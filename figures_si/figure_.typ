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
        "figure_.svg",
    ),
    caption: flex-caption(
[Decomposition of accuracy rates into performance and tradeoff. To summarize the relationship between the attributes of the cognizers (e.g., the network degree of $$), and the presented pairs (e.g., the average age of $i$ and $j$) as studied in Figs. 2-4 and the error rates, we examine the extent to which change across the range of values of that attribute represents a _bona fide_ change in performance or simply a tradeoff between the two error rates. Specifically, conduct a change of basis of the ROC-space plot for each attribute, by rotating the points 45 degrees clockwise, such that the y-axis represents pure change in performance and the x-axis denotes a pure tradeoff in error types (without any change in overall performance). We then examine the relationship between the maximum change in each dimension, corresponding to the vector decomposition of the secant line that passes through the maximum performance value and the furthest tradeoff value from that corresponding to the performance maximum. For (a) linear relationships, our quantities of interest correspond to the maximum change along each dimension, and for curvilinear relationships (b) this corresponds to the secant line passing through the point greatest difference along the x-axis from the x-value corresponding to the maximum performance value and the point of maximum performance itself.],
[Decomposition of accuracy rates into performance and tradeoff]
),
    kind: "image-si",
    supplement: [Supplementary Figure],
) <figure_>
