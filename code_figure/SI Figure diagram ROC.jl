# SI Figure diagram ROC.jl

include("../../code/setup/analysis preamble.jl")

nk = @subset(cr, .!(:kin431), :relation .== "free_time")

transforms = load_object("variable_transforms.jld2")
e = :dists_p
nk[!, e] = reversestandard(nk, e, transforms)

function errorframe(css; grps = [:relation, :perceiver], socio = socio)

    edf = @chain css begin
        select([:village_code, :response, socio, kin, grps...])
        @transform(
            :tp = (:response .& $socio), # TP
            :fp = (:response .& .!($socio)), # FP
            :fn = (.!:response .& $socio), # FN
            :tn = (.!:response .& .!($socio)), # TN
        )
        groupby([kin, grps...])
        @combine(
            :tp = sum(:tp),
            :fp = sum(:fp),
            :fn = sum(:fn),
            :tn = sum(:tn),
            :socio = sum($socio),
            :response = sum(:response),
            :count = length(:response)
            )
            @transform(
                :tpr = :tp ./ (:tp + :fn), # 1 - type 2
                :fpr = :fp ./ (:fp + :tn) # type 1 
            )
            sort(grps)
    end;

    edf[!, :type1] = edf.fpr;
    edf[!, :type2] = 1 .- edf.tpr;

    return edf
end

edf_oa = errorframe(nk; grps = [:relation]);
edf_oa.color .= oi[4];
edf_oa.perceiver .= "mean"

edf_perc = errorframe(nk; grps = [:perceiver, :relation]);
edf_perc.color .= fill((oi[5], 0.08), nrow(edf_perc));
edf_perc.perceiver .= "perceiver";

#edf_perc = vcat(edf_oa, edf_perc)

edf_educ = errorframe(nk; grps = [:educated]);
sort!(edf_educ, :educated);
dropmissing!(edf_educ);
edf_educ.color = colorschemes[:tab20b][1:3];

nkd = @subset nk (:dists_p_notinf) 
edf_ftd = errorframe(nkd; grps = [:dists_p]);
@subset!(edf_ftd, :dists_p .< 10)
disallowmissing!(edf_ftd);
edf_ftd.color = get(colorschemes[:berlin], edf_ftd.dists_p, :extrema);

function addfeatures!(ax)
    lines!(ax, 0:0.1:1, 0:0.1:1; linestyle = :dot, color = (:grey, 0.8))
    lines!(ax, (1:-0.1:0.5), 0:0.1:0.5; linestyle = :solid, color = (oi[6], 0.3))
    lines!(ax, (0.5:-0.1:0), 0.5:0.1:1; linestyle = :solid, color = (oi[3], 0.3))
end

fg = Figure(resolution = (800, 800), backgroundcolor = :transparent);

begin    
    r1 = GridLayout(fg[1, 1:2])
    l1 = GridLayout(r1[1, 1])
    l2 = GridLayout(r1[1, 2])
    rr2 = GridLayout(fg[2, 1:2])
    l3 = GridLayout(rr2[1, 1])
    # l4 = GridLayout(rr2[1, 2])
    lc = GridLayout(rr2[1, 2])

    # mean and perceiver
    ax = Axis(
        l1[1, 1];
        xlabel = "false positive rate (1 - specificity)",
        ylabel = "true positive rate (sensitivity)",
        xgridvisible = false, ygridvisible = false,
        backgroundcolor = :transparent
    )

    addfeatures!(ax)

    df1 = edf_perc[!, :]
    scatter!(
        ax, df1.fpr, df1.tpr;
        color = df1.color[1],
        label = "perceiver"
    )

    df1 = edf_oa[1, :]
    vlines!(ax, df1.fpr, ymin = df1.fpr, ymax = df1.tpr .- 0.02, color = (:grey, 0.6))

    scatter!(
        ax, df1.fpr, df1.tpr;
        color = df1.color,
        label = "overall"
    )

    lc[1, 1] = Legend(
        fg, ax, "Perceiver";
        backgroundcolor = :transparent, framevisible = false
    )

    ## educ

    ax = Axis(
        l2[1, 1];
        xlabel = "false positive rate (1 - specificity)",
        ylabel = "true positive rate (sensitivity)",
        xgridvisible = false, ygridvisible = false,
        backgroundcolor = :transparent
    )

    addfeatures!(ax)

    df1 = edf_educ
    #  .- 0.02 due to numerical accuracy issue?
    vlines!(ax, df1.fpr, ymin = df1.fpr, ymax = df1.tpr .- 0.02; color = (:grey, 0.6))

    for r in eachrow(df1)
        scatter!(
            ax, r.fpr, r.tpr;
            color = r.color,
            label = string(r[:educated])
        )
    end

    lc[1, 2] = Legend(
        fg, ax, "Education",
        tellwidth = false, tellheight = false, bgcolor = :transparent
    )

    ## distmean_ft

    ax = Axis(
        l3[1, 1];
        xlabel = "false positive rate (1 - specificity)",
        ylabel = "true positive rate (sensitivity)",
        xgridvisible = false, ygridvisible = false,
        backgroundcolor = :transparent
    )

    addfeatures!(ax)

    df1 = edf_ftd
    vlines!(ax, df1.fpr, ymin = df1.fpr, ymax = df1.tpr .- 0.02; color = (:grey, 0.4))

    for r in eachrow(df1)
        scatter!(
            ax, r.fpr, r.tpr;
            color = r.color,
            label = string(r[:dists_p])
        )
    end

    Colorbar(
        l3[1, 2];
        limits = extrema(df1.dists_p),
        colormap = :berlin,
        label = "Mean distance"
    )

    for (label, layout) in zip(["a", "b", "c"], [l1, l2, l3])
        Label(layout[1, 1, TopLeft()], label,
            fontsize = 26,
            font = :bold,
            padding = (0, 5, 5, 0),
            halign = :right
        )
    end

    colsize!(rr2, 1, Auto(1.3))
    fg
end

#%%
save2("honduras-css-paper/figures_si/SI Figure diagram ROC.svg", fg)
