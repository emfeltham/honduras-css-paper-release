# base_models.jl
# julia --threads=32 --project="." "honduras-css-paper/code/main_model.jl" > "output_main_model.txt"

@show pwd()

include("../../code/setup/analysis preamble.jl")

println("data loaded")

prds = [
    :response,
    :kin431, :relation,
    :age, :man,
    :educated,
    :educated_a,
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
    :coffee_cultivation
];

dats = let
    crt2 = dropmissing(@subset(cr, $socio), prds);
    crf2 = dropmissing(@subset(cr, .!$socio), prds);

    sort!(crt2, [:perceiver, :order]);
    sort!(crf2, [:perceiver, :order]);
    bidata(crt2, crf2)
end;

(nrow(dats.tpr), nrow(dats.fpr))

println("model start")

m1 = let dats = dats, fast = true
    
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

    x = bifit(
        MixedModel, fx, dats[:tpr], dats[:fpr];
        dstr = Binomial(), lnk = LogitLink(),
        fx2 = fx2, fast
    )
end

# ms = [m1.tpr, m2.tpr, m1_i.tpr, m1.fpr, m2.fpr, m1_i.fpr];
# regtablet(
#     ms,
#     "check_models";
#     modeltitles = ["1 tpr", "2 tpr", "3 tpr", "1 fpr", "2 fpr", "3 fpr"]
# )

println("model finished")

# save_object("interaction models/base1_tie_2.jld2", m1)
save_object("interaction models/main_model.jld2", m1)

# mainmodel = load_object("interaction models/main_model.jld2")

# (nobs(mainmodel.tpr), nobs(mainmodel.fpr))

# bimodel = load_object("interaction models/base1_tie_2.jld2")

# (nobs(bimodel.tpr), nobs(bimodel.fpr))

# sort(coefnames(bimodel.tpr)) == sort(coefnames(mainmodel.tpr))

# hcat(sort(coefnames(bimodel.tpr)), sort(coefnames(mainmodel.tpr)))