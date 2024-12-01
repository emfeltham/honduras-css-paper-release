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
        columns: (col1width, coliwidth, coliwidth, coliwidth, coliwidth, ),
        rows: (0.2em, 1.5em),
        align: center + horizon,
        stroke: auto,
        hlinex(y: 0, stroke: 0.05em),
        cellx(x: 0, y: 0, colspan: 5)[],
        hlinex(y: 1, stroke: 0.05em),
        cellx(x: 1, y: 1)[(TPR | $D_(r[i j]k) lt.eq 2$)],
        cellx(x: 2, y: 1)[(TPR)],
        cellx(x: 3, y: 1)[(FPR | $D_(r[i j]k) lt.eq 2$)],
        cellx(x: 4, y: 1)[(FPR)],
        hlinex(start: 1, y: 2, stroke: 0.05em),
        cellx(x: 0, y: 20, align: name_align)[religion_c: No Religion],
        cellx(x: 1, y: 20)[-0.175],
        cellx(x: 1, y: 21)[(0.145)],
        cellx(x: 2, y: 20)[-0.17#ps.at(0)],
        cellx(x: 2, y: 21)[(0.101)],
        cellx(x: 3, y: 20)[0.17],
        cellx(x: 3, y: 21)[(0.108)],
        cellx(x: 4, y: 20)[-0.064],
        cellx(x: 4, y: 21)[(0.088)],
        cellx(x: 0, y: 44, align: name_align)[degree_diff_a],
        cellx(x: 1, y: 44)[0.27#ps.at(1)],
        cellx(x: 1, y: 45)[(0.106)],
        cellx(x: 2, y: 44)[0.223#ps.at(2)],
        cellx(x: 2, y: 45)[(0.07)],
        cellx(x: 3, y: 44)[0.01],
        cellx(x: 3, y: 45)[(0.07)],
        cellx(x: 4, y: 44)[0.264#ps.at(3)],
        cellx(x: 4, y: 45)[(0.042)],
        cellx(x: 0, y: 46, align: name_align)[age_mean_a],
        cellx(x: 1, y: 46)[-2.159#ps.at(3)],
        cellx(x: 1, y: 47)[(0.156)],
        cellx(x: 2, y: 46)[-2.628#ps.at(3)],
        cellx(x: 2, y: 47)[(0.089)],
        cellx(x: 3, y: 46)[-0.114],
        cellx(x: 3, y: 47)[(0.107)],
        cellx(x: 4, y: 46)[-0.52#ps.at(3)],
        cellx(x: 4, y: 47)[(0.052)],
        cellx(x: 0, y: 18, align: name_align)[educated: Yes],
        cellx(x: 1, y: 18)[-0.249#ps.at(3)],
        cellx(x: 1, y: 19)[(0.067)],
        cellx(x: 2, y: 18)[-0.263#ps.at(3)],
        cellx(x: 2, y: 19)[(0.053)],
        cellx(x: 3, y: 18)[-0.447#ps.at(3)],
        cellx(x: 3, y: 19)[(0.06)],
        cellx(x: 4, y: 18)[-0.56#ps.at(3)],
        cellx(x: 4, y: 19)[(0.052)],
        cellx(x: 0, y: 52, align: name_align)[wealth_d1_4_diff_a],
        cellx(x: 1, y: 52)[-1.523#ps.at(3)],
        cellx(x: 1, y: 53)[(0.094)],
        cellx(x: 2, y: 52)[-1.406#ps.at(3)],
        cellx(x: 2, y: 53)[(0.057)],
        cellx(x: 3, y: 52)[-1.271#ps.at(3)],
        cellx(x: 3, y: 53)[(0.058)],
        cellx(x: 4, y: 52)[-1.034#ps.at(3)],
        cellx(x: 4, y: 53)[(0.03)],
        cellx(x: 0, y: 84, align: name_align)[dists_p_notinf & dists_p],
        cellx(x: 2, y: 84)[-2.046#ps.at(3)],
        cellx(x: 2, y: 85)[(0.08)],
        cellx(x: 4, y: 84)[-1.43#ps.at(3)],
        cellx(x: 4, y: 85)[(0.056)],
        cellx(x: 0, y: 24, align: name_align)[wealth_d1_4],
        cellx(x: 1, y: 24)[-2.045#ps.at(3)],
        cellx(x: 1, y: 25)[(0.384)],
        cellx(x: 2, y: 24)[-2.669#ps.at(3)],
        cellx(x: 2, y: 25)[(0.244)],
        cellx(x: 3, y: 24)[-3.346#ps.at(3)],
        cellx(x: 3, y: 25)[(0.287)],
        cellx(x: 4, y: 24)[-3.255#ps.at(3)],
        cellx(x: 4, y: 25)[(0.169)],
        cellx(x: 0, y: 56, align: name_align)[man & man_a: Mixed],
        cellx(x: 1, y: 56)[-0.301#ps.at(3)],
        cellx(x: 1, y: 57)[(0.077)],
        cellx(x: 2, y: 56)[-0.414#ps.at(3)],
        cellx(x: 2, y: 57)[(0.046)],
        cellx(x: 3, y: 56)[-0.031],
        cellx(x: 3, y: 57)[(0.045)],
        cellx(x: 4, y: 56)[-0.172#ps.at(3)],
        cellx(x: 4, y: 57)[(0.023)],
        cellx(x: 0, y: 54, align: name_align)[dists_p],
        cellx(x: 1, y: 54)[-0.703#ps.at(3)],
        cellx(x: 1, y: 55)[(0.036)],
        cellx(x: 3, y: 54)[-0.838#ps.at(3)],
        cellx(x: 3, y: 55)[(0.022)],
        cellx(x: 0, y: 48, align: name_align)[age_diff_a],
        cellx(x: 1, y: 48)[1.271#ps.at(3)],
        cellx(x: 1, y: 49)[(0.082)],
        cellx(x: 2, y: 48)[1.385#ps.at(3)],
        cellx(x: 2, y: 49)[(0.051)],
        cellx(x: 3, y: 48)[0.26#ps.at(3)],
        cellx(x: 3, y: 49)[(0.045)],
        cellx(x: 4, y: 48)[0.124#ps.at(3)],
        cellx(x: 4, y: 49)[(0.025)],
        cellx(x: 0, y: 58, align: name_align)[man & man_a: Women],
        cellx(x: 1, y: 58)[0.037],
        cellx(x: 1, y: 59)[(0.067)],
        cellx(x: 2, y: 58)[-0.344#ps.at(3)],
        cellx(x: 2, y: 59)[(0.039)],
        cellx(x: 3, y: 58)[0.325#ps.at(3)],
        cellx(x: 3, y: 59)[(0.051)],
        cellx(x: 4, y: 58)[-0.087#ps.at(3)],
        cellx(x: 4, y: 59)[(0.025)],
        cellx(x: 0, y: 14, align: name_align)[age ^ 2],
        cellx(x: 1, y: 14)[-0.667],
        cellx(x: 1, y: 15)[(0.431)],
        cellx(x: 2, y: 14)[-1.438#ps.at(3)],
        cellx(x: 2, y: 15)[(0.338)],
        cellx(x: 3, y: 14)[1.686#ps.at(3)],
        cellx(x: 3, y: 15)[(0.383)],
        cellx(x: 4, y: 14)[1.125#ps.at(2)],
        cellx(x: 4, y: 15)[(0.33)],
        cellx(x: 0, y: 64, align: name_align)[religion_c: No Religion & religion_c_a: Same],
        cellx(x: 1, y: 64)[0.131],
        cellx(x: 1, y: 65)[(0.154)],
        cellx(x: 3, y: 64)[-0.298#ps.at(2)],
        cellx(x: 3, y: 65)[(0.094)],
        cellx(x: 0, y: 74, align: name_align)[kin431 & relation: personal_private],
        cellx(x: 1, y: 74)[0.273#ps.at(3)],
        cellx(x: 1, y: 75)[(0.064)],
        cellx(x: 2, y: 74)[0.257#ps.at(3)],
        cellx(x: 2, y: 75)[(0.035)],
        cellx(x: 3, y: 74)[0.255#ps.at(3)],
        cellx(x: 3, y: 75)[(0.049)],
        cellx(x: 4, y: 74)[0.241#ps.at(3)],
        cellx(x: 4, y: 75)[(0.022)],
        cellx(x: 0, y: 42, align: name_align)[degree_mean_a],
        cellx(x: 1, y: 42)[-1.103#ps.at(3)],
        cellx(x: 1, y: 43)[(0.212)],
        cellx(x: 2, y: 42)[-1.393#ps.at(3)],
        cellx(x: 2, y: 43)[(0.128)],
        cellx(x: 3, y: 42)[-0.971#ps.at(3)],
        cellx(x: 3, y: 43)[(0.157)],
        cellx(x: 4, y: 42)[-1.386#ps.at(3)],
        cellx(x: 4, y: 43)[(0.083)],
        cellx(x: 0, y: 2, align: name_align)[(Intercept)],
        cellx(x: 1, y: 2)[2.15#ps.at(3)],
        cellx(x: 1, y: 3)[(0.247)],
        cellx(x: 2, y: 2)[1.951#ps.at(3)],
        cellx(x: 2, y: 3)[(0.169)],
        cellx(x: 3, y: 2)[2.209#ps.at(3)],
        cellx(x: 3, y: 3)[(0.192)],
        cellx(x: 4, y: 2)[1.078#ps.at(3)],
        cellx(x: 4, y: 3)[(0.128)],
        cellx(x: 0, y: 80, align: name_align)[religion_c: No Religion & religion_c_a: Mixed],
        cellx(x: 2, y: 80)[0.213#ps.at(1)],
        cellx(x: 2, y: 81)[(0.097)],
        cellx(x: 4, y: 80)[0.245#ps.at(3)],
        cellx(x: 4, y: 81)[(0.055)],
        cellx(x: 0, y: 6, align: name_align)[relation: personal_private],
        cellx(x: 1, y: 6)[-0.384#ps.at(3)],
        cellx(x: 1, y: 7)[(0.029)],
        cellx(x: 2, y: 6)[-0.438#ps.at(3)],
        cellx(x: 2, y: 7)[(0.018)],
        cellx(x: 3, y: 6)[-0.207#ps.at(3)],
        cellx(x: 3, y: 7)[(0.016)],
        cellx(x: 4, y: 6)[-0.277#ps.at(3)],
        cellx(x: 4, y: 7)[(0.009)],
        cellx(x: 0, y: 4, align: name_align)[kin431],
        cellx(x: 1, y: 4)[2.676#ps.at(3)],
        cellx(x: 1, y: 5)[(0.052)],
        cellx(x: 2, y: 4)[2.525#ps.at(3)],
        cellx(x: 2, y: 5)[(0.029)],
        cellx(x: 3, y: 4)[3.21#ps.at(3)],
        cellx(x: 3, y: 5)[(0.038)],
        cellx(x: 4, y: 4)[3.14#ps.at(3)],
        cellx(x: 4, y: 5)[(0.017)],
        cellx(x: 0, y: 50, align: name_align)[wealth_d1_4_mean_a],
        cellx(x: 1, y: 50)[0.012],
        cellx(x: 1, y: 51)[(0.377)],
        cellx(x: 2, y: 50)[-0.601#ps.at(1)],
        cellx(x: 2, y: 51)[(0.23)],
        cellx(x: 3, y: 50)[-1.611#ps.at(3)],
        cellx(x: 3, y: 51)[(0.273)],
        cellx(x: 4, y: 50)[-1.221#ps.at(3)],
        cellx(x: 4, y: 51)[(0.14)],
        cellx(x: 0, y: 62, align: name_align)[isindigenous_a: Mixed & isindigenous],
        cellx(x: 1, y: 62)[0.062],
        cellx(x: 1, y: 63)[(0.121)],
        cellx(x: 2, y: 62)[-0.012],
        cellx(x: 2, y: 63)[(0.072)],
        cellx(x: 3, y: 62)[0.158#ps.at(1)],
        cellx(x: 3, y: 63)[(0.075)],
        cellx(x: 4, y: 62)[0.033],
        cellx(x: 4, y: 63)[(0.039)],
        cellx(x: 0, y: 8, align: name_align)[degree],
        cellx(x: 1, y: 8)[0.232],
        cellx(x: 1, y: 9)[(0.286)],
        cellx(x: 2, y: 8)[-0.3#ps.at(0)],
        cellx(x: 2, y: 9)[(0.182)],
        cellx(x: 3, y: 8)[-1.367#ps.at(3)],
        cellx(x: 3, y: 9)[(0.165)],
        cellx(x: 4, y: 8)[-0.671#ps.at(3)],
        cellx(x: 4, y: 9)[(0.095)],
        cellx(x: 0, y: 72, align: name_align)[wealth_d1_4 & wealth_d1_4_mean_a],
        cellx(x: 1, y: 72)[2.539#ps.at(3)],
        cellx(x: 1, y: 73)[(0.633)],
        cellx(x: 2, y: 72)[3.597#ps.at(3)],
        cellx(x: 2, y: 73)[(0.39)],
        cellx(x: 3, y: 72)[4.435#ps.at(3)],
        cellx(x: 3, y: 73)[(0.459)],
        cellx(x: 4, y: 72)[4.073#ps.at(3)],
        cellx(x: 4, y: 73)[(0.238)],
        cellx(x: 0, y: 68, align: name_align)[degree & degree_mean_a],
        cellx(x: 1, y: 68)[0.793],
        cellx(x: 1, y: 69)[(0.909)],
        cellx(x: 2, y: 68)[3.209#ps.at(3)],
        cellx(x: 2, y: 69)[(0.642)],
        cellx(x: 3, y: 68)[3.416#ps.at(3)],
        cellx(x: 3, y: 69)[(0.623)],
        cellx(x: 4, y: 68)[3.373#ps.at(3)],
        cellx(x: 4, y: 69)[(0.404)],
        cellx(x: 0, y: 78, align: name_align)[dists_p_notinf],
        cellx(x: 2, y: 78)[0.555#ps.at(3)],
        cellx(x: 2, y: 79)[(0.045)],
        cellx(x: 4, y: 78)[0.473#ps.at(3)],
        cellx(x: 4, y: 79)[(0.031)],
        cellx(x: 0, y: 82, align: name_align)[religion_c: Protestant & religion_c_a: Mixed],
        cellx(x: 2, y: 82)[0.263#ps.at(3)],
        cellx(x: 2, y: 83)[(0.04)],
        cellx(x: 4, y: 82)[0.278#ps.at(3)],
        cellx(x: 4, y: 83)[(0.023)],
        cellx(x: 0, y: 86, align: name_align)[dists_a_notinf],
        cellx(x: 4, y: 86)[0.896#ps.at(3)],
        cellx(x: 4, y: 87)[(0.033)],
        cellx(x: 0, y: 88, align: name_align)[dists_a_notinf & dists_a],
        cellx(x: 4, y: 88)[-3.425#ps.at(3)],
        cellx(x: 4, y: 89)[(0.053)],
        cellx(x: 0, y: 36, align: name_align)[isindigenous_a: Mestizo],
        cellx(x: 1, y: 36)[0.051],
        cellx(x: 1, y: 37)[(0.087)],
        cellx(x: 2, y: 36)[0.092#ps.at(0)],
        cellx(x: 2, y: 37)[(0.051)],
        cellx(x: 3, y: 36)[-0.008],
        cellx(x: 3, y: 37)[(0.06)],
        cellx(x: 4, y: 36)[0.024],
        cellx(x: 4, y: 37)[(0.031)],
        cellx(x: 0, y: 70, align: name_align)[age & age_mean_a],
        cellx(x: 1, y: 70)[2.913#ps.at(3)],
        cellx(x: 1, y: 71)[(0.411)],
        cellx(x: 2, y: 70)[4.29#ps.at(3)],
        cellx(x: 2, y: 71)[(0.237)],
        cellx(x: 3, y: 70)[0.227],
        cellx(x: 3, y: 71)[(0.275)],
        cellx(x: 4, y: 70)[1.327#ps.at(3)],
        cellx(x: 4, y: 71)[(0.136)],
        cellx(x: 0, y: 22, align: name_align)[religion_c: Protestant],
        cellx(x: 1, y: 22)[-0.134#ps.at(1)],
        cellx(x: 1, y: 23)[(0.062)],
        cellx(x: 2, y: 22)[-0.128#ps.at(2)],
        cellx(x: 2, y: 23)[(0.042)],
        cellx(x: 3, y: 22)[-0.15#ps.at(2)],
        cellx(x: 3, y: 23)[(0.046)],
        cellx(x: 4, y: 22)[-0.168#ps.at(3)],
        cellx(x: 4, y: 23)[(0.037)],
        cellx(x: 0, y: 12, align: name_align)[age],
        cellx(x: 1, y: 12)[-0.227],
        cellx(x: 1, y: 13)[(0.369)],
        cellx(x: 2, y: 12)[-0.103],
        cellx(x: 2, y: 13)[(0.285)],
        cellx(x: 3, y: 12)[-0.261],
        cellx(x: 3, y: 13)[(0.314)],
        cellx(x: 4, y: 12)[0.005],
        cellx(x: 4, y: 13)[(0.269)],
        cellx(x: 0, y: 60, align: name_align)[isindigenous_a: Mestizo & isindigenous],
        cellx(x: 1, y: 60)[-0.14],
        cellx(x: 1, y: 61)[(0.127)],
        cellx(x: 2, y: 60)[-0.145#ps.at(0)],
        cellx(x: 2, y: 61)[(0.078)],
        cellx(x: 3, y: 60)[-0.005],
        cellx(x: 3, y: 61)[(0.087)],
        cellx(x: 4, y: 60)[-0.085#ps.at(0)],
        cellx(x: 4, y: 61)[(0.046)],
        cellx(x: 0, y: 32, align: name_align)[man_a: Mixed],
        cellx(x: 1, y: 32)[0.16#ps.at(2)],
        cellx(x: 1, y: 33)[(0.05)],
        cellx(x: 2, y: 32)[0.314#ps.at(3)],
        cellx(x: 2, y: 33)[(0.029)],
        cellx(x: 3, y: 32)[-0.7#ps.at(3)],
        cellx(x: 3, y: 33)[(0.031)],
        cellx(x: 4, y: 32)[-0.606#ps.at(3)],
        cellx(x: 4, y: 33)[(0.015)],
        cellx(x: 0, y: 40, align: name_align)[religion_c_a: Same],
        cellx(x: 1, y: 40)[0.18#ps.at(3)],
        cellx(x: 1, y: 41)[(0.045)],
        cellx(x: 3, y: 40)[0.338#ps.at(3)],
        cellx(x: 3, y: 41)[(0.026)],
        cellx(x: 0, y: 28, align: name_align)[isindigenous],
        cellx(x: 1, y: 28)[0.083],
        cellx(x: 1, y: 29)[(0.107)],
        cellx(x: 2, y: 28)[0.195#ps.at(1)],
        cellx(x: 2, y: 29)[(0.072)],
        cellx(x: 3, y: 28)[0.002],
        cellx(x: 3, y: 29)[(0.082)],
        cellx(x: 4, y: 28)[0.029],
        cellx(x: 4, y: 29)[(0.058)],
        cellx(x: 0, y: 38, align: name_align)[isindigenous_a: Mixed],
        cellx(x: 1, y: 38)[-0.077],
        cellx(x: 1, y: 39)[(0.088)],
        cellx(x: 2, y: 38)[0.024],
        cellx(x: 2, y: 39)[(0.052)],
        cellx(x: 3, y: 38)[-0.114#ps.at(0)],
        cellx(x: 3, y: 39)[(0.059)],
        cellx(x: 4, y: 38)[-0.04],
        cellx(x: 4, y: 39)[(0.03)],
        cellx(x: 0, y: 34, align: name_align)[man_a: Women],
        cellx(x: 1, y: 34)[0.288#ps.at(3)],
        cellx(x: 1, y: 35)[(0.042)],
        cellx(x: 2, y: 34)[0.426#ps.at(3)],
        cellx(x: 2, y: 35)[(0.024)],
        cellx(x: 3, y: 34)[-0.321#ps.at(3)],
        cellx(x: 3, y: 35)[(0.033)],
        cellx(x: 4, y: 34)[-0.113#ps.at(3)],
        cellx(x: 4, y: 35)[(0.015)],
        cellx(x: 0, y: 66, align: name_align)[religion_c: Protestant & religion_c_a: Same],
        cellx(x: 1, y: 66)[0.21#ps.at(2)],
        cellx(x: 1, y: 67)[(0.063)],
        cellx(x: 3, y: 66)[0.145#ps.at(3)],
        cellx(x: 3, y: 67)[(0.037)],
        cellx(x: 0, y: 10, align: name_align)[man],
        cellx(x: 1, y: 10)[0.136#ps.at(1)],
        cellx(x: 1, y: 11)[(0.059)],
        cellx(x: 2, y: 10)[0.329#ps.at(3)],
        cellx(x: 2, y: 11)[(0.041)],
        cellx(x: 3, y: 10)[0.031],
        cellx(x: 3, y: 11)[(0.05)],
        cellx(x: 4, y: 10)[0.26#ps.at(3)],
        cellx(x: 4, y: 11)[(0.036)],
        cellx(x: 0, y: 16, align: name_align)[educated: Some],
        cellx(x: 1, y: 16)[-0.095#ps.at(0)],
        cellx(x: 1, y: 17)[(0.054)],
        cellx(x: 2, y: 16)[-0.113#ps.at(1)],
        cellx(x: 2, y: 17)[(0.043)],
        cellx(x: 3, y: 16)[-0.186#ps.at(3)],
        cellx(x: 3, y: 17)[(0.047)],
        cellx(x: 4, y: 16)[-0.297#ps.at(3)],
        cellx(x: 4, y: 17)[(0.041)],
        cellx(x: 0, y: 26, align: name_align)[coffee_cultivation],
        cellx(x: 1, y: 26)[0.221#ps.at(2)],
        cellx(x: 1, y: 27)[(0.069)],
        cellx(x: 2, y: 26)[0.228#ps.at(3)],
        cellx(x: 2, y: 27)[(0.064)],
        cellx(x: 3, y: 26)[0.121],
        cellx(x: 3, y: 27)[(0.086)],
        cellx(x: 4, y: 26)[0.142#ps.at(0)],
        cellx(x: 4, y: 27)[(0.078)],
        cellx(x: 0, y: 30, align: name_align)[educated_a: Same],
        cellx(x: 1, y: 30)[0.02],
        cellx(x: 1, y: 31)[(0.026)],
        cellx(x: 2, y: 30)[-0.004],
        cellx(x: 2, y: 31)[(0.016)],
        cellx(x: 3, y: 30)[0.018],
        cellx(x: 3, y: 31)[(0.016)],
        cellx(x: 4, y: 30)[0.035#ps.at(3)],
        cellx(x: 4, y: 31)[(0.008)],
        cellx(x: 0, y: 76, align: name_align)[religion_c_a: Mixed],
        cellx(x: 2, y: 76)[-0.237#ps.at(3)],
        cellx(x: 2, y: 77)[(0.026)],
        cellx(x: 4, y: 76)[-0.319#ps.at(3)],
        cellx(x: 4, y: 77)[(0.014)],
        hlinex(start: 1, y: 90, stroke: 0.05em),
        cellx(x: 0, y: 90, align: name_align)[perceiver var.],
        cellx(x: 0, y: 91, align: name_align)[village_code var.],
        cellx(x: 0, y: 92, align: name_align)[N#sub[groups]],
        cellx(x: 1, y: 90)[1.31],
        cellx(x: 1, y: 91)[0.196],
        cellx(x: 1, y: 92)[9757, 82],
        cellx(x: 2, y: 90)[1.243],
        cellx(x: 2, y: 91)[0.202],
        cellx(x: 2, y: 92)[9943, 82],
        cellx(x: 3, y: 90)[1.417],
        cellx(x: 3, y: 91)[0.293],
        cellx(x: 3, y: 92)[9734, 82],
        cellx(x: 4, y: 90)[1.387],
        cellx(x: 4, y: 91)[0.268],
        cellx(x: 4, y: 92)[9940, 82],
        hlinex(start: 1, y: 93, stroke: 0.05em),
        cellx(x: 0, y: 93, align: name_align)[N],
        cellx(x: 0, y: 94, align: name_align)[BIC],
        cellx(x: 0, y: 95, align: name_align)[AIC],
        cellx(x: 1, y: 93)[75194],
        cellx(x: 1, y: 94)[52826.252],
        cellx(x: 1, y: 95)[52466.367],
        cellx(x: 2, y: 93)[175316],
        cellx(x: 2, y: 94)[129846.703],
        cellx(x: 2, y: 95)[129443.729],
        cellx(x: 3, y: 93)[130948],
        cellx(x: 3, y: 94)[133077.034],
        cellx(x: 3, y: 95)[132695.514],
        cellx(x: 4, y: 93)[448062],
        cellx(x: 4, y: 94)[421252.935],
        cellx(x: 4, y: 95)[420790.402],
        hlinex(y: 96, stroke: 0.1em),
        cellx(y: 96, colspan: 5, align: left)[Note: #ps.at(0)$p<0.1$; #ps.at(1)$p<0.05$; #ps.at(2)$p<0.005$; #ps.at(3)$p<0.001$],
    ),
    caption: flex-caption(
	[Network response model, with restriction on distance. Comparison of models that only include observations where the geodesic distance in the network between $k$ and the $(i,j)$ pair is 2 or less.],
	[Network response model, with restriction on distance.]
),
    kind: table,
) <table-lt-2-comp-regtable>