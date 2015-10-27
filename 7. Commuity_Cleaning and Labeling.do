/************************************************************
Jharkhand Adolescent Girls Study- Community Survey
Date Created: 26th, January 2015
author: Amanbir Singh, amanbir.s@gmail.com
 
Inputs:  "Raw Data/Community Datasheet.csv"
Outputs: "Community Data/Community Data.csv" 
		 "Community Data/Community Data.dta"

Names in community dataset were changed to start with a q so 
Stata can import the names. 


Date last edited: 13th July, 2015
***********************************************************/

set more off 
clear

*** Local with location of the raw data
local jharkhand_folder "/Users/Sabinadewan/Box Sync/Jharkhand Statewide Adolescent Girls Study"
cd "`jharkhand_folder'/Quantitative data and outputs/Do-Files"


* Folder for the community data
cap mkdir "`jharkhand_folder'/Quantitative data and outputs/Community Data"


* insheet raw data
insheet using "`jharkhand_folder'/Quantitative data and outputs/Raw Data/Community Datasheet.csv"


* renaming psu_code to match hh dataset
ren psucode psu_code

* renaming some questions if variables make no sense
ren q210whatarethemajorreligious 	 q210a_major_religious_groups
ren q210whatarethemajorreligiousgrou q210b_major_religious_groups
ren q2102whatarethemajorreligious 	 q210c_major_religious_groups
ren q2103whatarethemajorreligious 	 q210d_major_religious_groups
ren q2104whatarethemajorreligious 	 q210e_major_religious_groups

ren q213doesthisnameofthecommunitys q213_women_on_panchayat
ren q2131howmany q2131_number_women_panchayat

ren q28whichsubecologicalzones q28a_subecologicalzones 
ren v70 q28b_subecologicalzones
ren v71 q28c_subecologicalzones

ren q29whatarethemostwidelyspokenlan q29a_mostwidelyspokenlan 
ren v73 q29b_mostwidelyspokenlan
ren v74 q29c_mostwidelyspokenlan
ren v75 q29d_mostwidelyspokenlan

ren q211whatarethelargestcastegroups q211a_largestcastegroups 
ren v86 q211b_largestcastegroups 
ren v87 q211c_largestcastegroups 
ren v88 q211d_largestcastegroups 

ren q31hasnameofcommunity q31_natural_disaster_3_yrs

ren q311whatwerethey_1 q311_what_disaster_1
ren q311whatwerethey_2 q311_what_disaster_2

ren q321theptrobbery q321theftrobbery

ren q412thereisrelativelymoreworktod q412_relatively_more_work_jan
ren v108 q412_relatively_more_work_feb
ren q4123thereisrelativelymoreworkto q412_relatively_more_work_mar
ren q4124thereisrelativelymoreworkto q412_relatively_more_work_apr
ren v120 q412_relatively_more_work_may
ren v124 q412_relatively_more_work_jun
ren v128 q412_relatively_more_work_jul
ren v132 q412_relatively_more_work_aug
ren v136 q412_relatively_more_work_sep
ren v140 q412_relatively_more_work_oct
ren v144 q412_relatively_more_work_nov
ren v148 q412_relatively_more_work_dec

ren q4133peoplemovetothecommunitymar q413peoplemovetothecommunitymar
ren q4143communitymembersmoveawaymar q414communitymembersmoveawaymar
ren q4113foodbecomeshardertoobtainma q411foodbecomeshardertoobtainmar 
ren q4114foodbecomeshardertoobtainap q411foodbecomeshardertoobtainapr 

ren q42domoreleavethecommunityforwor q42_men_women_migrate_for_work
ren q43whenwomenleavethecommunityfor q43_women_migrate_occupation

forval i=1/3 {
	ren q44`i'whatarethetopocupationsofmen q44_`i'_top_occupations_men 
	ren q45`i'whatarethetopocupationsofwom q45_`i'_top_occupations_women
}

ren q51domostpeoplefeelthatamarried q51_married_woman_should_work
ren q52domostfeelthatitisbeetertosen q52_son_daughter_school


