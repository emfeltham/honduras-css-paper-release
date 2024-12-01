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
        "SI Figure results degree (mean) tie interaction.svg",
    ),
    caption: flex-caption(
        [Effect of the interaction between a cognizer's degree and the average degree of a pair on accuracy. Effects on *(a)* TPR, *(b)* FPR, and *(c, d)* $J$ represent marginal effects calculated from the mixed-effects logistic models of the TPR and FPR.],
        [Interaction between cognizer's degree and the average degree of a pair on accuracy.]
    ),
) <degree_mean_interaction>
