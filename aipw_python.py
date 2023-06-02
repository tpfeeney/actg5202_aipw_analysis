######################################################################################################################
# Improving the Precision of Intent-to-Treat Analyses of Clinical Trials Using Augmented Inverse Probability Weights
#
# Paul Zivich (2023/05/30)
######################################################################################################################

##############################################################
# Importing dependencies

import numpy as np
import pandas as pd
import patsy
from delicatessen import MEstimator
from delicatessen.estimating_equations import ee_regression

##############################################################
# Setting up data
d = pd.read_csv("sim_data_actg5202_aipw.csv")             # Loading .csv
d['trt'] = np.where(d['trt'] == 'ABC/3TC', 0, 1)          # Converting to numeric

# Extracting treatment and outcomes as arrays
a = np.asarray(d['trt'])
y = np.asarray(d['cd4'])

# Generating all design matrices from a model for AIPW
model = "trt*sex + trt*basecd4 + trt*C(agegrp) + trt*logrna0"
X = patsy.dmatrix(model, d)
da = d.copy()
da['trt'] = 1
X1 = patsy.dmatrix(model, da)
da = d.copy()
da['trt'] = 0
X0 = patsy.dmatrix(model, da)

# Setting up initial values for root-finding procedures
init_itt = [0., 440., 440.]
init_aipw = [0., 440., 440.] + [0.5, ] + [0., ]*X.shape[1]

# Empty storage for results
results = []


##############################################################
# Defining estimating functions

def psi_itt(theta):
    # Extracting parameters
    ate, mu1, mu0 = theta[0:]

    # Means conditional on assigned treatment
    ee_mean1 = (y - mu1)*a*subset
    ee_mean0 = (y - mu0)*(1-a)*subset

    # Transformation of means into the mean difference
    ee_ate = ((mu1 - mu0) - ate) * np.ones(y.shape[0])

    # Returning the stacked estimating functions
    return np.vstack((ee_ate,
                      ee_mean1,
                      ee_mean0))


def psi_aipw_itt(theta):
    # Extracting parameters
    ate, mu1, mu0 = theta[0:3]               # Parameters of interest
    pi_a = theta[3]                          # IPTW parameter
    beta = theta[4:]                         # Outcome model parameters

    # Outcome regression model
    ee_reg = ee_regression(beta,
                           X=X,
                           y=y,
                           model='linear')
    yhat1 = np.dot(X1, beta)                 # Predicted values under A=1
    yhat0 = np.dot(X0, beta)                 # Predicted values under A=0

    # IPW
    ee_pi = a - pi_a                         # Mean of assigned treatment
    ee_pi = ee_pi*subset                     # Potentially subsetting
    w = a/pi_a + (1-a)/(1-pi_a)              # Calculating IPTW

    # AIPW formula
    ee_mean1 = (y*a*w - yhat1*(a-pi_a)/pi_a) - mu1            # AIPW formula for mean A=1
    ee_mean1 = ee_mean1 * subset                              # applying subset if requested
    ee_mean0 = (y*(1-a)*w + yhat0*(a-pi_a)/(1-pi_a)) - mu0    # AIPW formula for mean A=0
    ee_mean0 = ee_mean0 * subset                              # applying subset if requested
    ee_ate = ((mu1 - mu0) - ate) * np.ones(y.shape[0])        # Transformation of AIPW means into mean difference

    # Returning the stacked estimating functions
    return np.vstack((ee_ate,
                      ee_mean1,
                      ee_mean0,
                      ee_pi,
                      ee_reg))


##############################################################
# Overall ATE

subset = 1

# Standard ITT
stnd = MEstimator(psi_itt, init=init_itt)
stnd.estimate(solver='lm')

# AIPW ITT
aipw = MEstimator(psi_aipw_itt, init=init_aipw)
aipw.estimate(solver='lm')

# Storing results to display to console
result = ["Overall", "ITT",                                                       # Label for the table
          stnd.theta[0],                                                          # Point estimate
          np.sqrt(stnd.variance[0, 0]),                                           # Standard Error (SE)
          stnd.confidence_intervals()[0, 0],                                      # Lower confidence limit
          stnd.confidence_intervals()[0, 1],                                      # Upper confidence limit
          1.0]                                                                    # Ratio with itself is 1
results.append(result)
result = ["Overall", "AIPW",                                                      # Labels for the table
          aipw.theta[0],                                                          # Point estimate
          np.sqrt(aipw.variance[0, 0]),                                           # Standard Error (SE)
          aipw.confidence_intervals()[0, 0],                                      # Lower confidence limit
          aipw.confidence_intervals()[0, 1],                                      # Upper confidence limit
          (1 - np.sqrt(aipw.variance[0, 0]) / np.sqrt(stnd.variance[0, 0]))*100]  # Ratio of SE
results.append(result)

##############################################################
# Displaying results in a table

table = pd.DataFrame(results, columns=["s", "Estr", "ATE", "SE", "LCL", "UCL", "SER"])
table = table.set_index("s")
print(table.round(3))

#          Estr    ATE      SE     LCL     UCL     SER
# s
# Overall   ITT  1.328  13.675 -25.474  28.130   1.000
# Overall  AIPW  5.471   1.172   3.173   7.769  91.426
