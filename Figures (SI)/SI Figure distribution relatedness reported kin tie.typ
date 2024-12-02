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
        "SI Figure distribution relatedness reported kin tie.svg",
    ),
    caption: flex-caption(
	[Reported kinship and genetic kinship. Distribution of the kinship coefficient (see Methods for description) for the self-reported Parent/child relationships and the sibling relationships. Distribution means (blue lines) indicate that the levels of relatedness are close to their expected values ($1/4$ for each) for both categories.],
	[Reported kinship and genetic kinship]
),
) <report_genetics>
