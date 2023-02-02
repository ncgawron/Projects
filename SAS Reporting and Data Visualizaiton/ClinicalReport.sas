/*
Author: Nicholas Gawron
Date: April 28th 2022
Purpose: Clinical Trial Report Project
*/


*clears log and listing windows
Something to keep every program!;
DM "log;clear";
DM "output;clear";

*new directory for L dirve;
X "cd  L:\st445\Data\BookData\ClinicalTrialCaseStudy";
  libname inputds "." ;
  filename rawData ".";



*I include this for proc compare purposes for personal use in this code;
X "cd  L:\st445\results";
  libname results ".";

*new chnage of directory the pdf too!;
X "cd S:\desktop\st445\results";
  libname final ".";

*creates several formats in one proc!;
proc format library=final.Projectformats;
* this format goes from -inf up to 120 and 120 inclusive to inf;
  value format4sbp(fuzz=0) low- 120 = "Acceptable (120 or below)"
                        120 <- high= "High"
  ;
  value $sex(fuzz=0) 
    "F" = "Female"
    "M" = "Male"
  ;
  *setting 0 to failure 
  and 1 to pass;
 value $screen(fuzz=0)
  0="Failure"
  1='Pass'
  ;
  *takes in reclined and outputs recumbent
   takes in sitting to seated;
  value $pos(fuzz=0)
  "RECLINED" =  "RECUMBENT"
  "SITTING" =  "SEATED" 
  ;
run;

*position;

*options statement needed the 2 lvel path name;
options fmtsearch =(inputds HW3 final.Projectformats);

*gpp turning off listing;
ods trace on; 
options nodate; 
ods listing close; 


*reads in the visit data sets!;
*note we have an attib on baseline cuz we need it for outputing purpsoes;

data final.GawronSite01BV;
attrib   Subj         label = "Subject Number"
         sfReas       label = "Screen Failure Reason"               length = $50
         sfStatus     label = "Screening Flag, 0=Failure, 1=Pass"  length = $1
         BioSex       label = "Biological Sex"                      length = $1
         VisitDate    label = "Date of Visit"                       format  = DATE9.
         failDate     label = "Failure Notification Date"           format = DATE9.
         sbp          label = "Systolic BP"
         dbp          label = "Diastolic BP"
         bpunits      label = "Units (BP)"                          length = $6
         pulse        label = "Pulse"
         pulseUnits   label = "Units (Pulse)"                       length = $9
         _position     label = "Position"                            length = $12
         _temp         label = "Temperature"                         format = 5.1
         _tempUnits    label = "Units (Temp)"                        length = $1
         _weight       label = "Weight"
         _weightUnits  label = "Units (Weight)"                      length = $2
         pain         label = "Pain Score";
         *dlm is tab and dsd does cool stuff with consec delims ;
  infile rawData("Site 1, Baseline Visit.txt") dsd dlm='09'x;
  input Subj 
        sfReas    : $50. 
        sfStatus  : $1.
        BioSex    : $1.
        VisitDate : DATE9.
        failDate  : DATE9.
        sbp 
        dbp 
        bpUnits     : $6.
        pulse     
        pulseUnits  : $9. 
        _position    : $12.
        _temp        
        _tempUnits   : $1.
        _weight 
        _weightUnits : $2.
        pain;
run;

data final.GawronSite01m3;
  infile rawData("Site 1, 3 Month Visit.txt") dsd dlm='09'x;
  input Subj 
        sfReas    : $50. 
        sfStatus  : $1.
        BioSex    : $1.
        VisitDate : DATE9.
        failDate  : DATE9.
        sbp 
        dbp 
        bpUnits     : $6.
        pulse     
        pulseUnits  : $9. 
        _position    : $12.
        _temp        
        _tempUnits   : $1.
        _weight 
        _weightUnits : $2.
        pain;
run;



data final.GawronSite01m6;
  infile rawData("Site 1, 6 Month Visit.txt") dsd dlm='09'x;
  input Subj 
        sfReas    : $50. 
        sfStatus  : $1.
        BioSex    : $1.
        VisitDate : DATE9.
        failDate  : DATE9.
        sbp 
        dbp 
        bpUnits     : $6.
        pulse     
        pulseUnits  : $9. 
        _position    : $12.
        _temp        
        _tempUnits   : $1.
        _weight 
        _weightUnits : $2.
        pain;
