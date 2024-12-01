# network_prediction.jl
# cf. AN note on 2024-05-19

include("../../code/setup/analysis preamble.jl")

#%% data prep
#=
    replicates and copies some code from `make_data.jl`
    we need to combine the actual network data with the model predictions for
    the beliefs
=#

# the most recent version of this is not correctly loaded
# in HondurasCSS or HondurasTools
function DataFrame2(gr::T; type = :node) where T <:AbstractMetaGraph
    fl, prps, en, nu = if type == :node
        :node => Int[], gr.vprops, vertices, nv
    elseif type == :edge
        :edge => Edge[], gr.eprops, edges, ne
    else
        error("You must specify type as :node or :edge")
    end

    dx = DataFrame(fl)

    # this block only applies if there are defined properties
    # on the MetaGraph object `gr`
    if length(values(prps)) > 0
        x = unique(reduce(vcat, values(prps)))
        for y in x
            for (k, v) in y
                if typeof(v) != Missing # update if there are non-missing entries
                    dx[!, k] = typeof(v)[]
                end
                if string(k) ∈ names(dx)
                    allowmissing!(dx, k)
                end
            end
        end
    end
    
    dx = similar(dx, nu(gr))

    for (i, e) in (enumerate∘en)(gr)

        dx[i, type] = e
        pr = props(gr, e)
        for (nme, val) in pr
            dx[i, nme] = val
        end
    end
    
    for v in Symbol.(names(dx))
        if !any(ismissing.(dx[!, v]))
            disallowmissing!(dx, v)
        end
    end
    return dx
end

# fill in the remaining ties (that do not exist)
function addfake!(gdf, g)
    for i in 1:nv(g)
        for j in 1:nv(g)
            if i < j
                if !has_edge(g, i, j)
                    push!(gdf, [Edge(i, j), g[i, :name], g[j, :name], false])
                end
            end
        end
    end
end


ndf = JLD2.load_object(datapath * "network_info_" * dte * ".jld2");
@subset!(ndf, :wave .== 4, :relation .∈ Ref(["free_time", "are_related"]));
select!(ndf, :village_code, :names, :graph, :degree, :wave, :relation)

rhv4 = load_object(datapath * "rhv4_" * dte * ".jld2");

css_villes = sunique(cr.village_code)

ndf.pop = length.(ndf.names)
# @subset! ndf :pop .< 80 :village_code .∈ Ref(css_villes)

vcx = 1 # 44

c1 = findfirst((ndf.village_code .== vcx) .& (ndf.relation .== "free_time"))
g = ndf[c1, :graph];
gdf = DataFrame2(g; type = :edge)
gdf.alter1 = [g[src(x), :name] for x in gdf.edge];
gdf.alter2 = [g[dst(x), :name] for x in gdf.edge];
@subset! gdf :alter1 .!= "No_One" :alter2 .!= "No_One"
gdf.socio4 .= true

addfake!(gdf, g)

rx = select(rhv4, :name, :village_code)
leftjoin!(gdf, rx, on = [:alter1 => :name])
dropmissing!(gdf, :village_code)

gdf.relation .= rl.ft;

# nets is global
# likely adjust css to be all possible combos

ndf_ = @subset(ndf, :village_code .== vcx)

perclist = cr.perceiver[cr.village_code .== vcx] |> sunique

xf = DataFrame()
for prc in perclist
    x = deepcopy(gdf)
    x.perceiver .= prc
    append!(xf, x)
end

xf.perceiver .∈ Ref(ndf_.names[1])
xf.perceiver = categorical(xf.perceiver)

cxd = cssdistances(xf, ndf_);

ndf_2 = @subset(ndf_, :relation .== "free_time")
ndf_deg = @chain ndf_2 begin
    flatten([:names, :degree])
    select(:names, :degree)
end

select!(
    cxd,
    :edge, :alter1, :alter2, :socio4, :village_code, :relation, :perceiver, 
    :dists_p, :dists_p_notinf, :dists_a, :dists_a_notinf, :are_related_dists_a
)

cxd.kin431 = cxd.are_related_dists_a .== 1;

leftjoin!(cxd, ndf_deg, on = [:perceiver => :names])

# join all model characteristics
# set kin at false and relation at "free_time"; everything else matches
# the alter or perceiver
# follow make data

