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
        columns: (col1width, coliwidth, coliwidth, coliwidth, ),
        rows: (0.2em, 1.5em),
        align: center + horizon,
        stroke: auto,
        hlinex(y: 0, stroke: 0.05em),
        cellx(x: 0, y: 0, colspan: 4)[],
        hlinex(y: 1, stroke: 0.05em),
        cellx(x: 1, y: 1)[(1)],
        cellx(x: 2, y: 1)[(2)],
        cellx(x: 3, y: 1)[(3)],
        hlinex(start: 1, y: 2, stroke: 0.05em),
        cellx(x: 0, y: 26, align: name_align)[J],
        cellx(x: 3, y: 26)[4.3836#ps.at(3)],
        cellx(x: 3, y: 27)[[2.729, 6.0382]],
        cellx(x: 0, y: 22, align: name_align)[Educated: Yes],
        cellx(x: 1, y: 22)[0.7552#ps.at(3)],
        cellx(x: 1, y: 23)[[0.5519, 0.9585]],
        cellx(x: 2, y: 22)[0.4095#ps.at(3)],
        cellx(x: 2, y: 23)[[0.2062, 0.6128]],
        cellx(x: 3, y: 22)[1.0927#ps.at(3)],
        cellx(x: 3, y: 23)[[0.8894, 1.296]],
        cellx(x: 0, y: 8, align: name_align)[Riddle: Zinc],
        cellx(x: 1, y: 8)[-0.2739#ps.at(3)],
        cellx(x: 1, y: 9)[[-0.3733, -0.1744]],
        cellx(x: 2, y: 8)[-0.2737#ps.at(3)],
        cellx(x: 2, y: 9)[[-0.3731, -0.1742]],
        cellx(x: 3, y: 8)[-0.2721#ps.at(3)],
        cellx(x: 3, y: 9)[[-0.3715, -0.1726]],
        cellx(x: 0, y: 2, align: name_align)[(Intercept)],
        cellx(x: 1, y: 2)[2.7235#ps.at(3)],
        cellx(x: 1, y: 3)[[1.5502, 3.8969]],
        cellx(x: 2, y: 2)[-0.2744],
        cellx(x: 2, y: 3)[[-1.4477, 0.899]],
        cellx(x: 3, y: 2)[-4.1453#ps.at(3)],
        cellx(x: 3, y: 3)[[-5.3186, -2.9719]],
        cellx(x: 0, y: 4, align: name_align)[TPR],
        cellx(x: 1, y: 4)[-7.8769#ps.at(3)],
        cellx(x: 1, y: 5)[[-9.5315, -6.2222]],
        cellx(x: 0, y: 6, align: name_align)[Riddle: Prenatal],
        cellx(x: 1, y: 6)[-0.8252#ps.at(3)],
        cellx(x: 1, y: 7)[[-0.9358, -0.7147]],
        cellx(x: 2, y: 6)[-0.8245#ps.at(3)],
        cellx(x: 2, y: 7)[[-0.935, -0.7139]],
        cellx(x: 3, y: 6)[-0.8203#ps.at(3)],
        cellx(x: 3, y: 7)[[-0.9308, -0.7098]],
        cellx(x: 0, y: 14, align: name_align)[Age],
        cellx(x: 1, y: 14)[7.7102#ps.at(3)],
        cellx(x: 1, y: 15)[[6.5926, 8.8278]],
        cellx(x: 2, y: 14)[5.3633#ps.at(3)],
        cellx(x: 2, y: 15)[[4.2457, 6.4809]],
        cellx(x: 3, y: 14)[4.3716#ps.at(3)],
        cellx(x: 3, y: 15)[[3.254, 5.4892]],
        cellx(x: 0, y: 18, align: name_align)[Gender: Man],
        cellx(x: 1, y: 18)[-0.5273#ps.at(3)],
        cellx(x: 1, y: 19)[[-0.6307, -0.4238]],
        cellx(x: 2, y: 18)[-0.3911#ps.at(3)],
        cellx(x: 2, y: 19)[[-0.4946, -0.2877]],
        cellx(x: 3, y: 18)[-0.5053#ps.at(3)],
        cellx(x: 3, y: 19)[[-0.6088, -0.4019]],
        cellx(x: 0, y: 20, align: name_align)[Educated: Some],
        cellx(x: 1, y: 20)[0.221#ps.at(2)],
        cellx(x: 1, y: 21)[[0.0718, 0.3702]],
        cellx(x: 2, y: 20)[-0.0584],
        cellx(x: 2, y: 21)[[-0.2076, 0.0908]],
        cellx(x: 3, y: 20)[0.2657#ps.at(3)],
        cellx(x: 3, y: 21)[[0.1165, 0.4148]],
        cellx(x: 0, y: 10, align: name_align)[Relation: Personal private],
        cellx(x: 1, y: 10)[-0.7893#ps.at(3)],
        cellx(x: 1, y: 11)[[-0.9722, -0.6063]],
        cellx(x: 2, y: 10)[-0.3726#ps.at(3)],
        cellx(x: 2, y: 11)[[-0.5555, -0.1896]],
        cellx(x: 3, y: 10)[0.1733#ps.at(0)],
        cellx(x: 3, y: 11)[[-0.0097, 0.3562]],
        cellx(x: 0, y: 24, align: name_align)[FPR],
        cellx(x: 2, y: 24)[-6.6217#ps.at(3)],
        cellx(x: 2, y: 25)[[-8.2763, -4.9671]],
        cellx(x: 0, y: 12, align: name_align)[Degree],
        cellx(x: 1, y: 12)[1.7879#ps.at(3)],
        cellx(x: 1, y: 13)[[1.3947, 2.1811]],
        cellx(x: 2, y: 12)[0.8439#ps.at(3)],
        cellx(x: 2, y: 13)[[0.4507, 1.2371]],
        cellx(x: 3, y: 12)[0.5018#ps.at(1)],
        cellx(x: 3, y: 13)[[0.1086, 0.895]],
        cellx(x: 0, y: 16, align: name_align)[Age ^ 2],
        cellx(x: 1, y: 16)[-10.3243#ps.at(3)],
        cellx(x: 1, y: 17)[[-11.7813, -8.8673]],
        cellx(x: 2, y: 16)[-5.5824#ps.at(3)],
        cellx(x: 2, y: 17)[[-7.0394, -4.1254]],
        cellx(x: 3, y: 16)[-5.2133#ps.at(3)],
        cellx(x: 3, y: 17)[[-6.6703, -3.7563]],
        hlinex(start: 1, y: 28, stroke: 0.05em),
        cellx(x: 0, y: 28, align: name_align)[N],
        cellx(x: 1, y: 28)[16363],
        cellx(x: 2, y: 28)[16363],
        cellx(x: 3, y: 28)[16363],
        hlinex(y: 29, stroke: 0.1em),
        cellx(y: 29, colspan: 4, align: left)[Note: #ps.at(0)$p<0.1$; #ps.at(1)$p<0.05$; #ps.at(2)$p<0.005$; #ps.at(3)$p<0.001$],
    ),
    caption: flex-caption(
[Riddle models. Logistic models of riddle knowledge on the respondent-level accuracy metrics, adjusting for basic demographic characteristics. The model values are adjusted for error at both stages of estimation.],
[Riddle models]
),
    kind: table,
) <riddle_models>
