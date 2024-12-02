# contrast_tables.jl
# run locally

include("../../code/setup/environment.jl");
saveloc = "honduras-css-paper/Tables (extended data)/"

pdigits = 5;

#%%

md = load_object("objects/base1_tie2_margins_bs_out.jld2")
transforms = load_object("objects/variable_transforms.jld2")

rg = md[:age].rg
_, x = findmax(rg.j)
rg[x, :]

md[kin].rg

vbls = [
    :kin431,
    :relation,
    :educated,
    :educated_a,
    :man,
    :man_a,
    # :age,
    :age_mean_a,
    :age_diff_a,
    :religion_c,
    :religion_c_a,
    :isindigenous,
    :isindigenous_a,
    :degree,
    :degree_mean_a,
    :degree_diff_a,
    :wealth_d1_4, 
    :wealth_d1_4_mean_a,
    :wealth_d1_4_diff_a,
    :coffee_cultivation
];

vars = [:man, :age, :educated, :wealth_d1_4, :degree];
vars_supp = [:religion_c, :isindigenous];

# back-transform relevant cts. variables
for e in [
    :age, :degree, :dists_p, :dists_a, :age_mean_a, :age_diff_a, :degree_mean_a, :degree_diff_a
]
	md[e].rg[!, e] = reversestandard(md[e].rg, e, transforms)
end

e = :man
md[e].rg[!, e] = replace(
	md[e].rg[!, e], true => "Man", false => "Woman"
) |> categorical

e = :isindigenous
md[e].rg[!, e] = replace(
	md[e].rg[!, e], true => "Indigenous", false => "Mestizo"
) |> categorical

#%%

cts = DataFrame();
for e in vbls
    var_add!(cts, e, md; rounddigits = 2)
end

#%%
# include maximum J point, since curvilinear
let
    e = :age
    md_, mrgvarname = md[e]
    mgd_ = @subset md_ .!$kin;
    vls = [sort([extrema(mgd_[!, e])...]; rev = true)..., mgd_[findmax(mgd_[!, :j])[2], e]];
    @subset! mgd_ $e .∈ Ref(vls)
    var_add!(cts, e, mrgvarname, mgd_)
end

let 
    e = :dists_p
    md_, mrgvarname = md[e]
    md_ = @subset md_ .!$kin;
    vls1 = sort(md_[!, e])[[1,2,end]]
    @subset!(md_, $e .∈ Ref(vls1))
    var_add!(cts, e, mrgvarname, md_)
    ix1 = findfirst((cts.vbl .== e) .& (cts.Contrast .== "17.5 > 0.0"))
    ix2 = findfirst((cts.vbl .== e) .& (cts.Contrast .== "1.0 > 0.0"))
    cts.Contrast[ix1] = "17.5 > No path"
    cts.Contrast[ix2] = "1.0 > No path"
end

let 
    e = :dists_a
    md_, mrgvarname = md[e]
    md_ = @subset md_ .!$kin;
    vls1 = sort(md_[!, e])[[1,2,end]]
    @subset!(md_, $e .∈ Ref(vls1))
    var_add!(cts, e, mrgvarname, md_)
    ix1 = findfirst((cts.vbl .== e) .& (cts.Contrast .== "19.0 > 0.0"))
    ix2 = findfirst((cts.vbl .== e) .& (cts.Contrast .== "1.0 > 0.0"))
    cts.Contrast[ix1] = "19.0 > No path"
    cts.Contrast[ix2] = "1.0 > No path"
end

replace!(cts.vbl, :relation => :relation_a);
replace!(cts.vbl, :dists_p => :dists_p_a);

save_object("objects/contrast_df.jld2", cts)

#%% table
dout = contrasttable(cts);

# fix NaN cases
dout.FPR = replace.(dout.FPR, "NaN" => "")
dout.TPR = replace.(dout.TPR, "NaN" => "")
dout.J = replace.(dout.J, "NaN" => "")

dout.FPR = replace.(dout.FPR, "(, )" => "")
dout.TPR = replace.(dout.TPR, "(, )" => "")
dout.J = replace.(dout.J, "(, )" => "")

#
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

#%% table respondents
dout_r.Variable[1] = dout_r.Variable[1] * " \\ " * "#text(fill: lbg)[95% CI]" * " \\ " * "#text(fill: lbg)[_P_]"
tbx = tablex(dout_r; superheader, scientificnotation = true, rounddigits = pdigits);

table_export(
    saveloc * "ED Table contrasts respondent",
    tbx;
    extra,
    placement = :auto,
    short_caption = "Contrasts for respondent and village characteristics.",
    caption = "Contrasts for respondent and village characteristics. Each accuracy measure represents the difference between the predicted value for each level of the contrast. 95% confidence intervals are presented in parentheses below the mean estimates. The corresponding p-values are presented below the intervals, and are rounded to 5 digits.",
    kind = Symbol("table-ed"),
    supplement = "Extended Data Table",
    numbering = "1",
    gap = Symbol("0.65em"),
    outlined = true
)

#%% tabel tie
dout_t = @subset dout :Subject .== "Tie"
select!(dout_t, Not(:Subject))

dout_t.Variable[1] = dout_t.Variable[1] * " \\ " * "#text(fill: lbg)[95% CI]" * " \\ " * "#text(fill: lbg)[_P_]"
tbx = tablex(dout_t; superheader, scientificnotation = true, rounddigits = pdigits);

table_export(
    saveloc * "ED Table contrasts tie",
    tbx;
    extra,
    placement = :auto,
    short_caption = "Contrasts for tie chracteristics.",
    caption = "Contrasts for tie chracteristics. Each accuracy measure represents the difference between the predicted value for each level of the contrast. 95% confidence intervals are presented in parentheses below the mean estimates. The corresponding p-values are presented below the intervals, and are rounded to 5 digits.",
    kind = Symbol("table-ed"),
    supplement = "Extended Data Table",
    numbering = "1",
    gap = Symbol("0.65em"),
    outlined = true
)
