# actg5202_aipw_analysis
Code and Suppemental information for Better Analysis of RCTs (publicaation pending)

## Supplemental Information from Analysis

### Supplemental Methods

Sample Size Analysis:
Evaluation of sample size was calculated by sequentially increasing (or decreasing) the sample size by one individual weighted over the entire sample as described by Rudolph et al$^1$. First, we evaluated the number of similar participants needed for the ITT estimate to have an equivalent SE as the AIPW estimate. Second, we evaluated how many fewer participants would be needed for the AIPW analysis to generate an estimate with a SE similar to the main ITT analysis without any sample size changes.

First, we create weights that can add 1/Nth of a person to each sum or squared errors. This assures that each person's squared error gets equal weight. Effectively, each person gets upweighted a little bit.

$$
\text{ weight }=w=1+\frac{i}{N_{a b c / 3 t c}}
$$

Next, we calculate the standard deviation for each treatment proportion using the weights and increasing total $\mathrm{N}$ in the group as well. This is done for each treatment group. The benefit of doing it this way is that we can weight the data we have and thereby see how many more (or fewer) people we would need with this same data structure to get similar results.

$$
\begin{aligned}
& C D 4 S D_{A B C / 3 T C}=\sqrt{\frac{\sum w *\left(C D 4_i-\overline{C D 4)^2}\right.}{\left(N_{A B C / 3 T C}+i\right)}} \\
& C D 4 S D_{T D F / F T C}=\sqrt{\frac{\sum w *\left(C D 4_i-\overline{C D 4}\right)^2}{\left(N_{T D F / F T C}+i\right)}}
\end{aligned}
$$

Standard errors are calculated and combined to obtain the standard error of the difference for specified sample size.

$$
\begin{gathered}
S E_{A B C / 3 T C}=\frac{s d_{A B C / 3 T C}}{\sqrt{N_{A B C / 3 T C}+i}} \\
S E_{T D F / F T C}=\frac{s d_{T D F / F T C}}{\sqrt{N_{T D F / F T C}+i}} \\
S E_{d i f f}=\sqrt{S E_{T D F / F T C}^2+S E_{A B C / 3 T C}^2}
\end{gathered}
$$

Calculating a closed form of the variance for the AIPW estimator is based on the influence curve

$$
\begin{gathered}
w_{A I P W}=\frac{i}{N} \\
\widehat{A I P} W_{d e v}=\left(\widehat{A I P} W_{i, A B C / 3 T C}-\widehat{A I P} W_{i, T D F / F T C}\right)-\widehat{A I P} W_{A T E}
\end{gathered}
$$

Where $\widehat{A I P} W_{d e v}$ is the analog to the sum of squared errors. Variance can be calculated as:

$$
\widehat{\text{Va}} r_{A I P W}=\frac{1}{\left[N *\left(1-w_{A I P W}\right)\right]^2} * \sum_{i=1}^N\left(1-w_{A I P W}\right) *\left(\widehat{A I P} W_{d e v}\right)^2
$$

Where $\left(\widehat{A I P} W_{\text {dev }}\right)^2$ is the analog to the sum of squared errors, which is weighted here to remove successive individuals from the sample in the same way they are added to above.
In both situations a simulation is performed recursively until the SE reaches a cutoff, and the requisite sample sizes are determined the number of additional individuals added or removed.