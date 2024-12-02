# SI Figures distances.jl

using Random
Random.seed!(2023)

include("../../code/setup/environment.jl")

cr = JLD2.load_object(datapath * "cr_" * "2024-05-01" * ".jld2");
code_variables!(cr);

ndf4 = JLD2.load_object(datapath * "network_info_" * dte * ".jld2");
@subset! ndf4 (:wave .== 4)

ndf4.dists = [Float64[] for _ in eachindex(ndf4.graph)];
for (i, g) in enumerate(ndf4.graph)
    dm = fill(Inf, nv(g), nv(g));
    for v in 1:nv(g)
        gdistances!(g, v, @views(dm[v, :]))
    end
    ds = ndf4.dists[i]
    for i in 1:size(dm,1), j in 1:size(dm, 1)
        if j > i
            append!(ds, dm[j,i])
        end
    end
end

ndf4.dists = [(collect(sai(x)), sum(isinf.(x))) for x in ndf4.dists];

ndf4_ft = @subset ndf4 :relation .== rl.ft;
ndf4_pp = @subset ndf4 :relation .== rl.pp;

dsft = reduce(vcat, [x[1] for x in ndf4_ft.dists]);
dspp = reduce(vcat, [x[1] for x in ndf4_pp.dists]);

mean(dsft)
mean(dspp)

mean(vcat(dsft, dspp))

quantile(dsft)

function tiedistances_plot(
    css, dsft, dspp; fg = Figure(resolution = (700, 900)), bins = 10
)

    los = []
    for i in 1:4
        lo = fg[i, 1] = GridLayout()
        push!(los, lo)
    end
    
    scr = select(css, [:perceiver, :relation, :dists_p, :dists_a]);
    d_p = scr.dists_p[scr.dists_p .> 0];
    d_a = scr.dists_a[scr.dists_a .> 1];

    ax1 = los[3][1,1] = Axis(
        fg; ygridvisible = false, xgridvisible = false,
        xlabel = "Cognizer-to-tie", backgroundcolor = :transparent
    )
    ax2 = los[4][1, 1] = Axis(
        fg; ygridvisible = false, xgridvisible = false,
        xlabel = "Alter-to-alter", backgroundcolor = :transparent
    )
    ax3 = los[1][1,1] = Axis(
        fg; ygridvisible = false, xgridvisible = false,
        backgroundcolor = :transparent,
        xlabel = "Villager-to-villager (free time)"
    )
    ax4 = los[2][1,1] = Axis(
        fg; ygridvisible = false, xgridvisible = false,
        backgroundcolor = :transparent,
        xlabel = "Villager-to-villager (personal private)"
    )
    
    mx = max(maximum(d_p), maximum(d_a))

    vshd = 0.3

    for (d, ax) in zip([d_p, d_a], [ax1, ax2])
        vspan!(ax, quantile(d, [0.2, 0.8])...; color = (oi[2], vshd))
        hist!(ax, d, color = (wc[1], 0.70); bins = bins)
        vlines!(ax, mean(d); color = :black)
        xlims!(ax, 1, mx)
    end

    for (d, cl, ax) in zip([dsft, dspp], [wc[3], wc[4]], [ax3, ax4])
        vspan!(ax, quantile(d, [0.2, 0.8])...; color = (oi[2], vshd))
        hist!(ax, d, color = (cl, 0.50); bins = bins)
        vlines!(ax, mean(d); color = :black)
        xlims!(ax, 1, mx)
    end

    for a in [ax1, ax2, ax3, ax4]
        ylims!(a, low = 0)
    end
    
    labelpanels!(los)

    return fg
end

@inline vred(x) = reduce(vcat, x)

