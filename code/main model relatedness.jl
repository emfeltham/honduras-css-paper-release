# relatedness.jl

include("../../code/setup/analysis preamble.jl")

grel = CSV.read("/WORKAREA/work/HONDURAS_MICROBIOME/E_FELTHAM/kin/merged_filter_hwe_maf_new_names.kin0", DataFrame);
rename!(grel, "#IID1" => "alter1", "IID2" => "alter2", "KINSHIP" => "kinship");

# put edges in alphanumeric order
HondurasTools.sortedges!(grel.alter1, grel.alter2)

select!(grel, :alter1, :alter2, :kinship)

leftjoin!(cr, grel; on = [:alter1, :alter2]);

crg = dropmissing(cr, :kinship)

unique(vcat(crg.alter1, crg.alter2))

# N.B. the drop in observations
length(unique(crg.village_code))
length(unique(crg.perceiver))

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

println("model start")

mk1 = let dats = dats;
    
    trms = @formula(
        y ~ kinship + relation + degree +
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
        kinship & relation +
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
        fx2 = fx2, fast = true
    )
end

save_object("interaction models/base1_tie_2_kinship.jld2", mk1);

#%%

bpd_kinship = biplotdata(
    m, dats, :kinship;
    pbs = nothing, invlink, iters, varname = "Kinship",
    type, transforms,
)

fg_kinship = let m = mk1, bpd = bpd_kinship # kinship
    fg = Figure();
    l = fg[1,1] = GridLayout()
    biplot!(
        l,
        bpd;
        jstat = false,
        ellipse = false,
        markeropacity = 1,
    )
    resize_to_layout!(fg)
    resize!(fg, 900, 400)
    fg
end
