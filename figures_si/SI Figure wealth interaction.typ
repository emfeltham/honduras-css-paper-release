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
        "SI Figure wealth interaction.svg", width: 80%
    ),
    caption: flex-caption(
[Effect of the interaction between cognizer and pair wealth on accuracy. *(a)* Interaction for the TPR and FPR rates in three dimensions. *(b)* Interaction between cognizer and pair wealth on the J statistic. Effects represent marginal effects calculated from the mixed-effects logistic models of the TPR and FPR.],
[Interaction between cognizer and pair wealth on accuracy.]
),
) <wealth_ineraction>