ren q531preschool 						q53_pre_school
ren q532privateprimary 					q53_private_primary
ren q533publicprimary  					q53_public_primary
ren q534privatehighschool 				q53_private_highschool
ren q535publichighschool  				q53_public_highschool
ren q536technicalcollegetrainingisst 	q53_tech_college_iti
ren q537university 						q53_university
ren q538religiousschool 				q53_religious_school
ren q539adultliteracycenter 			q53_adult_lit_centre

ren q541preschool 						q54_dist_km_pre_school
ren q542privateprimary 					q54_dist_km_private_primary
ren q543publicprimary  					q54_dist_km_public_primary
ren q544privatehighschool 				q54_dist_km_private_highschool
ren q545publichighschool  				q54_dist_km_public_highschool
ren q546technicalcollegetrainingisst 	q54_dist_km_tech_college_iti
ren q547university 						q54_dist_km_university
ren q548religiousschool 				q54_dist_km_religious_school
ren q549adultliteracycenter 			q54_dist_km_adult_lit_centre

ren q551preschool 						q55_dist_time_pre_school
ren q552privateprimary 					q55_dist_time_private_primary
ren q553publicprimary  					q55_dist_time_public_primary
ren q554privatehighschool 				q55_dist_time_private_highschool
ren q555publichighschool  				q55_dist_time_public_highschool
ren q556technicalcollegetrainingisst 	q55_dist_time_tech_college_iti
ren q557university 						q55_dist_time_university
ren q558religiousschool 				q55_dist_time_religious_school
ren q559adultliteracycenter 			q55_dist_time_adult_lit_centre

ren q592approxhowfardopeople 		q592_distance_public_transport
ren q593howoftendoespublictransport q593_frequency_public_transport

* formatting values = 0 for no if missing; for section 4 
foreach i in "jan" "feb" "mar" "apr" "may" "jun" "jul" "aug" "sep" "oct" "nov" "dec" {
	foreach j in q411foodbecomeshardertoobtain`i' q412_relatively_more_work_`i' q413peoplemovetothecommunity`i' ///
	q414communitymembersmoveaway`i' {
		replace `j' = 0 if `j' ==.
	}
}


* formatting gender variable 
forval i=1/7 {
	replace q14`i'sex = "2" if q14`i'sex=="F"
	replace q14`i'sex = "2" if q14`i'sex=="f"
	replace q14`i'sex = "1" if q14`i'sex=="M"

	destring q14`i'sex, replace
}


* formatting 
replace  q2131_number_women_panchayat = "-999" if q2131_number_women_panchayat == "DON’T KNOW"
destring q2131_number_women_panchayat, replace


* formatting all yes/no to be 1/0 from 2/0
foreach i in q25communitypartoftownorcity q213_women_on_panchayat q31_natural_disaster_3_yrs ///
q321theftrobbery q322violentcrime q323naxaliteactivity q324youthgangs q33inthiscommunityissexualassult ///
q34isdomesticviolenceverbal q51_married_woman_should_work q52_son_daughter_school ///
q53_pre_school q53_private_primary q53_public_primary q53_private_highschool q53_public_highschool ///
q53_tech_college_iti q53_university q53_religious_school q53_adult_lit_centre q591doanyofthesetypesofpublictra ///
q561policestation q562postoffice q563shopselling q564telephonenetwork q565electricpowersupply ///
q566irrigation q567pipedwater q568pdsshop q569agriculturalextension q5610businessorfinancialservice ///
q5611womensshg q5612childcareservices q5613anganwadiicds q5614grouporganisedbyanganwadice ///
q5615grouporganizedbyotherorgani q5616institutionalhealthservices {
	recode `i' 2=0
}

* labeling variables
label drop _all

label define yesno 0 "No" 1 "Yes" 3 "Do Not Know"
label values q25communitypartoftownorcity q213_women_on_panchayat q31_natural_disaster_3_yrs ///
q321theftrobbery q322violentcrime q323naxaliteactivity q324youthgangs q33inthiscommunityissexualassult ///
q34isdomesticviolenceverbal q51_married_woman_should_work q52_son_daughter_school ///
q53_pre_school q53_private_primary q53_public_primary q53_private_highschool q53_public_highschool ///
q53_tech_college_iti q53_university q53_religious_school q53_adult_lit_centre q591doanyofthesetypesofpublictra ///
q561policestation q562postoffice q563shopselling q564telephonenetwork q565electricpowersupply ///
q566irrigation q567pipedwater q568pdsshop q569agriculturalextension q5610businessorfinancialservice ///
q5611womensshg q5612childcareservices q5613anganwadiicds q5614grouporganisedbyanganwadice ///
q5615grouporganizedbyotherorgani q5616institutionalhealthservices yesno

