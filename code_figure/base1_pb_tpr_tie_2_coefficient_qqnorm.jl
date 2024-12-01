# base1_pb_tpr_tie_2_coefficient_qqnorm.jl

include("../../code/setup/environment.jl")

bimodel = load_object("interaction models/base1_tie_2.jld2")

pbs = (
    tpr = load_object("interaction models/base1_pb_10K_tpr_tie_2.jld2"),
    fpr = load_object("interaction models/base1_pb_10K_fpr_tie_2.jld2")
);

#%%

pβ = @chain pbs.tpr.β begin
    DataFrame
    groupby(:coefname)
    combine(:β => Ref => :β)
end

pβ.std = std.(pβ.β)

pβ.std_model = stderror(bimodel.tpr)

fg = Figure();
for i in 1:nrow(pβ)
    cn = pβ.coefname[i]
    x = pβ.β[i]
    i = i - 1
    mv = mod(i, 5)
    j = mv + 1
    i_ = i - mv
    ax = Axis(
        fg[i_,j]; title = string(cn), titlesize = 12,
        height = 200, width = 200
    )
    qqnorm!(ax, x; qqline = :fitrobust, strokewidth = 1, markercolor = :transparent, strokecolor = (:gray, 0.7))
end
resize!(fg, 800, 2100)
resize_to_layout!(fg)
fg

let fg = fg
	caption = "Normality of the estimated coefficients for the TPR model. We see that the bootstrap distribution of each estimated coefficient appears closely normal via quantile-quantile comparisons."

	figure_export(
		"honduras-css-paper/figures_si/qq_tpr_coefs.png",
		fg,
		save;
		caption,
		outlined = true,
	)
end

#%%
pβ = @chain pbs.fpr.β begin
    DataFrame
    groupby(:coefname)
    combine(:β => Ref => :β)
end

fg = Figure();
for i in 1:nrow(pβ)
    cn = pβ.coefname[i]
    x = pβ.β[i]
    i = i - 1
    mv = mod(i, 5)
    j = mv + 1
    i_ = i - mv
    ax = Axis(
        fg[i_,j]; title = string(cn), titlesize = 12,
        height = 200, width = 200
    )
    qqnorm!(ax, x; qqline = :fitrobust, strokewidth = 1, markercolor = :transparent, strokecolor = (:gray, 0.7))
end
resize!(fg, 800, 2100)
resize_to_layout!(fg)
fg

let fg = fg
	caption = "Normality of the estimated coefficients for the FPR model. We see that the bootstrap distribution of each estimated coefficient appears closely normal via quantile-quantile comparisons."

	figure_export(
		"honduras-css-paper/figures_si/qq_fpr_coefs.png",
		fg,
		save;
		caption,
		outlined = true,
	)
end
