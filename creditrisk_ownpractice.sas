FILENAME REFFILE '/folders/myshortcuts/creditrisk/Gift.xls';

PROC IMPORT DATAFILE=REFFILE /*Instead of importing REPLACE the dataset if importing a new one or revised one*/
	DBMS=XLS
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;

libname shan '/folders/myshortcuts/creditrisk';

data shan.gift;
	set work.import;
run; 

/*libname shan 'C:\SAScreditrisk'*/

PROC CONTENTS DATA=shan.gift; RUN;

/*proc print data=shan.gift(obs=100); run;*/

/* Proc Means to check the values of variable TargetD for distinct values of variable TargetB */
proc means data=shan.gift;
var TargetD;
class TargetB;
run;

/* Checking  for  missing value count*/
data  shan.chk;
	set shan.gift;
	where GiftAvgCard36=.;
run;
/*NOTE: There were 1780 observations read from the data set SHAN.GIFT. WHERE GiftAvgCard36=.; */
/*NOTE: The data set WORK.CHK has 1780 observations and 28 variables.*/

/*missing values for age*/

data  shan.chk;
	set shan.gift;
	where DemAge=.;
run;

/*NOTE: There were 2407 observations read from the data set SHAN.GIFT. */
      /*WHERE DemAge=.;*/
/*NOTE: The data set WORK.CHK has 2407 observations and 28 variables.*/

/* This course had missed on this following wonderful piece of code for summrizing missing values*/
proc means data=shan.gift NMISS N;
run;

/*missing value treatment*/

data shan.gift1;
set shan.gift;
	if DemAge=. then 
		do;
			DemAge=0;
			flagDemAge=1;
		end;
	else flagDemage=0;
	
	if GiftAvgCard36=. then 
		do;
		GiftAvgCard36=0;
		flagGiftAvgCard36=1;
		end;
	else flagGiftAvgCard36=0;
run;

/*NOTE: There were 9686 observations read from the data set SHAN.GIFT.*/
/*NOTE: The data set SHAN.GIFT1 has 9686 observations and 30 variables.*/

/* Spotting the character variables*/
proc contents data=shan.gift1; run;

/*Find the significance of character variables on the dependent variable*/

proc freq data=shan.gift1;
tables StatusCat96NK*TargetB/chisq;
run;

/* combine E and S of the output cross tablulation*/
/*A L and N can be combined of cross tab to reduce no of distinct categories in categorical variable*/
/*Please remove the categorical variable in the dataset once indicator variables are created*/

data shan.gift1;
	set shan.gift1;
	ind_stcat96nk_E_or_S=0;
	ind_stcat96nk_A_L_N=0;
	if StatusCat96NK in ('E','S') then ind_stcat96nk_E_or_S=1;
	else if StatusCat96NK in ('A','L','N') then ind_stcat96nk_A_L_N=1;
run;



proc freq data=shan.gift1;
tables ind_stcat96nk_E_or_S*StatusCat96NK ind_stcat96nk_A_L_N*StatusCat96NK/norow nocol nocum
nopercent chisq;
run;

/*Creating an Indicator variable for demcluster varaible*/
/*First take chisq*/

proc freq data=shan.gift1;
tables Demcluster*targetB/chisq;
run;

/* We know that only row separation matters*/
/*However, we also know that column % matters so that majority of the poulation is not concentrated in any one bucket */

proc freq data=shan.gift1;
tables Demcluster*targetB/nocol nofreq nocum
nopercent chisq;
run;


/* Let’s take this output to excel and check it */


