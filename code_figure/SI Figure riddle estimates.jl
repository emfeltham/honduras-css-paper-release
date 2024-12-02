# figure_riddle_riddle.jl
#=
SI figure to represent the estimates for each riddle,
marginalizing over the rates (recall, there are no interactions in the model)
=#

include("../../code/setup/environment.jl")

rgr, xfr = load_object("objects/riddle_riddle_data.jld2");

rgr[:tpr]

for (i, (df, r)) in (enumerate∘zip)(rgr, [:tpr, :fpr, :j])
    df[!, :metric] .= r
    df[!, :metric_num] .= i # to sort in desired order on rate
end

rg = reduce(vcat, rgr)
sort!(rg, [:riddle, :metric_num])

#%%

fg = Figure();
l1 = GridLayout(fg[1, 1]);

ax = Axis(l1[1, 1], ylabel = "Riddle", xlabel = "Riddle knowledge", yticksvisible = false)

for (i, r) in (enumerate∘eachrow)(rg)
    scatter!(ax, r.knows, i; color = ratecolor(r.metric), label = r.metric)
end

rangebars!(
    ax,
    (collect∘eachindex)(rg.metric), rg.lower, rg.upper;
    color = ratecolor.(rg.metric),
    direction = :x
)

hlines!(ax, [3.5, 6.5], color = (yale.grays[2], 0.8), linewidth = 1)

tc = fill("", nrow(rg))
tc[2] = "Umbilical cord care"
tc[5] = "Prenatal care"
tc[8] = "Zinc usage"

ax.yticks = (1:nrow(rg), tc)

elem = [MarkerElement(marker = :circle, color = ratecolor(rc)) for rc in [:tpr, :fpr, :j]]

Legend(
    fg[2, 1], elem, ["TPR", "FPR", "J"], "Accuracy",
    tellwidth = false, framevisible = false,
    orientation = :horizontal
)

let fg = fg
    short_caption = "Riddle estimates"
	caption = "Riddle estimates. In Fig. 5b, we estimate the relationship between knowledge of exogenously introduced health information and social network accuracy. We present the riddle knowledge effect estimates for each riddle, from the three separate models (for each accuracy metric), from the average accuracy value in the population of survey respondents. The estimates for each riddle are relatively similar. Bars represent 95% confidence intervals, bootstrapped to incorporate uncertainty at both stages of estimation."

	figure_export(
		"honduras-css-paper/Figures (SI)/SI Figure riddle estimates.svg",
		fg,
		save2;
		caption,
        short_caption,
		outlined = true,
	)
end
