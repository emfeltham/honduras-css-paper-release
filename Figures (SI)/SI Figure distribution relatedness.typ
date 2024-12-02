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
        "SI Figure distribution relatedness.svg",
    ),
    caption: flex-caption(
        [Distribution of genetic relatedness scores for the unique pairs of individuals presented in the survey. Scores range from -0.93 to 0.45 where a value of 0.5 would represent relatedness at the level of monozygotic twins. Scores below 0 (red dotted line) indicate individuals who are unrelated. We find that the average level of relatedness is 0.1, a level between 2nd and 3rd cousins (black dotted line). Moreover, we find that 13.03% of the population of pairs would be considered completely unrelated.],
        [Distribution of genetic relatedness scores]
    ),
    kind: image,
) <relatedness_dist>
