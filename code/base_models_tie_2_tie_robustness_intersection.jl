# base_models.jl
# julia --threads=32 --project="." "honduras-css-paper/code/base_models_tie_2_tie_robustness.jl" > "output_m1_base_tie_robustness.txt"

#=
Conduct two additional analyses to showcase the robustness of the results w.r.t. to informant accuracy.

1. intersection: only ties nominated at all waves, stable ties
2. union: ties nominated at _any_ wave, sensitivity to recall failure
=#

# nomination in any wave

include("../../code/setup/analysis preamble.jl")

# intersection of waves

gt = load_object("clean_data/ground_truth_2023-11-20.jld2")

gt.socio_all = missings(Bool, nrow(gt));

for (i, (a, b)) in (enumerate∘zip)(gt.socio4, gt.socio3)
    gt.socio_all[i] = if ismissing(b)
        a
    else
        a & b
    end
end

@chain gt begin
    groupby([:socio4, :socio_all])
    combine(nrow => :n)
end

# %%

leftjoin!(
    cr,
    select(gt, [:perceiver, :relation, :alter1, :alter2, :socio_all]),
    on = [:perceiver, :relation, :alter1, :alter2]
);

# %%

crs = let
    crt = @subset(cr, $:socio_all);
    # crf = @subset(cr, .!:socio_all);
    bidata(crt, DataFrame())
end

#=
no FPR for this, since we only restrict the number of TPR ties
we make it harder to be a true tie
but we still shouldn't count those ties that don't meet the stricter criterion
as false
=#

prds = [
    :response,
    :kin431, :relation,
    :age, :man,
    :educated,
    :degree,
    :dists_p_notinf, :dists_p,
    :man_a,
    :age_mean_a,
    :age_diff_a,
    :religion_c,
    :religion_c_a,
    :isindigenous,
    :isindigenous_a,
    :degree_mean_a,
    :degree_diff_a,
    :wealth_d1_4, 
    :wealth_d1_4_mean_a,
    :wealth_d1_4_diff_a,
    :educated_a
];

dats = let
    crt2 = dropmissing(crs.tpr, prds);
    #crf2 = dropmissing(crs.fpr, prds);

    sort!(crt2, [:perceiver, :order]);
    # sort!(crf2, [:perceiver, :order]);
    bidata(crt2, DataFrame())
end;

println("model start")

m1 = let dats = dats;
    
    trms = @formula(
        y ~ kin431 + relation + degree +
        man + age + age^2 + educated +
        religion_c +
        wealth_d1_4 +
        coffee_cultivation +
        isindigenous +
        educated_a + # + educated&educated_a +
        man_a + man&man_a +
        isindigenous_a + isindigenous_a&isindigenous +
        religion_c_a + religion_c&religion_c_a +
        degree_mean_a + degree_diff_a +
        degree & degree_mean_a +
        age_mean_a + age_diff_a +
        age & age_mean_a +
        wealth_d1_4_mean_a +
        wealth_d1_4 & wealth_d1_4_mean_a +
        wealth_d1_4_diff_a +
        kin431 & relation +
        dists_p_notinf +
        dists_p_notinf & dists_p
    );
    trms = trms.rhs

    re = (ConstantTerm(1) | term(:village_code)) + (ConstantTerm(1) | term(:perceiver))
    fx = vcat(trms..., re...)
    fx = term(:response) ~ reduce(+, fx)
    
    faketerms = term(:dists_a_notinf) + InteractionTerm(term.((:dists_a_notinf, :dists_a)))

    fx2 = Term(:response) ~ fx.rhs + faketerms;

    x = fit(
        MixedModel, fx, dats[:tpr], Binomial(), LogitLink(); fast = false
    )
end

println("model finished")

save_object("interaction models/base1_tie_2_tie_robustness_inter.jld2", m1)
