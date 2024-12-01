# margin data
# julia --threads=12 --project="." "honduras-css-paper/code/margin data.jl" > "output/margin data.jl.txt"

include("../../code/setup/analysis preamble.jl")

bimodel = load_object("interaction models/base1_tie_2.jld2")
invlink = logistic

#%% prepare data

prds = [
    :response,
    :kin431, :relation,
    :age, :man,
    :educated,
    :degree,
    :dists_p_notinf, :dists_p,
    :man_a,
    :age_mean_a,
    :age_diff_a,
    :religion_c,
    :religion_c_a,
    :isindigenous_a,
    :degree_mean_a,
    :degree_diff_a,
    :wealth_d1_4, 
    :wealth_d1_4_mean_a,
    :wealth_d1_4_diff_a,
    :educated_a,
    :coffee_cultivation
];

vbldict = [
    # :kin431 => "Kin",
    # :dists_p_notinf, :dists_p,
    :relation => "Relation",
    :age => "Age",
    :man => "Gender",
    :educated => "Education",
    :man_a => "Gender",
    :age_mean_a => "Age (mean)",
    :age_diff_a  => "Age (difference)",
    :religion_c => "Religion",
    :religion_c_a => "Religion",
    :isindigenous => "Indigeneity",
    :isindigenous_a => "Indigeneity",
    :degree => "Degree",
    :degree_mean_a => "Degree (mean)",
    :degree_diff_a => "Degree (difference)",
    :wealth_d1_4 => "Wealth",
    :wealth_d1_4_mean_a => "Wealth (mean)",
    :wealth_d1_4_diff_a => "Wealth (difference)",
    :educated_a => "Education",
    :coffee_cultivation => "Coffee cultivation"
];

dat = dropmissing(cr, prds)

#%% marginal effect calculations
using Random
Random.seed!(2023)

margindict = Dict{Symbol, @NamedTuple{rg::DataFrame, name::String}}();

addmargins!(margindict, vbldict, bimodel, dat)

# add distance variables
let
    d_p = (:dists_p, :dists_p_notinf);
    rg = margindistgrid(d_p, dat; margresolution = 0.001, allvalues = true)
    estimaterates!(rg, bimodel; iters = 20_000)
    ci_rates!(rg)
    margindict[d_p[1]] = (rg = rg, name = "Cognizer-to-tie distance",)
end

let
    d_a = (:dists_a, :dists_a_notinf);
    rg = margindistgrid(d_a, dat; margresolution = 0.001, allvalues = true)
    estimaterates!(rg, bimodel; iters = 20_000)
    ci_rates!(rg)
    select!(rg, Not(:tpr, :err_tpr, :ci_tpr, :j, :err_j, :ci_j))
    margindict[d_a[1]] = (rg = rg, name = "Within-tie distance",)
end

kin
let e= :kin431
    ed = standarddict(dat; kinvals = [false, true])
    rg = referencegrid(dat, ed)
    estimaterates!(rg, bimodel; iters = 20_000)
    ci_rates!(rg)
    margindict[e] = (rg = rg, name = "Kin",)
end

save_object("interaction models/base1_tie2_margins.jld2", margindict);

#%% examine degree
# x = margindict[:degree] |> deepcopy
# @subset! x.rg .!($kin)

# ad = Dict(
#     :dists_p_notinf => true,
#     :dists_p => mean(cr.dists_p[cr.dists_p_notinf]),
#     :degree => (extrema∘skipmissing)(cr.degree), :age => (mean∘skipmissing)(cr.age)
# )

# eft = effects(ad, bimodel.tpr; invlink = logistic)

#%% bootstrap confidence intervals

margindict = load_object("interaction models/base1_tie2_margins.jld2");

pbs = (
    tpr = load_object("interaction models/base1_pb_10K_tpr_tie_2.jld2"),
    fpr = load_object("interaction models/base1_pb_10K_fpr_tie_2.jld2")
);

# do these once
bm = deepcopy(bimodel)
βset = pbs_process(pbs)
pbs = nothing

K = 10_000

altermargins_bs!(
    margindict, bm, βset, invlink, K; bivar = true
)

save_object("interaction models/base1_tie2_margins_bs.jld2", margindict);
