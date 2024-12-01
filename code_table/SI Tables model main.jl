# SI Tables model main.jl

bimodel = load_object("interaction models/base1_tie_2.jld2")

regtablet(
    [bimodel.tpr, bimodel.fpr],
    "honduras-css-paper/tables_si/" * "SI Table model main";
    modeltitles = ["TPR", "FPR"],
    caption = "Social network response model. Models of the individual cognizer responses on the determinants of accuracy with respondent, tie, and village characteristics.",
    stats = [nobs, aic, bic],
    roundvals = 4,
    understat = "ci",
    col1width = 10,
    supplement = "Supplementary Table",
    kind = Symbol("table-si")
)

model = load_object("interaction models/base1_tie_2_tie_robustness_inter.jld2")

regtablet(
    [model],
    "honduras-css-paper/tables_si/" * "SI Table model main intersect";
    modeltitles = ["TPR"],
    caption = "Social network response model, for the intersection-based tie robustness check. The TPR model is restricted to include only nominations made at both waves 3 and 4. Ties are further allowed to be considered true if at least one of the two nodes exists only at wave 4. Models of the individual cognizer responses on the determinants of accuracy with respondent, tie, and village characteristics.",
    stats = [nobs, aic, bic],
    roundvals = 4,
    understat = "ci",
    col1width = 10,
    supplement = "Supplementary Table",
    kind = Symbol("table-si")
)

bimodel = emodel(
    load_object("interaction models/base1_tie_2_tie_robustness_union.jld2"),
    load_object("interaction models/base1_tie_2_tie_robustness_union_fpr.jld2")
)

regtablet(
    [bimodel.tpr, bimodel.fpr],
    "honduras-css-paper/tables_si/" * "SI Table model main union";
    modeltitles = ["TPR", "TPR"],
    short_caption = "Social network response model, union-based tie",
    caption = "Social network response model, for the union-based tie robustness check. The TPR model is expanded to include nominations made at any wave of network data collection. Models of the individual cognizer responses on the determinants of accuracy with respondent, tie, and village characteristics characteristics.",
    stats = [nobs, aic, bic],
    roundvals = 4,
    understat = "ci",
    col1width = 10,
    supplement = "Supplementary Table",
    kind = Symbol("table-si")
)
