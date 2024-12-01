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
        columns: (auto, auto, auto, auto, auto, auto, ),
        stroke: auto,
        cellx()[],
        vlinex(start: 1, stroke: 0.05em),
        cellx()[Contrast],
        cellx()[Estimate],
        cellx()[Error],
        cellx()[95% Conf. Int.],
        cellx()[Measure],
        hlinex(start: 1, stroke: 0.05em),
        cellx()[1],
        cellx()[N > 150 vs. N <= 150],
        cellx()[-0.038],
        cellx()[0.014],
        cellx()[(-0.066, -0.01)],
        cellx()[TPR],
        cellx()[2],
        cellx()[N > 150 vs. N <= 150],
        cellx()[0.047],
        cellx()[0.018],
        cellx()[(0.012, 0.082)],
        cellx()[TNR],
        cellx()[3],
        cellx()[N > 150 vs. N <= 150],
        cellx()[0.009],
        cellx()[0.022],
        cellx()[(-0.034, 0.053)],
        cellx()[J],
        vlinex(start: 1, stroke: 0.05em),
        hlinex(start: 1, stroke: 0.05em),
    ),
    caption: flex-caption(
	[Contrasts for village size above 150],
	[Contrasts for village size above 150]
),
    kind: table,
    supplement: [Table],
) <table_dunbar>