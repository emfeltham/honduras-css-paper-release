# Figure 4.jl

include("../../code/setup/environment.jl");

dataloc = "honduras-css-paper/objects/";
md = load_object(dataloc * "base1_tie2_margins_bs_out.jld2");
transforms = load_object(dataloc * "variable_transforms.jld2");
wd = load_object(dataloc * "wealth_interaction.jld2");

#%%
fg = Figure();
make_figure4!(fg, md, wd, transforms)
resize!(fg, 1600, 1200)
resize_to_layout!(fg)
fg

#%%
let fg = fg
	filename = "honduras-css-paper/Figures (main)/Figure 4"
	short_caption = "Tie determinants of respondent accuracy"
	caption = typst"Tie determinants of respondent accuracy. *(a)* We find that a range of properties of ties have statistically significant associations with their tendency to be accurately conceived. In each panel, the marginal effect on accuracy in ROC-space is shown. Grey shading represents the 95% bootstrapped confidence ellipse of the predictions from the two models. Estimates are stratified by whether they are of a tie among kin or not. *(b)* Network distances. Cognizer-to-tie geodesic distance. Individuals may or may not have a defined path between them in the reference network; when there is a path, individuals exist at a geodesic distance defined as the minimum number of steps between them; note that individuals who do not have a path between them necessarily have a path in at least one of other networks considered in this study, by design. Within-tie distance. When a direct tie does not exist between two individuals, a specific geodesic distance may separate them (or they may have no path between them in the network). The TPR is set to the population average; but it does not have a meaningful interpretation in assessments of ties that do not exist. Parameters are fit from separate models of each rate, conditional on tie verity in the reference network (see Methods for details). *(c)* Interaction between the average wealth of a pair and the cognizer's wealth on the summary measure, $J$ (see Methods for details)."

	save(
		filename * ".png", fg;
		px_per_unit = 2.0, background_color = :transparent
	)

	figure_export(
		filename * ".svg",
		fg,
		save2;
		short_caption,
		caption,
		outlined = true,
	)
end
