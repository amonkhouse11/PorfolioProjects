libname thesis "D:\Thesis";
data crp;
set thesis.crp_d thesis.crp_e thesis.crp_f;
run;
data demo;
set thesis.demo_d thesis.demo_e thesis.demo_f;
run;

data PHQ9;
set thesis.phq9_d thesis.phq9_e thesis.phq9_f;
run;

data ferritin;
set thesis.ferritin_d thesis.ferritin_e thesis.ferritin_f;
run;

data tfr;
set thesis.tfr_d thesis.tfr_e thesis.tfr_f;
run;
data tbi;
set thesis.tbi5 thesis.tbi7 thesis.tbi9;
run;
data BMI;
set thesis.BMI_d thesis.BMI_e thesis.BMI_f;
run;

proc sort data = BMI;
by seqn;
run;

proc sort data = crp;
by seqn;
run;

proc sort data = phq9;
by seqn;
run;

proc sort data = ferritin;
by seqn;
run;

proc sort data = tfr;
by seqn;
run;
proc sort data= tbi;
by seqn;
run;

data total;
merge demo crp phq9 ferritin tfr tbi bmi;
by seqn;
run; /*adding the variables to the data*/


data nhanes;
set total;

/*4-year sampe weights for 2003-2006, variable MEC6YR; adjust for more/fewer survey years*/
if sddsrvyr in (4,5,6) then MEC6YR = 1/2 * WTMEC2YR;

/*DUMMY & RECODED VARIABLES*/
hispanic=.;
if ridreth1=1 then hispanic=1;
if ridreth1=2 then hispanic =1;
if ridreth1=3 then hispanic =0;
if ridreth1=4 then hispanic =0;
if ridreth1=5 then hispanic =0;

black=.;
if ridreth1=1 then black =0;
if ridreth1=2 then black =0;
if ridreth1=3 then black =0;
if ridreth1=4 then black =1;
if ridreth1=5 then black =0;

other=.;
if ridreth1=1 then other =0;
if ridreth1=2 then other =0;
if ridreth1=3 then other =0;
if ridreth1=4 then other =0;
if ridreth1=5 then other =1;

ethncat=.;
if ridreth1=1 then ethncat=1;
if ridreth1=2 then ethncat=1;
if ridreth1=3 then ethncat=3;
if ridreth1=4 then ethncat=4;
if ridreth1=5 then ethncat=5;

/*SUBPOPULATION - define domain as needed for analysis*/
subpop=.;
  if riagendr=2 and ridageyr > 17 and ridageyr < 50 and RIDEXPRG=2 then subpop=1;
  else subpop=0;
PHQ2= .;
if PHQ9>10 then PHQ2=1;
if PHQ9<10 then PHQ2=0; /* make PHQ9 Dichotomous variable for analysis**/
run;
data nhanes;
set nhanes;
TBI2= .;
if TBI>0 then TBI2=0;
if TBI<0 then TBI2=1;
run;

/*weighted procedures for NHANES*/

proc surveymeans data = nhanes;
weight MEC6YR;
strata sddsrvyr;
cluster sdmvpsu;
var  PHQ9 TBI LBDFERSI LBXTFR lbxcrp hispanic black other ridreth1 PHQ2 Tbi2 ;
where tbi ^=.;
where phq9 ^=.;
where LBDFERSI ^=.;
where LBXTFR ^=.;
where LBXCRP ^=.;
where hispanic ^=.;
where black ^=.;
where other ^=.;
where ridreth1 ^=.;
where subpop=1;
run;
   title "Scatter Plot With Modifications TBI & PHQ9";

proc sgplot data=nhanes noautolegend;
   styleattrs datasymbols=(circlefilled squarefilled starfilled);
   scatter x=TBI y=phq9 / group=ridreth1;
   keylegend / location=inside position=NE across=1;
   where subpop=1;
run;

title "Scatter Plot With Modifications Transferretin & PHQ9";

   proc sgplot data=nhanes noautolegend;
   styleattrs datasymbols=(circlefilled squarefilled starfilled);
   scatter x=lbxtfr y=phq9 / group=ridreth1;
   keylegend / location=inside position=NE across=1;
   where subpop=1;
run;

title "Scatter Plot With Modifications BMI & PHQ9";
proc sgplot data=nhanes noautolegend;
   styleattrs datasymbols=(circlefilled squarefilled starfilled);
   scatter x=BMXBMI y=phq9 / group=ridreth1;
   keylegend / location=inside position=NE across=1;
   where subpop=1;
run;
title "Scatter Plot With Modifications Ferritin & PHQ9";
proc sgplot data=nhanes noautolegend;
   styleattrs datasymbols=(circlefilled squarefilled starfilled);
   scatter x=lbxfersi y=phq9 / group=ridreth1;
   keylegend / location=inside position=NE across=1;
   where subpop=1;
run;

proc sgplot data=nhanes noautolegend;
   title 'Linear Regression PHQ9 & TBI';
   reg y=phq9 x=tbi;
   where subpop=1;
run;
proc sgplot data=nhanes noautolegend;
   title 'Linear Regression PHQ9 & Ferritin';
   reg y=phq9 x=BMXBMI;
   where subpop=1;
run;
proc sgplot data=nhanes noautolegend;
   title 'Linear Regression PHQ9 & Ferritin';
   reg y=phq9 x=lbxfersi;
   where subpop=1;
run;
proc sgplot data=nhanes noautolegend;
   title 'Linear Regression PHQ9 & trasnferritin';
   reg y=phq9 x=lbxtfr;
   where subpop=1;
run;

proc corr data = nhanes;
var PHQ9 LBDFERSI LBXTFR TBI lbxcrp ridreth1 BMXBMI;
where subpop=1/*variable list*/;
run;

proc surveyreg data = nhanes;
model PHQ9= TBI hispanic black other ridreth1 BMXBMI LBXCRP;
where hispanic ^=.;
where black ^=.;
where other ^=.;
where ridreth1 ^=.;
where BMXBMI ^=.;
where LBXCRP ^=.;
where subpop=1;
run;

proc surveyreg data=nhanes;
model PHQ9=BMXBMI hispanic black other ridreth1;
where hispanic ^=.;
where black ^=.;
where other ^=.;
where ridreth1 ^=.;
where subpop=1;
run;
proc surveyreg data = nhanes;
model PHQ9= TBI;
where PHQ9 ^=.;
where TBI ^=.;
where subpop=1;
run;

title "Computing Frequencies and Percentages Using PROC FREQ";
proc freq data=nhanes;
by ridreth1;
tables PHQ2 TBI2;
where subpop=1;
run;

title "Cross Tab TBI";
proc freq data=nhanes;
tables ridreth1 * TBI2;
where subpop=1;
run;

title "Cross Tab PHQ";
proc freq data=nhanes;
tables ridreth1 * PHQ2;
where subpop=1;
run;


  data _null_; FREERAM_MB=input(getoption('xmrlmem'),20.)/1024/1024; put FREERAM_MB= 8.; run;

  proc options group=memory; run;
proc surveylogistic data=nhanes;
   strata sddsrvyr;
   cluster sdmvpsu;
   weight MEC6YR;
   model phq2 = TBI2 / link=glogit;/*what does this even do??*/
   where tbi2 ^=.;
where phq2 ^=.;
where subpop=1;
run;
















