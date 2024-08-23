# bootstrap interaction models tpr

using Random
Random.seed!(2023)

include("../code/environment.jl")

println("load model")

m = load_object("interaction models/base1_tie_2.jld2")

pbt = parametricbootstrap(10_000, m.tpr);

save_object("objects/base1_pb_10K_tpr_tie_2.jld2", pbt)
