proc import datafile="D:\Backup\Documents\CC\Commercial Sale Case Study.csv"
     out=auto_case
	 dbms=csv
	 replace;
	 getnames=yes;
	 run;
proc contents data=auto_case;run;
   data AUTO_CASE    ;
   %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
    infile 'D:\Backup\Documents\CC\Commercial Sale Case Study.csv' delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
          informat sauci $4. ;
          informat auctionname $19. ;
          informat auctioncity $15. ;
          informat swo $32. ;
          informat sdtesa best32. ;
          informat arrivaldate best32. ;
          informat sser17 $17. ;
          informat JD_POWERS_CAT_DESC $11. ;
          informat JD_POWERS_SUB_CAT_DESC $15. ;
          informat dmpostcond best32. ;
          informat dmprecond best32. ;
          informat smiles best32. ;
          informat color $6. ;
          informat dmsold best32. ;
          informat MID $32. ;
          informat MID_YEAR best32. ;
          informat MID_MAKE $8. ;
          informat MID_MODEL $26. ;
          informat MID_BODY $23. ;
          informat ch_make $8. ;
          informat ch_model $18. ;
          informat ch_body $7. ;
          informat sfloor best32. ;
          informat stime anydtdtm40. ;         
          informat SALE_NUM best32. ;
          informat LANE_NUM best32. ;
          informat RUN_NUM best32. ;
          informat sflndr $1. ;
          informat RED_LIGHT $1. ;
          informat YELLOW_LIGHT $1. ;
          informat YMM $27. ;
          informat volseg $5. ;
          informat Velocity $4. ;
          informat DSO best32. ;
          informat MMR best32. ;
          informat AdjMMR best32. ;
          informat SREMAR $22. ;
          informat SANNOU $27. ;
          informat abnormal best32. ;
format sauci $4. ;
format auctionname $19. ;
format auctioncity $15. ;
format swo $12. ;
format sdtesa best12. ;
format arrivaldate best12. ;
format sser17 $17. ;
format JD_POWERS_CAT_DESC $11. ;
format JD_POWERS_SUB_CAT_DESC $15. ;
format dmpostcond best12. ;
format dmprecond best12. ;
format smiles best12. ;
format color $6. ;
format dmsold best12. ;
format MID $32. ;
format MID_YEAR best12. ;
format MID_MAKE $8. ;
format MID_MODEL $26. ;
format MID_BODY $23. ;
format ch_make $8. ;
format ch_model $18. ;
format ch_body $7. ;
format sfloor best12. ;
format stime datetime. ;
format SALE_NUM best12. ;
format LANE_NUM best12. ;
format RUN_NUM best12. ;
format sflndr $1. ;
format RED_LIGHT $1. ;
format YELLOW_LIGHT $1. ;
format YMM $27. ;
format volseg $5. ;
format Velocity $4. ;
format DSO best12. ;
format MMR best12. ;
format AdjMMR best12. ;
format SREMAR $22. ;
format SANNOU $27. ;
format abnormal best12. ;
 input
sauci  $
auctionname  $
auctioncity  $
swo $
sdtesa
arrivaldate
sser17  $
JD_POWERS_CAT_DESC  $
JD_POWERS_SUB_CAT_DESC  $
dmpostcond
dmprecond
smiles
color  $
dmsold
MID $
MID_YEAR
MID_MAKE  $
MID_MODEL  $
MID_BODY  $
ch_make  $
ch_model  $
ch_body  $
sfloor
stime
SALE_NUM
LANE_NUM
RUN_NUM
sflndr  $
RED_LIGHT  $
YELLOW_LIGHT  $
YMM  $
volseg  $
Velocity  $
DSO 
MMR
AdjMMR
SREMAR  $
SANNOU  $
abnormal
 ;
if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
 run;
data auto_case;
set auto_case;/*(drop=swo ssr17 MID auctionname SREMAR); */
year=scan(YMM,1,'_')*1;
make=scan(YMM,2,'_');
model=scan(YMM,3,'_');

run;

proc contents data=auto_case position;
run;
footnote;

proc freq data=auto_case;
tables dmsold/missing
;
run;

/*check the influence by auction and its location*/
ODS HTML FILE="D:\Backup\Documents\CC\AutoAuction\AuctionFreq.html";
proc freq data=auto_case ORDER=FREQ;
table sauci auctioncity;
run;
ODS HTML CLOSE;
ODS HTML FILE="D:\Backup\Documents\CC\AutoAuction\MakeModelFreq.html";
 proc freq data=auto_case ORDER=FREQ;
table MID_MAKE  
      MID_MODEL  
      MID_BODY  
      ch_make  
      ch_model  
      ch_body  
      make
      model;
	  run;
