libname save "D:\Backup\Documents\CC\AutoAuction";

%let dummy_vars=
             MIDBODY_SEDAN MIDBODY_SUV CHBODY_SEDAN CHBODY_SUV
             MIDMODEL_ELANTRA  MIDMODEL_OPTIMA  MIDMODEL_SONATA  CHMODEL_ELANTRA  CHMODEL_OPTIMA  CHMODEL_SONATA MODEL_ELANTRA MODEL_OPTIMA MODEL_SONATA
             MIDMAKE_HYUNDAI MIDMAKE_KIA CHMAKE_HYUNDAI CHMAKE_KIA MAKE_HYUNDAI MAKE_KIA
            JDPOWER_COMPACT JDPOWER_MIDSIZE JDPOWER_SUV_VAN
	        JDPOWER_SUB_ENTRY JDPOWER_SUB_PREMIUM
            COLOR_Black COLOR_Blue  COLOR_Gray COLOR_Silver  COLOR_White
            sflndr_LEASE sflndr_REPO
            volseg_Tier1 volseg_Tier2 volseg_Tier345
            Velocity_Cold Velocity_Hot Velocity_Warm
            SREMAR_IND SANNOU_IND SANNOU_DMV0
RED_LIGHT_IND YELLOW_LIGHT_IND
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
SALE_NUM
LANE_NUM
RUN_NUM
DSO 
MMR
AdjMMR
sale_days /*number of days the car was sold,calculate from sdtesa-arrivaldate*/
mid_age  /* car age(years) got from MID_YEAR*/
ymm_age /*car age(years) got from YMM*/
sale_time /*the time of the day that the car was sold, got from stime*/
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

ODS HTML FILE="D:\Backup\Documents\CC\AutoAuction\SummaryOfKeptVars.html";
proc freq data=save.auto_case order=freq;tables &dummy_vars.;title 'Frequency of Dummy Variables';run;
proc means data=save.auto_case;var &N_vars.; title 'Summary of All Numeric Variables';run;
proc means data=save.auto_case;var &Keep_N_vars. ; title 'Summary of Keeped numerical Variables';run;
ODS HTML CLOSE;

/**Get ride of Outliers**/
proc univariate data=save.auto_case;var mid_age ymm_age sfloor_MMR sfloor_AdjMMR sale_days;run;
data auto_case;
set save.auto_case;
if mid_age>20 or mid_age<0 then mid_age='';
if ymm_age>20 or ymm_age<0 then ymm_age='';
if sfloor_MMR>1.5 or sfloor_MMR<0.5 then sfloor_MMR='';
if sfloor_AdjMMR>1.5 or sfloor_AdjMMR<0.5 then sfloor_AdjMMR='';
run;


proc means data=auto_case;var &Keep_N_vars. ; title 'Summary of Keeped numerical Variables after delete outlier';run;
                                     

data save.data_nomissing;
    set auto_case;
	if dmprecond='' then dmprecond=3.6454230;
	if sfloor='' then sfloor=12502.87 ;
    if DSO='' then DSO=81.3693476;     
    if MMR='' then MMR=12382.35;     
    if AdjMMR='' then AdjMMR=12305.93;     
    if sale_time='' then sale_time= 11.3264801;       
    if sfloor_MMR='' then sfloor_MMR= 1.0076426;
    if sfloor_AdjMMR='' then sfloor_AdjMMR=  1.0147674;
	if mid_age='' then mid_age= 5.3823566;       
    if ymm_age='' then ymm_age= 5.3823566; 
    if sfloor_MMR='' then sfloor_MMR=1.0072888;       
    if sfloor_AdjMMR='' then sfloor_AdjMMR= 1.0143218;  
;
run;    

ODS HTML FILE="D:\Backup\Documents\CC\AutoAuction\SummaryOfKeptVars_Nomissing.html";

proc means data=save.data_nomissing;var &Keep_N_vars. &dummy_vars. dmsold ; title 'Summary of Keeped Variables(nomissing)';run;

proc means data=save.data_nomissing;var &Keep_N_vars.; title 'Summary of Keeped Numeric Variables(nomissing)';run;
ODS HTML CLOSE;  



 
