# SI Figure diagram decomposition

include("../../code/setup/environment.jl")

md = load_object("objects/base1_tie2_margins_bs_out.jld2");
transforms = load_object("objects/variable_transforms.jld2");

#%% make figure
fg_diagram = Figure();
l_diagram1 = GridLayout(fg_diagram[1,1:2]);
l_diagram2 = GridLayout(fg_diagram[2,1:2]);

dwidth = 250
dheight = 250

# diagram panel
let l_diagram = l_diagram1
    e = :degree
    rg, margvarname = md[e]
    bpd = (
        rg = rg, margvar = e, margvarname = margvarname,
        tnr = true, jstat = true
    );
    
    rg = @subset md[e].rg .!:kin431
    
    l1 = GridLayout(l_diagram[1, 1]);
    l2 = GridLayout(l_diagram[1, 2]);

    pts = Point2f.(rg.fpr, rg.tpr)

    ax1 = Axis(
        l1[1, 1];
        ylabel = "True positive rate", xlabel = "False positive rate",
        height = dheight, width = dwidth
    )
    HondurasCSS.chanceline!(ax1);
    HondurasCSS.improvementline!(ax1);
    lines!(ax1, pts, linewidth = 5, color = yale.grays[2])

    ylims!(ax1, 0, 1)
    xlims!(ax1, 0, 1)

    ##
    θ = -π/4;
    ptst = Point2f.([HondurasCSS.rotation(θ) * pt *sqrt(2) for pt in pts])

    ax2 = Axis(
        l2[1,1];
        ylabel = "J", xlabel = "Positive predictive bias",
        height = dheight, width = dwidth
    )

    vlines!(ax2, 1, color = (:black, 0.75), linestyle = :dash)
    lines!(ax2, ptst, linewidth = 5, color = (yale.grays[2], 0.75))

    xt = [pt[1] for pt in ptst]
    yt = [pt[2] for pt in ptst]

    xtmn, xtmx = extrema(xt)
    ytmn, ytmx = extrema(yt)

    lines!(
        ax2,
        LinRange(xtmn, xtmx, 80), LinRange(ytmn, ytmx, 80);
        color = (columbia.secondary[2], 1), linestyle = :dash,
        linewidth = 5
    )

    ys = ytmn:0.0001:ytmx
    lines!(
        ax2, fill(xtmx, length(ys)), ys;
        color = (columbia.blues[1], 0.9),
        linewidth = 5
    )

    xs = xtmn:0.0001:xtmx
    lines!(
        ax2, xs, fill(ytmn, length(xs));
        color = (yale.accent[2], 0.9),
        linewidth = 5
    )

    l1, l2
end

let l_diagram = l_diagram2
    # diagram panel
    e = :age
    rg, margvarname = md[e]
    bpd = (
        rg = rg, margvar = e, margvarname = margvarname,
        tnr = true, jstat = true
    );

    rg = @subset md[e].rg .!:kin431

    l1 = GridLayout(l_diagram[1, 1]);
    l2 = GridLayout(l_diagram[1, 2]);

    pts = Point2f.(rg.fpr, rg.tpr)

    ax1 = Axis(
        l1[1, 1];
        ylabel = "True positive rate", xlabel = "False positive rate",
        height = dheight, width = dwidth
    )
    HondurasCSS.chanceline!(ax1);
    HondurasCSS.improvementline!(ax1);
    lines!(ax1, pts, linewidth = 5, color = yale.grays[2])

    ylims!(ax1, 0, 1)
    xlims!(ax1, 0, 1)

    ##
    θ = -π/4;
    ptst = Point2f.([HondurasCSS.rotation(θ) * pt * sqrt(2) for pt in pts])

    ax2 = Axis(
        l2[1, 1];
        ylabel = "J", xlabel = "Positive predictive bias",
        height = dheight, width = dwidth
    )

    vlines!(ax2, 1, color = (:black, 0.75), linestyle = :dash)
    lines!(ax2, ptst, linewidth = 5, color = (yale.grays[2], 0.75))

    xt = [pt[1] for pt in ptst]
    yt = [pt[2] for pt in ptst]

    xtmn, xtmx = extrema(xt)
    ytmn, ytmx = extrema(yt)

    ymaxx = xt[findmax(yt)[2]]
    
    lines!(
        ax2,
        LinRange(ymaxx, xtmx, 80), LinRange(ytmx, ytmn, 80);
        color = (columbia.secondary[2], 1), linestyle = :dash,
        linewidth = 5
    )

    ys = ytmn:0.0001:ytmx
    lines!(
        ax2, fill(ymaxx, length(ys)), ys;
        color = (columbia.blues[1], 0.9),
        linewidth = 5
    )

    xs = xtmn:0.0001:xtmx
    lines!(
        ax2, xs, fill(ytmn, length(xs));
        color = (yale.accent[2], 0.9),
        linewidth = 5
    )
end
    
labelpanels!([l_diagram1, l_diagram2])
resize!(fg_diagram, 700, 700)
resize_to_layout!(fg_diagram)

fg_diagram

#%%
let fg = fg_diagram
	caption = typst"Decomposition of accuracy. We represent the change in performance and the tradeoff in errors to summarize the relationship between the attributes of the cognizers (_e.g._, the network degree of $k$), and the presented pairs (_e.g._, the average age of $i$ and $j$), we examine the extent to which change across the range of values of that attribute represents a genuine change in performance or simply a tradeoff between the two error rates. Specifically, conduct a change of basis of the ROC-space plot for each attribute, by rotating and rescaling, such that the $y$-axis represents performance ($J$) and the $x$-axis is the positive predictive bias (PPB). We then examine the relationship between the maximum change in each dimension. For *(a)* linear relationships, our quantities of interest correspond to the maximum change along each dimension, and for *(b)* curvilinear relationships this corresponds to the secant line passing through the point greatest difference along the $x$-axis from the $x$-value corresponding to the maximum performance value and the point of maximum performance itself."

	figure_export(
		"honduras-css-paper/Figures (SI)/figure_diagram_si.svg",
		fg,
		save2;
        short_caption = "Decomposition of accuracy",
		caption,
	)
end
