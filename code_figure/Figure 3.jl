# Figure 3.jl

include("../../code/setup/environment.jl")

# data prep
dataloc = "honduras-css-paper/objects/"
sbar = load_object(dataloc * "bivar_data.jld2");
bpd = load_object(dataloc * "base1_tie2_relatedness_margins_bs_out.jld2")
bpd = (rg = bpd[:kinship].rg, margvar = :kinship, margvarname = "Relatedness")

bpd.rg[findmax(bpd.rg.j)[2], [:kinship, :j, :ci_j]];

md = load_object(dataloc * "base1_tie2_margins_bs_out.jld2");
transforms = load_object(dataloc * "variable_transforms.jld2");
vars = [:age, :wealth_d1_4, :degree];

for e in [:age, :degree]
	md[e].rg[!, e] = reversestandard(md[e].rg, e, transforms)
end

#%%
fg = Figure();
nlevels = 10;
colormap = berlin;

let
    l = fg[1, 1] = GridLayout();
    lla = l[1:2, 1] = GridLayout();
    l1_ = lla[1, :] = GridLayout();
    l2_ = lla[2, :] = GridLayout();
    l3 = l[1:2, 2] = GridLayout();
    
    perceivercontour!(
        l1_, sbar; kin, nlevels, colormap, axsz = 325
    );

    ellipsecolor = (yale.grays[end-1], 0.3)
    dropkin_eff = true
    tnr = true
    kinlegend = false

    l1 = l2_[1, 1] = GridLayout();
    ll = l2_[1, 2] = GridLayout();
	l2 = l2_[1, 3] = GridLayout();

    rocplot!(
        l1,
        bpd.rg, bpd.margvar, bpd.margvarname;
        ellipsecolor,
        markeropacity = 0.8,
        kinlegend,
        dolegend = false,
        axsz = 300
    )

    ll1 = ll[1, 1] = GridLayout()
    ll2 = ll[2, 1] = GridLayout()
    rowsize!(ll, 1, Relative(2.2/3))

    HondurasCSS.roclegend!(
        ll1, bpd.rg[!, bpd.margvar], bpd.margvarname, true, ellipsecolor, true;
        kinlegend = false,
    )

    HondurasCSS.effectsplot!(
        l2, bpd.rg, bpd.margvar, bpd.margvarname, tnr;
        dropkin = dropkin_eff,
        dolegend = false,
        axh = 300, axw = 300
    )

    HondurasCSS.effectslegend!(ll2[1, 1], true, true, false; tr = 0.6)

    l3s = [GridLayout(l3[i, 1])  for i in 1:3]
    ellipsecolor = (yale.grays[end-1], 0.3)
    for (i, e) in enumerate(vars)
		rg, margvarname = md[e]
		tp = (
			rg = rg, margvar = e, margvarname = margvarname,
			tnr = true, jstat = true
		);

        HondurasCSS.rocplot!(
            l3s[i],
            tp.rg, tp.margvar, tp.margvarname;
            axsz = 325,
            ellipsecolor,
            markeropacity = 0.8,
            kinlegend = true,
            dolegend = true
        )
	end

    labelpanels!([l1_, l2_, l3])
    
    colgap!(l, 1, -100)
    rowgap!(lla, 1, -100)
end

resize!(fg, 1500, 1300) # w,h
resize_to_layout!(fg)

#%%
let fg = fg
    filename = "honduras-css-paper/Figures (main)/Figure 3"
    short_caption = "Accuracy of social network beliefs"
    caption = typst"Accuracy of social network beliefs. Individuals perform better than chance at assessing social relationships for non-kin ties, and they perform more poorly in judgements of ties between pairs who are kin. *(a)* Bivariate distribution of respondent accuracy, represented as the true positive rate (sensitivity) versus false positive rate (1 – specificity). The green segment represents better-than-chance performance, and the orange section below the dotted line represents worse-than-chance performance. Top, distributions of assessments of ties that are between individuals who are kin, for the two relationships (free-time and personal-private). Bottom, assessments of ties for individuals who are not kin, for each relationship. Subject-level accuracy rates are stratified by the actual kinship status of the tie (whether the individuals in a displayed pair are kin based on their own reports) and by the two relationship types. Plots are restricted to respondents who evaluate at least 3 true and 3 false ties ($n = 9,305$ respondents). The overall unadjusted average subject-level accuracy rate and the model-adjusted means are indicated by black and magenta dots, respectively. The adjusted estimates are from a model with basic demographic controls, network degree, kinship status of the conceived tie, relationship type of the conceived tie, network distance, and random effects for village and survey respondent. The density values reflect counts of rates after interpolating, with a kernel density, the raw distribution of cognizer-level true and false positive rates along a $256^2$ grid corresponding to the range of rate values. This represents the underlying raw respondent-level means, rather than the model-adjusted estimates. Overall, we see that respondents perform better than the level of chance when assessing ties – between non-kin in particular. *(b)* Effect of the genetic relatedness of the pair with respect to accuracy in network cognition. In a subset of 17 villages ($n = 2,248$ respondents) we collected genetic data and estimated the kinship coefficient between the cognized pairs (involving $1,333$ individuals). The kinship coefficient is unbounded from below, where a value of 0 or less indicates that a pair of individuals are unrelated, and 1/2 indicates monozygotic twins (see Methods for details). Consistent with the results for the self-reported first-degree kinship result, we find a strong relationship between accuracy and relatedness. Specifically, we observe that individuals are the most accurate for individuals who are somewhat unrelated to themselves, and approach chance performance both for judgements of individuals who are either very unrelated or very close kin. LHS: Grey bands that surround the effect estimates represent bootstrapped 95% confidence ellipses. RHS: Bands represent 95% confidence intervals (see Methods for details). *(c)* Individual determinants of respondent accuracy. Three demographic characteristics associated with an individual's ability to accurately predict the ties in their village network are shown. In each panel, we see the marginal effect of the cognizer characteristic on accuracy (grey shading represents the 95% bootstrapped confidence ellipse of the predictions from the two models). Effect of age, education, wealth and network degree (here, effectively an average of the count of first-degree neighbors for the two relationships analyzed, personal-private or free-time) are shown (see Methods for details)."

    save(filename * ".png", fg; px_per_unit = 2.0)
    
    figure_export(
        filename * ".svg",
        fg,
        save2;
        caption,
        short_caption,
        outlined = true,
    )
end
