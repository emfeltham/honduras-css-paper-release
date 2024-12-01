# bootstrap interaction models
# julia --threads=28 --project="." "honduras-css-paper/code/bootstrap interaction model fpr kin.jl" > "output_kin_interaction_pb_fpr.txt"

using Random
Random.seed!(2023)

include("../../code/setup/environment.jl")

println("load model")

m = load_object("interaction models/interaction_kin_age2.jld2")

pb = parametricbootstrap(10_000, m.fpr); 

save_object("interaction models/interaction_kin_pb_10K_fpr.jld2", pb)
