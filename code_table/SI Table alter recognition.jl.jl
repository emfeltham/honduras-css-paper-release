# SI Table alter recognition.jl

#=
check the number of individuals recognized.
=#

include("../../code/setup/environment.jl")

basepath = "../";
css_path = "CSS/final_data/v1/css_edges_v1.csv";
css = CSV.read(basepath * css_path, DataFrame; missingstring = "NA");
rename!(css, :respondent_master_id => :name);

cs1 = select(
    css,
    :name, :ego_id, :knows_ego,
);

cs2 = select(
    css,
    :name, :alter_id, :knows_alter
);

rename!(cs2, :alter_id => :ego_id, :knows_alter => :knows_ego)

csx = vcat(cs1, cs2);
csx = unique(csx);
csx.tie = tieset(csx, :name, :ego_id);

csx_ = @chain csx begin
    groupby(:knows_ego)
    combine(nrow => :N)
end

dropmissing!(csx_)

csx_[!, "Pct. recognized"] = round.(100 .* csx_.N ./ sum(csx_.N); digits = 2)

recode!(csx_[!, "knows_ego"], "Dont_Know" => "Don't know")
rename!(csx_, "knows_ego" => "Recognized")

csx_.Recognized = String.(csx_.Recognized)

# table export for Typst
tbx = tablex(csx_);

table_export(
    "honduras-css-paper/tables_si/SI Table alter recognition",
    tbx;
    short_caption = "Recognition of alters by survey respondents",
    caption = "Recognition of alters by survey respondents. As described in Methods, we check whether each survey respondent (cognizer) recognizes the individuals in the candidate pairs to be judged. When an individual does not recognize another, the corresponding pair is not shown. We observe that 93.5% of all individuals presented are recognized.",
    kind = "table" |> Symbol,
    supplement = "Table"
);
