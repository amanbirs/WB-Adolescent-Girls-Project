********************************************************************** 
* Jharkhand Adolescent Girls Study- Household Survey
* Date Created: 26th, January 2015
* author: Amanbir Singh, amanbir.s@gmail.com
* 
* Inputs: "Household_Raw Data.csv"
* 
* Outputs: "Household Data.dta", "Adolescent Girls.dta"
*
* 
* This is the main data cleaning file for household data. In this
* do-file, the the household data is: 
* 1. Checking for errors and duplicates in data
* 2. Merging with Listing Data 
* 3. Labels
* 4. Generating weights for both hh and adolescent girls datasets
* 5. Generating additional variables for analysis including variables
*  	 from HH roster. These variables are also saved in the adolecent 
* 	 girls dataset.
*
* Date last edited: 14th September, 2015
********************************************************************** 

set more off


*** Local with location of the raw data
local jharkhand_folder "/Users/Sabinadewan/Box Sync/Jharkhand Statewide Adolescent Girls Study"

cd "`jharkhand_folder'/Quantitative data and outputs/Do-Files"


*** tempfile for errors
cap gen house_code = .
tempfile errors
save `errors'

tempfile code_duplicates 
save `code_duplicates'

*** folders for errors
cap mkdir "`jharkhand_folder'/Quantitative data and outputs/Errors"
cap mkdir "`jharkhand_folder'/Quantitative data and outputs/Errors/`c(current_date)'"

local errors_folder "`jharkhand_folder'/Quantitative data and outputs/Errors/`c(current_date)'"


*** Importing Raw Data--.csv file
insheet using "`jharkhand_folder'/Quantitative data and outputs/Raw Data/Household_Raw Data.csv", clear

save "`jharkhand_folder'/Quantitative data and outputs/Raw Data/Household_Raw Data.dta", replace 

**** Weights
* Getting total urban and rural populations for Jharkhand
insheet using "/Users/Sabinadewan/Box Sync/Jharkhand Statewide Adolescent Girls Study/Sampling files/Jharkahnd-Urban Areas.csv", clear
keep if level == "DISTRICT"

egen total_urban_hh = total(hh)
local total_urban_hh = total_urban_hh

egen total_urban_pop = total(tot_p)
local total_urban_pop = total_urban_pop


insheet using "/Users/Sabinadewan/Box Sync/Jharkhand Statewide Adolescent Girls Study/Sampling files/Village List-Jharkhand.xlsx", clear

egen total_rural_hh = total(hh)
local total_rural_hh = total_rural_hh

egen total_rural_pop = total(tot_p)
local total_rural_pop = total_rural_pop 


* importing rural/urban variable from adolescent girls dataset
use "`jharkhand_folder'/Quantitative data and outputs/Raw Data/Household_Raw Data.dta", clear

*replace house_code = house_replacecode if house_replacehouse == 1

* error check for duplicate house_codes
duplicates tag house_code, gen(hh_dups)
qui count if hh_dups>0
if `r(N)'>0 {
	preserve 

	keep if hh_dups>0
	outsheet using "`errors_folder'/hh_house_code duplicates.csv", comma replace
	
	restore
}
duplicates drop house_code, force


* merging with adolescent girls 
merge 1:1 house_code using "`jharkhand_folder'/Quantitative data and outputs/Adolescent Girls Data/Adolescent Girls.dta", keepusing(psu_type adole_groupnum)
drop if group_num == 5

* error check for hh codes that do not match
qui count if _merge != 3 
if `r(N)'>0 {
	preserve 

	keep if _merge != 3
	outsheet using "`errors_folder'/hh_adol_house_codes.csv", comma replace
	
	restore
}
drop if _merge!=3

* extracting psu_code from house_code
gen psu_code = substr(house_code, 3, 3)
replace psu_code = subinstr(psu_code, "-", "", .)
replace psu_code = "62" if psu_code=="o62"
destring psu_code, replace


* merging household data with populations of selected psus 
drop _merge
merge m:1 psu_code using "/Users/Sabinadewan/Box Sync/Jharkhand Statewide Adolescent Girls Study/Quantitative data and outputs/PSU Codes_2204.dta", keepusing(no_hh tot_p census_psuid psu_code)

* PSUs from Jagan's list that are not in the hh survey
qui count if _merge==2
if `r(N)'>0 {
	preserve 

	keep if _merge==2
	outsheet using "`errors_folder'/hh_extra_psu_code.csv", comma replace
	
	restore
}
drop if _merge==2


drop _merge 
ren census_psuid psuid
merge m:1 psuid using "/Users/Sabinadewan/Box Sync/Jharkhand Statewide Adolescent Girls Study/Sampling files/Selected_Jharkhand.dta"

* PSUs from Sample not in the hh survey
qui count if _merge==2
if `r(N)'>0 {
	preserve 

	keep if _merge==2
	outsheet using "`errors_folder'/psu_codes_not_in_hh.csv", comma replace
	
	restore
}
drop if _merge==2

****** merging with listing data
drop _merge
/*
replace house_code = subinstr(house_code, "((", "(", .)

split house_code, parse("-")

* house_code1
replace house_code1 = upper(house_code1)

* house_code3 & house_code4
split house_code3, parse("(")

replace house_code3 = house_code31
gen house_code4 = house_code32 
replace house_code4 = subinstr(house_code4, ")", "", .)
replace house_code4 = subinstr(house_code4, "(", "", .)

* capturing rows with errors in house_code
qui count if house_code4==""
if `r(N)'>0 {
	preserve 

	keep if house_code4==""
	outsheet using "`errors_folder'/hh_house_code.csv", comma replace
	
	restore
}
drop if house_code4=="" //these are captured above

destring house_code2 house_code3 house_code4, replace 
drop house_code31 house_code32 
*/

