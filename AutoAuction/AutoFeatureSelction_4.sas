
options compress=yes  linesize=100;
libname save "D:\Backup\Documents\CC";

%let K_vars1=
             MIDBODY_SEDAN /* MIDBODY_SUV CHBODY_SEDAN*/ CHBODY_SUV
             /*MIDMODEL_ELANTRA  MIDMODEL_OPTIMA MIDMODEL_SONATA CHMODEL_ELANTRA  CHMODEL_OPTIMA  CHMODEL_SONATA*/  MODEL_ELANTRA MODEL_OPTIMA MODEL_SONATA
             /*MIDMAKE_HYUNDAI MIDMAKE_KIA CHMAKE_HYUNDAI CHMAKE_KIA*/ MAKE_HYUNDAI /* MAKE_KIA*/
            JDPOWER_COMPACT JDPOWER_MIDSIZE JDPOWER_SUV_VAN
	        JDPOWER_SUB_ENTRY JDPOWER_SUB_PREMIUM
            COLOR_Black COLOR_Blue  COLOR_Gray COLOR_Silver  COLOR_White
            sflndr_LEASE /*sflndr_REPO*/
            volseg_Tier1 /* volseg_Tier2 volseg_Tier345
            Velocity_Cold Velocity_Hot */ Velocity_Warm
            SREMAR_IND SANNOU_IND SANNOU_DMV0
            abnormal sfloor_AdjMMR_match
			/*dmsold*/
/*dmpostcond*/
dmprecond
smiles
sfloor
SALE_NUM
LANE_NUM
RUN_NUM
DSO 
MMR
/*AdjMMR*/
sale_days /*number of days the car was sold,calculate from sdtesa-arrivaldate*/
mid_age  /* car age(years) got from MID_YEAR*/
/*ymm_age *//*car age(years) got from YMM*/
sale_time /*the time of the day that the car was sold, got from stime*/
sfloor_MMR /*sfloor_MMR=sfloor/MMR;*/
sfloor_AdjMMR /*sfloor_AdjMMR=sfloor/AdjMMR;*/
;
/*check pairwise correlation of continuous variables*/
proc corr data= save.data_nomissing(keep=&K_vars1. dmsold) best=5;
 run ; 

proc stepdisc data=save.data_nomissing maxstep=1;
 /***Get F-value for each candidate, higher better */
class dmsold; 
var &K_vars1.;
title 'Maxstep=1' ; 
run; 
/*** Check Correlation Coefficent in Model ***/
proc genmod data=save.data_nomissing;
model dmsold=&K_vars1./dist=binomial corrb;
run;
/*Check VIF in Model*/
proc reg data=save.data_nomissing;
model dmsold=&K_vars1./tol vif collin;
run;

%let K_vars2=
            /* MIDBODY_SEDAN MIDBODY_SUV CHBODY_SEDAN*/ CHBODY_SUV
             /*MIDMODEL_ELANTRA  MIDMODEL_OPTIMA MIDMODEL_SONATA  CHMODEL_ELANTRA  CHMODEL_OPTIMA  CHMODEL_SONATA*/  MODEL_ELANTRA MODEL_OPTIMA MODEL_SONATA
             /*MIDMAKE_HYUNDAI MIDMAKE_KIA CHMAKE_HYUNDAI CHMAKE_KIA*/ MAKE_HYUNDAI /* MAKE_KIA*/
           /* JDPOWER_COMPACT JDPOWER_MIDSIZE JDPOWER_SUV_VAN */
	        /*JDPOWER_SUB_ENTRY JDPOWER_SUB_PREMIUM*/
            COLOR_Black COLOR_Blue  COLOR_Gray COLOR_Silver  COLOR_White
            sflndr_LEASE /*sflndr_REPO*/
            volseg_Tier1 /* volseg_Tier2 volseg_Tier345
            Velocity_Cold Velocity_Hot */ Velocity_Warm
            SREMAR_IND SANNOU_IND SANNOU_DMV0
            abnormal sfloor_AdjMMR_match
			/*dmsold*/
/*dmpostcond*/
dmprecond
smiles
sfloor
SALE_NUM
LANE_NUM
RUN_NUM
DSO 
/*MMR*/
/*AdjMMR*/
sale_days /*number of days the car was sold,calculate from sdtesa-arrivaldate*/
mid_age  /* car age(years) got from MID_YEAR*/
/*ymm_age *//*car age(years) got from YMM*/
sale_time /*the time of the day that the car was sold, got from stime*/
/*sfloor_MMR*/ /*sfloor_MMR=sfloor/MMR;*/
sfloor_AdjMMR /*sfloor_AdjMMR=sfloor/AdjMMR;*/
;
%let K_vars3=
            /* MIDBODY_SEDAN MIDBODY_SUV CHBODY_SEDAN*/ CHBODY_SUV
             /*MIDMODEL_ELANTRA  MIDMODEL_OPTIMA MIDMODEL_SONATA  CHMODEL_ELANTRA  CHMODEL_OPTIMA  CHMODEL_SONATA*/  MODEL_ELANTRA MODEL_OPTIMA MODEL_SONATA
             /*MIDMAKE_HYUNDAI MIDMAKE_KIA CHMAKE_HYUNDAI CHMAKE_KIA*/ MAKE_HYUNDAI /* MAKE_KIA*/
           /* JDPOWER_COMPACT JDPOWER_MIDSIZE JDPOWER_SUV_VAN */
	        /*JDPOWER_SUB_ENTRY JDPOWER_SUB_PREMIUM*/
            COLOR_Black COLOR_Blue  COLOR_Gray COLOR_Silver  COLOR_White
            sflndr_LEASE /*sflndr_REPO*/
            volseg_Tier1 /* volseg_Tier2 volseg_Tier345
            Velocity_Cold Velocity_Hot */ Velocity_Warm
            SREMAR_IND SANNOU_IND SANNOU_DMV0
            abnormal sfloor_AdjMMR_match
			/*dmsold*/