cr = deepcopy(cxd);

leftjoin!(
    cr, rhv4;
    on = [:perceiver => :name, :village_code],
    matchmissing = :notequal
);

cr.relation = categorical(cr.relation);

code_variables!(cr);

cr.occ_simp = recode(cr.occupation,
    "Armed/police forces" => "Other",
    "Care work" => "Care work",
    "Dont_Know" => missing,
    "Emp. service/goods co." => "Other",
    "Farm owner" => "Other",
    "Merchant/bus. owner" => "Other",
    "Other" => "Other",
    "Profession" => "Other",
    "Retired/pensioned" => "Other",
    "Student" => "Other",
    "Trades" => "Other",
    "Unemp. disabled" => "Other",
    "Unemp. looking" => "Other",
    "Unemp: not looking" => "Other",
    "Work in field" => "Work in field"
);

cr.relig_weekly = recode(
    cr.relig_attend,
    "Never or almost never" => "<= Monthly",
    "Once or twice a year" => "<= Monthly",
    "Once a month" => "<= Monthly",
    "Once per week" => ">= Weekly",
    "More than once per week" => ">= Weekly"
);

cr.relig_weekly = passmissing(ifelse).(
    cr.relig_weekly .== ">= Weekly", true, false
);

cr.child = cr.children_under12 .> 0;

cr.religion_c = deepcopy(cr.religion);
replace!(cr.religion_c, "Mormon" => missing, "Other" => missing)

rhv4.religion_c = deepcopy(rhv4.religion);
replace!(rhv4.religion_c, "Mormon" => missing, "Other" => missing)

# %% tie variables

# network data
c2 = findfirst((ndf.village_code .== vcx) .& (ndf.relation .== "free_time"))
nsel = ndf[c2, :]
nsel = select(ndf, :relation, :names, :degree);
nsel = flatten(nsel, names(nsel)[2:end]);
rename!(nsel, :names => :name);

nsel = unique(nsel)

nsel = @chain nsel begin
    groupby([:name, :relation])
    combine(:degree => mean => :degree)
end

# respondent data

# variables to include as tie properties
tie_variables = [
    :age,
    :man,
    :educated, :wealth_d1_4, :religion_c,
    :isindigenous,
];

rsel = select(rhv4, :name, tie_variables...);

cssalt1 = deepcopy(cr[!, [:alter1, :relation]]);
cssalt2 = deepcopy(cr[!, [:alter2, :relation]]);

for (x, r) in zip([cssalt1, cssalt2], [:alter1, :alter2])
    leftjoin!(x, nsel; on = [r => :name, :relation])
end

for (x, r) in zip([cssalt1, cssalt2], [:alter1, :alter2])
    leftjoin!(x, rsel; on = [r => :name])
end

if !(cssalt1.alter1 == cxd.alter1) | !(cssalt2.alter2 == cxd.alter2)
    error("row mismatch")
end

for e in names(cssalt1)[3:end]
    rename!(cssalt1, e => e * "_a1")
end

for e in names(cssalt2)[3:end]
    rename!(cssalt2, e => e * "_a2")
end

cssalt = hcat(cssalt1, select(cssalt2, Not(:relation)));
cssalt1 = nothing
cssalt2 = nothing
rsel = nothing
nsel = nothing

cbl = [:age, :wealth_d1_4, :degree];

for cb in cbl
    amean!(cssalt, cb)
    adiff!(cssalt, cb)
end

function gendercat(a, b)
    return if (ismissing(a) | ismissing(b))
        missing
    elseif a & b
        "Men"
    elseif !(a | b)
        "Women"
    else
        "Mixed"
    end
end

cssalt.man_a = gendercat.(cssalt.man_a1, cssalt.man_a2);

cssalt.religion_c_a = passmissing(ifelse).(cssalt.religion_c_a1 .== cssalt.religion_c_a2, "Same", "Mixed")

function relcat(a, b)
    return if ismissing(a) | ismissing(b)
        missing
    elseif a == b
        "Both " * string(a)
    else
        string(a) * ", " * string(b)
    end
end

cssalt.religion_c_full_a = relcat.(cssalt.religion_c_a1, cssalt.religion_c_a2);
cssalt.religion_c_full_a = categorical(cssalt.religion_c_full_a);

