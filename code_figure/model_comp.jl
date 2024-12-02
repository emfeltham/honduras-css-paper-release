# compare the accuracy predictions across models

# relation-truth-subject-level TPR and FPR (model free)
sbar = errors(
    cr;
    truth = socio, grouping = [kin, :relation, :perceiver]
);

# subject-level averages
sbar = @chain sbar begin
    dropmissing!()
    @subset! :socio .> 3 ((:count .- :socio) .> 3)
    dropmissing([:tpr, :type1])
    groupby([kin, :relation, :tpr, :type1])
    combine(nrow => :count)
    @subset .!(isnan.(:tpr) .| isnan.(:type1))
    groupby([:relation, kin])
    combine(
        [x => Ref => x for x in [:tpr, :type1, :count]]...
    )
    sort!([:relation, kin])
end;

# relation-truth-subject-level TPR and FPR (model based)

# load relevant models
m1 = load_object("interaction models/base1_c.jld2");
m1i = load_object("interaction models/interaction_1.jld2");
m2i = load_object("interaction models/interaction_2.jld2");

modelnames = ["m0", "m1", "m1i", "m2i"];

# calculate marginal effects
prds = [
    :response,
    :kin431, :relation,
    :age, :man,
    :educated,
    :degree_centrality,
    :dists_p_notinf, :dists_p
];

regvars = [
    :age, :man, :educated,
    # exclude repeated-within-subject variables
    # :degree_centrality,
    # :kin431, # => set kin431 to false
    # :relation,
    # :dists_p_notinf, :dists_p_i, 
    # only for convenience
    :perceiver, :village_code
];

dats = let
    crt2 = dropmissing(crt, prds);
    crf2 = dropmissing(crf, prds);

    sort!(crt2, [:perceiver, :order]);
    sort!(crf2, [:perceiver, :order]);
    bidata(crt2, crf2)
end;

# dictionary of variable values / ranges for the reference grid
effectsdicts = let df = cr
    df = dropmissing(cr, [:relation, kin, :dists_p, :dists_a])

    d1 = Dict(
        :relation => sunique(df[!, :relation]),
        kin => sunique(df[!, kin]),
        :dists_p => df[df[!, :dists_p] .!= 0, :dists_p] |> mean,
    )

    df = @subset(df, .!($socio)); # only false ties -> range is correct
    d2 = deepcopy(d1)
    d2[:dists_a] = df[df[!, :dists_a] .!= 0, :dists_a] |> mean

    (tpr = d1, fpr = d2, )
end

# construct reference grids
m1_eff = referencegrid(dats, effectsdicts);

m0_eff = deepcopy(m1_eff);
apply_referencegrids!(m0, m0_eff; invlink = logistic);

m0a_eff = deepcopy(m1_eff);
apply_referencegrids!(m0a, m0a_eff; invlink = logistic);

m1i_eff = deepcopy(m1_eff);
m2i_eff = deepcopy(m1_eff);
# add model predictions to reference grid
for (m, me) in zip([m1, m1i, m2i], [m1_eff, m1i_eff, m2i_eff])
    apply_referencegrids!(m, me; invlink = logistic);
end

effs = let xs = DataFrame[];
    for (me, a) in zip([m0_eff, m1_eff, m1i_eff, m2i_eff], modelnames)
        x = bidatacombine(me; rates = rates)
        x.model .= a
        push!(xs, x)
    end
    reduce(vcat, xs)
end;

effs.ci = effs.response .± 1.96 .* effs.err;

# end effects calculation

# join the estimates for the roc plot
let efj = bidatajoin(m1i_eff; rates = rates)
    efj.accuracy = tuple.(efj.fpr, efj.tpr)
    select!(efj, Not(rates))
    leftjoin!(sbar, efj, on = [:relation, kin])
end

sbar.accuracy_unadj = [
    tuple(mean(x), mean(y)) for (x, y) in zip(sbar.type1, sbar.tpr)
];

# marginal effects across models

sort!(effs, [:relation, :model, kin, :rate])

