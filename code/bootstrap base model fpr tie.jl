# bootstrap interaction models
# julia --threads=32 --project="." "honduras-css-paper/code/bootstrap base model fpr tie.jl" > "output_m1_pb_fpr_tie_2.txt"

using Random
Random.seed!(2023)

include("../../code/setup/environment.jl")

println("load model")

m = load_object("interaction models/base1_tie_2.jld2")

pbf = parametricbootstrap(1_000, m.fpr);

save_object("interaction models/base1_pb_1K_fpr_tie_2.jld2", pbf)
