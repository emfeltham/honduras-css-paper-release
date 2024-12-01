# SI Table contrasts relatedness.jl

include("../../code/setup/analysis preamble.jl")

md = load_object("objects/base1_tie2_relatedness_margins_bs_out.jld2")

cts = DataFrame();

let
    e = :kinship
    md_, mrgvarname = md[e]
    mgd_ = @subset md_ .!$kin;
    vls = [sort([extrema(mgd_[!, e])...]; rev = true)..., mgd_[findmax(mgd_[!, :j])[2], e]];
    @subset! mgd_ $e .∈ Ref(vls)
    var_add!(cts, e, mrgvarname, mgd_)
end

dout = contrasttable(cts);

rename!(dout, :vardiff => :hline)
dout.hline = .!dout.hline
dout.hline[1] = false;

dout_r = @subset dout :Subject .== "Respondent"
select!(dout_r, Not(:Subject))

#%%
superheader = (content = [
    cellx(; colspan = 3),
    cellx(; content = "Difference", colspan = 3, align = :center),
    hlinex(; start_ = 3, stroke = Symbol("gray + 0.01em"))
], rownum = 1);
extra = "#let lbg = rgb(\"#63aaff\")\n#let org = rgb(\"#6d5319\")"

#%%

dout_r.Variable[1] = dout_r.Variable[1] * " \\ " * "#text(fill: lbg)[95% CI]" * " \\ " * "#text(fill: lbg)[_P_]"
tbx = tablex(dout_r; superheader, scientificnotation = true, rounddigits = 5);

table_export(
    "honduras-css-paper/tables/SI Table contrasts relatedness",
    tbx;
    extra,
    placement = :auto,
    short_caption = "Contrasts for genetic relatedness",
    caption = "Contrasts for genetic relatedness. Each accuracy measure represents the difference between the predicted value for each level of the contrast. 95% confidence intervals are presented in parentheses below the mean estimates. The corresponding p-values are presented below the intervals, and are rounded to 5 digits.",
    kind = Symbol("table-si"),
    supplement = "Supplementary Table",
    numbering = "1",
    gap = Symbol("0.65em"),
    outlined = true
)
