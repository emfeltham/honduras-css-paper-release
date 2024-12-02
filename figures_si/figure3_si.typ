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
        "figure3_si.svg",
    ),
    caption: flex-caption(
        [Additional individual determinants of respondent accuracy. In each panel, the left-hand image shows the marginal effect on accuracy in ROC-space (grey shading represents the 95% bootstrapped confidence ellipse of the predictions from the two models), and the right-hand image shows the marginal effect of each individual accuracy measure: the true positive rate, false positive rate, and the overall summary measure of accuracy (Youden's $J$). Intervals represent 95% confidence levels, calculated via normal approximation for the two rates, and bootstrapped for the $J$ statistic. *(a)* Religion and *(b)* indigenous status are shown.],
        [Additional individual determinants of respondent accuracy]
    ),
    kind: image,
) <figure3_si>
