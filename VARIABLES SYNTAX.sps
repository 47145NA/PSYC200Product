* Encoding: UTF-8.
*Create high risk measure for select case. 

*Add variable names. 
VARIABLE LABELS H1NB5 'neighborhood safety'.
EXECUTE. 

VARIABLE LABELS H1ED24 'school safety'.
EXECUTE.

*Add value labels.
VALUE LABELS H1NB5
    0 'no'
    1 'yes'
    6 'refused'
    8 'dont know'.
EXECUTE.

VALUE LABELS H1ED24 
    1 'strongly agree'
    2 'agree'
    3 'neither agree nor disagree'
    4 'disagree'
    5 'strongly disagree'
    6 'refused'
    7 'legitimate skip'
    8 'dont know'.
EXECUTE.

*Add missing values. 
MISSING VALUES
    H1NB5 H1ED24 (3 6 thru 8).
EXECUTE.

*recode variables.
RECODE H1ED24
    (1 thru 2 =1) (4 thru 5=0) INTO r_H1ED24.
VARIABLE LABELS r_H1ED24 'school safety'.
EXECUTE.

*Compute into different variable to get risk scale.
COMPUTE r_RISK_LEVEL=mean(r_H1ED24, H1NB5).
VARIABLE LABELS r_RISK_LEVEL 'risk level'.
EXECUTE. 

*Add value labels for risk level variable.
VALUE LABELS r_RISK_LEVEL
    0 'high risk'
    1 ‘low risk'.
EXECUTE.


* Encoding: UTF-8.
*_________________________________________________________________________________________________________________________

*CLOSENESS SYNTAX.
* ADD VALUE LABELS FOR CLOSENESS
    H1WP8 - 
    H1WP9
    H1WP10
    H1WP13
    H1WP14
    H1WP17A TO H1WP17K
    H1WP18A TO H1WP18K
    case_PARENT_CLOSENESS. 

VALUE LABELS 
    H1WP8 
    0 'no days' 
    1 '1 day' 
    2 '2 days' 
    3 '3 days' 
    4 '4 days' 
    5 '5 days' 
    6 '6 days' 
    7 '7 days' 
    96 'refused' 
    97 'legitimate skip' 
    98 'dont know'
    /
    H1WP9 to H1WP10 
    H1WP13
    1 'not at all' 
    2 'very little' 
    3 'somewhat'
     4 'quite a bit' 
     5 'very much' 
     6 'refused' 
     7 'legitimate skip' 
     8 'dont know'
     /
     H1WP14 
    1 'not at all' 
    2 'very little' 
    3 'somewhat' 
    4 'quite a bit' 
    5 'very much' 
    6 'refused' 
    7 'legitimate skip' 
    8 'dont know' 
    9 'not applicable'
    /
    H1WP17A to H1WP17K 
    0 'no' 
    1 'yes' 
    6 'refused' 
    7 'legitimate skip' 
    8 'dont know'
    /
    H1WP18A to H1WP18K
    0 "no"
    1 "yes" 
    6 "refused" 
    7 "legitimate skip" 
    8 "don’t know"
    9 "not applicable".

* add missing values.

MISSING VALUES
    H1WP8 
    (96 97 98)
    /
    H1WP9 to H1WP10
    H1WP13
    (6 7 8)
    /
    H1WP14
    (6 THRU 9)
    /
    H1WP17A to H1WP17K 
    (6 7 8)
    /
    H1WP18A to H1WP18K
    (6 THRU 9).


*recoding variables onto a scale of 0-1.

RECODE H1WP8 (0=0) (1=0.25) (2=0.25) (3=0.5) (4=0.5) (5=0.75) (6=0.75) (7=1) INTO r_H1WP8.
VARIABLE LABELS  r_H1WP8 'Recoded How Many Meals Had With Parents'.
EXECUTE.
  
RECODE H1WP9 (1=0.2) (2=0.4) (3=0.6) (4=0.8) (5=1) INTO r_H1WP9.
VARIABLE LABELS  r_H1WP9 'Recoded Closeness to Mom'.
EXECUTE.

RECODE H1WP10 (1=0.2) (2=0.4) (3=0.6) (4=0.8) (5=1) INTO r_H1WP10.
VARIABLE LABELS  r_H1WP10 'Recoded for How Much Mom Cares'.
EXECUTE.

RECODE H1WP13 (1=0.2) (2=0.4) (3=0.6) (4=0.8) (5=1) INTO r_H1WP13.
VARIABLE LABELS  r_H1WP13 'Recoded Closeness with Dad'.
EXECUTE.

