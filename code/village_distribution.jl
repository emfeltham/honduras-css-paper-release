# village_distribution.jl

include("../../code/setup/environment.jl")
invlink = AutoInvLink();

rg = load_object("interaction models/tpr_fpr_boot_data_rg.jld2");

rts = [:tpr, :fpr, :j];

rgv = @chain rg begin
    groupby([ids.vc, :relation])
    combine(
        [r => mean => r for r in rts]...,
        [r => std for r in rts]
    )
end

rhv4 = load_object(datapath * "rhv4_" * dte * ".jld2");
dropmissing!(rhv4, ids.vc)

vdf4 = unique(rhv4[!, [ids.vc, :coffee_cultivation, :elevation]])

leftjoin!(rgv, vdf4, on = ids.vc)
dropmissing!(rgv, :coffee_cultivation)

#%%
# coffee cultivation
rgv = @subset(rgv, :relation .== "free_time")
rgv.color = ifelse.(rgv.coffee_cultivation, columbia.secondary[2], yale.blues[end])
#[(berlin[e], 0.8) for e in rgv.j_stand];

fg = Figure();
l1 = GridLayout(fg[1,1])
l2 = GridLayout(fg[2,1])
let
    ax = Axis(l1[1,1], ylabel = "TPR", xlabel = "FPR")
    scatter!(
        ax,
        rgv.fpr, rgv.tpr; color = :transparent, strokewidth = 1,
        strokecolor = rgv.color
    )
    ## Colorbar(l1[1,2], colormap = :berlin, label = "J")
    axh = Axis(l2[1, 1:2], xlabel = "J");
    hist!(axh, rgv.j[rgv.coffee_cultivation], color = (columbia.secondary[1], 0.5); bins = 20)
    hist!(axh, rgv.j[.!rgv.coffee_cultivation], color = (yale.blues[end], 0.5); bins = 20)
    resize_to_layout!(fg)
    rowsize!(fg.layout, 2, Relative(1/3))
    rowgap!(fg.layout, 0)
    ylims!(axh, low = 0)
    labelpanels!([l1, l2])
end
fg

#%%
# elevation

mn, mx = extrema(rgv.elevation)
es = [unitize(e, mn, mx) for e in rgv.elevation]
rgv.color = [(berlin[e], 0.8) for e in es];

fg = Figure();
l1 = GridLayout(fg[1,1])
l2 = GridLayout(fg[2,1])
let
    ax = Axis(l1[1,1], ylabel = "TPR", xlabel = "FPR")
    scatter!(
        ax,
        rgv.fpr, rgv.tpr; color = :transparent, strokewidth = 1,
        strokecolor = rgv.color
    )
    ## Colorbar(l1[1,2], colormap = :berlin, label = "J")
    axh = Axis(l2[1, 1:2], xlabel = "J");
    scatter!(
        axh,
        rgv.elevation, rgv.j; color = :transparent, strokewidth = 1,
        strokecolor = ratecolor(:j)
    )
    resize_to_layout!(fg)
    rowsize!(fg.layout, 2, Relative(1/2))
    resize!(fg, 600, 900)
    rowgap!(fg.layout, 0)
    labelpanels!([l1, l2])
end
fg

##

#save_object("interaction models/village_acc.jld2", rgv)
