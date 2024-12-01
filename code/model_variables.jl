# model_variables.jl
# explore the input model variables

mdir = "model_variables/";

ndf = JLD2.load_object(datapath * "network_info_" * dte * ".jld2");
ndf4 = @subset ndf :wave .== 4;

rdf = let
    ndf4_ft = @subset ndf4 :relation .== "free_time";
    ndf4_pp = @subset ndf4 :relation .== "personal_private";

    dropmissing!(rhv4, [:name, :village_code])

    rdf1 = select(rhv4, :name, :village_code);
    join_ndf_df!(rdf1, ndf4_ft);
    select!(rdf1, :name, :degree, :degree_centrality, :betweenness, :betweenness_centrality, :triangles)
    rdf2 = select(rhv4, :name, :village_code)
    join_ndf_df!(rdf2, ndf4_pp);
    select!(rdf2, :name, :degree, :degree_centrality, :betweenness, :betweenness_centrality, :triangles)
    [rename!(rdf1, x => Symbol(string(x) * "_ft")) for x in names(rdf1)[2:end]];
    [rename!(rdf2, x => Symbol(string(x) * "_pp")) for x in names(rdf2)[2:end]];
    leftjoin!(rdf1, rdf2, on = :name)
    rdf1
end

leftjoin!(rdf, rhv4, on = :name);

lm(@formula(degree_ft ~ degree_pp), rdf)
lm(@formula(betweenness_ft ~ betweenness_pp), rdf)

prds = [
    :response,
    :kin431, :relation,
    :age, :man,
    :educated,
    :degree_centrality,
    :dists_p_notinf, :dists_p
];

crg = @chain cr begin
    groupby([:relation, :socio4, :kin431])
    combine(nrow => :n)
    dropmissing
end

rdfx = @chain rdf begin
    select(:educated, :degree_centrality, :gender)
    dropmissing()
end

rdfxm = @chain rdfx begin
    groupby(:educated)
    combine(:degree_centrality => mean, renamecols = false)
end

rdfxm.educated = levelcode.(rdfxm.educated);

ms1 = let df = rdf
    m1 = lm(@formula(degree_ft ~ educated), df)
    m2 = lm(@formula(degree_centrality_ft ~ educated), df)
    m3 = lm(@formula(degree_pp ~ educated), df)
    m4 = lm(@formula(degree_centrality_pp ~ educated), df)
    ms = [m1, m2, m3, m4];

    regtable_typ(
        ms,
        mdir * "tables/m_degree_education";
        modeltitles = nothing,
        caption = "Relationship between education and degree.",
        stats = [nobs, aic, bic, r2],
        roundvals = 3,
        understat = "ci",
        col1width = 10,
    )
    ms
end

ef1 = let
    dsn = Dict(:educated => unique(rdfx.educated))
    ef = effects(dsn, m1; level = 0.95)
    
    ef.educated = categorical(ef.educated)
    levels!(ef.educated, levels(rdfx.educated))
    ef
end

fg0 = let df = rdfx, ef = ef1
    fg = Figure()
    xv = :educated
    yv = :degree_centrality
    lim = 0.45;
    d = Uniform(-lim, lim)
    lv = levels(df[!, xv])
    l1 = fg[1, 1] = GridLayout();
    xticks = (eachindex(lv), lv)
    ylabel = string(yv); xlabel = string(xv)
    ax1 = Axis(l1[1, 1]; xticks, ylabel, xlabel);
    x = levelcode.(df[!, xv])
    scatter!(ax1, x + rand(d, length(x)), df[!, yv], color = (oi[1], 0.05));
    vlines!(ax1, (eachindex(lv).-0.5)[2:end], color = :black)
    xlims!(ax1, lim, length(lv)+1-lim)

    lines!(ax1, levelcode.(ef[!, xv]), ef[!, yv], color = :black)
    band!(ax1, levelcode.(ef[!, xv]), ef.lower, ef.upper, color = (:yellow, 0.5))
    fg
end

let fg = fg0
    fn = mdir * "edu_degree_scatter.svg"
    save(fn, fg)
    figure_typ(
        fn;
        caption = "Degree centrality and education. Simple regression of education level on degree centrality (standardized) with 95% CI.",
        width_pct = 100
    )
