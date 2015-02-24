********************************************************************** 
* Jharkhand Adolescent Girls Study- Adolescent Girls Survey
* Date Created: 23rd, February 2015
* author: Amanbir Singh, amanbir.s@gmail.com
*
* 
* Date last edited: 23rd, February 2015
********************************************************************** 


* box sync location
local box_folder "/Users/amanbirs/Box Sync/Jharkhand Statewide Adolescent Girls Study"
use "`box_folder'/Quantitative data and outputs/Adolescent Girls Data/Adolescent Girls.dta", clear

* Ad A1  Top 3 reasons stopped/not attending school (with %Õs)
tab adelo_a1_rank1
tab adelo_a1_rank2
tab adelo_a1_rank3

reshape_multiple_choices adelo_a1_rank1 a1_not_insterested(2) a1_distance(3) a1_fees_too_expensive(4) a1_work_home(9) ///
a1_siblings(14) a1_marriage(23) 

reshape_multiple_choices adelo_a1_rank2 a1_not_insterested(2) a1_distance(3) a1_fees_too_expensive(4) a1_work_home(9) ///
a1_siblings(14) a1_marriage(23) 

reshape_multiple_choices adelo_a1_rank3 a1_not_insterested(2) a1_distance(3) a1_fees_too_expensive(4) a1_work_home(9) ///
a1_siblings(14) a1_marriage(23) 

** Correctly define =0 for these variables after taking into account the skips
foreach i in  a1_not_insterested  a1_distance a1_fees_too_expensive a1_work_home a1_siblings a1_marriage {
	replace `i' = . if (adelo_a1_rank1 == . & adelo_a1_rank2 == . & adelo_a1_rank3 == .)
}


tab a1_not_insterested
tab a1_distance
tab a1_fees_too_expensive
tab a1_work_home
tab a1_siblings
tab a1_marriage



* Ad A9 | >15         % would like to participate in training
tab adole_a9

* Ad A10   % that have participated in training
tab adole_a10, miss

* Ad B7 | >15       % prefer to work outside of home 
tab adole_b7

* Ad B3        Top 3 jobs would like to be doing in 5-10 yrs (with %Õs)
tab adole_b3

* Ad C1        % participating in programs
tab adole_c1

* Ad C9        Top 3 programs would most likely to have in district/community (with %Õs)
forval i = 1/9{
	tab adole_c2opt`i'
}


tab adole_c9opt1, miss
tab adole_c9opt2, miss 
tab adole_c9opt3 , miss
tab adole_c9opt4 , miss
tab adole_c9opt5 , miss
tab adole_c9opt6 , miss
tab adole_c9opt7 , miss
tab adole_c9opt8 , miss
tab adole_c9opt9 , miss
tab adole_c9opt10 , miss
tab adole_c9opt11 , miss
tab adole_c9opt12, miss


* Ad D1 | >15        % aged 18+ with financial account (if 18 is min. age, or is it 15?)
tab adole_d1

* Ad E2        % with access to internet
tab adole_e2, miss

* Ad I4  | married       % married before age 18
replace adole_i4 = . if adole_i4 == -999 
tab adole_i4

* Ad I30        % report violence in homes as common or very common
tab adole_i30_home, miss
tab adole_i30_school, miss
tab adole_i30_publicplc, miss


* AD G9    % thought of hurting self/better off dead several days or more over last 2 wks
tab adole_g9, miss