run;


data final.GawronSite01m9;
  infile rawData("Site 1, 9 Month Visit.txt") dsd dlm='09'x;
   input Subj 
        sfReas    : $50. 
        sfStatus  : $1.
        BioSex    : $1.
        VisitDate : DATE9.
        failDate  : DATE9.
        sbp 
        dbp 
        bpUnits     : $6.
        pulse     
        pulseUnits  : $9. 
         _position    : $12.
        _temp        
        _tempUnits   : $1.
        _weight 
        _weightUnits : $2.
        pain;
run;



data final.GawronSite01m12;
  infile rawData("Site 1, 12 Month Visit.txt") dsd dlm='09'x;
    input Subj 
        sfReas    : $50. 
        sfStatus  : $1.
        BioSex    : $1.
        VisitDate : DATE9.
        failDate  : DATE9.
        sbp 
        dbp 
        bpUnits     : $6.
        pulse     
        pulseUnits  : $9. 
        _position    : $12.
        _temp        
        _tempUnits   : $1.
        _weight 
        _weightUnits : $2.
        pain;
run;



data final.Site1AllM(drop = _position _temp _tempUnits _weight _weightUnits);
  attrib Subj         label = "Subject Number"
         visitc                                                     length = $20
         visitMonth   format = best12.
         visitNum     format = best12. 
         sfReas       label = "Screen Failure Reason"               length = $50
         sfStatus     label = "Screening Flag, 0=Failure, 1=Pass"   length = $1
         BioSex       label = "Biological Sex"                      length = $1
         VisitDate    label = "Date of Visit"                       format = MMDDYY10. 
         failDate     label = "Failure Notification Date"           format = MMDDYY10. 
         sbp          label = "Systolic BP"
         dbp          label = "Diastolic BP"
         bpunits      label = "Units (BP)"                          length = $6
         pulse        label = "Pulse"
         pulseUnits   label = "Units (Pulse)"                       length = $9
         position     label = "Position"                            format = $pos12.
         temp         label = "Temperature"                         format = 5.1
         tempUnits    label = "Units (Temp)"                        length = $1
         weight       label = "Weight"
         weightUnits  label = "Units (Weight)"                      length = $2
         pain         label = "Pain Score";
*note the format we used on position $pos12. is a custom position format 
         with a set length of 12  ;
         *below creates tracking variable;
    set final.GawronSite01BV(in=inBV) 
        final.GawronSite01m3(in=inm3) 
        final.GawronSite01m6(in=inm6)
        final.GawronSite01m9(in=inm9)
        final.GawronSite01m12(in=inm12); 

    *cleaning data for recumbant spelling
        ;
    if lowcase(_position) eq "recumbant" then do; 
       position =  TRANWRD(_position,'A','E');
        end; 
    else do; 
        position = _position; 
        end; 

     * planning programming for when temp is reorded wrong as C instrad of F;
    if _tempUnits eq "C" then do; 
      temp = 1.8*_temp+32 ;       
      tempUnits = "F"; 
      end; 
    else do; 
      temp=_temp;
      tempUnits = _tempUnits; 
      end; 
    *converts an meteric measuremnts for weight to lbs;
      *also converts label;
    if _weightUnits eq "kg" then do; 
        weight = 2.20462*_weight ;
        weightUnits = "lb";
      end;
    else do;
        weight = _weight; 
        weightUnits = "lb"; 
       end; 


    visitMonth= inBV + 3*inm3 + 6*inm6 + 9*inm9 + 12*inm12;
   
    *ask logan how to prevent hard coding on visitNum var;
    select(visitMonth);
      when(1) do; 
          visitMonth = 0;
          visitNum = 0; 
          visitc = "Baseline Visit";
          end; 
      when(3) do; 
          visitNum = 1; 
          visitc = "3 Month Visit";
          end; 
      when(6) do; 
          visitNum = 2; 
          visitc = "6 Month Visit";
          end; 
      when(9) do; 
          visitNum = 3; 
          visitc = "9 Month Visit";
          end; 
      when(12) do; 
          visitNum = 4; 
          visitc = "12 Month Visit";
          end; 
    end; 





