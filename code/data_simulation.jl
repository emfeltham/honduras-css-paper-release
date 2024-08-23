# data_simulation.jl

include("analysis_preamble.jl")

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

# separate data frames for models of TPR and FPR
sf = (tpr = DataFrame(), fpr = DataFrame());

for x in [
    :response, :kin431, :age, :man, :dists_p_notinf, :dists_p
]
    sf.tpr[!, x] = rand(dats.tpr[!, x], 2_000)
end

sf.tpr.village_code = categorical(reduce(vcat, [fill(i, 250) for i in 1:8]));

for x in [
    :response, :kin431, :age, :man, :dists_p_notinf, :dists_p, :dists_a_notinf, :dists_a
]
    sf.fpr[!, x] = rand(dats.fpr[!, x], 2_000)
end

sf.fpr.village_code = categorical(reduce(vcat, [fill(i, 250) for i in 1:8]));

save_object("objects/simulated_data.jld2", sf);
