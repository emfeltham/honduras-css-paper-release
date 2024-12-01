# SI Figure result same building.jl

include("../../code/setup/environment.jl")

margindict = load_object(
    "interaction models/margindict_same_building.jld2"
)

e = :same_building_a;
rg = deepcopy(margindict[e].rg);
ename = margindict[e].name;
# rg = @subset rg .!($kin);
dropmissing!(rg);

cts = eltype(rg[!, e]) <: AbstractFloat

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
    rg, e, ename;
    ellipsecolor,
    markeropacity = 0.8,
    kinlegend,
    dolegend = false,
    axsz = 300
)

HondurasCSS.roclegend!(
    lll[1, 1], rg[!, e], ename, true, ellipsecolor, cts;
    kinlegend = false,
    framevisible = false
)

HondurasCSS.effectsplot!(
    ll2, rg, e, ename, tnr;
    dropkin = dropkin_eff,
    dolegend = false,
    axh = 300, axw = 300
)

HondurasCSS.effectslegend!(lll[2, 1], true, true, false; tr = 0.6)
resize_to_layout!(fg)
resize!(fg, 900, 400)

# rowsize!(lll, 1, Relative(2/3.5))

rowgap!(lll, -100)
fg

#%%

let fg = fg
    short_caption = "Effect of the pair living in the same building on accuracy"
	caption = "Effect of the pair living in the same building on accuracy with respect to accuracy in network cognition. LHS: Grey bands that surround the effect estimates represent bootstrapped 95% confidence ellipses. RHS: Bands represent 95% confidence intervals (see Methods for details)."

	figure_export(
		"honduras-css-paper/figures_si/SI Figure result same building.svg",
		fg,
		save2;
		caption,
        short_caption,
        # kind = Symbol("image-si"),
        # supplement = "*Supplementary Figure*",
		outlined = true,
	)
end
