# SI Figure results dunbar.jl

margindict = load_object(
    "interaction models/margindict_dunbar.jld2"
)

e = :dunbar;
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
lhist = fg[2,1:2] = GridLayout();

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

rowsize!(fg.layout, 1, Relative(2/3.5))
resize!(fg, 900, 750)
resize_to_layout!(fg)

# rowsize!(lll, 1, Relative(2/3.5))

df = unique(dat[!, [:village_code, :population]])

ax_ = Axis(lhist[1,1], xlabel = "Village size", ylabel = "Count")
hist!(ax_, df.population)
vlines!(ax_, [150], color = oi[2])
vlines!(ax_, mean(df.population), color = :black)

rowgap!(lll, -130)
labelpanels!([ll, lhist]; lbs = :lowercase)
fg

#%%

let fg = fg
    short_caption = "Effect of village size above or below 150"
	caption = "(a) Effect of village size above or below Dunbar's number with respect to accuracy in network cognition. LHS: Grey bands that surround the effect estimates represent bootstrapped 95% confidence ellipses. RHS: Bands represent 95% confidence intervals (see Methods for details). (b) Distribution of village sizes, with Dunbar's number (150) (yellow line) and average size (black line)."

	figure_export(
		"honduras-css-paper/figures_si/SI Figure results dunbar.svg",
		fg,
		save2;
		caption,
        short_caption,
        # kind = Symbol("image-si"),
        # supplement = "*Supplementary Figure*",
		outlined = true,
	)
end

contrast_table(e, additions, dats, m, pbs, iters, invlink)
