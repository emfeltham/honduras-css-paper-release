# SI Table kin multiplexity counts.jl

include("../../code/setup/environment.jl")

# N.B. the main datasets here are imputed (subject to constraints)
# cf. "make_data.jl" for more details
cr = JLD2.load_object(datapath * "cr_" * "2024-05-01" * ".jld2");
code_variables!(cr);

cr.tie = [Set([a,b]) for (a,b) in zip(cr.alter1, cr.alter2)];

ctable = @chain cr begin
    select(kin, socio, :relation, :tie)
    unique()
    groupby([kin, socio, :relation])
    combine(nrow => :N)
end

rename!(
    ctable,
    "kin431" => "Kin", "socio4" => "Exists", "relation" => "Relationship"
)

for e in ["Kin", "Exists"]
    ctable[!, e] = replace(ctable[!, e], true => "Yes", false => "No")
end

ctable[!, :Relationship] = replace(ctable[!, :Relationship], rl.ft => "Free time", rl.pp => "Personal private")

css_table = ctable |> tablex;

table_export(
    "honduras-css-paper/tables_si/SI Table sampled multiplexity counts",
    tc_table;
    short_caption = "Multiplexity of sampled ties",
    caption = "Multiplexity of sampled ties. Counts of unique, symmetric ties shown to cognizers (survey respondents), stratified by their status in the reference network and kinship status.",
    kind = "table" |> Symbol,
    supplement = "Table"
);


#%%

con = load_object(datapath * "connections_data_" * dte * ".jld2");
@subset! con :village_code .∈ Ref(unique(cr.village_code));
# @subset! con :wave .== 4; # match socio431

tie_counts = @chain con begin
    groupby(:tie)
    combine(
        :relationship => Ref∘unique,
        :village_code => Ref∘unique => :village_codes,
        renamecols = false
    )
    @rtransform(
        :are_related = "are_related" .∈ Ref(:relationship),
        :free_time = "free_time" .∈ Ref(:relationship),
        :personal_private = "personal_private" .∈ Ref(:relationship),
        :vilage_code = first(:village_codes)
    )
    select(Not(:village_codes))
    @rtransform(:relationship = setdiff(:relationship, ["are_related"]))
    @subset :are_related 
    groupby([:are_related, :free_time, :personal_private])
    combine(nrow => :N)
end

tie_counts_4 = @chain con begin
    @subset! :wave .== 4; # match socio431
    groupby(:tie)
    combine(
        :relationship => Ref∘unique,
        :village_code => Ref∘unique => :village_codes,
        renamecols = false
    )
    @rtransform(
        :are_related = "are_related" .∈ Ref(:relationship),
        :free_time = "free_time" .∈ Ref(:relationship),
        :personal_private = "personal_private" .∈ Ref(:relationship),
        :vilage_code = first(:village_codes)
    )
    select(Not(:village_codes))
    @rtransform(:relationship = setdiff(:relationship, ["are_related"]))
    @subset :are_related 
    groupby([:are_related, :free_time, :personal_private])
    combine(nrow => :N)
end

for x in [tie_counts, tie_counts_4]
    rename!(
        x,
        "are_related" => "Kin", "free_time" => "Free time", "personal_private" => "Personal private"
    )
    select!(Not("Kin"))
end

tie_counts_4.Condition .= "Wave 4 only";
tie_counts.Condition .= "Any wave";
tc = vcat(tie_counts, tie_counts_4);
for x in ["Free time", "Personal private"]
    tc[!, x] = replace(tc[!, x], true => "Yes", false => "No")
end

tc_table = tc |> tablex;

table_export(
    "honduras-css-paper/tables_si/SI Table kin multiplexity counts",
    tc_table;
    short_caption = "Multiplexity of kin ties",
    caption = "Multiplexity of kin ties. Counts of kin ties across the village networks of all 82 villages, and whether they also exist as connections in the _free time_ and _personal private_ networks. Counts are separately tabulated from networks where ties are taken as true if they are reported in any wave of data collection, or only in wave 4.",
    kind = "table" |> Symbol,
    supplement = "Table"
);
