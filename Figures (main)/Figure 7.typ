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
        "Figure 7.svg",
    ),
    caption: flex-caption(
	[Summary representation of examined characteristics. *(a)* To further summarize the change in accuracy, we change the basis of the ROC-space. The transformed axes represent performance ($J$) and bias (positive predictive bias). After this operation, we decompose the vector formed by the maximum change in each dimension (light-blue and orange lines). See Supplementary Information and Supplementary Fig. 9 for details. *(b)* Performance-tradeoff ratio and maximum change. The maximum change over the range of each studied attribute, whether an attribute of a survey respondent (cognizer) or of a tie is shown, as either the change in the J statistic, or in the positive predictive bias (LHS) and the ratio of the two (RHS). In the case of attributes of ties, an attribute may be either the mean values of the pair (mean), the absolute difference between the two (difference), or the unique combinations of qualitative values (combination). See Supplementary Information for more details.],
	[Summary representation of examined characteristics]
),
) <Figure-7>
