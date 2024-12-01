# kinship relatedness contrasts data.jl

include("../../code/setup/environment.jl")

#%% regression table
bm = load_object("interaction models/base1_tie_2_kinship.jld2");

pbs = (
    tpr = load_object("interaction models/kinship_pbs_tpr.jld2"),
    fpr = load_object( "interaction models/kinship_pbs_fpr.jld2"),
);

grel = CSV.read("/WORKAREA/work/HONDURAS_MICROBIOME/E_FELTHAM/kin/merged_filter_hwe_maf_new_names.kin0", DataFrame);
rename!(grel, "#IID1" => "alter1", "IID2" => "alter2", "KINSHIP" => "kinship");

# put edges in alphanumeric order
HondurasTools.sortedges!(grel.alter1, grel.alter2)

select!(grel, :alter1, :alter2, :kinship)

leftjoin!(cr, grel; on = [:alter1, :alter2]);

crg = dropmissing(cr, :kinship)

prds = [
    :alter1, :alter2, :village_code,
    :response,
    :kinship, :relation,
    :age, :man,
    :educated,
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
    :educated_a
];

dat = dropmissing(crg, prds)

using Random
Random.seed!(2023)

βset = pbs_process(pbs)
pbs = nothing

K = 10_000;

vbldict = [:kinship => "Kinship",];
margindict = Dict{Symbol, @NamedTuple{rg::DataFrame, name::String}}();

addmargins!(margindict, vbldict, bm, dat)

invlink = logistic;
@time altermargins_bs!(
    margindict, bm, βset, invlink, K; bivar = true
)

save_object(
    "interaction models/base1_tie2_relatedness_margins_bs.jld2", margindict
);

#%%

for (k, x) in margindict
    @show k
    rg = x.rg
    if "err_j" ∈ names(rg)
        select!(rg, Not(:err_j))
        rename!(rg, :err_j_bs => :err_j)
        rg.ci_j = ci.(rg.j, rg.err_j)
        rg.Σ = cov.(rg.bivar_bs) # (tpr, fpr)
        select!(rg, Not(:bivar_bs))
    end
end

save_object(
    "honduras-css-paper/objects/base1_tie2_relatedness_margins_bs_out.jld2",
    margindict
)
