include("../code/environment.jl")

#%% regression table
bm = load_object("interaction models/base1_tie_2_kinship.jld2");

regtablet(
    [bm.tpr, bm.fpr],
    "honduras-css-paper/tables_si/" * "kinship_models";
    coeftables = nothing,
    modeltitles = ["TPR", "FPR"],
    short_caption = "Response models, genetic relatedness",
    caption = "Response models, genetic relatedness. Models of the response, for TPR and FPR.",
    stats = [aic, bic, nobs],
    roundvals = 4,
    understat = "ci",
    col1width = 10,
    supplement = "Supplementary Table",
    kind = Symbol("table-si")
)
