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
        "ed_figure_2.svg",
    ),
    caption: flex-caption(
        [Effect of the interaction between cognizer and pair wealth on accuracy. (a) Interaction for the TPR and FPR rates in three dimensions, presented in *Figure 5e*. (b) Interaction between cognizer and pair wealth on the J statistic, presented in *Figure 5(f)*, in two dimensions. Effects represent marginal effects calculated from the mixed-effects logistic models of the TPR and FPR.],
        [Effect of the interaction between cognizer and pair wealth on accuracy.]
    ),
    kind: image,
) <ed_figure_2>
