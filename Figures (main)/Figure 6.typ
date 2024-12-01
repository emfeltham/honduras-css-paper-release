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
        "Figure 6.svg",
    ),
    caption: flex-caption(
	[Association of accuracy rates within individual respondents. (a) We find that the individual-level accuracy rates (TPR and FPR) are strongly related, such that increases in a tendency to identify true positives is associated with an increase in the tendency to identify false positives. The line represents the estimated marginal effects for model of the individual accuracy rates, estimated from an OLS regression of an individual's TPR on their FPR, further adjusting for age, gender, network degree, and the relationship (free-time and personal-private). Scatter points represent the model-predicted individual accuracy rates for each subject, marginalized over relationship, so that an individual point represents the predicted accuracy values for an individual (FPR, TPR), and points are colored by overall accuracy ($J$). The model fit and estimated predictions concern connections solely among non-kin ties. Bootstrapped 95% confidence intervals are shown (orange band) and account for error at both stages of estimation. Additionally, $J$ is represented graphically for its extrema ($J_('max')$, $J_('min')$), and the point at which individuals are unbiased ($'PPB' = 1$). (b) Social network accuracy is associated with the acquisition of novel non-social information. Estimation is performed with a logistic model that regresses knowledge of three exogenously introduced riddles related to zinc usage, umbilical cord care, and prenatal care on respondent-level social network accuracy. Models adjust for the specific riddle, demographic characteristics (age, gender, education), and network degree. Bands represent bootstrapped 95% confidence intervals that account for uncertainty at both stages of estimation (see Supplementary Fig. 8; Supplementary Tables 7 and 8 for details). ],
	[Association of accuracy rates within individual respondents]
),
) <Figure-6>
