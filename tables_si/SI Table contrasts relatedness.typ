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
 
#let lbg = rgb("#63aaff")
#let org = rgb("#6d5319")
 
#figure(
    gridx(
        columns: (auto, auto, auto, auto, auto, auto, ),
        stroke: auto,
        cellx(colspan: 3)[],
        cellx(colspan: 3, align: center)[Difference],
        hlinex(start: 3, stroke: gray + 0.01em),
        cellx()[],
        vlinex(start: 2, stroke: 0.05em),
        cellx()[Variable],
        cellx()[Contrast],
        cellx()[TPR],
        cellx()[FPR],
        cellx()[J],
        hlinex(start: 1, stroke: 0.05em),
        cellx()[1],
        cellx()[Kinship \ #text(fill: lbg)[95% CI] \ #text(fill: lbg)[_P_]],
        cellx()[-0.06 > -0.93],
        cellx()[0.63 \ (0.585, 0.675) \ 0.0],
        cellx()[0.188 \ (0.159, 0.217) \ 0.0],
        cellx()[0.442 \ (0.39, 0.494) \ 0.0],
        cellx()[2],
        cellx()[],
        cellx()[0.45 > -0.06],
        cellx()[0.287 \ (0.244, 0.329) \ 0.0],
        cellx()[0.686 \ (0.649, 0.723) \ 0.0],
        cellx()[-0.399 \ (-0.453, -0.345) \ 0.0],
        cellx()[3],
        cellx()[],
        cellx()[0.45 > -0.93],
        cellx()[0.917 \ (0.897, 0.937) \ 0.0],
        cellx()[0.874 \ (0.851, 0.896) \ 0.0],
        cellx()[0.043 \ (0.01, 0.076) \ 0.0099],
        vlinex(start: 2, stroke: 0.05em),
        hlinex(start: 1, stroke: 0.05em),
    ),
    caption: flex-caption(
[Contrasts for genetic relatedness. Each accuracy measure represents the difference between the predicted value for each level of the contrast. 95% confidence intervals are presented in parentheses below the mean estimates. The corresponding p-values are presented below the intervals, and are rounded to 5 digits.],
[Contrasts for genetic relatedness.]
),
    kind: table,
) <contrast_tie_relatedness_bs>
