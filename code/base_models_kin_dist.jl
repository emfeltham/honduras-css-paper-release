# base_models.jl
# julia --threads=28 --project="." "honduras-css-paper/code/base_models_kin_dist.jl" > "output_main_kin_dist.txt"

@show pwd()

include("../../code/setup/analysis preamble.jl")

println("data loaded")

prds = [
    :are_related_dists_a_notinf, :are_related_dists_a,
    :response,
    :relation,
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
    crt2 = @subset(cr, $socio);
    crf2 = @subset(cr, .!$socio);
    dropmissing!(crt2, prds)
    dropmissing!(crf2, prds)

    sort!(crt2, [:perceiver, :order]);
    sort!(crf2, [:perceiver, :order]);
    bidata(crt2, crf2)
end;

println("model start")

mkd1_base = let dats = dats;
    
    trms = @formula(
        y ~ 
        are_related_dists_a_notinf +
        (are_related_dists_a & are_related_dists_a_notinf) +
        relation + degree +
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
        (are_related_dists_a & are_related_dists_a_notinf) & relation +
        are_related_dists_a_notinf & relation +
        dists_p_notinf +
        dists_p_notinf & dists_p
    );
    trms = trms.rhs
    
    re = (ConstantTerm(1) | term(:village_code)) + (ConstantTerm(1) | term(:perceiver))
    fx = vcat(trms..., re...)
    fx = term(:response) ~ reduce(+, fx)
    
    faketerms = term(:dists_a_notinf) + InteractionTerm(term.((:dists_a_notinf, :dists_a)))
    # interaction fails when we interact with either of last two

    fx2 = Term(:response) ~ fx.rhs + faketerms;

    fx2 = if !isnothing(fx2)
        fx2
    else
        fx
    end

    fast = false
    emodel(
        fit(MixedModel, fx, dats[:tpr], Binomial(), LogitLink(); fast),
        fit(MixedModel, fx2, dats[:fpr], Binomial(), LogitLink(); fast)
    )
end

println("model finished")

save_object("interaction models/main_kin_dist.jld2", mkd1_base)

#=
# %%
invlink = logistic;

mrg_ka = marg_dist_data(
    :are_related_dists_a_notinf, :are_related_dists_a, "Kin distance",
    mkd1_base, dats, invlink; pbs = nothing, transforms
);


fg_kin_dist = let # kinship
    fg = Figure();
    l = fg[1,1] = GridLayout()
    l1 = l[1,1] = GridLayout()
    l2 = l[1,2] = GridLayout()
    distance_roc!(l1, mrg_ka; ellipse = false, fpronly = false)
    distance_eff!(l2, mrg_ka; jstat = false, fpronly = false, legend = true)
    
    resize_to_layout!(fg)
    resize!(fg, 900, 400)
    fg
end

figure_export(
    "new_report/kin_distance.svg",
    fg_kin_dist,
    save;
    caption = "The effect of distance in the kin network.",
)

# %%

bpd_man_b = biplotdata(
    mk1_base, dats, :man;
    pbs = nothing, invlink, iters, varname = "Gender",
    type, transforms,
)

fg_gender_b = let m = mk1_base, bpd = bpd_man_b
    fg = Figure();
    l = fg[1,1] = GridLayout()
    biplot!(
        l,
        bpd;
        jstat = false,
        ellipse = false,
        markeropacity = 1,
    )
    resize_to_layout!(fg)
    resize!(fg, 900, 400)
    fg
end

# %%

bpd_degree_b = biplotdata(
    mk1_base, dats, :degree;
    pbs = nothing, invlink, iters, varname = "Degree",
    type, transforms,
);

fg_degree_b = let m = mk1_base, bpd = bpd_degree_b
    fg = Figure();
    l = fg[1,1] = GridLayout()
    biplot!(
        l,
        bpd;
        jstat = false,
        ellipse = false,
        markeropacity = 1,
    )
    resize_to_layout!(fg)
    resize!(fg, 900, 400)
    fg
end
=#