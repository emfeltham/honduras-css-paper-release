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
    grid(
        columns: 3,
        gutter: 1mm,
        image("knows_source.jpg"),
        image("knows_target.jpg"),
        image("know_each_other.jpg"),
    ),
    caption: flex-caption(
        [Survey interface. Individuals are asked whether they know each individual in a pair; if they, in fact, know both individuals, they are then queried about the relationship status of the pair.],
        [Survey interface]
    ),
    kind: image,
) <interface>
