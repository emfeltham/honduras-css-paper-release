#import"@preview/tablex:0.0.8": tablex, gridx, hlinex, vlinex, colspanx, rowspanx, cellx

// table params 
#let col1width = 10em
#let coliwidth = auto
#let name_align = left + horizon 

// pkey 
#let ps = (super[$+$], super[$star.op$], super[$star.op star.op$], super[$star.op star.op star.op$], )
 
#figure( 
    kind: table, 
    gridx( 
        columns: (col1width, coliwidth, coliwidth, coliwidth, coliwidth, ), 
        rows: (0.2em, 1.5em), 
        align: center + horizon, 
        hlinex(y: 0, stroke: 0.05em), 
        cellx(x: 0, y: 0, colspan: 5)[], 
        hlinex(y: 1, stroke: 0.05em), 
        cellx(x: 1, y: 1)[(1)], 
        cellx(x: 2, y: 1)[(2)], 
        cellx(x: 3, y: 1)[(3)], 
        cellx(x: 4, y: 1)[(4)], 
        hlinex(start: 1, y: 2, stroke: 0.05em), 
        cellx(x: 0, y: 4, align: name_align)[educated: Some], 
        cellx(x: 1, y: 4)[-0.103#ps.at(1)], 
        cellx(x: 1, y: 5)[[0.099, -0.306]], 
        cellx(x: 2, y: 4)[-0.003#ps.at(3)], 
        cellx(x: 2, y: 5)[[0.002, -0.007]], 
        cellx(x: 3, y: 4)[-0.294#ps.at(3)], 
        cellx(x: 3, y: 5)[[0.282, -0.87]], 
        cellx(x: 4, y: 4)[-0.004#ps.at(3)], 
        cellx(x: 4, y: 5)[[0.004, -0.012]], 
        cellx(x: 0, y: 6, align: name_align)[educated: Yes], 
        cellx(x: 1, y: 6)[-0.297#ps.at(3)], 
        cellx(x: 1, y: 7)[[0.285, -0.879]], 
        cellx(x: 2, y: 6)[-0.006#ps.at(3)], 
        cellx(x: 2, y: 7)[[0.006, -0.018]], 
        cellx(x: 3, y: 6)[-0.851#ps.at(3)], 
        cellx(x: 3, y: 7)[[0.817, -2.519]], 
        cellx(x: 4, y: 6)[-0.01#ps.at(3)], 
        cellx(x: 4, y: 7)[[0.009, -0.029]], 
        cellx(x: 0, y: 2, align: name_align)[(Intercept)], 
        cellx(x: 1, y: 2)[3.116#ps.at(3)], 
        cellx(x: 1, y: 3)[[-2.992, 9.225]], 
        cellx(x: 2, y: 2)[0.023#ps.at(3)], 
        cellx(x: 2, y: 3)[[-0.022, 0.069]], 
        cellx(x: 3, y: 2)[3.561#ps.at(3)], 
        cellx(x: 3, y: 3)[[-3.419, 10.541]], 
        cellx(x: 4, y: 2)[0.026#ps.at(3)], 
        cellx(x: 4, y: 3)[[-0.025, 0.078]], 
        hlinex(start: 1, y: 8, stroke: 0.05em), 
        cellx(x: 0, y: 8, align: name_align)[N], 
        cellx(x: 0, y: 10, align: name_align)[BIC], 
        cellx(x: 0, y: 11, align: name_align)[$R^2$], 
        cellx(x: 0, y: 9, align: name_align)[AIC], 
        cellx(x: 1, y: 8)[11786], 
        cellx(x: 1, y: 10)[45498.498], 
        cellx(x: 1, y: 11)[0.004], 
        cellx(x: 1, y: 9)[45468.999], 
        cellx(x: 2, y: 8)[11786], 
        cellx(x: 2, y: 10)[-59172.124], 
        cellx(x: 2, y: 11)[0.013], 
        cellx(x: 2, y: 9)[-59201.623], 
        cellx(x: 3, y: 8)[11879], 
        cellx(x: 3, y: 10)[50483.146], 
        cellx(x: 3, y: 11)[0.024], 
        cellx(x: 3, y: 9)[50453.616], 
        cellx(x: 4, y: 8)[11879], 
        cellx(x: 4, y: 10)[-57022.509], 
        cellx(x: 4, y: 11)[0.026], 
        cellx(x: 4, y: 9)[-57052.039], 
        hlinex(y: 12, stroke: 0.1em), 
        cellx(y: 12, colspan: 5, align: left)[Note: #ps.at(0)$p<0.1$; #ps.at(1)$p<0.05$; #ps.at(2)$p<0.005$; #ps.at(3)$p<0.001$] 
    ), 
    caption: [Relationship between education and degree.]
) <m_degree_education>
