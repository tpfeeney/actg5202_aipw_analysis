# actg5202_aipw_analysis
Code and Suppemental information for Better Analysis of RCTs (publicaation pending)

## Supplemental Information from Analysis

### Supplemental Table 1. Baseline characteristics of ACTG 5202 re-analysis dataset
|                                   | ABC/3TC              | TDF/FTC              |
| --------------------------------- | -------------------- | -------------------- |
| n                                 |     398              |     399              |
| Sex (Female) (%)                  |     67 (16.8)        |     54 ( 13.5)       |
| Age Group (%)                     |                      |                      |
|      1-25                         |     29 ( 7.3)        |     34 (  8.5)       |
|      26-49                        |    315 (79.1)        |    299 ( 74.9)       |
|      ≥50                          |     54 (13.6)        |     66 ( 16.5)       |
| Baseline RNA log10 (median [IQR]) |    4.98 [4.73, 5.55] |    4.99 [4.72, 5.56] |
| RNA level Category (%)            |                      |                      |
|      1,000-9,999                  |      4 ( 1.0)        |      3 (  0.8)       |
|      10,000-49,999                |     82 (20.6)        |     90 ( 22.6)       |
|      50,000-99,999                |    117 (29.4)        |    109 ( 27.3)       |
|      100,000-249,999              |     77 (19.3)        |     73 ( 18.3)       |
|      250,000-499,999              |     36 ( 9.0)        |     38 (  9.5)       |
|      500,000-999,999              |     41 (10.3)        |     47 ( 11.8)       |
|      ≥1,000,000                   |     41 (10.3)        |     39 (  9.8)       |
| Baseline CD4 count (mean (SD))    |  180.57 (172.83)     |   182.88 (153.19)    |
| CD4 Category (%)                  |                      |                      |
|      0-49                         |    123 (30.9)        |    112 ( 28.1)       |
|      50-99                        |     42 (10.6)        |     48 ( 12.1)       |
|      100-199                      |     80 (20.1)        |     68 ( 17.1)       |
|      200-349                      |     96 (24.1)        |    114 ( 28.6)       |
|      350-499                      |     37 ( 9.3)        |     40 ( 10.1)       |
|      ≥500                         |     20 ( 5.0)        |     16 (  4.0)       |
| Hx of Hepatitis B (%)             |                      |                      |
|      Yes                          |     34 ( 8.6)        |     28 (  7.1)       |
|      No                           |    361 (91.4)        |    365 ( 92.6)       |
| Indeterminate                     |      0 ( 0.0)        |      1 (  0.3)       |
| Genotype (%)                      |                      |                      |
|      Recent infection, genotyped  |     53 (13.3)        |     35 (  8.8)       |
|      Not recent, genotyped        |    122 (30.7)        |    131 ( 32.8)       |
|      Not recent, Not Genotyped    |    223 (56.0)        |    233 ( 58.4)       |
| History of Aids (No) (%)          |    296 (74.4)        |    312 ( 78.2)       |




### Supplemental Table 2
| **Viral Suppression at 48 wks, ABC/3TC vs TDF/FTC  RD (95% CI)** | **SE** | **CID** |
| ---------------------------------------------------------------- | ------ | ------- |
| \-0.025 (-0.065, 0.016)                                          | 0.0205 | 0.081   |
| \-0.020 (-0.019, 0.061)                                          | 0.0203 | 0.080   |

ABC/3TC=Abacavir-Lamivudine. TDF/FTC=Tenofovir DF-Emtricitabine.  ITT=Intent-to-treat. AIPW= augmented inverse probability weighting. RD=risk difference. SE=standard error. CID=confidence interval difference=upper confidence limit-lower confidence limit. Adjustment variables=categorized age, sex, baseline log10 RNA in copies/mL,  and baseline CD4 counts/mm^3. AIPW confidence intervals from bootstrapped standard errors with 10,000 samples.



### Supplemental Explanation:

$$
A I P W=n^{-1} \sum_{i=1}^n \frac{X_i Y_i}{\pi\left(X_i ; \hat{\alpha}\right)}-\left(\frac{X_i}{\pi\left(X_i ; \hat{\alpha}\right)}-1\right) m\left(X_i ; \hat{\beta}\right)
$$

