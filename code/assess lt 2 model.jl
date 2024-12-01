# assess lt 2 model.jl

include("../../code/setup/environment.jl")

using Typstry

dd = Dict{String, Any}()

dd["lt2 model"] = load_object("interaction models/main_model_limited_dist.jld2");

dd["lt2 bs"] = (
    tpr = load_object("interaction models/main_model_limited_dist pb 1K tpr.jld2"),
    fpr = load_object("interaction models/main_model_limited_dist pb 1K fpr.jld2")
);

dd["model"] = load_object("interaction models/base1_tie_2.jld2")

regtablet(
    [
        dd["lt2 model"][:tpr], dd["model"][:tpr],
        dd["lt2 model"][:fpr], dd["model"][:fpr]
    ],
    "honduras-css-paper/tables_si/table lt 3 regtable";
    caption = typst"Network response model, with restriction on distance. Comparison of models that only include observations where the geodesic distance in the network between $k$ and the $(i,j)$ pair is 2 or less.",
    short_caption = typst"Network response model, with restriction on distance.",
    modeltitles = [
        typst"TPR | $D_(r[i j]k) lt.eq 2$",
        typst"TPR",
        typst"FPR | $D_(r[i j]k) lt.eq 2$",
        typst"FPR"
    ],
    stats = [nobs, bic, aic],
)

bm = load_object("interaction models/main_model.jld2")
