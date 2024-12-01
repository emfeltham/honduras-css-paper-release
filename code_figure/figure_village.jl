# figure_village.jl

include("../../code/setup/environment.jl")

import NiceDisplay.GraphMakie.SFDP;#,Stress
layout = GraphMakie.SFDP();

#%%
# data
md = load_object("objects/base1_tie2_margins_bs_out.jld2")
transforms = load_object("objects/variable_transforms.jld2")

mg = load_object("objects/net_plot_data_44.jld2");
rgv = load_object("objects/village_acc.jld2");

#%%
fg = Figure();
l_top = GridLayout(fg[1, 1:2]);
l_coffee = GridLayout(l_top[1, 2]);
l_j = GridLayout(l_top[1, 1]);
l_network = GridLayout(fg[2, 1:2]);
colsize!(l_top, 1, Relative(1/4.5))

let e = :coffee_cultivation, l = l_coffee

    md[e].rg[!, e] = replace(md[e].rg[!, e], true => "Yes", false => "No")

    l1 = l[1, 1] = GridLayout()
    ll = l[1, 2] = GridLayout()
    l2 = l[1, 3] = GridLayout()

    rg, margvarname = md[e]
    bpd = (
        rg = rg, margvar = e, margvarname = margvarname,
        tnr = true, jstat = true
    );
    
    colsize!(l, 1, Relative(1/2.25))
    rocplot!(
        l1,
        bpd.rg, bpd.margvar, bpd.margvarname;
        dolegend = false,
        dropkin = true, kinlegend = false
    )

    effectsplot!(
        l2, bpd.rg, bpd.margvar, bpd.margvarname, true;
        dolegend = false
    )

    ellipsecolor = (yale.grays[end-1], 0.3)
    lxr = ll[1, 1] = GridLayout()
    HondurasCSS.roclegend!(
        lxr, bpd.rg[!, bpd.margvar], bpd.margvarname, true, ellipsecolor, false; kinlegend = false, framevisible = false
    )
    lxe = ll[2, 1] = GridLayout()
    HondurasCSS.effectslegend!(lxe[1, 1], true, false, false; tr = 0.6)
end

let
    ax1 = Axis(l_j[1, 1]; title = "Free time", width = 175, height = 100)
    ax2 = Axis(l_j[2, 1]; title = "Personal private", width = 175, height = 100)
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

    ax = Axis(l1[1,1], aspect = 1, title = "Free time network");
    graphplot!(
        ax, g;
        node_strokecolor = :black,
        edge_color = ec,
        layout
    )
    hidedecorations!(ax)

    cs = []
    @eachrow edf begin
        x = if !(:sim)
            Symbol("transparent")
        else
            (last(yale.blues), 0.2)
            # if :socio4
            #     (ratecolor(Symbol("tpr")), 0.4)
            # elseif !(:socio4)
            #     (ratecolor(Symbol("fpr")), 0.2)
            # end
        end
        push!(cs, x)
    end

    ax2 = Axis(l2[1,1], aspect = 1, title = "Average conception of the free time network");
    graphplot!(
        ax2, g;
        edge_color = ifelse.(edf.sim, cs, :transparent),
        layout
    )
    hidedecorations!(ax2)


    elem = [
        LineElement(color = (ratecolor(Symbol("tpr")), 0.4)),
        LineElement(color = (ratecolor(Symbol("fpr")), 0.4))
    ]
    # Legend(
    #     l[1, 3], elem, ["True positive", "False positive"], "Belief about tie",
    #     #tellwidth = false, tellheight = false
    #     framevisible = false
    # )
    l1, l2
end

labelpanels!([l_j, l_coffee, lns...]; lbs = :uppercase)
resize!(fg, 1200, 900)
resize_to_layout!(fg)
fg

#%%

save("honduras-css-paper/figures/figure_village.png", fg)
@inline save2(name, fg) = save(name, fg; pt_per_unit = 2)

#%%
# captions
let fg = fg

    caption = "Village-level perspectives. (a) Village-level distributions of overall accuracy (\$J\$), we find that the village-average scores are narrowly distributed (in contradistinction to the much wider individual-level distributions, in Supplementary Fig. 1) just above 1/3 of the way to perfect accuracy from chance performance for each network. Consistent with the individual-level analyses (Figure 3), we see greater accuracy for the free time network. (b) Effect of whether a village cultivates coffee on social network accuracy. Parameters are fit from separate models of each rate, conditional on tie verity in the reference network. Grey shading represents the 95% bootstrapped confidence ellipse of the predictions from the two models. Right, marginal effect of each individual accuracy measure: the true positive and false positive rates and the summary measure Youden's \$J\$ statistic. Intervals represent 95% confidence levels, calculated via normal approximation for the two rates, and bootstrapped for the \$J\$ statistic. (c and d) We show the contrast between the underlying sociocentric network (c), and the network as an average of the individual cognizer predictions across the free time whole network (d) for a single village. Here, predicted ties are either true or false positives. We see that individuals predict a network that is much denser (by a factor of 8) adding a total of 748 ties to the 108 that exist in the sociocentric network. (See *Supplementary Information* for further village-level analyses)."

    figure_export(
        "honduras-css-paper/figures/figure_village.svg",
        fg,
        save2;
        caption,
        outlined = true,
    )
end

# adjust colgap
