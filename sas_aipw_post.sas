*Load sim_data_actg5202_aipw.csv

data df2;
 setSdadf df;
 IF trt='ABC/3TC' THEN trt_num=1;
 	ELSE trt_num=0;
Run;

PROC freq data=df2;
run;
	
data df3;
 set df2;
 trt_pi=sum(trt_num)/length(trt_num);
 run;

 Proc ttest data=df;
  var cd4;
  class trt;
  run;

 proc causaltrt data=df2;
 class trt sex agegrp;
 model cd4=sex agegrp basecd4 logrna0;
 psmodel trt;
 bootstrap bootci nboot=5000 seed=10;
 run;


 Proc freq data=df2;
 tables trt*supress/ CMH CHISQ RISKDIFF;
run;

 proc causaltrt data=df2;
 class trt sex agegrp;
 model supress=sex agegrp basecd4 logrna0/ dist=bin ;
 psmodel trt;
 bootstrap bootci nboot=5000 seed=10;
 run;
