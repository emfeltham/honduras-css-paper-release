# model_comparison.jl
# compare the base to the interaction models

prds = [
    :response,
    :kin431, :relation,
    :age, :man,
    :educated,
    :degree,
    :dists_p_notinf, :dists_p
];

dats = let
    crt2 = dropmissing(crt, prds);
    crf2 = dropmissing(crf, prds);

    sort!(crt2, [:perceiver, :order]);
    sort!(crf2, [:perceiver, :order]);
    bidata(crt2, crf2)
end;

let
m1 = load_object("interaction models/base1_c.jld2")
m1c = load_object("interaction models/interaction1_c.jld2");
m2c = load_object("interaction models/interaction2_c.jld2");

ms = [];
for m in [m1, m2c, m1c], r in rates
    push!(ms, m[r])
end

# add #show figure: set block(breakable: true)
regtablet(
    ms,
    "honduras-css-paper/tables_si/" * "aim1_models";
    modeltitles = nothing,
    caption = "Relationship between education and age.",
    stats = [nobs, aic, bic, r2],
    roundvals = 3,
    understat = "ci",
    col1width = 10,
    supplement = "Supplementary Table",
    kind = Symbol("table-si")
)
end

## perceiver level predictions

# select model variables
regvars = [
    :age, :man, :educated,
    # exclude repeated-within-subject variables
    # :degree,
    # :kin431, # => set kin431 to false
    # :relation,
    # :dists_p_notinf, :dists_p_i, 
    # only for convenience (not needed to define person by the model)
    :perceiver, :village_code
];

# improve on degree: use the average of the two network variables for that person

efdicts = let dats = dats
    dt_ = dats.tpr;
    df_ = dats.fpr;
    
    # separate or the same (across rates)?
    ds = [dats[x].dists_p[dats[x].dists_p .!= 0] for x in rates];
    distmean = mean(reduce(vcat, ds))    

    tpr_dict = Dict(
        :kin431 => false,
        :dists_p => distmean
    );

    fpr_dict = deepcopy(tpr_dict);
    fpr_dict[:dists_a] = mean(df_[df_[!, :dists_a] .!= 0, :dists_a])
    (tpr = tpr_dict, fpr = fpr_dict)
end


# set mean for within specific within-subject values
# v = :relation;
# relation_means = Dict(r => 0.0 for r in rates)
# for r in rates
#     bef[r][!, v] .= a = mean(levelcode.(dats[r][!, v]) .- 1)
#     relation_means[r] = a    
# end

# ndf = JLD2.load_object(datapath * "network_info_" * dte * ".jld2");

rdf = let
    ndf4 = @subset ndf :wave .== 4;

    ndf4_ft = @subset ndf4 :relation .== "free_time";
    ndf4_pp = @subset ndf4 :relation .== "personal_private";

    dropmissing!(rhv4, [:name, :village_code])

    rdf1 = select(rhv4, :name, :village_code);
    join_ndf_df!(rdf1, ndf4_ft);
    select!(rdf1, :name, :degree, :degree_centrality, :betweenness, :betweenness_centrality, :triangles)
    applystandards!(rdf1, transforms)
    rdf2 = select(rhv4, :name, :village_code)
    join_ndf_df!(rdf2, ndf4_pp);
    select!(rdf2, :name, :degree, :degree_centrality, :betweenness, :betweenness_centrality, :triangles)
    applystandards!(rdf2, transforms)
    [rename!(rdf1, x => Symbol(string(x) * "_ft")) for x in names(rdf1)[2:end]];
    [rename!(rdf2, x => Symbol(string(x) * "_pp")) for x in names(rdf2)[2:end]];
    leftjoin!(rdf1, rdf2, on = :name)
    rdf1
end

rdf.degree = (rdf.degree_ft + rdf.degree_pp)/2;
rdf_ = select(rdf, [:name, :degree]);

befs = BiData[];
for m in [m1, m2c, m1c]
    bef = let m = m
        bef = refgrid_stage1(dats, regvars, efdicts; rates = rates);

        for r in rates; leftjoin!(bef[r], rdf_, on = :perceiver => :name) end
        # not sure why needed? because of different networks?
        for r in rates; dropmissing!(bef[r], :degree) end

        addeffects!(bef, m; rates)
        bef
    end
    push!(befs, bef)
end

bf = BiData(DataFrame(), DataFrame());
for (i, b) in enumerate(befs)
    for r in rates
        b_ = select(b[r], [:perceiver, :village_code, :response])
        b_.model .= string(i)
        append!(bf[r], b_)
    end
end