* merging with listing data
merge 1:1 house_code using "/Users/Sabinadewan/Box Sync/Jharkhand Statewide Adolescent Girls Study/Quantitative data and outputs/Listing/House_listing.dta", /// 
keepusing(noofhhselectedh15 noofhhlistedh13 noofhhselectedh25 noofhhlistedh23 noofhhselected35 noofhhlisted33 noofhhselected45 noofhhlisted43 response_rate_*)

qui count if _merge==1
if `r(N)'>0 {
	preserve 

	keep if _merge==1
	outsheet using "`errors_folder'/hh_listing_codes.csv", comma replace
	
	restore
}
drop if _merge ==2 //dropping listed hh that were not sampled for adolescent surveys
drop _merge

* Prob of selection of PSU
gen prob_urban_psu = (no_hh*45)/`total_urban_hh' if psu_type==1
gen prob_rural_psu = (no_hh*105)/`total_rural_hh' if psu_type==2


* prob of selection of hh within PSU
gen prob_hh_per_psu = noofhhselectedh15/noofhhlistedh13 if adole_groupnum ==1
replace prob_hh_per_psu = noofhhselectedh25/noofhhlistedh23 if adole_groupnum ==2
replace prob_hh_per_psu = noofhhselected35/noofhhlisted33 if adole_groupnum ==3
replace prob_hh_per_psu = noofhhselected45/noofhhlisted43 if adole_groupnum ==4


* HH-Weight
gen hh_weight 	  = 1/(prob_urban_psu*prob_hh_per_psu) if psu_type == 1
replace hh_weight = 1/(prob_rural_psu*prob_hh_per_psu) if psu_type == 2

* Individual-Weight
gen 	indi_weight = hh_weight*(1/response_rate_11_15) if adole_groupnum ==1
replace indi_weight = hh_weight*(1/response_rate_16_18) if adole_groupnum ==2
replace indi_weight = hh_weight*(1/response_rate_19_21) if adole_groupnum ==3
replace indi_weight = hh_weight*(1/response_rate_22_24) if adole_groupnum ==4


*** Splitting multiple choice variables
reshape_multiple_choices house_a3 a3_caste_sc a3_caste_st a3_caste_obc a3_caste_general a3_caste_other(-888) ///
							      a3_caste_refused(-777) a3_caste_dnk(-999)

replace house_a4other= proper(house_a4other)
replace house_a4=4 if house_a4other == "Sarna"
reshape_multiple_choices house_a4 a4_religion_hindu a4_religion_muslim a4_religion_christian a4_religion_sarna a4_religion_other(-888) ///
								  a4_religion_refused(-777) a4_religion_dnk(-999)

reshape_multiple_choices house_a5 a5_language_hindi a5_language_urdu a5_language_nagpuri a5_language_bhojpuri ///
								  a5_language_sadri a5_language_other(-888) a5_language_refused(-777)

		
// roster begins here
forval i = 1/25{
	reshape_multiple_choices house_a14`i' a14_education_primary`i'(1) a14_education_primary`i'(2) a14_education_primary`i'(3) ///
	a14_education_primary`i'(4) a14_education_primary`i'(5) a14_education_middle_school`i'(6) a14_education_middle_school`i'(7) ///
	a14_education_middle_school`i'(8) a14_education_secondary`i'(9) 

	reshape_multiple_choices house_a14`i' a14_education_secondary`i'(10) a14_education_secondary`i'(11) a14_education_secondary`i'(12) 


	reshape_multiple_choices house_a21`i' a21_self_employed`i'(11) a21_self_employed`i'(12) a21_self_employed`i'(21) ///
	a21_regular_wage_employee`i'(31) a21_casual_wage_labour`i'(41) a21_casual_wage_labour`i'(51) 

	reshape_multiple_choices house_a21`i' a21_unemployed_seeking_work`i'(81) a21_not_labour_force`i'(91) a21_not_labour_force`i'(92) ///
	a21_not_labour_force`i'(93) a21_not_labour_force`i'(94) a21_not_labour_force`i'(95) a21_other`i'(-888)	

 	gen student`i' = (house_a13`i'==2)
	
	reshape_multiple_choices house_a30`i' a30_pf`i'(1) a30_pf`i'(4) a30_pf`i'(5) a30_pf`i'(7) 
}

tostring house_a22*, replace


egen students_hh = rowtotal(student*)
egen unemp_hh = rowtotal(*_unemployed_seeking_work*)
egen pf_hh = rowtotal(*_pf*)
egen no_reg_sal = rowtotal(*_regular_wage_employee*)
egen no_selfemp = rowtotal(*_self_employed*)

