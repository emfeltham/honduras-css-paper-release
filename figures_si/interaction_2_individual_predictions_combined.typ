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
        "interaction_2_individual_predictions_combined.svg",
    ),
    caption: [Individual accuracy predictions (full interaction set). (A) univariate distributions of individual accuracy scores for the true positive, false positive, and Youden's J. (B) Bivariate accuracy distributions, stratified by judgements of ties between kin and non-kin. We observe that predictions for kin ties are highly concentrated in the top left panel, at a level close to chance performance.],
    kind: "image-si",
    supplement: [*Supplementary Figure*],
) <interaction_2_individual_predictions_combined>
