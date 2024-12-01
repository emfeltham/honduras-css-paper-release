# indig.jl

m1_ = load_object("interaction models/main_model.jld2")

m1_ = let dats = dats, fast = true
    
    trms = @formula(
        y ~ kin431 + relation + degree +
        man + age + age^2 + educated +
        # religion_c +
        # wealth_d1_4 +
        # coffee_cultivation +
        isindigenous +
        # educated_a + # + educated&educated_a +
        man_a + man&man_a +
        isindigenous_a + isindigenous_a&isindigenous +
        #religion_c_a + religion_c&religion_c_a +
        #degree_mean_a + degree_diff_a +
        # degree & degree_mean_a +
        # age_mean_a + age_diff_a +
        # age & age_mean_a +
        # wealth_d1_4_mean_a +
        # wealth_d1_4 & wealth_d1_4_mean_a +
        # wealth_d1_4_diff_a +
        kin431 & relation +
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
        fx2 = fx2, fast
    )
end

c_ = dropmissing(cr, prds);
sdict = standarddict(c_)
v2 = :isindigenous_a # Symbol(v)
ext = extrema(dats.tpr[!, v2])
sdict[v2] = ext[1]:0.01:ext[2]
# sdict[v2] = ext[1]:ext[2]
sdict[v2] = unique(dats.tpr.isindigenous_a)
sdict[:isindigenous] = false
rg = referencegrid(cr, sdict)

e_tpr = effects!(rg, m1_.tpr, eff_col = :tpr, err_col = :tpr_err; invlink = logistic);
e_fpr = effects!(rg, m1_.fpr, eff_col = :fpr, err_col = :fpr_err; invlink = logistic);

rgc = rg

# rgc = @subset rg :committee_count .∈ Ref(extrema(rg.committee_count))
em1 = empairs(rgc, eff_col = :tpr, err_col = :tpr_err)
em1.pval = pvalue.(em1.tpr, em1.tpr_err)
em2 = empairs(rgc, eff_col = :fpr, err_col = :fpr_err)
em2.pval = pvalue.(em2.fpr, em2.fpr_err)
