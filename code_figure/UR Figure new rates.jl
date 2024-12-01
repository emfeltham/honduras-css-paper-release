# new rates.jl

include("../../code/setup/environment.jl")

rgs, _ = load_object("objects/riddle_data.jld2");

rd_ef, rd = load_object("objects/rates_data_2.jld2")
rd.tnr = 1 .- rd.fpr;

#%%

fx = @formula(tpr ~ fpr + fpr^2)
msq = lm(fx, rd)
rd.tpr_msq = predict(msq);
sort!(rd, :fpr)

mx, lc = findmax(rd.tpr_msq - rd.fpr)
rd.tpr_msq[lc] - rd.fpr[lc] # J
rd.tpr_msq[lc] + rd.fpr[lc] # PPB

rd.ppb = rd.tpr_msq + rd.fpr
mean(rd.ppb)

@subset rd (:ppb .< 1.0001) .& (:ppb .> 0.9999)


#%%

fg = Figure();
p = GridLayout(fg[1, 1]);

# TPR-FPR panel
let

    ax_rate = Axis(
        p[1, 1], ylabel = "TPR", xlabel = "FPR", aspect = 1
    );

    xlims!(ax_rate, 0, 1)
    ylims!(ax_rate, 0, 1)

    lw = rd_ef.lower
    hg = rd_ef.upper

    js = rd.j
    js_range = extrema(js)

    js = (js .- minimum(js)) * inv.(maximum(js) - minimum(js)) # unit-range
    c_ = [(berlin[j], 0.4) for j in js]

    # band for new reg line
    band!(
        ax_rate, rd.fpr, rd.fpr, rd.tpr_msq;
        color = (yale.grays[end-2], 0.15)
    )
    
    lines!(ax_rate, 0:0.1:1, 0:0.1:1, color = (:black, 0.8))
    lines!(ax_rate, 0:0.1:1, 1:-0.1:0, color = (:black, 0.4))

    scatter!(
        ax_rate, rd.fpr, rd.tpr;
        color = :transparent,
        strokecolor = c_,
        strokewidth = 1
    );

    # regression line
    lines!(ax_rate, rd_ef.fpr, rd_ef.tpr, color = yale.accent[1])
    lines!(ax_rate, rd_ef.fpr, lw, color = (yale.accent[1], 1), linestyle = :dash)
    lines!(ax_rate, rd_ef.fpr, hg, color = (yale.accent[1], 1), linestyle = :dash)

    # new regression line
    # rd[lc, :]
    vlines!(
        ax_rate,
        rd.fpr[lc];
        ymin = rd.fpr[lc], ymax = rd.tpr_msq[lc],
        color = ratecolor(:j)
    )
    lines!(ax_rate, rd.fpr, rd.tpr_msq, color = columbia.secondary[1])

    # color range should reflect original values
    Colorbar(
        p[1, 2]; label = "J", limits = js_range, colormap = :berlin
    )

    text!(
        ax_rate, rd.fpr[lc]+0.005, (rd.tpr_msq[lc] + rd.fpr[lc])/2;
        text = L"J_{\text{max}}"
    )

end

fg

#%%

fg = Figure();
p = GridLayout(fg[1, 1]);
# l = GridLayout(fg[1, 2]);

height_ = 300
width_ = 300

# TPR-FPR panel
let
    ef_, rd = load_object("objects/rates_data_2.jld2")
    rd.tnr = 1 .- rd.fpr;

    ax_rate = Axis(
        p[1, 1], ylabel = "TPR", xlabel = "TNR",
        width = width_,
        height = height_
    );
    lw = ef_.lower
    hg = ef_.upper

    js = rd.j
    js_range = extrema(js)

    js = (js .- minimum(js)) * inv.(maximum(js) - minimum(js)) # unit-range
    c_ = [(berlin[j], 0.4) for j in js]
    
    lines!(ax_rate, 0:0.1:1, 0:0.1:1, color = (:black, 0.8))
    lines!(ax_rate, 0:0.1:1, 1:-0.1:0, color = (:black, 0.4))

    scatter!(
        ax_rate, rd.tnr, rd.tpr;
        color = :transparent,
        strokecolor = c_,
        strokewidth = 1
    )

    lines!(ax_rate, 1 .- ef_.fpr, ef_.tpr, color = yale.accent[1])
    lines!(ax_rate, 1 .- ef_.fpr, lw, color = (yale.accent[1], 1), linestyle = :dash)
    lines!(ax_rate, 1 .- ef_.fpr, hg, color = (yale.accent[1], 1), linestyle = :dash)

    xlims!(ax_rate, 0, 1)
    ylims!(ax_rate, 0, 1)

    # ylims!(ax_rate, minimum(rd.tpr)-0.005, maximum(hg))
    # xlims!(ax_rate, extrema(ef_.fpr))

    # color range should reflect original values
    Colorbar(
        p[1, 2]; label = "J", limits = js_range, colormap = :berlin
    )
end

fg

#%%

js = rd.j
js_range = extrema(js)
js = (js .- minimum(js)) * inv.(maximum(js) - minimum(js)) # unit-range
c_ = [(berlin[j], 0.4) for j in js]

m1 = lm(@formula(tpr ~ tnr), rd)
m2 = lm(@formula(tpr ~ tnr + tnr^2), rd)

[bic(m1), bic(m2)]

