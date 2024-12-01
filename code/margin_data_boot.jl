# margin data
# julia --threads=20 --project="." "honduras-css-paper/code/margin data.jl" > "output/margin data.jl.txt"

include("../../code/setup/analysis preamble.jl")

margindict = load_object("interaction models/base1_tie2_margins_bs.jld2")

ej = Float64[]
ejb = Float64[]
for (k, x) in margindict
    @show k
    rg = x.rg
    if "err_j" ∈ names(rg)
        push!(ej, mean(rg.err_j))
        push!(ejb, mean(rg.err_j_bs))
    end
end

ej ./ ejb
mean(ejb - ej)
# bootstrap are slightly larger

margindict[:age].rg

for (k, x) in margindict
    @show k
    rg = x.rg
    if "err_j" ∈ names(rg)
        select!(rg, Not(:err_j))
        rename!(rg, :err_j_bs => :err_j)
        rg.ci_j = ci.(rg.j, rg.err_j)
        rg.Σ = cov.(rg.bivar_bs) # (tpr, fpr)
        select!(rg, Not(:bivar_bs))
    end
end

save_object(
    "honduras-css-paper/objects/base1_tie2_margins_bs_out.jld2",
    margindict
)
