# julia --threads=18 --project="." "honduras-css-paper/code/bootstrap_kinship_model_fpr.jl" > "output_kinship_pb_fpr.txt"

using Random
Random.seed!(2023)

include("../../code/setup/environment.jl")

bm = load_object("interaction models/base1_tie_2_kinship.jld2");

K = 10_000

pb = parametricbootstrap(K, bm.fpr);

save_object("interaction models/kinship_pbs_fpr.jld2", pb)
