
#title: "Coding AIPW"
#author: "Tim Feeney"
#date: '2023-02-20'
    
##############################
#Load Packages
##############################

packages<-c("tidyverse")

for (i in packages) {
    library(i,character.only = TRUE)    
}

#set seed
set.seed(1234)


##############################
#Load Data
##############################

df<-read.csv("sim_data_actg5202_aipw.csv")
df$agegrp<-as.factor(df$agegrp)
head(df)


##############################
### ITT analysis
##############################

summary(lm(cd4~trt, data=df))


##############################
### AIPW
##############################

aipw_single<-function(data){
    
    pi<-sum(data$trt=="TDF/FTC")/nrow(data)
    ipw<-1/pi
    #model the outcome
    out_model<-lm(cd4~trt*sex+trt*agegrp+trt*basecd4+trt*logrna0,
                  data=data)
    g0<-predict(out_model,
                newdata=data %>% mutate(trt="ABC/3TC"))
    g1<-predict(out_model, 
                newdata=data %>% mutate(trt="TDF/FTC"))
    
    AIPW0<-(data$cd4*(data$trt=="ABC/3TC")/(1-pi))-(((data$trt=="ABC/3TC")/(1-pi))-1)*g0
    AIPW1<-(data$cd4*(data$trt=="TDF/FTC")/pi)-(((data$trt=="TDF/FTC")/pi)-1)*g1
    
    paste0("AIPW Estimate: ",round(mean(AIPW1)-mean(AIPW0),3)  ) 
}

aipw_single(df)


##############################
### Bootstrap AIPW Standard Error for CD4 count
##############################

aipw_sim<-function(data, nsims){
    pis<-vector()
    mean_diffs<-vector()
    for (i in 1:nsims){
        #random sample from data with size=n, and replacement (ie bootstrap sampling)
        samp<-sample_n(data,
                       size=nrow(data),
                       replace = TRUE) 
        #calculate robability of treatment, ABC/3TC in this sample
        pi<-sum(samp$trt=="TDF/FTC")/nrow(samp)
        ipw<-1/pi
        #model the outcome
        out_model<-lm(cd4~trt*sex+trt*agegrp+trt*basecd4+trt*logrna0,
                      data=samp)
        g0<-predict(out_model,
                    newdata=samp %>% mutate(trt="ABC/3TC"))
        g1<-predict(out_model,
                    newdata=samp %>% mutate(trt="TDF/FTC"))
        
        AIPW0<-(samp$cd4*(samp$trt=="ABC/3TC")/(1-pi))-(((samp$trt=="ABC/3TC")/(1-pi))-1)*g0
        AIPW1<-(samp$cd4*(samp$trt=="TDF/FTC")/pi)-(((samp$trt=="TDF/FTC")/pi)-1)*g1
        
        mean_diffs<-append(mean_diffs,
                           mean(AIPW1)-mean(AIPW0))
        pis<-append(pis, pi)
    }
    data.frame(mean_diffs,pis)
}

aipw_data<-aipw_sim(df, 3000)
head(aipw_data)
mean(aipw_data[,1])

paste0("Bootstrapped SE: ",sd(aipw_data[,1]))

##############################
### Closed for AIPW Standard Error for CD4 count
##############################

#calculate the probabilty of "treatment", pi
pi<-sum(df$trt=="TDF/FTC")/nrow(df)

#model the outcome
out_model<-lm(cd4~trt*sex+trt*agegrp+trt*basecd4+trt*logrna0,
              data=df)

#Estimate G-formula for the "untreated" and "treated"
g0<-predict(out_model,
            newdata=df %>% mutate(trt="ABC/3TC"))
g1<-predict(out_model,
            newdata=df %>% mutate(trt="TDF/FTC"))

#estimate AIPW values for each individual in both 'untreated' and 'treated'
AIPW0<-(df$cd4*(df$trt=="ABC/3TC")/(1-pi))-(((df$trt=="ABC/3TC")/(1-pi))-1)*g0
AIPW1<-(df$cd4*(df$trt=="TDF/FTC")/pi)-(((df$trt=="TDF/FTC")/pi)-1)*g1

cf_aipw_ate<-mean(AIPW1)-mean(AIPW0)

cf_aipw_diff<-(AIPW1-AIPW0)-cf_aipw_ate
cf_aipw_var<-(1/nrow(df)^2)*sum(cf_aipw_diff^2)
cf_aipw_se<-sqrt(cf_aipw_var)

paste0("Closed-form SE ",cf_aipw_se)
