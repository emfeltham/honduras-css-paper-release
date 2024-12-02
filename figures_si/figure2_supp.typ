// short captions
#let in-outline = state("in-outline", false)
#show outline: it => {
    in-outline.update(true)
    it
    in-outline.update(false)
}
#let flex-caption(long, short) = locate(loc => 
    if in-outline.at(loc) { short } else { long }
)

#figure(
    image(
        "figure2_supp.svg",
    ),
    caption: flex-caption(
[Model interaction term estimates. Estimates are from separate TPR and FPR models. Estimates are presented from model 3 in figure2, and include demographic controls, network degree, and interactions of each covariate with with kin status and relationship type. All numeric covariates are standardized to the unit range. Coefficients are unadjusted from logistic models. Observe that alter-alter distances only appear in the FPR model.],
[Model interaction term estimates]
),
    kind: image,
) <figure2_supp>
