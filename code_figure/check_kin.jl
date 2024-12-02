# check_kin.jl

ck = @subset con (:wave .== 4) .& (:relationship .== "are_related")
ck.tie = tieset(ck, :ego, :alter);

grel = CSV.read("/WORKAREA/work/HONDURAS_MICROBIOME/E_FELTHAM/kin/merged_filter_hwe_maf_new_names.kin0", DataFrame);
rename!(grel, "#IID1" => "alter1", "IID2" => "alter2", "KINSHIP" => "kinship");

grel.tie = tieset(grel, :alter1, :alter2);

leftjoin!(ck, grel, on = :tie)

cks = dropmissing(ck, :kinship)
@subset! cks :kintype .!= "Partners"

sunique(cks.kintype)

cks_gen_hist = data(cks) * mapping(:kinship, layout=:kintype) * histogram(bins = 25)

cks_m = @chain cks begin
    groupby(:kintype)
    combine(:kinship => mean, renamecols = false)
end

l2 = data(cks_m) * mapping(:kinship, layout = :kintype) * visual(VLines, color = oi[1])

fgl = draw(cks_gen_hist + l2);

#%%

@inline save2(name, fg) = save(name, fg; pt_per_unit = 2)

let fg = fgl
    short_caption = "Reported kinship and genetic kinship"
	caption = "Reported kinship and genetic kinship. Distribution of the kinship coefficient (see Methods for description) for the self-reported Parent/child relationships and the sibling relationships. Distribution means (blue lines) indicate that the levels of relatedness are close to their expected values (\$1/4\$ for each) for both categories."

	figure_export(
		"honduras-css-paper/Figures (SI)/report_genetics.svg",
		fg,
		save2;
		caption,
        short_caption,
        # kind = Symbol("image-si"),
        # supplement = "*Supplementary Figure*",
		outlined = true,
	)
end
