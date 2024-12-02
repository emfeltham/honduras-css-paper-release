# individual predictions figures.jl

obj_dir = "honduras-css-paper/objects/";
fig_dir = "honduras-css-paper/Figures (SI)/";

fns = ["base", "interaction_1", "interaction_2"];
# [load_object(fn * "_individual.jld2") for fn in fns]

#=
figure panels
A. univariate histograms
B. bivariate predictions
fg_ind_preds = let refgrids = refgrids, refgrid = refgrid
    fg = Figure();
    lo = fg[1, 1:3] = GridLayout();
    l1 = lo[1, 1] = GridLayout();

    ax1a = Axis(l1[1, 1]; xlabel = "TPR");
    ax1b = Axis(l1[2, 1]; xlabel = "FPR");
    ax1c = Axis(l1[3, 1]; xlabel = "FPR");

    linkaxes!(ax1a, ax1b);

    for (r, ax) in zip(rates, [ax1a, ax1b])
        hist!(ax, refgrids[r][!, :response], bins = 100)
        xlims!(ax, 0, 1)
    end

    hist!(ax1c, refgrid[!, :youden], bins = 100)
    xlims!(ax1c, -1, 1)

    l2 = lo[1, 2] = GridLayout();
    colsize!(l2, 1, Aspect(1, 1.0))
    ax2 = Axis(l2[1, 1], ylabel = "TPR", xlabel = "FPR");

    # line of chance
    lines!(ax2, (0:0.1:1), 0:0.1:1; linestyle = :dot, color = (:black, 0.5))

    # line of improvement
    lines!(ax2, (1:-0.1:0.5), 0:0.1:0.5; linestyle = :solid, color = (oi[6], 0.5))
    lines!(ax2, (0.5:-0.1:0), 0.5:0.1:1; linestyle = :solid, color = (oi[3], 0.5))

    kd = KernelDensity.kde((refgrid.fpr, refgrid.tpr))
    co = contour!(
        ax2, kd, levels = 10, colormap = :berlin,
    )
    
    ylim = (0.25, 1.0)
    xlim = (0.0, 0.750)

    ylims!(ax2, ylim)
    xlims!(ax2, xlim)

    labelpanels!([l1, l2])
    colsize!(fg.layout, 1, Aspect(1, 2.5))
    resize_to_layout!(fg)
    fg
end

fg_ind_preds_kin = let refgrids = refgrids_kin, refgrid = refgrid_kin
    fg = Figure();
    lo = fg[1, 1:3] = GridLayout();
    l1 = lo[1, 1] = GridLayout();

    ax1a = Axis(l1[1, 1]; xlabel = "TPR");
    ax1b = Axis(l1[2, 1]; xlabel = "FPR");
    ax1c = Axis(l1[3, 1]; xlabel = "FPR");

    linkaxes!(ax1a, ax1b);

    for (r, ax) in zip(rates, [ax1a, ax1b])
        hist!(ax, refgrids[r][!, :response], bins = 100)
        xlims!(ax, 0, 1)
    end

    hist!(ax1c, refgrid[!, :youden], bins = 100)
    xlims!(ax1c, -1, 1)

    l2 = lo[1, 2] = GridLayout();
    colsize!(l2, 1, Aspect(1, 1.0))
    ax2 = Axis(l2[1, 1], ylabel = "TPR", xlabel = "FPR");

    # line of chance
    lines!(ax2, (0:0.1:1), 0:0.1:1; linestyle = :dot, color = (:black, 0.5))

    # line of improvement
    lines!(ax2, (1:-0.1:0.5), 0:0.1:0.5; linestyle = :solid, color = (oi[6], 0.5))
    lines!(ax2, (0.5:-0.1:0), 0.5:0.1:1; linestyle = :solid, color = (oi[3], 0.5))

    kd = KernelDensity.kde((refgrid.fpr, refgrid.tpr))
    co = contour!(
        ax2, kd, levels = 10, colormap = :berlin,
    )
    
    ylim = (0.8, 1.0)
    xlim = (0.8, 1.0)

    ylims!(ax2, ylim)
    xlims!(ax2, xlim)

    labelpanels!([l1, l2])
    colsize!(fg.layout, 1, Aspect(1, 2.5))
    resize_to_layout!(fg)
    fg
end
=#

fgs = [];
for fn in fns
    refgrid, refgrids, refgrid_kin, refgrids_kin = load_object(obj_dir * fn * "_individual.jld2")

    fg = Figure();
    parent_lo = fg[1, 1] = GridLayout();
    individualpredictions!(
        parent_lo,
        refgrid, refgrids, refgrid_kin, refgrids_kin;
        rates, numlev = 10
    )
    resize_to_layout!(fg)
    fg

    push!(fgs, fg)
end

let fg = fgs[1], fig_dir = fig_dir
    fn = fns[1] * "_individual_predictions_combined.svg";

    caption = "Individual accuracy predictions (main effects only). (A) univariate distributions of individual accuracy scores for the true positive, false positive, and Youden's J. (B) Bivariate accuracy distributions, stratified by judgements of ties between kin and non-kin. We observe that predictions for kin ties are highly concentrated in the top left panel, at a level close to chance performance.";

    figure_export(
        fig_dir * fn, fg, save;
        caption, kind = Symbol("image-si"), supplement = "Supplementary Figure"
    )
end

let fg = fgs[2], fig_dir = fig_dir
    fn = fns[2] * "_individual_predictions_combined.svg";

    caption = "Individual accuracy predictions (relationship and kin interactions). (A) univariate distributions of individual accuracy scores for the true positive, false positive, and Youden's J. (B) Bivariate accuracy distributions, stratified by judgements of ties between kin and non-kin. We observe that predictions for kin ties are highly concentrated in the top left panel, at a level close to chance performance.";

    figure_export(
        fig_dir * fn, fg, save;
        caption, kind = Symbol("image-si"), supplement = "Supplementary Figure"
    )
end

let fg = fgs[3], fig_dir = fig_dir
    fn = fns[3] * "_individual_predictions_combined.svg";

    caption = "Individual accuracy predictions (full interaction set). (A) univariate distributions of individual accuracy scores for the true positive, false positive, and Youden's J. (B) Bivariate accuracy distributions, stratified by judgements of ties between kin and non-kin. We observe that predictions for kin ties are highly concentrated in the top left panel, at a level close to chance performance.";

    figure_export(
        fig_dir * fn, fg, save;
        caption, kind = Symbol("image-si"), supplement = "Supplementary Figure"
    )
end
