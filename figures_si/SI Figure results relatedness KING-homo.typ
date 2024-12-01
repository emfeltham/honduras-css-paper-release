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
        "SI Figure results relatedness KING-homo.svg",
    ),
    caption: flex-caption(
        [Effect of the genetic relatedness of the pair with respect to accuracy in network cognition, using an alternative algorithm to calculate genetic relatedness. In Figure 2, we use the _KING-robust_ algorithm to compute relatedness. Here, as a further robustness check, we instead use the _KING-homo_ algorithm, which does not account for population structure. The kinship coefficient ranges between 0 and 1 (see Methods for details). The results are broadly consistent with the results in Figure 2. Specifically, we see that individuals are most accurate at intermediate levels of relatedness. Here, note the range is shifted with respect to Figure 2. Consistent with the results for the self-reported first-degree kinship result, we find a strong relationship between accuracy and relatedness. Specifically, we observe that individuals are the most accurate for individuals who are somewhat unrelated to themselves, and approach chance performance both for judgements of individuals who are either very unrelated or very close kin. LHS: Grey bands that surround the effect estimates represent bootstrapped 95% confidence ellipses. RHS: Bands represent 95% confidence intervals (see Methods for details).],
        [Effect of the genetic relatedness of the pair, using KING-homo algorithm]
    ),
) <king_homo>
