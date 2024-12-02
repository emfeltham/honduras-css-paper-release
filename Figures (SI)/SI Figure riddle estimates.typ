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
        "SI Figure riddle estimates.svg",
    ),
    caption: flex-caption(
        [Riddle estimates. In Fig. 6b, we estimate the relationship between knowledge of exogenously introduced health information and social network accuracy. We present the riddle knowledge effect estimates for each riddle, from the three separate models (for each accuracy metric), from the average accuracy value in the population of survey respondents. The estimates for each riddle are relatively similar. Bars represent 95% confidence intervals, bootstrapped to incorporate uncertainty at both stages of estimation.],
        [Riddle estimates]
    ),
    kind: image
) <riddles>
