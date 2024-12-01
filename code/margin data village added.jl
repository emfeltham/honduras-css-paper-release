# margin data village added
# julia --threads=12 --project="." "honduras-css-paper/code/margin data.jl" > "output/margin data.jl.txt"

include("../../code/setup/analysis preamble.jl")

bimodel = load_object("interaction models/main_village_added.jld2")
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
    :population => "Population",
    :isolation => "Isolation",
    :coffee_cultivation => "Coffee cultivation"
];

dat = dropmissing(cr, prds);

using Random
Random.seed!(2023)

margindict = Dict{Symbol, @NamedTuple{rg::DataFrame, name::String}}();

addmargins!(margindict, vbldict, bimodel, dat)

save_object("interaction models/base1_tie2_margins_village_added.jld2", margindict);

##

# margindict = load_object("interaction models/base1_tie2_margins.jld2");

pbs = (
    tpr = load_object("interaction models/main_village_added_pb_1K_tpr.jld2"),
    fpr = load_object("interaction models/main_village_added_pb_1K_fpr.jld2")
);

# do these once
bm = deepcopy(bimodel)
βset = pbs_process(pbs)
pbs = nothing

K = 1_000

altermargins_bs!(
    margindict, bm, βset, invlink, K; bivar = true
)

save_object("interaction models/base1_tie2_margins_bs.jld2", margindict);

# ej = Float64[]
# ejb = Float64[]
# for (k, x) in margindict
#     @show k
#     rg = x.rg
#     if "err_j" ∈ names(rg)
#         push!(ej, mean(rg.err_j))
#         push!(ejb, mean(rg.err_j_bs))
#     end
# end

# ej ./ ejb
# we confirm that in general the bootstrap intervals are a bit smaller
# with SEs ranging from 5-10% smaller over the set of attributes
# x = margindict[:age].rg
# es, ix = findmax(x.j)
# x[ix, :]
