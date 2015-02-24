********************************************************************** 
* Jharkhand Adolescent Girls Study- Adolescent Girls Survey
* Date Created: 23rd, February 2015
* author: Amanbir Singh, amanbir.s@gmail.com
* 
* Inputs: 
* 
* Outputs: 
*
*
* 
* Date last edited: 23rd, February 2015
********************************************************************** 


local raw_data_dir "/Users/amanbirs/Box Sync/Jharkhand Statewide Adolescent Girls Study/Quantitative data and outputs/Raw Data"
insheet using "`raw_data_dir'/Adolescent Girls_Raw Data.csv", clear


*** Labeling Variables 

* Section A
label variable adelo_a1_rank1 "Main reasons for stopped attending/never attended/studies completed: Rank 1"
label variable adelo_a1_rank2 "Main reasons for stopped attending/never attended/studies completed: Rank 2"
label variable adelo_a1_rank3 "Main reasons for stopped attending/never attended/studies completed: Rank 3"

label variable adole_a2 "If you had no constraints--what level of formal education would you complete?"

label variable adole_a9 "Would like to participate in training or skills course?"

label variable adole_a10 "Ever participated in vocational or skills training" 


* Section B
label variable adole_b3 "Top 3 jobs would like to be doing in 5-10 yrs"

label variable adole_b7 "If you weren't in school, would you prefer to work at home or outside?"


* Section C
label variable adole_c1 "Participate in any programs, at least once a month"

local x = 1
foreach programs in "none" "Education Support Programs" "Sports program" "Girls clubs" ///
					"help girls who face violence or abuse" "Job training programs" ///
					"Job placement programs" "Entrepreneurship programs" "Child/elderly care services" ///
					"Health education programs" "Other(specify)" "Refused to Answer" {
	label variable adole_c9opt`x' "Programs you like to have in your district/commmunity:`programs'" 
 	local x = `x'+1
}


* Section D
label variable adole_d1 "Joint or Personal Account at a bank, cooperative or post office?"

* Section E
label variable adole_e2 "At least occasionally use the internet?"

* Section G
label variable adole_g9 "Last 2 weeks, thoughts about: better off dead or of hurting yourself in some way"

* Section I
label variable adole_i4 "How old were you when you (first) got married?"

label variable adole_i30_home      "How common is abuse/violence against girls like you in homes?"
label variable adole_i30_school    "How common is abuse/violence against girls like you in schools?"
label variable adole_i30_publicplc "How common is abuse/violence against girls like you in public places?"



*** Labeling Values
label define drop_out_reasons 1 "Finished studies" 2 "Not interested in studying further" 3 "Distance/ school not available in community" ///
4 "Fees too expensive" 5 "Books and/or other supplies too expensive" 6 "Transport too expensive" ///
7 "Institution did not admit" 8 "Have to work for pay" 9 "Have to work at home" 10 "Disability " ///
11 "Illness/Injury " 12 "Orphaned " 13 "Have to care for sick and elderly " 14 "Have to care for siblings" ///
15 "Pregnancy " 16 "Going to school not safe " 17 "Social/ Religious pressure " ///
18 "Expelled from school because of behaviour  " 19 "Expelled from school because missed too many days" ///
20 "Expelled from school because failed to achieve necessary grade/level at school" 21 "Bullying/abuse from peers" ///
22 "Ill-treatment/abuse from teachers/principal" 23 "Marriage" 24 "Migration/Relocation" 25 "Waiting for exam result" ///
26 "Lack of toilets " 27 "Difficulties attending during mensuration " 28 "Not aware of further educational oppurtunities" ///
-888 "Others (specify)"
label values adelo_a1_rank1 adelo_a1_rank2 adelo_a1_rank3 drop_out_reasons


label define yesno 1 "Yes" 2 "No" -666 "Not Applicable" -777 "Refused to Answer" -999 "Do Not Know"
label values adole_a9 adole_a10 adole_c1 adole_d1 adole_e2 yesno


label define work_home_outside 1 "At Home" 2 "Outside of Home" -999 "Do Not Know"  -777 "Refused to Answer"
label values adole_b7 work_home_outside


label define employment 1 "Nurse" 2 "Teacher" 3 "Policeman/woman" 4 "Actor/actress" 5 "Doctor" 6 "Engineer" ///
7 "Sportsman/woman" 8 "Singer" 9 "Dentist" 10 "Labourer" 11 "Driver" 12 "Painter/decorator" 13 "Pilot" ///
14 "Fulltime parent/Housewife" 15 "Artist" 16 "Computer operator" 17 "Fisherman" 18 "Farmer" 19 "Soldier" ///
20 "Mechanic" 21 "Accountant" 22 "Civil servant " 23 "Conductor" 24 "Construction worker " 25 "Cook" ///
26 "District collector " 27 "Domestic Worker " 28 "Fireman/woman " 29 "Lawyer" 30 "Lecturer" ///
31 "Market Trader/shop assistant" 32 "Mason " 33 "Politician " 34 "President/leader of country" ///
35 "Scientist" 36 "Tailor" 37 "Taxi Driver" 38 "Trader/businessman/woman" 39 "Traditional occupation " ///
40 "University Student " 41 "Vet" 42 "Administrative Assistant/secretary" 43 "Religious leader/priest/sheikh" ///
44 "Management" 45 "Stylist / Beautician" 46 "Crafts/tapestry" 47 "Community/social work" ///
-888 "Other, Specify" -777 "Refused to Answer"-999 "Don’t Know"
label values adole_b3 employment 


label define phq 0 "Not at all" 1 "Several Days" 2 "More than half the days" 3 "Nearly Every Day"
label values adole_g1-adole_g9 phq


label define how_common 1 "no problem at all" 2 "rare cases" 3 "some cases" 4 "common problem" 5 "very common problem"
label values adole_i30_home adole_i30_school adole_i30_publicplc how_common



*** Saving
cd "`raw_data_dir'"
save "../Adolescent Girls Data/Adolescent Girls.dta"
