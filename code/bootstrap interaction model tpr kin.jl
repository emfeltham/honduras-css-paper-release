# bootstrap interaction models
# julia --threads=32 --project="." "honduras-css-paper/code/bootstrap interaction model tpr kin.jl" > "output_kin_interaction_pb_tpr.txt"

using Random
Random.seed!(2023)

include("../../code/setup/environment.jl")

println("load model")

m = load_object("interaction models/interaction_kin_age2.jld2")

pbt = parametricbootstrap(10_000, m.tpr); 

save_object("interaction models/interaction_kin_pb_10K_tpr.jld2", pbt)
