# SI Table model riddle.jl

include("../../code/setup/environment.jl")

bm, adj_cfts = load_object("interaction models/riddle_models.jld2")

regtablet(
    [bm.tpr, bm.fpr, bm.j],
    "honduras-css-paper/tables_si/" * "SI Table model riddle";
    coeftables = adj_cfts,
    modeltitles = nothing,
    short_caption = "Riddle models",
    caption = "Riddle models. Logistic models of riddle knowledge on the respondent-level accuracy metrics, adjusting for basic demographic characteristics. The model values are adjusted for error at both stages of estimation.",
    stats = [nobs],
    roundvals = 4,
    understat = "ci",
    col1width = 10,
    supplement = "Supplementary Table",
    kind = Symbol("table-si")
)
