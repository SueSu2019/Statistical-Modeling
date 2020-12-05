libname save "D:\Backup\Documents\CC\AutoAuction";
options compress=yes linesize=256;
%let dummy_vars=
             MIDBODY_SEDAN MIDBODY_SUV /*CHBODY_SEDAN CHBODY_SUV*/
             MIDMODEL_ELANTRA  MIDMODEL_OPTIMA  MIDMODEL_SONATA /* CHMODEL_ELANTRA  CHMODEL_OPTIMA  CHMODEL_SONATA MODEL_ELANTRA MODEL_OPTIMA MODEL_SONATA*/
             MIDMAKE_HYUNDAI MIDMAKE_KIA/* CHMAKE_HYUNDAI CHMAKE_KIA MAKE_HYUNDAI MAKE_KIA*/
            JDPOWER_COMPACT JDPOWER_MIDSIZE JDPOWER_SUV_VAN
	        JDPOWER_SUB_ENTRY JDPOWER_SUB_PREMIUM
            COLOR_Black COLOR_Blue  COLOR_Gray COLOR_Silver  COLOR_White
            sflndr_LEASE sflndr_REPO
            volseg_Tier1 volseg_Tier2 volseg_Tier345
            Velocity_Cold Velocity_Hot Velocity_Warm
RED_LIGHT_IND YELLOW_LIGHT_IND
            SREMAR_IND SANNOU_IND SANNOU_DMV0
            abnormal sfloor_AdjMMR_match;
%let Drop_C_vars=
     swo ssr17 MID auctionname SREMAR /*Delete Directly*/
	 sauci auctioncity /*too many groups and no group percent over 10%*/
     MID_MAKE MID_MODEL MID_BODY  ch_make ch_model ch_body make model /*Transfer to dummy vars*/
	 JD_POWERS_CAT_DESC JD_POWERS_SUB_CAT_DESC color sflndr volseg Velocity/*Transfer to dummy vars*/
	 RED_LIGHT YELLOW_LIGHT /*Transfer to dummy vars*/
     SREMAR  SANNOU /*Transfer to dummy vars*/
	 YMM /*Splitted into 'year', 'make' and 'model'*/
;
%let N_vars=
sdtesa /*transfer sale_days*/
arrivaldate /*transfer sale_days*/
dmpostcond
dmprecond
smiles
MID_YEAR /*tranform to MID_AGE*/
sfloor
stime /*extract sold time of the sold day*/
SALE_NUM
LANE_NUM
RUN_NUM
DSO 
MMR
AdjMMR
year /*Split from YMM, transformed YMM_AGE*/
sale_days /*number of days the car was sold,calculate from sdtesa-arrivaldate*/
mid_age  /* car age(years) got from MID_YEAR*/
ymm_age /*car age(years) got from YMM*/
sale_time /*the time of the day that the car was sold, got from stime*/
sfloor_MMR /*sfloor_MMR=sfloor/MMR;*/
sfloor_AdjMMR /*sfloor_AdjMMR=sfloor/AdjMMR;*/
;
%LET Keep_N_vars=
dmpostcond
dmprecond
smiles
sfloor
/*SALE_NUM
LANE_NUM
RUN_NUM
DSO */
MMR
AdjMMR
/*sale_days*/ /*number of days the car was sold,calculate from sdtesa-arrivaldate*/
mid_age  /* car age(years) got from MID_YEAR*/
/*ymm_age*/ /*car age(years) got from YMM*/
/*sale_time*/ /*the time of the day that the car was sold, got from stime*/
sfloor_MMR /*sfloor_MMR=sfloor/MMR;*/
sfloor_AdjMMR /*sfloor_AdjMMR=sfloor/AdjMMR;*/
;
%let Drop_N_vars =
sdtesa /*transfer sale_days*/
arrivaldate /*transfer sale_days*/
MID_YEAR /*tranform to MID_AGE*/
stime /*extract sold time of the sold day*/
SALE_NUM
LANE_NUM
RUN_NUM
year /*Split from YMM, transformed YMM_AGE*/
;

/**Check correlation/multicollinearity********************/
/*First Loop*/
/*check pairwise correlation of continuous variables*/
ODS HTML FILE="D:\Backup\Documents\CC\AutoAuction\VarsCorr.html";
proc corr data= save.data_nomissing(keep=&Keep_N_vars. &dummy_vars. dmsold) best=5;
 run ; 
ODS HTML CLOSE;
ODS HTML FILE="D:\Backup\Documents\CC\AutoAuction\F_VALUE OF Predictors.html";
proc stepdisc data=save.data_nomissing maxstep=1;
 /***Get F-value for each candidate, higher better */
class dmsold; 
var &Keep_N_vars. &dummy_vars.;
title 'Maxstep=1' ; 
run; 
ODS HTML CLOSE;
ODS HTML FILE="D:\Backup\Documents\CC\AutoAuction\Correlation with outcomes.html";
/*** Check Correlation Coefficent in Model ***/
proc genmod data=save.data_nomissing;
model dmsold=&Keep_N_vars. &dummy_vars./dist=binomial corrb;
run;
ODS HTML CLOSE;
/*Check VIF in Model*/
ODS HTML FILE="D:\Backup\Documents\CC\AutoAuction\VarsVIF.html";
proc reg data=save.data_nomissing;
model dmsold=&Keep_N_vars. &dummy_vars./tol vif collin;
run;
ODS HTML CLOSE;

/***Remove the high correlated vars based on F-VALUE***/
%let K_vars1=
             /*MIDBODY_SEDAN*/ MIDBODY_SUV
             MIDMODEL_ELANTRA  MIDMODEL_OPTIMA   MIDMODEL_SONATA
              MIDMAKE_HYUNDAI/* MIDMAKE_KIA */
            /*JDPOWER_COMPACT JDPOWER_MIDSIZE JDPOWER_SUV_VAN
	        JDPOWER_SUB_ENTRY JDPOWER_SUB_PREMIUM*/
            COLOR_Black COLOR_Blue  COLOR_Gray COLOR_Silver  COLOR_White
            sflndr_LEASE /*sflndr_REPO*/
            volseg_Tier1 /* volseg_Tier2 volseg_Tier345
            Velocity_Cold Velocity_Hot */ Velocity_Warm
            SREMAR_IND SANNOU_IND SANNOU_DMV0
            /*abnormal*/ sfloor_AdjMMR_match
			RED_LIGHT_IND YELLOW_LIGHT_IND
			/*dmsold*/
/*dmpostcond*/
dmprecond
smiles
sfloor
/* 
MMR
AdjMMR*/
mid_age  /* car age(years) got from MID_YEAR*/
/*sfloor_MMR *//*sfloor_MMR=sfloor/MMR;*/
sfloor_AdjMMR /*sfloor_AdjMMR=sfloor/AdjMMR;*/
;
/*Second Loop*/
/*check pairwise correlation of continuous variables*/
ODS HTML FILE="D:\Backup\Documents\CC\AutoAuction\VarsCorr_2nd.html";
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

ods html close;