run;



*reading in lab results data all same input / infile statement just different files ;
*******************************************************************;

*baseline data;
data final.labr01BV;
*dsd lets us say 2 empty spaces is a missing value, delim by tab;
 infile rawData("Site 1, Baseline Lab Results.txt") dsd dlm='09'x;
 input Subject
      DOV         : date9.
      Notif_Date  : date9.
      SF_Reas     : $50. 
      Screen      : $1.
      Sex         : $1.
      ALB 
      Alk_Phos
      ALT 
      AST 
      D_Bili 
      GGTP 
      C_Gluc 
      U_Gluc 
      T_Bili 
      Prot 
      Hemoglob 
      Hematocr 
      Preg      : $1. ; 
run;


*3 month data -read in same as baseline;
data final.lab01m3; 
 infile rawData("Site 1, 3 Month Lab Results.txt") dsd dlm='09'x;
 input Subject DOV : date9. Notif_Date : date9.
      SF_Reas     : $50. 
      Screen      : $1.
      Sex         : $1.
      ALB 
      Alk_Phos
      ALT 
      AST 
      D_Bili 
      GGTP 
      C_Gluc 
      U_Gluc 
      T_Bili 
      Prot 
      Hemoglob 
      Hematocr 
      Preg      : $1. ; 
run;




data final.lab01m6; 
 infile rawData("Site 1, 6 Month Lab Results.txt") dsd dlm='09'x;
 input Subject
      DOV         : date9.
      Notif_Date  : date9.
      SF_Reas     : $50. 
      Screen      : $1.
      Sex         : $1.
      ALB 
      Alk_Phos
      ALT 
      AST 
      D_Bili 
      GGTP 
      C_Gluc 
      U_Gluc 
      T_Bili 
      Prot 
      Hemoglob 
      Hematocr 
      Preg      : $1. ; 
run;




data final.lab01m9; 
 infile rawData("Site 1, 9 Month Lab Results.txt") dsd dlm='09'x;
 input Subject
      DOV         : date9.
      Notif_Date  : date9.
      SF_Reas     : $50. 
      Screen      : $1.
      Sex         : $1.
      ALB 
      Alk_Phos
      ALT 
      AST 
      D_Bili 
      GGTP 
      C_Gluc 
      U_Gluc 
      T_Bili 
      Prot 
      Hemoglob 
      Hematocr 
      Preg      : $1. ; 
run;




data final.lab01m12; 
 infile rawData("Site 1, 12 Month Lab Results.txt") dsd dlm='09'x;
 input Subject
      DOV         : date9.
      Notif_Date  : date9.
      SF_Reas     : $50. 
      Screen      : $1.
      Sex         : $1.
      ALB 
      Alk_Phos
      ALT 
      AST 
      D_Bili 
      GGTP 
      C_Gluc 
      U_Gluc 
      T_Bili 
      Prot 
      Hemoglob 
      Hematocr 
      Preg      : $1. ; 
run;






