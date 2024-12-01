# Figure 6.jl

include("../../code/setup/environment.jl")

dataloc = "honduras-css-paper/objects/";
rgef, rgr = load_object(dataloc * "rates_data_2_new.jld2");
rgs, _ = load_object(dataloc * "riddle_data.jld2");

#%%
fg = Figure();
p = GridLayout(fg[1, 1]);
l = GridLayout(fg[1, 2]);

height_ = 300
width_ = 300

# TPR-FPR panel
let
    ax = Axis(p[1, 1], aspect = 1, xlabel = "FPR", ylabel = "TPR");
    xlims!(0,1); ylims!(0,1);

    yx = 0:0.1:1
    lines!(ax, yx, yx, color = :black)
    lines!(ax, yx, 1 .- yx, color = yale.grays[end-2])

    jstand = (rgr.j .- minimum(rgr.j)) * inv(maximum(rgr.j) - minimum(rgr.j));
    jstands = [(berlin[x], 0.25) for x in jstand];

    # perceivier "raw" (stage-1) data
    scatter!(
        ax, rgr.fpr, rgr.tpr;
        color = :transparent, strokewidth = 1,
        strokecolor = jstands
    )

    # hold stage 2 model at averages except degree
    rgef.ppb = rgef.tpr + rgef.fpr;
    rgef.j = rgef.tpr - rgef.fpr;
    mx, lc = findmax(rgef.j)
    mn, lcmin = findmin(rgef.j)

    vlines!(
        ax, rgef[lc, :fpr];
        ymin = rgef[lc, :fpr], ymax = rgef[lc, :tpr], color = ratecolor(:j)
    )

    vlines!(ax, rgef[lcmin, :fpr];
    ymin = rgef[lcmin, :fpr], ymax = rgef[lcmin, :tpr], color = ratecolor(:j)
)

    ppbrow = @subset(rgef, :ppb .<= 1.001, :ppb .>= 0.999)[1, :];
    vlines!(
        ax, ppbrow[:fpr];
        ymin = ppbrow[:fpr], ymax = ppbrow[:tpr],
        color = ratecolor(:j)
    )

    text!(
        ax, rgef[lc, :fpr]-0.005, (rgef.tpr[lc] + rgef.fpr[lc])/2;
        text = L"J_{\text{max}}",
        align = (:right, :center)
    )

    text!(
        ax, ppbrow[:fpr]-0.005, (ppbrow.tpr + ppbrow.fpr)/2;
        text = L"J_{\text{PPB}=1}",
        align = (:right, :center)
    )

    text!(
        ax, rgef[lcmin, :fpr]-0.005, (rgef.tpr[lcmin] + rgef.fpr[lcmin])/2;
        text = L"J_{\text{min}}",
        align = (:right, :center)
    )

    lines!(ax, rgef.fpr, rgef.tpr, color = columbia.secondary[2])
    band!(
        ax, rgef.fpr, rgef.lower, rgef.upper;
        color = (columbia.secondary[2], 0.2)
    )
    Colorbar(p[1, 2]; colormap = :berlin, label = "J")
end

let
    yvar = :knows
    trp = 0.4
    ax = Axis(
        l[1, 1];
        ylabel = "Riddle knowledge", xlabel = "Rate",
        yticks = 0:0.25:1,
        # width = width_,
        # height = height_
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
resize!(fg, 1000, 500)
resize_to_layout!(fg)
fg

#%%
let fg = fg
    filename = "honduras-css-paper/Figures (main)/Figure 6"
    short_caption = "Association of accuracy rates within individual respondents"
    caption = typst"Association of accuracy rates within individual respondents. (a) We find that the individual-level accuracy rates (TPR and FPR) are strongly related, such that increases in a tendency to identify true positives is associated with an increase in the tendency to identify false positives. The line represents the estimated marginal effects for model of the individual accuracy rates, estimated from an OLS regression of an individual's TPR on their FPR, further adjusting for age, gender, network degree, and the relationship (free-time and personal-private). Scatter points represent the model-predicted individual accuracy rates for each subject, marginalized over relationship, so that an individual point represents the predicted accuracy values for an individual (FPR, TPR), and points are colored by overall accuracy ($J$). The model fit and estimated predictions concern connections solely among non-kin ties. Bootstrapped 95% confidence intervals are shown (orange band) and account for error at both stages of estimation. Additionally, $J$ is represented graphically for its extrema ($J_('max')$, $J_('min')$), and the point at which individuals are unbiased ($'PPB' = 1$). (b) Social network accuracy is associated with the acquisition of novel non-social information. Estimation is performed with a logistic model that regresses knowledge of three exogenously introduced riddles related to zinc usage, umbilical cord care, and prenatal care on respondent-level social network accuracy. Models adjust for the specific riddle, demographic characteristics (age, gender, education), and network degree. Bands represent bootstrapped 95% confidence intervals that account for uncertainty at both stages of estimation (see Supplementary Fig. 8; Supplementary Tables 7 and 8 for details). "

    save(filename * ".png", fg; px_per_unit = 4.0)

    figure_export(
        filename * ".svg",
        fg,
        save2;
        short_caption,
        caption,
        outlined = true,
    )
end