************ Asset index *****************
	ren house_b1 hh_ownership
	gen house=(hh_ownership==1)
	la var house "HH owns their house"

	ren house_b2 wall_type
	gen pukka_wall=(wall_type==5|wall_type==6|wall_type==7|wall_type==8|wall_type==9)
	la var pukka_wall "HH has pukka walls"

	ren house_b3 roof_type
	gen pukka_roof=(roof_type==3|roof_type==4|roof_type==5|roof_type==6|roof_type==7|roof_type==8|roof_type==9)
	la var pukka_roof "HH has pukka roof"
	 
	ren house_b4 no_floors
	gen floors=(no_floors>1)
	la var floors "HH has > 1 floor for own use"

	ren house_b5 no_rooms
	gen rooms=(no_rooms>1)
	la var rooms "HH has > 1 room for own use"

	ren house_b9 water_source

	gen tap=(water_source ==1)
	la var tap "Drinking water connect at home"

	ren house_b10 elect_source
	gen bijli=(elect_source==1)
	la var bijli "HH has electricity connection"

	ren house_b11 latrine
	recode latrine (2=0)
	la var latrine "HH has water sealed latrine inside the home" 

	ren house_b12 toilet_type

	gen community_toilet=(toilet_type==1 & latrine==1)
	la var community_toilet "HH reports using community toilet"

	gen uses_toilets=(toilet_type!=2)
	la var uses_toilets "HH no own toilet but does not defacate in open & uses toilets"

	ren house_b13 drain_type
	gen closed_drain=(drain_type==1)
	la var closed_drain "HH uses closed drains for sewage" 

	gen open_drain=(drain_type==2)
	la var open_drain "HH uses open drains for sewage"

	gen drain_hh=(drain_type!=3)
	la var drain_hh "HH has access to drainage system for sewage"

	ren house_b14 kitchen
	recode kitchen (2=0)
	la var kitchen "HH has separate room for kitchen" 

	tab kitchen rooms /*Some inconsistency here as 117 households report only having one room but say they have a separate room for kitchen, will not use Rooms but only use kitchen for asset index as cleanly interpreted and understood by interviewer and respondent*/

	ren house_b15 fridge
	recode fridge (2=0)

	ren house_b16 phone_type
	gen phone=(phone_type==1|phone_type==3)
	la var phone "HH has landline connection" 

	gen mobile_only=(phone_type==2)
	la var mobile_only "HH reports only posessing mobile phone connection"

	gen comp_laptop=(house_b17!=3)
	la var comp_laptop "HH has Computer/Laptop"

	gen internet=(house_b17==1)
	la var internet "HH has internet connection"

	gen vehicle=(house_b18opt4!=4)
	la var vehicle "HH has motorized vehicle"

	foreach var in house_b20 house_b21 house_b22 house_b23 house_b24 house_b25 {
		recode `var' (2=0)
		}

	ren house_b20 ac
	la var ac "HH has AirConditioner"

	ren house_b21 wash_mach
	la var wash_mach "HH has wash_mach"

	ren house_b22 cot
	la var cot "HH has Steel/Wooden Sleeping cot"

	ren house_b23 watch
	la var watch "HH has watch/Clock"

	ren house_b24 radio
	la var radio "HH has radio/Transistor"

	ren house_b25 tv_type
	gen TV=(tv_type!=3)
	la var TV "HH has Colour/Black and White TV"

	ren house_b26 cycle
	la var cycle "HH has cycle"

	ren house_b27 own_land
	gen land=(own_land==1)
	la var land "HH owns land"

	* created in do-file2
	la var students_hh "No. of Students in HH"

	la var unemp_hh "No. of Unemployed in HH"  
	la var pf_hh "No. of Formal workers with pf in HH" 

	gen pf=(pf_hh>0)
	la var pf "HH has mem who recieve pf"

	la var no_reg_sal "No. of Regular Salaried workers in HH"

	gen reg_sal=(no_reg_sal>0)
	la var reg_sal "HH has Regular Salaried Workers"
	
	la var no_selfemp "No. of self-employed in HH"
	
	*ASSET INDEX -- URBAN
	pca house rooms pukka_wall pukka_roof floors tap bijli latrine kitchen fridge phone comp_laptop internet vehicle ac wash_mach cot watch radio cycle TV land [aw=hh_weight] if psu_type==1, factors(1) 
	predict asset_urban if psu_type==1
	xtile rankasset_urban=asset_urban [aw=hh_weight],nq(5)
	
	tab rankasset_urban

	*ASSET INDEX -- RURAL
	pca house pukka_wall pukka_roof floors rooms tap bijli toilet_type kitchen open_drain mobile_only comp_laptop vehicle TV land [aw=hh_weight] if psu_type==2, factors(1) 
	predict asset_rural if psu_type ==2
	xtile rankasset_rural=asset_rural [aw=hh_weight],nq(5)
	
	tab rankasset_rural


	gen asset_poor=(rankasset_rural <=3) | (rankasset_urban<=3)
	label var asset_poor "Bottom 3 on asset index"

**********************************

tostring house_a8fname*, replace
tostring house_a8lname*, replace

* any migrant from the household
egen any_migrant_HH = anymatch(house_a19*), values(1)


* hoh/spouse work outside home
gen hoh_work_outside 	= 0
gen spouse_work_outside = 0
forval i=1/25{
	replace hoh_work_outside = 1 if house_a10`i'==1  & house_a24`i'==14 | house_a24`i'==15 | ///
									house_a24`i'==16 | house_a24`i'==17 | house_a24`i'==18 | ///
									house_a24`i'==31 | house_a24`i'==24 | house_a24`i'==25 | ///
									house_a24`i'==26 | house_a24`i'==27 | house_a24`i'==28 | ///
									house_a24`i'==41
							
	replace spouse_work_outside = 1 if house_a10`i'==2  & house_a24`i'==14 | house_a24`i'==15 | ///
									   house_a24`i'==16 | house_a24`i'==17 | house_a24`i'==18 | ///
									   house_a24`i'==31 | house_a24`i'==24 | house_a24`i'==25 | ///
									   house_a24`i'==26 | house_a24`i'==27 | house_a24`i'==28 | ///
									   house_a24`i'==41
}

*** NEET
forval i=1/25{
	cap gen neet`i' = 0
	replace neet`i' = (house_a21`i'==92 | house_a21`i'==93 | house_a21`i'==94 | house_a21`i'==95)
}

*** Attending Educational Institution variables, attending training
forval i=1/25{
	gen attending_education`i' = .
	replace attending_education`i' = 1 if (house_a21`i'== 91 | house_a34`i'== 91)
	replace attending_education`i' = 0 if (attending_education`i'==.)

	cap gen attending_education_principal`i' = .
	replace attending_education_principal`i' = 1 if (house_a21`i'== 91)
	replace attending_education_principal`i' = 0 if (attending_education_principal`i'==.)

	cap gen attending_education_subsidiary`i' = .
	replace attending_education_subsidiary`i' = 1 if (house_a34`i'== 91)
	replace attending_education_subsidiary`i' = 0 if (attending_education_subsidiary`i'==.)

	cap gen attending_training`i' = .
	replace attending_training`i' = 1 if (house_a13`i'== 13)
	replace attending_training`i' = 0 if (attending_training`i'==.)	
}

