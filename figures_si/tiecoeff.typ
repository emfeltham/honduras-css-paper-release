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
        "tiecoeff.svg",
    ),
    caption: [Model coefficient estimates, including tie characteristics. Marginal effects from this model are presented in @figure4. All numeric covariates are standardized to the unit range. Coefficients are unadjusted from logistic models. Observe that alter-alter distances only appear in the FPR model.],
    kind: image,
) <tiecoeff>
