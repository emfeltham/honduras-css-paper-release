# figure ed coefplot tie model.jl

m1_tie = load_object("interaction models/base1_tie.jld2");
bcmp_tie = (tpr = coefplotdata(m1_tie.tpr), fpr = coefplotdata(m1_tie.fpr));

fg = Figure();
lo = fg[1, 1] = GridLayout();
l_coef = coefficientbiplot!(
    lo, [bcmp_tie];
    cnames = nothing
);
resize!(fg, 800, 800)
fg

let fg = fg
    caption = "Model coefficient estimates, including tie characteristics. Marginal effects from this model are presented in @figure4. All numeric covariates are standardized to the unit range. Coefficients are unadjusted from logistic models. Observe that alter-alter distances only appear in the FPR model."

    figure_export(
        "honduras-css-paper/figures_si/tiecoeff.svg",
        fg,
        save;
        caption,
        kind = Symbol("image-si"),
        supplement = "Extended Data Figure",
        outlined = true,
    )
end
