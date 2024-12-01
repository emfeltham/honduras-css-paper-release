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
        "Figure 5.svg",
    ),
    caption: flex-caption(
	[Village-level perspectives. *(a)* Village-level distributions of overall accuracy ($J$). We find that the village-average scores are narrowly distributed (in contradistinction to the much wider individual-level distributions in Supplementary Fig. 3), just above 1/3 of the way to perfect accuracy from chance performance for each network. Consistent with the individual-level analyses (Fig. 3), we see greater accuracy for the free-time network. *(b)* Effect of whether a village cultivates coffee on social network accuracy. Parameters are fit from separate models of each rate, conditional on tie verity in the reference network. Marginal effects on accuracy in ROC space are shown; grey shading represents the 95% bootstrapped confidence ellipse of the predictions from the two models. (c and d) We show the contrast between the underlying sociocentric network *(c)*, and the network as an average of the individual cognizer predictions across the whole free-time network *(d)* for a single village. Here, predicted ties are either true or false positives. We see that individuals predict a network that is much denser (by a factor of 8) adding a total of 748 ties to the 108 that exist in the sociocentric network. See Supplementary Information for further village-level analyses.],
	[Village-level perspectives]
),
) <Figure-5>