*** LFP (15-24)
forval i=1/25{
	cap gen lfp`i' = .

	replace lfp`i' = 1 if (house_a21`i'!=91 & house_a21`i'!=92 & house_a21`i'!=93 & house_a21`i'!=94 & ///
	house_a21`i'!=95) & (house_a9`i'<24 & house_a9`i'>15)

	replace lfp`i' = 0 if lfp`i'==. & (house_a9`i'<24 & house_a9`i'>15)
}


** Regions; defined as per 2001 districts
gen dist_number_2001 = .
replace dist_number_2001 = 1  if district_number == 6  //"Garhwa"
replace dist_number_2001 = 2  if district_number == 17 //"Palamu"
replace dist_number_2001 = 3  if district_number == 2  //"Chatra"
replace dist_number_2001 = 4  if district_number == 10 //"Hazaribag"
replace dist_number_2001 = 5  if district_number == 13 //"Kodarma"
replace dist_number_2001 = 6  if district_number == 7  //"Giridih"
replace dist_number_2001 = 7  if district_number == 3  //"Deoghar"
replace dist_number_2001 = 8  if district_number == 8  //"Godda"
replace dist_number_2001 = 9  if district_number == 22 //"Sahibganj"
replace dist_number_2001 = 10 if district_number == 16 //"Pakaur"
replace dist_number_2001 = 11 if district_number == 5  //"Dumka"
replace dist_number_2001 = 12 if district_number == 4  //"Dhanbad"
replace dist_number_2001 = 13 if district_number == 1  //"Bokaro"
replace dist_number_2001 = 14 if district_number == 21 //"Ranchi"
replace dist_number_2001 = 15 if district_number == 15 //"Lohardaga"
replace dist_number_2001 = 16 if district_number == 9  //"Gumla"
replace dist_number_2001 = 17 if district_number == 18 //"Pashchimi Singhbhum"
replace dist_number_2001 = 18 if district_number == 19 //"Purbi Singhbhum"


replace dist_number_2001 = 2  if district_number == 14 // Latehar, formerly part of Palamu
replace dist_number_2001 = 4  if district_number == 20 // Ramgarh, formerly part of Hazaribag
replace dist_number_2001 = 16 if district_number == 24 // Simdega, formerly part of Gumla
replace dist_number_2001 = 14 if district_number == 12 // Khunti, formerly part of Ranchi
replace dist_number_2001 = 17 if district_number == 23 // Saraikela Kharsawan, formerly part of Pashchimi Singhbhum
replace dist_number_2001 = 11 if district_number == 11 // Jamtara, formerly part of Dumka


* taken from Home Ministry list of districts under Security Related Expenditure Scheme
gen conflict_district = (district_number ==1 | district_number ==2 | district_number ==4 | district_number ==19 | ///
district_number ==6  | district_number ==7  | district_number ==9  | district_number ==10 | district_number==13 | ///
district_number ==14 | district_number ==15 | district_number ==17 | district_number ==21 | district_number ==24 | ///
district_number ==23 | district_number ==18 | district_number ==12 | district_number ==20 | district_number ==5 | ///
district_number ==3  | district_number ==16 )


gen region_sp = 201 if dist_number_2001 == 1 | dist_number_2001 == 16 | dist_number_2001 == 2 | ///
dist_number_2001 == 14 | dist_number_2001 == 15 | dist_number_2001 == 17 | dist_number_2001 == 18

replace region_sp = 202 if dist_number_2001 == 3 | dist_number_2001 == 4 | dist_number_2001 == 5 | ///
dist_number_2001 == 6  | dist_number_2001 == 7  | dist_number_2001 == 8  | dist_number_2001 == 9 | ///
dist_number_2001 == 10 | dist_number_2001 == 11 | dist_number_2001 == 12 | dist_number_2001 == 13


* Shocks 
gen any_shocks=0
forval i = 1/9{
	replace any_shocks=1 if house_e1event`i'==1  
}


*** Formatting
* formating phone numbers, dates and time
format primetele_no alttele_no %10.0g

gen survey_date1 = date(survey_date, "YMD")
format survey_date1 %tdCCYY-mm-DD //This isn't working properly for some 


* recoding multiple variable responses to 1/0
foreach i in house_b18opt1 house_b18opt2 house_b18opt3 house_b18opt4 {
	recode `i' -777/4=1
	recode `i' .=0 
}



*** Variable Labels 
label drop _all

label variable house_replacecode "Household Code for Replacement Household"
label variable primetele_no "Primary Telephone Number"
label variable alttele_no "Alternate Telephone Number"

label variable group_num "Group Number"
label variable house_replacehouse "Replacement Household"
label variable house_replacecode  "Code for replacement household"
label variable house_contactedb4rpl "Number of times contacted before replacement"
label variable house_replacereason  "Reason for Replacement"
label variable house_replacereasonother "Reason for Replacement. Other, Specify"


label variable district_number "District Number"
label variable block_name "Block Name"
label variable gp_name "Gram Panchayat Name"
label variable village_name "Village Name"
label variable respondent_fname "Respondent First Name"
label variable respondent_lname "Respondent Last Name"

label variable psu_type "Rural or Urban"
label variable psu_code "Code for PSU"

label variable any_migrant_HH "Any migrants from the HH within last 3 yrs?"

// Section A
label variable house_a1 "How many people eat together in your house?"
label variable house_a2 "Who is the head of the household?"
label variable house_a3 "Caste of the head of household"

label variable house_a3other "Caste of the head of household. Other, Specify"

label variable house_a4 "Religion of the head of household"
label variable house_a4other "Religion of the head of household. Other, Specify"