Is the AIPW estimator, where $X_i$=exposure for each person $i$, $Y_i$= the outcome of interest for person $i$, n=total number of participants

Step 1: Estimate the probability of treatment given covariates for each person, $\pi\left(X_i ; \hat{\alpha}\right)$.
However, in our case we are evaluating an RCT, so the predicted probability of treatment (in this case of receiving 'ABC/3TC') for each person is the same and empirically estimate to be $0.486$, slightly off from the expectation of $0.5$.

Step 2: Estimate the outcome using maximum likelihood, $m\left(X_i, \boldsymbol{W}_i ; \hat{\beta}\right)$. Here we use logistic regression to estimate expected value of $Y$ conditional on the treatment, $X_i$, and on a vector of covariates, $\boldsymbol{W}_i$. Then, for each person compute the predicted probability of outcome value setting exposure $(X=0)$ and $(X=1)$. This give us a predicted probability of outcome for each person had they been unexposed (Gformula $0_0$ ) and had they been exposed (Gformula $\left.\mathrm{a}_1\right)$. Shown are the values for the first 5 persons in the data.

$$
\begin{array}{lll}
\text{ID}& \text {  Gformula0 } & \text { GFormula1 } \\
1 & 0.9136610 & 0.8847934 \\
2 & 0.9531515 & 0.9365710 \\
3 & 0.9698576 & 0.9589350 \\
4 & 0.8822341 & 0.8446456 \\
5 & 0.9418696 & 0.9216245
\end{array}
$$

Step 3: Use the propensity score and G-formula $a_0$ and G-formula $a_1$ to calculate the AIPW for every individual had they been exposed $\left(\right.$ AIPW $\left._1\right)$ and had they been unexposed (AIPW ${ }^0$ ).

Step 3a: AIPW ${ }_1$ for individuals, $i$, who were actually exposed this is calculated as $\frac{X_i Y_i}{\pi\left(X_i ; \hat{\alpha}\right)}-\left(\frac{x_i}{\pi\left(X_i ; \hat{\alpha}\right)}-1\right) m\left(X_i, W_i ; \hat{\beta}\right)$, otherwise if individual, $i$, was unexposed it is their counterfactual value which is just the G-formula result (G-formula ${ }_1$ ).

Step 3b: AIPW ${ }_0$ for individuals, $i$, who were actually unexposed this is calculated as $\frac{X_i Y_i}{1-\pi\left(X_i ; \hat{\alpha}\right)}-\left(\frac{X_i}{1-\pi\left(X_i ; \widehat{\alpha}\right)}-1\right) m\left(X_i, W_i ; \hat{\beta}\right)$, otherwise if individual, $i$, was exposed it is their counterfactual value which is just the G-formula result (G-formula $)$.

$$
\begin{array}{cllll}
\text { ID } & \text { outcome } & \text { treat/exp } & \text { aipw0 } & \text { aipw1 } \\
1 & 1 & 1 & 0.932 & 1.10 \\
2 & 1 & 0 & 1.06 & 0.909 \\
1 & 0 & 1 & 0.932 & -0.960 \\
2 & 0 & 0 & -0.883 & 0.909
\end{array}
$$

Step 4: AIPW $=$ mean( $\left(AIPW_1\right.$ )-mean(AIPW_0$ )

Step 5: Calculate AIPW= mean($AIPW_1$ )-mean(AIPW_0), 1000 or more times via bootstrap and calculate the standard error (SE) by estimating the standard deviation of the bootstrapped samples. Use this SE to calculate \% confidence intervals: AIPW $\pm z\cdot sqrt{SE}$

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
\widehat{\operatorname{Va}} r_{A I P W}=\frac{1}{\left[N *\left(1-w_{A I P W}\right)\right]^2} * \sum_{i=1}^N\left(1-w_{A I P W}\right) *\left(\widehat{A I P} W_{d e v}\right)^2
$$

Where $\left(\widehat{A I P} W_{\text {dev }}\right)^2$ is the analog to the sum of squared errors, which is weighted here to remove successive individuals from the sample in the same way they are added to above.
In both situations a simulation is performed recursively until the SE reaches a cutoff, and the requisite sample sizes are determined the number of additional individuals added or removed.