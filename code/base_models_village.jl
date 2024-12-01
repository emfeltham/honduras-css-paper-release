# base_models.jl
# julia --threads=32 --project="." "honduras-css-paper/code/base_models.jl" > "output_main.txt"

@show pwd()

include("../../code/setup/analysis preamble.jl")

println("data loaded")

prds = [
    :response,
    :kin431, :relation,
    :age, :man,
    :educated,
    :degree,
    :wealth_d1_4,
    :coffee_cultivation,
    :dists_p_notinf, :dists_p,
];

dats = let
    crt2 = dropmissing(@subset(cr, $socio), prds);
    crf2 = dropmissing(@subset(cr, .!$socio), prds);

    sort!(crt2, [:perceiver, :order]);
    sort!(crf2, [:perceiver, :order]);
    bidata(crt2, crf2)
end;

println("model start")

# m1 = let dats = dats;
#     trms = @formula(y ~
#         kin431 + relation + degree +
#         man + age + age^2 + educated +
#         wealth_d1_4 +
#         coffee_cultivation + 
#         isolation +
#         population +
#         dists_p_notinf +
#         dists_p_notinf&dists_p
#     );
#     trms = trms.rhs
    
#     re = (ConstantTerm(1) | term(:village_code)) + (ConstantTerm(1) | term(:perceiver))
#     fx = vcat(trms..., re...)
#     fx = term(:response) ~ reduce(+, fx)
    
#     faketerms = term(:dists_a_notinf) + InteractionTerm(term.((:dists_a_notinf, :dists_a)))
#     # interaction fails when we interact with either of last two

#     fx2 = Term(:response) ~ fx.rhs + faketerms;

#     fx2 = if !isnothing(fx2)
#         fx2
#     else
#         fx
#     end

#     fast = true
#     emodel(
#         fit(MixedModel, fx, dats[:tpr], Binomial(), LogitLink(); fast),
#         fit(MixedModel, fx2, dats[:fpr], Binomial(), LogitLink(); fast)
#     )
# end

dats.tpr.dunbar = dats.tpr.population .> 150
dats.fpr.dunbar = dats.fpr.population .> 150

# drop k to (i,j) distance
m2 = let dats = dats;
    fx = @formula(response ~
        kin431 + relation + dunbar + (1|village_code) + (1|perceiver)
    );

    fast = false
    emodel(
        fit(MixedModel, fx, dats[:tpr], Binomial(), LogitLink(); fast),
        fit(MixedModel, fx, dats[:fpr], Binomial(), LogitLink(); fast)
    )
end

save_object("interaction models/main_village_added_dunbar.jld2", m2)

pbs = (
    tpr = parametricbootstrap(1000, m2.tpr),
    fpr = parametricbootstrap(1000, m2.fpr)
);

save_object("interaction models/main_village_added_dunbar_bootstrap.jld2", pbs)

m3 = let dats = dats;
    fx = @formula(response ~
        kin431 + relation + dunbar +
        dists_p_notinf +
        dists_p_notinf & dists_p +
        (1|village_code) + (1|perceiver)
    );
    fx2 = @formula(response ~
        kin431 + relation + dunbar +
        dists_p_notinf +
        dists_p_notinf & dists_p +
        dists_a_notinf & dists_a +
        (1|village_code) + (1|perceiver)
    );

    fast = true
    emodel(
        fit(MixedModel, fx, dats[:tpr], Binomial(), LogitLink(); fast),
        fit(MixedModel, fx2, dats[:fpr], Binomial(), LogitLink(); fast)
    )
end

save_object("interaction models/main_village_added_dunbar_2.jld2", m2)

pbs = (
    tpr = parametricbootstrap(1000, m3.tpr),
    fpr = parametricbootstrap(1000, m3.fpr)
);

save_object("interaction models/main_village_added_dunbar_bootstrap_2.jld2", pbs)

println("model finished")

# save_object("interaction models/main_village_added.jld2", m1)

# m1 = load_object("interaction models/main_village_added.jld2")

#=
# %%
invlink = logistic;
iters = 100;
type = :normal;

effdict = usualeffects(dats, :kin431; kinvals = nothing)
refgrids = referencegrid(dats, effdict)
bf = deepcopy(refgrids[:fpr])
for r in [:tpr, :fpr, :j]
    bf[!, r] .= NaN
    bf[!, Symbol(string(r) * "_err")] .= NaN
end
bieffects!(bf, m1, invlink; rates)
bf.kin = categorical(replace(bf.kin431, true => "Yes", false => "No"))

fg_kin = let m = m1, bpd = bpd_kin # kinship
    fg = Figure();
    l = fg[1,1] = GridLayout()
    rocplot!(
        l, bf, vbl, "Kin"
    )
    resize_to_layout!(fg)
    #resize!(fg, 900, 400)
    fg
end

figure_export(
    "new_report/kin.svg",
    fg_kin,
    save;
    caption = "The effect of kin relatedness.",
)
=#