#%%
fg1 = Figure();
let fg = fg1
    ax = Axis(fg[1, 1], aspect=1, xlabel = "FPR", ylabel = "TPR")
    xlims!(ax, 0, 1)
    ylims!(ax, 0, 1)

    lines!(ax, 0:0.1:1, 0:0.1:1, color = (:black, 0.8))
    lines!(ax, 0:0.1:1, 1:-0.1:0, color = (:black, 0.4))

    scatter!(
        ax, rd.fpr, rd.tpr;
        color = :transparent,
        strokecolor = c_,
        strokewidth = 1
    )
    rd.m2 = predict(m2)

    sort!(rd, :tnr)

    lines!(ax, rd.fpr, rd.m2, color = :black)
    Colorbar(
        fg[2, 1]; label = "J", limits = js_range, colormap = :berlin, vertical = false
    )

    ax2 = Axis(fg[1, 2], aspect=1, xlabel = "tradeoff", ylabel = "performance")

    xt = (rd.fpr + rd.m2) # .* (inv∘sqrt).(2)
    yt = (rd.m2 - rd.fpr) # * (inv∘sqrt).(2)
    lines!(ax2, xt, yt, color = :black) 
end
fg1

#%%

@inline U(x, y; α = 0.5, β = 0.5) = x^α * y^β
@inline G(x, z; α = 0.5, β = 0.5) = (z * x^(-α))^(inv(β))

fg2 = Figure();
let fg = fg2
    axf = Axis(fg[1,1])
    for c in 1:10
        lines!(axf, t, [G(e, c) for e in t])
    end
end

rd.fpr

# predicted tpr
jmx, jloc = findmax(rd.m2 - rd.fpr)
rd.tnr[jloc]
rd.tpr[jloc]

rd.m2[jloc] - rd.fpr[jloc]

fg3 = Figure();
let fg = fg3
    Y = Vector{Vector{Float64}}()
    X = .01:0.01:10
    for c in 1:10
        y = [G(x, c; α = 0.4, β = 0.6) for x in X]
        push!(Y, y)
    end
    
    ax = Axis(fg[1, 1])
    for y in Y
        lines!(X, y)
    end
    ylims!(ax, 0, 10)
    xlims!(ax, 0, 10)
end
fg3

fg4 = Figure();
let fg = fg4
    T = 1:10
    y = [G(t, ; α = 0.4, β = 0.6) for t in T]
    ax = Axis(fg[1, 1])
    lines!(ax, T, y)
    # xlims!(ax, 0, 1)
    # ylims!(ax, 0, 1)
end
fg4

#%%
fg = Figure();
lwr = 0.5-sqrt(0.5)/2; upr = 0.5+sqrt(0.5)/2; # boundaries for same area plot
color_ = :black
l1 = GridLayout(fg[1,1])
lt = GridLayout(fg[1,2])

ax = Axis(
    l1[1,1]; ylabel = "TPR", xlabel = "FPR", backgroundcolor = :transparent,
    yticks = ([lwr, (lwr+upr)/2, upr], string.([0, 0.5, 1])),
    xticks = ([lwr, (lwr+upr)/2, upr], string.([0, 0.5, 1])),
    aspect = 1
)
xlims!(ax, 0, 1)
ylims!(ax, 0, 1)


h(x) = 1 - x
xs = lwr:0.001:upr

lines!(xs, xs, color = (color_, 0.5))
lines!(xs, h.(xs), color = (color_, 0.5))

# visually, we want a smaller space for ax, and then relabel
# ax2 is half the area

hlines!(ax, [lwr, upr]; xmin = lwr, xmax = upr, color = color_)
vlines!(ax, [lwr, upr]; ymin = lwr, ymax = upr, color = color_)
hidespines!(ax)

vlines!(ax, [lwr, upr]; color = (color_, 0.1))
hlines!(ax, [lwr, upr]; color = (color_, 0.1))
vlines!(ax, [0, 1]; color = (color_, 0.1))
hlines!(ax, [0, 1]; color = (color_, 0.1))

# transformed axes
xtlim = (0, sqrt(2));
ytlim = (-sqrt(2)/2, sqrt(2)/2);
axt = Axis(
    lt[1,1];
    backgroundcolor = :transparent,
    xticks = ([xtlim[1], sqrt(2)/2, xtlim[end]], [L"\frac{-\sqrt{2}}{2}", L"\frac{\sqrt{2}}{2}", L"\sqrt{2}"]),
    yticks = (
        [ytlim[1], 0, ytlim[end]],
        [L"-", L"0", L"\frac{\sqrt{2}}{2}"] # using value at first index causes some odd error
    ),
    aspect = 1,
    xaxisposition = :top,
    yaxisposition = :right
)

axts = Axis(
    lt[1,1];
    ylabel = "J", xlabel = "PPB",
    backgroundcolor = :transparent,
    xticks = ([xtlim[1], sqrt(2)/2, xtlim[end]], string.([0.0, 1.0, 2.0])),
    yticks = ([ytlim[1], 0, ytlim[end]], string.([-1.0, 0.0, 1.0])),
    aspect = 1
)
hidedecorations!(axt, ticklabels = true)
linkaxes!(axts, axt)

## add axis with transformed values

vlines!(axt, [xtlim...]; color = (color_, 0.1))
hlines!(axt, [ytlim...]; color = (color_, 0.1))

xlims!(axt, xtlim)
ylims!(axt, ytlim)
xlims!(axts, xtlim)
ylims!(axts, ytlim)

hlines!(0, color = (color_, 0.5))
vlines!(sqrt(2)/2, color = (color_, 0.5))

lines!(axt, 0:0.1:1, 0:0.1:1; color = color_)
lines!(axt, 0:0.1:1, 0:-0.1:-1; color = color_)

g(x) = sqrt(2) - x
xs = 0:0.01:sqrt(2)
lines!(axt, xs, g.(xs); color = color_)

g2(x) = -sqrt(2) + x
xs = 0:0.001:sqrt(2)
lines!(axt, xs, g2.(xs); color = color_)

hidespines!(axt)
hidespines!(axts)
fg
