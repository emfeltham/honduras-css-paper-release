# check bootstrap.jl

# m0a, m0b, m0c = load_object("interaction models/simple.jld2");
m1 = load_object("interaction models/base1_c.jld2");
# m2i = load_object("interaction models/interaction_2.jld2");

bimodal, pbs = let
    m1i = load_object("interaction models/interaction_1.jld2");
    m1i_pbs = load_object("interaction models/interaction_1_pb.jld2");
    m1i_pbs = (tpr = m1i_pbs[1], fpr = m1i_pbs[2], );

    bimodal = m1i; pbs = m1i_pbs;
end

prds = [
    :response,
    :kin431, :relation,
    :age, :man,
    :educated,
    :degree_centrality,
    :dists_p_notinf, :dists_p
];

dats = let
    crt2 = dropmissing(crs.tpr, prds);
    crf2 = dropmissing(crs.fpr, prds);

    sort!(crt2, [:perceiver, :order]);
    sort!(crf2, [:perceiver, :order]);
    bidata(crt2, crf2)
end

invlink = logistic;
iters = 10_000;

bpd.margins[!, [kin, bpd.margvar, :peirce, :ci_j]]

jb = bpd.margins.bs_j[1];

mean(jb)

@assert bs.tpr - bs.fpr == bs.peirce

# the individual bootstrap means seem close to the calculated values
bs.tpr[1]
mean(bs.bs_tpr[1])

bs.tpr[1] - mean(bs.bs_tpr[1]) # tpr is off more than fpr by a factor of 10
bs.fpr[1] - mean(bs.bs_fpr[1])

bs.fpr[1]
mean(bs.bs_fpr[1])

let fg = Figure()
    lo = fg[1,1] = GridLayout()
    axs = [Axis(lo[1,i]) for i in 1:3]
    bss = [bs.bs_tpr[1], bs.bs_fpr[1], bs.bs_j[1]]
    est = [bs.tpr[1], bs.fpr[1], bs.peirce[1]]
    for (a, b, c) in zip(axs, bss, est)
        hist!(a, b)
        vlines!(a, mean(b); color = wc[1])
        vlines!(a, median(b); color = :black, linestyle = :dot)
        vlines!(a, c; color = wc[2])
    end
    colsize!(fg.layout, 1, Aspect(1, 3))
    resize_to_layout!(fg)
    fg
end

xb = fill(NaN, iters)
for i in eachindex(xb)
    xb[i] = rand(bs.bs_tpr[1]) - rand(bs.bs_fpr[1])
end

(bs.tpr[1] - bs.fpr[1]) - (mean(bs.bs_tpr[1]) - mean(bs.bs_fpr[1]))

##

bred = @chain pbs.tpr.β begin
    DataFrame()
    groupby([:coefname])
    combine(:β => mean; renamecols = false)
end;
bmodel = DataFrame(coefname = coefnames(bimodel.tpr), β_est = coef(bimodel.tpr));
bmodel.coefname = bred.coefname
leftjoin!(bred, bmodel; on = [:coefname])

##

##
q1, q2 = quantile(xb, [0.025, 0.975])
mxb = mean(xb)

θ = bs.peirce[1]
2mxb - q2, 2mxb - q1
2θ - q2, 2θ - q1

θ ± 1.96std(xb)
θ

let
    fg = Figure()
    ax = Axis(fg[1,1])
    hist!(ax, xb; bins = 50)
    vlines!(ax, [mxb, θ]; color = [wc[1], wc[2]])
    fg
end


q1, q2

2mxb - q2, 2*mxb - q1
