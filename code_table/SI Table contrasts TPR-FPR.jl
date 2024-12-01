# SI Table contrasts TPR-FPR.jl

include("../../code/setup/environment.jl")

ef, rgb_r = load_object("objects/rates_data_2.jld2");

x1, a = findmin(ef_.fpr)
x2, b = findmax(ef_.fpr)

xf = ef_[[a, b], :]

select!(xf, [:fpr, :tpr, :err])
xf = empairs(xf, eff_col = :tpr)
xf.ci = ci.(xf.tpr, xf.err)
xf.p = pvalue.(xf.tpr, xf.err)
xf.lower .= xf.ci[1][1]
xf.upper .= xf.ci[1][2]

# Don't bother with a table: just report this one row in the text