label variable house_a5 "Primary language of the Head of the Household"
label variable house_a5other "Primary language of the Head of the Household. Other, Specify"

label variable house_a7 "What is the annual income of the household?"

// Section A-Roster
forval i = 1/25{
	label variable house_a8fname`i' "HH Member `i': First Name"
	label variable house_a8lname`i' "HH Member `i': Last Name"
	label variable house_a9`i' 		"HH Member `i': Completed Age"
	label variable house_a10`i' 	"HH Member `i': Relationship with Household Head"
	label variable house_a10other`i' "HH Member `i': Relationship with Household Head (other)"
	label variable house_a11`i' "HH Member `i': Sex"
	label variable house_a12`i' "HH Member `i': Marital Status (If age>=10)"
	label variable house_a13`i' "HH Member `i': Education Status"
	label variable house_a13_1`i' "HH Member `i': Private/Public Institution"	
	label variable house_a14`i' "HH Member `i': Highest Education Level"
	label variable house_a15`i' "HH Member `i': Can this person Read/ Write?"
	label variable house_a17`i' "HH Member `i': Cash Transfer (Y/N)"
	label variable house_a18`i' "HH Member `i': In-Kind Transfer (Y/N)"
	label variable house_a19`i' "HH Member `i': Migrated in the Last 3 Years (Y/N)"

	label variable house_a21`i' "HH Member `i': Usual Principal Activity Status"
	label variable a21_other`i' "HH Member `i': Principal Activity Status. Other, Specify"
	label variable house_a22`i' "HH Member `i': Usual Principal Activity Occupation"
	label variable house_a23`i' "HH Member `i': Engaged in Any Subsidiary Capacity (Y/N)"
	label variable house_a24`i' "HH Member `i': Principal Activity Location of Workplace"
	label variable house_a24other`i' "HH Member `i': Usual Principal Activity Location of Workplace (other)"
	label variable house_a25`i' "HH Member `i': Usual Principal Activity Enterprise Type"
	label variable house_a25other`i' "HH Member `i': Usual Principal Activity Enterprise Type (other)"
	label variable house_a27`i' "HH Member `i': Usual Principal Activity No. of Workers"
	label variable house_a28`i' "HH Member `i': Usual Principal Activity Type of Contract"
	label variable house_a30`i' "HH Member `i': Usual Principal Activity Availability of Social Security Benefits"
	label variable a30_pf`i' 	"HH Member `i': Usual Principal Activity, is PF available at workplace?"
	label variable house_a32`i' "HH Member `i': Usual Principal Activity Available for Work During Last 365 Days (Age>5)"

	label variable house_a34`i' "HH Member `i': Usual Subsidiary Activity Status"
	label variable house_a35`i' "HH Member `i': Usual Subsidiary Activity Occupation"
	label variable house_a36`i' "HH Member `i': Usual Subsidiary Activity Location of Workplace"
	label variable house_a36other`i' "HH Member `i': Usual Subsidiary Activity Location of Workplace (other)"
	label variable house_a37`i' "HH Member `i': Usual Subsidiary Activity Enterprise Type"
	label variable house_a37other`i' "HH Member `i': Usual Subsidiary Activity Enterprise Type (other)"
	label variable house_a39`i' "HH Member `i': Usual Subsidiary Activity Number of Workers in Enterprise"
	label variable house_a40`i' "HH Member `i': Usual Subsidiary Activity Type of Contract"
	label variable house_a42`i' "HH Member `i': Usual Subsidiary Activity Availability of Social Security Benefits"
}


// Section B
label variable hh_ownership "Ownership Status of the house"
label variable wall_type 	"Predominant material of wall of dwelling room "
label variable roof_type 	"Predominant material of roof of dwelling room "
label variable no_floors 	"Number of Stories/Floor-Levels exclusively in the possession of this household"
label variable no_rooms 	"Number of dwelling rooms exclusively in possession of this household"
label variable house_b6 	"Number of Pucca Rooms"
label variable house_b7 	"Number of Kuccha Rooms"
label variable house_b8 	"Number of Semi-Pucca Rooms"
label variable water_source "Availability of drinking water sources"
label variable elect_source "Main Source of Lighting"
label variable latrine 		"Water-Seal Latrine Exclusively for the Household"
label variable toilet_type 	"What Toilet Does the Household Use"
label variable drain_type 	"Waste Water Outlet is Connected to"
label variable kitchen 		"Seperate Room Used as Kitchen Exclusively (Y/N)"

label variable fridge 			"Assets: Refrigerator"
label variable phone_type 		"Assets: Telephone"
label variable house_b17 		"Assets: Computer/Laptop"
label variable house_b18opt1 	"Assets: Two Wheeler"
label variable house_b18opt2 	"Assets: Three Wheeler"
label variable house_b18opt3 	"Assets: Four Wheeler"
label variable house_b18opt4 	"Assets: None"
label variable house_b19 		"Assets: Is the Motorized Vehicle Used Commercially?"
label variable ac 				"Assets: Air Conditioner"
label variable wash_mach 		"Assets: Washing Machine"
label variable cot 				"Assets: Wooden/Steel Sleeping Cot"
label variable watch 			"Assets: Clock/Watch/Time Piece"
label variable radio 			"Assets: Radio/Transistor"
label variable tv_type 			"Assets: Television"
label variable cycle 			"Assets: Bicycle"
label variable own_land 		"Assets: Land (excluding homestead)"
label variable house_b28 		"Assets: Irrigated Land (amount)"
label variable house_b28unit 	"Assets: Irrigated Land (unit)"
label variable house_b28unitother "Assets: Irrigated Land (unit-other)"
label variable house_b29 		"Assets: Unirrigated Land (amount)"
label variable house_b29unit 	"Assets: Unirrigated Land (unit)"
label variable house_b29unitother "Assets: Unirrigated Land (unit-other)"


