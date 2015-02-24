********************************************************************** 
* Jharkhand Adolescent Girls Study- Adolescent Girls Survey
* Date Created: 23rd, February 2015
* author: Amanbir Singh, amanbir.s@gmail.com
* 
* Date last edited: 23rd, February 2015
********************************************************************** 

*** Local with location of box
local box_folder "/Users/amanbirs/Box Sync/Jharkhand Statewide Adolescent Girls Study"
use "`box_folder'/Quantitative data and outputs/HH Survey Data/Household data", clear


*** Descriptive Stats

* Reshaping to individual records
*preserve 

replace house_code = house_replacecode if house_replacehouse == 1
keep house_code house_a9* house_a13* house_a21* house_a23* house_a34* house_a111 house_a112 house_a113 ///
house_a114 house_a115 house_a116 house_a117 house_a118 house_a119 house_a1110 house_a1111 house_a1112 ///
house_a1113 house_a1114 house_a1115 house_a1116 house_a1117 house_a1118 house_a1119 house_a1120

	duplicates drop house_code, force
	
	
drop house_a13_*

reshape long house_a9 house_a11 house_a13 house_a21 house_a23 house_a34, i(house_code) j(hh_member)
drop if house_a9 == .

*  % aged 15-24 ÒNEETÓ 
gen neet_15_24_fem 		= 1 if (house_a9`i' >=15 & house_a9`i' <=24 & house_a11 ==2 & (house_a21==92 | ///
		  		 	        house_a21==93 | house_a21==94 | house_a21==95))
replace neet_15_24_fem  = 0 if (house_a9`i' >=15 & house_a9`i' <=24 & house_a11==2 & neet_15_24_fem==.)


gen neet_15_24_male 	= 1 if (house_a9`i' >=15 & house_a9`i' <=24 & house_a11==1 & (house_a21==92 | ///
		  		 	            house_a21==93 | house_a21==94 | house_a21==95))
replace neet_15_24_male = 0 if (house_a9`i' >=15 & house_a9`i' <=24 & house_a11==1 & neet_15_24_male==.)




*  % aged 11-17 dropped out of school
gen stopped_attending 	  = 1 if (house_a9`i'>=11 & house_a9`i'<=17 & house_a13==5)
replace stopped_attending = 0 if (house_a9`i'>=11 & house_a9`i'<=17 & stopped_attending==.)

gen stopped_attending_female 	  = 1 if (house_a9`i'>=11 & house_a9`i'<=17 & house_a11==2 & house_a13==5)
replace stopped_attending_female  = 0 if (house_a9`i'>=11 & house_a9`i'<=17 & house_a11==2 & stopped_attending_female==.)

gen stopped_attending_male 	    = 1 if (house_a9`i'>=11 & house_a9`i'<=17 & house_a11==1 & house_a13==5)
replace stopped_attending_male  = 0 if (house_a9`i'>=11 & house_a9`i'<=17 & house_a11==1 & stopped_attending_male==.)



*  % aged 11-17 never attended school
gen 	never_attended = 1 if (house_a9`i'>=11 & house_a9`i'<=17 & house_a13==1)
replace never_attended = 0 if (house_a9`i'>=11 & house_a9`i'<=17 & never_attended==.)

gen 	never_attended_female = 1 if (house_a9`i'>=11 & house_a9`i'<=17 & house_a11==2 & house_a13==1)
replace never_attended_female = 0 if (house_a9`i'>=11 & house_a9`i'<=17 & house_a11==2 & never_attended_female==.)

gen 	never_attended_male = 1 if (house_a9`i'>=11 & house_a9`i'<=17 & house_a11==1 & house_a13==1)
replace never_attended_male = 0 if (house_a9`i'>=11 & house_a9`i'<=17 & house_a11==1 & never_attended_male==.)
