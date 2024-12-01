# margin data lt 2
# julia --threads=12 --project="." "honduras-css-paper/code/margin data lt 3.jl" > "output/margin data lt 3.jl.txt"

include("../../code/setup/analysis preamble.jl")
invlink = logistic;

m_smp = load_object("interaction models/main_model_limited_dist_3.jld2")
m_smp_b = load_object("interaction models/main_model_limited_dist_3a_fpr.jld2")
m_smp = EModel(m_smp.tpr, m_smp_b)
m_smp_b = nothing

pbs_smp = (
    tpr = load_object("interaction models/main_model_limited_dist_3 pb 1K tpr.jld2"),
    fpr = load_object("interaction models/main_model_limited_dist_3a pb 1K fpr.jld2")
);

#%% prepare data
cr = JLD2.load_object(datapath * "cr_" * "2024-05-01" * ".jld2");
code_variables!(cr);

@subset! cr :dists_p_notinf
@subset! cr :dists_p .<= 3;

transforms = standards(cr);
applystandards!(cr, transforms); # cf. reversestandards!

save_object("honduras-css-paper/objects/variable_transforms_lt_3.jld2", transforms)

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
    :dists_p => "Cognizer-to-tie distance",
    :dists_a => "Within-tie distance"
];

margindict = Dict{Symbol, @NamedTuple{rg::DataFrame, name::String}}();

addmargins!(
    margindict, vbldict, m_smp, pbs_smp, dat, length(pbs_smp.tpr), invlink;
    margresolution = 0.001, allvalues = false,
)

#=
dists_a and dists_p are handled normally above, since there is no interaction here
=#

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
    "honduras-css-paper/objects/main_model_limited_dist_3_margins.jld2", margindict
);
