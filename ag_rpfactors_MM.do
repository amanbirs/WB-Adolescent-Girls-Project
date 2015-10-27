**Risk & protective factors analysis: Jharkhand adolescent girls**
**Author: Matthew Morton
**Updated: May 19, 2015
******************************************************

clear
global path "C:\Users\wb410929\Desktop\jk_analysis"
use  "$path\ag.dta"

merge 1:m house_code using "$path\hh.dta"

**risk & protective factor anayses

logistic neet low_self_efficacy respondent_age
logistic neet depressed respondent_age

logistic neet respondent_age psu_type any_migrant_HH hoh_work_outside spouse_work_outside  low_self_efficacy depressed

reg neet respondent_age psu_type any_migrant_HH hoh_work_outside spouse_work_outside  low_self_efficacy depressed
vif
*-> high collinearity between: hoh_work_outside spouse_work_outside --- drop one

************
**Using HH data w/imperfect match
************

clear
global path "C:\Users\wb410929\Desktop\jk_analysis"
use  "$path\ag.dta"

merge 1:m house_code using "$path\hh.dta"
*-> 161 observatoins not matched from using. Need to fix. 

* generating required variables 
gen sc = (house_a3==1)
gen st = (house_a3==2)
gen obc= (house_a3==3) // largest group
gen general= (house_a3==4) 

gen depressed = 1 if severe_depression==1| moderate_sev_depression== 1| moderate_depression== 1
replace depressed = 0 if mild_depression==1| min_depression== 1

gen has_living_child = (adole_i24>0) & (adole_i24!=.)

gen low_income= (house_a7<=30000)
gen middle_income= (house_a7>30000) & (house_a7<=60000)
gen high_income= (house_a7>60000)

gen never_married = (adole_i1==1)
gen currently_married = (adole_i1==3)

replace adole_c2opt7 = 1 if adole_c2opt7==7
replace adole_c2opt7 = 0 if adole_c2opt7==.

replace adole_c14opt2 = 1 if adole_c14opt2==2
replace adole_c14opt2 = 0 if adole_c14opt2==.

replace adole_f4=.a if adole_f4 == -777
replace adole_f4=.b if adole_f4 == -999
replace adole_f4 = adole_f4-1

gen school_under_30_min = 1 if adole_a20==1
replace school_under_30_min = 0 if adole_a20!=1 & adole_a20!=.

gen marital_status= .  
replace marital_status= 1 if adole_i1== 3
replace marital_status= 0 if adole_i1== 1  
 
gen birth_ever= . 
replace birth_ever= 1 if adole_i6== 1
replace birth_ever= 0 if adole_i6== 2 

ren house_d1 bpl_card
ren house_a7 annual_income
ren adole_b1 indi_earnings
ren adole_f4 ifa_tablets
ren house_a3 social_group
replace social_group =.a if social_group ==-999
replace social_group =.b if social_group ==-888

gen first_born= (birth_order==1) & (birth_order!=.)

replace first_born_son = 0 if first_born_son==.

**Analysis
reg neet sc st general respondent_age psu_type any_migrant_HH hoh_work_outside spouse_work_outside bpl_card annual_income ifa_tablets low_self_efficacy has_living_child land depressed
vif
*-> high collinearity between: hoh_work_outside spouse_work_outside --- drop one

logistic neet sc st general respondent_age psu_type any_migrant_HH hoh_work_outside bpl_card annual_income ifa_tablets low_self_efficacy has_living_child land depressed
*->depressed and low SE sig risk factors

*add weights using Amanbir's approach
logistic neet sc st general respondent_age psu_type any_migrant_HH hoh_work_outside bpl_card annual_income ifa_tablets low_self_efficacy has_living_child land depressed [pweight=hh_weight]
*->depressed and low SE insignicant 

***********************************
*******resetting weights through svy

clear
global path "C:\Users\wb410929\Desktop\jk_analysis"
use  "$path\ag.dta"

merge 1:m house_code using "$path\hh.dta"
*-> 161 observatoins not matched from using. Need to fix. 

drop if hh_weight==.

svyset psuid [w=hh_weight]

* generating required variables 
gen sc = (house_a3==1)
gen st = (house_a3==2)
gen obc= (house_a3==3) // largest group
gen general= (house_a3==4) 

gen depressed = 1 if severe_depression==1| moderate_sev_depression== 1| moderate_depression== 1
replace depressed = 0 if mild_depression==1| min_depression== 1

gen has_living_child = (adole_i24>0) & (adole_i24!=.)

gen low_income= (house_a7<=30000)
gen middle_income= (house_a7>30000) & (house_a7<=60000)
gen high_income= (house_a7>60000)

gen never_married = (adole_i1==1)
gen currently_married = (adole_i1==3)

replace adole_c2opt7 = 1 if adole_c2opt7==7
replace adole_c2opt7 = 0 if adole_c2opt7==.

replace adole_c14opt2 = 1 if adole_c14opt2==2
replace adole_c14opt2 = 0 if adole_c14opt2==.

replace adole_f4=.a if adole_f4 == -777
replace adole_f4=.b if adole_f4 == -999
replace adole_f4 = adole_f4-1

gen school_under_30_min = 1 if adole_a20==1
replace school_under_30_min = 0 if adole_a20!=1 & adole_a20!=.

gen marital_status= .  
replace marital_status= 1 if adole_i1== 3
replace marital_status= 0 if adole_i1== 1  
 
gen birth_ever= . 
replace birth_ever= 1 if adole_i6== 1
replace birth_ever= 0 if adole_i6== 2 

ren house_d1 bpl_card
ren house_a7 annual_income
ren adole_b1 indi_earnings
ren adole_f4 ifa_tablets
ren house_a3 social_group
replace social_group =.a if social_group ==-999
replace social_group =.b if social_group ==-888

gen first_born= (birth_order==1) & (birth_order!=.)

replace first_born_son = 0 if first_born_son==.

**Analysis
reg neet sc st general respondent_age psu_type any_migrant_HH hoh_work_outside spouse_work_outside bpl_card annual_income ifa_tablets low_self_efficacy has_living_child land depressed
vif
*-> high collinearity between: hoh_work_outside spouse_work_outside --- drop one

logistic neet sc st general respondent_age psu_type any_migrant_HH hoh_work_outside bpl_card annual_income ifa_tablets low_self_efficacy has_living_child land depressed
*->depressed and low SE sig risk factors

*add svy
svy: logistic neet sc st general respondent_age psu_type any_migrant_HH hoh_work_outside bpl_card annual_income ifa_tablets low_self_efficacy has_living_child land depressed
*->depressed and low SE insignicant 

*New variables for subpopulation analysis using survey data: Urban and Rural subpopulations
gen urru_urban=0
replace urru_urban=1 if selected_psu_urban==1
gen urru_rural=0
replace urru_rural=1 if selected_psu_rural==1

**urru subgroup analysis with weights
svy, subpop(urru_urban): logistic neet sc st general respondent_age any_migrant_HH hoh_work_outside bpl_card annual_income ifa_tablets low_self_efficacy has_living_child land depressed
svy, subpop(urru_rural): logistic neet sc st general respondent_age any_migrant_HH hoh_work_outside bpl_card annual_income ifa_tablets low_self_efficacy has_living_child land depressed

**urru subgroup analysis without weights
sort urru_urban
by urru_urban: logistic neet sc st general respondent_age any_migrant_HH hoh_work_outside bpl_card annual_income ifa_tablets low_self_efficacy has_living_child land depressed
