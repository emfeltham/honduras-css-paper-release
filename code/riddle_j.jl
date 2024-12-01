# riddle_2_tpr.jl
# julia --threads=18 --project="." "honduras-css-paper/code/riddle_model_2_j.jl" > "output/riddle_model_2_j.jl.txt"

include("../../code/setup/environment.jl")

using Random
Random.seed!(2024)

rte = :j

# via tpr_fpr_interaction_bimodel.jl
rg = load_object("interaction models/tpr_fpr_boot_data_rg.jld2")

otc = load_object(datapath * "outcomes_" * dte * ".jld2");
select!(otc, Not(ids.vc, :wave))
leftjoin!(rg, otc, on = :perceiver => :name)
# non-treated individuals, random villages only
@subset!(rg, .!:resp_target, .!:friend_treatment)
rgx = stack(rg, riddles; variable_name = :riddle, value_name = :knows);
rgx.riddle = [split(x, "_")[1] for x in rgx.riddle];
rgx.riddle = categorical(rgx.riddle);
rgx.ix = 1:nrow(rgx)
dropmissing!(rgx, :knows)

K = 1_000
L = 1_000

######

ŷs = load_object("interaction models/newstrap_stage1.jld2")

# transform to match rgx
ŷst = (tpr = [e[rgx.ix] for e in ŷs.tpr], fpr = [e[rgx.ix] for e in ŷs.fpr])

ŷst = (j = [a + b for (a, b) in zip(ŷst.tpr, ŷst.fpr)], )

# actual second stage model
fx = @eval @formula(
    knows ~ $rte + riddle + relation + degree + age + age^2 + man + educated
)

m = fit(GeneralizedLinearModel, fx, rgx, Binomial(), LogitLink())

# bootstrap version of second stage model
rte_ = Symbol(string(rte) * "_k")
fx_k = @eval @formula(
    knows ~ $rte_ + riddle + relation + degree + age + age^2 + man + educated
)

fx_l = @eval @formula(
    knows_l ~ $rte + riddle + relation + degree + age + age^2 + man + educated
)

@inline fitfunc(fx, dat) = fit(GeneralizedLinearModel, fx, dat, Binomial(), LogitLink())

rgx[!, rte_] .= NaN;
rgx.knows_l .= false;

nth = Threads.nthreads()

nβ = length(coef(m));
# preallocate vectors of β coefficients
τ = [fill(NaN, nβ) for k in eachindex(1:(K*L))];
τ = reshape(τ, L, K);
mt = Vector{RegressionModel}(undef, nth);
# preallocate for predicted values (at each k)
ysim = [fill(NaN, nrow(rgx)) for _ in eachindex(1:K)];

@time newstrap2!(τ, rgx, ŷst, mt, ysim, K, L, fitfunc, rte, fx_k, fx_l)

# ysim

# std.(eachrow(reduce(hcat, ysim)))

save_object("interaction models/" * string(rte) *"_τ.jld2", τ)