data final.labrALL;
  attrib 
        Subject     label =""
        visitc      label = "Visit"                     length = $20
        visitMonth  format = best12.      label = "Visit Month"
        visitNum    format = best12.
        DOV         format = MONYY7. label = "Date of Visit"
        Notif_Date  label = "Failure Notification Date"
        SF_Reas     label = "Screen Failure Reason"
        Screen      label = "Screening Flag, 0=Failure, 1=Pass"
        Sex
        ALB         label = "Chem-Albumin, g/dL"
        Alk_Phos    label = "Chem-Alk. Phos., IU/L"
        ALT         label = "Chem-Alt, IU/L"
        AST         label = "Chem-AST, IU/L"
        D_Bili      label= "Chem-Dir. Bilirubin, mg/dL"
        GGTP        label= "Chem-GGTP, IU/L"
        C_Gluc      label = "Chem-Glucose, mg/dL"
        U_Gluc      label = " Uri.-Glucose, 1label =high"
        T_Bili      label = "Chem-Tot. Bilirubin, mg/dL"
        Prot        label = "Chem-Tot. Prot., g/dL"
        Hemoglob    label = "Hemoglobin, g/dL"
        Hematocr    label = "EVF/PCV, %"
        Preg        label = "Pregnancy Flag, 1=Pregnant, 0=Not";
 
     *clears format on subject that was best12.;
    format subject;

   set  final.labr01BV(in = inBV)
        final.lab01m3(in = inm3)
        final.lab01m6(in=inm6)
        final.lab01m9(in=inm9)
        final.lab01m12(in=inm12)
        ; 
   *visit month variable made from trakcing vars;
    visitMonth= inBV + 3*inm3 + 6*inm6 + 9*inm9 + 12*inm12;
   
    *ask logan how to prevent hard coding on visitNum var;
    select(visitMonth);
      when(1) do; 
          visitMonth = 0;
          visitNum = 0; 
          visitc = "Baseline";
          end; 
      when(3) do; 
          visitNum = 1; 
          visitc = "3 Month";
          end; 
      when(6) do; 
          visitNum = 2; 
          visitc = "6 Month";
          end; 
      when(9) do; 
          visitNum = 3; 
          visitc = "9 Month";
          end; 
      when(12) do; 
          visitNum = 4; 
          visitc = "12 Month";
          end; 
    end; 
run;

************rotating big data set from all visits!!!**************************;


data final.GawronReshapeVisits; 
  *selects data to flip and drops variables we will not need;
  set final.Site1AllM(drop =  position sfStatus sfReas failDate BioSex pain); 
  array horiz[*] sbp dbp pulse temp weight;
  array unitsnames[*] $  bpUnits bpUnits pulseUnits tempUnits weightUnits;
  do indx = 1 to dim(horiz);
    *creates names of new coloumn variables;
   name = vlabel(horiz[indx]);
   value= horiz[indx];
   units= unitsnames[indx];
   output;
  end;
  drop sbp dbp pulse indx temp weight bpUnits  pulseUnits tempUnits weightUnits ;
run;






*creates means data set for highlow plot in 8.4.4.;
*orders data similar to varnum;
ods output summary= work.MPQuantiles;
proc means data = final.Site1AllM q1 q3 order = data; 
  class visitc;
  var sbp;
run; 



************************ REPORT TIME****************************************; 

*sending outputs to pdf AND RTF AND PPTX file ;
ods rtf file = "Gawron Final Tables Site 1.rtf" style = sapphire;
ods pdf file = "Gawron Final Report Site 1.pdf"  style = meadow; 
ods powerpoint file = "Gawron Final Presentation Site 1.pptx" style = PowerPointDark; 





*8.2.3 proc freq table***************************;

 
*excludes following steps from being sent to the powerpoint; 
ods powerpoint exclude all;
ods noproctitle;
title 'Output 8.2.3: Sex Versus Pain Level Split on Screen Failure Versus Pass, Site 1 Baseline';
proc freq data = final.GawronSite01BV;
  table sfStatus*BioSex*pain/nocol; 
   *applies custom formats;
  format sfStatus $screen. BioSex $sex. ; 
run; 
title; 


*allows things to be wirtten to the ppt again;
ods powerpoint exclude none;



*8.2.4 table is created and goes in the power point;
ods noproctitle;
title 'Output 8.2.4: Sex Versus Screen Failure at Baseline Visit in Site 1';
proc freq data = final.GawronSite01BV;
  format BioSex $sex.;
  table BioSex*sfReas /nocol NOPERCENT ; 
run;  
title; 

*8.2.5 table is a proc means lookin mainly at blood pressure and pulse for a formated version of sbp and sex;
ods noproctitle;
title 'Output 8.2.5: Diastolic Blood Pressure and Pulse Summary Statistics at Baseline Visit in 
Site 1';
proc means data = final.GawronSite01BV maxdec =1 nolabels n mean stddev min max;
  format sbp format4sbp. BioSex $sex.; 
  class BioSex sbp;
  var dbp pulse ;
run;
title; 

*surpresses any printing to the power point;
ods powerpoint exclude all;




