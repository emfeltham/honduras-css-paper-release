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
        "ED Figure results tie.svg",
    ),
    caption: flex-caption(
	[Tie determinants of respondent accuracy. *(a)* We find that a range of properties of ties have statistically significant associations with their tendency to be accurately conceived. In each panel, the marginal effect on accuracy in ROC-space is shown. Grey shading represents the 95% bootstrapped confidence ellipse of the predictions from the two models. Estimates are stratified by whether they are of a tie among kin or not. *(b)* Network distances. Cognizer-to-tie geodesic distance. Individuals may or may not have a defined path between them in the reference network; when there is a path, individuals exist at a geodesic distance defined as the minimum number of steps between them; note that individuals who do not have a path between them necessarily have a path in at least one of other networks considered in this study, by design. Within-tie distance. When a direct tie does not exist between two individuals, a specific geodesic distance may separate them (or they may have no path between them in the network). The TPR is set to the population average; but it does not have a meaningful interpretation in assessments of ties that do not exist. Parameters are fit from separate models of each rate, conditional on tie verity in the reference network (see Methods for details). *(c)* Interaction between the average wealth of a pair and the cognizer's wealth on the summary measure, $J$ (see Methods for details).],
	[Tie determinants of respondent accuracy]
),
) <ED-Figure-results-tie>
