********************************************************************** 
* Jharkhand Adolescent Girls Study- Household Survey
* Date Created: 22nd, February 2015
* author: Amanbir Singh, amanbir.s@gmail.com
* 
* Inputs: "HouseholdReport_dd-mm-yyyy.xlsx"
* 
* Outputs: "Household_Raw Data.csv" 
* 		   "Household_Raw Data.dta"  
*
*
* 
* Date last edited: 22nd, February 2015
********************************************************************** 

set more off


*** Local with location of the raw data
local raw_data_dir "/Users/amanbirs/Box Sync/Jharkhand Statewide Adolescent Girls Study/Quantitative data and outputs/Raw Data"


*** Importing Raw Data--.xlsx file
import excel "`raw_data_dir'/Week1_HouseholdReport_22-02-2015.xlsx", sheet("household") firstrow clear

* Destringing numeric variables
destring PRIMETELE_NO ALTTELE_NO, replace
destring HOUSE_A7, replace 

	forval i= 1/20{
		destring HOUSE_A9`i'  HOUSE_A10`i' HOUSE_A11`i' HOUSE_A12`i' HOUSE_A13`i' HOUSE_A13_1`i' ///
				 HOUSE_A14`i' HOUSE_A15`i' HOUSE_A17`i' HOUSE_A18`i' HOUSE_A19`i' HOUSE_A21`i' ///
				 HOUSE_A23`i' HOUSE_A24`i' HOUSE_A25`i' HOUSE_A27`i' HOUSE_A28`i' ///
			 	 HOUSE_A30`i' HOUSE_A32`i' HOUSE_A34`i' HOUSE_A36`i' ///
				 HOUSE_A37`i' HOUSE_A39`i' HOUSE_A40`i' HOUSE_A42`i', replace
	}

destring HOUSE_A*, replace
destring HOUSE_B4 HOUSE_B5 HOUSE_B6 HOUSE_B7 HOUSE_B8 HOUSE_B28 HOUSE_B29, replace
destring HOUSE_C*, replace
destring HOUSE_E*, replace

tostring *OTHER*, replace
tostring HOUSE_LAT HOUSE_LONG, replace
tostring HOUSE_A8FNAME* HOUSE_A8LNAME* HOUSE_A22* HOUSE_A35*, replace


tempfile hhdata
save `hhdata', replace


** Appending remaining HH files
forval i = 2/5 {
	import excel "`raw_data_dir'/Week`i'_HouseholdReport_22-02-2015.xlsx", sheet("household") firstrow clear
	
	* Destringing numeric variables
	destring PRIMETELE_NO ALTTELE_NO, replace
	destring HOUSE_A7, replace 

	forval i= 1/20{
		destring HOUSE_A9`i'  HOUSE_A10`i' HOUSE_A11`i' HOUSE_A12`i' HOUSE_A13`i' HOUSE_A13_1`i' ///
				 HOUSE_A14`i' HOUSE_A15`i' HOUSE_A17`i' HOUSE_A18`i' HOUSE_A19`i' HOUSE_A21`i' ///
				 HOUSE_A23`i' HOUSE_A24`i' HOUSE_A25`i' HOUSE_A27`i' HOUSE_A28`i' ///
			 	 HOUSE_A30`i' HOUSE_A32`i' HOUSE_A34`i' HOUSE_A36`i' ///
				 HOUSE_A37`i' HOUSE_A39`i' HOUSE_A40`i' HOUSE_A42`i', replace
	}
	
	destring HOUSE_A*, replace
	destring HOUSE_B4 HOUSE_B5 HOUSE_B6 HOUSE_B7 HOUSE_B8 HOUSE_B28 HOUSE_B29, replace
	destring HOUSE_C*, replace
	destring HOUSE_E*, replace
	
	tostring *OTHER*, replace
	tostring HOUSE_LAT HOUSE_LONG, replace
	tostring HOUSE_A8FNAME* HOUSE_A8LNAME* HOUSE_A22* HOUSE_A35*, replace
	
	append using `hhdata'
	save `hhdata', replace
}


* Saving consolidated file
outsheet using "`raw_data_dir'/Household_Raw Data.csv", comma replace

save "`raw_data_dir'/Household_Raw Data", replace
