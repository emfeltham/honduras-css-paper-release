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
        "ED Figure results identity.svg",
    ),
    caption: flex-caption(
	[Tie social identity determinants of respondent accuracy. We find that characteristics related to the social identity of a pair of individuals ($i$ and $j$) affects how well that tie is conceived of by individuals $k$. (a-d) LHS, marginal effects on accuracy in ROC-space. Grey shading represents the 95% bootstrapped confidence ellipse of the predictions from the two models. RHS, marginal effect of each individual accuracy measure: the true positive and false positive rates and the summary measure, $J$. Intervals represent 95% confidence levels, calculated via normal approximation for the two rates, and bootstrapped for $J$. *(a)* Religion combination of tie members. *(b)* Indigenous status of the pair. Parameters are fit from separate models of each rate, conditional on tie verity in the reference network. *(c)* Absolute difference in wealth between the tie members. *(d)* Average wealth of the tie members. *(e)* Interaction between the average wealth of a pair and the cognizer's wealth on the (LHS) TPR and (RHS) FPR. *(f)* Interaction between the average wealth of a pair and the cognizer's wealth on the summary measure, $J$. See Methods for details of model specification.],
	[Tie social identity determinants of respondent accuracy]
),
) <ED-Figure-results-identity>
