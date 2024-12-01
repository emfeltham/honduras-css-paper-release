# margin data lt 2
# julia --threads=12 --project="." "honduras-css-paper/code/margin data lt 2.jl" > "output/margin data lt 2.jl.txt"

include("../../code/setup/analysis preamble.jl")

m_smp = load_object("interaction models/main_model_limited_dist.jld2")
invlink = logistic

pbs_smp = (
    tpr = load_object("interaction models/main_model_limited_dist pb 1K tpr.jld2"),
    fpr = load_object("interaction models/main_model_limited_dist pb 1K fpr.jld2")
);

#%% prepare data
cr = JLD2.load_object(datapath * "cr_" * "2024-05-01" * ".jld2");
code_variables!(cr);

@subset! cr :dists_p_notinf
@subset! cr :dists_p .< 3;

transforms = standards(cr);
applystandards!(cr, transforms); # cf. reversestandards!

save_object("honduras-css-paper/objects/variable_transforms_lt_2.jld2", transforms)

println("data loaded")

prds = [
    :response,
    :kin431, :relation,
    :age, :man,
    :educated,
    :educated_a,
    :degree,
    :dists_p_notinf, :dists_p,
    :man_a,
    :age_mean_a,
    :age_diff_a,
    :religion_c,
    :religion_c_a,
    :isindigenous,
    :isindigenous_a,
    :degree_mean_a,
    :degree_diff_a,
    :wealth_d1_4, 
    :wealth_d1_4_mean_a,
    :wealth_d1_4_diff_a,
    :coffee_cultivation
];

dropmissing!(cr, prds);

dats = let
    crt2 = dropmissing(@subset(cr, $socio), prds);
    crf2 = dropmissing(@subset(cr, .!$socio), prds);

    sort!(crt2, [:perceiver, :order]);
    sort!(crf2, [:perceiver, :order]);
    bidata(crt2, crf2)
end;

dat = dropmissing(cr, prds)

#%% marginal effect calculations
using Random
Random.seed!(2023)

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
    :coffee_cultivation => "Coffee cultivation",
    :dists_p => "Cognizer-to-tie distance"
];

margindict = Dict{Symbol, @NamedTuple{rg::DataFrame, name::String}}();

addmargins!(
    margindict, vbldict, m_smp, pbs_smp, dat, length(pbs_smp.tpr), invlink;
    margresolution = 0.001, allvalues = false,
)

# #%% this is handled normally above, since there is no interaction here
# # add distance variables
# d_p = (:dists_p, :dists_p_notinf);
# name_d_p = "Cognizer-to-tie distance";

# addmargins_dist!(
#     margindict,
#     d_p, name_d_p, m_smp, pbs_smp, dat, invlink; margresolution = 0.001, allvalues = true
# )

# d_a = (:dists_a, :dists_a_notinf);
# name_d_a = "Within-tie distance";

# addmargins_dist!(
#     margindict,
#     d_a, name_d_a, m_smp, pbs_smp, dat, invlink; margresolution = 0.001, allvalues = true
# )

# kin
let e = :kin431
    ed = standarddict(dat; kinvals = [false, true])
    rg = referencegrid(dat, ed)
    βset = pbs_process(pbs_smp)
    bms = deepcopy(m_smp)
    K = length(pbs_smp.tpr)

    estimaterates!(rg, m_smp; iters = nothing)
    rg[!, :j] = rg[!, :tpr] - rg[!, :fpr]
    ses, bv = j_calculations_pb!(rg, bms, βset, invlink, K; bivar = true)
    rg[!, :err_j] = ses
    rg[!, :ci_j] = ci.(rg[!, :j], rg[!, :err_j])
    rg[!, :ci_tpr] = ci.(rg[!, :tpr], rg[!, :err_tpr])
    rg[!, :ci_fpr] = ci.(rg[!, :fpr], rg[!, :err_fpr])
    rg[!, :Σ] = cov.(eachrow(bv))
    
    margindict[e] = (rg = rg, name = "Kin",)
end

save_object(
    "interaction models/main_model_limited_dist_margins.jld2", margindict
);
