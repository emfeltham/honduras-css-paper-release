# rates_2.jl
# julia --threads=24 --project="." "honduras-css-paper/code/tpr_fpr_2_new.jl" > "output/tpr_fpr_2_new.jl.txt"

include("../code/environment.jl")

invlink = AutoInvLink();

using Random
Random.seed!(2024)

# via tpr_fpr_interaction_bimodel.jl
rg = load_object("interaction models/tpr_fpr_boot_data_rg.jld2")

K = 1_000
L = 1_000

#%%

rx = deepcopy(rg)

ŷs = load_object("interaction models/newstrap_stage1.jld2")

# actual second stage model
fx = @eval @formula(
    tpr ~ fpr + relation + degree + age + age^2 + man
)

m = fit(LinearModel, fx, rx)

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
