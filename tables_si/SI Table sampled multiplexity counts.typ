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

#import"@preview/tablex:0.0.8": tablex, gridx, hlinex, vlinex, colspanx, rowspanx, cellx
 
#figure(
    gridx(
        columns: (auto, auto, auto, auto, auto, ),
        stroke: auto,
        cellx()[],
        vlinex(start: 1, stroke: 0.05em),
        cellx()[Free time],
        cellx()[Personal private],
        cellx()[N],
        cellx()[Condition],
        hlinex(start: 1, stroke: 0.05em),
        cellx()[1],
        cellx()[No],
        cellx()[No],
        cellx()[23320],
        cellx()[Any wave],
        cellx()[2],
        cellx()[No],
        cellx()[Yes],
        cellx()[6070],
        cellx()[Any wave],
        cellx()[3],
        cellx()[Yes],
        cellx()[No],
        cellx()[6666],
        cellx()[Any wave],
        cellx()[4],
        cellx()[Yes],
        cellx()[Yes],
        cellx()[16358],
        cellx()[Any wave],
        cellx()[5],
        cellx()[No],
        cellx()[No],
        cellx()[13824],
        cellx()[Wave 4 only],
        cellx()[6],
        cellx()[No],
        cellx()[Yes],
        cellx()[3845],
        cellx()[Wave 4 only],
        cellx()[7],
        cellx()[Yes],
        cellx()[No],
        cellx()[3939],
        cellx()[Wave 4 only],
        cellx()[8],
        cellx()[Yes],
        cellx()[Yes],
        cellx()[6390],
        cellx()[Wave 4 only],
        vlinex(start: 1, stroke: 0.05em),
        hlinex(start: 1, stroke: 0.05em),
    ),
    caption: flex-caption(
	[Multiplexity of sampled ties. Counts of unique, symmetric ties shown to cognizers (survey respondents), stratified by their status in the reference network and kinship status.],
	[Multiplexity of sampled ties]
),
    kind: table,
    supplement: [Table],
) <css_tie_counts>
