#import"@preview/tablex:0.0.8": tablex, gridx, hlinex, vlinex, colspanx, rowspanx, cellx
 
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

#let lbg = rgb("#63aaff")
#let org = rgb("#6d5319")
#figure(
    gridx(
        columns: (auto, auto, auto, auto, ),
        stroke: auto,
        cellx()[],
        vlinex(start: 1, stroke: 0.05em),
        cellx()[Contrast],
        cellx()[Rate],
        cellx()[Riddle knowledge],
        hlinex(start: 1, stroke: 0.05em),
        cellx()[1],
        cellx()[0.82 > 0.47],
        cellx()[TPR],
        cellx()[-0.463],
        cellx()[2],
        cellx()[#text(fill: lbg)[95% CI]],
        cellx()[],
        cellx()[(-0.552, -0.375)],
        cellx()[3],
        cellx()[#text(fill: lbg)[_P_]],
        cellx()[],
        cellx()[0.0],
        cellx()[4],
        cellx()[0.88 > 0.28],
        cellx()[TNR],
        cellx()[0.401],
        cellx()[5],
        cellx()[],
        cellx()[],
        cellx()[(0.177, 0.626)],
        cellx()[6],
        cellx()[],
        cellx()[],
        cellx()[0.00046],
        cellx()[7],
        cellx()[0.49 > -0.07],
        cellx()[J],
        cellx()[0.234],
        cellx()[8],
        cellx()[],
        cellx()[],
        cellx()[(0.162, 0.305)],
        cellx()[9],
        cellx()[],
        cellx()[],
        cellx()[0.0],
        vlinex(start: 1, stroke: 0.05em),
        hlinex(start: 1, stroke: 0.05em),
    ),
    caption: flex-caption(
        [Contrasts for riddle knowledge on social network accuracy. Each accuracy measure represents the difference between the predicted value for each level of the contrast. 95% confidence intervals are presented in parentheses below the mean estimates. The corresponding p-values are presented below the intervals, and are rounded to 5 digits.],
        [Contrasts for riddle knowledge on social network accuracy.]
),
    kind: table,
) <contrast_riddle>
