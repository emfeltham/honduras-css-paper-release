# ascona conference.jl

include("../../code/setup/analysis preamble.jl");

figure1 = let
    @inline bsize(a) = Int(round(800^2/a; digits = 0))

    css = select(
        cr, ids.vc, :perceiver, :alter1, :alter2, socio, :relation, :response
    );
    @subset! css :relation .== rl.ft;
    dropmissing!(css, [:relation, :response, socio]);

    ndf4 = let
        ndf = JLD2.load_object(datapath * "network_info_" * dte * ".jld2");
        @subset ndf :wave .== 4;
    end

    figure1 = make_figure1(css, cr, ndf4)


    #colsize!(fg_background.layout, 1, Aspect(1, 3))

    @inline bsize(a) = Int(round(800^2/a; digits = 0))

    a = 1100
    resize!(figure1, a+150, bsize(a))
    resize_to_layout!(figure1)
    figure1
end

let fg = figure1
    caption = "Outline of the sampling procedure. (a) The network for a specific relationship (b) Conceivable ties. (c) Survey responses."
    figure_export(
        "honduras-css-paper/ascona/figure1.svg",
        fg,
        save;
        caption,
        outlined = true,
    )
end

figure2 = make_figure2(m0a, m0b, m0c, m1, crs, cr);

let fg = figure2
    caption = "Bivariate distribution of respondent accuracies, represented as the true positive (sensitivity) vs. false positive rate (1 - specificity). Observations are respondent-level means, where each individual perceiver may be thought of as a binary classifier."
    figure_export(
        "honduras-css-paper/ascona/figure2.svg",
        fg,
        save;
        caption,
        outlined = true,
    )
end

# %% figure 3 content

using Random
Random.seed!(2023)

plotdata_cog = load_object("figure3_plotdata.jld2");

let vbl = :gender
    fg = Figure();
    layout = fg[1, 1] = GridLayout();
    biplot!(
        layout,
        plotdata_cog[vbl];
        jstat = true,
        ellipse = true,
        markeropacity = 1.0,
        panellabels = true
    )
    resize!(fg, 900, 300)
    resize_to_layout!(fg)
    
    caption = "Marginal effect of gender represented (a) as two-dimensional accuracy, (b) along each measure, with a summary score, Youden's _J_, and for non-kin relations."
    figure_export(
        "honduras-css-paper/ascona/figure_gender.svg",
        fg,
        save;
        caption,
        outlined = true,
    )
    fg
end

let vbl = :age
    fg = Figure();
    layout = fg[1, 1] = GridLayout();
    biplot!(
        layout,
        plotdata_cog[vbl];
        jstat = true,
        ellipse = true,
        markeropacity = 1.0,
        panellabels = true
    )
    resize!(fg, 900, 300)
    resize_to_layout!(fg)
    
    caption = "Marginal effect of age. Model includes age#super[2]."
    figure_export(
        "honduras-css-paper/ascona/figure_age.svg",
        fg,
        save;
        caption,
        outlined = true,
    )
    fg
end

let vbl = :degree
    fg = Figure();
    layout = fg[1, 1] = GridLayout();
    biplot!(
        layout,
        plotdata_cog[vbl];
        jstat = true,
        ellipse = true,
        markeropacity = 1.0,
        panellabels = true
    )
    resize!(fg, 900, 300)
    resize_to_layout!(fg)
    
    caption = "Marginal effect of degree."
    figure_export(
        "honduras-css-paper/ascona/figure_degree.svg",
        fg,
        save;
        caption,
        outlined = true,
    )
    fg
end

cap1 = "Effect of age on perceiver accuracy.  Fits from two separate models with the same covariate specification, conditional on tie verity. Grey shading represents 95% bootstrapped confidence ellipse."
cap2 = "*(b)* Marginal effect of age. Fits from two separate models with the same covariate specification, conditional on tie verity. Estimates are among non-kin ties only. Intervals represent 95% confidence levels, calculated via normal approximation for the two rates, and bootstrapped for the J statistic."

plotdata_tie = load_object("plotdata_figure4.jld2")
mrgs = load_object("distance_figure4.jld2")

let
    fg = Figure();
    l = fg[1, 1] = GridLayout();
    l1 = l[1, 1] = GridLayout();
    l2 = l[1, 2] = GridLayout();
    l3 = l[1, 3] = GridLayout();
    # l4 = l[1, 4] = GridLayout();
    
    distance_roc!(l1[1, 1], mrgs.p; ellipse = true)
    distance_eff!(
        l2[1, 1], mrgs.p; jstat = true, fpronly = false, legend = false
    )
    distance_eff!(
        l3[1, 1], mrgs.a; jstat = false, fpronly = true, legend = false
    )

    resize!(fg, 1200, 300)
    resize_to_layout!(fg)

    labelpanels!([l1, l2, l3])
    
    caption = "Marginal effect of distance. Effects for pairs with and without defined geodesic distances."
    figure_export(
        "honduras-css-paper/ascona/figure_distance.svg",
        fg,
        save;
        caption,
        outlined = true,
    )
    fg
end

let vbl = :degree_mean_a
    fg = Figure();
    layout = fg[1, 1] = GridLayout();
    biplot!(
        layout,
        plotdata_tie[vbl];
        jstat = true,
        ellipse = true,
        markeropacity = 1.0,
        panellabels = true
    )
    resize!(fg, 900, 300)
    resize_to_layout!(fg)
    
    caption = "Marginal effect of average degree."
    figure_export(
        "honduras-css-paper/ascona/figure_degree_mean_tie.svg",
        fg,
        save;
        caption,
        outlined = true,
    )
    fg
end

let vbl = :protestant_a
    fg = Figure();
    layout = fg[1, 1] = GridLayout();
    biplot!(
        layout,
        plotdata_tie[vbl];
        jstat = true,
        ellipse = true,
        markeropacity = 1.0,
        panellabels = true
    )
    resize!(fg, 900, 300)
    resize_to_layout!(fg)
    
    caption = "Marginal effect of religious composition."
    figure_export(
        "honduras-css-paper/ascona/figure_religion_tie.svg",
        fg,
        save;
        caption,
        outlined = true,
    )
    fg
end