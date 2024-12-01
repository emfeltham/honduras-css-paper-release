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
        "SI Figure results coffee.svg",
    ),
    caption: flex-caption(
[Effect of whether a village cultivates coffee on social network accuracy. Parameters are fit from separate models of each rate, conditional on tie verity in the reference network. Grey shading represents the 95% bootstrapped confidence ellipse of the predictions from the two models. Right, marginal effect of each individual accuracy measure: the true positive and false positive rates and the summary measure Youden's $J$ statistic. Intervals represent 95% confidence levels, calculated via normal approximation for the two rates, and bootstrapped for the $J$ statistic.],
[Effect of whether a village cultivates coffee on social network accuracy]
),
) <figure_coffee>
