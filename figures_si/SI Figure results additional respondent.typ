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
        "SI Figure results additional respondent.svg",
    ),
    caption: flex-caption(
        [Additional individual determinants of respondent accuracy. In each panel, the LHS image shows the marginal effect on accuracy in ROC-space (grey shading represents the 95% bootstrapped confidence ellipse of the predictions from the two models), and the RHS image shows the marginal effect of each individual accuracy measure: the true positive rate, false positive rate, and the overall summary measure of accuracy (Youden's $J$). Intervals represent 95% confidence levels, calculated via normal approximation for the two rates, and bootstrapped for the $J$ statistic. Religion and indigenous status are shown.],
        [Additional individual determinants of respondent accuracy.]
    ),
    kind: image
) <figure3_si_s>