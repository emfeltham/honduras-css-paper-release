# kin_extra.jl;

include("../../code/setup/analysis preamble.jl")

mkcat = load_object("interaction models/main_kincat.jld2")
mkdst = load_object("interaction models/main_kin_dist.jld2")
ck = load_object("interaction models/kintypes.jld2")
select!(ck, :tie, :kintype, :wave)

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
    :isindigenous,
    :isindigenous_a,
    :degree_mean_a,
    :degree_diff_a,
    :wealth_d1_4, 
    :wealth_d1_4_mean_a,
    :wealth_d1_4_diff_a,
    :educated_a
];

dat = dropmissing(cr, prds);

ckr = @chain ck begin
    groupby(:tie)
    combine(:kintype => Ref∘unique => :kintype)
end

# handle a few cases where multiple kin types are reported
ckr.kintype = [x[1] for x in ckr.kintype];

dat.tie = [Set([a, b]) for (a,b) in zip(dat.alter1, dat.alter2)];
leftjoin!(dat, ckr, on = :tie)
replace!(dat.kintype, missing => "None")
dat.kintype = categorical(dat.kintype);

catmarg = let
    e = :kintype;
    ed = standarddict(dat; kinvals = nothing)
    ed[e] = ["None", "Parent/child", "Partners", "Siblings"]
    rg = referencegrid(dat, ed)
    estimaterates!(rg, mkcat; iters = 20_000)
    ci_rates!(rg)
    (rg = rg, name = "Kin type",)
end

dstmarg = let
    d_a = (:are_related_dists_a, :are_related_dists_a_notinf);
    rg = margindistgrid(d_a, dat; margresolution = 0.001, allvalues = true)
    estimaterates!(rg, mkdst; iters = 20_000)
    ci_rates!(rg)
    (rg = rg, name = "Within-tie kinship distance",)
end

save_object("interaction models/kinship_marg.jld2", [catmarg, dstmarg])
