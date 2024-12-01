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
        "acc_comp.svg",
    ),
    caption: flex-caption(
        [Accuracy estimates for a typical individual. The estimates are stratified by relationship, and whether judgements are of kin or non-kin ties. Separate models estimate for true and false ties. Error bars represent 95% confidence intervals. Estimates are presented from a minimal model that only adjusts for the stratified categories along with distance, a model with demographic controls (but no interactions), a model that interacts each control with kin status and relationship, and a model with all pairwise interactions. Generally, we observe that the estimates change only very little across each specification.],
        [Accuracy estimates for a typical individual]
    ),
    kind: image,
    supplement: [Supplementary Figure],
) <acc_comp>
