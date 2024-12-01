# rates_assess_2.jl
# updated model with quadratic term

include("../../code/setup/environment.jl")

#%%
invlink = AutoInvLink()

#%%
# via tpr_fpr_interaction_bimodel.jl
rg = load_object("interaction models/tpr_fpr_boot_data_rg.jld2")

rgr = @chain rg begin
    groupby(:perceiver)
    combine([x => mean => x for x in [:tpr, :fpr, :j, :degree, :age]]...)
end

#%% fit the stage-2 models

# check against m2
m1 = let
    fx = @eval @formula(
        tpr ~ fpr + fpr^2
    )

    fit(LinearModel, fx, rg)
end

# we use this model
m2 = let
    fx = @eval @formula(
        tpr ~ fpr + fpr^2 + relation + degree + age + age^2 + man
    )

    fit(LinearModel, fx, rg)
end

ms = [m1, m2];

nobs.(ms)
bic.(ms)
vif.(ms)

#%% load bootstrapped variance-covariance matrix
vcmat = let
    τ = load_object("interaction models/tpr_fpr_τ_new.jld2")
    varcov([vec(r) for r in eachrow(reduce(hcat, τ))])
end

# use m2 as the model, m
m = m2
yvar = :tpr
xvar = :fpr

#%% marginal effects
rgef = let df = rg
    mn, mx = round.(extrema(df[!, xvar]); digits = 2)
    ed = Dict(xvar => mn:0.001:mx, :age => mean(df.age))
    rg = referencegrid(df, ed)
    effects!(rg, m, vcmat; invlink = identity) # calculate effects with external vcov matrix
    rg.ci = ci.(rg[!, yvar], rg[!, :err])
    rg.lower = [first(x) for x in rg.ci]
    rg.upper = [last(x) for x in rg.ci]
    rg1 = deepcopy(rg)
end

sort!(rgef, :fpr)

#%%

#%% contrasts
rgef.j = rgef.tpr - rgef.fpr
rgef.ppb = rgef.tpr + rgef.fpr
jmaxrow = @subset(rgef, :j .>= maximum(rgef.j));
jminrow = @subset(rgef, :j .<= minimum(rgef.j));
ppbrow = @subset(rgef, :ppb .<= 1.001, :ppb .>= 0.999);

ex = reduce(vcat, [jmaxrow, jminrow, ppbrow])
sort!(ex, :j)
select!(ex, Not([:ci, :lower, :upper, :ppb, :fpr, :tpr, :age]))

ex.pval = pvalue.(ex.j, ex.err)

ex.type = ["jmin", "ppb=1", "jmax"]
pvalue.(ex.j, ex.err)
ci.(ex.j, ex.err)

(0.417, 0.434)
6.7, 11.7

# change in tpr over change in fpr
a = (jmaxrow[1, :tpr] - jminrow[1, :tpr])
b = (jmaxrow[1, :fpr] - jminrow[1, :fpr])

a/b
b/a

# use tpr error
exp = empairs(ex, eff_col = :j, err_col = :err)
exp.p = pvalue.(exp.j, exp.err)
exp.ci = ci.(exp.j, exp.err)

#%% PPB distribution
# fg2 = Figure()
# let fg = fg2
#     ax = Axis(fg[1,1], xlabel = "Positive predictive bias")
#     ppb = rgr.tpr+rgr.fpr
#     hist!(ax, ppb)
#     vlines!(ax, mean(ppb), color = wc[2])
# end

# fg2

#%% contrast over range
xf = DataFrame();
let rg = rgef,
    x = select(rg, xvar, yvar, :err)
    @subset!(x, $xvar .∈ Ref(extrema(rg[!, xvar])))
    sort!(x, xvar; rev = true)
    x2 = empairs(x, eff_col = yvar, err_col = :err)
    x2.ci = ci.(x2[!, yvar], x2.err)
    x2
    x2.rate .= string(xvar)
    rename!(x2, xvar => :Contrast)
    append!(xf, x2)
end

xf[!, "Pr(>|z|)"] = pvalue.(xf[!, yvar], xf.err);

save_object("interaction models/rates_data_2_new.jld2", [rgef, rgr])

# create adjusted coefficient table to pass into the regression table
adj_cft = adjustedcoeftable(m, vcmat; overwrite = true)

save_object("rates_regtable_data_new.jld2", [m, adj_cft])
