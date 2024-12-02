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
        "ED Figure kinship alternative.svg",
    ),
    caption: flex-caption(
        [The effect of alternative definitions of kinship. In addition to the binary definition of kinship (used in the primary analyses) and genetic relatedness (Figure 2B), we consider the specific type of kinship tie as a categorical variable (A) and distance in the kinship network (B). We find that the categorical results are consistent with the binary definition, and distance in the kinship network broadly corresponds to that of genetic relationship.],
        [The effect of alternative definitions of kinship]
    ),
) <kinship>
