# figure_rates_diagram.jl

include("../../environment.jl")

#%%
# data
md = load_object("objects/base1_tie2_margins.jld2");
transforms = load_object("objects/variable_transforms.jld2");
addΣ!(md);

e = :degree
rg, margvarname = md[e]
bpd = (
    rg = rg, margvar = e, margvarname = margvarname,
    tnr = true, jstat = true
);

rg = @subset md[e].rg .!:kin431

#%%
fg = Figure();
l_diagram = fg[1, 1]

let
    l1 = GridLayout(l_diagram[1, 1]);

    pts = Point2f.(rg.fpr, rg.tpr)

    ax1 = Axis(
        l1[1, 1];
        ylabel = "True positive rate", xlabel = "False positive rate",
        height = 250, width = 250
    )
    HondurasCSS.chanceline!(ax1);
    HondurasCSS.improvementline!(ax1);
    scatter!(ax1, pts, markersize = 3, color = yale.grays[3])

    ylims!(ax1, 0, 1)
    xlims!(ax1, 0, 1)

    ##
    θ = -π/4;
    ptst = Point2f.([HondurasCSS.rotation(θ) * pt for pt in pts])

    l2 = GridLayout(l_diagram[1, 2]);
    ax2 = Axis(
        l2[1,1];
        ylabel = "Performance", xlabel = "Tradeoff",
        height = 250, width = 250
    )
    hidespines!(ax2)

    vlines!(ax2, [0.601, 0.799]; ymin = 0.0, ymax = 1, linestyle = :dash, color = (yale.accent[1], 0.9))
    hlines!(ax2, [0.2001, .399]; linestyle = :dot, color = (yale.grays[1], 0.9))

    scatter!(ax2, ptst, markersize = 3, color = yale.grays[3])

    xt = [pt[1] for pt in ptst]
    yt = [pt[2] for pt in ptst]

    xtmn, xtmx = extrema(xt)
    ytmn, ytmx = extrema(yt)

    ys = ytmn:0.0001:ytmx
    lines!(ax2, fill(xtmx, length(ys)), ys; color = columbia.blues[1])
    # lines!(ax2, fill(xtmn, length(ys)), ys; color = columbia.blues[1], linestyle = :dash)

    xs = xtmn:0.0001:xtmx
    lines!(ax2, xs, fill(ytmn, length(xs)); color = yale.accent[2])
    # lines!(ax2, xs, fill(ytmx, length(xs)); color = yale.accent[2], linestyle = :dash)

    ylims!(ax2, 0.2, 0.4)
    xlims!(ax2, 0.6, 0.8)
end

labelpanels!([l1, l2])
resize_to_layout!(fg)
fg

save("honduras-css-paper/figures/decomposition.png", fg)
