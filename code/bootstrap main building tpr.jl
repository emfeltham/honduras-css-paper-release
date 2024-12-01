# bootstrap interaction models
# julia --threads=20 --project="." "honduras-css-paper/code/bootstrap main building tpr.jl" > "output_pb_tpr.txt"

using Random
Random.seed!(2023)

include("../../code/setup/environment.jl")

println("load model")

m = load_object("interaction models/main_model_same_building.jld2")

pbt = parametricbootstrap(1_000, m.tpr); 

save_object("interaction models/main_model_same_building_pb_10K_tpr.jld2", pbt)