ODS HTML CLOSE;


libname save "D:\Backup\Documents\CC\AutoAuction";
data save.auto_case;/*Drop MID_MAKE MID_MODEL MID_BODY  ch_make ch_model ch_body make model*/
     set auto_case;
	 if  substr(MID_BODY,4,5)='SEDAN' THEN MIDBODY_SEDAN=1; ELSE MIDBODY_SEDAN=0;
	 IF  substr(MID_BODY,4,3)='SUV' THEN MIDBODY_SUV=1; ELSE MIDBODY_SUV=0;
	 IF  ch_body='Sedan' then CHBODY_SEDAN=1; ELSE CHBODY_SEDAN=0;
	 IF  ch_body='SUV' THEN CHBODY_SUV=1; ELSE CHBODY_SUV=0;

	 IF  MID_MODEL='ELANTRA' THEN MIDMODEL_ELANTRA=1; ELSE MIDMODEL_ELANTRA=0;
	 IF  MID_MODEL='OPTIMA' THEN MIDMODEL_OPTIMA=1; ELSE MIDMODEL_OPTIMA=0;
     IF  MID_MODEL='SONATA' THEN MIDMODEL_SONATA=1; ELSE MIDMODEL_SONATA=0;
     IF  CH_MODEL='Elantra' THEN CHMODEL_ELANTRA=1; ELSE CHMODEL_ELANTRA=0;
	 IF  CH_MODEL='Optima' THEN CHMODEL_OPTIMA=1; ELSE CHMODEL_OPTIMA=0;
     IF  CH_MODEL='Sonata' THEN CHMODEL_SONATA=1; ELSE CHMODEL_SONATA=0;
     IF  MODEL='Elantra' THEN MODEL_ELANTRA=1; ELSE MODEL_ELANTRA=0;
	 IF  MODEL='Optima' THEN MODEL_OPTIMA=1; ELSE MODEL_OPTIMA=0;
     IF  MODEL='Sonata' THEN MODEL_SONATA=1; ELSE MODEL_SONATA=0;

     IF  MID_MAKE='HYUNDAI' THEN MIDMAKE_HYUNDAI=1; ELSE MIDMAKE_HYUNDAI=0;
	 IF  MID_MAKE='KIA' THEN MIDMAKE_KIA=1; ELSE MIDMAKE_KIA=0;
     IF  CH_MAKE='Hyundai' THEN CHMAKE_HYUNDAI=1; ELSE CHMAKE_HYUNDAI=0;
	 IF  CH_MAKE='Kia' THEN CHMAKE_KIA=1; ELSE CHMAKE_KIA=0;
     IF  MAKE='Hyundai' THEN MAKE_HYUNDAI=1; ELSE MAKE_HYUNDAI=0;
	 IF  MAKE='Kia' THEN MAKE_KIA=1; ELSE MAKE_KIA=0;
	 RUN;
	 PROC FREQ DATA=SAVE.AUTO_CASE;
	 TABLES MIDBODY_SEDAN MIDBODY_SUV CHBODY_SEDAN CHBODY_SUV
            MIDMODEL_ELANTRA  MIDMODEL_OPTIMA  MIDMODEL_SONATA  CHMODEL_ELANTRA  CHMODEL_OPTIMA  CHMODEL_SONATA MODEL_ELANTRA MODEL_OPTIMA MODEL_SONATA
             MIDMAKE_HYUNDAI MIDMAKE_KIA CHMAKE_HYUNDAI CHMAKE_KIA MAKE_HYUNDAI MAKE_KIA;
			 RUN;


proc freq data=auto_case ORDER=FREQ;
tables JD_POWERS_CAT_DESC JD_POWERS_SUB_CAT_DESC color sflndr RED_LIGHT YELLOW_LIGHT volseg Velocity;run;

proc freq data=auto_case;tables JD_POWERS_CAT_DESC*JD_POWERS_SUB_CAT_DESC dmsold*color dmsold*JD_POWERS_CAT_DESC dmsold*JD_POWERS_SUB_CAT_DESC;run;
proc freq data=auto_case;tables dmsold*sflndr dmsold*RED_LIGHT dmsold*YELLOW_LIGHT dmsold*volseg dmsold*Velocity;run;
   
