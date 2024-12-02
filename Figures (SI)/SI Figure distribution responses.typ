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
        "SI Figure distribution responses.svg",
    ),
    caption: flex-caption(
        [Univariate distributions of respondent-level accuracy, for judgements of ties between non-kin. *(a)* TPR, *(b)* FPR, and *(c)* $J$. Dotted lines represent the distribution means, and the gray vertical spans represent the 20th and 80th percentiles of the distributions. We see the narrowest range of variation in the TPR, where subjects are effective in identifying relationships that do exist. However, we see both greater variation, with a similar average ability to correctly identify ties that do not exist (The average TPR stands at around 0.65, and the TNR at under 0.7). Ultimately, we see that the combined accuracy measure ($J$) has a mean value closer to chance performance ($J=0$) than to perfect accuracy ($J=1$), at less than 0.4. The cognizer-level predictions represent model-adjusted averages at the respondent-level and averaged across _free time_ and _personal private_.],
        [Univariate distributions of respondent-level accuracy.]
    ),
) <resp_dist>
