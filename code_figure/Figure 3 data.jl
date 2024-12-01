# figure_bivar_relatedness_data.jl

include("../../code/setup/analysis preamble.jl")

invlink = logistic;

# load relevant models
m1 = load_object("interaction models/base1_age2.jld2");
sbar = setup_figure2(m1, cr; invlink);

save_object("interaction models/bivar_data.jld2", sbar)

m1rel = load_object("interaction models/main_kinship.jld2");
pbsrel = let
    pbt = load_object("interaction models/main_relatedness_pb_1K_tpr.jld2")
    pbf = load_object("interaction models/main_relatedness_pb_1K_fpr.jld2")
    (tpr = pbt, fpr = pbf, )
end;

crg = let
    grel = CSV.read("/WORKAREA/work/HONDURAS_MICROBIOME/E_FELTHAM/kin/merged_filter_hwe_maf_new_names.kin0", DataFrame);
    rename!(grel, "#IID1" => "alter1", "IID2" => "alter2", "KINSHIP" => "kinship");

    # put edges in alphanumeric order
    HondurasTools.sortedges!(grel.alter1, grel.alter2)

    select!(grel, :alter1, :alter2, :kinship)

    leftjoin!(cr, grel; on = [:alter1, :alter2]);

    dropmissing(cr, :kinship)
end

println("data loaded")

prds = [
    :response,
    :kinship,
    :relation,
    :age, :man,
    :educated,
    :degree,
    :wealth_d1_4,
    :coffee_cultivation,
    :dists_p_notinf, :dists_p,
];

crg.unrelatedness = crg.kinship .* -1;
dat = dropmissing(crg, prds)

bimodel = m1rel;
pbs = pbsrel;
iters = 1_000;
vbl = :kinship;
vname = "Relatedness"

bpd = let e = vbl, name = vname
    ed = standarddict(dat; kinvals = [false, true])
    ed[e] = marginrange(dat, e; margresolution = 0.001, allvalues = false)
    rg = referencegrid(dat, ed)
    estimaterates!(rg, bimodel; iters = 20_000)
    ci_rates!(rg)
    bpd = (rg = rg, margvar = e, margvarname = name, )
end
addΣ!(bpd.rg)

save_object("interaction models/relatedness_margins_data.jld2", bpd)
