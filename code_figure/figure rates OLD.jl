# tradeoffs.jl

#%%

include("../../code/setup/environment.jl")

@inline polarback(r, θ) = r*cos(θ), r*sin(θ)

#%% data for tradeoff

# remove these, since not sig
rms = [:religion_c, :man, :isindigenous_a];
rms_ = ["Within-tie distance", "Indigeneity"];

md = load_object("objects/base1_tie2_margins.jld2")

# remove no path entries, since we only want to include the real range
@subset!(md[:dists_p].rg, :dists_p_notinf);
@subset!(md[:dists_a].rg, :dists_a_notinf);

prds = [
    :relation,
    :age,
    :man,
    :educated,
    :degree,
    :dists_p,
    # :dists_a,
    :man_a,
    :age_mean_a,
    :age_diff_a,
    :religion_c,
    :religion_c_a,
    :isindigenous_a,
    :degree_mean_a,
    :degree_diff_a,
    :wealth_d1_4, 
    :wealth_d1_4_mean_a,
    :wealth_d1_4_diff_a,
    :educated_a,
    :coffee_cultivation
];

trades = ratetradeoffs(md, prds)

nm = String[]
for (κ, ω) in md
    push!(nm, split(ω.name, " (")[1])
end

nm = setdiff(nm, rms_)
unique!(nm)

cscheme = colorschemes[:seaborn_colorblind];
cdict = Dict(nm .=> cscheme[1:length(nm)]);
cdict["Coffee cultivation"] = cscheme[end]

for x in rms_; delete!(cdict, x) end

tdf = DataFrame(
    :variable => Symbol[], :name => String[], :type => String[],
    :x => AbstractFloat[], :y => AbstractFloat[], :rto => AbstractFloat[]
)

for (k, v) in trades
    vnm = md[k].name
    vnm2 = split(vnm, " (")[1]
    sk = string(k)
    t_ = if occursin("(difference)", vnm)
        "Difference"
    elseif occursin("(mean)", vnm)
        "Mean"
    elseif occursin("_a", sk)
        "Combination"
    else "Cognizer"
    end
    push!(tdf, [k, vnm2, t_, v[1], v[2], v[2]*inv(v[1])])
end

tdf[findfirst(tdf.variable .== Symbol("relation")), :type] = "Combination"
tdf[findfirst(tdf.variable .== Symbol("dists_p")), :type] = "Mean"

sort!(tdf, :rto)

# remove non-significant effects
vs = setdiff(tdf.variable, rms)
@subset!(tdf, :variable .∈ Ref(vs))

#%% TPR FPR model data

ef_, rgb_r = load_object("objects/rates_data_2.jld2")

#%% Figure

height_ = 375
width_ = 375

#%%
fg = Figure();
lo = fg[1, 1] = GridLayout()
l_diagram = GridLayout(lo[1, 2])
l1_rate = GridLayout(lo[1, 1])
l_trade = lo[2, 1:2] = GridLayout()
l_trade1 = l_trade[1, 1] = GridLayout()
l_trade2 = l_trade[1, 2] = GridLayout()
rowgap!(lo, 0)

# TPR-FPR panel
let
    ax_rate = Axis(
        l1_rate[1, 1], ylabel = "TPR", xlabel = "FPR",
        width = width_,
        height = height_
    );
    lw = ef_.lower
    hg = ef_.upper

    # yale.grays[3]
    js = rgb_r.j
    js_range = extrema(js)
    js = (js .- minimum(js)) * inv.(maximum(js) - minimum(js))
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

    Colorbar(
        l1_rate[1, 2]; label = "J", limits = js_range, colormap = :berlin
    )
end