foreach i in "jan" "feb" "mar" "apr" "may" "jun" "jul" "aug" "sep" "oct" "nov" "dec" {
	label values q411foodbecomeshardertoobtain`i' q412_relatively_more_work_`i' q413peoplemovetothecommunity`i' ///
	q414communitymembersmoveaway`i' yesno
}


label define gender 1 "Male" 2 "Female"
forval i=1/7 {
	label values q14`i'sex gender
}


label define community_position 1 "MUKHIYA" 2 "WARD MEMBER/SARPANCH/MLA/ELECTED MEMBER IN ANY ORGANISATION (SHG PRESIDENT, SECRETARY ETC.)" ///
3 "SAHIYA, ANM, PHARMACY, DOCTOR, COMPAUNDER" 4 "HEAD MASTER/ TEACHER" ///
5 "RELIGIOUS LEADER" 6 "WOMEN LEADER ANY SOCIAL WORK/ORGANIZATION ETC." 7 "ANGANWADI WORKER" 8 "SAHIKA" 9 "GENERAL PEOPLE"

forval i=1/6 {
	label values q15`i'position_in_the_community community_position
	label values q17`i'caste_group caste
}


label define change_population 1 "increased" 2 "decreased" 3 "remained about the same" 999 "don’t know/can’t answer"
label values q23inthelast3yearsnumberofpeople change_population

label define uses_time 1 "Planned housing" 2 "Squatter settlements" 3 "Farming" 4 "Fisheries" 5 "Industry" 6 "Mining" ///
7 "Manufacturing" 8 "Recreation grounds" 9 "Shops/trade" 10 "Nothing" 11 "Grazing Land" 12 "Other: SPECIFY" 
label values q24whatarethemostcommonuses_1 q24whatarethemostcommonuses_2 q24whatarethemostcommonuses_3 ///
q24whatarethemostcommonuses_4 q24whatarethemostcommonuses_5 uses_time

label define ecology 1 "Rain forest." 2 "Coastal plain." 3 "Inland plain" 4 "Hill " 5 "Mountain " 6 "Desert " 7 "Other: SPECIFY" 
label values q28a_subecologicalzones q28b_subecologicalzones q28c_subecologicalzones ecology

label define language 1 "HINDI" 2 "SADRI" 3 "BHOJPURI" 4 "NAGPURI" 5 "SANTHALI" 6 "KHORTHA" 7 "MAITHILI" ///
8 "BANGALA" 9 "ODIA" 10 "URDU" 11 "MAGAHI" 12 "ORA" 13 "HO" 14 "MUNDA" 15 "KUDUKH" 16 "ANGIKA" 17 "ASURI" ///
18 "CHAITRI" 19 "MAHUTO" 
label values q29a_mostwidelyspokenlan q29b_mostwidelyspokenlan q29c_mostwidelyspokenlan q29d_mostwidelyspokenlan ///
q291whichoftheseismostwidelyspok q292whichofthesesecondlanguages language


