* Encoding: UTF-8.

* adding a select case to filter for only high and middle risk youth.

USE ALL.
COMPUTE filter_$=(r_RISK_LEVEL  < 1).
VARIABLE LABELS filter_$ 'r_RISK_LEVEL  < 1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

* split file for bio sex.
SORT CASES  BY BIO_SEX.
SPLIT FILE LAYERED BY BIO_SEX.
EXECUTE. 

*Run Pearson chi-square test for new_violence by case_PARENT_CLOSENESS.

CROSSTABS
  /TABLES=new_violence BY case_PARENT_CLOSENESS
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT EXPECTED ROW SRESID 
  /COUNT ROUND CELL
  /BARCHART. 

*testing for relationship between violence and parent relationship stability. 
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN
  /DEPENDENT VIOLENCE
  /METHOD=ENTER r_PR_STABILITY.
EXECUTE. 

*testing for a relationship between parent closeness and parent relationship stability. 
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN
  /DEPENDENT PARENT_CLOSENESS
  /METHOD=ENTER r_PR_STABILITY.
EXECUTE. 

*ANOVA for violence by female puberty group.
ONEWAY VIOLENCE BY r_H1FP6
  /MISSING ANALYSIS
  /CRITERIA=CILEVEL(0.95).
EXECUTE. 

*ANOVA for violence by male puberty group.
ONEWAY VIOLENCE BY r_H1MP4
  /MISSING ANALYSIS
  /CRITERIA=CILEVEL(0.95).
EXECUTE.  

*ANOVA for puberty with parent closeness for boys. 
EXECUTE.
ONEWAY PARENT_CLOSENESS BY r_H1MP4
  /MISSING ANALYSIS
  /CRITERIA=CILEVEL(0.95).
EXECUTE. 

*ANOVA for puberty with parent closeness for girls. 
ONEWAY PARENT_CLOSENESS BY r_H1FP6
  /MISSING ANALYSIS
  /CRITERIA=CILEVEL(0.95).
EXECUTE. 

* running pearson chi square for rearing environment by violence.

CROSSTABS
  /TABLES=case_PARENT_CLOSENESS BY r_environment
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN TOTAL 
  /COUNT ROUND CELL
  /BARCHART.

*running ANOVA for parent-child closeness and impulsivity.
ONEWAY IMPULSIVITY BY case_PARENT_CLOSENESS
  /MISSING LISTWISE
  /CRITERIA=CILEVEL(0.95).


*Running regression for impulsivity predicts impulsivity..
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT VIOLENCE
  /METHOD=ENTER IMPULSIVE.

