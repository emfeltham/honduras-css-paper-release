# bootstrap interaction models
# julia --threads=12 --project="." "honduras-css-paper/code/bootstrap model lt 2 tpr.jl" > "output pb tpr lt2.txt"

using Random
Random.seed!(2023)

include("../../code/setup/environment.jl")

println("load model")

m = load_object("interaction models/main_model_limited_dist_3.jld2");

pbt = parametricbootstrap(1_000, m.tpr); 

save_object("interaction models/main_model_limited_dist_3 pb 1K tpr.jld2", pbt)