*8.2.6 - new table;
ods noproctitle;
title 'Output 8.2.6: Glucose and Hemoglobin Summary Statistics from Baseline Lab Results,
Site 1';
proc means data = final.labr01BV maxdec =1 min q1 median q3 max ;
  class Sex; 
  var c_gluc hemoglob;
  format sex $sex.;
run;
title; 
*the above table was really weird - I thought this would output a labels column but no luck!;

* suppression to rtf for first - stops plots form going to rtf; 
ods rtf exclude all;



*8.3.2; 

*ods grpahics for creating image name;
ods graphics on / width =6in imagename="Gawron832sgplot";
*sets the image;
ods listing image_dpi =300; 

title 'Output 8.3.2: Recruits that Pass Initial Screening, by Month in Site 1';
proc sgplot data = final.GawronSite01BV;
  vbar VisitDate /group = BioSex
                  groupdisplay = cluster;
                  *correct format for display of data;
  format VisitDate MONYY7.; 
  xaxis label = "Month";
  yaxis label = "Passed Screening at Baseline Visit";
  keylegend  / location = inside 
               position = topleft 
               title="";
               *only considering where people pass!;
  where SfStatus = "1"; 
run;
title; 



*ods grpahics for creating image name;
ods graphics on / width =6in imagename="Gawron833sgplot";

*8.3.3 plot of lab data; 
title'Output 8.3.3: Average Albumin Results-Baseline Lab, Site 1';
proc sgplot data = final.labr01BV;
  hbar Sex / response = ALB
                stat = mean
                fillattrs = (color = cxADD8E6)
                limits = upper LIMITSTAT=CLM alpha =0.05
                legendlabel="Chem-Albumin, g/dL, 95% Confidence Limits" ;
                 *changes the label on the legend;
  xaxis label = "Chem-Albumin, g/dL";
  yaxis label = "";
  keylegend  / position = bottom
               location = outside;
run; 
title;

*ods grpahics for creating image name;
ods graphics on / width =6in imagename="Gawron842sgpanel";

*Output 8.4.3: Glucose Distributions, Baseline and 3 Month Visits, Site 1; 
title 'Output 8.4.3: Glucose Distributions, Baseline and 3 Month Visits, Site 1';
proc sgpanel data = final.labrALL; 
   *each panel will be a different visit i.e. baseline and 3 month visits;
  panelby visitc /sort = descending;
  where visitNum  in (0,1);
  histogram C_Gluc; 
  colaxis label = "Chem-Glucose, mg/dL"
           offsetmax = .05;
           *creates tick marks on bottom x axis and lets number be visualized;
  rowaxis label = "Percent";
run;
title; 



*ods grpahics for creating image name;
ods graphics on / width =6in imagename="Gawron844sgplot";

*Output 8.4.4: Systolic Blood Pressure Quartiles, Site 1;
*highlow plot using data output from proc menas to represnt quantiles;
title 'Output 8.4.4: Systolic Blood Pressure Quartiles, Site 1';
proc sgplot data = work.MPQuantiles;
  highlow x=visitc low=sbp_q1 high = sbp_q3/
            type = bar
            barwidth = .3
             fillattrs = (color = cx3399FF)
            grouporder = REVERSEDATA ; 
  yaxis label = "Systolic BP Q1 to Q3 Span"
        values = (95 to 125 by 5);
  xaxis label = "Visit";
run; 
title; 


ods listing close; *closes listing windoe from plot gneration stuff;
 
*stops suppression to rtf for last time; 
ods rtf  exclude none; 
 


*8.6.1;
title "Output 8.6.1: Rotated Date from Baseline Visit, Site 1 (Partial Listing)";
  proc report data =final.Gawronreshapevisits(obs=10); 
    where visitc ="Baseline Visit"; 
    columns obs Subj VisitDate name value Units;  
    define obs  /computed;
      *compute block for the observation, unsure if this is correct but we try!;
      compute obs;
      _obs + 1;
      obs = _obs;
      endcomp;
      define name / style(column) = [cellwidth=1in];
    define value /'Value' format =5.1  style(column) = [cellwidth=.75in];
  run; 
title;





