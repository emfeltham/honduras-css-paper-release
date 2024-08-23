# margin data
# julia --threads=20 --project="." "honduras-css-paper/code/margin data.jl" > "output/margin data.jl.txt"

include("../code/analysis_preamble.jl");

margindict = load_object("objects/base1_tie2_margins_bs.jld2");

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

save_object("objects/base1_tie2_margins_bs_out.jld2", margindict)
