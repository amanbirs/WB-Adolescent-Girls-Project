**Adolescent Girls Project- Jharkhand: World Bank
**Author: Vatsala Shreeti

**Analysis of risk and protective factors
**In this do file, determinants of labor force participation rate among women aged 15-24 as well as of depression among women aged 15-24 are analysed.

**Merging the household survey data with the individual survey data for adolescent girls
use "C:\Users\Vatsala\Downloads\Household data.dta", clear

reshape long roster_id neet attending_education lfp house_a9 house_a10 ///
house_a11 house_a13 house_a14, i(house_code) j(hh_member)

 merge m:1 house_code roster_id using "C:\Users\Vatsala\Downloads\Adolescent Girls.dta
 
 **Labor force participation rate analysis for women aged 15-24
 
 drop if adole_groupnum== 1 // Age 10-14 are dropped
 
 **Creating dummy variables for birth order
 tabulate birth_order, generate(dummy)
 rename dummy1 birth_order_1
 rename dummy2 birth_order_2
 rename dummy3 birth_order_3
 rename dummy4 birth_order_4 
 rename dummy5 birth_order_5
 rename dummy6 birth_order_6
 
 **Renaming relevant variables 
 rename adole_i26 mother_age_marriage
 rename adole_i28 mother_work
 rename house_d1 bpl_card
 
 **Generating variables for marital status of the respondent and for birth history
 gen marital_status= . 
 replace marital_status= 1 if adole_i1== 3
 replace marital_status= 0 if adole_i1== 1 
 tab marital_status [fw= round(hh_weight)]
 
 gen birth_ever= .
 replace birth_ever= 1 if adole_i6== 1
 replace birth_ever= 0 if adole_i6== 2
 tab birth_ever [fw= round(hh_weight)]
 
 **Generating a variable for the respondent's mother's education
gen mother_education= .
local x 
forval x= 1/16 {
replace mother_education= 1 if adole_i27== `x'
}
replace mother_education= 0 if adole_i27== 17| adole_i27== 18

**Gender value aggregate (indicating values biased against women)
gen gender_value_biased= .
replace gender_value_biased= 1 if adole_i18== 1|adole_i19==1|adole_i20==1|adole_i21==1|adole_i22== 1
replace gender_value_biased= 0 if adole_i18==2 & adole_i19==2 & adole_i20==2 & adole_i21==2 & adole_i22== 2

**Social Network Aggregate
drop if adole_h6== -777| adole_h7== -777| adole_h8== -777|adole_h9== -777
egen social_network= rowtotal(adole_h6 adole_h7 adole_h8 adole_h9)
gen high_connectedness= 1 if social_network>= 8
replace high_connectedness= 0 if social_network<8

**PHQ depression aggregate
gen phq_dep= .
replace phq_dep= 1 if severe_depression==1| moderate_sev_depression== 1| moderate_depression== 1
replace phq_dep= 0 if mild_depression==1| min_depression== 1

**Logit regression for determinats of LFP among women aged 15-24 years. 


**Dependent variables include mother's education, marital status of respondent, presence of shocks, respondent residing in conflict district
**mother's age of marriage, presence of bpl card, high scoial connectedness, low self efficacy, phq depression indicator variable, 
**whether household owns land, whether respondent has ever given birth and mother's age of marriage
logit lfp mother_education marital_status any_shocks conflict_district mother_age_marriage mother_work bpl_card high_connectedness ///
phq_dep  low_self_efficacy land birth_ever [pweight= hh_weight], or

logit phq_dep lfp mother_education land marital_status land any_shocks conflict_district mother_age_marriage mother_work///
bpl_card high_connectedness  low_self_efficacy birth_ever [pweight= hh_weight], or
