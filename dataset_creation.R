### Make simulated data
set.seed(1234)
n<-697 #same size as analysis dataset
study_n<-697

#can weight observations or use right seed.

#variables that should have *similar* distributions to the ACTG5202 data
trt<-sample(c("TDF/FTC","ABC/3TC"),
            size=n,replace = TRUE,
            prob=c(0.5,0.5))#random treatment assignment in expectation


sex<-rbinom(n,1, prob=0.147)

logrna0<-rnorm(n, 5,0.58)

basecd4<-rnorm(n,186, 165.2)

agegrp<-sample(c(1,2,3),
               size=n,
               replace=TRUE,
               prob = c(0.075, 0.761,0.164))



Y0<-26.14*sex+
    57.75*logrna0+
    1.05*basecd4+
    (-19.72)*agegrp+
    rnorm(n,0,16)#use the coefficients from the linear regression in the ACTG5202 data

Y1<-Y0+6.7

cd4<-ifelse(trt=="ABC/3TC",Y0, Y1)

df<-data.frame(cd4, trt, sex, logrna0, basecd4, agegrp)
head(df)
#write_csv(df, "sim_data_actg5202_aipw.csv") #output dataset into working directory 