# wealth interaction.jl

include("../../code/setup/analysis preamble.jl");
dataloc = "honduras-css-paper/objects/";

bimodel, pbs = let
	m = load_object(dataloc * "base1_tie_2.jld2")

    pbs = (
        tpr = load_object(dataloc * "base1_pb_10K_tpr_tie_2.jld2"),
        fpr = load_object(dataloc * "base1_pb_10K_fpr_tie_2.jld2")
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
vk = :wealth_d1_4;
v = :wealth_d1_4_mean_a;

# %%
distmean_p = let
    ds = [dats[x][!, :dists_p][dats[x][!, :dists_p] .!= 0] for x in rates];
    mean(reduce(vcat, ds));
end;

distmean_a = let
    ds = [dats[x][!, :dists_a][dats[x][!, :dists_a] .!= 0] for x in rates];
    mean(reduce(vcat, ds));
end;

xd = 0:0.05:1

dict = Dict(
    :kin431 => false,
    :dists_p => distmean_p,
    :age => (mean∘skipmissing)(cr.age),
    :wealth_d1_4 => xd,
    :wealth_d1_4_mean_a => xd
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

invlink = logistic
ses, bv = j_calculations_pb!(rg, bm, βset, invlink, K)
rg.err_j = ses
rg.bivar = eachrow(bv)
rg.ci = ci.(rg.j, rg.err_j)

#%%
save_object(dataloc * "wealth_interaction.jld2", rg);
