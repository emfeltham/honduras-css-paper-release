# Figure 7.jl

include("../../code/setup/environment.jl")

dataloc = "honduras-css-paper/objects/";
md = load_object(dataloc * "base1_tie2_margins.jld2");
tdf = tradeoffdata(md);

tdf.transparency .= 1.0;
tdf.color .= :black;
tdf.Name = tdf.name .* " (" .* tdf.type .* ")";

replace!(
    tdf.Name, "Coffee cultivation (Cognizer)" => "Coffee cultivation (Village)"
)

tdf.x*sqrt(2) # TPR-TNR+1
(tdf.y)*sqrt(2) # J

tdf.shape = typeshape.(tdf.type);

pts = ratediagramdata(md, :age_mean_a);

#%% make figure
fg = Figure(backgroundcolor = :white);
l_ = GridLayout(fg[1:2, 1])
l = GridLayout(l_[1, 1]);

# panel b
ratediagram!(l[1, 1], pts)

let # panel a legend
    c1 = (oi[3]+oi[end-1], 0.25);
    c2 = oi[end-1]-oi[3];
    c2 = (RGBA(c2.r, c2.g, c2.b), 0.25)

    elem1 = [
        MarkerElement(
            color = (oi[3], 0.5), marker = :rect, markersize = 30,
            stroke = :black, strokewidth = 1
        ),
        MarkerElement(
            color = (oi[end-1], 0.5), marker = :rect, markersize = 30,
            stroke = :black, strokewidth = 1
        ),
    ];
    elem_labels1 = [
        "Above chance", "Below chance"
    ];

    elem2 = [
        MarkerElement(
            color = c1, marker = :rect, markersize = 30,
            stroke = :black, strokewidth = 1
        ),
        LineElement(color = :black, linestyle = :dot, linewidth = 2),
        MarkerElement(
            color = c2, marker = :rect, markersize = 30,
            stroke = :black, strokewidth = 1
        ),
    ];
    elem_labels2 = [
        "Conservative (PPB < 1)", "Unbiased (PPB = 1)", "Liberal (PPB > 1)"
    ];

    Legend(
        l[1, 2], [elem1, elem2], [elem_labels1, elem_labels2], ["Performance", "Bias type"];
        framevisible = true,
        tellwidth = false, tellheight = false,
        halign = :center, valign = :top,
        # margin = (0, 0, -50, 0)
    )
end

# panel b
l1 = GridLayout(l_[2, 1]);
ax1 = scatter_ratio!(l1[1, 2], tdf)
ax2 = scatter_values!(l1[1, 1], tdf)

yticks_ = (eachindex(tdf[!, :name]), tdf[!, :Name]);
ax2.yticks = yticks_;

let # panel b legend
    elem = [
        MarkerElement(color = (c, 0.8), marker = :circle, markersize = 15, ) for c in [columbia.blues[1], yale.accent[2]]
    ];
    elem_labels = ["Performance (ΔJ)", "Tradeoff (ΔPPB)"];
    Legend(
        l[1, 2], elem, elem_labels, "Change in accuracy";
        framevisible = true,
        tellwidth = false, tellheight = false,
        halign = :center, valign = :bottom,
        margin = (0, 0, 15, 0)
    )
end

labelpanels!([l_, l1]; lbs = :lowercase)
colsize!(l, 1, Relative(2.25/3))
rowgap!(l_, -70)

resize_to_layout!(fg)
resize!(fg, 1000, 800)

fg

#%%
let fg = fg
    filename = "honduras-css-paper/Figures (main)/Figure 7"
    short_caption = "Summary representation of examined characteristics"
	caption = typst"Summary representation of examined characteristics. *(a)* To further summarize the change in accuracy, we change the basis of the ROC-space. The transformed axes represent performance ($J$) and bias (positive predictive bias). After this operation, we decompose the vector formed by the maximum change in each dimension (light-blue and orange lines). See Supplementary Information and Supplementary Fig. 9 for details. *(b)* Performance-tradeoff ratio and maximum change. The maximum change over the range of each studied attribute, whether an attribute of a survey respondent (cognizer) or of a tie is shown, as either the change in the J statistic, or in the positive predictive bias (LHS) and the ratio of the two (RHS). In the case of attributes of ties, an attribute may be either the mean values of the pair (mean), the absolute difference between the two (difference), or the unique combinations of qualitative values (combination). See Supplementary Information for more details."

    save(
        filename * ".png", fg;
        px_per_unit = 2.0, background_color = :transparent
    )

	figure_export(
		filename * ".svg",
		fg,
		save2;
        short_caption,
		caption,
		outlined = true,
	)
end
