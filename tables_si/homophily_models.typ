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
        columns: (col1width, coliwidth, coliwidth, coliwidth, ), 
        rows: (0.2em, 1.5em), 
        align: center + horizon, 
        hlinex(y: 0, stroke: 0.05em), 
        cellx(x: 0, y: 0, colspan: 4)[], 
        hlinex(y: 1, stroke: 0.05em), 
        cellx(x: 1, y: 1)[(1)], 
        cellx(x: 2, y: 1)[(2)], 
        cellx(x: 3, y: 1)[(3)], 
        hlinex(start: 1, y: 2, stroke: 0.05em), 
        cellx(x: 0, y: 10, align: name_align)[educated_ad], 
        cellx(x: 1, y: 10)[0.121#ps.at(3)], 
        cellx(x: 1, y: 11)[[-0.116, 0.359]], 
        cellx(x: 3, y: 10)[0.108#ps.at(3)], 
        cellx(x: 3, y: 11)[[-0.104, 0.319]], 
        cellx(x: 0, y: 4, align: name_align)[-j_ad], 
        cellx(x: 1, y: 4)[-2.117#ps.at(3)], 
        cellx(x: 1, y: 5)[[2.033, -6.267]], 
        cellx(x: 2, y: 4)[0.569#ps.at(3)], 
        cellx(x: 2, y: 5)[[-0.546, 1.685]], 
        cellx(x: 3, y: 4)[-1.514#ps.at(3)], 
        cellx(x: 3, y: 5)[[1.453, -4.48]], 
        cellx(x: 0, y: 12, align: name_align)[religion_ad], 
        cellx(x: 1, y: 12)[0.412#ps.at(3)], 
        cellx(x: 1, y: 13)[[-0.395, 1.219]], 
        cellx(x: 3, y: 12)[0.424#ps.at(3)], 
        cellx(x: 3, y: 13)[[-0.407, 1.255]], 
        cellx(x: 0, y: 2, align: name_align)[(Intercept)], 
        cellx(x: 1, y: 2)[-2.621#ps.at(3)], 
        cellx(x: 1, y: 3)[[2.516, -7.759]], 
        cellx(x: 2, y: 2)[-1.888#ps.at(3)], 
        cellx(x: 2, y: 3)[[1.813, -5.589]], 
        cellx(x: 3, y: 2)[-2.363#ps.at(3)], 
        cellx(x: 3, y: 3)[[2.269, -6.995]], 
        cellx(x: 0, y: 6, align: name_align)[gender_ad], 
        cellx(x: 1, y: 6)[0.195#ps.at(3)], 
        cellx(x: 1, y: 7)[[-0.187, 0.576]], 
        cellx(x: 3, y: 6)[0.201#ps.at(3)], 
        cellx(x: 3, y: 7)[[-0.193, 0.594]], 
        cellx(x: 0, y: 8, align: name_align)[-age_ad], 
        cellx(x: 1, y: 8)[0.008#ps.at(3)], 
        cellx(x: 1, y: 9)[[-0.008, 0.024]], 
        cellx(x: 3, y: 8)[0.007#ps.at(3)], 
        cellx(x: 3, y: 9)[[-0.006, 0.02]], 
        hlinex(start: 1, y: 14, stroke: 0.05em), 
        cellx(x: 0, y: 14, align: name_align)[alter1 var.], 
        cellx(x: 0, y: 15, align: name_align)[alter2 var.], 
        cellx(x: 0, y: 16, align: name_align)[village_code var.], 
        cellx(x: 0, y: 17, align: name_align)[N#sub[groups]], 
        cellx(x: 2, y: 14)[0.102], 
        cellx(x: 2, y: 15)[0.1], 
        cellx(x: 2, y: 16)[0.275], 
        cellx(x: 2, y: 17)[9935, 9935, 82], 
        cellx(x: 3, y: 14)[0.121], 
        cellx(x: 3, y: 15)[0.12], 
        cellx(x: 3, y: 16)[0.269], 
        cellx(x: 3, y: 17)[9935, 9935, 82], 
        hlinex(start: 1, y: 18, stroke: 0.05em), 
        cellx(x: 0, y: 18, align: name_align)[N], 
        cellx(x: 0, y: 20, align: name_align)[BIC], 
        cellx(x: 0, y: 19, align: name_align)[AIC], 
        cellx(x: 1, y: 18)[937119], 
        cellx(x: 1, y: 20)[135719.236], 
        cellx(x: 1, y: 19)[135648.733], 
        cellx(x: 2, y: 18)[937119], 
        cellx(x: 2, y: 20)[134079.403], 
        cellx(x: 2, y: 19)[134020.65], 
        cellx(x: 3, y: 18)[937119], 
        cellx(x: 3, y: 20)[130482.742], 
        cellx(x: 3, y: 19)[130376.987], 
        hlinex(y: 21, stroke: 0.1em), 
        cellx(y: 21, colspan: 4, align: left)[Note: #ps.at(0)$p<0.1$; #ps.at(1)$p<0.05$; #ps.at(2)$p<0.005$; #ps.at(3)$p<0.001$] 
    ), 
    caption: [Probit models of the presence of a tie, regressing on alter-alter differences. The focal variable is the negative of the absolute difference between the accuracy score ($J$) of $i$ and that of $j$.]
) <homophily_models>
