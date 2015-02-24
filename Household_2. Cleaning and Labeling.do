********************************************************************** 
* Jharkhand Adolescent Girls Study- Household Survey
* Date Created: 26th, January 2015
* author: Amanbir Singh, amanbir.s@gmail.com
* 
* Inputs: "HouseholdReport_dd-mm-yyyy.xlsx"
* 
* Outputs: "Household Data.dta" 
*
* 
* Date last edited: 23rd February, 2015
********************************************************************** 

set more off


*** Local with location of the raw data
local raw_data_dir "/Users/amanbirs/Box Sync/Jharkhand Statewide Adolescent Girls Study/Quantitative data and outputs/Raw Data"


*** Importing Raw Data--.csv file
insheet using "`raw_data_dir'/Household_Raw Data.csv", clear


*** Splitting multiple choice variables
reshape_multiple_choices house_a3 A3_caste_sc A3_caste_st A3_caste_obc A3_caste_general A3_caste_other(-888) ///
							      A3_caste_refused(-777) A3_caste_dnk(-999)

reshape_multiple_choices house_a4 A4_religion_hindu A4_religion_muslim A4_religion_christian A4_religion_other(-888) ///
								  A4_religion_refused(-777) A4_religion_dnk(-999)

reshape_multiple_choices house_a5 A5_language_hindi A5_language_urdu A5_language_nagpuri A5_language_bhojpuri ///
								  A5_language_sadri A5_language_other(-888) A5_language_refused(-777)

		
