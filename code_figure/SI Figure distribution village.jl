# SI Figure distribution village.jl

include("../../code/setup/environment.jl")

rgv = load_object("objects/village_acc.jld2")

@subset! rgv :relation .== "free_time"

@inline unitize(a, mn, mx) = (a - mn) * inv(mx - mn)

let
    a, b = extrema(rgv.j)
    rgv.j_stand = unitize.(rgv.j, a, b)
end

rgv = @subset(rgv, :relation .== "free_time")
rgv.color = [(berlin[e], 0.8) for e in rgv.j_stand];

fg = Figure();
l1 = GridLayout(fg[1,1])
l2 = GridLayout(fg[2,1])
let
    ax = Axis(l1[1,1], ylabel = "TPR", xlabel = "FPR")
    scatter!(
        ax,
        rgv.fpr, rgv.tpr; color = :transparent, strokewidth = 1,
        strokecolor = rgv.color
    )
    Colorbar(l1[1,2], colormap = :berlin, label = "J")
    axh = Axis(l2[1, 1:2], xlabel = "J");
    hist!(axh, rgv.j, color = (ratecolor(:j), 0.75); bins = 20)
    resize_to_layout!(fg)
    rowsize!(fg.layout, 2, Relative(1/3))
    rowgap!(fg.layout, 0)
    ylims!(axh, low = 0)
    labelpanels!([l1, l2]; lbs = :lowercase)
end
fg

@inline save2(name, fg) = save(name, fg; pt_per_unit = 2)

let fg = fg
    short_caption = "Village level accuracy, _free time_"
	caption = "Village level accuracy, _free time_. *(a)* Bivariate distribution of social network accuracy at the village level. We see that the villages-level averages exhibit a positive correlation between type 1 and type 2 error rates. *(b)* univariate distribution of the \$J\$ statistic. In general, villages fall into a relatively narrow range, implying that most of the variation stems from individuals rather than whole village populations. Village-level predictions represent model-adjusted averages at the respondent-level, for judgements of non-kin ties."

	figure_export(
		"honduras-css-paper/Figures (SI)/village_dist.svg",
		fg,
		save2;
		caption,
        short_caption,
        # kind = Symbol("image-si"),
        # supplement = "*Supplementary Figure*",
		outlined = true,
	)
end
