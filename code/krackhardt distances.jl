# krackhardt distances.jl

include("../../code/setup/environment.jl")

using CSV

krd = CSV.read("/Users/emf/Downloads/ds1_Krackhardt.csv", DataFrame)

# filter to reports on first-degree relationships
krd_ = @subset krd (:i .== :k) .| (:j .== :k)

# Create a dictionary to store the graphs
k1 = @subset krd_ :relation .== "advice";
k2 = @subset krd_ :relation .== "friend";

gr = (advice = MetaGraph(k1, :i, :j), friend = MetaGraph(k2, :i, :j));

function distancematrix(g)
    ds = fill(typemax(Int), nv(g), nv(g));
    for i in eachindex(1:nv(g))
        gdistances!(g, i, @views(ds[:, i]))
    end
    return ds
end

ds = (advice = distancematrix(gr.advice), friend = distancematrix(gr.friend))

# check range of distances
extrema(ds.advice)
extrema(ds.friend)

mean(UpperTriangular(ds.advice)[UpperTriangular(ds.advice) .> 0])
mean(UpperTriangular(ds.friend)[UpperTriangular(ds.friend) .> 0])
