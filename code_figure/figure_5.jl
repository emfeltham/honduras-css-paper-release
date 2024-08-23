# figure_riddle.jl

include("../../code/setup/environment.jl")

rgs, _ = load_object("objects/riddle_data.jld2");

#%%

fg = Figure();
p = GridLayout(fg[1, 1]);
l = GridLayout(fg[1, 2]);

height_ = 300
width_ = 300

# TPR-FPR panel
let
    ef_, rgb_r = load_object("objects/rates_data_2.jld2")

    ax_rate = Axis(
        p[1, 1], ylabel = "TPR", xlabel = "FPR",
        width = width_,
        height = height_
    );
    lw = ef_.lower
    hg = ef_.upper

    js = rgb_r.j
    js_range = extrema(js)

    js = (js .- minimum(js)) * inv.(maximum(js) - minimum(js)) # unit-range
    c_ = [(berlin[j], 0.4) for j in js]
    
    scatter!(
        ax_rate, rgb_r.fpr, rgb_r.tpr;
        color = :transparent,
        strokecolor = c_,
        strokewidth = 1
    )

    lines!(ax_rate, ef_.fpr, ef_.tpr, color = yale.accent[1])
    lines!(ax_rate, ef_.fpr, lw, color = (yale.accent[1], 1), linestyle = :dash)
    lines!(ax_rate, ef_.fpr, hg, color = (yale.accent[1], 1), linestyle = :dash)

    ylims!(ax_rate, minimum(rgb_r.tpr)-0.005, maximum(hg))
    xlims!(ax_rate, extrema(ef_.fpr))

    # color range should reflect original values
    Colorbar(
        p[1, 2]; label = "J", limits = js_range, colormap = :berlin
    )
end

let
    yvar = :knows
    trp = 0.4
    ax = Axis(
        l[1, 1];
        ylabel = "Riddle knowledge", xlabel = "Rate",
        yticks = 0:0.25:1,
        width = width_,
        height = height_
    );
    ax_r = Axis(l[1, 1]; xlabel = "J", xaxisposition = :top);
    linkyaxes!(ax, ax_r)
    hideydecorations!(ax_r);
    
    for (rte) in [:tpr, :tnr, :j]
        rg = rgs[rte]

        x = rg[!, rte]
        y = rg[!, yvar]
        lwr = rg[!, :lower]
        upr = rg[!, :upper]
        rc = ratecolor(rte)

        ax_ = ifelse(rte == :j, ax_r, ax)

        lines!(ax_, x, y; color = rc)
        band!(ax_, x, lwr, upr; color = (rc, trp))
    end

    ylims!(ax_r, 0, 1)
    
    xlims!(ax, extrema(rgs[:tnr][!, :tnr]))
    xlims!(ax_r, extrema(rgs[:j][!, :j]))
    
    elems = [[PolyElement(; color = (rc, trp)), LineElement(; color = rc)] for rc in ratecolor.([:tpr, :tnr, :j])]
    Legend(l[1, 2], elems, ["TPR", "TNR", "J"], "Accuracy"; framevisible = false)
end

labelpanels!([p, l])
resize_to_layout!(fg)
fg

#%%

save("figures/figure_5.png", fg; px_per_unit = 2.0)