end

##

fg1 = let fg = Figure(), df = rdfx
    xv = :educated
    yv = :degree_centrality
    
    lv = levels(df[!, xv])
    
    lo = fg[1:3, 1] = GridLayout();
    ls = [lo[i, 1] = GridLayout() for i in eachindex(lv)]
    axs = [Axis(ls[i][1, 1], xticks = 0:0.25:1, xticklabelsvisible = false) for i in eachindex(lv)];

    lax = Axis[]
    for i in eachindex(lv)
        lax = Axis(ls[i][1, 1]; yaxisposition = :right, ylabel = lv[i], ylabelrotation = -π/2)
        hidespines!(lax)
        hidexdecorations!(lax)
        hideydecorations!(lax, label = false)
    end

    for (e, ax) in zip(lv, axs)
        xix = df[!, xv] .== e;
        hist!(ax, df[xix, yv], bins = 30)
        vlines!(ax, mean(df[xix, yv]), color = :black)
        xlims!(ax, 0, 0.5)

        vlines!(ax, 0:0.25:0.5, color = (:grey, 0.2), linestyle = :dot)
    end

    axs[2].ylabel = string(xv)
    axs[end].xlabel = string(yv)
    axs[end].xticklabelsvisible = true

    colsize!(fg.layout, 1, Aspect(1, 2))
    resize_to_layout!(fg)

    rowgap!(lo, -5)

    # resize!(fg.scene, (0, 600))
    # resize_to_layout!(fg)
    fg
end

let fg = fg1
    fn = mdir * "edu_degree.svg"
    save(fn, fg)
    figure_typ(
        fn;
        caption = "Distribution of degree centrality, conditional on education level.",
        width_pct = 100
    )
end

##

rdfx = @chain rdf begin
    select(:educated, :degree_centrality, :gender, :age)
    dropmissing()
end

rdfxm = @chain rdfx begin
    groupby(:educated)
    combine(:age => mean, renamecols = false)
end

rdfxm.educated = levelcode.(rdfxm.educated);

m1 = let df = rdfx
    m1 = lm(@formula(age ~ educated), df)
    m2 = lm(@formula(age ~ educated + gender), df)
    ms = [m1, m2];

    regtable_typ(
        ms,
        mdir * "age_edu_mod";
        modeltitles = nothing,
        caption = "Relationship between education and age.",
        stats = [nobs, aic, bic, r2],
        roundvals = 3,
        understat = "ci",
        col1width = 10,
    )
    m1
end

fg2 = let fg = Figure(), df = rdfx
    xv = :educated
    yv = :age
    
    lv = levels(df[!, xv])
    
    lo = fg[1:3, 1] = GridLayout();
    ls = [lo[i, 1] = GridLayout() for i in eachindex(lv)]
    axs = [Axis(ls[i][1, 1], xticks = 0:0.25:1, xticklabelsvisible = false) for i in eachindex(lv)];

    lax = Axis[]
    for i in eachindex(lv)
        lax = Axis(ls[i][1, 1]; yaxisposition = :right, ylabel = lv[i], ylabelrotation = -π/2)
        hidespines!(lax)
        hidexdecorations!(lax)
        hideydecorations!(lax, label = false)
    end

    for (e, ax) in zip(lv, axs)
        xix = df[!, xv] .== e;
        hist!(ax, df[xix, yv], bins = 30)
        vlines!(ax, mean(df[xix, yv]), color = :black)
        xlims!(ax, 0, 1)

        vlines!(ax, 0:0.25:1, color = (:grey, 0.2), linestyle = :dot)
    end

    axs[2].ylabel = string(xv)
    axs[end].xlabel = string(yv)
    axs[end].xticklabelsvisible = true

    colsize!(fg.layout, 1, Aspect(1, 2))
    resize_to_layout!(fg)

    rowgap!(lo, -5)

    # resize!(fg.scene, (0, 600))
    # resize_to_layout!(fg)
    fg
end

let fg = fg1
    fn = mdir * "edu_degree.svg"
    save(fn, fg)
    figure_typ(
        fn;
        caption = "Distribution of degree centrality, conditional on education level.",
        width_pct = 100
    )
end
