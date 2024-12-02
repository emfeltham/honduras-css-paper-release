#import "@preview/tablex:0.0.8": cellx, gridx, hlinex, vlinex

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
    gridx(
        columns: (auto, auto, auto),
        rows: auto,
        fill: none,
        align: left + top,
        hlinex(y: 1, stroke: 0.1em),
        hlinex(y: 7, stroke: 0.1em),
        vlinex(x: 0, start: 1, end: 7, stroke: 0.1em),
        // vlinex(x: 1, start: 1, end: 7, stroke: 0.1em),
        // vlinex(x: 2, start: 1, end: 7, stroke: 0.1em),
        vlinex(x: 3, start: 1, end: 7, stroke: 0.1em),
        cellx(x: 0, y: 0)[Question],
        cellx(x: 1, y: 0)[Text],
        cellx(x: 2, y: 0)[Response],
        cellx(x: 0, y: 1)[1],
        cellx(x: 1, y: 1)[Do you know [person a]? \ [photo of a shown with question 1]],
        cellx(x: 2, y: 1)[Yes \ No \ I don't know / I refuse to answer#super[⋆]],
        cellx(x: 0, y: 2)[2],
        cellx(x: 1, y: 2)[Do you know [person b]?  \ [photo of b shown with question 2]],
        cellx(x: 2, y: 2)[Yes \ No \ I don't know / I refuse to answer#super[⋆]],
        cellx(x: 0, y: 3)[3],
        cellx(x: 1, y: 3)[Do [person a] and [person b] know each other? \ [photo of pair shown with question 3]],
        cellx(x: 2, y: 3)[Yes \ No \ I don't know / I refuse to answer#super[⋆]],
        cellx(x: 0, y: 4)[4],
        cellx(x: 1, y: 4)[Do [person a] and [person b] spend free time together?],
        cellx(x: 2, y: 4)[Yes \ No \ I don't know / I refuse to answer#super[⋆]],
        cellx(x: 0, y: 5)[5],
        cellx(x: 1, y: 5)[Do [person a] and [person b] trust each other to talk about something personal or private?],
        cellx(x: 2, y: 5)[Yes \ No \ I don't know / I refuse to answer#super[⋆]],
        cellx(x: 0, y: 6)[6],
        cellx(x: 1, y: 6)[Are [person a] and [person b] one of the following?],
        cellx(x: 2, y: 6)[Parent / child \ Sibling \ Partner \ I don't know / I refuse to answer#super[⋆]],
        cellx(x: 0, y: 7, colspan: 3, align: left + horizon)[#super[⋆] Response option not read by surveyor.]
    ),
    caption: flex-caption(
        [Survey questions regarding conception of others' ties.],
        [Survey questions regarding conception of others' ties.],
    ),
    kind: table,
) <survey>