* recoding religion variables to match hh questionnaire
foreach i in q210a_major_religious_groups q210b_major_religious_groups q210c_major_religious_groups ///
q210d_major_religious_groups q210e_major_religious_groups q2101whichoftheseisthebiggestrel q2102whichoftheseisthesecondbigg {
	replace `i' = `i' +10
	
	recode `i' 11=3 12=1 13=2 14=-888 15=4 6=-777 7=-888
}

label define religion 1 "Hindu" 2 "Muslim" 3 "Christian" 4 "Sarna" -777 "Refused to Answer" -888 "Other" -999 "Does not Know"
label values q210a_major_religious_groups q210b_major_religious_groups q210c_major_religious_groups ///
q210d_major_religious_groups q210e_major_religious_groups q2101whichoftheseisthebiggestrel q2102whichoftheseisthesecondbigg religion

label define caste 1 "SC" 2 "ST" 3 "BC" 4 "OC" 
label values q211a_largestcastegroups ///
q211b_largestcastegroups q211c_largestcastegroups q211d_largestcastegroups q2111whichofthelargestcastegroup ///
q2112whichoftheseisthesecondlarg caste

label define comparison 1 "Among the richest" 2 "A little richer than most communities" 3 "About average" ///
4 "A little poorer than most communities" 5 "Among the poorest" 
label values q212comparedtotherestofthestate comparison

label define disaster 1 "Volcanic eruption" 2 "Cyclone/tornado/hurricane" 3 "Drought" 4 "Avalanche/mud slide" ///
5 "Earthquake" 6 "Flooding (lake, river, sea)" 7 "Other: SPECIFY BELOW" 
label values q311_what_disaster_1 q311_what_disaster_2 disaster

label define men_women_migrate 1 "more women" 2 "more men" 3 "about the same" 4 "don’t know/not applicable" 
label values q42_men_women_migrate_for_work men_women_migrate

label define migrate_work 1 "domestic work" 2 "other types of jobs" 3 "about the same" 4 "don’t know/not applicable" 
label values q43_women_migrate_occupation migrate_work

label define occupation 1 "Fulltime parent/domestic responsibilities" 2 "Farmer" 3 "Fisher" 4 "Labourer" ///
5 "Shop assistant" 6 "Civil servant" 7 "Community worker" 9 "Teacher" 10 "Trader/entrepreneur" 11 "Handicrafts producer" ///
12 "Factory worker" 13 "Technical professional (e.g., accountant, lawyer, engineer)" 14 "Construction worker" ///
15 "Mining worker" 17 "Fisherman/woman" 18 "Traditional job/healer" 19 "Other (PLEASE SPECIFY)" 
forval i=1/3 {
	label values q44_`i'_top_occupations_men occupation
	label values q45_`i'_top_occupations_women occupation
}

label define dist_km 1 "<1 KM" 2 "1-5 KM" 3 "5-10 KM"
label values q54_dist_km_pre_school q54_dist_km_private_primary q54_dist_km_public_primary ///
q54_dist_km_private_highschool q54_dist_km_public_highschool q54_dist_km_tech_college_iti ///
q54_dist_km_university q54_dist_km_religious_school q54_dist_km_adult_lit_centre dist_km

label define dist_time 1 "<1/2 hour" 2 "1/2-1 hour" 3 "1-2 hours" 4 ">2 hours" 9 "NK" 
label values q55_dist_time_pre_school q55_dist_time_private_primary q55_dist_time_public_primary ///
q55_dist_time_private_highschool q55_dist_time_public_highschool q55_dist_time_tech_college_iti ///
q55_dist_time_university q55_dist_time_religious_school q55_dist_time_adult_lit_centre dist_time


label define change 1 "improved " 2 "deteriorated" 3 "stayed the same" 4 "don’t know" 
label values q571policestation q572postoffice q573shopselling q574telephonenetwork q575electricpowersupply ///
q576irrigation q577pipedwater q578pdsshop q579agriculturalextension q5710businessorfinancialservice q5711womensshg ///
q5712childcareservices q5713anganwadiicds q5714grouporganisedbyanganwadice q5715grouporganizedbyotherorgani ///
q5716institutionalhealthservices change


label define public_transport 1 "none" 2 "bus" 3 "minibus" 4 "train" 5 "taxi" 6 "rickshaw" 7 "motorbike" ///
8 "motorized boats (including ferries and taxies)" 9 "non-motorized boats (including ferries and taxies)" 10 "other (specify)"
label values q581whattypesofpublictransport q582whattypesofpublictransport q583whattypesofpublictransport ///
q584whattypesofpublictransport q585whattypesofpublictransport public_transport

label define nearest_transport 1 "less than 1km" 2 "2-5km" 3 "6-10km" 4 "more than 10km" 
label values q592_distance_public_transport nearest_transport

label define frequency_public_transport  1 "daily" 2 "weekly" 3 "monthly" 4 "less often" 
label values q593_frequency_public_transport frequency_public_transport



* save
outsheet using "`jharkhand_folder'/Quantitative data and outputs/Community Data/Community Data.csv", comma replace
save "`jharkhand_folder'/Quantitative data and outputs/Community Data/Community Data.dta", replace


