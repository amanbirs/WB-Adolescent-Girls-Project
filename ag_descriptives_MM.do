**Descriptive statistics: Jharkhand adolescent girls**
**Author: Matthew Morton
**Updated: May 18, 2015
******************************************************

clear
global path "C:\Users\wb410929\Desktop\jk_analysis"
use  "$path\ag.dta"

**create age groups variable
gen agegroup=.
replace agegroup=1 if respondent_age>=10 & respondent_age<=14
replace agegroup=2 if respondent_age>=15 & respondent_age<=18
replace agegroup=3 if respondent_age>=19 & respondent_age<=24
recast byte agegroup
label define agegroup 1 "age 10-14" 2 "age 15-18" 3 "age 19-24"
label values agegroup agegroup

**neet
tab agegroup neet, row nof
proportion neet [pweight=indi_weight]
proportion neet [pweight=indi_weight], over(agegroup)

**self-efficacy
proportion low_self_efficacy [pweight=indi_weight], over(agegroup)
proportion low_self_efficacy [pweight=indi_weight], over(neet)
proportion low_self_efficacy [pweight=indi_weight]

**depression
*create depression variable (cut-off of 10)
gen depressed=.
replace depressed=1 if phq>=10
replace depressed=0 if phq<=9
*descriptives
proportion depressed [pweight=indi_weight]
proportion depressed [pweight=indi_weight], over(agegroup)
proportion depressed [pweight=indi_weight], over(neet)

