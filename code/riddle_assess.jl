# riddle_2_assess.jl

include("../../code/setup/environment.jl")

#%%
invlink = AutoInvLink()

#%%
# via tpr_fpr_interaction_bimodel.jl
rg = load_object("interaction models/tpr_fpr_boot_data_rg.jld2")

otc = load_object(datapath * "outcomes_" * dte * ".jld2");
select!(otc, Not(ids.vc, :wave))
leftjoin!(rg, otc, on = :perceiver => :name)
# non-treated individuals, random villages only
@subset!(rg, .!:resp_target, .!:friend_treatment)
rgx = stack(rg, riddles; variable_name = :riddle, value_name = :knows);
rgx.riddle = [split(x, "_")[1] for x in rgx.riddle];
rgx.riddle = categorical(rgx.riddle);
rgx.ix = 1:nrow(rgx)
dropmissing!(rgx, :knows)

#%%
@inline fxx(rte) = @eval @formula(knows ~ $rte + riddle + relation + degree + age + age^2 + man + educated)

bm = let tp = GeneralizedLinearModel
    m1 = fit(tp, fxx(:tpr), rgx, Binomial(), LogitLink())
    m2 = fit(tp, fxx(:fpr), rgx, Binomial(), LogitLink())
    m3 = fit(tp, fxx(:j), rgx, Binomial(), LogitLink())
    
    (tpr = m1, fpr = m2, j = m3)
end

τs = (
    tpr = load_object("interaction models/tpr_τ.jld2"),
    fpr = load_object("interaction models/fpr_τ.jld2"),
    j = load_object("interaction models/τ_j.jld2"),
);

vcmats = let
    xs = [varcov([vec(r) for r in eachrow(reduce(hcat, τs.tpr))]) for r in [:tpr, :fpr, :j]]
    (tpr = xs[1], fpr = xs[2], j = xs[3])
end;

#%%
# regression table

adj_cfts = DataFrame[]
for r in [:tpr, :fpr, :j]
    ct = adjustedcoeftable(bm[r], vcmats[r]; overwrite = true)
    push!(adj_cfts, ct)
end

save_object("interaction models/riddle_models.jld2", [bm, adj_cfts])

#%%

rgs = let yvar = :knows, df = rgx
    r = :tpr
    mn, mx = round.(extrema(df[!, r]); digits = 2)
    ed = Dict(r => mn:0.01:mx, :age => mean(df.age))
    rg = referencegrid(df, ed)
    effects!(rg, bm[r], vcmats[r]; invlink)
    rg.ci = ci.(rg[!, yvar], rg[!, :err])
    rg.lower = [first(x) for x in rg.ci]
    rg.upper = [last(x) for x in rg.ci]
    rg1 = deepcopy(rg)

    r = :fpr
    mn, mx = round.(extrema(df[!, r]); digits = 2)
    ed = Dict(r => mn:0.01:mx, :age => mean(df.age))
    rg = referencegrid(df, ed)
    effects!(rg, bm[r], vcmats[r]; invlink)
    rg.tnr = 1 .- rg.fpr
    rg.ci = ci.(rg[!, yvar], rg[!, :err])
    rg.lower = [first(x) for x in rg.ci]
    rg.upper = [last(x) for x in rg.ci]
    rg2 = deepcopy(rg)

    r = :j
    mn, mx = round.(extrema(df[!, r]); digits = 2)
    ed = Dict(r => mn:0.01:mx, :age => mean(df.age))
    rg = referencegrid(df, ed)
    effects!(rg, bm[r], vcmats[r]; invlink)
    rg.ci = ci.(rg[!, yvar], rg[!, :err])
    rg.lower = [first(x) for x in rg.ci]
    rg.upper = [last(x) for x in rg.ci]
    rg3 = deepcopy(rg)

    (tpr = rg1, tnr = rg2, j = rg3)
end

xf = DataFrame()
for r in [:tpr, :tnr, :j]
    x = select(rgs[r], r, :knows, :err)
    @subset!(x, $r .∈ Ref(extrema(rgs[r][!, r])))
    sort!(x, r; rev = true)
    x2 = empairs(x, eff_col = :knows, err_col = :err)
    x2.ci = ci.(x2.knows, x2.err)
    x2
    x2.rate .= string(r)
    rename!(x2, r => :Contrast)
    append!(xf, x2)
end

xf[!, "Pr(>|z|)"] = pvalue.(xf.knows, xf.err);

save_object("interaction models/riddle_data.jld2", [rgs, xf])

## riddle contrasts

rgs_riddle = let yvar = :knows, df = rgx
    ed = Dict(:riddle => sunique(df.riddle), :age => mean(df.age))
    
    r = :tpr
    rg = referencegrid(df, ed)
    effects!(rg, bm[r], vcmats[r]; invlink)
    rg.ci = ci.(rg[!, yvar], rg[!, :err])
    rg.lower = [first(x) for x in rg.ci]
    rg.upper = [last(x) for x in rg.ci]
    rg1 = deepcopy(rg)

    r = :fpr
    rg = referencegrid(df, ed)
    effects!(rg, bm[r], vcmats[r]; invlink)
    rg.ci = ci.(rg[!, yvar], rg[!, :err])
    rg.lower = [first(x) for x in rg.ci]
    rg.upper = [last(x) for x in rg.ci]
    rg2 = deepcopy(rg)

    r = :j
    rg = referencegrid(df, ed)
    effects!(rg, bm[r], vcmats[r]; invlink)
    rg.ci = ci.(rg[!, yvar], rg[!, :err])
    rg.lower = [first(x) for x in rg.ci]
    rg.upper = [last(x) for x in rg.ci]
    rg3 = deepcopy(rg)

    (tpr = rg1, tnr = rg2, j = rg3)
end

xf_riddle = DataFrame()
for r in [:tpr, :tnr, :j]
    x = select(rgs_riddle[r], :riddle, :knows, :err)
    sort!(x, :riddle; rev = true)
    replace!(x.riddle, "zinc" => "Zinc usage", "prenatal" => "Prenatal care", "cord" => "Umbilical cord care")
    x2 = empairs(x, eff_col = :knows, err_col = :err)
    x2.ci = ci.(x2.knows, x2.err)
    x2
    x2.rate .= string(r)
    rename!(x2, :riddle => :Contrast)
    append!(xf_riddle, x2)
end

xf_riddle[!, "Pr(>|z|)"] = pvalue.(xf_riddle.knows, xf_riddle.err);

save_object(
    "honduras-css-paper/objects/riddle_riddle_data.jld2",
    [rgs_riddle, xf_riddle]
)
