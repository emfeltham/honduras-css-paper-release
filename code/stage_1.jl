# stage_1.jl
# julia --threads=32 --project="." "honduras-css-paper/code/stage_1.jl" > "output/stage_1.jl.txt"

# first stage stage for tpr-fpr and riddle models
# keep separate relationships (to adjust for degree)

include("../../code/setup/environment.jl")

bimodel = load_object("interaction models/base1_tie_2.jld2")

pbs = (
    tpr = load_object("interaction models/base1_pb_10K_tpr_tie_2.jld2"),
    fpr = load_object("interaction models/base1_pb_10K_fpr_tie_2.jld2")
);

# via tpr_fpr_interaction_bimodel.jl
rg = load_object("interaction models/tpr_fpr_boot_data_rg.jld2")

# K = length(pbs.tpr.θ);
K = 1_000

Θ = let
    A = @chain pbs.tpr.β begin
        DataFrame()
        groupby(:iter)
        combine([x => Ref => x for x in [:coefname, :β]]...)
    end

    A.θ = pbs.tpr.θ

    B = @chain pbs.fpr.β begin
        DataFrame()
        groupby(:iter)
        combine([x => Ref => x for x in [:coefname, :β]]...)
    end

    B.θ = pbs.fpr.θ

    (tpr = A, fpr = B)
end

# check that order is always the same across iters
@assert (length∘unique)(Θ.tpr.coefname) .== 1

#%%

bm2 = deepcopy(bimodel);
rx = deepcopy(rg)
invlink = logistic

ŷs = (
    tpr = [fill(NaN, nrow(rx)) for i in eachindex(1:K)],
    fpr = [fill(NaN, nrow(rx)) for i in eachindex(1:K)]
)

@time newstrap!(ŷs, rx, bm2, Θ, K, invlink)

save_object("interaction models/newstrap_stage1.jld2", ŷs)
