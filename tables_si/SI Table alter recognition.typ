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
        columns: (auto, auto, auto, auto, ),
        stroke: auto,
        cellx()[],
        vlinex(start: 1, stroke: 0.05em),
        cellx()[Recognized],
        cellx()[N],
        cellx()[Pct. recognized],
        hlinex(start: 1, stroke: 0.05em),
        cellx()[1],
        cellx()[Yes],
        cellx()[393515],
        cellx()[93.5],
        cellx()[2],
        cellx()[No],
        cellx()[27345],
        cellx()[6.5],
        cellx()[3],
        cellx()[Don't know],
        cellx()[23],
        cellx()[0.01],
        vlinex(start: 1, stroke: 0.05em),
        hlinex(start: 1, stroke: 0.05em),
    ),
    caption: flex-caption(
	[Recognition of alters by survey respondents. As described in Methods, we check whether each survey respondent (cognizer) recognizes the individuals in the candidate pairs to be judged. When an individual does not recognize another, the corresponding pair is not shown. We observe that 93.5% of all individuals presented are recognized.],
	[Recognition of alters by survey respondents]
),
    kind: table,
    supplement: [Table],
) <recognition_table>
