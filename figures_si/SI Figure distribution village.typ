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
        "SI Figure distribution village.svg",
    ),
    caption: flex-caption(
        [Village level accuracy, _free time_. *(a)* Bivariate distribution of social network accuracy at the village level. We see that the villages-level averages exhibit a positive correlation between type 1 and type 2 error rates. *(b)* univariate distribution of the $J$ statistic. In general, villages fall into a relatively narrow range, implying that most of the variation stems from individuals rather than whole village populations. Village-level predictions represent model-adjusted averages at the respondent-level, for judgements of non-kin ties.],
        [Village level accuracy, _free time_]
    ),
) <village_dist>