RECODE H1WP14 (1=0.2) (2=0.4) (3=0.6) (4=0.8) (5=1) INTO r_H1WP14.
VARIABLE LABELS  r_H1WP14 'Recoded for How Much Dad Cares'.
EXECUTE.

* computing closeness to mom variable.

COMPUTE CLOSENESS_MOM=MEAN(H1WP17A TO H1WP17K).
EXECUTE.

* adding variable label for CLOSENESS_MOM.

VARIABLE LABELS CLOSENESS_MOM ‘original closeness to mom variable with activity questions’.

* adding value labels for CLOSENESS_MOM.

VALUE LABELS CLOSENESS_MOM 0 ‘not close’ 1 ‘close’.
 
* computing new closeness mom variable with other questions. 

COMPUTE new_CLOSENESS_MOM=MEAN(CLOSENESS_MOM,r_H1WP9,r_H1WP10).
EXECUTE.

* compute original dad closeness variable.

COMPUTE CLOSENESS_DAD = MEAN(H1WP18A to H1WP18K).
EXECUTE.
* adding variable label for CLOSENESS_DAD.

VARIABLE LABELS CLOSENESS_DAD ‘original closeness to dad variable with activity questions’.

* adding value labels for CLOSENESS_DAD.

VALUE LABELS CLOSENESS_DAD 0 ‘not close’ 1 ‘close’.

* compute new closeness dad variable with other questions.

COMPUTE new_CLOSENESS_DAD=MEAN(CLOSENESS_DAD,r_H1WP13,r_H1WP14).
EXECUTE.

* adding variable label for new closeness dad variable.
VARIABLE LABELS 
new_CLOSENESS_DAD     'final closeness mom variable including activity frequency questions, closeness question, and how much he loves you question'
new_CLOSENESS_MOM    'final closeness mom variable including activity frequency questions, closeness question, and how much she loves you question'.
.
* computing new mom variable, new dad variable, 
    and other parent closeness variable into 
    new general parent closeness continuous variable.

COMPUTE PARENT_CLOSENESS=MEAN(new_CLOSENESS_MOM,new_CLOSENESS_DAD,r_H1WP8).
EXECUTE.
* adding variable labels to PARENT_CLOSENESS.

VARIABLE LABELS PARENT_CLOSENESS ‘mean of mom and dad closeness with other questions’.

* adding value labels to PARENT_CLOSENESS.

VALUE LABELS PARENT_CLOSENESS 0 ‘not close’ 1 ‘close’.

* recoding parent closeness variable into a new dichotomous variable.

RECODE PARENT_CLOSENESS (0 thru 0.5=0) (0.5 thru Highest=1) INTO r_PARENT_CLOSENESS.
VARIABLE LABELS  r_PARENT_CLOSENESS 'recoded dichotomous variable for parent closeness'.
EXECUTE.

* cases for closeness to mom and dad.

DO IF    (new_CLOSENESS_DAD < 0.7 & new_CLOSENESS_MOM < 0.76).
     COMPUTE case_PARENT_CLOSENESS = 1.
ELSE IF    (new_CLOSENESS_DAD < 0.7 & new_CLOSENESS_MOM >= 0.76).
    COMPUTE case_PARENT_CLOSENESS = 2.
ELSE IF    (new_CLOSENESS_DAD >= 0.7 & new_CLOSENESS_MOM < 0.76).
    COMPUTE case_PARENT_CLOSENESS = 3.
ELSE IF    (new_CLOSENESS_DAD >= 0.7 & new_CLOSENESS_MOM >= 0.76).
    COMPUTE case_PARENT_CLOSENESS = 4.
END IF .
EXECUTE.

*_________________________________________________________________________________________________________________________

*GENDER SYNTAX.
*ADD VARIABLE LABEL FOR
    BIO_SEX
    r_H1MP4
    r_H1FP6.

VALUE LABELS 
    BIO_SEX 1 'male' 2 'female' 6 'refused to answer'
    /
    H1MP4 H1FP6
    1 'i look younger than most'
    2 'i look younger than some'
    3 'i look about average'
    4 'i look older than some'
    5 'i look older than most'
    6 'refused'
    7 'legitimate skip' 
    8 'dont know'
    9 'not applicable'.

* changing variable on the level of physical development of boys as compared to boys in the same age group w value label
* changing variable on the level of physical development of girls as compared to girls in the same age group w value label

*add missing values 
    
