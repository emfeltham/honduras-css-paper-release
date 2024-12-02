#%%

margindict = load_object(
    "interaction models/base1_tie_2_kinship_homo_figure_data.jld2"
)

e = :kinship_homo;
rg = deepcopy(margindict[e].rg);
rg = @subset rg .!($kin)
dropmissing!(rg)

fg = Figure();
ll = fg[1, 1:3] = GridLayout();
ll1 = ll[1, 1] = GridLayout();
lll = ll[1:2, 2] = GridLayout();
ll2 = ll[1, 3] = GridLayout();

ellipsecolor = (yale.grays[end-1], 0.3)
dropkin_eff = true
tnr = true
kinlegend = false

rocplot!(
    ll1,
    rg, e, bpd.name;
    ellipsecolor,
    markeropacity = 0.8,
    kinlegend,
    dolegend = false,
    axsz = 300
)

HondurasCSS.roclegend!(
    lll[1, 1], rg[!, e], bpd.name, true, ellipsecolor, true;
    kinlegend = false,
)

HondurasCSS.effectsplot!(
    ll2, rg, e, bpd.name, tnr;
    dropkin = dropkin_eff,
    dolegend = false,
    axh = 300, axw = 300
)

HondurasCSS.effectslegend!(lll[2, 1], true, true, false; tr = 0.6)
resize_to_layout!(fg)
resize!(fg, 900, 400)

rowsize!(lll, 1, Relative(2/3.5))
fg

#%%

@inline save2(name, fg) = save(name, fg; pt_per_unit = 2)

let fg = fg
    short_caption = "Effect of the genetic relatedness of the pair, using KING-homo algorithm"
	caption = "Effect of the genetic relatedness of the pair with respect to accuracy in network cognition, using an alternative algorithm to calculate genetic relatedness. In Figure 2, we use the _KING-robust_ algorithm to compute relatedness. Here, as a further robustness check, we instead use the _KING-homo- algorithm, which does not account for population structure. The kinship coefficient ranges between 0 and 1 (see Methods for details). The results are broadly consistent with the results in Figure 2. Specifically, we see that individuals are most accurate at intermediate levels of relatedness. Here, note the range is shifted with respect to Figure 2. Consistent with the results for the self-reported first-degree kinship result, we find a strong relationship between accuracy and relatedness. Specifically, we observe that individuals are the most accurate for individuals who are somewhat unrelated to themselves, and approach chance performance both for judgements of individuals who are either very unrelated or very close kin. LHS: Grey bands that surround the effect estimates represent bootstrapped 95% confidence ellipses. RHS: Bands represent 95% confidence intervals (see Methods for details)."

	figure_export(
		"honduras-css-paper/Figures (SI)/king_homo.svg",
		fg,
		save2;
		caption,
        short_caption,
        # kind = Symbol("image-si"),
        # supplement = "*Supplementary Figure*",
		outlined = true,
	)
end