function netstats1_plot(
    ndf4; fg = Figure(resolution = (700, 850))
)
    # unstandardized
    ndf4.density = [density(g) for g in ndf4.graph];
    ndf4.degree_centrality_raw = [degree_centrality(g, normalize = false) for g in ndf4.graph];
    
    vrs = [:degree_centrality_raw, :density];
    xa = @chain ndf4 begin
       groupby(:relation)
       combine([x => Ref∘vred for x in vrs], renamecols = false)
    end
    
    lx = fg[1,1:3] = GridLayout()
    los = [lx[1,i+1] = GridLayout() for i in 1:2];
    l1 = fg[:,1]

    mx = 0
    for (i, r) in (enumerate∘eachrow)(xa)
        for (j, e) in enumerate([:degree_centrality_raw, :density])
            ax = los[j][i,1] = Axis(fg)
            vlf = r[e]
            mx = max(mx, maximum(vlf))
            vlf = vlf[vlf .< 20] # filter bad values?

            hist!(ax, vlf, bins = 30)
            for (ls, vl) in zip([:dash, :solid], [median(vlf), mean(vlf)])
                vlines!(ax, vl, linestyle = ls, color = [:black, :black])
            end

        end
        rr = replace(unwrap.(r[:relation]), "_" => " ")
        Label(l1[i,0], rr, rotation = pi/2, tellheight = false)
    end
    labelpanels!(los)

    colsize!(lx, 1, Relative(1/25))

    # cap = "Distribution of (A) degree centrality (unstandardized). The solid lines represent the average distance, and the dashed lines represent the median. Degree centrality values above 20 are removed from the distribution, however values as high as high as " * string(mx) * " exist (in 'any' network), but seems like an error?. (B) Distribution of network density (unstandardized). We observe that density is *low* across even the most liberal network definitions."
    # if saveplot
    #     savemdfigure(prj.pp, prj.css, "centrality-density", cap, fg)
    # end
    
    return fg
end

#%% Distribution of geodesic distances
@inline save2(name, fg) = save(name, fg; pt_per_unit = 2)
fg1 = tiedistances_plot(cr, dsft, dspp; bins = 15);

let fg = fg1
    short_caption = "Distribution of geodesic distances."
	caption = "Distribution of geodesic distances. The yellow regions represent the 20th and 80th percentiles of the distribution around the mean geodesic distance (black line). Distances in the the underlying (a) _free time_ (green) and (b) _personal private_ (fuchsia) networks. (c) Distances from the cognizer to the alter in the pairs presented to respondents. (d) Distances between the individuals in the pairs presented to the respondents, when the ground truth tie does not exist."

	figure_export(
		"honduras-css-paper/Figures (SI)/SI Figure distribution distances.svg",
		fg,
		save2;
		caption,
        short_caption,
		outlined = true,
	)
end

#%% empirical CDF

ec = (ft = ecdf(dsft), pp = ecdf(dspp), c = (ecdf∘vcat)(dsft, dspp));

1 - ec.c(8)

fgcdf = Figure();
l1 = fgcdf[1,1] = GridLayout();

ax1 = Axis(
    l1[1,1]; ygridvisible = false, xgridvisible = false,
    xlabel = "Cognizer-tie distance", backgroundcolor = :transparent
)

for ax in [ax1]; vlines!(ax, [8], color = :black, linestyle = :dot) end

x = minimum(ec.ft):0.1:maximum(ec.ft);
y = [ec.ft(i) for i in x];
lines!(ax1, x, y, color = oi[1]; label = "free time")

x = minimum(ec.pp):0.1:maximum(ec.pp);
y = [ec.pp(i) for i in x];
lines!(ax1, x, y, color = oi[2]; label = "personal private")

resize_to_layout!(fgcdf)

ylims!(ax1, low = 0, high = 1.01)

axislegend(ax1, "Relationship"; position = :rb, framevisible = false)

ec8 = (ft = round(1 - ec.ft(8); digits = 3) * 100,
pp = round(1 - ec.pp(8); digits = 3) * 100)

let fg = fgcdf
    short_caption = "Empirical CDFs of cognizer-tie distance"
	caption = "Empirical CDFs of cognizer-tie distance for (a) _free time_ and (b) _personal private_ relationships. We observe that 12.3% of _free time_ and 8.0% of _personal private_ ties presented are 8 degrees or more (dotted line) away from the survey respondents."

	figure_export(
		"honduras-css-paper/Figures (SI)/SI Figure distances cdf.svg",
		fg,
		save2;
		caption,
        short_caption,
		outlined = true,
	)
end

#%%
netstats1_plot(ndf4)
