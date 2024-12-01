# neighborhood.jl
# heterogeneity of neighbors

include("../../code/setup/analysis preamble.jl")

rhv4 = load_object(datapath * "rhv4_" * dte * ".jld2");
select!(rhv4, Not([:friend_treatment, :dosage]));
rhv4 = dropmissing(rhv4, [ids.vc, ids.n]);
# @subset! rhv4 :data_source .== "Census, survey";

ndfw = let waves = [4]
    con = load_object(datapath * "connections_data_" * dte * ".jld2")
    @subset! con :ego .!= "No_One" :alter .!= "No_One"
    @subset! con :ego .!= "No one" :alter .!= "No one"
    
    nts = ["free_time", "personal_private", "are_related"];
    @subset! con :wave .== 1 :relationship .∈ Ref(nts) :alter_source .== "Census"
   
    @time ndf = networkinfo(
        con;
        waves = [1],
        relnames = [
            "free_time", "personal_private", "are_related", "union"
        ]
    );
end;

@subset! ndfw :relation .!= "union";


nfo = let
    nb = Vector{Vector{Vector{String}}}(undef, length(ndfw[!, :graph]));
    for (i, x) in enumerate(ndfw.names)
        nb[i] = Vector{Vector{String}}(undef, length(x))
    end

    neighborprops!(nb, ndfw[!, :graph])

    nfo = DataFrame(
        :village_code => ndfw[!, :village_code],
        :names => ndfw[!, :names],
        :neighbors => nb
    )

    nfo_ = flatten(nfo, [:names, :neighbors]) 
    nfo_.neigbor_num = length.(nfo_.neighbors)
    nfo_ = flatten(nfo_, :neighbors)
    rename!(nfo_, :neighbors => :neighbor, :names => :name)
    nfo_
end

# unique over both networks
nfo = unique(nfo)

#%%
# neighbor outcomes
neighbor_vbls = [:name, :age, :man, :wealth_d1_4];
rhv4_ = rhv4[!, neighbor_vbls];
for v in neighbor_vbls[2:end]
    rename!(rhv4_, v => Symbol(string(v) * "_n"))
end
leftjoin!(nfo, rhv4_, on = [:neighbor => :name])

nfo2 = leftjoin(nfo, rhv4[!, neighbor_vbls], on = :name)

nfo2_ = @chain nfo2 begin
    groupby(:name)
    combine(nrow => :count, :wealth_d1_4_n => mean, renamecols = false)
end
nfo2_.wealth_d1_4_ndiff = nfo2_.wealth_d1_4 - nfo2_.wealth_d1_4_n;

nfo3 = leftjoin(nfo2_, rhv4[!, neighbor_vbls], on = :name)
nfo3.wealth_d1_4_ndiff = nfo3.wealth_d1_4 - nfo3.wealth_d1_4_n;

nfo4 = dropmissing(nfo3)

hist(nfo4.wealth_d1_4_ndiff)
mean(nfo4.wealth_d1_4_ndiff)

scatter(nfo4.wealth_d1_4, nfo4.wealth_d1_4_n, color = (oi[1], 0.2))

leftjoin!(
    cr,
    select(nfo3, :name, :wealth_d1_4_n, :wealth_d1_4_ndiff),
    on = :perceiver => :name
)

###

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
    :coffee_cultivation,
    ##
    :wealth_d1_4_ndiff
];

dats = let
    crt2 = dropmissing(@subset(cr, $socio), prds);
    crf2 = dropmissing(@subset(cr, .!$socio), prds);

    sort!(crt2, [:perceiver, :order]);
    sort!(crf2, [:perceiver, :order]);
    bidata(crt2, crf2)
end;

m1_ = let dats = dats, fast = true
    
    trms = @formula(
        y ~ kin431 + relation + degree +
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
        kin431 & relation +
        dists_p_notinf +
        dists_p_notinf & dists_p +
        ##
        wealth_d1_4_ndiff * wealth_d1_4 +
        wealth_d1_4_ndiff * wealth_d1_4_mean_a +
        wealth_d1_4_ndiff * wealth_d1_4_diff_a
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
        fx2 = fx2, fast
    )
end

m1_.tpr
m1_.fpr
c_ = dropmissing(cr, prds);

sdict = standarddict(c_)
v2 = :wealth_d1_4_ndiff # Symbol(v)
ext = extrema(dats.tpr[!, v2])
sdict[v2] = ext[1]:0.01:ext[2]
rg = referencegrid(cr, sdict)

effects!(rg, m1_.tpr, eff_col = :tpr, err_col = :tpr_err; invlink = logistic)
effects!(rg, m1_.fpr, eff_col = :fpr, err_col = :fpr_err; invlink = logistic)

rg

rgc = @subset rg $v2 .∈ Ref(extrema(rg[!, v2]))
em1 = empairs(rgc, eff_col = :tpr, err_col = :tpr_err)
pvalue.(em1.tpr, em1.tpr_err)
em2 = empairs(rgc, eff_col = :fpr, err_col = :fpr_err)
pvalue.(em2.fpr, em2.fpr_err)
