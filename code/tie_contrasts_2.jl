# tie_contrasts.jl
# julia --threads=32 --project="." "honduras-css-paper/code/tie_contrasts_2.jl" > "output_tie_contrasts_2.txt"

using Random
Random.seed!(2023)

include("../../code/setup/analysis preamble.jl")

bimodel, pbs = let
	m = load_object("interaction models/base1_tie_2.jld2")

    pbs = (
        tpr = load_object("interaction models/base1_pb_10K_tpr_tie_2.jld2"),
        fpr = load_object("interaction models/base1_pb_10K_fpr_tie_2.jld2")
    )

	EModel(m.tpr, m.fpr), pbs
end

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
    :isindigenous_a,
    :degree_mean_a,
    :degree_diff_a,
    :wealth_d1_4, 
    :wealth_d1_4_mean_a,
    :wealth_d1_4_diff_a,
    :educated_a
];

dats = let
	crt = @subset cr $socio
    crf = @subset cr .!$socio
    dropmissing!(crt, prds);
    dropmissing!(crf, prds);

	sort!(crt, [:perceiver, :order])
	sort!(crf, [:perceiver, :order])
	bidata(crt, crf)
end;

#%%
emsd = Dict{Symbol, DataFrame}();
iters = 1_000;
invlink = logistic;

# let e = :wealth_d1_4_diff_a
#     additions = [e => sort([round.((extrema∘skipmissing)(cr[!, e]); digits = 3)...]; rev = true), kin => [false]]
#     ems = contrast_table(e, additions, dats, bimodel, pbs, iters, invlink);
#     rename!(ems, e => :contrast)
#     ems.variable .= string.(e)
#     emsd[e] = ems
# end;

# let e = :age_mean_a
#     additions = [e => sort([round.((extrema∘skipmissing)(cr[!, e]); digits = 3)...]; rev = true), kin => [false]]
#     ems = contrast_table(e, additions, dats, bimodel, pbs, iters, invlink);
#     rename!(ems, e => :contrast)
#     ems.variable .= string.(e)
#     emsd[e] = ems
# end;

let e = :age_diff_a
    additions = [e => sort([round.((extrema∘skipmissing)(cr[!, e]); digits = 3)...]; rev = true), kin => [false]]
    ems = contrast_table(e, additions, dats, bimodel, pbs, iters, invlink);
    rename!(ems, e => :contrast)
    ems.variable .= string.(e)
    emsd[e] = ems
end;

let e = :religion_c_a
    additions = [e => sort((sunique∘skipmissing)(cr[!, e]), rev = true), kin => [false]];
    ems = contrast_table(e, additions, dats, bimodel, pbs, iters, invlink);
    rename!(ems, e => :contrast)
    ems.variable .= string.(e)
    emsd[e] = ems
end;

save_object("interaction models/tie_contrasts_2.jld2", emsd);
