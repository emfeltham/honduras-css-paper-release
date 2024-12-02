# kinship_ed.jld2

include("../../code/setup/environment.jl")

dataloc = "honduras-css-paper/objects/"
mcat, mdst = load_object(dataloc * "kinship_marg.jld2")
addΣ!(mcat.rg)
addΣ!(mdst.rg)

saveloc = "honduras-css-paper/Figures (extended data)/";

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

let fg = fgk
    filename = saveloc * "ED Figure kinship alternative"
    short_caption = "The effect of alternative definitions of kinship"
	caption = "In addition to the binary definition of kinship (used in the primary analyses) and genetic relatedness (Figure 2B), we consider the specific type of kinship tie as a categorical variable (A) and distance in the kinship network (B). We find that the categorical results are consistent with the binary definition, and distance in the kinship network broadly corresponds to that of genetic relationship."

    save(
		filename * ".png", fg; px_per_unit=2.0, background_color = :transparent
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
