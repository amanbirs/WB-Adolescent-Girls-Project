********************************************************************** 
* Jharkhand Adolescent Girls Study- Adolescent Girls Survey
* Date Created: 23rd, February 2015
* author: Amanbir Singh, amanbir.s@gmail.com
* 
* Inputs: "Week#_AdeloscentReport_dd-mm-yyyy.xlsx"
* 
* Outputs: "Adolescent Girls_Raw Data.csv" 
* 		   "Adolescent Girls_Raw Data.dta"  
*
* This do-file takes the different .xls files with adolescent girls 
* data and combines them into a single data set. This is then 
* exported as a .csv file and a .dta file. The individual .xls files 
* are downloaded from the D-COR servers.
* 
* Date last edited: 12th April 2015
********************************************************************** 

set more off


*** Local with location of the raw data
local jharkhand_folder "/Users/Sabinadewan/Box Sync/Jharkhand Statewide Adolescent Girls Study"
local date_import "10-05-2015" // date at which the data was downloaded


*** Importing Raw Data--.xlsx file
import excel "`jharkhand_folder'/Quantitative data and outputs/Raw Data/`date_import'/Week1_AdeloscentReport_`date_import'.xlsx", sheet("adeloscent") firstrow clear

tostring *, replace
ren ROASTER_ID roster_id

tempfile hhdata
save `hhdata', replace


** Appending remaining HH files
forval i = 2/7 {
	import excel "`jharkhand_folder'/Quantitative data and outputs/Raw Data/`date_import'/Week`i'_AdeloscentReport_`date_import'.xlsx", sheet("adeloscent") firstrow clear
	
	tostring *, replace
	ren ROASTER_ID roster_id
	
	append using `hhdata'
	save `hhdata', replace
}

ren HOUSE_NO house_code


* recoding all yes/no to 1/0
foreach i in ADOLE_A3 ADOLE_A8 ADOLE_A9 ADOLE_A10 ADOLE_A11 ADOLE_A12 TRAINING3_A16 ADOLE_A19 ///
ADOLE_A21 ADOLE_A25A ADOLE_A26 ADOLE_B1 ADOLE_B4 ADOLE_C1 ADOLE_C4 ADOLE_C6 ///
ADOLE_C10 ADOLE_D1 ADOLE_D4 ADOLE_D5 ADOLE_E2 ADOLE_E4 ADOLE_F1SUB1 ADOLE_F1SUB2 ADOLE_F1SUB3 ///
ADOLE_F1SUB4 ADOLE_F1SUB5 ADOLE_F1SUB6 ADOLE_F1SUB7 ADOLE_F4 ADOLE_F5 ///
ADOLE_H2 ADOLE_I6 ADOLE_I7A ADOLE_I7B ADOLE_I7C ADOLE_I8 ADOLE_I11 ADOLE_I12 ///
ADOLE_I28 ADOLE_I36 ADOLE_J3 ADOLE_J6 {
	destring `i', replace
	recode `i' 2=0
}
 

* recoding multiple variable responses to 1/0
destring ADOLE_A23, replace
foreach i in ADOLE_A25OPT1 ADOLE_A25OPT2 ADOLE_A25OPT3 ///
ADOLE_A25OPT4 ADOLE_A25OPT5 ADOLE_A25OPT6 ADOLE_A25OPT7 ///
{
	destring `i', replace
	recode `i' -777/9=1
	recode `i' .=0 if ADOLE_A23!=.
}

destring ADOLE_A26, replace
foreach i in ADOLE_A27OPT1 ADOLE_A27OPT2 ADOLE_A27OPT3 ADOLE_A27OPT4 ///
ADOLE_A27OPT5 ADOLE_A27OPT6 ADOLE_A27OPT7 ADOLE_A27OPT8 ADOLE_A27OPT9 { 
	destring `i', replace
	recode `i' -777/9=1
	recode `i' .=0 if ADOLE_A26==1
}


foreach i in ADOLE_C2OPT1 ADOLE_C2OPT2 ADOLE_C2OPT3 ADOLE_C2OPT4 ///
ADOLE_C2OPT5 ADOLE_C2OPT6 ADOLE_C2OPT7 ADOLE_C2OPT8 ADOLE_C2OPT9 {
	destring `i', replace
	recode `i' -777/9=1
	recode `i' .=0 if ADOLE_C1==1
}

foreach i in ADOLE_C5OPT1 ADOLE_C5OPT2 ADOLE_C5OPT3 ADOLE_C5OPT4 ///
ADOLE_C5OPT5 ADOLE_C5OPT6 ADOLE_C5OPT7 {
	destring `i', replace
	recode `i' -777/9=1
	recode `i' .=0 if ADOLE_C4==1
}

foreach i in ADOLE_C9OPT1 ADOLE_C9OPT2 ADOLE_C9OPT3 ADOLE_C9OPT4 /// 
ADOLE_C9OPT5 ADOLE_C9OPT6 ADOLE_C9OPT7 ADOLE_C9OPT8 ADOLE_C9OPT9 ///
ADOLE_C9OPT10 ADOLE_C9OPT11 ADOLE_C9OPT12 {
	destring `i', replace
	recode `i' -888/12=1
	recode `i' .=0 
}

foreach i in ADOLE_C14OPT1 ADOLE_C14OPT2 ADOLE_C14OPT3 ADOLE_C14OPT4 ///
ADOLE_C14OPT5 ADOLE_C14OPT6 ADOLE_C14OPT7 ADOLE_C14OPT8 {
	destring `i', replace
	recode `i' -888/8=1
	recode `i' .=0 
}

foreach i in ADOLE_D3OPT1 ADOLE_D3OPT2 ADOLE_D3OPT3 ADOLE_D3OPT4 ///
ADOLE_D3OPT5 ADOLE_D3OPT6 ADOLE_D3OPT7 ADOLE_D3OPT8 {
	destring `i', replace
	recode `i' -888/8=1
	recode `i' .=0 if ADOLE_D1==0
}


foreach i in ADOLE_F6OPT1 ADOLE_F6OPT2 ADOLE_F6OPT3 ADOLE_F6OPT4 ///
ADOLE_F6OPT5 ADOLE_F6OPT6 ADOLE_F6OPT7 ADOLE_F6OPT8 {
	destring `i', replace
	recode `i' -888/8=1
	recode `i' .=0 if ADOLE_F5==1
}


foreach i in ADOLE_I28AOPT1 ADOLE_I28AOPT2 ADOLE_I28AOPT3 ADOLE_I28AOPT4 ///
ADOLE_I28AOPT5 ADOLE_I28AOPT6 {
	destring `i', replace
	recode `i' -888/6=1
	recode `i' .=0 
}


foreach i in ADOLE_I39OPT1 ADOLE_I39OPT2 ADOLE_I39OPT3 ADOLE_I39OPT4 ///
ADOLE_I39OPT5 ADOLE_I39OPT6 ADOLE_I39OPT7 {
	destring `i', replace
	recode `i' -888/7=1
	recode `i' .=0 
}



* Saving consolidated file
outsheet using "`jharkhand_folder'/Quantitative data and outputs/Raw Data/Adolescent Girls_Raw Data.csv", comma replace

save "`jharkhand_folder'/Quantitative data and outputs/Raw Data/Adolescent Girls_Raw Data.dta", replace