# rate tradeoff panels
let
    l1 = GridLayout(l_trade2[1, 1])

    ax = Axis(
        l_trade1[1, 1],
        xlabel = "Tradeoff",
        ylabel = "Performance",
        width = width_,
        height = height_
    );

    ax2 = Axis(
        l1[1, 1],
        xlabel = "Performance / Tradeoff",
        ylabel = "Attribute",
        width = width_*1.3,
        height = height_*inv(2)+10
    );

    a = max(maximum(tdf.x), maximum(tdf.y)) + 0.01
    lines!(
        ax, -0.1:0.001:(a+0.01), -0.1:0.001:(a+0.01);
        linestyle = :dot, color = yale.grays[2]
    )
    a = ceil(a; digits = 2)
    xlims!(ax, -0.0025, a)
    ylims!(ax, -0.0025, a)

    vlines!(ax2, 1; color = :black, linestyle = :dash)
    mxr = maximum(tdf.rto)
    for u in 2:nrow(tdf)
        hlines!(ax2, u-0.5, mxr;
        color = (yale.grays[2], 0.1), linestyle = :solid)
    end

    for (i, r) in (enumerate∘eachrow)(tdf)
        clr = copy(cdict[r[:name]])
        strokecolor = copy(cdict[r[:name]])
        
        clr, trp, strokewidth = if r[:type] == "Cognizer"
            clr, 1, 0
        elseif r[:type] ∈ ["Combination", "Mean"]
            :transparent, 0, 2
        else
            # fill color for difference attributes
            yale.grays[2], 0.75, 2
        end

        pt = (r.x, r.y)
        lines!(ax, [0, r.x], [0, r.y]; color = (yale.grays[2], 0.1))
        scatter!(
            ax, pt;
            label = r[:name],
            color = (clr, trp), strokecolor, strokewidth,
            markersize = 13
        )

        jtr = i
        # jtr = (rand() - 0.5)
        scatter!(
            ax2, (r.rto, jtr);
            label = r[:name],
            color = (clr, trp), strokecolor, strokewidth,
            markersize = 13
        )
    end

    xlims!(ax2; low = -0.01, high = mxr+0.1)
    ylims!(ax2, 0.5, nrow(tdf)+0.5)
    hideydecorations!(ax2; label = false)

    vblcolor = []
    nms = []
    for r in eachrow(tdf)
        vnm2 = r[:name]

        if vnm2 ∉ nms
        
            clr = copy(cdict[vnm2])
            strokecolor = copy(cdict[vnm2])

            push!(
                vblcolor,
                # MarkerElement(
                #     marker = :circle,
                #     color = clr, strokecolor = :transparent,
                #     markersize = 13,
                # )
                PolyElement(marker = :circle, color = clr)
            )
            push!(nms, vnm2)
        end
    end

    prop = []
    vs = ["Cognizer", "Tie (mean or combination)", "Tie (difference)"]
    for (v, cl, sc) in zip(vs, [:black, :transparent, (yale.grays[2], 0.75)], [:transparent, columbia.secondary[1], columbia.secondary[1]])
        push!(
            prop,
            MarkerElement(
                marker = :circle, color = cl, strokecolor = sc,
                markersize = 13,
                strokewidth = 2
            )
        )
    end

    Legend(
        l1[2, 1],
        [vblcolor, prop], [nms, vs], ["Attribute", "Attribute type"];
        nbanks = 3, framevisible = false,
        tellwidth = true
    )

    rowgap!(l1, 40)
end

dwidth = 175
dheight = 175

# diagram panel
let
    e = :age_mean_a
    rg, margvarname = md[e]
    bpd = (
        rg = rg, margvar = e, margvarname = margvarname,
        tnr = true, jstat = true
    );
    
    rg = @subset md[e].rg .!:kin431
    
    lall = GridLayout(l_diagram[1:2, 1:2])

    axb = Axis(lall[1,1]; backgroundcolor = :transparent)
    hidedecorations!(axb)
    hidespines!(axb)
    ylims!(axb, -1.05,1.05)
    xl = [-1.25,1.25]
    xlims!(axb, xl...)

    pa = π*(3/4)
    arc!(
        axb, Point2f(0), 1, pa, π - pa;
        linestyle = :dash,
        linewidth = 4,
        color = (columbia.secondary[5], 0.75)
    )
    text!(axb, mean(xl)-0.08, 0.75; text = L"45^{\circ}", fontsize = 24)

    ptx = Point2f[
        polarback(1., π - pa - π/24),
        polarback(1.05, π - pa),
        polarback(0.95, π - pa)
    ]
    poly!(
        axb, ptx,
        color = :black, strokecolor = columbia.secondary[5], strokewidth = 1
    )

    ##
    l1 = GridLayout(l_diagram[1:2, 1]);
    l2 = GridLayout(l_diagram[1:2, 2]);

    pts = Point2f.(rg.fpr, rg.tpr)

    ax1 = Axis(
        l1[1, 1];
        ylabel = "True positive rate", xlabel = "False positive rate",
        height = dheight, width = dwidth,
        yticklabelcolor = ratecolor(:tpr),
        xticklabelcolor = ratecolor(:fpr)
    )
    HondurasCSS.chanceline!(ax1);
    HondurasCSS.improvementline!(ax1);
    scatter!(ax1, pts, linewidth = 4, color = yale.grays[2])

    ylims!(ax1, 0, 1)
    xlims!(ax1, 0, 1)

    ##
    θ = -π/4;
    ptst = Point2f.([HondurasCSS.rotation(θ) * pt for pt in pts])

    yext = [0, 0.5]
    xext = [0.4, 0.9]

    ax2 = Axis(
        l2[1,1];
        ylabel = "Performance", xlabel = "Tradeoff",
        height = dheight, width = dwidth,
        yticklabelcolor = columbia.blues[1],
        xticklabelcolor = yale.accent[2],
        xticks = [xext[1], mean(xext), xext[2]],
        yticks = [yext[1], mean(yext), yext[2]]
    )
    #hidespines!(ax2)

    ylims!(ax2, yext...)
    xlims!(ax2, xext...)

    adj_ = [0.03, -0.03];

    vlines!(
        ax2,
        xext + adj_;
        ymin = 0.0, ymax = 1,
        linestyle = :dash, color = (yale.accent[1], 1)
    )
    hlines!(
        ax2, yext + adj_;
        linestyle = :dot, color = (yale.grays[1], 1)
    )

    scatter!(ax2, ptst, linewidth = 4, color = (yale.grays[2], 0.75))

    xt = [pt[1] for pt in ptst]
    yt = [pt[2] for pt in ptst]

    xtmn, xtmx = extrema(xt)
    ytmn, ytmx = extrema(yt)

    # lines!(
    #     ax2,
    #     LinRange(xtmn, xtmx, 80), LinRange(ytmn, ytmx, 80);
    #     color = (columbia.secondary[2], 1), linestyle = :dot,
    #     linewidth = 3
    # )

    ys = ytmn:0.0001:ytmx
    scatter!(
        ax2, fill(xtmx, length(ys)), ys;
        color = (columbia.blues[1], 0.1),
        linewidth = 4
    )

    xs = xtmn:0.0001:xtmx
    scatter!(
        ax2, xs, fill(ytmn, length(xs));
        color = (yale.accent[2], 0.1),
        linewidth = 4
    )
