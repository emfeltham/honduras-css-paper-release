# tpr_fpr_2_assess.jl

include("../../code/setup/environment.jl")

#%%
invlink = AutoInvLink()

#%%
# via tpr_fpr_interaction_bimodel.jl
rg = load_object("interaction models/tpr_fpr_boot_data_rg.jld2")

#%%

fx = @eval @formula(
    tpr ~ fpr + relation + degree + age + age^2 + man
)

m = fit(LinearModel, fx, rg)

τ = load_object("interaction models/tpr_fpr_τ.jld2")

vcmat = varcov([vec(r) for r in eachrow(reduce(hcat, τ))])

#%%
rgef = let yvar = :tpr, df = rg
    r = :fpr
    mn, mx = round.(extrema(df[!, r]); digits = 2)
    ed = Dict(r => mn:0.01:mx, :age => mean(df.age))
    rg = referencegrid(df, ed)
    effects!(rg, m, vcmat; invlink = identity)
    rg.ci = ci.(rg[!, yvar], rg[!, :err])
    rg.lower = [first(x) for x in rg.ci]
    rg.upper = [last(x) for x in rg.ci]
    rg1 = deepcopy(rg)
end

yvar = :tpr
xf = DataFrame()
let rg = rgef, r = :fpr
    x = select(rg, r, yvar, :err)
    @subset!(x, $r .∈ Ref(extrema(rg[!, r])))
    sort!(x, r; rev = true)
    x2 = empairs(x, eff_col = yvar, err_col = :err)
    x2.ci = ci.(x2[!, yvar], x2.err)
    x2
    x2.rate .= string(r)
    rename!(x2, r => :Contrast)
    append!(xf, x2)
end

xf[!, "Pr(>|z|)"] = pvalue.(xf[!, yvar], xf.err);

rgr = @chain rg begin
    groupby(:perceiver)
    combine([x => mean => x for x in [:tpr, :fpr, :j]]...)
end

save_object("interaction models/rates_data_2.jld2", [rgef, rgr])

# create adjusted coefficient table to pass into the regression table
adj_cft = adjustedcoeftable(m, vcmat; overwrite = true)

save_object("rates_regtable_data.jld2", [m, adj_cft])
