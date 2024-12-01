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
        "qq_fpr_coefs.png",
    ),
    caption: flex-caption(
    [Normality of the estimated coefficients for the FPR model. We see that the bootstrap distribution of each estimated coefficient appears closely normal via quantile-quantile comparisons.],
    [Normality of the estimated coefficients for the FPR model]
    ),
    kind: "image-si",
    supplement: [*Supplementary Figure*]
) <qq_fpr_coefs>
