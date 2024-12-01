# SI Table model village.jl

include("../../code/setup/environment.jl")

bimodel = load_object("objects/main_village_added.jld2")

regtablet(
    [bimodel.tpr, bimodel.fpr],
    "honduras-css-paper/tables_si/" * "SI Table model village";
    modeltitles = ["TPR", "FPR"],
    caption = "Social network response model. Models of the individual cognizer responses on the determinants of accuracy with for additional village characteristics.",
    stats = [nobs, aic, bic],
    roundvals = 4,
    understat = "ci",
    col1width = 10,
)
