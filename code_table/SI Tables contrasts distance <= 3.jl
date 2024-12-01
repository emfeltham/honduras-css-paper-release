# SI Tables contrasts distance <= 3.jl

include("../../code/setup/environment.jl");

#%%
pdigits = 5

md  = load_object("honduras-css-paper/objects/main_model_limited_dist_3_margins.jld2")
transforms = load_object(
    "honduras-css-paper/objects/variable_transforms_lt_3.jld2"
)

rg = md[:age].rg
_, x = findmax(rg.j)

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
    :coffee_cultivation,
    :dists_p,
    :dists_a
];

vars = [:man, :age, :educated, :wealth_d1_4, :degree];
vars_supp = [:religion_c, :isindigenous];

# back-transform relevant cts. variables
for e in [
    :age, :degree, :age_mean_a, :age_diff_a, :degree_mean_a, :degree_diff_a,
    :dists_p, :dists_a
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
# set this to match main analyses (natural point differs a little bit)
let
    e = :age
    md_, mrgvarname = md[e]
    mgd_ = @subset md_ .!$kin;
    
    # vls = [
    #     sort([extrema(mgd_[!, e])...]; rev = true)...,
    #     mgd_[findmax(mgd_[!, :j])[2], e]
    # ];

    # match main model analysis
    vls = [96, 14, 30.974];
    
    @subset! mgd_ $e .∈ Ref(vls)
    var_add!(cts, e, mrgvarname, mgd_)
end

replace!(cts.vbl, :relation => :relation_a);
replace!(cts.vbl, :dists_p => :dists_p_a);
replace!(cts.vbl, :dists_a => :dists_a_a);
replace!(cts.vbl, kin => :kin431_a);

#%% table
dout = contrasttable(cts);

# fix NaN cases
dout.FPR = replace.(dout.FPR, "NaN" => "")
dout.TPR = replace.(dout.TPR, "NaN" => "")
dout.J = replace.(dout.J, "NaN" => "")

dout.FPR = replace.(dout.FPR, "(, )" => "")
dout.TPR = replace.(dout.TPR, "(, )" => "")
dout.J = replace.(dout.J, "(, )" => "")

rename!(dout, :vardiff => :hline)
dout.hline = .!dout.hline
dout.hline[1] = false;

# dout[dout.Variable .== "Kin", :Subject] .= "Tie"

dout_r = @subset dout :Subject .== "Respondent"
select!(dout_r, Not(:Subject))

superheader = (content = [
    cellx(; colspan = 3),
    cellx(; content = "Difference", colspan = 3, align = :center),
    hlinex(; start_ = 3, stroke = Symbol("gray + 0.01em"))
], rownum = 1);
extra = "#let lbg = rgb(\"#63aaff\")\n#let org = rgb(\"#6d5319\")"

# column information
dout_r.Variable[1] = dout_r.Variable[1] * " \\ " * "#text(fill: lbg)[95% CI]" * " \\ " * "#text(fill: lbg)[_P_]"
tbx = tablex(dout_r; superheader, scientificnotation = true, rounddigits = pdigits);

#%% export cognizer table
table_export(
    "honduras-css-paper/tables_si/SI Table contrasts respondent distance <= 3",
    tbx;
    extra,
    placement = :auto,
    short_caption = typst"Contrasts for respondent and village characteristics, limited distance ($D_(k[i j]r) lt.eq 3$).",
    caption = typst"Contrasts for respondent and village characteristics, limited distance ($D_(k[i j]r) lt.eq 3$). Each accuracy measure represents the difference between the predicted value for each level of the contrast. 95% confidence intervals are presented in parentheses below the mean estimates. The corresponding p-values are presented below the intervals, and are rounded to 5 digits.",
    kind = :table,
    numbering = "1",
    gap = Symbol("0.65em"),
    outlined = true
)

dout_t = @subset dout :Subject .== "Tie"
select!(dout_t, Not(:Subject))

# column information
dout_t.Variable[1] = dout_t.Variable[1] * " \\ " * "#text(fill: lbg)[95% CI]" * " \\ " * "#text(fill: lbg)[_P_]"
tbx = tablex(dout_t; superheader, scientificnotation = true, rounddigits = pdigits);

#%% export tie table
table_export(
    "honduras-css-paper/tables_si/SI Table contrasts tie distance <= 3",
    tbx;
    extra,
    placement = :auto,
    short_caption = typst"Contrasts for tie chracteristics, limited distance ($D_(k[i j]r) lt.eq 3$)",
    caption = typst"Contrasts for tie chracteristics, limited distance ($D_(k[i j]r) lt.eq 3$). Each accuracy measure represents the difference between the predicted value for each level of the contrast. 95% confidence intervals are presented in parentheses below the mean estimates. The corresponding p-values are presented below the intervals, and are rounded to 5 digits.",
    kind = :table,
    numbering = "1",
    gap = Symbol("0.65em"),
    outlined = true
)
