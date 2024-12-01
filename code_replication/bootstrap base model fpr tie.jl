# bootstrap interaction models fpr

using Random
Random.seed!(2023)

include("../code/environment.jl")

println("load model")

m = load_object("interaction models/base1_tie_2.jld2")

pbf = parametricbootstrap(10_000, m.fpr);

save_object("objects/base1_pb_10K_fpr_tie_2.jld2", pbf)
