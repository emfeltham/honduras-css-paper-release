# identity_figure.jl

#%%
include("../../code/setup/environment.jl")

dataloc = "honduras-css-paper/objects/";
md = load_object(dataloc * "base1_tie2_margins_bs_out.jld2");
transforms = load_object(dataloc * "variable_transforms.jld2");
wd = load_object(dataloc * "wealth_interaction.jld2");

#%%
vars = [
    :religion_c_a, :isindigenous_a, :wealth_d1_4_diff_a, :wealth_d1_4_mean_a
];

function figure5!(los, vars, md)
	for (i, e) in enumerate(vars)
		rg, margvarname = md[e]
		tp = (
			rg = rg, margvar = e, margvarname = margvarname,
			tnr = true, jstat = true
		);
		biplot!(los[i], tp)
	end
end

fg5 = let fg = Figure(), vars = vars
    lo = GridLayout(fg[1:6, 1:2], width = 950*2)
	los = GridLayout[];
	cnt = 0
	for i in 1:4
		for j in 1:2
			cnt+=1
			if cnt <= length(vars)
				l = lo[i, j] = GridLayout()
				push!(los, l)
			end
		end
	end
	figure5!(los, vars, md)

    ##
    vt = :wealth_d1_4_mean_a
    vk = :wealth_d1_4
    
    l1 = lo[3, 1] = GridLayout()
    push!(los, l1)
    l1a = GridLayout(l1[1, 1])
    l1b = GridLayout(l1[1, 2])

    yvar = (var = :tpr, name = "TPR", )
    interaction_wealth!(l1a, wd, yvar, vt, vk)
    yvar = (var = :fpr, name = "FPR", )
    interaction_wealth!(l1b, wd, yvar, vt, vk)

    ##
    su = sunique(wd[!, vt]);
    mt = fill(NaN, length(su), length(su));
    for (i, e) in enumerate(su), (j, f) in enumerate(su)
        ix = findfirst((wd[!, vt] .== e) .& (wd[!, vk] .== f))
        mt[i,j] = wd[!, :j][ix]
    end
    
    l2 = GridLayout(lo[3, 2])
    push!(los, l2)
    ax = Axis3(
        l2[1, 1];
        xlabel = "Pair wealth (mean)", ylabel = "Cognizer wealth",
        zlabel = "J",
        height = 375
        #width =300
    )
    sp = wireframe!(ax, su, su, mt; color = ratecolor(:j))

    ##
    labelpanels!(los)
	resize!(fg, 1000 * 2, 400 * 3)
	resize_to_layout!(fg)
	fg
end

let fg = fg5
    filename = "honduras-css-paper/figures/figure_identity"
    short_caption = "Tie social identity determinants of respondent accuracy"
	caption = "Tie social identity determinants of respondent accuracy. We find that characteristics related to the social identity of a pair of individuals (\$i\$ and \$j\$) affects how well that tie is conceived of by individuals \$k\$. *(a-d)* LHS, marginal effects on accuracy in ROC-space. Grey shading represents the 95% bootstrapped confidence ellipse of the predictions from the two models. RHS, marginal effect of each individual accuracy measure: the true positive and false positive rates and the summary measure, Youden's \$J\$. Intervals represent 95% confidence levels, calculated via normal approximation for the two rates, and bootstrapped for \$J\$. *(a)* Religion combination of tie members. *(b)* Indigenous status of the pair. Parameters are fit from separate models of each rate, conditional on tie verity in the reference network. *(c)* Absolute difference in wealth between the tie members. *(d)* Average wealth of the tie members. *(e)* Interaction between the average wealth of a pair and the cognizer's wealth on the (LHS) TPR and (RHS) FPR. *(f)* Interaction between the average wealth of a pair and the cognizer's wealth on the summary measure, \$J\$. See Methods for details of model specification."

    save(
        filename * ".png", fg;
        px_per_unit=2.0, background_color = :transparent
    )

	figure_export(
		filename * ".svg",
		fg,
		save2;
		caption,
        short_caption,
		outlined = true,
	)
end