MISSING VALUES 
    BIO_SEX (6)
    /
    H1MP4 H1FP6
    (6 THRU 9).

*Recode gendered development into 3 groups.

RECODE 
    H1MP4 H1FP6
    (1=1)
    (2=1)
    (3=2)
    (4=3)
    (5=3)
    INTO r_H1MP4 r_H1FP6.
EXECUTE.

*enter new value labels. 

VALUE LABELS r_H1MP4 r_H1FP6
   1 'under developed' 
   2 'normally developed' 
   3 'over developed'.
EXECUTE. 

*_________________________________________________________________________________________________________________________

*SYNTAX FOR ENVIRONMENT.

VARIABLE LABELS 
    H1NB5 'neighborhood safety'
    H1ED24 'school safety'.
EXECUTE.

*Add value labels.
VALUE LABELS H1NB5
    0 'no'
    1 'yes' 
    6 'refused'
    8 'don’t know'.
EXECUTE.

VALUE LABELS H1ED24
    1 'strongly agree'
    2 'agree' 
    3 'neither agree nor disagree' 
    4 'disagree'
    5 'strongly disagree'
    6 'refused'
    7 'legitimate skip' 
    8 'don’t know'.
EXECUTE.

*Add missing values. 
MISSING VALUES 
    H1NB5 (6 8).
EXECUTE.

MISSING VALUES
    H1ED24 (3 6 to 8).
EXECUTE.

*Recode variables.

RECODE H1NB5
    (0=1) (1=2) INTO r_H1NB5.
VARIABLE LABELS r_H1NB5 'neighborhood safety recode'.
EXECUTE.

RECODE H1ED24
    (1 thru 2=2) (4 thru 5 =1) INTO r_H1ED24.
VARIABLE LABELS r_H1ED24 'school safety recode'.
EXECUTE.

*_________________________________________________________________________________________________________________________

*SYNTAX FOR PARENT RELATIONSHIP STABILITY.

*Add variable labels. 
VARIABLE LABELS 
    PB18 'PQ rate relationship w partner'
    PB19 'PQ discuss separating'
    PB20 'PQ fight with partner'. 
EXECUTE. 

*Add value labels.
VALUE LABELS PB18 
    1 'completely unhappy' 
    2 '2/10 happy' 
    3 '3/10 happy' 
    4 '4/10 happy' 
    5 '5/10 happy' 
    6 '6/10 happy' 
    7 '7/10 happy' 
    8 '8/10 happy' 
    9 '9/10 happy' 
    10 'completely happy'.
EXECUTE. 

VALUE LABELS PB19 
    0 'no' 
    1 'yes' 
    6 'refused' 
    7 'legitimate skip'.
EXECUTE. 

VALUE LABELS PB20 
    1 'a lot' 
    2 'some' 
    3 'a little' 
    4 'not at all' 
    6 'refused' 
    7 'legitimate skip'.
EXECUTE. 

*Add missing values.
MISSING VALUES
    PB19 PB20 (6).
EXECUTE.

*Recode variables for current relationship stability rating with 4 groups, 0 thru 3.
*0 is single, 1 is unstable, 2 is medium, 3 is stable. 
RECODE PB18 
    (1 thru 3=1) (4 thru 6 =2) (7 thru 10 = 3) INTO rPB18.
VARIABLE LABELS  rPB18 'current relationship happiness rating'.
EXECUTE.

RECODE PB19 
    (7=0) (1=1) (0=3) INTO rPB19.
VARIABLE LABELS  rPB19 'talked about separating'.
EXECUTE.

RECODE PB20 
    (1=1) (4=3) (7=0) (2 thru 3=2) INTO rPB20.
VARIABLE LABELS  rPB20 'fight with partner '.
EXECUTE.

VALUE LABELS rPB18 rPB19 rPB20
    0 'single parent'
    1 'unstable'
    2 'moderate stability'
    3 'stable'.
EXECUTE.

*Compute mean of current relationship stability - PR_STABILITY.
COMPUTE r_PR_STABILITY=mean(rPB18 to rPB20).
EXECUTE.



*_________________________________________________________________________________________________________________________

*SYNTAX FOR PROBLEM SOLVING.

