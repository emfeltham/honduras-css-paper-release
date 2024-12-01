# tie robustness.jl

#=
Conduct two additional analyses to showcase the robustness of the results w.r.t. to informant accuracy.

1. intersection: only ties nominated at all waves, stable ties
2. union: ties nominated at _any_ wave, sensitivity to recall failure
=#

# nomination in any wave

include("../../code/setup/analysis preamble.jl")

# load models

# intersect
model = load_object("interaction models/base1_tie_2_tie_robustness_inter.jld2")
invlink = logistic

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

using Random
Random.seed!(2023)

margindict = Dict{Symbol, @NamedTuple{rg::DataFrame, name::String}}();

addmargins!(margindict, vbldict, model, dat)

# add distance variables
let
    d_p = (:dists_p, :dists_p_notinf);
    rg = margindistgrid(d_p, dat; margresolution = 0.001, allvalues = true)
    estimaterates!(rg, model; iters = 20_000)
    ci_rates!(rg)
    margindict[d_p[1]] = (rg = rg, name = "Cognizer-to-tie distance",)
end

# let
#     d_a = (:dists_a, :dists_a_notinf);
#     rg = margindistgrid(d_a, dat; margresolution = 0.001, allvalues = true)
#     estimaterates!(rg, model; iters = 20_000)
#     ci_rates!(rg)
#     select!(rg, Not(:tpr, :err_tpr, :ci_tpr, :j, :err_j, :ci_j))
#     margindict[d_a[1]] = (rg = rg, name = "Within-tie distance",)
# end

save_object("interaction models/base1_tie2_margins_intersect.jld2", margindict);

##

bimodel = 
    emodel(
        load_object("interaction models/base1_tie_2_tie_robustness_union.jld2"),
        load_object("interaction models/base1_tie_2_tie_robustness_union_fpr.jld2"),
    )
invlink = logistic

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
    margindict[d_a[1]] = (rg = rg, name = "Within-tie distance",)
end

save_object("interaction models/base1_tie2_margins_union.jld2", margindict);
