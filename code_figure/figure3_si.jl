# figure 3 si

# %%

include("../../code/setup/environment.jl");

md = load_object("objects/base1_tie2_margins_bs_out.jld2")
transforms = load_object("objects/variable_transforms.jld2")
wd = load_object("objects/wealth_interaction.jld2");

# %%

vars = [:religion_c, :isindigenous];

# back-transform relevant cts. variables
for e in [
	:age_mean_a, :age_diff_a,
	:degree_mean_a,
	:dists_p, :dists_a
]
	md[e].rg[!, e] = reversestandard(md[e].rg, e, transforms)
end

let e = :relation
    md[e].rg[!, e] = replace(
		md[e].rg[!, e],
		"free_time" => "Free time", "personal_private" => "Personal private"
	) |> categorical
end

# plot at the mean TPR prediction over the dist_p range
let
    tprbar = mean(md[:dists_p].rg[md[:dists_p].rg.dists_p_notinf .== true, :tpr])
    md[:dists_a].rg.tpr .= tprbar
end

function figure4!(los, vars, md)
	for (i, e) in enumerate(vars)
		rg, margvarname = md[e]
		tp = (
			rg = rg, margvar = e, margvarname = margvarname,
			tnr = true, jstat = true
		);
		# biplot!(los[i], tp)

        if tp.margvar ∉ [:dists_p, :dists_a, :are_related_dists_a]
            rocplot!(
                los[i],
                tp.rg, tp.margvar, tp.margvarname;
                markeropacity = 0.8,
                kinlegend = true,
                dolegend = true
            )
        else
            distance_roc!(
                los[i],
                tp.rg, tp.margvar, tp.margvarname
            )
        end
        colsize!(los[i], 1, Relative(1/2))
        colgap!(los[i], -200)
	end

	#labelpanels!(los; lbs = :uppercase)
end

fg4 = let fg = Figure(), vars = vars
    lo1 = fg[1, 1] = GridLayout()
    lo = GridLayout(lo1[1, 1:2])
	
    los = GridLayout[];
	cnt = 0
	for i in 1:1
		for j in 1:2
			cnt+=1
			if cnt <= length(vars)
				l = lo[i, j] = GridLayout()
				push!(los, l)
			end
		end
	end
	figure4!(los, vars, md)

	resize!(fg, 1000, 400)
	resize_to_layout!(fg)
	fg
end
fg4
##

@inline save2(name, fg) = save(name, fg; pt_per_unit = 2)

let fg = fg4
	caption = "Additional individual determinants of respondent accuracy. In each panel, the lefthand image shows the marginal effect on accuracy in ROC-space (grey shading represents the 95% bootstrapped confidence ellipse of the predictions from the two models), and the righthand image shows the marginal effect of each individual accuracy measure: the true positive rate, false positive rate, and the overall summary measure of accuracy (Youden’s \$J\$). Intervals represent 95% confidence levels, calculated via normal approximation for the two rates, and bootstrapped for the \$J\$ statistic. Religion and indigenous status are shown."

	figure_export(
		"honduras-css-paper/figures_si/figure3_si_s.svg",
		fg,
		save2;
        short_caption = "Additional individual determinants of respondent accuracy.",
		caption,
        # supplement = "Supplementary Figure",
        # kind = Symbol("image-si")
	)
end
