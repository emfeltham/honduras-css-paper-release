# riddle_2_fpr.jl
# julia --threads=12 --project="." "honduras-css-paper/code/riddle_2_fpr.jl" > "output/riddle_2_fpr.jl.txt"

include("../../code/setup/environment.jl")

using Random
Random.seed!(2024)

rte = :fpr

bimodel = load_object("objects/base1_tie_2.jld2")

# via tpr_fpr_interaction_bimodel.jl
rg = load_object("objects/tpr_fpr_boot_data_rg.jld2")

K = 1_000
L = 1_000

#%%
otc = load_object(datapath * "outcomes_" * dte * ".jld2");
select!(otc, Not(ids.vc, :wave))

leftjoin!(rg, otc, on = :perceiver => :name)

#%%

######

rx = deepcopy(rg)

ŷs = load_object("objects/newstrap_stage1.jld2")

rgx = stack(rg, riddles; variable_name = :riddle, value_name = :knows);

# non-treated individuals, random villages only
@subset!(rgx, .!:resp_target, .!:friend_treatment)

rgx.riddle = [split(x, "_")[1] for x in rgx.riddle];
rgx.riddle = categorical(rgx.riddle);
rgx.ix = 1:nrow(rgx)

dropmissing!(rgx, :knows)

save_object("objects/riddle_data.jld2", rgx)

# transform to match rgx
ŷst = (tpr = [e[rgx.ix] for e in ŷs.tpr], fpr = [e[rgx.ix] for e in ŷs.fpr])

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

nβ = length(coef(m))
# preallocate vectors of β coefficients
τ = [fill(NaN, nβ) for k in eachindex(1:(K*L))];
τ = reshape(τ, L, K);
mt = Vector{RegressionModel}(undef, nth)
# preallocate for predicted values (at each k)
ysim = [fill(NaN, nrow(rgx)) for _ in eachindex(1:K)]

@time newstrap2!(τ, rgx, ŷst, mt, ysim, K, L, fitfunc, rte, fx_k, fx_l)

save_object("objects/" * string(rte) *"_τ.jld2", τ)
