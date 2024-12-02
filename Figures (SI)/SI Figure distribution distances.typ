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
        "SI Figure distribution distances.svg",
    ),
    caption: flex-caption(
	[Distribution of geodesic distances. The yellow regions represent the 20th and 80th percentiles of the distribution around the mean geodesic distance (black line). Distances in the the underlying (a) _free time_ (green) and (b) _personal private_ (fuchsia) networks. (c) Distances from the cognizer to the alter in the pairs presented to respondents. (d) Distances between the individuals in the pairs presented to the respondents, when the ground truth tie does not exist.],
	[Distribution of geodesic distances.]
),
) <figure_network_distances>