function indigcat(a, b)
    return if ismissing(a) | ismissing(b)
        missing
    elseif a & b
        "Indigenous"
    elseif !(a | b)
        "Mestizo"
    else
        "Mixed"
    end
end

cssalt.isindigenous_a = indigcat.(cssalt.isindigenous_a1, cssalt.isindigenous_a2);
cssalt.isindigenous_a = categorical(cssalt.isindigenous_a);

#%%
function educat(a, b; basic = true)
    return if basic
        if ismissing(a) | ismissing(b)
            missing
        elseif a == b
            "Same"
        else
            "Mixed"
        end
    elseif !basic
        if ismissing(a) | ismissing(b)
            missing
        elseif a == b
            "Both " * string(a)
        else
            string(a) * ", " * string(b)
        end
    end
end

cssalt.educated_a = educat.(cssalt.educated_a1, cssalt.educated_a2);
cssalt.educated_full_a = educat.(cssalt.educated_a1, cssalt.educated_a2; basic = false);
for x in [:educated_a, :educated_full_a]
    cssalt[!, x] = categorical(cssalt[!, x])
end

# drop the individual alter values
select!(cssalt, names(cssalt)[.!(occursin.("_a1", names(cssalt)) .| occursin.("_a2", names(cssalt)))])

# test
if !(cssalt.alter1 == cr.alter1) | !(cssalt.alter2 == cr.alter2)
    error("row mismatch")
end

cr = hcat(cr, select(cssalt, Not(:relation, :alter1, :alter2)));

code_variables!(cr);

applystandards!(cr, transforms); # cf. reversestandards!

prds = [
    :kin431, :relation,
    :age, :man,
    :educated,
    :degree,
    :dists_p_notinf, :dists_p,
    :dists_a_notinf, :dists_a,
    :man_a,
    :age_mean_a,
    :age_diff_a,
    :religion_c,
    :religion_c_a,
    :isindigenous,
    :isindigenous_a,
    :degree_mean_a,
    :degree_diff_a,
    :wealth_d1_4, 
    :wealth_d1_4_mean_a,
    :wealth_d1_4_diff_a,
    :educated_a,
    :coffee_cultivation
];

idvars = [ids.vc, :perceiver, socio, :alter1, :alter2]

cr = select(cr, vcat(idvars, prds))

# JLD2.save_object("interaction models/" * "net pred village 2" * ".jld2", cr);

dropmissing!(cr)

#%%
# model
bimodel = load_object("interaction models/base1_tie_2.jld2")

pdat = (tpr = cr[cr.socio4, :], fpr = cr[.!cr.socio4, :]);
(nrow(pdat.tpr), nrow(pdat.fpr))

pdat.tpr.response .= NaN
pdat.fpr.response .= NaN

invlink = logistic

# long-running
effects!(pdat.tpr, bimodel.tpr; invlink)
effects!(pdat.fpr, bimodel.fpr; invlink)
# save_object("interaction models/" * "net pred village 2 eff" * ".jld2", pdat)

#pdat = load_object("interaction models/" * "net pred village 2 eff" * ".jld2")

# collapse (alter1,alter2)-wise and consider presenting based on threshold

cr2 = vcat(pdat.tpr, pdat.fpr);

cr3 = @chain cr2 begin
    groupby([:alter1, :alter2])
    combine([x => Ref => x for x in [:response, :err, kin, socio]])
end

@assert !any(length.(unique.(cr3.kin431)) .> 1)

cr3.kin431 = [x[1] for x in cr3.kin431];
cr3.socio4 = [x[1] for x in cr3.socio4];

cr3.response_bar = mean.(cr3.response);

gdf2 = leftjoin(
    gdf,
    select(cr3, :alter1, :alter2, :kin431, :response_bar),
    on = [:alter1, :alter2]
);

dropmissing!(gdf2)
gdf2.sim = rand.(Bernoulli.(gdf2.response_bar))
mg = MetaGraph(gdf2, :alter1, :alter2; edge_attributes = [:socio4, :kin431, :sim])

#save_object("honduras-css-paper/objects/net_plot_data_44.jld2", (graph = mg, edf = mg_edf, ))

mge = DataFrame2(mg)
rx = select(rhv4, [:name, :religion])
leftjoin!(mge, rx, on = :name)

countmap(mge.religion)