/*dmpostcond*/
dmprecond
smiles
sfloor
/*SALE_NUM*/
LANE_NUM
RUN_NUM
/*DSO */
/*MMR*/
/*AdjMMR*/
/*sale_days*/ /*number of days the car was sold,calculate from sdtesa-arrivaldate*/
mid_age  /* car age(years) got from MID_YEAR*/
/*ymm_age *//*car age(years) got from YMM*/
sale_time /*the time of the day that the car was sold, got from stime*/
/*sfloor_MMR*/ /*sfloor_MMR=sfloor/MMR;*/
sfloor_AdjMMR /*sfloor_AdjMMR=sfloor/AdjMMR;*/
;

%let K_vars4=
             MIDBODY_SEDAN /* MIDBODY_SUV CHBODY_SEDAN*/ CHBODY_SUV
             /*MIDMODEL_ELANTRA  MIDMODEL_OPTIMA MIDMODEL_SONATA CHMODEL_ELANTRA  CHMODEL_OPTIMA  CHMODEL_SONATA*/  MODEL_ELANTRA MODEL_OPTIMA MODEL_SONATA
             /*MIDMAKE_HYUNDAI MIDMAKE_KIA CHMAKE_HYUNDAI CHMAKE_KIA*/ MAKE_HYUNDAI /* MAKE_KIA*/
            JDPOWER_COMPACT JDPOWER_MIDSIZE JDPOWER_SUV_VAN
	        JDPOWER_SUB_ENTRY JDPOWER_SUB_PREMIUM
            COLOR_Black COLOR_Blue  COLOR_Gray COLOR_Silver  COLOR_White
            sflndr_LEASE /*sflndr_REPO*/
            volseg_Tier1 /* volseg_Tier2 volseg_Tier345
            Velocity_Cold Velocity_Hot */ Velocity_Warm
            SREMAR_IND SANNOU_IND SANNOU_DMV0
            abnormal sfloor_AdjMMR_match
			/*dmsold*/
/*dmpostcond*/
dmprecond
smiles
sfloor
/*SALE_NUM*/
LANE_NUM
RUN_NUM
/*DSO */
MMR
/*AdjMMR*/
/*sale_days*/ /*number of days the car was sold,calculate from sdtesa-arrivaldate*/
mid_age  /* car age(years) got from MID_YEAR*/
/*ymm_age *//*car age(years) got from YMM*/
sale_time /*the time of the day that the car was sold, got from stime*/
sfloor_MMR /*sfloor_MMR=sfloor/MMR;*/
sfloor_AdjMMR /*sfloor_AdjMMR=sfloor/AdjMMR;*/
;
/* Randomly split the model data file into two samples: 
70% DEV_data sample, 
30% TEST_data sample */

proc surveyselect data=save.data_nomissing out=split samprate= .7 outall seed=9999999 ; 
run ; 
Data save.DEV_data save.TEST_data; 
set split; 
if selected = 1 then output save.DEV_data; 
else output save.TEST_data; 
Run ; 
/* AutomatiCally select the model by using Stepwise and Backward Selection */
/***Decending: Probabi1ity modeled is attr_flag=1***/
proc Logistic Data = save.DEV_data DESCENDING OUTEST=model1;
Model dmsold=&K_vars1./selection=stepwise RSQ parmlabel; 
run;
proc Logistic Data = save.DEV_data DESCENDING OUTEST= model2; 
Model dmsold =&K_vars1./selection=backward RSQ parmlabel ; 
run;

proc Logistic Data = save.DEV_data DESCENDING OUTEST=model1;
/***Decending: Probabi1ity modeled is attr_flag=1***/
Model dmsold  = &K_vars2./selection=stepwise RSQ parmlabel; 
run;
proc Logistic Data = save.DEV_data DESCENDING OUTEST= model2; 
Model dmsold  = &K_vars2./selection=backward RSQ parmlabel ; 
run;


proc Logistic Data = save.DEV_data DESCENDING OUTEST=model1;
/***Decending: Probabi1ity modeled is attr_flag=1***/
Model dmsold  = &K_vars3./selection=stepwise RSQ parmlabel; 
run;
proc Logistic Data = save.DEV_data DESCENDING OUTEST= model2; 
Model dmsold  = &K_vars3./selection=backward RSQ parmlabel ; 
run;
proc Logistic Data = save.DEV_data DESCENDING OUTEST=model1;
/***Decending: Probabi1ity modeled is attr_flag=1***/
Model dmsold  = &K_vars4./selection=stepwise RSQ parmlabel; 
run;
proc Logistic Data = save.DEV_data DESCENDING OUTEST= model2; 
Model dmsold  = &K_vars4./selection=backward RSQ parmlabel ; 
run;
