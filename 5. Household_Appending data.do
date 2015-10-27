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
* This do-file takes the different .xls files with household data 
* and combines them into a single data set. This is then 
* exported as a .csv file and a .dta file. The individual .xls files 
* were initially downloaded from the D-COR servers. After errors were 
* corrected and there were problems with the server downloads, the data
* was shared as a combined .xls file. The commented code can be used to
* merge individual data files downloaded from the server. All yes/no
* options are also recoded from 1/2 to 1/0.
*
* Date last edited: 12th, July 2015
********************************************************************** 

set more off

local jharkhand_folder "/Users/Sabinadewan/Box Sync/Jharkhand Statewide Adolescent Girls Study" //location of the Jharkhand study folder on your computer

/*
local date_import "10-05-2015" // date at which the data was downloaded

*** Importing Raw Data--.xlsx file
import excel "`jharkhand_folder'/Quantitative data and outputs/Raw Data/`date_import'/Week1_HouseholdReport_`date_import'.xlsx", sheet("household") firstrow clear

* Destringing numeric variables
destring PRIMETELE_NO ALTTELE_NO, replace
destring HOUSE_A7, replace 

	forval i= 1/20{
		ren ROASTER_ID`i' roster_id`i'
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

ren DISTRICT_NAME district_number

tempfile hhdata
save `hhdata', replace


** Appending remaining HH files
forval i = 2/5 {
	import excel "`jharkhand_folder'/Quantitative data and outputs/Raw Data/`date_import'/Week`i'_HouseholdReport_`date_import'.xlsx", sheet("household") firstrow clear
	
	* Destringing numeric variables
	destring PRIMETELE_NO ALTTELE_NO, replace
	destring HOUSE_A7, replace 

	forval i= 1/20{
		ren ROASTER_ID`i' roster_id`i'
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
	
	ren DISTRICT_NAME district_number
	
	append using `hhdata'
	save `hhdata', replace
}

*/


import excel "`jharkhand_folder'/Quantitative data and outputs/Raw Data/HH_Records_19May.xlsx", ///
sheet("Sheet1") firstrow clear

destring PRIMETELE_NO ALTTELE_NO, replace
destring HOUSE_A7, replace 

	forval i= 1/20{
		ren ROASTER_ID`i' roster_id`i'
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

ren DISTRICT_NAME district_number



* recoding all yes/no to 1/0
forval i = 1/25 {
	foreach j in HOUSE_A17 HOUSE_A18 HOUSE_A19 HOUSE_A23  {
		destring `j'`i', replace
		recode `j'`i' 2=0
	}
}
 
 
foreach i in HOUSE_B11 HOUSE_B14 HOUSE_B15 HOUSE_B19 HOUSE_B20 HOUSE_B21 ///
			 HOUSE_B22 HOUSE_B23 HOUSE_B24 HOUSE_B26 HOUSE_B27 HOUSE_C3  ///
			 HOUSE_C4 HOUSE_C5 HOUSE_C6 HOUSE_D1 HOUSE_D2 HOUSE_D3 		 ///
			 HOUSE_E1EVENT1 HOUSE_E1EVENT2 HOUSE_E1EVENT3 HOUSE_E1EVENT4 ///
			 HOUSE_E1EVENT5 HOUSE_E1EVENT6 HOUSE_E1EVENT7 HOUSE_E1EVENT8 ///
			 HOUSE_E1EVENT9 {
	destring `i', replace
	recode `i' 2=0
}



* Saving consolidated file
outsheet using "`jharkhand_folder'/Quantitative data and outputs/Raw Data/Household_Raw Data.csv", comma replace
save "`jharkhand_folder'/Quantitative data and outputs/Raw Data/Household_Raw Data", replace
