set more off

*** Local with location of the raw data
local jharkhand_folder "/Users/Sabinadewan/Box Sync/Jharkhand Statewide Adolescent Girls Study"

cap mkdir "`jharkhand_folder'/Quantitative data and outputs/Asset Index"
cap mkdir "`jharkhand_folder'/Quantitative data and outputs/Asset Index/Graphs and tables"

use "`jharkhand_folder'/Quantitative data and outputs/HH Survey Data/Household data", clear

*** Kernel Density Functions

foreach i in house pukka_wall pukka_roof floors tap bijli latrine community_toilet uses_toilets closed_drain open_drain drain_hh kitchen rooms fridge phone mobile_only comp_laptop internet vehicle ac wash_mach cot watch radio TV cycle land students_hh unemp_hh pf_hh pf no_reg_sal reg_sal no_selfemp {
	quietly kdensity `i', name(`i')
}

foreach i in "house pukka_wall pukka_roof floors" "tap bijli" "latrine community_toilet uses_toilets" "closed_drain open_drain drain_hh" "kitchen rooms fridge" "phone mobile_only comp_laptop internet" "vehicle ac wash_mach cot" "watch radio TV cycle" "land students_hh unemp_hh pf_hh" "pf no_reg_sal reg_sal no_selfemp"  {
	quietly graph combine `i'
	graph export "`jharkhand_folder'/Quantitative data and outputs/Asset Index/Graphs and tables/`i'.png", replace
}

graph drop _all

log using "`jharkhand_folder'/Quantitative data and outputs/Asset Index/Graphs and tables/ttest tables.txt", replace text

foreach i in house pukka_wall pukka_roof floors tap bijli latrine community_toilet uses_toilets closed_drain open_drain drain_hh kitchen rooms fridge phone mobile_only comp_laptop internet vehicle ac wash_mach cot watch radio TV cycle land students_hh unemp_hh pf_hh pf no_reg_sal reg_sal no_selfemp {
	ttest `i' == 0
}

log close 
