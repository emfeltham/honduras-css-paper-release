#import"@preview/tablex:0.0.8": tablex, gridx, hlinex, vlinex, colspanx, rowspanx, cellx
#show figure: set block(breakable: true)

#let lbg = rgb("#63aaff")
#let org = rgb("#6d5319")

#text(size: 10pt)[ 
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
        cellx()[30.97 > 14.0],
        cellx()[0.053 \ (0.026, 0.081) \ 0.0002],
        cellx()[0.027 \ (0.004, 0.051) \ 0.0246],
        cellx()[0.026 \ (-0.013, 0.066) \ 0.1939],
        cellx()[2],
        cellx()[],
        cellx()[96.0 > 14.0],
        cellx()[-0.006 \ (-0.072, 0.061) \ 0.8657],
        cellx()[0.368 \ (0.304, 0.431) \ 0.0],
        cellx()[-0.373 \ (-0.468, -0.279) \ 0.0],
        cellx()[3],
        cellx()[],
        cellx()[96.0 > 30.97],
        cellx()[-0.059 \ (-0.123, 0.004) \ 0.0684],
        cellx()[0.34 \ (0.278, 0.403) \ 0.0],
        cellx()[-0.399 \ (-0.489, -0.309) \ 0.0],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[4],
        cellx()[Coffee cultivation],
        cellx()[Yes > No],
        cellx()[0.051 \ (0.02, 0.081) \ 0.001],
        cellx()[0.029 \ (-0.003, 0.06) \ 0.0735],
        cellx()[0.022 \ (-0.021, 0.065) \ 0.3153],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[5],
        cellx()[Degree],
        cellx()[18.0 > 1.0],
        cellx()[0.076 \ (0.035, 0.116) \ 0.0002],
        cellx()[-0.03 \ (-0.06, 0.001) \ 0.0574],
        cellx()[0.105 \ (0.048, 0.163) \ 0.0003],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[6],
        cellx()[Education],
        cellx()[Some > No],
        cellx()[-0.024 \ (-0.048, 0.0) \ 0.0525],
        cellx()[-0.065 \ (-0.093, -0.038) \ 0.0],
        cellx()[0.041 \ (0.007, 0.075) \ 0.0198],
        cellx()[7],
        cellx()[],
        cellx()[Yes > No],
        cellx()[-0.057 \ (-0.085, -0.03) \ 0.0],
        cellx()[-0.116 \ (-0.145, -0.088) \ 0.0],
        cellx()[0.059 \ (0.02, 0.098) \ 0.003],
        cellx()[8],
        cellx()[],
        cellx()[Yes > Some],
        cellx()[-0.033 \ (-0.058, -0.008) \ 0.009],
        cellx()[-0.051 \ (-0.075, -0.028) \ 0.0],
        cellx()[0.018 \ (-0.017, 0.053) \ 0.3131],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[9],
        cellx()[Gender],
        cellx()[Woman > Man],
        cellx()[-0.008 \ (-0.03, 0.015) \ 0.5035],
        cellx()[-0.031 \ (-0.054, -0.007) \ 0.0104],
        cellx()[0.023 \ (-0.009, 0.055) \ 0.1531],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[10],
        cellx()[Indigeneity],
        cellx()[Mestizo > Indigenous],
        cellx()[-0.018 \ (-0.046, 0.01) \ 0.2046],
        cellx()[0.006 \ (-0.021, 0.033) \ 0.67],
        cellx()[-0.024 \ (-0.063, 0.015) \ 0.2322],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[11],
        cellx()[Religion],
        cellx()[No Religion > Catholic],
        cellx()[-0.012 \ (-0.052, 0.028) \ 0.5588],
        cellx()[0.017 \ (-0.022, 0.056) \ 0.3947],
        cellx()[-0.029 \ (-0.085, 0.028) \ 0.3185],
        cellx()[12],
        cellx()[],
        cellx()[Protestant > Catholic],
        cellx()[0.004 \ (-0.019, 0.026) \ 0.7595],
        cellx()[-0.001 \ (-0.024, 0.023) \ 0.9493],
        cellx()[0.004 \ (-0.028, 0.036) \ 0.7922],
        cellx()[13],
        cellx()[],
        cellx()[Protestant > No Religion],
        cellx()[0.015 \ (-0.025, 0.056) \ 0.4496],
        cellx()[-0.018 \ (-0.056, 0.021) \ 0.3753],
        cellx()[0.033 \ (-0.024, 0.09) \ 0.2524],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[14],
        cellx()[Wealth],
        cellx()[1.0 > 0.07],
        cellx()[-0.138 \ (-0.173, -0.103) \ 0.0],
        cellx()[-0.198 \ (-0.232, -0.163) \ 0.0],
        cellx()[0.059 \ (0.01, 0.109) \ 0.0183],
        vlinex(start: 2, stroke: 0.05em),
        hlinex(start: 1, stroke: 0.05em),
    ),
    caption: [Contrasts for respondent and village characteristics. Each accuracy measure represents the difference between the predicted value for each level of the contrast. 95% confidence intervals are presented in parentheses below the mean estimates. The corresponding p-values are presented below the intervals, and are rounded to 3 digits.],
    kind: table
)
]