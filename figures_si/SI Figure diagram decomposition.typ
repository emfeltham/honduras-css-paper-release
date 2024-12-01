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
    image(
        "SI Figure diagram decomposition.svg",
    ),
    caption: flex-caption(
	[Decomposition of accuracy. We represent the change in performance and the tradeoff in errors to summarize the relationship between the attributes of the cognizers (_e.g._, the network degree of $k$), and the presented pairs (_e.g._, the average age of $i$ and $j$), we examine the extent to which change across the range of values of that attribute represents a genuine change in performance or simply a tradeoff between the two error rates. Specifically, conduct a change of basis of the ROC-space plot for each attribute, by rotating and rescaling, such that the $y$-axis represents performance ($J$) and the $x$-axis is the positive predictive bias (PPB). We then examine the relationship between the maximum change in each dimension. For *(a)* linear relationships, our quantities of interest correspond to the maximum change along each dimension, and for *(b)* curvilinear relationships this corresponds to the secant line passing through the point greatest difference along the $x$-axis from the $x$-value corresponding to the maximum performance value and the point of maximum performance itself.],
	[Decomposition of accuracy]
),
) <figure_diagram_si>
