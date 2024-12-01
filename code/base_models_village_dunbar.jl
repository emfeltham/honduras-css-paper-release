# base_models_village_dunbar.jl
# julia --threads=12 --project="." "honduras-css-paper/code/base_models_village_dunbar.jl" > "output_dunbar.txt"

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

cr.dunbar = cr.population .> 150;

dats = let
    crt2 = dropmissing(@subset(cr, $socio), prds);
    crf2 = dropmissing(@subset(cr, .!$socio), prds);

    sort!(crt2, [:perceiver, :order]);
    sort!(crf2, [:perceiver, :order]);
    bidata(crt2, crf2)
end;

println("model start")

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
    tpr = parametricbootstrap(500, m2.tpr),
    fpr = parametricbootstrap(500, m2.fpr)
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

    fast = false
    emodel(
        fit(MixedModel, fx, dats[:tpr], Binomial(), LogitLink(); fast),
        fit(MixedModel, fx2, dats[:fpr], Binomial(), LogitLink(); fast)
    )
end

save_object("interaction models/main_village_added_dunbar_2.jld2", m2)

pbs3 = (
    tpr = parametricbootstrap(500, m3.tpr),
    fpr = parametricbootstrap(500, m3.fpr)
);

save_object("interaction models/main_village_added_dunbar_2_bootstrap.jld2", pbs3)

println("model finished")