VARIABLE LABELS
    H1PF7      "You never argue with anyone."
    H1PF13    "You never critize other people."
    H1PF29    "You are well coordinated"
    H1PF15    "Difficult problems make you very upset"
    H1PF16    "When making decisions, you usually go with your 'gut feeling' without thinking too much about the consequences of each alternative."
    H1PF14    "You usually go out of your way to avoid having to deal with problems in your life."
    H1PF18    "When you have a problem to solve, one of the first things you do is get as many facts about the problem as possible"
    H1PF19    "When you are attempting to find a solution to a problem, you usually try to think of as many different ways to approach the problem as possible"
    H1PF20    "When making decisions, you generally use a systematic method for judging and comparing alternatives."
    H1PF21    "After carrying out a solution to a problem, you usually try to analyze what went right and what went wrong"
    H1PF26    "You have a lot of energy". 

VALUE LABELS    
        H1PF7
        H1PF13 to H1PF14
        H1PF19
        H1PF29
        1 'strongly agree' 
        2 'agree' 
        3 'neither agree nor disagree' 
        4 'disagree' 
        5 'strongly disagree'
        6 'refused to answer'
        8 "don't know"
        /
        H1PF18
        H1PF20 to H1PF21
        H1PF26
        1 'strongly agree' 
        2 'agree' 
        3 'neither agree nor disagree' 
        4 'disagree' 
        5 'strongly disagree'
        6 'refused to answer'
        8 "don't know"
        9 'not applicable'. 

RECODE
    H1PF15
    H1PF16
    H1PF26
    (1 = 5)
    (2 = 4)
    (3 = 3)
    (4 = 2)
    (5 = 1)
     into RE_H1PF15
           RE_H1PF16
           RE_H1PF26. 
EXECUTE. 

    *Problem Solving Missing Value.
MISSING VALUES   
    H1PF7
    H1PF13 to H1PF14
    H1PF19
    H1PF29
    (6 8)
    H1PF18
    H1PF20 to H1PF21
    H1PF26
    (6 8 9).

RENAME VARIABLES    
    H1PF7            = IMPULSIVE_1
    H1PF13          = IMPULSIVE_2
    H1PF14          = IMPULSIVE_3
    RE_H1PF15    = IMPULSIVE_4
    RE_H1PF16    = IMPULSIVE_5
    RE_H1PF26    = IMPULSIVE_6
    H1PF18          = IMPULSIVE_7
    H1PF19          = IMPULSIVE_8
    H1PF20          = IMPULSIVE_9
    H1PF21          = IMPULSIVE_10
    H1PF29          = IMPULSIVE_11.

COMPUTE    IMPULSIVE    =    MEAN(IMPULSIVE_1 to IMPULSIVE_11).
EXECUTE. 
                                               
VARIABLE LABELS    
    IMPULSIVE        "MEAN IMPULSIVE"
    IMPULSIVE_4    "Difficult problem is not making you upset"
    IMPULSIVE_5    "Not using gut feeling in making decision"
    IMPULSIVE_6    "Don't have a lot of energy".

VALUE LABELS    
    IMPULSIVE
    1    "LOW"
    5    "HIGH"
    /
    IMPULSIVE_1 
    IMPULSIVE_2
    IMPULSIVE_3 
    IMPULSIVE_4
    IMPULSIVE_5 
    IMPULSIVE_8
    IMPULSIVE_11
        1 'strongly agree' 
        2 'agree' 
        3 'neither agree nor disagree' 
        4 'disagree' 
        5 'strongly disagree'
        6 'refused to answer'
        8 "don't know"
      /
     IMPULSIVE_6     
     IMPULSIVE_7
     IMPULSIVE_9     
     IMPULSIVE_10
        1 'strongly agree' 
        2 'agree' 
        3 'neither agree nor disagree' 
        4 'disagree' 
        5 'strongly disagree'
        6 'refused to answer'
        8 "don't know"
        9 "not applicable".

COMPUTE IMPULSIVITY	= 1.

DO IF (IMPULSIVE < 2.74).
    COMPUTE IMPULSIVITY    = 1.
ELSE IF (IMPULSIVE < 3).
    COMPUTE IMPULSIVITY    = 2.
ELSE IF (IMPULSIVE < 5).
    COMPUTE IMPULSIVITY    = 3.
END IF.
VALUE LABEL
    IMPULSIVITY
    1 'LOW'
    2 'MID'
    3 'HIGH'.
EXECUTE    .


*_________________________________________________________________________________________________________________________

*SYNTAX FOR VIOLENCE
    ADD VARIABLE LABEL AND VALUE LABEL FOR
    H1DS2
    H1DS5
    H1DS6
    H1DS11
    H1DS14
    H1FV7
    H1FV8
    H1FV13
    r_H1DS2 
    r_H1DS5 
    r_H1DS6 
    r_H1DS11 
    r_H1DS14
    r_H1FV13.
    
