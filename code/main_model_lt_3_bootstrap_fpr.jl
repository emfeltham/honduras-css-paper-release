# bootstrap interaction models
# julia --threads=16 --project="." "honduras-css-paper/code/bootstrap model lt 2 fpr.jl" > "output pb fpr lt3.txt"

using Random
Random.seed!(2023)

include("../../code/setup/environment.jl")

println("load model")

m = load_object("interaction models/main_model_limited_dist_3a_fpr.jld2");

pbf = parametricbootstrap(1_000, m); 

save_object("interaction models/main_model_limited_dist_3a pb 1K fpr.jld2", pbf)


# ndf4.dists = [Float64[] for _ in eachindex(ndf4.graph)];
# for (i, g) in enumerate(ndf4.graph)
#     dm = fill(Inf, nv(g), nv(g));
#     for v in 1:nv(g)
#         gdistances!(g, v, @views(dm[v, :]))
#     end
#     ds = ndf4.dists[i]
#     for i in 1:size(dm,1), j in 1:size(dm, 1)
#         if j > i
#             append!(ds, dm[j,i])
#         end
#     end
# end

# ndf4.dists = [(collect(sai(x)), sum(isinf.(x))) for x in ndf4.dists];
