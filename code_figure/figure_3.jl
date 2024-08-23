# figure 3 science

# %%

include("../code/environment.jl");

md = load_object("objects/base1_tie2_margins_bs_out.jld2");
transforms = load_object("objects/variable_transforms.jld2");
wd = load_object("objects/wealth_interaction.jld2");

# %%

# dists_p
# dists_a

vars = [
    :relation, :man_a, :degree_mean_a,
    :religion_c_a, :wealth_d1_4_diff_a, :wealth_d1_4_mean_a,
    #:dists_p, :dists_a,
];

# vars_supp = [:religion_c, :isindigenous];

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
	end

	#labelpanels!(los; lbs = :uppercase)
end


fg4 = let fg = Figure(), vars = vars
    lo1 = fg[1, 1] = GridLayout()
    lo = GridLayout(lo1[1:2, 1:3])
    
    lo2 = GridLayout(fg[2, 1])
    lo2a = GridLayout(lo2[1, 1])
    lo2b = GridLayout(lo2[1, 2])
    #colsize!(lo2, 1, Relative(2/3))
	
    los = GridLayout[];
	cnt = 0
	for i in 1:2
		for j in 1:3
			cnt+=1
			if cnt <= length(vars)
				l = lo[i, j] = GridLayout()
				push!(los, l)
			end
		end
	end
	figure4!(los, vars, md)

    los = GridLayout[];
	cnt = 0
	for i in 1:2
		for j in 1:3
			cnt+=1
			if cnt <= length(vars)
				l = lo[i, j] = GridLayout()
				push!(los, l)
			end
		end
	end
	# figure4!(los, vars, md)
    # colsize!(los[i], 1, Relative(1/2))
    # colgap!(los[i], -40)

    los2 = [GridLayout(lo2a[1,1]), GridLayout(lo2a[1,2])]
    figure4!(los2, [:dists_p, :dists_a], md)

    vt = :wealth_d1_4_mean_a
    vk = :wealth_d1_4
    ##
    su = sunique(wd[!, vt]);
    mt = fill(NaN, length(su), length(su));
    for (i, e) in enumerate(su), (j, f) in enumerate(su)
        ix = findfirst((wd[!, vt] .== e) .& (wd[!, vk] .== f))
        mt[i,j] = wd[!, :j][ix]
    end
    
    ax = Axis3(
        lo2b[1, 1];
        xlabel = "Pair wealth (mean)", ylabel = "Cognizer wealth",
        zlabel = "J",
        height = 375
        # width =300
    )
    sp = wireframe!(ax, su, su, mt; color = ratecolor(:j))

    labelpanels!([lo1, lo2a, lo2b])

	resize!(fg, 1600, 1200)
	resize_to_layout!(fg)
	fg
end

##

save("figures/figure_3.png", fg4; px_per_unit = 2.0)
