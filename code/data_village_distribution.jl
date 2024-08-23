include("../code/environment.jl")
invlink = AutoInvLink();

rg = load_object("objects/tpr_fpr_boot_data_rg.jld2");

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
rgv.color = ifelse.(
    rgv.coffee_cultivation, columbia.secondary[2], yale.blues[end]
)

save_object("objects/village_acc.jld2", rgv)
