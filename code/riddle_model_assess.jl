# riddle_model_assess.jl

include("../../code/setup/environment.jl")

K = 1_000
L = 1_000
invlink = logistic

otc = load_object(datapath * "outcomes_" * dte * ".jld2");
select!(otc, Not(ids.vc, :wave))

rgb = load_object("interaction models/tpr_fpr_boot_data_stage1.jld2")

for l in 1:K
    l_ = string(l)
    rgb[!, "j_" * l_] = rgb[!, "tpr_" * l_] - rgb[!, "fpr_" * l_]
end

leftjoin!(rgb, otc, on = :perceiver => :name)
rgbc = stack(rgb, riddles; variable_name = :riddle, value_name = :knows);
@subset!(rgbc, .!:resp_target, .!:friend_treatment)

bs = let
    tprm = load_object(
        "interaction models/riddle_boot_data_stage_2_" * string(:tpr) * "_3.jld2",
    )

    fprm = load_object(
        "interaction models/riddle_boot_data_stage_2_" * string(:fpr) * "_3.jld2",
    )
    
    (tpr = tprm, fpr = fprm, )
end

bs.tpr.β
bs.tpr.vcov

bm = let fast = false
    rte = :tpr
    fx = @eval @formula(
        knows ~ riddle + $rte + relation + degree + age + age^2 + man + religion_c +
        wealth_d1_4 + isindigenous +
        (1|perceiver) + (1|village_code)
    )
    m1 = fit(MixedModel, fx, rgbc, Binomial(), LogitLink(); fast)
    rte = :fpr
    fx = @eval @formula(
        knows ~ riddle + $rte + relation + degree + age + age^2 + man + religion_c +
        wealth_d1_4 + isindigenous +
        (1|perceiver) + (1|village_code)
    )
    m2 = fit(MixedModel, fx, rgbc, Binomial(), LogitLink(); fast)
    (tpr = m1, fpr = m2, )
end

# use these quantities to create bootstrapped effects reference grids
k = 1
l = 1

# reshape stage 2 bootstrap output to vector of β coefficients
vcmats = let
    num_β = length(bs.tpr.β[1])
    bs_βs = [fill(NaN, K) for _ in eachindex(1:num_β)];

    for i in eachindex(1:num_β)
        for j in 1:K
            bs_βs[i][j] = bs.tpr.β[j][i]
        end
    end
    vcmat1 = varcov(bs_βs);

    num_β = length(bs.fpr.β[1])
    bs_βs = [fill(NaN, K) for _ in eachindex(1:num_β)];

    for i in eachindex(1:num_β)
        for j in 1:K
            bs_βs[i][j] = bs.fpr.β[j][i]
        end
    end
    vcmat2 = varcov(bs_βs);

    (tpr = vcmat1, fpr = vcmat2)
end

#bs2

bb = vcat(DataFrame(bs2.β), DataFrame(bs3.β));
stderror(bm.tpr)
@chain bb begin
    groupby(:coefname)
    combine(:β => std => :se, :β => mean, :β => extrema)
end

b_tpr = let bres = bs.tpr
    num_β = length(bres.β[1])
    bs2β = [[fill(NaN, L) for _ in 1:K] for _ in eachindex(1:num_β)]

    for k in 1:K
        # θ_ = bs.tpr.θ[k]
        β_ = bres.β[k]
        ses = sqrt.(diag(bres.vcov[k]))

        for i in eachindex(1:num_β)
            bs2β[i][k] = rand.(Normal(β_[i], ses[i]), L)
        end
    end
    b_ = [reduce(vcat, bs2β[i])  for i in eachindex(bs2β)]
    vcmat = varcov(b_)
    df = DataFrame(:mean => mean.(b_), :extrema => extrema.(b_), :std => std.(b_))
    df, vcmat
end

b_fpr = let bres = bs.fpr
    num_β = length(bres.β[1])
    bs2β = [[fill(NaN, L) for _ in 1:K] for _ in eachindex(1:num_β)]

    for k in 1:K
        # θ_ = bs.tpr.θ[k]
        β_ = bres.β[k]
        ses = sqrt.(diag(bres.vcov[k]))

        for i in eachindex(1:num_β)
            bs2β[i][k] = rand.(Normal(β_[i], ses[i]), L)
        end
    end
    b_ = [reduce(vcat, bs2β[i])  for i in eachindex(bs2β)]
    vcmat = varcov(b_)
    df = DataFrame(:mean => mean.(b_), :extrema => extrema.(b_), :std => std.(b_))
    df, vcmat
end

b_tpr[1].coefname = coefnames(bm.tpr)
b_fpr[1].coefname = coefnames(bm.fpr)
bout = (tpr = b_tpr[1], fpr = b_fpr[1]);
vcmats2 = (tpr = b_tpr[2], fpr = b_fpr[2]);

rgs = let yvar = :knows
    r = :tpr
    mn, mx = round.(extrema(rgbc[!, r]); digits = 2)
    ed = Dict(r => mn:0.01:mx, :age => mean(rgbc.age))
    rg = referencegrid(rgbc, ed)
    effects!(rg, bm[r], vcmats[r]; invlink)
    rg.ci = ci.(rg[!, yvar], rg[!, :err])
    rg.lower = [first(x) for x in rg.ci]
    rg.upper = [last(x) for x in rg.ci]
    rg1 = deepcopy(rg)

    r = :fpr
    mn, mx = round.(extrema(rgbc[!, r]); digits = 2)
    ed = Dict(r => mn:0.01:mx, :age => mean(rgbc.age))
    rg = referencegrid(rgbc, ed)
    effects!(rg, bm[r], vcmats[r]; invlink)
    rg.tnr = 1 .- rg.fpr
    rg.ci = ci.(rg[!, yvar], rg[!, :err])
    rg.lower = [first(x) for x in rg.ci]
    rg.upper = [last(x) for x in rg.ci]
    rg2 = deepcopy(rg)

    (tpr = rg1, tnr = rg2)
end

sunique(rgbc.tpr - rgbc.fpr) == sunique(rgbc.j)

let fg = Figure();
    yvar = :knows
    trp = 0.4
    l = GridLayout(fg[1,1])
    ax = Axis(l[1, 1]; ylabel = "Riddle knowledge", xlabel = "Rate");
    ax_r = Axis(l[1, 1]; xlabel = "J", xaxisposition = :top);
    linkyaxes!(ax, ax_r)
    hideydecorations!(ax_r);
    
    for (rte) in [:tpr, :tnr]
        rg = rgs[rte]

        x = rg[!, rte]
        y = rg[!, yvar]
        lwr = rg[!, :lower]
        upr = rg[!, :upper]
        rc = ratecolor(rte)

        ax_ = ifelse(rte == :j, ax_r, ax)

        lines!(ax_, x, y; color = rc)
        band!(ax_, x, lwr, upr; color = (rc, trp))
    end
    
    #xlims!(ax, extrema(rgs[:tnr][!, :tnr]))
    #xlims!(ax_r, extrema(efj[!, :j]))
    #ylims!(ax_r, -0.01+min(minimum(rgs[:tpr][!, :lwr]), minimum(rgs[:tnr][!, :lwr]), minimum(efj[!, :lwr])), maximum(rgs[:tpr][!, :upr])+0.01)
    elems = [[PolyElement(; color = (rc, trp)), LineElement(; color = rc)] for rc in ratecolor.([:tpr, :tnr, :j])]
    Legend(l[1,2], elems, ["TPR", "TNR", "J"], "Accuracy")
    fg
end
