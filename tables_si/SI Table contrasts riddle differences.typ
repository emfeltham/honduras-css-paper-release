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
        cellx()[Zinc usage > Umbilical cord care],
        cellx()[TPR],
        cellx()[-0.049],
        cellx()[2],
        cellx()[],
        cellx()[#text(fill: lbg)[95% CI]],
        cellx()[(-0.071, -0.027)],
        cellx()[3],
        cellx()[],
        cellx()[#text(fill: lbg)[_P_]],
        cellx()[1.0e-5],
        cellx()[4],
        cellx()[Zinc usage > Prenatal care],
        cellx()[],
        cellx()[0.077],
        cellx()[5],
        cellx()[],
        cellx()[],
        cellx()[(0.058, 0.095)],
        cellx()[6],
        cellx()[],
        cellx()[],
        cellx()[0.0],
        cellx()[7],
        cellx()[Prenatal care > Umbilical cord care],
        cellx()[],
        cellx()[-0.125],
        cellx()[8],
        cellx()[],
        cellx()[],
        cellx()[(-0.145, -0.105)],
        cellx()[9],
        cellx()[],
        cellx()[],
        cellx()[0.0],
        cellx()[10],
        cellx()[Zinc usage > Umbilical cord care],
        cellx()[TNR],
        cellx()[-0.043],
        cellx()[11],
        cellx()[],
        cellx()[],
        cellx()[(-0.181, 0.094)],
        cellx()[12],
        cellx()[],
        cellx()[],
        cellx()[0.53465],
        cellx()[13],
        cellx()[Zinc usage > Prenatal care],
        cellx()[],
        cellx()[0.067],
        cellx()[14],
        cellx()[],
        cellx()[],
        cellx()[(-0.04, 0.174)],
        cellx()[15],
        cellx()[],
        cellx()[],
        cellx()[0.22213],
        cellx()[16],
        cellx()[Prenatal care > Umbilical cord care],
        cellx()[],
        cellx()[-0.11],
        cellx()[17],
        cellx()[],
        cellx()[],
        cellx()[(-0.231, 0.01)],
        cellx()[18],
        cellx()[],
        cellx()[],
        cellx()[0.07326],
        cellx()[19],
        cellx()[Zinc usage > Umbilical cord care],
        cellx()[J],
        cellx()[-0.043],
        cellx()[20],
        cellx()[],
        cellx()[],
        cellx()[(-0.166, 0.079)],
        cellx()[21],
        cellx()[],
        cellx()[],
        cellx()[0.48978],
        cellx()[22],
        cellx()[Zinc usage > Prenatal care],
        cellx()[],
        cellx()[0.066],
        cellx()[23],
        cellx()[],
        cellx()[],
        cellx()[(-0.029, 0.162)],
        cellx()[24],
        cellx()[],
        cellx()[],
        cellx()[0.17405],
        cellx()[25],
        cellx()[Prenatal care > Umbilical cord care],
        cellx()[],
        cellx()[-0.11],
        cellx()[26],
        cellx()[],
        cellx()[],
        cellx()[(-0.217, -0.002)],
        cellx()[27],
        cellx()[],
        cellx()[],
        cellx()[0.04611],
        vlinex(start: 1, stroke: 0.05em),
        hlinex(start: 1, stroke: 0.05em),
    ),
    caption: flex-caption(
[Contrasts for riddle knowledge on social network accuracy, for each riddle, with the population average accuracy measure. Each accuracy measure represents the difference between the predicted value for each level of the contrast. 95% confidence intervals are presented in parentheses below the mean estimates. The corresponding p-values are presented below the intervals, and are rounded to 5 digits.],
[Contrasts riddle knowledge on social network accuracy]
),
    kind: table,
) <contrast_riddle_riddle>