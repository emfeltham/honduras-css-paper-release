# model_diagnostics.jl
# diagnostics for the TPR, FPR models

#%%
include("../../code/setup/analysis preamble.jl")
bimodel = load_object("interaction models/base1_tie_2.jld2")

#%%
# binned residual plot
# https://journals.sagepub.com/doi/pdf/10.1177/1536867X1501500219
@inline bnd(p, n) = 2*sqrt(p*(1-p)*inv(n))

fg_pred = let fg = Figure();
    m = bimodel.tpr
    n = 500

    rdf = DataFrame(pred = predict(m), res = residuals(m))
    sort!(rdf, :pred)
    rdf.bin = cut(rdf.pred, n)

    rdf_ = @chain rdf begin
        groupby(:bin)
        combine(nrow => :count, :res => mean, :res => std => :res_std, :pred => mean, renamecols = false)
    end

    l1 = GridLayout(fg[1,1])
    ax1 = Axis(l1[1,1], ylabel = "Bin average residual (observed - expected)", xlabel = "Bin average prediction")
    scatter!(ax1,
        rdf_.pred, rdf_.res, color = :transparent,
        strokewidth = 1, strokecolor = last(yale.blues)
    )
    hlines!(ax1, 0, linestyle = :dot)


    lines!(ax1, rdf_.pred, 1 .* bnd.(rdf_.res_std, rdf_.count), color = (yale.grays[3], 0.5))
    lines!(ax1, rdf_.pred, -1 .* bnd.(rdf_.res_std, rdf_.count), color = (yale.grays[3], 0.5))

    m = bimodel.fpr

    rdf = DataFrame(pred = predict(m), res = residuals(m))
    sort!(rdf, :pred)
    rdf.bin = cut(rdf.pred, n)

    rdf_ = @chain rdf begin
        groupby(:bin)
        combine(nrow => :count, :res => mean, :res => std => :res_std, :pred => mean, renamecols = false)
    end

    l2 = GridLayout(fg[1,2])
    ax2 = Axis(l2[1,1], ylabel = "Bin average residual (observed - expected)", xlabel = "Bin average prediction")
    scatter!(ax2,
        rdf_.pred, rdf_.res, color = :transparent,
        strokewidth = 1, strokecolor = columbia.secondary[1]
    )
    hlines!(ax2, 0, linestyle = :dot)

    lines!(ax2, rdf_.pred, 1 .* bnd.(rdf_.res_std, rdf_.count), color = (yale.grays[3], 0.5))
    lines!(ax2, rdf_.pred, -1 .* bnd.(rdf_.res_std, rdf_.count), color = (yale.grays[3], 0.5))

    labelpanels!([l1, l2])
    resize!(fg, 800, 350)
    resize_to_layout!(fg)
    fg
end

let fg = fg_pred
    short_caption = "Model residuals"
	caption = "Binned residual plots of the primary models of the *(a)* TPR and *(b)* FPR. Lines represent the ± 2 standard error bounds. The model predictions are divided into 500 bins, with equal counts of observations. The average residual values of each bin are plotted against the average model prediction from each corresponding bin."

	figure_export(
		"honduras-css-paper/figures_si/residuals.svg",
		fg,
		Makie.save;
		caption,
        short_caption,
        kind = Symbol("image-si"),
        supplement = "*Supplementary Figure*",
		outlined = true,
	)
end


#%%

let fg = Figure();
    r = :tpr
    m = m1[r];

    avar = :wealth_d1_4_mean_a
    rdf = DataFrame(
        :pred => predict(m), :res => residuals(m), avar => dats[r][!, avar]
    );
    sort!(rdf, avar)
    # @subset(rdf, $avar .> 0)
    rdf.bin = cut(rdf[!, avar], 6)

    rdf_ = @chain rdf begin
        groupby(:bin)
        combine(
            nrow => :count,
            :res => mean, :res => std => :res_std,
            :pred => mean,
            avar => mean,
            renamecols = false
        )
    end

    x = if eltype(rdf_[!, avar]) <: CategoricalValue
        levelcode.(rdf_[!, avar])
    else rdf_[!, avar]
    end

    l1 = GridLayout(fg[1,1])
    ax1 = Axis(l1[1,1], ylabel = "Bin average residual (observed - expected)", xlabel = "Bin average prediction")
    scatter!(ax1,
        x, rdf_.res, color = :transparent,
        strokewidth = 1, strokecolor = ratecolor(r)
    )
    hlines!(ax1, 0, linestyle = :dot, color = yale.grays[3])

    rdf_.lower = -1 .* bnd.(rdf_.res_std, rdf_.count)
    rdf_.upper = 1 .* bnd.(rdf_.res_std, rdf_.count)

    lines!(ax1, x, rdf_.lower, color = (yale.grays[3], 0.5))
    lines!(ax1, x, rdf_.upper, color = (yale.grays[3], 0.5))
    fg
end