end

labelpanels!([l1_rate, l_diagram, l_trade, l_trade2])

resize!(fg, 600*3, 925)
resize_to_layout!(fg)
fg

#%%

save(
    "honduras-css-paper/figures/figure_rates.png", fg;
    px_per_unit=2.0, background_color = :transparent
)

let fg = fg
	caption = "Association of accuracy rates within individual respondents. *(a)* We find that the individual-level accuracy rates (TPR and FPR) are strongly related, such that increases in a tendency to identify true positives is associated with an increase in the tendency to identify a false positive. The line represents the estimated marginal effects for model of the individual accuracy rates, estimated from an ordinary least squares regression of an individual's TPR on their FPR, further adjusting for age, gender, network degree, and the relationship (free-time and personal-private). Scatter points represent the model-predicted individual accuracy rates for each subject, marginalized over relationship, so that an individual point represents the predicted accuracy values for an individual (FPR, TPR), and is colored by overall accuracy (\$J\$). The model fit and estimated predictions concern connections solely among non-kin ties. Bootstrapped 95% confidence intervals are shown (green dotted lines) and account for error at both stages of estimation. *(b)* To summarize the relationship between the attributes of the cognizers (_e.g._, the network degree of k) or the presented pairs (_e.g._, the average age of \$i\$ and \$j\$) as studied in Figs. 2, 3 and the error rates, we examine the extent to which change across the range of values of that attribute represents a bona fide change in performance or simply a tradeoff between the two error rates. Specifically, we change the basis of the ROC-space plot for each attribute (LHS) by rotating the points 45 degrees clockwise. The consequent y-axis represents pure change in performance and the x-axis denotes a pure tradeoff in error types (without change in overall performance). After the rotation, we examine the relationship between the maximum change in each dimension (light-blue and orange lines), which corresponds to the vector decomposition of the secant line that passes through the maximum performance value and the furthest tradeoff value from the point given by the intersection of the two elements of the decomposition. *(c)* Performance versus tradeoff, as measured by the lengths of the decomposed vectors. We include each attribute presented in Figs. 2, 3 with a statistically significant contrast for either rate. Attributes above and to the left the diagonal line represent a greater amount of genuine change in performance than a mere tradeoff in errors (and the obverse for points below and to the right of the line). *(d)* Ratio of performance to tradeoff. We further summarize the relationships as the ratio of the two lengths. While the two accuracy rates are highly correlated in general, we see that characteristics vary in their impact on performance. A characteristic could have a pure effect on performance, _e.g._, a change in network degree could lead to a higher or lower overall accuracy rate without any change in the rates of the two errors committed. By contrast, a characteristic may yield no change in overall accuracy, but a shift in the ratio of true positive to false positive rates. While change across the range of values of most properties represent a mixture, they primarily represent a tradeoff. Notably, only network degree stands out as a property that has a ratio substantially above 1. Most other properties, by contrast, represent changes in error type more than they reflect changes in overall accuracy. Model results are presented in Table S3."

	figure_export(
		"honduras-css-paper/figures/figure_rates.svg",
		fg,
		save2;
		caption,
        short_caption = "Association of accuracy rates within individual respondents.",
		outlined = true,
	)
end
