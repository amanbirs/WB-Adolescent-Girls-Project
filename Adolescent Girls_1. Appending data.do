********************************************************************** 
* Jharkhand Adolescent Girls Study- Adolescent Girls Survey
* Date Created: 23rd, February 2015
* author: Amanbir Singh, amanbir.s@gmail.com
* 
* Inputs: "HouseholdReport_dd-mm-yyyy.xlsx"
* 
* Outputs: "Household_Raw Data.csv" 
* 		   "Household_Raw Data.dta"  
*
*
* 
* Date last edited: 23rd, February 2015
********************************************************************** 

set more off


*** Local with location of the raw data
local raw_data_dir "/Users/amanbirs/Box Sync/Jharkhand Statewide Adolescent Girls Study/Quantitative data and outputs/Raw Data"


*** Importing Raw Data--.xlsx file
import excel "`raw_data_dir'/Week1_AdeloscentReport_22-02-2015.xlsx", sheet("adeloscent") firstrow clear

tostring *, replace

tempfile hhdata
save `hhdata', replace


** Appending remaining HH files
forval i = 2/4 {
	import excel "`raw_data_dir'/Week`i'_AdeloscentReport_22-02-2015.xlsx", sheet("adeloscent") firstrow clear
	
	tostring *, replace
	
	append using `hhdata'
	save `hhdata', replace
}


* Saving consolidated file
outsheet using "`raw_data_dir'/Adolescent Girls_Raw Data.csv", comma replace

