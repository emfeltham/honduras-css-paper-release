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
        "SI Figure distances cdf.svg",
    ),
    caption: flex-caption(
	[Empirical CDFs of cognizer-tie distance for (a) _free time_ and (b) _personal private_ relationships. We observe that 12.3% of _free time_ and 8.0% of _personal private_ ties presented are 8 degrees or more (dotted line) away from the survey respondents.],
	[Empirical CDFs of cognizer-tie distance]
),
) <figure_network_distances_cdf>
