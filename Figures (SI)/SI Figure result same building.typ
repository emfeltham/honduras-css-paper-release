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
        "SI Figure result same building.svg",
    ),
    caption: flex-caption(
	[Effect of the pair living in the same building on accuracy with respect to accuracy in network cognition. LHS: Grey bands that surround the effect estimates represent bootstrapped 95% confidence ellipses. RHS: Bands represent 95% confidence intervals (see Methods for details).],
	[Effect of the pair living in the same building on accuracy]
),
) <figure_same_building_a>
