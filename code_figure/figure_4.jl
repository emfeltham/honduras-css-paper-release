# figure_village.jl

include("../code/environment.jl")

import NiceDisplay.GraphMakie.SFDP;#,Stress
layout = GraphMakie.SFDP();

#%%
# data
md = load_object("objects/base1_tie2_margins_bs_out.jld2");
transforms = load_object("objects/variable_transforms.jld2";)

mg = load_object("objects/net_plot_data_44.jld2");
rgv = load_object("objects/village_acc.jld2");

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

save("figures/figure_4.png", fg; px_per_unit = 2.0)
