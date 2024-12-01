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
        "Figure 1.svg",
    ),
    caption: flex-caption(
	[Outline of the sampling procedure. (a) Perceiver's perspective of the network for a specific relationship (e.g., _free time_), in a representative village. Rings represent geodesic distances 1 to 4. (b) Possibly perceived ties. Ties are restricted to within 4 geodesic steps from the perceiver. Solid lines represent ties that actually exist in the underlying sociocentric network, and dotted lines those that do not. The total number of possible relationships is so great that it would be infeasible to survey completely. (c) Survey responses. We present no more than 40 ties to the survey respondent, drawn from the set of possible ties in panel (b). Of the 40 ties, roughly 20 are among individuals within 2 degrees of the perceiver, 10 are 3 degrees away, and 10 are 4 degrees away, where each distance is measured in the network defined by the union of the _kin_, _personal private_, and _free time_ networks. In each case, half are ties that exist in the sociocentric network (_real_ ties), and half do not exist (_counterfactual_ ties, denoted by dashed lines). The circular rings denote the geodesic distance, $d$, in the underlying sociocentric network, from the perceiver, and correspond to the sampling bins. The _ground truth_ of whether $i$ is connected to $j$ is ascertained because of the near simultaneous full sociocentric mapping of the village. Individuals assess both real and fake ties, and may respond correctly or not. This process is repeated separately for each villager, and we elicit this basic data structure for each survey respondent. On average individuals were queried around 33.6 ties (median=37.0, mode=40.0) across _free time_ and _personal private_.],
	[Outline of the sampling procedure]
),
) <Figure-1>