# accuracy score distributions (over the three models)
fg = let
    fg = Figure();
    lo = fg[1, 1:2] = GridLayout();
    l1 = lo[1, 1] = GridLayout();
    l2 = lo[1, 2] = GridLayout();

    for (r, l) in zip(rates, [l1, l2])
        let df = bf[r]
            plt = data(df) * mapping(:response, row = :model) * histogram(bins = 100, normalization = :none) * visual(color = oi[1])
            draw!(l, plt)
        end
    end
    labelpanels!([l1, l2])

    fg
end

let fn = "model_variables/figures/individual_predictions.svg", fg = fg
    save(fn, fg)

    figure_typ(
        fn;
        caption = "Distribution of individual accuracy as the (A) true positive and (B) false positive rates. Scores are predicted values from models with (1) demographic characteristics, (2) interactions for relationship type and distance, and (3) interactions between all included main effects.",
        width_pct = 100
    )
end

fg1 = let
    fg = Figure();
    lo = fg[1, 1:2] = GridLayout();
    l1 = lo[1, 1] = GridLayout();
    l2 = lo[1, 2] = GridLayout();

    for (r, l) in zip(rates, [l1, l2])
        let df = bf[r]
            df.lc = levelcode.(df.perceiver)
            plt = data(df) * mapping(:lc, :response, row = :model, color = :man)
            # visual(color = (oi[1], 0.02))
            draw!(l, plt)
        end
    end
    labelpanels!([l1, l2])
    fg
end

bfc = deepcopy(bf);
for r in rates
    rename!(bfc[r], :response => r)
end

# combined rates
bfc = outerjoin(bfc.tpr, bfc.fpr, on = [:perceiver, :village_code, :model, :lc])

bfc_ = dropmissing(bfc, [:tpr, :fpr]);
bfc_.model = parse.(Int, bfc_.model)

fga = let df = bfc_
    fg = Figure();
    lo = fg[1, 1] = GridLayout()
    ls = [];
    for i in [(1,1), (1,2), (2,1)]
        l = lo[i...] = GridLayout()
        push!(ls, l)
    end
    for l in ls # aspect of each axis
        colsize!(l, 1, Aspect(1, 1.0))
    end
    axs = Axis[]
    for l in ls
        ax = Axis(l[1, 1])
        push!(axs, ax)
    end
    
    # xlims!(0,1)
    # ylims!(0,1)
    
    colsize!(fg.layout, 1, Aspect(1, 1)) # overall figure aspect
    resize_to_layout!(fg)

    linkaxes!(axs...)
    labelpanels!(ls)

    # for ax in axs
    #     # line of chance
    #     lines!(ax, (0:0.1:1), 0:0.1:1; linestyle = :dot, color = (:black, 0.5))
    #     # line of improvement
    #     lines!(ax, (1:-0.1:0.5), 0:0.1:0.5; linestyle = :solid, color = (oi[6], 0.5))
    #     lines!(ax, (0.5:-0.1:0), 0.5:0.1:1; linestyle = :solid, color = (oi[3], 0.5))
    # end

    gdf = groupby(df, :model)
    for (k, g) in pairs(gdf) # iterate over axis-data
        kd = KernelDensity.kde((g.fpr, g.tpr))
        co = contour!(
            axs[k.model], kd,
            levels = 10,
            colormap = :berlin,
        )
    end
        
    fg
end

let fn = "model_variables/figures/individual_predictions_bivar.svg", fg = fga
    save(fn, fg)

    figure_typ(
        fn;
        caption = "Bivariate distribution of individual accuracy. Scores are predicted values from models with (A) demographic characteristics, (B) interactions for relationship type and distance, and (C) interactions between all included main effects. Predictions are for non-kin judgements.",
        width_pct = 100
    )
end

@chain bfc_ begin
    groupby(:model)
    combine([:tpr, :fpr] => cor => :cor)
end

bfc2 = @subset(bfc_, :model .== 2);

leftjoin!(bfc2, rhv4, on = [:village_code, :perceiver => :name]);
leftjoin!(bfc2, rdf_, on =:perceiver => :name)

mrates1 = let df = bfc2
    fx = @formula(tpr ~ fpr + (1|village_code))
    fit(MixedModel, fx, df)
end

mrates2 = let df = bfc2
    fx = @formula(tpr ~ fpr * (man + educated + age + degree) + (1|village_code))
    fit(MixedModel, fx, df)
end

regtable_typ(
    [mrates1, mrates2],
    mdir * "tables/tpr_fpr_models";
    modeltitles = nothing,
    caption = "Models of the relationship between the TPR and the FPR. In model (2), we see that the relationship between the two rates is conditional on key demographic covariates.",
    stats = [nobs, aic, bic],
    roundvals = 3,
    understat = "ci",
    col1width = 10,
)