// Section C
label variable house_c1 "Typical week: how much do you spend on food for the household?"
label variable house_c2 "Typical week: how many times do you eat the following: Eggs, Fish, Meat or chicken, Dairy products"
label variable house_c3 "Past 4 Weeks: did you worry that your household would not have enough food?"
label variable house_c4 "Past 4 Weeks: did you or any household member eat a smaller meal because there was not enough food?"
label variable house_c5 "Past 4 Weeks: did you or any other household member eat fewer meals because there was not enough food?"
label variable house_c6 "Past 4 Weeks: did you or any household member go to sleep at night hungry because there was not enough food?"
label variable house_c7 "Last 1 Year: Spending on Education"
label variable house_c8 "Last 1 Year: Spending on Healthcare"
label variable house_c9 "Compared to other households, how would you describe your household?"


// Section D
label variable house_d1 "Below Poverty Line Card (Y/N)"
label variable house_d2 "Enrolled in RSBY (Y/N)"
label variable house_d3 "Has anyone in the household received any health services using this RSBY card?"
label variable house_d4 "When members of your household get sick, where do they mainly go for treatment?"
label variable house_d4other "When members of your household get sick, where do they mainly go for treatment? (other)"
label variable house_d5 "Why donÕt members of your household generally go to a government facility when they are sick?"

// Section E
label variable house_e1event1 "Has your household faced Hospitalization of Family Member in the past 3 years?"
label variable house_e1event2 "Has your household faced Eviction from Locality in the past 3 years?"
label variable house_e1event3 "Has your household Organized a Wedding/ Funeral/ other major ceremony in the past 3 years?"
label variable house_e1event4 "Has your household faced the death of a household member in the past 3 years?"
label variable house_e1event5 "Has your household faced Natural Disaster (e.g., flood, typhoon, earthquake) in the past 3 years?"
label variable house_e1event6 "Has your household faced Fire/Riots harmed property in the past 3 years?"
label variable house_e1event7 "Has your household faced theft or violence in the past 3 years?"
label variable house_e1event8 "Has your household faced drought, frost, or other condition of nature that significantly reduced crop yields, past 3 years?"
label variable house_e1event9 "Has your household seen organized migration of self/family members in the past 3 years?"

label variable house_e1eventfrq1 "How many times in the past 3 years: faced Hospitalization of Family Member"
label variable house_e1eventfrq2 "How many times in the past 3 years: faced Eviction from Locality"
label variable house_e1eventfrq3 "How many times in the past 3 years: Organized a Wedding/ Funeral/ other major ceremony"
label variable house_e1eventfrq4 "How many times in the past 3 years: death of a household member"
label variable house_e1eventfrq5 "How many times in the past 3 years: Natural Disaster (e.g., flood, typhoon, earthquake)"
label variable house_e1eventfrq6 "How many times in the past 3 years: Fire/Riots harmed property"
label variable house_e1eventfrq7 "How many times in the past 3 years: theft or violence"
label variable house_e1eventfrq8 "How many times in the past 3 years: drought, frost, or other condition of nature that significantly reduced crop yields, past 3 years?"
label variable house_e1eventfrq9 "How many times in the past 3 years: organized migration of self/family members"


*** Value Labels 
label define groups 1 "Adolescent 11-14" 2 "Adolescent 15-17" 3 "Adolescent 18-21" ///
4 "Adolescent 22-24" 5 "Widow over 24"
label values group_num groups 

label define rural_urban 1 "Urban" 2 "Rural"
label values psu_type rural_urban



label define caste 1 "SC" 2 "ST" 3 "OBC" 4 "General" -777 "Refused to Answer" -888 "Other" -999 "Does not Know"
label values house_a3 caste

label define religion 1 "Hindu" 2 "Muslim" 3 "Christian" 4 "Sarna" -777 "Refused to Answer" -888 "Other" -999 "Does not Know"
label values house_a4 religion

label define public_school 1 "Public" 2 "Private"
label values house_a13_1* public_school

label define house_ownership 1 "Owned" 2 "Rented" 3 "Shared" 4 "Living on premises with employer" ///
							 5 "House provided by the employer" 6 "Any other"					 
label values hh_ownership house_ownership

label define wall_material 1 "Grass / thatch / bamboo etc" 2 "Plastic / polythene" 3 "Mud/Unburnt brick" ///
						   4 "Wood" 5 "Stone not packed with mortar" 6 "Stone packed with mortar" ///
						   7 "G.I. / metal / asbestos sheets" 8 "Burnt brick" 9 "Concrete" 10 "Stone with Mud" ///
						   11 "Any other"
label values wall_type wall_material

label define roof_material 1 "Grass / thatch / bamboo/ wood / mud etc" 2 "Plastic / polythene" 3 "Hand made tiles" ///
						   4 "Machine made tiles" 5 "Burnt brick" 6 "Stone" 7 "Slate" ///
						   8 "G.I./ metal/asbestos sheets" 9 "Concrete" 10 "Khapra" ///
						   11 "Any other"
label values roof_type roof_material

label define drinking_water 1 "Within the premises" 2 "Near the premises" 3 "Away"
label values water_source drinking_water

label define lighting 1 "Electricity" 2 "Kerosene" 3 "Solar" 4 "Other Oil" 5 "Any other" 6 "No Lighting"
label values elect_source lighting

label define toilet 1 "Community toilet" 2 "Open Toilet" 3 "Own Toilet" 4 "others"
label values toilet_type toilet

label define drainage 1 "Closed drainage" 2 "Open drainage" 3 "No drainage"
label values drain_type drainage

label define telephone 1 "Landline only" 2 "Mobile only" 3 "Both" 4 "Neither"
label values phone_type telephone

label define computer_laptop 1 "Yes, with internet" 2 "Yes, without internet" 3 "No"
label values house_b17 computer_laptop

