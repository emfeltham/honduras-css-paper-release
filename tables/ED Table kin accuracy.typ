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
        stroke: auto,
        columns: (auto, auto, auto, auto, auto,),
        cellx()[Response \\ Status],
        vlinex(start: 1),
        cellx()[None of the above],
        cellx()[Parent/child],
        cellx()[Partners],
        cellx()[Siblings],
        hlinex(start: 1),
        cellx()[None of the above],
        cellx()[96.74],
        cellx()[1.17],
        cellx()[0.33],
        cellx()[1.77],
        cellx()[Parent/child],
        cellx()[2.23],
        cellx()[96.99],
        cellx()[0.24],
        cellx()[0.55],
        cellx()[Partners],
        cellx()[2.11],
        cellx()[0.47],
        cellx()[96.95],
        cellx()[0.47],
        cellx()[Siblings],
        cellx()[3.15],
        cellx()[0.76],
        cellx()[0.13],
        cellx()[95.97],
        hlinex(start: 1),
        vlinex(start: 1),
    ),
    caption: flex-caption(
        [Kin accuracy. Survey respondents are remarkably accurate in their knowledge of the kinship relations in their networks. Rows indicate the response to survey question 6, where respondents indicate the type of kin relationship (if any) that holds between a presented pair. Columns indicate the status in the underlying sociocentric (reference) network. We see that correct identifications are made around 96.66% of the time, on average across the categories.],
        [Kin Accuracy]
    ),
    kind: table,
)
