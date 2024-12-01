# education interaction.jl

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
vk = :educated;
v = :educated_a;

# %%
distmean_p = let
    ds = [dats[x][!, :dists_p][dats[x][!, :dists_p] .!= 0] for x in rates];
    mean(reduce(vcat, ds));
end;

distmean_a = let
    ds = [dats[x][!, :dists_a][dats[x][!, :dists_a] .!= 0] for x in rates];
    mean(reduce(vcat, ds));
end;

dict = Dict(
    :kin431 => false,
    :dists_p => distmean_p,
    :age => (mean∘skipmissing)(cr.age),
    :educated => (collect∘skipmissing∘unique)(cr.educated),
    :educated_a => (collect∘skipmissing∘unique)(cr.educated_a),
);

dicts = (tpr = deepcopy(dict), fpr = deepcopy(dict));
dicts.fpr[:dists_a] = distmean_a;
dict[:dists_a] = distmean_a;

rg = referencegrid(dats.tpr, dict) # empty referencegrid
estimaterates!(rg, bimodel; iters = 20_000)
ci_rates!(rg)

# do these once
bm = deepcopy(bimodel)
βset = pbs_process(pbs)
pbs = nothing

K = 10_000

ses, bv = j_calculations_pb!(rg, bm, βset, invlink, K)
rg.err_j = ses
rg.bivar = eachrow(bv)
rg.ci = ci.(rg.j, rg.err_j)

rg2 = sort(rg, :educated)

fg = Figure();
ax = Axis(fg[1,1]);
rg2.lc = levelcode.(rg2.educated_a);
rgg = groupby(rg2, :educated)

for (k,v) in pairs(rgg)
    lines!(ax, v.lc, v.j)
end

fg

##

# rg = referencegrid(dats.tpr, dicts.tpr);
# apply_referencegrids!(bimodel, rg; invlink = logistic);
# ci!(rg)

# rgc = combinerefgrid(rg, [vk, v], :response; rates = rates, kin = kin);
# j_calculations!(rgc, 10_000)

# save_object("wealth_interaction.jld2", rgc);