*8.6.2;
ods noproctitle;
*creates report for each visit month and computes summary stats for a set of tests in name 
variable from reshapred data;
title 'Output 8.6.2: Summary Report on Selected Vital Signs, All Visits, Site 1';
proc report data = final.Gawronreshapevisits;
  columns visitMonth visitc name units value=mean value=median value=std value =min value =max;
  define visitMonth / group noprint; 
  define visitc / group 'Visit';
  define name / group width = 5 'Test' style(column) = [cellwidth=1in]; 
  define units / group; 
  define value /'';
  define mean / analysis mean 'mean' format =5.1;
  define median / analysis median 'Median' format = 5.1;
  define std  / analysis std  'Standard Deviation' format = 5.1;
  define min  / analysis min  'Minimum' format = 5.1;
  define max  / analysis max  'Maximum' format = 5.1;
    *excluding wieght as a meteric;
    where name ne "Weight" ;
run;
title; 


*stops suppression to power point for last time; 
ods powerpoint exclude none; 

*Output 8.6.3: BP Summaries, All Visits, Site 1;
ods noproctitle; 
title 'Output 8.6.3: BP Summaries, All Visits, Site 1'; 
proc report data = final.Gawronreshapevisits; 
  columns visitMonth
          visitc 
          name,value,(mean median std);
  *above creates alysis note the commas mean value is nested inside name variable;
  define name /  across 'Measurment' style(column) = [cellwidth=.75in];
  *must begin with the across on the name variable;
  define visitMonth / group noprint; 
  define visitc / group 'Visit';
  *group rows vertically;
  define value /''; 
  *print value;
  define mean  / 'Mean'       format =5.1  style(column) = [cellwidth=.75in];
  define median /'Median'     format =5.1  style(column) = [cellwidth=.75in];
  define std / 'Std. Dev.'    format =5.2  style(column) = [cellwidth=.75in];
  *define stats NOT w compute alias;
    where name in  ("Systolic BP" "Diastolic BP");
run;
title;

* suppression to power point for last time; 
ods powerpoint exclude all; 
 
*8.7.3;
ods noproctitle;
title 'Output 8.7.3: Summary Report on Selected Vital Signs, All Visits, Site 1-Enhanced';
proc report data = final.Gawronreshapevisits nowd
style(summary)=[background=black]
style(header) = [fontweight=bold];
*makes coloumns for report;
  columns visitMonth visitc name units value,(mean median std min max);
      *considers everything but wieght;
     where name ne "Weight" ;
  define visitMonth / group noprint; 
  define visitc / group 'Visit';
  define name / group width = 5 'Test'; 
  define units / group 'Units';  
  define value / '' analysis;  
  define mean /  'Mean' format =5.1;
  define median / 'Median' format =5.1;
  define std  / 'Standard Deviation' format =5.2;
  define min  / 'Minimum' format =5.1;
  define max  / 'Maximum' format =5.1;

  compute visitc ; 
    call define(_col_, 'style', 'style=[fontweight=bold]');
  endcomp;

*compute block for the name varables;
  *colors the lines;
 COMPUTE name;
  IF name ='Pulse' then do; 
      CALL DEFINE(_ROW_, "style", "STYLE=[BACKGROUND=cxC3B1E1]");
      end; 
  else if  name='Systolic BP' then do;
      CALL DEFINE(_ROW_, "style", "STYLE=[BACKGROUND=cxFDFD96]");
      end; 
  else if  name ='Diastolic BP' then do;
      CALL DEFINE(_ROW_, "style", "STYLE=[BACKGROUND=cxC1E1C1]");
      end; 
  else if  name ='Temperature' then do;
      CALL DEFINE(_ROW_, "style", "STYLE=[BACKGROUND=cxFAC898]");
      end; 
 ENDCOMP; 



*adds  the summary coloumn!;
break after visitMonth/ summarize;
compute after visitMonth;
  if _break_ eq '_RBREAK_' then visitMonth = '';
endcomp;


run;
title; 

*closes documents ;
ods rtf close;
ods powerpoint close;
ods pdf close;

*closes trace turns on date and listing window;
ods trace off; 
options date; 
ods listing; 



quit; *gpp;