# switch to prob correct
effs.prob_correct = effs.response;
effs.prob_correct_ci = effs.ci;

effs[!, :prob_correct] = ifelse.(effs.rate .== :fpr, 1 .- effs[!, :prob_correct], effs[!, :prob_correct]);

"""
replace tuple (v,v) with tuple (1-v, 1-v)
"""
@inline tuple_addinv(c) = (1 - c[1], 1 - c[2]);

effs[!, :prob_correct_ci] = ifelse.(
    effs.rate .== :fpr,
    tuple_addinv.(effs[!, :prob_correct_ci]),
    effs[!, :prob_correct_ci]
);

effs.marker = ifelse.(effs[!, kin], :rect, :cross);
effs.color = ifelse.(effs[!, :rate] .== :tpr, oi[5], oi[4]);

effs_youd = @chain effs begin
    select([kin, :relation, :response, :rate, :model])
    unstack(:rate, :response)
    @transform(:j = :tpr .- :fpr)
    dropmissing()
end
effs_youd.marker = ifelse.(effs_youd[!, kin], :rect, :cross);

effsg = groupby(effs, :relation);
effs_youdg = groupby(effs_youd, :relation);

fg_acccomp = let
    fg = Figure(backgroundcolor = :transparent);
    plo = fg[1, 1] = GridLayout();
    lo = plo[1, 1] = GridLayout();

    ax = Axis(
        lo[1, 1];
        xlabel = "model",
        ylabel = "accuracy",
        xticks = (
            1:(length(modelnames)*2),
            ["minimal", "none", "(kin, relation)", "all", "minimal", "none", "(kin, relation)", "all"]
        )
    );

    ax_ = Axis(
        lo[1, 1]; xaxisposition = :top,
        xticks = ([2.5, 6.5], ["free time", "personal private"]),
        xticksvisible = false
    );
    hideydecorations!(ax_)

    ax_y = Axis(lo[1, 1], yaxisposition = :right, ylabel = "Youden's J");
    hidexdecorations!(ax_y)

    linkaxes!(ax, ax_)
    linkxaxes!(ax, ax_, ax_y)


    for (e, a) in zip(effsg, [0, length(modelnames)])
        for i in eachindex(modelnames)
            sub = @subset e :model .== modelnames[i];
            y = sub[!, :prob_correct];
            cnft = sub[!, :prob_correct_ci];
            color = color = sub.color; marker = sub.marker
            rangebars!(ax, fill(a + i, nrow(sub)) .- 0.25, cnft; color = :black, marker)
            scatter!(ax, fill(a + i, nrow(sub)) .- 0.25, y; color, marker)
        end
    end

    for (e, a) in zip(effs_youdg, [0, length(modelnames)])
        for i in eachindex(modelnames)
            sub = @subset e :model .== modelnames[i];
            y = sub[!, :j]
            marker = sub.marker
            scatter!(ax_y, fill(a + i, nrow(sub)) .+ 0.25, y; color = oi[2], marker)
        end
    end

    vlines!(ax, length(modelnames) + 0.5, color = :black);
    ints = (1:length(modelnames)*2) .+ 0.5
    vlines!(ax, ints; color = :grey, linewidth = 0.5);

    xlims!(ax_y, 0.5, length(modelnames)*2+0.5)
    ylims!(ax_, 0, 1)
    ylims!(ax_y, -1, 1)

    resize_to_layout!(fg)
    fg
end

let
    caption = "Accuracy estimates for a typical individual. The estimates are stratified by relationship, and whether judgements are of kin or non-kin ties. Separate models estimate for true and false ties. Error bars represent 95% confidence intervals. Estimates are presented from a minimal model that only adjusts for the stratified categories along with distance, a model with demographic controls (but no interactions), a model that interacts each control with kin status and relationship, and a model with all pairwise interactions. Generally, we observe that the estimates change only very little across each specification."
    figure_export(
        "honduras-css-paper/Figures (SI)/acc_comp.svg",
        fg_acccomp,
        save;
        caption,
        kind = Symbol("image-si"),
        supplement = "*Supplementary Figure*"
    )
end