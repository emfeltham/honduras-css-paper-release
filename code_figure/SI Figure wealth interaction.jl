# SI Figure wealth interaction.jl

include("../../code/setup/environment.jl")

rgc = load_object("objects/wealth_interaction.jld2")

vk = :wealth_d1_4
vt = :wealth_d1_4_mean_a

fg3 = let
    fg = Figure();
    l1 = GridLayout(fg[1,1])
    l2 = GridLayout(fg[2,1])
    ax1 = Axis3(
        l1[1, 1];
        xlabel = "Wealth (pair)", ylabel = "Wealth (respondent)",
        zlabel = "Rate",
        azimuth = 1.275π,
        height = 300
    )

    su = sunique(rgc[!, vt]);
    sps = []

    for (metric, ax) in zip([:tpr, :fpr,], [ax1, ax1])
        mt = fill(NaN, length(su), length(su));
        mtc = Matrix{RGB{Float64}}(undef, size(mt))
        for (i, e) in enumerate(su), (j, f) in enumerate(su)
            ix = findfirst((rgc[!, vt] .== e) .& (rgc[!, vk] .== f))
            mt[i,j] = rgc[ix, metric]
            mtc[i,j] = berlin[f-e]
        end
        
        sp = wireframe!(
            ax, su, su, mt, color = (HondurasCSS.ratecolor(metric), 0.6)
        )
        push!(sps, sp)
    end

    yvar = (var = :j, name = "J", )
    interaction_wealth!(l2[1,1], rgc, yvar, vt, vk; fullylim = false)

    labelpanels!([l1, l2])
    fg
end

resize!(fg3, 500, 500)
resize_to_layout!(fg3)

@inline save2(name, fg) = save(name, fg; pt_per_unit = 2);

let
    caption = "Effect of the interaction between cognizer and pair wealth on accuracy. *(a)* Interaction for the TPR and FPR rates in three dimensions. *(b)* Interaction between cognizer and pair wealth on the J statistic. Effects represent marginal effects calculated from the mixed-effects logistic models of the TPR and FPR."
    figure_export(
        "honduras-css-paper/figures_si/SI Figure wealth interaction.svg",
        fg3,
        save2;
        short_caption = "Effect of the interaction between cognizer and pair wealth on accuracy.",
        caption,
        outlined = true,
        # kind = "image-ed" |> Symbol,
        # supplement = "Extended Data Figure"
    )
end
