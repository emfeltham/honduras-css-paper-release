# SI Figure results coffee

include("../../code/setup/environment.jl")

import NiceDisplay.GraphMakie.SFDP;#,Stress
layout = GraphMakie.SFDP();

#%%
# data
md = load_object("objects/base1_tie2_margins_bs_out.jld2")
transforms = load_object("objects/variable_transforms.jld2")

#%%
fg = Figure();

l_coffee = GridLayout(fg[1,1])

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

resize!(fg, 950, 800)
resize_to_layout!(fg)
fg

#%%

save("honduras-css-paper/figures_si/SI Figure results coffee.png", fg)

#%%
# captions
let fg = fg

    caption = "Effect of whether a village cultivates coffee on social network accuracy. Parameters are fit from separate models of each rate, conditional on tie verity in the reference network. Grey shading represents the 95% bootstrapped confidence ellipse of the predictions from the two models. Right, marginal effect of each individual accuracy measure: the true positive and false positive rates and the summary measure Youden's \$J\$ statistic. Intervals represent 95% confidence levels, calculated via normal approximation for the two rates, and bootstrapped for the \$J\$ statistic."

    figure_export(
        "honduras-css-paper/figures_si/SI Figure results coffee.svg",
        fg,
        save2;
        caption,
        outlined = true,
    )
end
