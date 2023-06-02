libname data "Z:\Desktop";

PROC import out=df
datafile="Z:\Users\timf\Documents\Github\actg5202_aipw_analysis\sim_data_actg5202_aipw.csv"
DBMS=CSV;
GETNAMES=yes;
Datarow=2;
run;

data df2;
 set df;
 IF trt='ABC/3TC' THEN trt_num=1;
 	ELSE trt_num=0;
trt_ind=1;
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
 psmodel trt =trt_ind;*to model empirical proportion include vector of 1s;
 bootstrap bootci nboot=5000 seed=1234;
 run;

