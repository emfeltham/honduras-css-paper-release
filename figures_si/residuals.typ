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
        "residuals.svg",
    ),
    caption: flex-caption(
[Binned residual plots of the primary models of the *(a)* TPR and *(b)* FPR. Lines represent the ± 2 standard error bounds. The model predictions are divided into 500 bins, with equal counts of observations. The average residual values of each bin are plotted against the average model prediction from each corresponding bin.],
[Model residuals]
),
    kind: "image-si",
    supplement: [*Supplementary Figure*],
) <residuals>
