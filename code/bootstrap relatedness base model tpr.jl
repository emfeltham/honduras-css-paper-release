# bootstrap interaction models
# julia --threads=32 --project="." "honduras-css-paper/code/bootstrap relatedness base model tpr.jl" > "output_main_pb_fpr.txt"

using Random
Random.seed!(2023)

include("../../code/setup/environment.jl")

println("load model")

m = load_object("interaction models/main_kinship.jld2")

pbf = parametricbootstrap(1_000, m.fpr);

save_object("interaction models/main_relatedness_pb_1K_fpr.jld2", pbf)
