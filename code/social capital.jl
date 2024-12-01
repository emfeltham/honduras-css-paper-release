# social capital.jl

# no real results here

include("../../code/setup/analysis preamble.jl")

committees = [:education_committee, :health_committee, :parent_society_committee, :religious_committee, :school_snack_committee, :soccer_committee, :water_committee, :women_committee, :management_committee];

disallowmissing!(cr, :soccer_committee)
disallowmissing!(cr, :water_committee)
# :education_committee
disallowmissing!(cr, :health_committee)
disallowmissing!(cr, :parent_society_committee)
disallowmissing!(cr, :school_snack_committee)
disallowmissing!(cr, :religious_committee)
disallowmissing!(cr, :women_committee)
disallowmissing!(cr, :management_committee)

@inline misproc(x) = ifelse(!ismissing(x), ifelse(x == 0, false, true), missing);

replace!(cr.education_committee, missing => false)
disallowmissing!(cr, :education_committee)

cr.soccer_committee = [misproc(x) for x in cr.soccer_committee]

unique(cr[!, [:village_code, committees...]])

cr.committee_count = (sum∘eachcol)(cr[!, committees]);

#=
:community_board
:private_soccer_field, :community_center
=#

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

dats = let
    crt2 = dropmissing(@subset(cr, $socio), prds);
    crf2 = dropmissing(@subset(cr, .!$socio), prds);

    sort!(crt2, [:perceiver, :order]);
    sort!(crf2, [:perceiver, :order]);
    bidata(crt2, crf2)
end;

glm(@formula(response ~ committee_count + population), dats.tpr, Binomial(), LogitLink())

cr[!, :education_committee]

trms = @formula(
        response ~ kin431 + relation + degree +
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
        committee_count + population +
        health_center + communityboard + havepatron +
        community_center
);

mtpl = (
    t = glm(trms, dats.tpr, Binomial(), LogitLink()),
    f = glm(trms, dats.fpr, Binomial(), LogitLink())
);

v = "community_center"
x = let 
    a = findfirst(coefnames(mtpl.t) .== v);
    b = findfirst(coefnames(mtpl.f) .== v);

    [coef(mtpl.t)[a] pvalue(coef(mtpl.t)[a], stderror(mtpl.t)[a]);
    coef(mtpl.f)[b] pvalue(coef(mtpl.f)[b], stderror(mtpl.f)[b])]
end

v2 = :committee_count # Symbol(v)
ext = extrema(dats.tpr[!, v2])
dd = standarddict(dats.fpr)
dd[v2] = ext[1]:0.01:ext[2]

effects(dd, mtpl.t; invlink = logistic)
effects(dd, mtpl.f; invlink = logistic)

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
        committee_count + population +
        health_center + communityboard + havepatron +
        community_center
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

c_ = dropmissing(cr, prds);
sdict = standarddict(c_)
v2 = :committee_count # Symbol(v)
ext = extrema(dats.tpr[!, v2])
sdict[v2] = ext[1]:0.01:ext[2]
sdict[v2] = ext[1]:ext[2]
rg = referencegrid(cr, sdict)

e_tpr = effects!(rg, m1_.tpr, eff_col = :tpr, err_col = :tpr_err; invlink = logistic)
e_fpr = effects!(rg, m1_.fpr, eff_col = :fpr, err_col = :fpr_err; invlink = logistic)

rgc = @subset rg :committee_count .∈ Ref(extrema(rg.committee_count))
em1 = empairs(rgc, eff_col = :tpr, err_col = :tpr_err)
pvalue.(em1.tpr, em1.tpr_err)
em2 = empairs(rgc, eff_col = :fpr, err_col = :fpr_err)
pvalue.(em2.fpr, em2.fpr_err)

# empairs(e_tpr, eff_col = :response)