// roster begins here
forval i = 1/20{
	reshape_multiple_choices house_a13`i' A13`i'education_primary(1) A13`i'_education_primary(2) A13`i'_education_primary(3) ///
	A13`i'_education_primary(4) A13`i'_education_primary(5) A13`i'_education_middle_school(6) A13`i'_education_middle_school(7) ///
	A13`i'_education_middle_school(8) A13`i'_education_secondary(9) A13`i'_education_secondary(10) A13`i'_education_secondary(11) 

	reshape_multiple_choices house_a13`i' A13`i'_education_secondary(12) 


	reshape_multiple_choices house_a21`i' A21`i'_self_employed(11) A21`i'_self_employed(12) A21`i'_self_employed(21) ///
	A21`i'_regular_wage_employee(31) A21`i'_casual_wage_labour(41) A21`i'_casual_wage_labour(51) ///

	reshape_multiple_choices house_a21`i' A21`i'_unemployed_seeking_work(81) A21`i'_not_labour_force(91) A21`i'_not_labour_force(92) ///
	A21`i'_not_labour_force(93) A21`i'_not_labour_force(94) A21`i'_not_labour_force(95) A21`i'_other(-888)	
}


*** Formatting
* formating phone numbers, dates and time
format primetele_no alttele_no %10.0g

gen survey_date1 = date(survey_date, "YMD")
format survey_date1 %tdCCYY-mm-DD //This isn't working properly for some reason


*START_TIME END_TIME




*** Variable Labels 
label variable house_replacecode "Household Code for New Household"
label variable primetele_no "Primary Telephone Number"
label variable alttele_no "Alternate Telephone Number"


// Section A
label variable house_a1 "How many people eat together in your house?"
label variable house_a2 "Who is the head of the household?"
label variable house_a3 "Caste of the head of household"
label variable house_a4 "Religion of the head of household"
label variable house_a5 "Primary language of the Head of the Household"
label variable house_a7 "What is the annual income of the household?"

// Section A-Roster
forval i = 1/20{
	label variable house_a8fname`i' "HH Member `i': First Name"
	label variable house_a8lname`i' "HH Member `i': Last Name"
	label variable house_a9`i' 		"HH Member `i': Completed Age"
	label variable house_a10`i' 	"HH Member `i': Relationship with Household Head"
	label variable house_a10other`i' "HH Member `i': Relationship with Household Head (other)"
	label variable house_a11`i' "HH Member `i': Sex"
	label variable house_a12`i' "HH Member `i': Marital Status (If age>=10)"
	label variable house_a13`i' "HH Member `i': Education Status"
	label variable house_a13_1`i' "HH Member `i': Highest Education Level"
	label variable house_a14`i' "HH Member `i': Can this person Read/ Write?"
	label variable house_a15`i' "HH Member `i': Can this person add and subtract numbers in your head?"
	label variable house_a17`i' "HH Member `i': Cash Transfer (Y/N)"
	label variable house_a18`i' "HH Member `i': In-Kind Transfer (Y/N)"
	label variable house_a19`i' "HH Member `i': Migrated in the Last 3 Years (Y/N)"

	label variable house_a21`i' "HH Member `i': Usual Principal Activity Status "
	label variable house_a22`i' "HH Member `i': Usual Principal Activity Occupation"
	label variable house_a23`i' "HH Member `i': Engaged in Any Subsidiary Capacity (Y/N)"
	label variable house_a24`i' "HH Member `i': Princiapl Activity Location of Workplace"
	label variable house_a24other`i' "HH Member `i': Usual Princiapl Activity Location of Workplace (other)"
	label variable house_a25`i' "HH Member `i': Usual Principal Activity Enterprise Type"
	label variable house_a25other`i' "HH Member `i': Usual Principal Activity Enterprise Type (other)"
	label variable house_a27`i' "HH Member `i': Usual Principal Activity No. of Workers"
	label variable house_a28`i' "HH Member `i': Usual Principal Activity Type of Contract"
	label variable house_a30`i' "HH Member `i': Usual Principal Activity Availability of Social Security Benefits"
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
label variable house_b1 "Ownership Status of the house"
label variable house_b2 "Predominant material of wall of dwelling room "
label variable house_b3 "Predominant material of roof of dwelling room "
label variable house_b4 "Number of Stories/Floor-Levels exclusively in the possession of this household"
label variable house_b5 "Number of dwelling rooms exclusively in possession of this household"
label variable house_b6 "Number of Pucca Rooms"
label variable house_b7 "Number of Kuccha Rooms"
label variable house_b8 "Number of Semi-Pucca Rooms"
label variable house_b9 "Availability of drinking water sources"
label variable house_b10 "Main Source of Lighting"
label variable house_b11 "Water-Seal Latrine Exclusively for the Household"
label variable house_b12 "What Toilet Does the Household Use"
label variable house_b13 "Waste Water Outlet is Connected to"
label variable house_b14 "Seperate Room Used as Kitchen Exclusively (Y/N)"

label variable house_b15 "Assets: Refrigerator"
label variable house_b16 "Assets: Telephone"
label variable house_b17 "Assets: Computer/Laptop"
label variable house_b18opt1 "Assets: Two Wheeler"
label variable house_b18opt2 "Assets: Three Wheeler"
label variable house_b18opt3 "Assets: Four Wheeler"
label variable house_b18opt4 "Assets: None"
label variable house_b19 "Assets: Is the Motorized Vehicle Used Commercially?"
label variable house_b20 "Assets: Air Conditioner"
label variable house_b21 "Assets: Washing Machine"
label variable house_b22 "Assets: Wooden/Steel Sleeping Cot"
label variable house_b23 "Assets: Clock/Watch/Time Piece"
label variable house_b24 "Assets: Radio/Transistor"
label variable house_b25 "Assets: Television"
label variable house_b26 "Assets: Bicycle"
label variable house_b27 "Assets: Land (excluding homestead)"
label variable house_b28 "Assets: Irrigated Land (amount)"
label variable house_b28unit "Assets: Irrigated Land (unit)"
label variable house_b28unitother "Assets: Irrigated Land (unit-other)"
label variable house_b29 "Assets: Unirrigated Land (amount)"
label variable house_b29unit "Assets: Unirrigated Land (unit)"
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
label variable house_d5 "Why don’t members of your household generally go to a government facility when they are sick?"

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


* Save as .csv


*** Value Labels 
label define house_ownership 1 "Owned" 2 "Rented" 3 "Shared" 4 "Living on premises with employer" ///
							 5 "House provided by the employer" 6 "Any other"					 
label values house_b1 house_ownership

label define wall_material 1 "Grass / thatch / bamboo etc" 2 "Plastic / polythene" 3 "Mud/Unburnt brick" ///
						   4 "Wood" 5 "Stone not packed with mortar" 6 "Stone packed with mortar" ///
						   7 "G.I. / metal / asbestos sheets" 8 "Burnt brick" 9 "Concrete" 10 "Stone with Mud" ///
						   11 "Any other"
label values house_b2 wall_material

label define roof_material 1 "Grass / thatch / bamboo/ wood / mud etc" 2 "Plastic / polythene" 3 "Hand made tiles" ///
						   4 "Machine made tiles" 5 "Burnt brick" 6 "Stone" 7 "Slate" ///
						   8 "G.I./ metal/asbestos sheets" 9 "Concrete" 10 "Khapra" ///
						   11 "Any other"
label values house_b3 roof_material

label define drinking_water 1 "Within the premises" 2 "Near the premises" 3 "Away"
label values house_b9 drinking_water

label define lighting 1 "Electricity" 2 "Kerosene" 3 "Solar" 4 "other Oil" 5 "Any other" 6 "No Lighting"
label values house_b10 lighting

label define toilet 1 "Community toilet" 2 "Open Toilet" 3 "Own Toilet" 4 "others"
label values house_b12 toilet

label define drainage 1 "Closed drainage" 2 "Open drainage" 3 "No drainage"
label values house_b13 drainage

label define telephone 1 "Landline only" 2 "Mobile only" 3 "Both" 4 "Neither"
label values house_b16 telephone

label define computer_laptop 1 "Yes, with internet" 2 "Yes, without internet" 3 "No"
label values house_b17 computer_laptop

label define tv 1 "Yes, colour" 2 "Yes, B&W" 3 "No"
label values house_b25 tv

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


label define yesno 1 "Yes" 2 "No" -777 "Refused to Answer" -999 "Do Not Know" 
label values house_b11 house_b14 house_b15 house_b19 house_b20 house_b21 house_b22 house_b23 /// 
house_b24 house_b26 house_b27 house_c3 house_c4 house_c5 house_c6 house_c7 house_c8 ///
house_d1 house_d2 house_d3 house_e1event* yesno


*** Save as dta
save "../HH Survey Data/Household data", replace
