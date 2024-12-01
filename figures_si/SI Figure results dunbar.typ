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
        "SI Figure results dunbar.svg",
    ),
    caption: flex-caption(
	[*(a)* Effect of village size above or below Dunbar's number with respect to accuracy in network cognition. LHS: Grey bands that surround the effect estimates represent bootstrapped 95% confidence ellipses. RHS: Bands represent 95% confidence intervals (see Methods for details). *(b)* Distribution of village sizes, with Dunbar's number (150) (yellow line) and average size (black line).],
	[Effect of village size above or below 150]
),
) <figure_dunbar>
