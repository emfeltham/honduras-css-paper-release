# SI Figure results degree (mean) tie interaction.jl

include("../../code/setup/environment.jl")

rg = load_object("objects/degree_interaction.jld2");

v = (cog = :degree, pair = :degree_mean_a);
gdf = groupby(rg, v.cog);

#%%
fg = Figure();
los = [GridLayout(fg[1, i]) for i in 1:3];
axs = Axis[]
for (i, (r, rname)) in (enumerate∘zip)([:tpr, :fpr, :j], ["TPR", "FPR", "J"])
    x_ext = extrema(rg[!, v.cog]);
    y_ext = extrema(rg[!, r]);
    y_ext_adj = floor(y_ext[1]; digits = 1), ceil(y_ext[2]; digits = 1);

    fullylim = true
    yticks = if fullylim
        0:0.2:1
    else
        y_ext_adj[1]:0.1:y_ext_adj[2]
    end
    ax = Axis(
        los[i][1, 1];
        ylabel = rname, xlabel = "Pair degree (mean)",
        xticks = x_ext[1]:0.2:x_ext[2],
        #yticks,
        aspect = 1,
        #width = 250,
        height = 250
    )
    push!(axs, ax)

    for (k, g) in pairs(gdf)
        lines!(ax, g[!, v.pair], g[!, r]; color = (berlin[k.degree], 0.6))
    end
end

Colorbar(
    fg[1,4], colormap = :berlin,
    label = "Cognizer degree", vertical = true,
    tellheight = false
)

linkaxes!(axs[1:2]...)
for ax in axs; xlims!(ax, 0, 1) end

su = sunique(rg[!, v.pair]);
mt = fill(NaN, length(su), length(su));
for (i, e) in enumerate(su), (j, f) in enumerate(su)
    ix = findfirst((rg[!, v.pair] .== e) .& (rg[!, v.cog] .== f))
    mt[i,j] = rg[!, :j][ix]
end

l2 = GridLayout(fg[2, :])
push!(los, l2)
ax = Axis3(
    l2[1, 1];
    xlabel = "Pair degree (mean)", ylabel = "Cognizer degree",
    zlabel = "J",
    height = 350
    #width =300
)
sp = wireframe!(ax, su, su, mt; color = ratecolor(:j))

resize!(fg, 1000, 500)
resize_to_layout!(fg)
labelpanels!(los)

fg

#%%
save("honduras-css-paper/Figures (SI)/SI Figure results degree (mean) tie interaction.png", fg; px_per_unit = 2)

let
    scaption = "Effect of the interaction between a cognizer's degree and the average degree of a pair on accuracy."
    figure_export(
        "honduras-css-paper/Figures (SI)/SI Figure results degree (mean) tie interaction.svg",
        fg,
        save2;
        short_caption = scaption,
        caption = "Effect of the interaction between a cognizer's degree and the average degree of a pair on accuracy. Effects on *(a)* TPR, *(b)* FPR, and *(c, d)* \$J\$ represent marginal effects calculated from the mixed-effects logistic models of the TPR and FPR.",
        outlined = true
    )
end
