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
        "ED Figure results cognizer.svg",
    ),
    caption: flex-caption(
	[Individual determinants of respondent accuracy. We observe that several key demographic characteristics are associated with an individual's ability to accurately predict the ties in their village network. In each panel, the left-hand image shows the marginal effect of the cognizer characteristic on accuracy in ROC-space (grey shading represents the 95% bootstrapped confidence ellipse of the predictions from the two models), and the right-hand image shows the marginal effect with respect to each individual accuracy measure: the true positive rate, false positive rate, and $J$. Intervals represent 95% confidence levels, calculated via normal approximation for the two rates, and bootstrapped for $J$. *(a)* Gender, *(b)* Age, *(c)* Education, *(d)* Wealth and *(e)* Network degree (here, effectively an average of the count of first-degree neighbors for the two relationships analyzed, personal-private or free-time). Supplementary Fig. 7 presents additional characteristics.],
	[Individual determinants of respondent accuracy]
),
) <ED-Figure-results-cognizer>
