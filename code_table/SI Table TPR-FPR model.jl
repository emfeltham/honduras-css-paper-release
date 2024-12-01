# SI Table TPR-FPR model.jl

include("../../code/setup/environment.jl")

m, adj_cft = load_object("rates_regtable_data_new.jld2")

regtablet(
    [m],
    "honduras-css-paper/tables_si/" * "SI Table TPR-FPR model";
    coeftables = [adj_cft],
    modeltitles = nothing,
    short_caption = "Model of TPR on FPR",
    caption = "Model of TPR on FPR. Model of the respondent-level TPR on the FPR and basic demographic characteristics. The model values are adjusted for error at both stages of estimation.",
    stats = [nobs],
    roundvals = 5,
    understat = "ci",
    col1width = 10,
    supplement = "Supplementary Table",
    kind = Symbol("table-si")
)