data shan.gift1;
set shan.gift1;
ind_demclus_1=0;
ind_demclus_2=0;
ind_demclus_3=0;
ind_demclus_4=0;
	If DemCluster  in  ( '32') then ind_demclus_1  = 1 ;
	If DemCluster  in  ( '10') then ind_demclus_1  = 1 ;
	If DemCluster  in  ( '47') then ind_demclus_1  = 1 ;
	If DemCluster  in  ( '44') then ind_demclus_1  = 1 ;
	If DemCluster  in  ( '52') then ind_demclus_1  = 1 ;
	If DemCluster  in  ( '06') then ind_demclus_1  = 1 ;
	If DemCluster  in  ( '30') then ind_demclus_1  = 1 ;
	else If DemCluster  in  ( '41') then ind_demclus_2  = 1 ;
	else If DemCluster  in  ( '37') then ind_demclus_2  = 1 ;
	else If DemCluster  in  ( '08') then ind_demclus_2  = 1 ;
	else If DemCluster  in  ( '21') then ind_demclus_2  = 1 ;
	else If DemCluster  in  ( '43') then ind_demclus_2  = 1 ;
	else If DemCluster  in  ( '49') then ind_demclus_2  = 1 ;
	else If DemCluster  in  ( '51') then ind_demclus_2  = 1 ;
	else If DemCluster  in  ( '45') then ind_demclus_2  = 1 ;
	else If DemCluster  in  ( '36') then ind_demclus_2  = 1 ;
	else If DemCluster  in  ( '25') then ind_demclus_3  = 1 ;
	else If DemCluster  in  ( '15') then ind_demclus_3  = 1 ;
	else If DemCluster  in  ( '17') then ind_demclus_3  = 1 ;
	else If DemCluster  in  ( '09') then ind_demclus_3  = 1 ;
	else If DemCluster  in  ( '05') then ind_demclus_3  = 1 ;
	else If DemCluster  in  ( '12') then ind_demclus_3  = 1 ;
	else If DemCluster  in  ( '31') then ind_demclus_3  = 1 ;
	else If DemCluster  in  ( '19') then ind_demclus_3  = 1 ;
	else If DemCluster  in  ( '33') then ind_demclus_3  = 1 ;
	else If DemCluster  in  ( '48') then ind_demclus_3  = 1 ;
	else If DemCluster  in  ( '50') then ind_demclus_3  = 1 ;
	else If DemCluster  in  ( '27') then ind_demclus_3  = 1 ;
	else If DemCluster  in  ( '26') then ind_demclus_3  = 1 ;
	else If DemCluster  in  ( '14') then ind_demclus_3  = 1 ;
	else If DemCluster  in  ( '39') then ind_demclus_3  = 1 ;
	else If DemCluster  in  ( '34') then ind_demclus_3  = 1 ;
	else If DemCluster  in  ( '16') then ind_demclus_3  = 1 ;
	else If DemCluster  in  ( '02') then ind_demclus_3  = 1 ;
	else If DemCluster  in  ( '22') then ind_demclus_4  = 1 ;
	else If DemCluster  in  ( '42') then ind_demclus_4  = 1 ;
	else If DemCluster  in  ( '18') then ind_demclus_4  = 1 ;
	else If DemCluster  in  ( '35') then ind_demclus_4  = 1 ;
	else If DemCluster  in  ( '46') then ind_demclus_4  = 1 ;
	else If DemCluster  in  ( '11') then ind_demclus_4  = 1 ;
	else If DemCluster  in  ( '24') then ind_demclus_4  = 1 ;
	else If DemCluster  in  ( '23') then ind_demclus_4  = 1 ;
	else If DemCluster  in  ( '20') then ind_demclus_4  = 1 ;
	else If DemCluster  in  ( '40') then ind_demclus_4  = 1 ;
	else If DemCluster  in  ( '29') then ind_demclus_4  = 1 ;
	else If DemCluster  in  ( '38') then ind_demclus_4  = 1 ;
	else If DemCluster  in  ( '13') then ind_demclus_4  = 1 ;
	else If DemCluster  in  ( '01') then ind_demclus_4  = 1 ;
	else If DemCluster  in  ( '03') then ind_demclus_4  = 1 ;
	else If DemCluster  in  ( '53') then ind_demclus_4  = 1 ;
	else If DemCluster  in  ( '28') then ind_demclus_4  = 1 ;
	else If DemCluster  in  ( '07') then ind_demclus_4  = 1 ;
