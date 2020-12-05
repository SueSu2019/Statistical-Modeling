

options compress=yes  linesize=100;
libname save "D:\Backup\Documents\CC";

/***Vars selected by stepwise1 and backword2 from all the variable with VIF<20***/
%let K_vars1_model1_2=  
                      MODEL_ELANTRA             
                      MODEL_OPTIMA     
                      MODEL_SONATA   
                      MAKE_HYUNDAI           
                      COLOR_Black              
                      COLOR_Gray                
                      sflndr_LEASE              
                      SREMAR_IND                
                      SANNOU_IND               
                      sfloor_AdjMMR_match       
                      dmprecond                
                      smiles                 
                      sfloor                
                      SALE_NUM              
                     /* LANE_NUM*/    /*From Model1*/              
                      RUN_NUM              
                      DSO                      
                      MMR                       
                      mid_age                   
                      sale_time                
                      sfloor_MMR             
                      sfloor_AdjMMR
  JDPOWER_MIDSIZE  /*From Model2*/ 
  JDPOWER_SUV_VAN   /*From Model2*/ 
;
proc Logistic Data = save.DEV_data DESCENDING OUTEST= model; 
Model dmsold  = &K_vars1_model1_2./RSQ parmlabel ; 
run; 
proc corr  Data = save.DEV_data ;
var &K_vars1_model1_2.;
with dmsold;
run;
/***Remove sale_days, DSO and sale_num, and keep c>0.5 vars in vars1**/
%let K_vars4_model7_8= 
MODEL_ELANTRA 
MAKE_HYUNDAI    
COLOR_Black        
COLOR_Gray           
sflndr_LEASE           
volseg_Tier1           
Velocity_Warm          
SREMAR_IND            
sfloor_AdjMMR_match   
dmprecond               
smiles                 
sfloor                 
LANE_NUM            
RUN_NUM            
MMR                  
mid_age               
sale_time            
sfloor_MMR            
sfloor_AdjMMR         
;


proc Logistic Data = save.DEV_data DESCENDING OUTEST= model; 
Model dmsold  = &K_vars4_model7_8./RSQ parmlabel ; 
run; 
proc corr  Data = save.DEV_data ;
var &K_vars4_model7_8.;
with dmsold;
run;
/***remove low f-value var from the pairs with c>0.5***/
%let K_vars2_model3_4=  
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
proc Logistic Data = save.DEV_data DESCENDING OUTEST= model; 
Model dmsold  = &K_vars2_model3_4./RSQ parmlabel ; 
run; 
proc corr  Data = save.DEV_data ;
var &K_vars2_model3_4.;
with dmsold;
run;
/***Remove both c>0.5 and sale_days, DSO and sale_num**/
%let K_vars3_model5_6= 
 
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


proc Logistic Data = save.DEV_data DESCENDING OUTEST= model; 
Model dmsold  = &K_vars3_model5_6./RSQ parmlabel ; 
run; 
proc corr  Data = save.DEV_data ;
var &K_vars3_model5_6.;
with dmsold;
run;