label define tv 1 "Yes, colour" 2 "Yes, B&W" 3 "No"
label values phone_type tv

label define land_unit 1 "Hecter" 2 "Acre" 3 "Gaz" 4 "Yard" 5 "Killa" 6 "Feet" 7 "Bigha" ///
					   8 "Decimal" 9 "Katha" 10 "others"
label values house_b28unit house_b29unit land_unit


label define house_description 1 "Among the richest" 2 "A little richer than most households" ///
					 	 	   3 "About Average" 4 "A little poorer than most households" ///
					 	 	   5 "Among the poorest" -999 "Don't Know/ Cannot Answer"
label values house_c9 house_description


label define treatment_facilities 1 "Government Facility / Hospital" 2 "ANM/ Sahiya" 3 "Private Hospital" ///
								  4 "Private Doctor/ Clinic" 5 "Traditional healer / Ayurvedic" ///
								  -888 "other (Specify)" -777 "Refused to Answer" 
label values house_d4 treatment_facilities


label define not_govt_facility 1 "Too Far" 2 "Road is not good" 3 "Doctors are not available" /// 
							   4 "Better facility available" 5 "Trust private sources more" ///
							   -777 "Refused to Answer"
label values house_d5 not_govt_facility


label define districts 6  "Garhwa" 17 "Palamu" 2  "Chatra" 10 "Hazaribag" 13 "Kodarma" ///
7 "Giridih" 3 "Deoghar" 8 "Godda" 22 "Sahibganj" 16 "Pakaur" 5 "Dumka" 4 "Dhanbad" 1 "Bokaro" ///
21 "Ranchi" 15 "Lohardaga" 9  "Gumla" 18 "Pashchimi Singhbhum" 19 "Purbi Singhbhum" 14 "Latehar" ///
20 "Ramgarh" 24 "Simdega" 12 "Khunti" 23 "Saraikela Kharsawan" 11 "Jamtara"
label values dist_number_2001 district_number districts

label define regions 201 "Ranchi Plateau" 202 "Hazaribagh Plateau"
label values region_sp regions


label define yesno 0 "No" 1 "Yes" -777 "Refused to Answer" -999 "Do Not Know" 
label values latrine kitchen fridge ac wash_mach cot watch radio /// 
cycle own_land house_c3 house_c4 house_c5 house_c6 house_c7 house_c8 ///
house_d1 house_d2 house_d3 house_e1event* any_shocks conflict_district yesno


*** Generating variable for birth order & whether the first born is a son
reshape long roster_id neet attending_education attending_education_principal attending_education_subsidiary attending_training ///
lfp house_a9 house_a10 house_a11 house_12 house_a13 house_a14 a14_education_primary a14_education_middle_school a14_education_secondary ///
house_a12 house_a13_1 a21_self_employed a21_regular_wage_employee a21_casual_wage_labour a21_unemployed_seeking_work a21_not_labour_force ///
house_a21 house_a22 student, i(house_code) j(hh_member)

sort house_code hh_member house_a9 house_a10 house_a11
bysort house_code: egen birth_order = rank(house_a9) if house_a10==3, field
sort house_code

gen first_born_son=1 if birth_order==1 & house_a11==1
bysort house_code: egen foo = mean(first_born_son)
bysort house_code: replace first_born_son=1 if foo!=. & foo!=0
drop foo


tempfile hh_data
save `hh_data', replace

drop if roster_id == .

local jharkhand_folder "/Users/Sabinadewan/Box Sync/Jharkhand Statewide Adolescent Girls Study"
merge 1:1 house_code roster_id using "`jharkhand_folder'/Quantitative data and outputs/Adolescent Girls Data/Adolescent Girls.dta", keepusing()
cap gen respondent_generation=.
gen respondent_relation = house_a10 if _merge==3
bysort house_code: egen foo = max(respondent_relation)
bysort house_code: replace respondent_relation = foo 
drop foo


replace respondent_generation = 1 if house_a10 == 3 & respondent_relation == 3 
replace respondent_generation = 1 if (house_a10 == 1 | house_a10 == 2) & (respondent_relation == 1 | respondent_relation == 2)

gen fathers_education = house_a14 if respondent_relation == 3 & house_a10 == 1 & house_a11 == 1
replace fathers_education = house_a14 if respondent_relation == 3 & house_a10 == 2 & house_a11 == 1
replace fathers_education = house_a14 if respondent_relation == 5 & house_a10 == 3 & house_a11 == 1
replace fathers_education = house_a14 if respondent_relation == 8 & house_a10 == 6 & house_a11 == 1

bysort house_code: egen foo = max(fathers_education)
bysort house_code: replace fathers_education = foo
drop foo

/*
to check if father's education has been defined correctly
run before the replace fathers_education = max(fathers_education) line
tempfile data
save `data'
levelsof house_code, local(codes)
foreach i of local codes {
	keep if house_code == "`i'"
	tab fathers_education 
	if `r(r)' >1 {
		use `data', clear
		break
	}
	use `data', clear
}
*/


*gen boys_neet = neet if house_a11==1 & house_a9>=11 & house_a9<=24

*bysort house_code: egen foo = mean(boys_neet)
*bysort house_code: gen boys_neet_hh =1 if foo!=. & foo!=0
*replace  boys_neet_hh=0 if boys_neet_hh !=1
*drop foo

*gen boys_age = house_a9

tempfile merge_data
save `merge_data', replace


use "`jharkhand_folder'/Quantitative data and outputs/Adolescent Girls Data/Adolescent Girls.dta", clear

