# ED Table kin accuracy.jl

saveloc = "honduras-css-paper/Tables (extended data)/"
css_path = "CSS/final_data/v1/css_edges_v1.csv";
basepath = "../";
css = CSV.read(basepath * css_path, DataFrame; missingstring = "NA");
con = load_object(datapath * "connections_data_" * dte * ".jld2");

clean_css!(css);
css = arrangecss(css)

begin
    c1 = nrow(css) != nrow(@subset(css, :alter1 .!= :alter2))
    c2 = nrow(con) != nrow(@subset(con, :ego .!= :alter))
    if c1 | c2
        error("rows do not match")
    end
end

# remove problem rows
@subset!(css, :alter1 .!= :alter2);
@subset!(css, :perceiver .!= :alter2);
@subset!(css, :perceiver .!= :alter1);
@subset!(css, :alter1 .!= :alter2);

# drop bad rows
dropmissing!(css, [:perceiver, :village_code, :response, :relation]);

# include("../setup/calculate css distances.jl");
# css = cssdx;

@subset!(css, :relation .== "are_related");
@subset!(css, :response .∉ Ref(["Dont_Know", "Refused", "Don't Know"]));

gt = load_object("clean_data/ground_truth_2023-11-20.jld2");
select(gt, :perceiver, :alter1, :alter2, :relation, :kin4, :kin431);

gk = unique(gt[!, [:alter1, :alter2, :kin431, :kin4]]);
@assert nrow(unique(gt[!, [:alter1, :alter2]])) == nrow(gk)

leftjoin!(css, gk, on = [:alter1, :alter2])
dropmissing!(css, :kin431)
css.think_kin = css.response .!= "None of the above";

@chain css begin
    groupby([:response, :kin4])
    combine(nrow => :n, :think_kin => sum => :count, :think_kin => mean => :rate)
    sort(:kin4)
end

css.tie = [Set([x,y]) for (x,y) in zip(css.alter1, css.alter2)];

ck = @subset con :relationship .== "are_related";
select!(ck, [:ego, :alter, :kintype, :tie, :wave]);
dropmissing!(ck, :kintype);

# save_object("interaction models/kintypes.jld2", ck)
# ck = load_object("interaction models/kintypes.jld2")

ck_ = @chain ck begin
    groupby(:tie)
    combine(:kintype => Ref∘unique => :kintype)
end

leftjoin!(css, ck_; on = :tie)

csx = select(css, :perceiver, :tie, :response, :kintype);

replace!(csx.kintype, missing => ["None of the above"])
csx.ident = [any(isequal.(x, r)) for (x, r) in zip(csx.response, csx.kintype)]

csx.len = length.(csx.kintype);
@subset! csx :len .== 1 # ignore problem cases

@subset csx :len .!= 1 # ignore problem cases

csx.kintype = [x[1] for x in csx.kintype];
select!(csx, Not(:ident, :len));
csx_ = select(csx, :perceiver, :tie, :kintype);

cr.tie = [Set([a1, a2]) for (a1, a2) in zip(cr.alter1, cr.alter2)];
leftjoin!(cr, csx_; on = [:perceiver, :tie])
cr.kintype = categorical(cr.kintype);

idtable = @chain csx begin
    groupby([:response, :kintype])
    combine(nrow => :n)
    # @transform(:frac = :ident .* inv.(:n))
end

ln = length(sunique(csx.kintype))
un = sunique(csx.kintype);

mt = fill(0, ln, ln);
for (e1, e2, e3) in zip(idtable.response, idtable.kintype, idtable.n)
    x = findfirst(un .== e1)
    y = findfirst(un .== e2)
    mt[x, y] = e3
end

using NamedArrays

mtn = NamedArray(mt, (un, un), ("Response", "Status"))

save_object("objects/kin_table_data.jld2", mtn)

mtn = load_object("objects/kin_table_data.jld2", mtn)

mtn = string.(round.(mtn ./ sum(mtn; dims = 2) .* 100; digits = 2))

typeof(mtn) <: NamedMatrix

dimnames(mtn)
names(mtn)

cells = CellX[];
for i in 1:size(mtn, 1)
    for j in 1:size(mtn, 2) 
        push!(cells, cellx(content = mtn[i,j], x = i, y = j))
    end
end

for (i, e) in enumerate(names(mtn)[1])
    push!(cells, cellx(content = e, x = 0, y = i))
    push!(cells, cellx(content = e, x = i, y = 0))
end

push!(cells, cellx(content = "Response \\ Status", x = 0, y = 0))

tb = [print(cell) for cell in cells] .* ","

cells = TableComponent[]

# top row
xd, yd = dimnames(mtn)
push!(cells, cellx(content = xd * " \\ " * yd))

for e in last(names(mtn))
    push!(cells, cellx(content = e, x = :auto, y = :auto))
end

push!(cells, hlinex(; start_ = 1))

# content rows
for i in eachindex(1:size(mtn, 1))
    cl = cellx(content = first(names(mtn))[i])
    push!(cells, cl)
    for j in eachindex(1:size(mtn, 2))
        cl = cellx(content = mtn[i, j])
        push!(cells, cl)
    end
end

push!(cells, hlinex(; start_ = 1))

tbx = tablex(cells)

table_export(
    saveloc * "Tables (extended data)/ED Table kin accuracy",
    tbx;
    short_caption = "Accuracy for kin ties",
    caption = "Survey respondents are remarkably accurate in their knowledge of the kinship relations in their networks. Rows indicate the response to survey question 6, where respondents indicate the type of kin relationship (if any) that holds between a presented pair. Columns indicate the status in the underlying sociocentric network. We see that correct identifications are made around 96.66% of the time, on average across the categories.",
    kind = "table-ed" |> Symbol,
    supplement = "Extended Data Table"
)

# percent of responses that correctly identify the kin relationship
idtable = @chain csx begin
    groupby([:response])
    combine(nrow => :n, :ident => sum => :ident)
    @transform(:frac = :ident .* inv.(:n))
end

@chain idtable begin
    combine(frac)
end
