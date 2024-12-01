# SI Table model main distance <= 3.jl

include("../../code/setup/environment.jl")

m = load_object("interaction models/main_model_limited_dist_3.jld2");

regtablet(
    [m[:tpr], m[:fpr]],
    "honduras-css-paper/tables_si/SI Table model main distance <= 3";
    caption = typst"Network response model, with restriction on distance. Comparison of models that only include observations where the geodesic distance in the network between $k$ and the $(i,j)$ pair is 3 or less.",
    short_caption = typst"Network response model, with restriction on distance.",
    modeltitles = [
        typst"TPR | $D_(r[i j]k) lt.eq 2$",
        typst"FPR | $D_(r[i j]k) lt.eq 2$",
    ],
    stats = [nobs, bic, aic],
)
