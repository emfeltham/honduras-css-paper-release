# base_models.jl
# julia --threads=20 --project="." "honduras-css-paper/code/base_models_kin_cat.jl" > "output_main_kin_cat.txt"

@show pwd()

include("../../code/setup/analysis preamble.jl")

# cf. kin accuracy to join in the kin ground truth categories

ck = load_object("interaction models/kintypes.jld2")
select!(ck, :tie, :kintype, :wave)
ckr = @chain ck begin
    groupby(:tie)
    combine(:kintype => Ref∘unique => :kintype)
end

ckr.kintype = [x[1] for x in ckr.kintype];

cr.tie = [Set([a, b]) for (a,b) in zip(cr.alter1, cr.alter2)];
leftjoin!(cr, ckr, on = :tie)
sunique(cr.kintype)
replace!(cr.kintype, missing => "None")
cr.kintype = categorical(cr.kintype);

prds = [
    :response,
    :kintype,
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

mkc1_base = let dats = dats;
    
    trms = @formula(
        y ~ kintype + relation + degree +
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
        kintype & relation +
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

save_object("interaction models/main_kincat.jld2", mkc1_base)

# %%
#=
bpd_kincat = biplotdata(
    mkc1_base, dats, :kintype;
    pbs = nothing, invlink, iters, varname = "Kin type",
    type, transforms,
);

@subset!(bpd_kincat.margins, .!:kin431)

fg_kincat = let m = mkc1_base, bpd = bpd_kincat
    fg = Figure();
    l = fg[1,1] = GridLayout()
    biplot!(
        l,
        bpd;
        jstat = false,
        ellipse = false,
        markeropacity = 1,
        kinlegend = false,
        xticklabelrotation = π/8
    )
    resize_to_layout!(fg)
    resize!(fg, 900, 400)
    fg
end

figure_export(
    "new_report/kin_category.svg",
    fg_kincat,
    save;
    caption = "The effect of kin category.",
)
=#
