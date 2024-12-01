# unreported.jl
# explore unreported effects from the TPR, FPR model

include("../../code/setup/analysis preamble.jl")

bimodel = load_object("interaction models/base1_tie_2.jld2")
invlink = logistic

prds = [
    :response,
    :kin431, :relation,
    :age, :man,
    :educated,
    :degree,
    :dists_p_notinf, :dists_p,
    :man_a,
    :age_mean_a,
    :age_diff_a,
    :religion_c,
    :religion_c_a,
    :isindigenous,
    :isindigenous_a,
    :degree_mean_a,
    :degree_diff_a,
    :wealth_d1_4, 
    :wealth_d1_4_mean_a,
    :wealth_d1_4_diff_a,
    :educated_a,
    :coffee_cultivation
];

dat = dropmissing(cr, prds)

using Random
Random.seed!(2023)

#%%
# indigeneity 

ed = standarddict(dat; kinvals = [false, true])
ed[:isindigenous] = unique(dat[!, :isindigenous]);
ed[:isindigenous_a] = unique(dat[!, :isindigenous_a]);
rg = referencegrid(dat, ed)
estimaterates!(rg, bimodel; iters = 20_000)
ci_rates!(rg)

rg_ = @subset rg (.!$kin);

sort!(rg_, [:isindigenous, :isindigenous_a])

gdf = groupby(rg_, :isindigenous);

metrics = [:tpr, :fpr, :j]

#%%
fg = Figure();

los = GridLayout[];
axs = Axis[];
for (i, c) in enumerate(zip(["TPR", "FPR", "J"], metrics))
    (r, e) = c
    lo = GridLayout(fg[i, 1])
    ax = Axis(
        lo[1,1],
        xticks = (1:3, levels(rg_[!, :isindigenous_a])),
        ylabel = r
    );
    push!(los, lo)
    push!(axs, ax)
end

for (i, e) in enumerate(metrics)
    ax = axs[i]
    gdf_ = gdf[(isindigenous = false, )]
    x = levelcode.(gdf_[!, :isindigenous_a]);
    y = gdf_[!, e];
    lines!(ax, x, y)
    scatter!(ax, x, y)

    gdf_ = gdf[(isindigenous = true, )]
    x = levelcode.(gdf_[!, :isindigenous_a]);
    y = gdf_[!, e];
    lines!(ax, x, y)
    scatter!(ax, x, y)
end

elems = [[
    LineElement(color = cl, linestyle = nothing),
    MarkerElement(color = cl, marker = :circle)
] for cl in [oi[1], oi[2]]]

Legend(fg[4, 1],
    elems,
    ["No", "Yes"],
    "Indigenous",
    tellwidth = false, framevisible = false
)

resize!(fg, 500, 600)
resize_to_layout!(fg)
fg

let
    caption = "Indigeneity interaction, between cognizer and cognized."
    figure_export(
        "honduras-css-paper/figures_unreported/indigeneity_interaction.svg",
        fg,
        save;
        short_caption = :auto,
        caption,
        outlined = true,
        kind = "image-unreported" |> Symbol,
        supplement = "Unreported Figure"
    )
end

#%%
# religion

ed = standarddict(dat; kinvals = false)
ed[:religion_c] = unique(dat[!, :religion_c]);
ed[:religion_c_a] = unique(dat[!, :religion_c_a]);
rg = referencegrid(dat, ed)
estimaterates!(rg, bimodel; iters = 20_000)
ci_rates!(rg)

sort!(rg, [:religion_c, :religion_c_a])

v = :religion_c;
va = :religion_c_a;
rg[!, va] = categorical(rg[!, va])
gdf = groupby(rg, v);

#%%

#%%
fg = Figure();

los = GridLayout[];
axs = Axis[];
ul = levels(rg[!, v]);
rl = levels(rg[!, va]);
for (i, c) in enumerate(zip(["TPR", "FPR", "J"], metrics))
    (r, e) = c
    lo = GridLayout(fg[i, 1])
    ax = Axis(
        lo[1, 1],
        xticks = (eachindex(rl), rl),
        ylabel = r
    );
    push!(los, lo)
    push!(axs, ax)
end

for (i, e) in enumerate(metrics)
    ax = axs[i]

    for u in ul
        gdf_ = gdf[(religion_c = u, )]
        x = levelcode.(gdf_[!, va]);
        y = gdf_[!, e];
        lines!(ax, x, y)
        scatter!(ax, x, y)
    end
end

