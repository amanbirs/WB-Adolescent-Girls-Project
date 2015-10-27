********************************************************************** 
* Jharkhand Adolescent Girls Study- Listing Survey
* Date Created: 22th, April 2015
* author: Amanbir Singh, amanbir.s@gmail.com
* 
* Inputs: Houselisting_Cleaned_6May.csv, Houselisting_Cleaned_6May_sec_g.csv
* 		  Houselisting_Cleaned_6May_sec_e.csv
* 
* Outputs: listing_hh_code.csv, House_listing.dta,  
*
* 
* The listing data is presented in 3 files. One for the main data and 
* two for roster data. The data is processed and merged into one file 
* in this do-file and saved as House_listing.dta. The roster files are
* for section E and G in the listing and are imported seperately in the
* files Houselisting_Cleaned_6May_sec_e.csv & 
* Houselisting_Cleaned_6May_sec_g.csv.
*
* Initially, data was shared in excel files by D-COR. After additional
* cleaning was requested and there proved to be some problems in the 
* initial files, they reshared the data as .csv files, thus the commented
* code. 
*
* Error checks are also conducted on duplicate HH ids in the listing data
* 
* 
* Date last edited: 9th June, 2015
********************************************************************** 


set more off


*** Local with location of the raw data
local jharkhand_folder "/Users/Sabinadewan/Box Sync/Jharkhand Statewide Adolescent Girls Study"


*** folders for errors
cap mkdir "`jharkhand_folder'/Quantitative data and outputs/Errors"
cap mkdir "`jharkhand_folder'/Quantitative data and outputs/Errors/`c(current_date)'"

local errors_folder "`jharkhand_folder'/Quantitative data and outputs/Errors/`c(current_date)'"


* importing from excel
/*
import excel "`jharkhand_folder'/Quantitative data and outputs/Listing/Houselisting_Cleaned_6May.xlsx", sheet("Sec_ABDFH") firstrow clear
outsheet using "`jharkhand_folder'/Quantitative data and outputs/Listing/Houselisting_Cleaned_6May.csv", comma replace 

import excel "`jharkhand_folder'/Quantitative data and outputs/Listing/Houselisting_Cleaned_6May.xlsx", sheet("Sec_G") firstrow clear
outsheet using "`jharkhand_folder'/Quantitative data and outputs/Listing/Houselisting_Cleaned_6May_sec_g.csv", comma replace 

import excel "`jharkhand_folder'/Quantitative data and outputs/Listing/Houselisting_Cleaned_6May.xlsx", sheet("Sec_E") firstrow clear
outsheet using "`jharkhand_folder'/Quantitative data and outputs/Listing/Houselisting_Cleaned_6May_sec_e.csv", comma replace 
*/
*********** Aggregating Listing Data ***********
insheet using "`jharkhand_folder'/Quantitative data and outputs/Listing/Houselisting_Cleaned_6May.csv", clear
ren psucodea1 psu_code


* individual response rate
egen total_selected_11_15= total(totalnoofinterviewsconducted + noofhhselectedforreplaceme)
egen total_interviewed_11_15= total(totalnoofinterviewsconducted)
gen response_rate_11_15= total_interviewed_11_15/total_selected_11_15

egen total_selected_16_18= total(es+ep)
egen total_interviewed_16_18= total(es)
gen response_rate_16_18= total_interviewed_16_18/total_selected_16_18

egen total_selected_19_21= total(ey+ev)
egen total_interviewed_19_21= total(ey)
gen response_rate_19_21= total_interviewed_19_21/total_selected_19_21

egen total_selected_22_24= total(fe+fb)
egen total_interviewed_22_24= total(fe)
gen response_rate_22_24= total_interviewed_22_24/total_selected_22_24


save "`jharkhand_folder'/Quantitative data and outputs/Listing/House_listing.dta", replace

* merging section g
insheet using "`jharkhand_folder'/Quantitative data and outputs/Listing/Houselisting_Cleaned_6May_sec_g.csv", clear
ren hh_code_g3 house_code

* checking for duplicates on house_code
duplicates tag house_code, gen(dups)
qui count if dups>0
if `r(N)'>0 {
	preserve 

	keep if dups>0
	sort house_code
	
	tempfile listing_duplicate_hh_code
	save `listing_duplicate_hh_code', replace	
	
	restore
}
duplicates drop house_code, force

