
options compress=yes  linesize=100;
libname save "D:\Backup\Documents\CC";
run;
/***vars1-2, from K_vars3_model5_6,Remove both c>0.5 and sale_days, DSO and sale_num**/
%let vars1=  
  MODEL_ELANTRA 
  /*MAKE_HYUNDAI    */   
  COLOR_Black     
  COLOR_Gray       
 /* sflndr_LEASE*/
  volseg_Tier1          
  Velocity_Warm  
  SREMAR_IND     
  sfloor_AdjMMR_match       
  dmprecond        
  smiles         
  sfloor           
  /*LANE_NUM  */          
  /*RUN_NUM */  
  mid_age            
  sale_time          
  sfloor_AdjMMR      
;
%let vars2=  
  MODEL_ELANTRA 
  /*MAKE_HYUNDAI    */   
  COLOR_Black     
  COLOR_Gray       
 /* sflndr_LEASE*/
  volseg_Tier1          
  Velocity_Warm  
  SREMAR_IND     
  sfloor_AdjMMR_match       
  dmprecond        
  smiles         
  sfloor           
  LANE_NUM            
  RUN_NUM   
  mid_age            
  sale_time          
  sfloor_AdjMMR      
;
/***Var3 from K_vars2_model3_4:remove low f-value var from the pairs with c>0.5***/
%let vars3=  
   MODEL_ELANTRA       
   /*MAKE_HYUNDAI  */  
   COLOR_Black 
   COLOR_Gray  
   /*sflndr_LEASE */    
   volseg_Tier1    /*From Model3*/ 
   /*Velocity_Warm */  /*From Model3*/ 
   SREMAR_IND    
   /*SANNOU_IND*/   
   dmprecond       
   smiles            
   sfloor            
   SALE_NUM         
   RUN_NUM          
   DSO               
   mid_age            
   sale_time         
   sfloor_AdjMMR  
   sfloor_AdjMMR_match  

  /* MODEL_SONATA */ /*From Model4*/ 
   MODEL_OPTIMA  /*From Model4*/ 
  /*SANNOU_DMV0*/ /*From Model4*/ 
   /*abnormal */   /*From Model4*/ 
;

proc Logistic Data = save.DEV_data DESCENDING OUTEST= model1; 
Model dmsold  = &vars1./RSQ parmlabel ; 
title 'Model One';
run; 


proc Logistic Data = save.DEV_data DESCENDING OUTEST= model2; 
Model dmsold  = &vars2./RSQ parmlabel ; 
title 'Model Two';
run; 

proc Logistic Data = save.DEV_data DESCENDING OUTEST= model3; 
Model dmsold  = &vars3./RSQ parmlabel ;
title 'Model Three'; 
run; 
title;

%macro ks_test(num=, varlist=); 
proc score data=save.DEV_data score=model&num. OUT = scrout1 TYPE=PARMS; 
VAR &varlist.; 
Run; 
proc score data=save.TEST_data score=model&num. OUT = scrout2 type=PARMS; 
VAR &varlist.;
Run; 

DATA save.P1SCR;
SET SCROUT1;
X = exp(-dmsold2);
X1 = 1/(1+X);
SCOR1000 = ROUND(X1*1000,1);
run;
DATA save.P2SCR;
SET SCROUT2;
X = exp(-dmsold2);
X1 = 1/(1+X);
SCOR1000 = ROUND(X1*1000,1);
RUN;
proc sort data=save.P1SCR; by descending X1; run; 
proc sort data=save.P2SCR; by descending X1; run;
proc format; 
value sscore
  LOW-50='0 to 50'     50-100= '51 to 100'
100-150='101 to 150'   150-200='151 to 200'
200-250='201 to 250'  250-300='251 to 300'
300-350='301 to 350'  350-400='351 to 400'
400-450='401 to 450'  450-500='451 to 500'
500-550='501 to 550'  550-600 ='551 to 600'
600-650='601 to 650'  650-700='651 to 700'
700-750='701 to 750'  750-800='751 to 800'
800-850='801 to 850'  850-900='851 to 900'
900-950='901 to 950'  950-1000='951 to 1000'
1000-HIGH='OVER 1000'
;

proc freq data=save.P1SCR;
tables SCOR1000*dmsold/NOROW NOPERCENT NOCOL;
FORMAT SCOR1000 sscore.;
title "SCORE FOR DEVELOPMENT DATA" ;
RUN;
proc freq data= save.P2SCR; 
tables SCOR1000*dmsold/NOROW NOPERCENT NOCOL;
FORMAT SCOR1000 sscore.; 
title "SCORE FOR TEST DATA" ;
RUN; 
proc Logistic Data = save.DEV_data DESCENDING OUTEST=mode11; 
Model dmsold = &varlist./RSQ parmlabel ctable; 
score data=save.test_data out=score;
run; 

proc tabulate data=score;
class f_dmsold i_dmsold;
table f_dmsold,i_dmsold;
title 'confusion matrix of Test data';
run;
proc Logistic Data = save.DEV_data DESCENDING OUTEST=mode11; 
Model dmsold = &varlist./RSQ parmlabel ctable;
score data=save.dev_data out=score;
run; 

proc tabulate data=score;
class f_dmsold i_dmsold;
table f_dmsold,i_dmsold;
title 'confusion matrix of Train data';
run;
proc print data=model1;
title 'model1 parameter estimates';
run;

%mend ks_test;
*%ks_test(num=1,varlist=&vars1.);
%ks_test(num=2,varlist=&vars2.);
*%ks_test(num=3,varlist=&vars3.);
ENDSAS;

proc Logistic Data = save.DEV_data DECENDING OUTEST=mode11; 
Model dmsold = &vars1./RSQ parmlabel ctable; 
score data=save.test_data out=score;
run; 

proc tabulate data=score;
class f_dmsold i_dmsold;
table f_dmsold,i_dmsold;
title 'confusion matrix of Test data';
run;
proc Logistic Data = save.DEV_data DECENDING OUTEST=mode11; 
Model dmsold = &vars1./RSQ parmlabel ctable;
score data=save.dev_data out=score;
run; 

proc tabulate data=score;
class f_dmsold i_dmsold;
table f_dmsold,i_dmsold;
title 'confusion matrix of Train data';
run;
proc print data=model1;
title 'model1 parameter estimates';
run;




/****Check the relation between Indvar and Dependvar***/ 

proc Logistic Data = save.DEV_data DECENDING OUTEST=mode11; 
Model dmsold = &vars1./RSQ parmlabel ctable; 
score data=save.test_data out=score;
run; 

proc tabulate data=score;
class f_dmsold i_dmsold;
table f_dmsold,i_dmsold;
run;
proc Logistic Data = save.DEV_data DECENDING OUTEST=mode11; 
Model dmsold = &vars1./RSQ parmlabel ctable; 
score data=save.dev_data out=score;
run; 

proc tabulate data=score;
class f_dmsold i_dmsold;
table f_dmsold,i_dmsold;
title 'Accuracy of the model by Train data';
run;
proc print data=model1;
title 'parameter estimates';
run; 
title;

/*Check the Accuary of the model by confusion matrix*/
proc logistic data=train;
model sex=weight height age/ ctable;
score data=valid out=score;
run;

proc tabulate data=score;
class f_sex i_sex;
table f_sex,i_sex;
run;