data save.auto_case;/*Drop JD_POWERS_CAT_DESC JD_POWERS_SUB_CAT_DESC color sflndr RED_LIGHT YELLOW_LIGHT volseg Velocity*/
    set save.auto_case;
	if JD_POWERS_CAT_DESC='COMPACT CAR' THEN JDPOWER_COMPACT=1;ELSE JDPOWER_COMPACT=0;
	if JD_POWERS_CAT_DESC='MIDSIZE CAR' THEN JDPOWER_MIDSIZE=1;ELSE JDPOWER_MIDSIZE=0;   
	if JD_POWERS_CAT_DESC='SUV' OR JD_POWERS_CAT_DESC='VAN' THEN JDPOWER_SUV_VAN=1;ELSE JDPOWER_SUV_VAN=0;
   
	IF JD_POWERS_SUB_CAT_DESC='ENTRY' THEN JDPOWER_SUB_ENTRY=1;ELSE JDPOWER_SUB_ENTRY=0;
    IF JD_POWERS_SUB_CAT_DESC='PREMIUM' THEN JDPOWER_SUB_PREMIUM=1;ELSE JDPOWER_SUB_PREMIUM=0;

	IF COLOR='Black' THEN COLOR_Black=1;ELSE COLOR_Black=0;
	IF COLOR='Blue' THEN COLOR_Blue=1;ELSE COLOR_Blue=0;
    IF COLOR='Gray' THEN COLOR_Gray=1;ELSE COLOR_Gray=0;
    IF COLOR='Silver' THEN COLOR_Silver=1;ELSE COLOR_Silver=0;
    IF COLOR='White' THEN COLOR_White=1;ELSE COLOR_White=0;

	if sflndr='L' THEN sflndr_LEASE=1;ELSE sflndr_LEASE=0;
	IF sflndr='R' THEN sflndr_REPO=1;ELSE sflndr_REPO=0;

	IF RED_LIGHT ='Y' THEN RED_LIGHT_IND =1; ELSE RED_LIGHT_IND =0;
    IF YELLOW_LIGHT ='Y' THEN YELLOW_LIGHT_IND =1; ELSE YELLOW_LIGHT_IND =0;

	IF volseg='Tier1' THEN volseg_Tier1=1; ELSE volseg_Tier1=0; 
    IF volseg='Tier2' THEN volseg_Tier2=1; ELSE volseg_Tier2=0; 
    IF volseg ='Tier3' OR volseg ='Tier4' OR volseg ='Tier5' THEN volseg_Tier345=1; ELSE volseg_Tier345=0; 

    IF Velocity='Cold' Then Velocity_Cold=1;ELSE Velocity_Cold=0;
    IF Velocity='Hot' Then Velocity_Hot=1;ELSE Velocity_Hot=0;
    IF Velocity='Warm' Then Velocity_Warm=1;ELSE Velocity_Warm=0;
    
	run;
PROC FREQ DATA=SAVE.AUTO_CASE;
	 TABLES JDPOWER_COMPACT JDPOWER_MIDSIZE JDPOWER_SUV_VAN
	        JDPOWER_SUB_ENTRY JDPOWER_SUB_PREMIUM
            COLOR_Black COLOR_Blue  COLOR_Gray COLOR_Silver  COLOR_White
            sflndr_LEASE sflndr_REPO
            volseg_Tier1 volseg_Tier2 volseg_Tier345
            Velocity_Cold Velocity_Hot Velocity_Warm
			;
			run;
PROC FREQ DATA=SAVE.AUTO_CASE order=freq;
tables SREMAR  SANNOU;run;

data save.auto_case;/*Drop SREMAR  SANNOU */
    set save.auto_case;
	if SREMAR=' ' THEN SREMAR_IND=0; ELSE SREMAR_IND=1;
	IF SANNOU=' ' THEN SANNOU_IND=0; ELSE SANNOU_IND=1;
	IF SANNOU='DMV$0' THEN SANNOU_DMV0=1; ELSE SANNOU_DMV0=0;
	RUN;
PROC FREQ DATA=SAVE.AUTO_CASE;
	 TABLES dmsold*SREMAR_IND dmsold*SANNOU_IND dmsold*SANNOU_DMV0;
 RUN;

DATA save.auto_case;
    set save.auto_case; 
	 sfloor_MMR=sfloor/MMR;
     sfloor_AdjMMR=sfloor/AdjMMR;
	 if abs(sfloor_AdjMMR-1)<=0.1 then sfloor_AdjMMR_match=1;else  sfloor_AdjMMR_match=0;
	 RUN;
/*
proc univariate data=save.auto_case;
var SALE_NUM LANE_NUM RUN_NUM;
run;*/

data save.auto_case;
set save.auto_case;
sale_days=input(put(sdtesa,8.),yymmdd8.)-input(put(arrivaldate,8.),yymmdd8.);
mid_age=19-(mid_year-2000);
ymm_age=19-(mid_year-2000);
sale_time=timepart(stime)/3600;
run;
proc print data=save.auto_case(obs=20); 
var 
sdtesa 
arrivaldate 
MID_YEAR
year
stime
sale_days
mid_age
ymm_age
sale_time;
run;
