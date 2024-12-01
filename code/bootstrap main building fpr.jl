# bootstrap interaction models
# julia --threads=22 --project="." "honduras-css-paper/code/bootstrap main building fpr.jl" > "output_pb_fpr.txt"

using Random
Random.seed!(2023)

include("../../code/setup/environment.jl")

println("load model")

m = load_object("interaction models/main_model_same_building.jld2")

pbf = parametricbootstrap(1_000, m.fpr);

save_object("interaction models/main_model_same_building_pb_10K_fpr.jld2", pbf)
