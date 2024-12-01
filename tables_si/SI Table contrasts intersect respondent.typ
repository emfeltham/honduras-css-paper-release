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
        cellx()[Age \ #text(fill: lbg)[95% CI] \ #text(fill: lbg)[_P_]],
        cellx()[96.0 > 14.0],
        cellx()[-0.14 \ (-0.218, -0.062) \ 0.0004],
        cellx()[ \  \ ],
        cellx()[ \  \ ],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[2],
        cellx()[Coffee cultivation],
        cellx()[Yes > No],
        cellx()[0.042 \ (0.015, 0.069) \ 0.0026],
        cellx()[ \  \ ],
        cellx()[ \  \ ],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[3],
        cellx()[Degree],
        cellx()[18.0 > 1.0],
        cellx()[0.063 \ (0.024, 0.103) \ 0.0016],
        cellx()[ \  \ ],
        cellx()[ \  \ ],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[4],
        cellx()[Education],
        cellx()[Some > No],
        cellx()[-0.02 \ (-0.043, 0.003) \ 0.0939],
        cellx()[ \  \ ],
        cellx()[ \  \ ],
        cellx()[5],
        cellx()[],
        cellx()[Yes > No],
        cellx()[-0.033 \ (-0.059, -0.007) \ 0.0122],
        cellx()[ \  \ ],
        cellx()[ \  \ ],
        cellx()[6],
        cellx()[],
        cellx()[Yes > Some],
        cellx()[-0.014 \ (-0.037, 0.01) \ 0.2528],
        cellx()[ \  \ ],
        cellx()[ \  \ ],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[7],
        cellx()[Gender],
        cellx()[Woman > Man],
        cellx()[0.007 \ (-0.014, 0.028) \ 0.4926],
        cellx()[ \  \ ],
        cellx()[ \  \ ],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[8],
        cellx()[Indigeneity],
        cellx()[Mestizo > Indigenous],
        cellx()[-0.017 \ (-0.044, 0.009) \ 0.1988],
        cellx()[ \  \ ],
        cellx()[ \  \ ],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[9],
        cellx()[Religion],
        cellx()[No Religion > Catholic],
        cellx()[-0.023 \ (-0.063, 0.017) \ 0.2565],
        cellx()[ \  \ ],
        cellx()[ \  \ ],
        cellx()[10],
        cellx()[],
        cellx()[Protestant > Catholic],
        cellx()[0.005 \ (-0.016, 0.026) \ 0.6547],
        cellx()[ \  \ ],
        cellx()[ \  \ ],
        cellx()[11],
        cellx()[],
        cellx()[Protestant > No Religion],
        cellx()[0.028 \ (-0.012, 0.068) \ 0.1708],
        cellx()[ \  \ ],
        cellx()[ \  \ ],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[12],
        cellx()[Wealth],
        cellx()[1.0 > 0.07],
        cellx()[-0.076 \ (-0.11, -0.041) \ 0.0],
        cellx()[ \  \ ],
        cellx()[ \  \ ],
        vlinex(start: 2, stroke: 0.05em),
        hlinex(start: 1, stroke: 0.05em),
    ),
    caption: flex-caption(
        [Contrasts for respondent and village characteristics. Each accuracy measure represents the difference between the predicted value for each level of the contrast. 95% confidence intervals are presented in parentheses below the mean estimates. The corresponding p-values are presented below the intervals, and are rounded to 5 digits. FPR and J are not estimated.],
        [Contrasts for respondent and village characteristics]
    ),
    kind: table,
) <contrast_tie_resp_intersection>