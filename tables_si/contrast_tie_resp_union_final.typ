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
        cellx()[-0.004 \ (-0.069, 0.06) \ 0.8931],
        cellx()[0.383 \ (0.319, 0.446) \ 0.0],
        cellx()[-0.387 \ (-0.478, -0.296) \ 0.0],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[2],
        cellx()[Coffee cultivation],
        cellx()[Yes > No],
        cellx()[0.047 \ (0.017, 0.076) \ 0.0024],
        cellx()[0.029 \ (-0.002, 0.061) \ 0.0659],
        cellx()[0.017 \ (-0.025, 0.059) \ 0.4284],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[3],
        cellx()[Degree],
        cellx()[18.0 > 1.0],
        cellx()[0.057 \ (0.02, 0.094) \ 0.0024],
        cellx()[-0.069 \ (-0.097, -0.042) \ 0.0],
        cellx()[0.126 \ (0.074, 0.179) \ 0.0],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[4],
        cellx()[Education],
        cellx()[Some > No],
        cellx()[-0.021 \ (-0.045, 0.003) \ 0.0808],
        cellx()[-0.069 \ (-0.096, -0.041) \ 0.0],
        cellx()[0.048 \ (0.014, 0.081) \ 0.0054],
        cellx()[5],
        cellx()[],
        cellx()[Yes > No],
        cellx()[-0.052 \ (-0.079, -0.025) \ 0.0001],
        cellx()[-0.124 \ (-0.152, -0.096) \ 0.0],
        cellx()[0.072 \ (0.034, 0.11) \ 0.0002],
        cellx()[6],
        cellx()[],
        cellx()[Yes > Some],
        cellx()[-0.031 \ (-0.055, -0.006) \ 0.0133],
        cellx()[-0.055 \ (-0.078, -0.032) \ 0.0],
        cellx()[0.024 \ (-0.01, 0.059) \ 0.1635],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[7],
        cellx()[Gender],
        cellx()[Woman > Man],
        cellx()[-0.009 \ (-0.031, 0.013) \ 0.4334],
        cellx()[-0.031 \ (-0.055, -0.008) \ 0.0086],
        cellx()[0.023 \ (-0.008, 0.054) \ 0.1525],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[8],
        cellx()[Indigeneity],
        cellx()[Mestizo > Indigenous],
        cellx()[-0.021 \ (-0.048, 0.005) \ 0.1193],
        cellx()[-0.003 \ (-0.03, 0.024) \ 0.8296],
        cellx()[-0.018 \ (-0.056, 0.019) \ 0.343],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[9],
        cellx()[Religion],
        cellx()[No Religion > Catholic],
        cellx()[-0.019 \ (-0.058, 0.019) \ 0.325],
        cellx()[-0.007 \ (-0.044, 0.03) \ 0.7229],
        cellx()[-0.013 \ (-0.067, 0.042) \ 0.6484],
        cellx()[10],
        cellx()[],
        cellx()[Protestant > Catholic],
        cellx()[-0.002 \ (-0.024, 0.02) \ 0.8734],
        cellx()[-0.006 \ (-0.03, 0.017) \ 0.597],
        cellx()[0.004 \ (-0.027, 0.036) \ 0.7781],
        cellx()[11],
        cellx()[],
        cellx()[Protestant > No Religion],
        cellx()[0.018 \ (-0.021, 0.056) \ 0.3737],
        cellx()[0.0 \ (-0.037, 0.037) \ 0.983],
        cellx()[0.017 \ (-0.038, 0.072) \ 0.5382],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[12],
        cellx()[Wealth],
        cellx()[1.0 > 0.07],
        cellx()[-0.125 \ (-0.159, -0.091) \ 0.0],
        cellx()[-0.198 \ (-0.233, -0.164) \ 0.0],
        cellx()[0.073 \ (0.025, 0.121) \ 0.0028],
        vlinex(start: 2, stroke: 0.05em),
        hlinex(start: 1, stroke: 0.05em),
    ),
    caption: flex-caption(
[Contrasts for respondent and village characteristics, union. Each accuracy measure represents the difference between the predicted value for each level of the contrast. 95% confidence intervals are presented in parentheses below the mean estimates. The corresponding p-values are presented below the intervals, and are rounded to 5 digits.],
[Contrasts for respondent and village characteristics, union]
),
    kind: "table-si",
    supplement: [Supplementary Table],
) <contrast_tie_resp_union_final>