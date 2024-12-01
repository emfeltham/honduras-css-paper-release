# bootstrap interaction models
# ~/.juliaup/bin/julia --threads=60 "--sysimage=JuliaSysimage_plot_mod.so" --project="." "honduras-css-paper/code/bootstrap interaction model 1 fpr.jl" > "output_mi1_pb_fpr.txt"

using Random
Random.seed!(2023)

include("../../code/setup/environment.jl")

println("load model")

m = load_object("interaction models/interaction_1.jld2")

pbf = parametricbootstrap(10_000, m.fpr);

save_object("interaction models/interaction_1_pb_10K_fpr.jld2", pbf)