run;


/*demgender variable signifcance*/
proc freq data=shan.gift1;
tables demgender*targetb/ chisq;
run;

/*categorical variable conversion to indicator NOT REQUIRED*/
proc freq data=shan.gift1;
tables demhomeowner*targetb/ chisq;
run;

/*Multi collinearity Treatment*/
/*Multi collinearity Treatment*/
/*Multi collinearity Treatment*/

data test val;
	set shan.gift1;
	if ranuni(1)<=0.7 then output test;
	else output val;
run;

/* log file*/
/*NOTE: There were 9686 observations read from the data set SHAN.GIFT1.
NOTE: The data set WORK.TEST has 6793 observations and 36 variables.
NOTE: The data set WORK.VAL has 2893 observations and 36 variables.*/

/* Knowing bi-variate strength of the independent variables in explaining the dependent variable*/
	proc logistic data = test ;
		model targetB = 
	DemAge
	DemMedHomeValue
	DemMedIncome
	DemPctVeterans
	GiftAvg36
	GiftAvgAll
	GiftAvgCard36
	GiftAvgLast
	GiftCnt36
	GiftCntAll
	GiftCntCard36
	GiftCntCardAll
	GiftTimeFirst
	GiftTimeLast
	PromCnt12
	PromCnt36
	PromCntAll
	PromCntCard12
	PromCntCard36
	PromCntCardAll
	StatusCatStarAll
	flagDemAge
	flagGiftAvgCard36
	ind_demclus_1
	ind_demclus_2
	ind_demclus_3
	ind_demclus_4
	ind_stcat96nk_A_L_N
	ind_stcat96nk_E_or_S/selection = stepwise maxstep=1 details;
	ods output EffectNotInModel = log_data ;
	run;

/* Multi collinearity treatment – step 01*/
/*Note – we also dropped some insignificant variables based on bi-variate strength*/


proc reg  data = test plots(maxpoints=none);
model targetB = 
DemAge
DemMedHomeValue
GiftAvg36
GiftAvgAll
GiftAvgLast
GiftCnt36
GiftCntAll
GiftCntCard36
GiftCntCardAll
GiftTimeFirst
GiftTimeLast
PromCnt12
PromCnt36
PromCntAll
PromCntCard12
PromCntCard36
PromCntCardAll
StatusCatStarAll
flagGiftAvgCard36
ind_demclus_1
ind_demclus_2
ind_demclus_4
ind_stcat96nk_A_L_N
ind_stcat96nk_E_or_S
/ vif collin; ODS OUTPUT CollinDiag = collin_data (drop = intercept) ParameterEstimates = para_data; run;

/* First cycle of VIF we removed promcntcardall*/
/* Close look at complete multi collinearity removal output*/


/*Final Model development*/
/*Final Model development*/
/*Final Model development*/

proc logistic data = test outmodel = model_1;
    model targetb(event  = '1') =
DemAge
DemMedHomeValue
GiftAvg36
GiftCnt36
GiftCntCardAll
GiftTimeLast
ind_demclus_1
ind_demclus_2
ind_demclus_4
ind_stcat96nk_E_or_S/
details;
ods output EffectNotInModel = log_data ;
run;


/***** final model variable selection using step wise regression ******/
/***** final model variable selection using step wise regression ******/
/***** final model variable selection using step wise regression ******/

proc logistic data = test outmodel = model_1;
    model targetb(event  = '1') =
DemAge
DemMedHomeValue
GiftAvg36
GiftCnt36
GiftCntCardAll
GiftTimeLast
ind_demclus_1
ind_demclus_2
ind_demclus_4
ind_stcat96nk_E_or_S/
selection = stepwise maxstep=8 details;
ods output EffectNotInModel = log_data ;
run;


/*****Developing final model variable coefficients on validation data set*****/
/*****Developing final model variable coefficients on validation data set*****/
/*****Developing final model variable coefficients on validation data set*****/
/*****Developing final model variable coefficients on validation data set*****/