merge m:1 psu_code using "`jharkhand_folder'/Quantitative data and outputs/Listing/House_listing.dta"
drop _merge 
save "`jharkhand_folder'/Quantitative data and outputs/Listing/House_listing.dta", replace


insheet using "`jharkhand_folder'/Quantitative data and outputs/Listing/Houselisting_Cleaned_6May_sec_e.csv", clear
ren _psucode psu_code
ren _hhcode house_code

* checking for duplicates on house_code
duplicates tag house_code, gen(dups)
qui count if dups>0
if `r(N)'>0 {
	preserve 

	keep if dups>0
	sort house_code
	
	tempfile listing_duplicate_hh_code
	save `listing_duplicate_hh_code', replace	
	
	restore
}

duplicates drop house_code, force

merge 1:1 house_code using "`jharkhand_folder'/Quantitative data and outputs/Listing/House_listing.dta"
drop _merge 

drop if sl_no==.
drop dups 

save "`jharkhand_folder'/Quantitative data and outputs/Listing/House_listing.dta", replace


*********** Splitting house codes ***********
use "`jharkhand_folder'/Quantitative data and outputs/Listing/House_listing.dta", clear
split house_code, parse("-")

** Errors in house_code entry
tempfile house_code_errors
*drop _all


* checking house_code1, to see if at least one of N,S,E or W has been used
qui count if house_code1!="N" & house_code1!="S" & house_code1!="E" & house_code1!="W" 
if `r(N)'>0 {
	preserve 

	keep if house_code1!="N" & house_code1!="S" & house_code1!="E" & house_code1!="W" 
	sort house_code
	
	save `house_code_errors', replace	
	
	restore
}

replace house_code1 = upper(house_code1)

* house_code2
drop if strmatch(house_code2, "*)*")==1  //these are all cases where neither N,S,E nor W has been used

* house_code3 & house_code4, refering to the number of families within the house
split house_code3, parse("(")
replace house_code3 = house_code31


gen house_code4 = house_code32 
replace house_code4 = subinstr(house_code4, ")", "", .)
replace house_code4 = subinstr(house_code4, "(", "", .)
drop house_code31 house_code32


qui count if house_code4==""
if `r(N)'>0 {
	preserve 

	keep if house_code4==""
	sort house_code
	
	cap append using `house_code_errors'
	save `house_code_errors', replace	
	
	restore
}

preserve 

keep if house_code == "W-052-4 1(1)"
cap append using `house_code_errors'
save `house_code_errors', replace	

restore

drop if house_code == "W-052-4 1(1)"
drop if strmatch(house_code3, "*)*")==1 //in all these cases house_code4 is missing


destring house_code2 house_code3 house_code4, replace

*********** rechecking duplicate house_codes ***********
duplicates tag house_code1 house_code2 house_code3 house_code4, gen(dups)

qui count if dups>0
if `r(N)'>0 {
	preserve 

	keep if dups>0
	sort house_code
	
	drop  house_code1 house_code2 house_code3 house_code4 //these variables are now int, were string, cannot append
	
	append using `listing_duplicate_hh_code'
	save `listing_duplicate_hh_code', replace	
	
	restore
}

duplicates drop  house_code1 house_code2 house_code3 house_code4, force
drop dups

*********** Labels ***********
label variable noofhhlistedh13   "Number of households listed 11-14"
label variable noofhhselectedh15 "Number of households selected 11-14"

label variable noofhhlistedh23   "Number of households listed 15-17"
label variable noofhhselectedh25 "Number of households selected 15-17"

label variable noofhhlisted33   "Number of households listed 18-21"
label variable noofhhselected35 "Number of households selected 18-21"
 
label variable noofhhlisted43   "Number of households listed 22-24"
label variable noofhhselected45 "Number of households selected 22-24"
 
label variable noofhhlisted53   "Number of households listed widow survey (>24)"
label variable noofhhselected55 "Number of households selected widow (>24)"


* Saving final data
save "`jharkhand_folder'/Quantitative data and outputs/Listing/House_listing.dta", replace

* Outsheeting errors
use `house_code_errors', clear
outsheet using "`errors_folder'/house_code_errors.csv", comma replace

use `listing_duplicate_hh_code', clear
outsheet using "`errors_folder'/listing_dup_house_code.csv", comma replace
