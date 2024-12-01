# relatedness-kin-homo.jl
# alternative relatedness calculation

#%% run first 56 lines of `base_models_kin_relatedness.jl` (included below)

include("../../code/setup/analysis preamble.jl")

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

dats = let cr = crg
    crt2 = @subset(cr, $socio);
    crf2 = @subset(cr, .!$socio);
    dropmissing!(crt2, prds)
    dropmissing!(crf2, prds)

    sort!(crt2, [:perceiver, :order]);
    sort!(crf2, [:perceiver, :order]);
    bidata(crt2, crf2)
end;

dat = let cr = crg
   d = dropmissing(cr, prds)
   sort!(d, [:perceiver, :order]);
end;

println("model start")

#%%

grel_h = CSV.read("/SCRATCH/tmp/king.kin", DataFrame);
rename!(grel_h, "ID1" => "alter1", "ID2" => "alter2", "Kinship" => "kinship");
HondurasTools.sortedges!(grel_h.alter1, grel_h.alter2)
select!(grel_h, :alter1, :alter2, :kinship)
rename!(grel_h, :kinship => :kinship_homo)

leftjoin!(cr, grel_h; on = [:alter1, :alter2]);

xx = @chain cr begin
    select(:kinship_homo, :kinship)
    dropmissing()
end

using HypothesisTests

CorrelationTest(xx.kinship, xx.kinship_homo)
# we find that the two are closely

leftjoin!(dats.tpr, grel_h; on = [:alter1, :alter2]);
leftjoin!(dats.fpr, grel_h; on = [:alter1, :alter2]);
leftjoin!(dat, grel_h; on = [:alter1, :alter2]);


mk1_h = let dats = dats;
    
    trms = @formula(
        y ~ kinship_homo + relation + degree +
        man + age + age^2 + educated +
        religion_c +
        wealth_d1_4 +
        coffee_cultivation +
        isindigenous +
        educated_a + # + educated&educated_a +
        man_a + man&man_a +
        isindigenous_a + isindigenous_a&isindigenous +
        religion_c_a + religion_c&religion_c_a +
        degree_mean_a + degree_diff_a +
        degree & degree_mean_a +
        age_mean_a + age_diff_a +
        age & age_mean_a +
        wealth_d1_4_mean_a +
        wealth_d1_4 & wealth_d1_4_mean_a +
        wealth_d1_4_diff_a +
        kinship_homo & relation +
        dists_p_notinf +
        dists_p_notinf & dists_p
    );
    trms = trms.rhs

    re = (ConstantTerm(1) | term(:village_code)) + (ConstantTerm(1) | term(:perceiver))
    fx = vcat(trms..., re...)
    fx = term(:response) ~ reduce(+, fx)
    
    faketerms = term(:dists_a_notinf) + InteractionTerm(term.((:dists_a_notinf, :dists_a)))

    fx2 = Term(:response) ~ fx.rhs + faketerms;

    x = bifit(
        MixedModel, fx, dats[:tpr], dats[:fpr];
        dstr = Binomial(), lnk = LogitLink(),
        fx2 = fx2, fast = false
    )
end

save_object("interaction models/base1_tie_2_kinship_homo.jld2", mk1_h);

pbt = parametricbootstrap(1_000, mk1_h.tpr);
pbf = parametricbootstrap(1_000, mk1_h.fpr);

save_object(
    "interaction models/base1_tie_2_kinship_homo_pb_1k.jld2",
    [pbt, pbf]
)

#%%

pbs = (tpr = pbt, fpr = pbf,);

invlink = logistic;
margindict = Dict{Symbol, @NamedTuple{rg::DataFrame, name::String}}();
vbldict = [:kinship_homo => "Kinship (KING-homo)"]

addmargins!(margindict, vbldict, mk1_h, dat)

#%%

K = 1_000;
bm = deepcopy(mk1_h)
βset = pbs_process(pbs)
pbs = nothing

altermargins_bs!(
    margindict, mk1_h, βset, invlink, K; bivar = true
)

margindict[e].rg.ci_j = ci.(margindict[e].rg.j, margindict[e].rg.err_j_bs)
margindict[e].rg.Σ = cov.(margindict[e].rg.bivar_bs)


save_object("interaction models/base1_tie_2_kinship_homo_figure_data.jld2", margindict)