elems = [[
    LineElement(color = cl, linestyle = nothing),
    MarkerElement(color = cl, marker = :circle)
] for cl in [oi[i] for i in eachindex(ul)]]

Legend(fg[4, 1],
    elems,
    ul,
    "Religion",
    tellwidth = false, framevisible = false
)

resize!(fg, 500, 600)
resize_to_layout!(fg)
fg

let
    caption = "Religion interaction, between cognizer and cognized."
    figure_export(
        "honduras-css-paper/figures_unreported/religion_interaction.svg",
        fg,
        save;
        short_caption = :auto,
        caption,
        outlined = true,
        kind = "image-unreported" |> Symbol,
        supplement = "Unreported Figure"
    )
end

#%%
# religion
v = :man;
va = :man_a;

ed = standarddict(dat; kinvals = false)
ed[v] = unique(dat[!, v]);
ed[va] = unique(dat[!, va]);
rg = referencegrid(dat, ed)
estimaterates!(rg, bimodel; iters = 20_000)
ci_rates!(rg)

sort!(rg, [v, va])

rg[!, va] = categorical(rg[!, va])
gdf = groupby(rg, v);

#%%

#%%
fg = Figure();

los = GridLayout[];
axs = Axis[];
ul = levels(rg[!, v]);
rl = levels(rg[!, va]);
for (i, c) in enumerate(zip(["TPR", "FPR", "J"], metrics))
    (r, e) = c
    lo = GridLayout(fg[i, 1])
    ax = Axis(
        lo[1, 1],
        xticks = (eachindex(rl), rl),
        ylabel = r
    );
    push!(los, lo)
    push!(axs, ax)
end

for (i, e) in enumerate(metrics)
    ax = axs[i]

    for u in ul
        gdf_ = gdf[(man = u, )]
        x = levelcode.(gdf_[!, va]);
        y = gdf_[!, e];
        lines!(ax, x, y)
        scatter!(ax, x, y)
    end
end

elems = [[
    LineElement(color = cl, linestyle = nothing),
    MarkerElement(color = cl, marker = :circle)
] for cl in [oi[i] for i in eachindex(ul)]]

Legend(fg[4, 1],
    elems,
    ["Woman", "Man"],
    "Gender",
    tellwidth = false, framevisible = false
)

resize!(fg, 500, 600)
resize_to_layout!(fg)
fg

let
    caption = "Gender interaction, between cognizer and cognized."
    figure_export(
        "honduras-css-paper/figures_unreported/gender_interaction.svg",
        fg,
        save;
        short_caption = :auto,
        caption,
        outlined = true,
        kind = "image-unreported" |> Symbol,
        supplement = "Unreported Figure"
    )
end

#%%
# relationship by kin

v = :relation;
ed = standarddict(dat; kinvals = [false, true])
ed[v] = unique(dat[!, v]);
rg = referencegrid(dat, ed)
estimaterates!(rg, bimodel; iters = 20_000)
ci_rates!(rg)

sort!(rg, [kin, :relation])

gdf = groupby(rg, v);

#%%

#%%
fg = Figure();

los = GridLayout[];
axs = Axis[];
ul = levels(rg[!, v]);
rl = string.([false, true]);
for (i, c) in enumerate(zip(["TPR", "FPR", "J"], metrics))
    (r, e) = c
    lo = GridLayout(fg[i, 1])
    ax = Axis(
        lo[1, 1],
        xticks = (eachindex(rl), string.(rl)),
        ylabel = r
    );
    push!(los, lo)
    push!(axs, ax)
end

for (i, e) in enumerate(metrics)
    ax = axs[i]

    for u in ul
        gdf_ = gdf[(relation = u, )]
        x = gdf_[!, :kin431] .* 1 .+ 1;
        y = gdf_[!, e];
        lines!(ax, x, y)
        scatter!(ax, x, y)
    end
end

elems = [[
    LineElement(color = cl, linestyle = nothing),
    MarkerElement(color = cl, marker = :circle)
] for cl in [oi[i] for i in eachindex(ul)]]

Legend(fg[4, 1],
    elems,
    ul,
    "Relation",
    tellwidth = false, framevisible = false
)

resize!(fg, 500, 600)
resize_to_layout!(fg)
fg

let
    caption = "Kin by relationship interaction."
    figure_export(
        "honduras-css-paper/figures_unreported/kin_relation_interaction.svg",
        fg,
        save;
        short_caption = :auto,
        caption,
        outlined = true,
        kind = "image-unreported" |> Symbol,
        supplement = "Unreported Figure"
    )
end
