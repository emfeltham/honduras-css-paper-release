# Figure 5.jl

include("../../code/setup/environment.jl")

import NiceDisplay.GraphMakie.SFDP;
layout = GraphMakie.SFDP();

dataloc = "honduras-css-paper/objects/"
md = load_object(dataloc * "base1_tie2_margins_bs_out.jld2")
transforms = load_object(dataloc * "variable_transforms.jld2")

mg = load_object(dataloc * "net_plot_data_44.jld2");
rgv = load_object(dataloc * "village_acc.jld2");

#%%
fg = Figure();
l_top = GridLayout(fg[1, 1:2]);
l_coffee = GridLayout(l_top[1, 2]);
l_j = GridLayout(l_top[1, 1]);
l_network = GridLayout(fg[2, 1:2]);
colsize!(l_top, 1, Relative(1/2))

let e = :coffee_cultivation

    md[e].rg[!, e] = replace(md[e].rg[!, e], true => "Yes", false => "No")

    l1 = l_coffee[1, 1] = GridLayout()

    rg, margvarname = md[e]
    bpd = (
        rg = rg, margvar = e, margvarname = margvarname,
        tnr = true, jstat = true
    );
    
    rocplot!(
        l1,
        bpd.rg, bpd.margvar, bpd.margvarname;
        dolegend = false,
        dropkin = true,
        kinlegend = false,
        axsz = 350,
        legargs = (framevisible = false, tellheight = false, tellwidth = false, orientation = :horizontal, nbanks = 1)
    )

    ellipsecolor = (yale.grays[end-1], 0.3)
    elems = [[
        MarkerElement(
            marker = :circle, color = ellipsecolor,
            strokecolor = :transparent, markersize = 30
        ),
        MarkerElement(
            marker = :circle, color = c, strokecolor = :transparent
        )
    ] for c in oi[1:2]]

    # elems = [MarkerElement(color = X, marker = :circle) for X in oi[1:2]]
    
    Legend(
        l1[1, 2],
        elems,
        ["No", "Yes"],
        ["Cultivation"],
        orientation = :vertical, nbanks = 1, framevisible = false,
        titleposition = :top
    )
end

let
    ax1 = Axis(l_j[1, 1]; title = "Free time", width = 325, height = 300/2)
    ax2 = Axis(l_j[2, 1]; title = "Personal private", width = 325, height = 300/2)
    linkaxes!(ax1, ax2)

    bins = 20
    x1 = rgv.j[rgv.relation .== "free_time"];
    x2 = rgv.j[rgv.relation .== "personal_private"];
    vlines!(ax1, mean(x1), color = (yale.grays[1], 0.75), linestyle = :dash)
    hist!(ax1, x1; color = (ratecolor(:j), 0.75), bins)
    vlines!(ax2, mean(x2), color = (yale.grays[1], 0.75), linestyle = :dash)
    hist!(ax2, x2;color = (ratecolor(:j), 0.75), bins)
    for ax in [ax1, ax2]; xlims!(ax, 0.25, 0.50) end
end

# network
lns = let l = l_network, mg = mg
    g = mg.graph
    edf = mg.edf
    l1 = GridLayout(l[1, 1])
    l2 = GridLayout(l[1, 2])
    ec = [ifelse(e, (yale.grays[3], 0.5), (:transparent, 0.5)) for e in edf.socio4]

    ax = Axis(
        l1[1,1], title = "Free time network",
        height = 400, width = 400
    );
    graphplot!(
        ax, g;
        node_strokecolor = :black,
        edge_color = ec,
        layout,
    )
    hidedecorations!(ax)

    cs = []
    @eachrow edf begin
        x = if !(:sim)
            Symbol("transparent")
        else
            (last(yale.blues), 0.2)
        end
        push!(cs, x)
    end

    ax2 = Axis(
        l2[1,1],
        title = "Average conception of the free time network",
        height = 400, width = 400
    );
    graphplot!(
        ax2, g;
        edge_color = ifelse.(edf.sim, cs, :transparent),
        layout,
    )
    hidedecorations!(ax2)


    elem = [
        LineElement(color = (ratecolor(Symbol("tpr")), 0.4)),
        LineElement(color = (ratecolor(Symbol("fpr")), 0.4))
    ]
    l1, l2
end

labelpanels!([l_j, l_coffee, lns...])
resize!(fg, 1000, 1000)
resize_to_layout!(fg)
fg

#%%
# captions
let fg = fg
    filename = "honduras-css-paper/Figures (main)/Figure 5"
    short_caption = "Village-level perspectives"
    caption = typst"Village-level perspectives. *(a)* Village-level distributions of overall accuracy ($J$). We find that the village-average scores are narrowly distributed (in contradistinction to the much wider individual-level distributions in Supplementary Fig. 3), just above 1/3 of the way to perfect accuracy from chance performance for each network. Consistent with the individual-level analyses (Fig. 3), we see greater accuracy for the free-time network. *(b)* Effect of whether a village cultivates coffee on social network accuracy. Parameters are fit from separate models of each rate, conditional on tie verity in the reference network. Marginal effects on accuracy in ROC space are shown; grey shading represents the 95% bootstrapped confidence ellipse of the predictions from the two models. (c and d) We show the contrast between the underlying sociocentric network *(c)*, and the network as an average of the individual cognizer predictions across the whole free-time network *(d)* for a single village. Here, predicted ties are either true or false positives. We see that individuals predict a network that is much denser (by a factor of 8) adding a total of 748 ties to the 108 that exist in the sociocentric network. See Supplementary Information for further village-level analyses."

    save(filename * ".png", fg; px_per_unit = 2.0)

    figure_export(
        filename * ".svg",
        fg,
        save2;
        short_caption,
        caption,
        outlined = true,
    )
end
