# tpr_fpr_second_stage.jl
# julia --threads=32 --project="." "honduras-css-paper/code/tpr_fpr_model_1.jl" > "output/tpr_fpr_model_1.jl.txt"

include("../../code/setup/environment.jl")

bimodel = load_object("interaction models/base1_tie_2.jld2")

pbs = (
    tpr = load_object("interaction models/base1_pb_10K_tpr_tie_2.jld2"),
    fpr = load_object("interaction models/base1_pb_10K_fpr_tie_2.jld2")
);

# via tpr_fpr_interaction_bimodel.jl
rg = load_object("interaction models/tpr_fpr_boot_data_rg.jld2")

# K = length(pbs.tpr.θ);
K = 10_000

Θ = pbs_process(pbs)

# check that order is always the same across iters
@assert (length∘unique)(Θ.tpr.coefname) .== 1

mthreads = Vector{typeof(bimodel)}(undef, Threads.nthreads());
fill_mthreads!(mthreads, bimodel)

# add new column to rgb for each iter
# e.g., :fpr_i
rgb = deepcopy(rg);
fill_rgb!(rgb, K, rates)

# bootstrap procedure:
# for each (iter, params) in enumerate pbs
# run a second stage model
# run effects
# store the estimates
# (end loop)
# get se of estimates, and
# update uncertainty in second stage model

@time stage1_bs!(rgb, mthreads, βset, θset, rates, K, logistic)

save_object("interaction models/tpr_fpr_boot_data_stage1_10K.jld2", rgb)

#=
rgb = load_object("interaction models/tpr_fpr_boot_data_stage1_10K.jld2")

rgb_tpr = @chain rgb begin
    select(:relation, :perceiver, Between(:tpr_1, :tpr_1000))
    stack(Not(:relation, :perceiver))
end

r2 = @chain rgb_tpr begin
    groupby([:perceiver, :relation])
    combine(nrow => :count, :value => mean, :value => std, :value => extrema)
end

dsts = Normal.(coef(bimodel.tpr), stderror(bimodel.tpr));

βsims = [fill(NaN, 10_000) for i in eachindex(dsts)];

for (i, e) in enumerate(dsts)
    βsims[i] .= rand(e, 10_000)
end

std.(βsims)

rg
=#

#%%
otc = load_object(datapath * "outcomes_" * dte * ".jld2");
select!(otc, Not(ids.vc, :wave))

leftjoin!(rg, otc, on = :perceiver => :name)

#%%

rgx = stack(rg, riddles; variable_name = :riddle, value_name = :knows);

# non-treated individuals, random villages only
@subset!(rgx, .!:resp_target, .!:friend_treatment)

rgx.riddle = [split(x, "_")[1] for x in rgx.riddle];
rgx.riddle = categorical(rgx.riddle);

rg_ = deepcopy(rgx)

rte = :tpr
fx = @eval @formula(
    knows ~ riddle + $rte + relation + degree + age + age^2 + man + religion_c +
    wealth_d1_4 + isindigenous
)

mtpr = fit(GeneralizedLinearModel, fx, rgx, Binomial(), LogitLink())

rgxb = deepcopy(rgx)

ms = Vector{RegressionModel}(undef, 1)

rte = :tpr_k
fx = @eval @formula(
    knows ~ riddle + $rte + relation + degree + age + age^2 + man + religion_c +
    wealth_d1_4 + isindigenous
)

K = 1_000
L = 10_000
βout = [fill(NaN, 13) for i in eachindex(1:(K*L))];
βout = reshape(βout, L, K)
rgxb[!, :tpr_k] .= NaN

function simulation!(βout, ms, rgxb, fx, K,L)
    for k in eachindex(1:K)
        # simulate to get first-stage uncertainty (via err in what is stage 2 data)
        rgxb[!, :tpr_k] .= rand.(Normal.(rgxb.tpr, rgxb.err_tpr))
        ms[1] = fit(GeneralizedLinearModel, fx, rgxb, Binomial(), LogitLink())
        for l in eachindex(1:L)
            # simulate using stage 2 std error to get uncertainty at second stage
            βout[l, k] .= rand.(Normal.(coef(ms[1]), stderror(ms[1])))
        end
    end
end

simulation!(βout, ms, rgxb, fx, K,L)

βreorg = [vec([βout[j][i] for j in 1:length(βout)]) for i in eachindex(1:13)]

mean(βreorg[4])

vc = varcov(βreorg)
sqrt.(diag(vc))

hcat(coef(mtpr), stderror(mtpr), sqrt.(diag(vc)))

std(pbs.tpr.tbl.β04)

Θ.tpr


# fit(LinearModel, [ones(nrow(rg)) rg.fpr], rg.tpr)

bm2 = deepcopy(bimodel);
rx = deepcopy(rg)
invlink = logistic

K = 1_000

ŷs = (
    tpr = [fill(NaN, nrow(rx)) for i in eachindex(1:K)],
    fpr = [fill(NaN, nrow(rx)) for i in eachindex(1:K)]
)

@time newstrap!(ŷs, rx, bm2, Θ, K, invlink)

save_object("interaction models/newstrap_stage1.jld2", ŷs)
