# figure_riddle.jl

include("../../code/setup/environment.jl")

rgs, _ = load_object("objects/riddle_data.jld2");

fg_riddle = Figure();
l = GridLayout(fg_riddle[1, 1]);

let fg = fg_riddle
    yvar = :knows
    trp = 0.4
    ax = Axis(
        l[1, 1];
        ylabel = "Riddle knowledge", xlabel = "Rate",
        yticks = 0:0.25:1
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
    Legend(l[1,2], elems, ["TPR", "TNR", "J"], "Accuracy"; framevisible = false)
end

@inline save2(name, fg) = save(name, fg; pt_per_unit = 2)

save("honduras-css-paper/figures/figure_riddle.png", fg_riddle)

let fg = fg_riddle

    caption = "Social network accuracy is associated with the acquisition of novel non-social information. Estimation is performed by logistic a model that regress knowledge of three exogenously introduced riddles related to zinc usage, umbilical cord care, and prenatal care on respondent-level social network accuracy. Models adjust for the specific riddle, demographic characteristics (age, gender, education) and network degree. Bands represent bootstrapped 95% confidence intervals that account for uncertainty at both stages of estimation. We present the separate estimates for each riddle, marginalizing over the ranges of accuracy measures in Supplementary Fig. 7 and contrasts in Supplementary Table 9. "

    figure_export(
        "honduras-css-paper/figures/figure_riddle.svg",
        fg,
        save2;
        caption,
        outlined = true,
    )
end
