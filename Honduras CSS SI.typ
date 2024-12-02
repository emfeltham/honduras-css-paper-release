// supplementary_information.typ

#let tblsz = 10pt

#import "Honduras CSS SI template.typ": *
#show: project.with()

#let fgdir = "figures/"
#let tdir = "tables/"

#let sfgdir = "figures_si/"
#let stdir = "tables_si/"

// outlines

#outline(
  title: [Table of Contents],
  indent: auto
)

#outline(
  title: [List of Supplementary Figures],
  target: figure.where(kind: image),
)

#outline(
  title: [List of Supplementary Tables],
  target: figure.where(kind: table),
)

#pagebreak()

= Traditional data collection on network cognition <trad>

Almost all the existing work on perceiving social networks uses the complete survey _roster method_ (as depicted in Supplementary Fig. #ref(<roster>, supplement:none)), where a response is elicited from each individual in the social network for every possible tie in that network. This strategy has limited data collection to small-scale networks, as networks of even moderate size networks would require a survey with thousands of questions, even for symmetric ties, far beyond the capacity of any survey participants. In such an approach, the whole population of possible ties could be elicited: everyone would be asked about _every_ possible relationship in the group, in succession. The number of relationships queried scales non-linearly with the number of individuals in the network. For example, in a network of $10$ people, an individual would be asked about $(10 times 9) / 2 = 45$ relationships (for symmetric relationships). This number increases dramatically to $(100 times 99) / 2 = 4,950$ for a network of $100$ individuals.

Egocentric studies @small_personal_2021 ask about surrounding relationships but, they elicit only a subset of one's ties, and do not collect data on the underlying truth of those ties, nor survey the alters themselves. To be clear, cognized networks are not easily elicited through alternative means, _e.g._, through tracking mobility data or other "objective" measures to track large networks of individuals @blumenstock_airtime_2016, since they require information from the minds of the social network members.

Only a few studies attempt to sample elements of the cognitive social structure to allow inferences about cognition of one's social network in more generalizable settings. One study develops a sampling strategy to examine whether an individual attribute, "need for closure", is associated with accuracy in network cognition, with 53 students enrolled in a 1-year MBA program at a "West Coast university" @flynn_you_2010. They sample nodes rather than dyads, randomly picking five classmates for each participant, and then asked them to characterize the advice behaviors among the five individuals using a form in the style of an adjacency-matrix. Another study develops a method to collect data on beliefs from larger networks, where the underlying sociocentric network is unknown @lee_mapping_2018. They do so in a network of 393 Alaskan Natives, with interviews from 170 respondents. In this method, randomly chosen individuals are asked to place randomly chosen photos of other network members into groups of individuals who are said to be close to one another. From this classification procedure, ties are inferred by the researcher, rather than elicited directly from the respondents. Other work applies a "visual network scale" to examine the behavioral impacts of believed versus actual brokerage in a network of workers at a consultancy firm, and capture beliefs of a particular network statistic (brokerage) @iorio_brokers_2022. This approach is implemented specifically to circumvent the difficulties of eliciting many responses in a larger network population. The visual network scale @brass_imaginary_2014 makes use of visual depictions of networks, where respondents judge the network position of another individual through a scale defined by network diagrams that show a node with varying features (_e.g._, in a denser or sparser network).

= Supplementary methods <suppmethods>

== The $J$ statistic

Youden's $J$ statistic @peirce_numerical_1884 @youden_index_1950 is a uni-dimensional index of the accuracy of a binary classifier. $J$ is frequently employed in the assessment of diagnostic tests in epidemiological research. It combines the two dimensions of accuracy, sensitivity and specificity, to a single measure of accuracy, and is defined as

$ J = "sensitivity" + "specificity" - 1 ⇔ "TPR" - "FPR" $ <eqn_youden>

$J$ is interpreted as the _informedness_ of a classification. Geometrically, $J$ is the vertical distance from the point to the line $y = x$. The grey lines in Supplementary Fig. #ref(<roc_ex>, supplement:none) display the absolute value of the  $J$ for each point. To the extent that $J$ is positive, we measure the classifier's higher tendency to assert true positives over false positives. $J$  ranges on $[-1, 1]$, where zero indicates a classifier that performs at the level of chance. $J < 0$ worse-than-chance performance, classifying incorrectly in every instance when $J=-1$. At the other extreme, $J=1$ is perfect performance for a classifier that asserts neither false positives nor false negatives. Fig. 2 visually summarizes the $J$ statistic and its relationship to the ROC framework.

In this context, the accuracy of binary classifiers are often expressed within a receiver operating characteristic (ROC) framework @porta_receiver_2016 @koepsell_measurement_2004, where accuracy is represented as the true positive rate vs. the false positive rate. Points in this space represent a binary classifier measured on these two dimensions. In other words, each point in the space defined by the two rates essentially represents a confusion matrix, where the classifier (_e.g._, a test, a logistic regression model, a survey respondent, or a group of survey respondents) has classified a series of observations into ones or zeros (truly or falsely) by threshold.

ROC curves are used to study shifts in accuracy as the latent threshold of a classifier, which assigns a latent score (_e.g._, from 0 to 1), changes. Movement along an ROC curve Specifically, they illuminate the performance of a classifier as its threshold for converting a latent score to a one or a zero output; _e.g._, a score of 0.3 may be taken as the threshold above which a result implies a 1, in contrast to the usual threshold of 0.5.

Binary regression models (_e.g._, logistic or probit models) estimate a latent score from binary data, which may be further translated into the prediction of a 1 or 0 through the application of a threshold. Here, an ROC curve represents the change in the performance of the model as the cutoff is shifted across the range 0 to 1. For a given test and set of observations, movement along the ROC curve represents a change in the mix of true and false positive rates as a consequence of shifting the threshold @koepsell_measurement_2004. The overall performance of the classifier ($J$) may change as the TPR and FPR changes. While the overall performance of a test or model may be calculated as the area under the ROC curve (AUC) @steyerberg_assessing_2010 (and equivalent to the $c$ statistic in a binary classification setting), the optimal threshold for a particular model or test is maximized at the largest $J$ statistic. In our setting, a point usually represents the average accuracy for a subset of the response data. Supplementary Fig. #ref(<roc_ex>, supplement:none) illustrates this approach, with estimates for the _free time_ relation.

== Accuracy, performance, and bias

In Fig. 2, we illustrate three distinct types of change in accuracy, over values changing values of an attribute. While $J$ measures the performance of a classifier, and corresponds to vertical distance in ROC-space, it may be more natural to consider _pure_ changes in performance that do not correspond to a change in _bias_, the tendency to make true positives vs. false positives.  

Movement parallel to line such that $y = 1-x$ indicates an improvement (toward the top-left corner) or decrement (toward the bottom-right corner) in accuracy, such that $J = "TPR" – "FPR"$ changes, with an equal increase for both rates. By contrast, movement parallel to the line ($y = x$) represents a change purely in bias. In this case, there is a tradeoff in the tendency to commit one or the other type of error shifts, but with no change in overall performance ($J$ is constant). 

The first two cases in Fig. 2 correspond to values of the slope ($-1$ and $1$), where changes in one rate are met with equal changes in the magnitude of the other. In the first ("Pure performance change"), the change in an attribute leads to a pure change in performance, where the J decreases from level 1 to level 2 with an equal change in the rate of true positives to and false positives ($"slope" = –1$). In the second ("Pure error tradeoff"), we see no change in overall performance, but a sizable shift in types of errors committed across the changes in the attribute ($"slope" = 1$). Note that, along this line, the value of an attribute is associated with a more liberal or more conservative tendency to render judgements of the existence of a tie. In the third ("Impure change"), we see a change in both bias and in overall performance. Most of the observed characteristics we study fall into this third category.

While movement along $y=x$ indicates pure changes in performance, orthogonal movement ($y=1-x$) indicates change in bias. In Fig. 7, we conduct a change of basis on ROC-space to summarize the change in accuracy. We rotate $45 degree$ clockwise, which corresponds to

$ ("TPR", "FPR") -> (("TPR" + "FPR")/sqrt(2), ("TPR" - "FPR")/sqrt(2)) $

Then, we scale the axes by $sqrt(2)$, to facilitate interpretation of the transformed coordinates.

The transformed axes represent performance ($J$) and bias. We define the _positive predictive bias_ (PPB) of a classifier

$ "PPB" = "TPR" + "FPR" ⇔ "TPR" - "TNR" + 1 $

which corresponds to the transformed $x$-axis. We also see that the transformed $y$-axis is our uni-dimensional performance metric, $J$. This operation is shown in Fig. 7a.

PPB may be interpreted as the bias toward positive predictions by a classifier. When represented as the sum $"TPR" + "FPR"$, it is clear that it is the classifier's tendency to nominate ties regardless of whether they are true or false. $"PPB" in [0, 2]$, such that a value of 1 indicates an unbiased classifier.

After this transformation, we decompose the vector formed by the maximum change in each dimension (light-blue and orange lines). We examine the maximum change over the observed range of values for a characteristic since several (_e.g._, age, cognizer-to-tie distance) express a curvilinear relationship between TPR and FPR. This is is the vector decomposition of the secant line that passes through the maximum value of $J$ and the furthest PPB value from that performance maximum. Supplementary Fig. 11 illustrates this breakdown, where changes in accuracy over the change in the values of attributes are represented in terms of their change along these transformed dimensions of accuracy: $J$ and PPB.

In Fig. 7b, we consider the magnitudes of each component, $Δ J$ and $Δ"PPB"$, and the relative change in each, $(Δ J) / (Δ "PPB")$. Values above 1 indicate that the preponderance of change associated with an attribute are in _bona fide_ performance.

= Supplementary results <suppresults>

We present further results related to the underlying survey design. In Supplementary #ref(<recognition_table>), we show the percentage of individuals recognized by survey respondents. As described in Methods, we present each individual in each candidate pair prior to conducting the network knowledge survey. We find that a very high percentage of individuals are recognized by our survey respondents. Moreover, Supplementary Fig. #ref(<figure_recognition_distance>, supplement: none) shows that levels of recognition are high across the range of distances between the judged ties and the survey respondents. The effect of distance on recognition is estimated with a logistic regression with categorically defined distance, and adjustment for relationship type (_free time_ or _personal private_).

Separately, we also show the total counts of true and false ties shown to survey respondents (those that do and do not exist in the reference network), stratified by whether they are also truly among kin (Supplementary #ref(<css_tie_counts>)) and the counts of kin ties in the underlying reference networks (Supplementary #ref(<con_tie_counts>)). Together, these tables indicate that there are substantial numbers of kin relationships that do not represent connections in the _free time_ and _personal private_ networks. Moreover, subjects evaluate substantial numbers of ties that represent multiplex and kin-only ties.

In Supplementary Fig. #ref(<figure_network_distances>, supplement: none), we display the distributions of geodesic distances in both the underlying reference networks for _free time_ and _personal private_ and for the elicited pairs. For the latter, we show both the distributions of the distance between the cognizer and the pair, and between the individuals in the pair when there is no connection in the underlying network (_i.e._, when the distance is 1). While the sampling design (see Methods for details) stratifies on distance in the _union_ network (where a tie exists if at least one of _kin_, _free time_, and _personal private_) with a maximum of 4 geodesic steps away from the survey respondent, we nonetheless cover a much larger range of geodesic distances. Specifically, in Supplementary Fig. #ref(<figure_network_distances>, supplement: none)c. In fact, the average distance for _free time_ is 5.86 and 5.50 for _personal private_, and 5.67 over both relationships. Further, we see that 12.3% and 8.0% of ties displayed at 8 or more steps away from the survey respondents (Supplementary Fig. #ref(<figure_network_distances_cdf>, supplement: none)).

Additionally, we present the coefficient estimates for the primary statistical models of the TPR and FPR in Supplementary Fig. #ref(<mainmodel>, supplement: none) and those for the model with genetic relatedness (in a reduced sample) in Supplementary Table #ref(<kinship_models>, supplement: none). Additonal village-level accuracy distributions are presented in Supplementary Fig. #ref(<village_dist>, supplement: none). Supplementary Table #ref(<villagemodel>, supplement: none) presents the results of a model with two additional village characteristics: the geographic isolation of a village, and the village population.

Furthermore, we examined the effect of whether the individuals in an elicited pair live together in the same building. As displayed in Supplementary Fig. #ref(<figure_same_building_a>, supplement: none), we find that that accuracy decreases substantially for judgements of individuals who live in the same building.

We also conduct additional analyses that explore the association between accuracy and village size in Supplementary Fig. #ref(<figure_dunbar>, supplement: none) and Supplementary Table #ref(<table_dunbar>, supplement: none). Specifically, we estimate models that examine whether individuals are more accurate in villages that fall above or below Dunbar's Number @dunbar_neocortex_1992 which finds that (typical) humans are cognitively capable of maintaining around 150 stable connections. We find both that the true positive rate decreases when villages are above the threshold and the true negative rate increases when villages are above villages over Dunbar's number. However these effects become non-significant when we control for the distance between the survey respondent and the judged pair.

== Tie robustness

Given concerns in the literature regarding the ability of individuals to faithfully report their own ties @bernard_informant_1977 @bernard_informant_1979, we conduct two further analyses that exploit the fact that the broader project involved the collection of network data at multiple time points to compare model results under different definitions of a tie. Specifically, we estimate models that count ties as true if they are (1) nominated _only_ in the current wave of data collection, and (2) if they are nominated in any previous wave of the network survey. Note that the primary analyses define ties as true if they are nominated in the current wave of data collection, regardless of their status at previous waves.

In Supplementary Tables #ref(<contrast_tie_resp_union>, supplement: none), #ref(<contrast_tie_union>, supplement: none), and #ref(<model_union>, supplement: none) we compare model estimates over the data collection waves. We define a tie as true if it is nominated by at least one alter, in any of the waves, and false otherwise. Observe that the number of true ties increases under this definition. 

Additionally, in Supplementary Tables #ref(<contrast_tie_resp_intersection>, supplement: none), #ref(<contrast_tie_intersection>, supplement: none), and #ref(<model_intersect>, supplement: none), we compare the union-rule true tie definition for wave 4 (the usual approach) to requiring that the tie is nominated in both wave 3 and 4; in other words, a tie is counted as true only if it is nominated by at least one alter in both waves. Also note that where the nodes (members of the tie) only exist in wave 4, we use the wave 4 value to define the tie.

Here we also do not estimate FPR models (and hence do not estimate _J_) for this specification, since it does not seem reasonable to use ties that exist in only one wave as failing to be present in a meaningful sense. We see that the estimates are broadly consistent, though significance drops in a number of cases. However, we drop about 73,329 ties under this definition.

We generally observe similar estimates across the different definitions with significance patterns that do not change drastically (in comparison to the estimates in Supplementary #ref(<mainmodel>)).

== Restricted distance

Given that the networks we analyze are orders of magnitude larger than previous attempts to collect data on network beliefs, we also re-estimate the main models we present (Equation 1 in Methods) on a subset of the data, where the distance between the cognizer and a pair comparable to existing analyses of small networks in the literature. Specifically, we restrict to three or fewer geodesic steps.

We examine the "friendship" and "advice" networks from Kilduff and Krackhardt (1994) @kilduff_bringing_1994. Specifically, we extract the undirected, symmetric sociocentric networks, and calculate the maximum geodesic distance between nodes to be 3 steps in each network, with average pairwise distances of 1.58 (advice) and 1.77 (friendship) in the two networks. Consequently, we analyze the subset of our network where $D_(k[i j]r g) lt.eq 3$. These models are specified in the same way, except that we do not include the distance between alters ($D_([i j]r g)$) and interaction terms for distance are not needed, since all nodes are connected in these models.

We estimate _mutatis mutandis_ specifications relative to Equation 1. We only remove the interaction on distance, since all distances are defined in the restricted data. Consequently, we replace the interactions with the distances themselves: _e.g._, $bb(1)_([D_(r[i j]k g) < inf]) β_(l)^b + β_(l+1)^b D_(r[i j]k g)$ is reduced to $β_(l) D_(r[i j]k g)$, here $l$ denotes the position of the covariate in the model.

These additional results are presented in Supplementary Table #ref(<main_model_limited_dist_3_regtable>, supplement: none). Further, we present contrasts based on the marginal effect estimates for each accuracy metric in Supplementary Tables #ref(<contrast_tie_resp_bs_lt_3>, supplement: none) and #ref(<contrast_tie_bs_lt_3>, supplement: none) that match the results in Extended Data Tables 2 and 3.

In general, the estimates are similar across all considered effects, in both magnitude and significance. In a few cases, contrasts become non-significant including for some of the age and education level differences. Notably, this similarity holds for distances. The cognizer-to-tie distance is associated with a decrease in accuracy from the case where a survey respondent is 1 step away from the pair to where the respondent is 3 steps away, and the within-tie distance is associated with an increase in the true negative rate over nodes that are 1 degree apart vs. 6 degrees apart in the network.

== Software and code

Mixed effects models were estimated (and bootstrapped) with "MixedModels.jl" @bates_juliastatsmixedmodelsjl_2020. Other linear models were estimated with "GLM.jl" @noauthor_juliastatsglmjl_2023. Marginal effects and contrasts were calculated with "Effects.jl" @noauthor_beacon-biosignalseffectsjl_2023, networks were handled with "Graphs.jl" @fairbanks_juliagraphsgraphsjl_2021 and "MetaGraphs.jl" @bromberger_juliagraphsmetagraphsjl_2023. Additional code is available in the replication package @feltham_emfelthamhondurascssjl_2024.

= Supplementary figures

#text(size: 10pt)[

#pagebreak()
#include sfgdir + "SI Figure distribution distances.typ"

#pagebreak()
#include sfgdir + "SI Figure diagram ROC.typ"

#pagebreak()
#include(sfgdir + "SI Figure distribution responses.typ")

#pagebreak()
#include(sfgdir + "SI Figure results degree (mean) tie interaction.typ")

#pagebreak()
#include(sfgdir + "SI Figure wealth interaction.typ")

#pagebreak()
#include sfgdir + "SI Figure results dunbar.typ"

#pagebreak()
#include(sfgdir + "SI Figure results coffee.typ")

#pagebreak()
#include sfgdir + "SI Figure riddle estimates.typ"

#pagebreak()
#include sfgdir + "SI Figure diagram decomposition.typ"

#pagebreak()
#include(sfgdir + "SI Figure roster.typ")

#pagebreak()
#include(sfgdir + "SI Figure interface.typ")

#pagebreak()
#include sfgdir + "SI Figure distances cdf.typ"

#pagebreak()
#include(sfgdir + "SI Figure distribution relatedness.typ")

#pagebreak()
#include sfgdir + "SI Figure results relatedness KING-homo.typ"

#pagebreak()
#include sfgdir + "SI Figure distribution relatedness reported kin tie.typ"

#pagebreak()
#include sfgdir + "SI Figure results additional respondent.typ"

#pagebreak()
#include sfgdir + "SI Figure distribution village.typ"

#pagebreak()
#include sfgdir + "SI Figure result same building.typ"

#pagebreak()
#include sfgdir + "SI Figure alter recognition.typ"

= Supplementary tables

#pagebreak()
#include(stdir + "SI Table kin multiplexity counts.typ")

#pagebreak()
#include(stdir + "SI Table contrasts relatedness.typ")

#pagebreak()
#include(stdir + "SI Table model main.typ")

#pagebreak()
#include(stdir + "SI Table TPR-FPR model.typ")

#pagebreak()
#include(stdir + "SI Table riddle descriptions.typ")

#pagebreak()
#include(stdir + "SI Table contrasts riddle.typ")

#pagebreak()
#include(stdir + "SI Table model riddle.typ")

#pagebreak()
#include(stdir + "SI Table contrasts riddle differences.typ")

#pagebreak()
#include(stdir + "SI Table alter recognition.typ")

#pagebreak()
#include(stdir + "SI Table sampling algorithm.typ")

#pagebreak()
#include(stdir + "SI Table model relatedness.typ")

#pagebreak()
#include(stdir + "SI Table contrasts union respondent.typ")

#pagebreak()
#include(stdir + "SI Table contrasts union tie.typ")

#pagebreak()
#include(stdir + "SI Table model main union.typ")

#pagebreak()
#include(stdir + "SI Table contrasts intersect respondent.typ")

#pagebreak()
#include(stdir + "SI Table contrasts intersect tie.typ")

#pagebreak()
#include(stdir + "SI Table model main intersect.typ")

#pagebreak()
#include(stdir + "SI Table model village.typ")

#pagebreak()
#include(stdir + "SI Table village size.typ")

#pagebreak()
#include(stdir + "SI Table sampled multiplexity counts.typ")

#pagebreak()
#include stdir + "SI Table model main distance <= 3.typ"

#pagebreak()
#include(stdir + "SI Table contrasts respondent distance <= 3.typ")

#pagebreak()
#include(stdir + "SI Table contrasts tie distance <= 3.typ")
]

#pagebreak()
#bibliography(
  "references.bib", style: "nature.csl", title: "Supplementary References"
)
