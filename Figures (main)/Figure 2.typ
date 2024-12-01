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
        "Figure 2.svg",
    ),
    caption: flex-caption(
	[Receiver operator characteristic space. Observations represent respondent-level or attribute-level means for the two dimensions of accuracy, the true positive rate (TPR), and the false positive rate (FPR); each point in the space may be thought of as a binary classifier. Classifiers perform better-than-chance (light-green region) or worse-than-chance (light-orange region), and those on the diagonal black line (where TPR = FPR) perform at the level of chance. We measure overall performance with J = TPR – FPR, which corresponds to the vertical distance to the line of chance, but which is negative for points below the line of chance (where FPR > TPR). Movement parallel to line, such that TPR = 1 – FPR, indicates an improvement (toward the top-left corner) or decrement (toward the bottom-right corner) in accuracy, such that J changes with an equal increase for both rates. Conversely, movement parallel to the line TPR = FPR represents a change in bias, where there is a tradeoff in the tendency to commit one or the other type of error, but with no change in overall performance (J is constant). We show three illustrative examples where a change in the value of an attribute (the move between a black dot and a red dot) leads to a change in accuracy. In the first (“Pure performance change”), the change in an attribute leads to a pure change in performance, where the J decreases from level 1 to level 2 with an equal change in the rate of true positives and false positives (slope = $–1$). In the second (“Pure error tradeoff”), we see no change in overall performance, but a sizable shift in types of errors committed across the range of the attribute (slope = 1). Note that, along this line, the value of an attribute is associated with a more liberal or more conservative tendency to render judgements of the existence of a tie. In the third (“Impure change”), we see a change in both bias and in overall performance. Most of the observed characteristics we study fall into this third category.],
	[Receiver operator characteristic space]
),
) <Figure-2>