MISSING VALUES
    H1DS2
    H1DS5
    H1DS6
    H1DS11
    H1DS14
    H1FV7
    H1FV8
    (6 8 9)
    /
    H1FV13
    (996 THRU 999).

RECODE
    H1DS2
    H1DS5
    H1DS6
    H1DS11
    H1DS14
    (0 = 0)
    (1 = 1)
    (2 = 2)
    (3 = 2)
    INTO    r_H1DS2
               r_H1DS5
               r_H1DS6
               r_H1DS11
               r_H1DS14.

RECODE
	H1FV13
	(0 = 0)
	(1 THRU 182 = 1)
	(183 THRU 365 = 2)
	INTO r_H1FV13.
EXECUTE.

VALUE LABELS
    r_H1DS2 r_H1DS5 r_H1DS6 r_H1DS11 r_H1DS14 0 'never' 1 'once' 2 'more than once'.
    
VALUE LABELS
    r_H1FV13 0 'never' 1 'sometimes' 2 'often'.
    
* computing violence variable.

COMPUTE VIOLENCE=MEAN(r_H1DS5,r_H1DS2,r_H1DS6,r_H1DS11,r_H1DS14,r_H1FV13,H1FV7,H1FV8).
EXECUTE.


* Encoding: UTF-8.
MISSING VALUES
    H1DS2
    H1DS5
    H1DS6
    H1DS11
    H1DS14
    H1FV7
    H1FV8
    (6 8 9)
    /
    H1FV13
    (996 THRU 999).

RECODE
    H1DS2
    H1DS5
    H1DS6
    H1DS11
    H1DS14
    (0 = 0)
    (1 = 1)
    (2 = 2)
    (3 = 2)
    INTO    r_H1DS2
               r_H1DS5
               r_H1DS6
               r_H1DS11
               r_H1DS14.

RECODE
	H1FV13
	(0 = 0)
	(1 THRU 182 = 1)
	(183 THRU 365 = 2)
	INTO r_H1FV13.
EXECUTE.

VALUE LABELS
    r_H1DS2 r_H1DS5 r_H1DS6 r_H1DS11 r_H1DS14 0 'never' 1 'once' 2 'more than once'.
    
VALUE LABELS
    r_H1FV13 0 'never' 1 'sometimes' 2 'often'.
    
* computing violence variable.

COMPUTE VIOLENCE=MEAN(r_H1DS5,r_H1DS2,r_H1DS6,r_H1DS11,r_H1DS14,r_H1FV13,H1FV7,H1FV8).
EXECUTE.

* Environment syntax.

* rename variable.

RENAME VARIABLES H1IR12=environment.
EXECUTE.
   
* add value labels.

VALUE LABELS
    environment 
    1 'rural' 
    2 'suburban' 
    3 'urban, residential only' 
    4 '3 or more commercial properties, mostly retail' 
    5 '3 or more commercial properties, mostly wholesale or industrial' 
    6 'other' 
    96 'refused' 
    98 'dont know' 
    99 'not applicable'.
EXECUTE.

* add missing values.

MISSING VALUES
    environment (6, 96 thru 99).
EXECUTE.

*add variable label to renamed variable environment. 

VARIABLE LABELS
    environment 'participant location of residence'.
EXECUTE.

* recoding values.

RECODE environment (1=1) (2=2) (3=3) (4=3) (5=3) INTO r_environment.
VARIABLE LABELS  r_environment 'new environment variable'.
EXECUTE.

*add value labels to recoded environment variable.

VALUE LABELS
    r_environment 1 'rural' 2 'suburban' 3 'urban'.

FREQUENCIES VARIABLES=r_environment
  /ORDER=ANALYSIS.

* running crosstabs to check work.

CROSSTABS
  /TABLES=r_environment BY environment
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT
  /COUNT ROUND CELL.

compute new_violence    = 0.
EXECUTE    .

DO IF (VIOLENCE= 0).
    COMPUTE new_violence = 0.
ELSE IF (VIOLENCE < 0.14).
    COMPUTE new_violence  = 1.
ELSE IF (VIOLENCE < 0.5).
    COMPUTE new_violence  = 2.
ELSE IF (VIOLENCE < 2).
    COMPUTE new_violence    = 3.
END IF.
VALUE LABELs
    NEW_VIOLENCE
    0 'NO VIOLENCE'
    1 'LOW VIOLENCE'
    2 'MED VIOLENCE'
    3 'HIGH VIOLENCE'.
EXECUTE.


