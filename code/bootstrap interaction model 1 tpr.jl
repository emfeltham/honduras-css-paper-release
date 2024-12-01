# bootstrap interaction models
# ~/.juliaup/bin/julia --threads=60 "--sysimage=JuliaSysimage_plot_mod.so" --project="." "honduras-css-paper/code/bootstrap interaction model 1 tpr.jl" > "output_mi1_pb_tpr.txt"

using Random
Random.seed!(2023)

include("../../code/setup/environment.jl")

println("load model")

m = load_object("interaction models/interaction_1.jld2")

pbt = parametricbootstrap(10_000, m.tpr); 

save_object("interaction models/interaction_1_pb_10K_tpr.jld2", pbt)