proc logistic data = val ;
    model targetb(event  = '1') =
DemMedHomeValue
GiftAvg36
GiftCnt36
GiftCntCardAll
GiftTimeLast
ind_demclus_1
ind_demclus_2
ind_demclus_4
;
run;

/* Take a look at coefficient stability worksheet */
/* Take a look at coefficient stability worksheet */
/* Take a look at coefficient stability worksheet */
/* Take a look at coefficient stability worksheet */


/*//****Knowing model strength****//*/
/*//****Knowing model strength****//*/
/*//****Knowing model strength****//*/
/*//****Knowing model strength****//*/
/*Keeping model coefficients in a data set*/


proc logistic data = test outmodel = model_1;
    model targetb(event  = '1') =
DemMedHomeValue
GiftAvg36
GiftCnt36
GiftCntCardAll
GiftTimeLast
ind_demclus_1
ind_demclus_2
ind_demclus_4
;
run;

/* Predictions - Generating score in the test data */
/* Predictions - Generating score in the test data */
/* Predictions - Generating score in the test data */ /*In this sheet 'test'  is the training data */

proc logistic inmodel = model_1;
score data= test out = predicted; 
run;

/* Proc contents of test data just to see what extra fields were added */

proc contents data=predicted;
run;

/* Understand how proc logistic generates score in the dataset
And what is the score actually */

/* This section is just demonstrating the back calculation of PD through Odds */
data predicted; 
set predicted;
P_0_D = round(P_0*1000,0.1);
log_odds=0.2751	+
DemMedHomeValue*9.425E-7	+
GiftAvg36*-0.00915	+
GiftCnt36*0.0847	+
GiftCntCardAll*0.0273	+
GiftTimeLast*-0.0362	+
ind_demclus_1*-0.3611	+
ind_demclus_2*-0.2279	+
ind_demclus_4*0.1434	;
prob=exp(log_odds)/(1+exp(log_odds));

run;

/*P_0=Probability of '0' in the model
P_1=Probability of 1
prob =e(logs_odds/(1+exp(log_odds) this is the derived probability value using equation which should be equal to P_1 in the predicted dataset(almost equal)
P_0_D=It is P_0 Multiplied by 1000 to make it easier to read for the user*/

proc print data=predicted (obs=50);
var DemMedHomeValue
GiftAvg36
GiftCnt36
GiftCntCardAll
GiftTimeLast
ind_demclus_1
ind_demclus_2
ind_demclus_4
P_0
P_1
log_odds
Prob
P_0_D;
run;


/*Creates ten deciles for the score variable on the dataset.
The decile will be ascending(P_0) 
Please note lower value of P_0 is same as high value of P_1, hence more of outcome =1
*/

proc rank data=predicted out=practice group=10 ties=low ;
var P_0_D;
ranks P_Final;
run;

/*Check how does the actual score and ranked variable look like */
proc print data=practice(obs=50);
var P_0_D P_Final ;
run;

/*Getting figures to calculate KS and Gini in Development datset */
proc sql ;
select P_final, min(P_0_D)as Min_score, max(P_0_D)as Max_score, sum(1*targetB) as responder, count(targetB) as population
from practice
group by P_final
order by P_final
;
quit;

/*Scoring the validation dataset – using coefficients obtained on development data*/
/*Scoring the validation dataset – using coefficients obtained on development data*/
proc logistic inmodel = model_1;
score data= val out = predicted; 
run;

data predicted; 
set predicted;
P_0_D = round(P_0*1000,0.1);
run;

proc rank data=predicted out=practice group=10 ties=low ;
var P_0_D;
ranks P_Final;
run;

proc print data=practice(obs=50);
var P_0_D P_Final ;
run;

proc sql ;
select P_final, min(P_0_D)as Min_score, max(P_0_D)as Max_score, sum(1*targetB) as responder, count(targetB) as population
from practice
group by P_final
order by P_final
;
quit;


