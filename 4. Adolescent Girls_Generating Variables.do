********************************************************************** 
* Jharkhand Adolescent Girls Study- Household Survey
* Date Created: 10th, April 2015
* author: Amanbir Singh, amanbir.s@gmail.com
* 
* Inputs: "Adolescent Girls.dta"
* 
* Outputs: "Adolescent Girls.dta" 
*
* This do-file takes the .dta file for Adolescent Girls data and 
* creates variables for self-efficacy and depression. These are 
* created using establisehd cut-offs for the gse and phq scales. 
* The variables created are low_self_efficacy and high_self_efficacy
* from the gse scale and min_depression, mild_depression, 
* moderate_depression, moderate_sev_depression and severe_depression. 
* A single cut-off depression variable is also created. 
* 
* 
* Date last edited: 14th September, 2015
********************************************************************** 

set more off


*** Local with location of the raw data
local jharkhand_folder "/Users/Sabinadewan/Box Sync/Jharkhand Statewide Adolescent Girls Study"

use "`jharkhand_folder'/Quantitative data and outputs/Adolescent Girls Data/Adolescent Girls.dta", clear

** psu_code
gen psu_code = substr(house_code, 3, 3)
destring psu_code, replace


** Psychosocial outcomes
* General Self-Efficacy (only for 15-24)
* Cut-off for low_self_efficacy is calculated by being 1 SD below the mean. high_self_efficacy is 
* 1 SD above the mean.
* source: NIH Toolbox, Scoring and Interpretation Guide pg.40
* http://www.nihtoolbox.org/WhatAndWhy/Scoring%20Manual/NIH%20Toolbox%20Scoring%20and%20Interpretation%20Manual%209-27-12.pdf
egen gse = rowtotal(adole_g10 adole_g11 adole_g12 adole_g13 adole_g14 adole_g15 adole_g16 adole_g17 adole_g18 adole_g19), missing
gen low_self_efficacy 	  = 1 if gse <=26.1523 & respondent_age>=15
replace low_self_efficacy = 0 if gse > 26.1523 & respondent_age>=15 & gse!=.

gen high_self_efficacy 	   = 1 if gse >=40.8131 & respondent_age>=15
replace high_self_efficacy = 0 if gse < 40.8131 & respondent_age>=15 & gse!=.


* Patient Health Questionnaire-9 (for all age groups)
* Source for all PHQ cut-offs: The PHQ-9: A New Depression Diagnostic and Severity Measure 
* by Kurt Kroenke, MD; and Robert L. Spitzer, MD
egen phq = rowtotal(adole_g1 adole_g2 adole_g3 adole_g4 adole_g5 adole_g6 adole_g7 adole_g8 adole_g9)
gen no_depression = phq >=1 & phq <=4
gen mild_depression = phq >=5 & phq <=9
gen moderate_depression = phq >=10 & phq <=14
gen moderate_sev_depression = phq >=15 & phq <=19
gen severe_depression = phq >=20 & phq <=27

gen depressed = phq >= 10


* variable and value labels for new variables
label variable gse "Raw General Self-Efficacy Scale"
label variable low_self_efficacy "Low Self-Efficacy (cut-off: 1 SD below mean)"
label variable high_self_efficacy "High Self-Efficacy (cut-off: 1 SD above mean)"

label variable phq  "Patient Health Questionnaire-9 Scale"
label variable no_depression  "No Depression (PHQ<=4)"
label variable mild_depression  "Mild Depression (5<=PHQ<=9)"
label variable moderate_depression  "Moderate Depression (10<=PHQ<=14)"
label variable moderate_sev_depression  "Moderately Severe (15<=PHQ<=19)"
label variable severe_depression  "Severe Depression (20<=PHQ)"

label variable depressed "Single-Point Depression (PHQ>=10)"


cap label define yesno 0 "No" 1 "Yes" -666 "Not Applicable" -777 "Refused to Answer" -999 "Do Not Know"
label values low_self_efficacy high_self_efficacy no_depression mild_depression moderate_depression ///
moderate_sev_depression severe_depression depressed yesno


* save
save "`jharkhand_folder'/Quantitative data and outputs/Adolescent Girls Data/Adolescent Girls.dta", replace
