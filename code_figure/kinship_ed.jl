# kinship_ed.jld2

include("../../code/setup/environment.jl")

mcat, mdst = load_object("objects/kinship_marg.jld2")
addΣ!(mcat.rg)
addΣ!(mdst.rg)

fgk = let fg = Figure()
	lo = GridLayout(fg[1:2, 1], width = 950)
    layout1 = lo[1, 1] = GridLayout()
    layout2 = lo[2, 1] = GridLayout()
	
    tp = (
        rg = mcat.rg, margvar = :kintype, margvarname = mcat.name,
        tnr = true, jstat = true
    );
    biplot!(layout1, tp)

    @subset!(mdst.rg, .!:kin431)
    # @subset!(mdst.rg, :are_related_dists_a .> 0)
    tp = (
        rg = mdst.rg, margvar = :are_related_dists_a, margvarname = mdst.name,
        tnr = true, jstat = true
    );
    biplot!(layout2, tp)

	resize!(fg, 1000, 400 * 2)
	resize_to_layout!(fg)
    labelpanels!([layout1, layout2]; lbs = :uppercase)
	fg
end

@inline save2(name, fg) = save(name, fg; pt_per_unit = 2)

let fg = fgk
	caption = "The effect of alternative definitions of kinship. In addition to the binary definition of kinship (used in the primary analyses) and genetic relatedness (Figure 2B), we consider the specific type of kinship tie as a categorical variable (A) and distance in the kinship network (B). We find that the categorical results are consistent with the binary definition, and distance in the kinship network broadly corresponds to that of genetic relationship."

	figure_export(
		"honduras-css-paper/figures/kinship.svg",
		fg,
		save2;
		caption,
		outlined = true,
	)
end
