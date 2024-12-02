# SI Figure distribution responses.jl

include("../../code/setup/environment.jl")

rgp = load_object("objects/respondent_acc.jld2")

rts = [:tpr, :fpr, :j]

fg = Figure();
los = [GridLayout(fg[i, 1]) for i in eachindex(rts)];
axs = [Axis(los[i][1, 1], xlabel = (uppercase∘string)(rts[i])) for i in eachindex(rts)]

for (r, ax) in zip(rts, axs)
    x1, x2 = quantile(rgp[!, r], [0.2, 0.8])
    vspan!(ax, x1, x2, color = (yale.grays[3], 0.5))
    hist!(ax, rgp[!, r]; color = (ratecolor(r), 0.8), bins = 50)
    vlines!(ax, mean(rgp[!, r]); color = (:black, 0.5), linestyle = :dash)
    ylims!(ax, low = 0)
end
rowsize!(fg.layout, 1, Relative(1/3))
rowsize!(fg.layout, 2, Relative(1/3))
linkxaxes!(axs[1], axs[2])
labelpanels!(los)
rowgap!(fg.layout, -20)
resize_to_layout!(fg)
resize!(fg, 600, 600)
fg

save(
    "honduras-css-paper/Figures (SI)/SI Figure distribution responses.png",
    fg; px_per_unit = 2.0
)

let fg = fg
    short_caption = "Univariate distributions of respondent-level accuracy."
	caption = "Univariate distributions of respondent-level accuracy, for judgements of ties between non-kin. *(a)* TPR, *(b)* FPR, and *(c)* \$J\$. Dotted lines represent the distribution means, and the gray vertical spans represent the 20th and 80th percentiles of the distributions. We see the narrowest range of variation in the TPR, where subjects are effective in identifying relationships that do exist. However, we see both greater variation, with a similar average ability to correctly identify ties that do not exist (The average TPR stands at around 0.65, and the TNR at under 0.7). Ultimately, we see that the combined accuracy measure (\$J\$) has a mean value closer to chance performance (\$J=0\$) than to perfect accuracy (\$J=1\$), at less than 0.4. The cognizer-level predictions represent model-adjusted averages at the respondent-level and averaged across _free time_ and _personal private_."

	figure_export(
		"honduras-css-paper/Figures (SI)/SI Figure distribution responses.svg",
		fg,
		save2;
		caption,
        short_caption,
		outlined = true,
	)
end
