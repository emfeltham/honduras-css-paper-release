# rates_1.jl
# julia --threads=32 --project="." "honduras-css-paper/code/tpr_fpr_model_1.jl" > "output/tpr_fpr_model_1.jl.txt"

include("../code/environment.jl")

bimodel = load_object("interaction models/base1_tie_2.jld2")

pbs = (
    tpr = load_object("interaction models/base1_pb_10K_tpr_tie_2.jld2"),
    fpr = load_object("interaction models/base1_pb_10K_fpr_tie_2.jld2")
);

# via tpr_fpr_interaction_bimodel.jl
rg = load_object("interaction models/tpr_fpr_boot_data_rg.jld2")

Θ = pbs_process(pbs)

# check that order is always the same across iters
@assert (length∘unique)(Θ.tpr.coefname) .== 1

#%%

bm2 = deepcopy(bimodel);
rx = deepcopy(rg)
invlink = logistic

K = 1_000

ŷs = (
    tpr = [fill(NaN, nrow(rx)) for i in eachindex(1:K)],
    fpr = [fill(NaN, nrow(rx)) for i in eachindex(1:K)]
)

@time newstrap!(ŷs, rx, bm2, Θ, K, invlink)

save_object("interaction models/newstrap_stage1.jld2", ŷs)