merge 1:1 house_code roster_id using `merge_data', ///
keepusing(neet attending_education attending_education_principal attending_education_subsidiary attending_training ///
lfp house_a9 house_a10 house_a11 house_a12 house_a13 house_a14 a14_education_primary a14_education_middle_school a14_education_secondary ///
house_a13_1 a21_self_employed a21_regular_wage_employee a21_casual_wage_labour a21_unemployed_seeking_work a21_not_labour_force ///
house_21 house_22
student house_a3 a3_caste_sc a3_caste_st a3_caste_obc a3_caste_general  ///
house_a4 a4_religion_hindu a4_religion_muslim a4_religion_christian a4_religion_sarna house_a10 respondent_relation first_born_son birth_order any_migrant_HH ///
hoh_work_outside spouse_work_outside fathers_education hh_weight indi_weight asset_urban rankasset_urban asset_rural rankasset_rural asset_poor)
drop if _merge == 2
drop _merge

save "`jharkhand_folder'/Quantitative data and outputs/Adolescent Girls Data/Adolescent Girls.dta", replace


use `hh_data', clear
local jharkhand_folder "/Users/Sabinadewan/Box Sync/Jharkhand Statewide Adolescent Girls Study"


reshape wide roster_id neet attending_education attending_education_principal attending_education_subsidiary attending_training ///
lfp house_a9 house_a10 house_a11 house_12 house_a13 house_a14 a14_education_primary a14_education_middle_school a14_education_secondary ///
house_a13_1 house_21 house_22 ///
a21_self_employed a21_regular_wage_employee a21_casual_wage_labour a21_unemployed_seeking_work a21_not_labour_force ///
student birth_order, i(house_code) j(hh_member)


*** Variable Labels 
// Section A-Roster
forval i = 1/25 {
	label variable house_a9`i' 		"HH Member `i': Completed Age"
	label variable house_a10`i' 	"HH Member `i': Relationship with Household Head"
	label variable house_a11`i'		"HH Member `i': Sex"
	label variable house_a13`i' 	"HH Member `i': Education Status"
	label variable house_a13_1`i' 	"HH Member `i': Private/Public Institution"	

	label variable a14_education_primary`i' 		"HH Member `i': Primary Education"
	label variable a14_education_middle_school`i' 	"HH Member `i': Middle Education"
	label variable a14_education_secondary`i' 		"HH Member `i': Secondary Education"

	label variable house_a14`i'  "HH Member `i': Highest Education Level"
	
	label variable a21_self_employed`i'				"HH Member `i': Self-Employed"
	label variable a21_regular_wage_employee`i'		"HH Member `i': Regular Wage Employment"
	label variable a21_casual_wage_labour`i'		"HH Member `i': Casual Wage Labour"
	label variable a21_unemployed_seeking_work`i' 	"HH Member `i': Unemployed Seeking Work"
	label variable a21_not_labour_force`i'			"HH Member `i': Not Labout Force"
		
	label variable student`i'  						"HH Member `i': Student"
	label variable neet`i' 							"HH Member `i': NEET"
	label variable attending_education`i' 			"HH Member `i': Attending Education"
	label variable attending_education_principal`i'	"HH Member `i': Principal Activity-Education Principal"
	label variable attending_education_subsidiary`i' "HH Member `i': Subsidiary Activity-Education Principal"
	label variable attending_training`i'			"HH Member `i': Attending Training"
	label variable lfp`i' 							"HH Member `i': LFP"
	label variable roster_id`i'						"HH Member `i': Roster ID"
	label variable birth_order`i'					"HH Member `i': Birth Order"
}

label variable first_born_son 		"Is the first born child a son?"
label variable hoh_work_outside 	"Does HoH work outside the home?"
label variable spouse_work_outside  "Does spouse of HoH work outside the home?"

* value labels
label define relationship 1 "Household head" 2 "Spouse" 3 "Son/Daughter" 4 "Daughter and Son in law/ Son and Daughter in law" ///
5 "Grandson/daughter" 6 "Father/Mother" 7 "Father in law/Mother in law" 8 "Brother/Sister" ///
9 "Brother in law/sister and brother inlaw/sister in law/ brother and sister in law" 10  "Niece/Nephew" ///
11 "Grand parents/ parents In-law" 12 "Uncle/aunt" 13 "Cousin" 15 "Non Relative" 16 "Stepson/daughter or adopted children" ///
98 "Not related" -888 "Other Relatives" 

label define class 1 "CLASS 1" 2 "CLASS 2" 3 "CLASS 3" 4 "CLASS 4" 5 "CLASS 5" /// 
6 "CLASS 6" 7 "CLASS 7" 8 "CLASS 8" 9 "CLASS 9" 10 "CLASS 10/SSC" ///
11 "CLASS 11" 12 "CLASS 12/HSC" 13 "VOCATIONAL OR INDUSRTIAL DIPLOMA" ///
14 "GRADUATE AND ABOVE" 15 "POST GRADUATE OR PROFESSIONAL (INCLUDES MASTERS, PhD, MEDICINE, LAW)" ///
16 "OTHER DIPLOMA" 17 "DID NOT COMPLETE CLASS 1" 18 "NEVER ATTENDED SCHOOL" 

label define gender 1 "Male" 2 "Female"

forvalue i= 1/25 {
	label values a14_education_primary`i' a14_education_middle_school`i' a14_education_secondary`i' ///
	a21_self_employed`i' a21_regular_wage_employee`i' a21_casual_wage_labour`i' a21_unemployed_seeking_work`i' ///
	a21_not_labour_force`i' student`i' neet`i' attending_education`i' attending_education_principal`i' ///
	attending_education_subsidiary`i' attending_training`i' lfp`i' roster_id`i' birth_order`i' yesno
	
	label values house_a10`i' relationship
	
	label values house_a11`i' gender
	
	label values house_a13`i' class
}



*** Save as dta
save "`jharkhand_folder'/Quantitative data and outputs/HH Survey Data/Household data.dta", replace
outsheet using "`jharkhand_folder'/Quantitative data and outputs/HH Survey Data/Household data.csv", replace
