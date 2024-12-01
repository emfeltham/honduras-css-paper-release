# base_models_tie_2_wealth.jl

include("../../code/setup/analysis preamble.jl")

bimodel, pbs = let
	m = load_object("interaction models/base1_tie_2.jld2")

    pbs = (
        tpr = load_object("interaction models/base1_pb_10K_tpr_tie_2.jld2"),
        fpr = load_object("interaction models/base1_pb_10K_fpr_tie_2.jld2")
    )

	EModel(m.tpr, m.fpr), pbs
end

ds = [dats[x][!, :dists_p][dats[x][!, :dists_p] .!= 0] for x in rates];
distmean = mean(reduce(vcat, ds));

xd = (mean∘skipmissing)(cr.wealth_d1_4) .+ collect(-0.3:0.1:0.3);

dict = Dict(
    :kin431 => false,
    :dists_p => distmean,
    :age => mean(dats[:fpr].age),
    :wealth_d1_4 => xd,
    :wealth_d1_4_mean_a => xd
    #:wealth_d1_4_mean_a => [(mean∘skipmissing)(cr.wealth_d1_4) - (std∘skipmissing)(cr.wealth_d1_4), (mean∘skipmissing)(cr.wealth_d1_4), (mean∘skipmissing)(cr.wealth_d1_4) + (std∘skipmissing)(cr.wealth_d1_4)],
);

rg = referencegrid(cr, dict);
ap = effects!(rg, bimodel[:tpr]; invlink = logistic)
# ap.wd = ap.wealth_d1_4 .- mean(ap.wealth_d1_4_mean_a)
ap.wd = ap.wealth_d1_4_mean_a .- ap.wealth_d1_4
sort!(ap, [:wealth_d1_4_mean_a, :wd])
gap = groupby(ap, :wealth_d1_4_mean_a)

fg = Figure();
ax = Axis(fg[1, 1]; ylabel = "TPR", xlabel = "respondent wealth");
# for ((k, g), c) in zip(pairs(gap), wc[1:3])
#     lines!(ax, g.wealth_d1_4, g.response; color = c, label = string(round(k[1]; digits = 3)))
# end
# fg[1, 2] = Legend(fg, ax, "pair wealth", tellheight = false)

eq = @subset(ap, :wealth_d1_4_mean_a .== :wealth_d1_4);
lines!(ax, eq.wealth_d1_4, eq.response; color = :black)
fg

##

# v = :wealth_d1_4_mean_a
# x_ = sunique(dats[:fpr][!, v])
# a, b = extrema(x_)
# x_ = collect(a:0.0011:b)

# dict = Dict(
#     :kin431 => false,
#     :dists_p => distmean,
#     :age => mean(dats[:fpr].age),
#     v => x_
# );

# e1 = effects(dict, m.tpr)
# e2 = effects(dict, m2.tpr)

# fg = Figure();
# ax = Axis(fg[1,1])
# lines!(ax, e1[!, v], e1.response; color = oi[1])
# lines!(ax, e2[!, v], e2.response; color = oi[2])
# fg


#%%
adf = DataFrame();
for x in -0.5:0.05:0.5
    a_ = @subset ap :wealth_d1_4 .== :wealth_d1_4_mean_a .- x;
    a_.diff .= x
    append!(adf, a_)
end
gadf = groupby(adf, :diff);

fg_same = Figure();
ax = Axis(fg_same[1, 1]; ylabel = "TPR", xlabel = "Cognizer wealth");
for (k, g) in pairs(gadf)
    c = (k[:diff]+1)*inv(2)
    lines!(ax, g[!, vk], g[!, :response]; color = berlin[c])
end
Colorbar(
    fg_same[1, 2], colormap = :berlin,
    limits = (-1,1),
    label = "Cognizer household wealth", vertical = true
)
fg_same

sort!(adf, :diff)

dict2 = Dict(
    :kin431 => false,
    :dists_p => distmean,
    :age => (mean∘skipmissing)(cr.age),
    :wealth_d1_4 => (mean∘skipmissing)(cr[!, vk]),
    :wealth_d1_4_mean_a => xd
);

rg = referencegrid(cr, dict2);
ap2 = effects!(rg, m1.tpr; invlink = logistic)
ap2.diff = ap2[!, vk] - ap2[!, v];

fg_diff = Figure();
ax = Axis(fg_diff[1, 1]; ylabel = "TPR", xlabel = "Cognizer wealth - pair wealth");
lines!(ax, ap2[!, :diff], ap2[!, :response])
fg_diff