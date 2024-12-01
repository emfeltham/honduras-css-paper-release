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
        "SI Figure alter recognition.svg",
    ),
    caption: flex-caption(
	[Recognition by distance. Survey respondents recognize individuals in displayed candidate pairs above 90% across every distance to the respondent, including those far away in the network, at more than 10 degrees of separation. Error bars represent 95% confidence intervals.],
	[Recognition by distance]
),
) <figure_recognition_distance>
