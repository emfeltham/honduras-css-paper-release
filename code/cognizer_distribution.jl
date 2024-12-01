# cognizer_distribution.jl

include("../../code/setup/environment.jl")
invlink = AutoInvLink();

rg = load_object("interaction models/tpr_fpr_boot_data_rg.jld2");

rts = [:tpr, :fpr, :j];

rgp = @chain rg begin
    groupby([:perceiver])
    combine(
        [r => mean => r for r in rts]...,
        [r => std for r in rts]
    )
end

save_object("interaction models/respondent_acc.jld2", rgp)
