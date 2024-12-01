# bootstrap interaction models
# julia --threads=32 --project="." "honduras-css-paper/code/bootstrap base model tpr.jl" > "output_main_pb_tpr.txt"

using Random
Random.seed!(2023)

include("../../code/setup/environment.jl")

println("load model")

# m = load_object("interaction models/main.jld2")
# m = load_object("interaction models/main_village_added.jld2");
m = load_object("interaction models/base1_2.jld2")

pbt = parametricbootstrap(1_000, m.tpr);

save_object("interaction models/main_2_pb_1K_tpr.jld2", pbt)
