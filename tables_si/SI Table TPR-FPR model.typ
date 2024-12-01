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

// table params
#let col1width = 10em
#let coliwidth = auto
#let name_align = left + horizon
// pkey 
#let ps = (super[$+$], super[$star.op$], super[$star.op star.op$], super[$star.op star.op star.op$], )
 
#figure(
    gridx(
        columns: (col1width, coliwidth, ),
        rows: (0.2em, 1.5em),
        align: center + horizon,
        stroke: auto,
        hlinex(y: 0, stroke: 0.05em),
        cellx(x: 0, y: 0, colspan: 2)[],
        hlinex(y: 1, stroke: 0.05em),
        cellx(x: 1, y: 1)[(1)],
        hlinex(start: 1, y: 2, stroke: 0.05em),
        cellx(x: 0, y: 16, align: name_align)[man],
        cellx(x: 1, y: 16)[-0.01026#ps.at(3)],
        cellx(x: 1, y: 17)[[-0.01331, -0.00722]],
        cellx(x: 0, y: 8, align: name_align)[relation: personal_private],
        cellx(x: 1, y: 8)[-0.06258#ps.at(3)],
        cellx(x: 1, y: 9)[[-0.06592, -0.05924]],
        cellx(x: 0, y: 4, align: name_align)[fpr],
        cellx(x: 1, y: 4)[1.0381#ps.at(3)],
        cellx(x: 1, y: 5)[[0.94551, 1.13069]],
        cellx(x: 0, y: 6, align: name_align)[fpr ^ 2],
        cellx(x: 1, y: 6)[-0.66974#ps.at(3)],
        cellx(x: 1, y: 7)[[-0.79484, -0.54464]],
        cellx(x: 0, y: 10, align: name_align)[degree],
        cellx(x: 1, y: 10)[0.10625#ps.at(3)],
        cellx(x: 1, y: 11)[[0.094, 0.1185]],
        cellx(x: 0, y: 2, align: name_align)[(Intercept)],
        cellx(x: 1, y: 2)[0.42305#ps.at(3)],
        cellx(x: 1, y: 3)[[0.40805, 0.43805]],
        cellx(x: 0, y: 12, align: name_align)[age],
        cellx(x: 1, y: 12)[0.21447#ps.at(3)],
        cellx(x: 1, y: 13)[[0.18701, 0.24192]],
        cellx(x: 0, y: 14, align: name_align)[age ^ 2],
        cellx(x: 1, y: 14)[-0.40895#ps.at(3)],
        cellx(x: 1, y: 15)[[-0.44615, -0.37175]],
        hlinex(start: 1, y: 18, stroke: 0.05em),
        cellx(x: 0, y: 18, align: name_align)[N],
        cellx(x: 1, y: 18)[19971],
        hlinex(y: 19, stroke: 0.1em),
        cellx(y: 19, colspan: 2, align: left)[Note: #ps.at(0)$p<0.1$; #ps.at(1)$p<0.05$; #ps.at(2)$p<0.005$; #ps.at(3)$p<0.001$],
    ),
    caption: flex-caption(
	[Model of TPR on FPR. Model of the respondent-level TPR on the FPR and basic demographic characteristics. The model values are adjusted for error at both stages of estimation.],
	[Model of TPR on FPR]
),
    kind: "table-si",
    supplement: [Supplementary Table],
) <rates_model>
