# tpr_fpr_model_2_new.jl
# julia --threads=24 --project="." "honduras-css-paper/code/tpr_fpr_2_new.jl" > "output/tpr_fpr_2_new.jl.txt"

include("../../code/setup/environment.jl")

invlink = AutoInvLink();

using Random
Random.seed!(2024)

# via tpr_fpr_interaction_bimodel.jl
rg = load_object("interaction models/tpr_fpr_boot_data_rg.jld2")

K = 1_000
L = 1_000

#%%
otc = load_object(datapath * "outcomes_" * dte * ".jld2");
select!(otc, Not(ids.vc, :wave))
leftjoin!(rg, otc, on = :perceiver => :name)

#%%

######

rx = deepcopy(rg)

ŷs = load_object("interaction models/newstrap_stage1.jld2")

# actual second stage model
fx = @eval @formula(
    tpr ~ fpr + relation + degree + age + age^2 + man
)

m = fit(LinearModel, fx, rx)

# rxr = @chain rx begin
#     groupby(:perceiver)
#     combine([r => mean for r in [:tpr, :fpr, :j]]...; renamecols = false)
# end
# rxr.j_stand = (rxr.j .- minimum(rxr.j)) ./ (maximum(rxr.j) - minimum(rxr.j))
# rxr.j_color = [(berlin[x], 0.2) for x in rxr.j_stand];

# scatter(rxr.fpr, rxr.tpr; color = :transparent, strokewidth = 1, strokecolor = rxr.j_color)

# bootstrap version of second stage model
fx_k = @eval @formula(
    tpr ~ fpr_k + relation + degree + age + age^2 + man
)

fx_l = @eval @formula(
    tpr_l ~ fpr + relation + degree + age + age^2 + man
)

@inline fitfunc(fx, dat) = fit(LinearModel, fx, dat)

rx[!, :fpr_k] .= NaN;
rx.tpr_l .= NaN;

nth = Threads.nthreads()

K = 1_000
L = 1_000

nβ = length(coef(m))
# preallocate vectors of β coefficients
τ = [fill(NaN, nβ) for k in eachindex(1:(K*L))];
τ = reshape(τ, L, K);
mt = Vector{RegressionModel}(undef, nth)
# preallocate for predicted values (at each k)
ysim = [fill(NaN, nrow(rx)) for _ in eachindex(1:K)]

@time newstrap2_lm!(
    τ, rx, ŷs, mt, ysim, K, L, fitfunc, :fpr, fx_k, fx_l, :tpr_l
)

save_object("interaction models/tpr_fpr_τ.jld2", τ)

# τ = load_object("interaction models/" * string(rte) *"_τ.jld2")

# τt = [vec(r) for r in eachrow(reduce(hcat, τ))]
# vcn = varcov(τt);

# hcat(coef(m), mean.(τt))

# m_c = coeftable(m) |> DataFrame;
# m_c[!, "Std. Error Adj."] = sqrt.(diag(vcn));

# m_c[!, "Pr(>|z|) Adj."] = pvalue.(m_c[!, "Coef."], m_c[!, "Std. Error Adj."])

# m_c[!, "Lower 95% Adj."] .= NaN
# m_c[!, "Upper 95% Adj."] .= NaN

# for (i, (e1, e2)) in (enumerate∘zip)(m_c[!, "Coef."], m_c[!, "Std. Error Adj."])
#     m_c[i, "Lower 95% Adj."], m_c[i, "Upper 95% Adj."] = ci(e1, e2)
# end

# m_c
