# SI Table village size.jl
# base_models_village_dunbar_assess.jl

include("../../code/setup/analysis preamble.jl")
invlink = :logistic

m_smp = load_object("interaction models/main_village_added_dunbar.jld2")
pbs_smp = load_object("interaction models/main_village_added_dunbar_bootstrap.jld2");

dat.dunbar = dat.population .> 150;

margindict = Dict{Symbol, @NamedTuple{rg::DataFrame, name::String}}();
vbldict = [:dunbar => "N > 150"];

addmargins!(
    margindict, vbldict, m_smp, pbs_smp, dat, length(pbs_smp.tpr), invlink;
    margresolution = 0.001, allvalues = false,
)

save_object("interaction models/margindict_dunbar.jld2", margindict)

xt = margindict[e].rg
@subset! xt (.!$kin)
xt.tnr = 1 .- xt.fpr
xt.err_tnr = xt.err_fpr

xf = DataFrame()
for r in [:tpr, :tnr, :j]
    er = Symbol("err_" * string(r))
    x = select(xt, e, r, er)
    sort!(x, e; rev = true)
    x2 = empairs(x, eff_col = r, err_col = er)
    x2.ci = ci.(x2[!, r], x2[!, er])
    x2.rate .= string(r)
    rename!(x2, e => :Contrast, r => :Estimate, er => :Error)
    append!(xf, x2)
end

xf.rate = uppercase.(xf.rate);
for v in [:Estimate, :Error, :ci] xf[!, v] = round.(xf[!, v]; digits = 3); end
rename!(xf, :ci => "95% Conf. Int.", :rate => :Measure)
replace!(xf.Contrast, "true > false" => "N > 150 vs. N <= 150")

#%% export table

tbx = tablex(xf);

table_export(
    "honduras-css-paper/tables_si/SI Table village size",
    tbx;
    short_caption = "Contrasts for village size above 150",
    caption = "Contrasts for village size above 150",
    kind = "table" |> Symbol,
    supplement = "Table"
)
