# Figure cognizer OLD.jl
#=
Determinants of perceiver accuracy.
=#

include("../../code/setup/environment.jl");

dataloc = "honduras-css-paper/objects/";
md = load_object(datalpc * "base1_tie2_margins_bs_out.jld2")
transforms = load_object(dataloc * "variable_transforms.jld2")

#%% setup
vars = [:man, :age, :educated, :wealth_d1_4, :degree];
vars_supp = [:religion_c, :isindigenous];

# back-transform relevant cts. variables
for e in [:age, :degree]
	md[e].rg[!, e] = reversestandard(md[e].rg, e, transforms)
end

e = :man
md[e].rg[!, e] = replace(
	md[e].rg[!, e], true => "Man", false => "Woman"
) |> categorical

e = :isindigenous
md[e].rg[!, e] = replace(
	md[e].rg[!, e], true => "Indigenous", false => "Mestizo"
) |> categorical

function figure3!(los, vars, md)
	for (i, e) in enumerate(vars)
		rg, margvarname = md[e]
		tp = (
			rg = rg, margvar = e, margvarname = margvarname,
			tnr = true, jstat = true
		);
		biplot!(los[i], tp)
	end

	labelpanels!(los)
end

fg3 = let fg = Figure(), vars = vars
	lo = GridLayout(fg[1:3, 1:2], width = 950*2)
	los = GridLayout[];
	cnt = 0
	for i in 1:3
		for j in 1:2
			cnt+=1
			if cnt <= length(vars)
				l = lo[i, j] = GridLayout()
				push!(los, l)
			end
		end
	end
	figure3!(los, vars, md)
	resize!(fg, 1000 * 2, 400 * 3)
	resize_to_layout!(fg)
	fg
end

let fg = fg3
	filename = "honduras-css-paper/figures/figure_cognizer"
	short_caption = "Individual determinants of respondent accuracy"
	caption = "Individual determinants of respondent accuracy. We observe that several key demographic characteristics are associated with an individual's ability to accurately predict the ties in their village network. In each panel, the left-hand image shows the marginal effect of the cognizer characteristic on accuracy in ROC-space (grey shading represents the 95% bootstrapped confidence ellipse of the predictions from the two models), and the right-hand image shows the marginal effect with respect to each individual accuracy measure: the true positive rate, false positive rate, and the overall summary measure of accuracy (Youden's \$J\$). Intervals represent 95% confidence levels, calculated via normal approximation for the two rates, and bootstrapped for the \$J\$ statistic. *(a)* Gender, *(b)* Age, *(c)* Education, *(d)* Wealth and *(e)* Network degree (here, effectively an average of the count of first-degree neighbors for the two relationships analyzed, personal-private or free-time). Figure S11 presents additional characteristics."

	save(filename * ".png", fg; px_per_unit=2.0, background_color = :transparent)

	figure_export(
		filename * ".svg",
		fg,
		save2;
		caption,
		short_caption,
		outlined = true,
	)
end
