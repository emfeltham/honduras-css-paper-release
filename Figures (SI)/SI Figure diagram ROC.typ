
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

#figure(
   image("SI Figure diagram ROC.svg", width: 100%),
   caption: flex-caption(
    [ROC-space plot example. The dotted line  ($y = x$) indicates that a classifier that performs at the level of random chance. Points along the line $y = 1 - x$ perform more (above, green line) or less  (below, red line) accurately with equal changes in the rate of true and false positives. Grey lines indicate the value of Youden's J statistic for that point. We illustrate three scenarios, where responses are *(a)* an overall average across the population and for each perceiver (where darker (less transparent) colors indicate a greater density of points at a coordinate); *(b)* averages stratified by each education level; and averages stratified *(c)* by the average distance of the pair to the perceiver.],
    [ROC-space plot example.]
  ),
  kind: image,
) <roc_ex>
