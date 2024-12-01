# basic_numbers.jl

include("../../code/setup/analysis preamble.jl")

#%% ties surveilled

dats = let
    crt2 = @subset(cr, $socio)
    crf2 = @subset(cr, .!$socio)

    sort!(crt2, [:perceiver, :order]);
    sort!(crf2, [:perceiver, :order]);
    bidata(crt2, crf2)
end;

@chain unique(dats.tpr, [:alter1, :alter2]) begin
    combine(nrow => :n)
end

@chain unique(dats.fpr, [:alter1, :alter2]) begin
    combine(nrow => :n)
end

@chain unique(cr, [:alter1, :alter2]) begin
    combine(nrow => :n)
end

#%% total number of ties in villages
con = load_object(datapath * "connections_data_" * dte * ".jld2");

@subset! con :wave .== 4;
css_villages = unique(cr[!, :village_code]);

@assert nrow(@subset(con, :village_code .∈ Ref(css_villages))) == nrow(con)

unique(con.relationship)

c_ = @subset con :relationship .∈ Ref([rl.ft, rl.pp, "are_related"])

unique(c_.relationship)

c_out = @chain c_ begin
    groupby(:relationship)
    combine(nrow => :count)
end

CSV.write("con_counts.csv", c_out)

unique(c_, :tie)