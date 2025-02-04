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
        cellx()[30.65 > 14.0],
        cellx()[0.029 \ (-0.002, 0.06) \ 0.0666],
        cellx()[0.007 \ (-0.025, 0.04) \ 0.6668],
        cellx()[0.022 \ (-0.02, 0.064) \ 0.3047],
        cellx()[2],
        cellx()[],
        cellx()[96.0 > 14.0],
        cellx()[0.03 \ (-0.044, 0.104) \ 0.4289],
        cellx()[0.358 \ (0.289, 0.428) \ 0.0],
        cellx()[-0.329 \ (-0.424, -0.233) \ 0.0],
        cellx()[3],
        cellx()[],
        cellx()[96.0 > 30.65],
        cellx()[0.001 \ (-0.069, 0.071) \ 0.9848],
        cellx()[0.351 \ (0.285, 0.417) \ 0.0],
        cellx()[-0.351 \ (-0.441, -0.26) \ 0.0],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[4],
        cellx()[Coffee cultivation],
        cellx()[Yes > No],
        cellx()[0.046 \ (0.014, 0.077) \ 0.0045],
        cellx()[0.027 \ (-0.012, 0.067) \ 0.1748],
        cellx()[0.018 \ (-0.028, 0.065) \ 0.4407],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[5],
        cellx()[Degree],
        cellx()[18.0 > 1.0],
        cellx()[0.08 \ (0.032, 0.128) \ 0.001],
        cellx()[-0.151 \ (-0.191, -0.11) \ 0.0],
        cellx()[0.231 \ (0.171, 0.291) \ 0.0],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[6],
        cellx()[Education],
        cellx()[Some > No],
        cellx()[-0.019 \ (-0.046, 0.008) \ 0.1732],
        cellx()[-0.044 \ (-0.077, -0.011) \ 0.0095],
        cellx()[0.025 \ (-0.015, 0.065) \ 0.2133],
        cellx()[7],
        cellx()[],
        cellx()[Yes > No],
        cellx()[-0.051 \ (-0.082, -0.02) \ 0.0014],
        cellx()[-0.102 \ (-0.137, -0.067) \ 0.0],
        cellx()[0.051 \ (0.007, 0.095) \ 0.0222],
        cellx()[8],
        cellx()[],
        cellx()[Yes > Some],
        cellx()[-0.032 \ (-0.06, -0.004) \ 0.0248],
        cellx()[-0.058 \ (-0.088, -0.028) \ 0.0002],
        cellx()[0.026 \ (-0.013, 0.065) \ 0.1876],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[9],
        cellx()[Gender],
        cellx()[Woman > Man],
        cellx()[-0.011 \ (-0.036, 0.013) \ 0.3721],
        cellx()[-0.03 \ (-0.059, -0.0) \ 0.0492],
        cellx()[0.018 \ (-0.018, 0.055) \ 0.3222],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[10],
        cellx()[Indigeneity],
        cellx()[Mestizo > Indigenous],
        cellx()[0.003 \ (-0.03, 0.037) \ 0.8474],
        cellx()[-0.005 \ (-0.041, 0.03) \ 0.7716],
        cellx()[0.009 \ (-0.038, 0.055) \ 0.7165],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[11],
        cellx()[Kin],
        cellx()[Yes > No],
        cellx()[0.262 \ (0.246, 0.277) \ 0.0],
        cellx()[0.586 \ (0.566, 0.606) \ 0.0],
        cellx()[-0.324 \ (-0.348, -0.301) \ 0.0],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[12],
        cellx()[Religion],
        cellx()[No Religion > Catholic],
        cellx()[-0.015 \ (-0.063, 0.034) \ 0.5522],
        cellx()[-0.01 \ (-0.059, 0.038) \ 0.6841],
        cellx()[-0.005 \ (-0.068, 0.059) \ 0.8892],
        cellx()[13],
        cellx()[],
        cellx()[Protestant > Catholic],
        cellx()[0.007 \ (-0.018, 0.032) \ 0.5867],
        cellx()[-0.01 \ (-0.04, 0.019) \ 0.4889],
        cellx()[0.017 \ (-0.019, 0.053) \ 0.3454],
        cellx()[14],
        cellx()[],
        cellx()[Protestant > No Religion],
        cellx()[0.021 \ (-0.027, 0.07) \ 0.382],
        cellx()[-0.0 \ (-0.049, 0.048) \ 0.9882],
        cellx()[0.022 \ (-0.042, 0.086) \ 0.5011],
        hlinex(start: 1, stroke: 0.01em),
        cellx()[15],
        cellx()[Wealth],
        cellx()[1.0 > 0.07],
        cellx()[-0.121 \ (-0.162, -0.079) \ 0.0],
        cellx()[-0.199 \ (-0.243, -0.155) \ 0.0],
        cellx()[0.078 \ (0.023, 0.133) \ 0.0057],
        vlinex(start: 2, stroke: 0.05em),
        hlinex(start: 1, stroke: 0.05em),
    ),
    caption: flex-caption(
	[Contrasts for respondent and village characteristics, limited distance. Each accuracy measure represents the difference between the predicted value for each level of the contrast. 95% confidence intervals are presented in parentheses below the mean estimates. The corresponding p-values are presented below the intervals, and are rounded to 5 digits.],
	[Contrasts for respondent and village characteristics, limited distance.]
),
    kind: "table-si",
    supplement: [Supplementary Table],
) <contrast_tie_resp_bs_lt_2>
