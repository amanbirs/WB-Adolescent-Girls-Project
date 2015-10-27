********************************************************************** 
* Jharkhand Adolescent Girls Study- Analysis 
* Date Created: 10th May, 2015
* author: Amanbir Singh, amanbir.s@gmail.com
* 
* 
* Date last edited: 24th May, 2015
********************************************************************** 


* using adol data and merging with household data
use "/Users/Sabinadewan/Box Sync/Jharkhand Statewide Adolescent Girls Study/Quantitative data and outputs/Adolescent Girls Data/Adolescent Girls.dta" , clear
merge 1:1 house_code using "/Users/Sabinadewan/Box Sync/Jharkhand Statewide Adolescent Girls Study/Quantitative data and outputs/HH Survey Data/Household data.dta" ///
, keepusing(house_a3 hh_weight indi_weight house_d1 house_a7 land) 

* generating required variables 
gen sc = (house_a3==1)
gen st = (house_a3==2)
gen obc= (house_a3==3) // largest group
gen general= (house_a3==4) 

gen seperate_toilets = (adole_a18==1)
gen no_toilets = (adole_a18==3)

gen menstruation_sn = (adole_a28==1) 
gen menstruation_cloth = (adole_a28==2) 
gen menstruation_both = (adole_a28==3) 

gen aspiration_teacher = (adole_b3==2)

gen depressed = 1 if phq>10
replace depressed = 0 if phq<10

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

foreach i in adole_h6 adole_h7 adole_h9 adole_a3 adole_a18 adole_a21 adole_a22 adole_a23 adole_a24 {
replace `i'=.a if `i' == -777
replace `i'=.b if `i' == -999
replace `i'=.c if `i' == -666
}
gen connectedness = (adole_h6+adole_h7+adole_h9)
replace attending_education = 1 if attending_education_principal ==1 | attending_education_subsidiary==1
replace attending_education = 0 if attending_education == .


**************Logit regressions**************
* Since the psychosocial scales were not administered for respondents in the age group 11-14, 
* the data for these respondents is missing in this age range. Two models are being developed
* one with pschosocial outcomes for ages 15-24 and the other without, for ages 11-24.


* Logit for NEET Urban
logit neet sc st general respondent_age any_migrant_HH annual_income ///
low_self_efficacy currently_married first_born_son depressed if psu_type==1
cap drop pneet_urban_15_24
predict pneet_urban_15_24

logit neet sc st general respondent_age any_migrant_HH annual_income ///
ifa_tablets currently_married depressed first_born_son if psu_type==1
cap drop pneet_urban_11_24
predict pneet_urban_11_24


* Logit for NEET Rural
logit neet sc st general respondent_age any_migrant_HH annual_income ///
ifa_tablets low_self_efficacy currently_married land depressed if psu_type==2
cap drop pneet_rural_15_24
predict pneet_rural_15_24

logit neet sc st general respondent_age any_migrant_HH annual_income ///
ifa_tablets currently_married land depressed first_born_son if psu_type==2
cap drop pneet_rural_11_24
predict pneet_rural_11_24

* Logit for attending educational institution (11-17)
logit attending_education sc st general respondent_age annual_income ///
adole_a22 adole_a23 a4_religion_muslim a4_religion_christian a4_religion_sarna connectedness ///
adole_a24 seperate_toilets school_under_30_min  ///
if respondent_age >=11 & respondent_age<=17


logit attending_education sc st general respondent_age annual_income ///
land a4_religion_muslim a4_religion_christian a4_religion_sarna connectedness ///
seperate_toilets school_under_30_min if respondent_age >=11 & respondent_age<=17 & psu_type==2


**************Diagnostics**************
regress neet sc st general respondent_age psu_type any_migrant_HH bpl_card annual_income ///
ifa_tablets low_self_efficacy has_living_child land depressed
//Heteroskedasticity
rvfplot
estat hettest

//multicollinearity
estat vif


* prediction for neet
foreach i in pneet_urban_15_24 pneet_urban_11_24 pneet_rural_15_24 pneet_rural_11_24 {
	cap drop resid_* round_* diff_*
	gen resid_`i' = neet - `i'

	gen round_`i' = round(`i')
	gen diff_`i' = neet - round_`i'

	count if diff_`i' == 0
	local number_correct = `r(N)'

	count if diff_`i' != .
	local total_predictions = `r(N)'

	di "Percentage of correct predictions for the `i' model is  " 100*(`number_correct'/`total_predictions')
}


regress attending_education sc st annual_income psu_type bpl_card ///
school_under_30_min land i.birth_order adole_a18 adole_a23 if respondent_age >=11 & respondent_age<=17
//Heteroskedasticity
rvfplot
estat hettest

//multicollinearity
estat vif
