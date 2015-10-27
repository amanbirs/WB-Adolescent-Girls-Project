****For top 4 shocks vizualisation
****By: Amanbir 

foreach i in 3 8 9 {
	tab house_e1event1 house_e1event`i'
	}
	house_e1event1
	house_e1event3
	house_e1event8
	house_e1event9
	shocks_other
	
gen shocks_other = 1 if any_shocks==1 & house_e1event1!=1 & house_e1event3!=1 & house_e1event8!=1 & house_e1event9!=1 
replace shocks_other = 2 if shocks_other == .

gen shock0 = 1 if house_e1event1 ==2 & house_e1event3 ==2 & house_e1event8==2 & house_e1event9 ==2

gen shock1_1 = 1 if house_e1event1 ==1 & house_e1event3 ==2 & house_e1event8==2 & house_e1event9 ==2
gen shock1_2 = 1 if house_e1event1 ==1 & house_e1event3 ==1 & house_e1event8==2 & house_e1event9 ==2
gen shock1_3 = 1 if house_e1event1 ==1 & house_e1event3 ==2 & house_e1event8==1 & house_e1event9 ==2
gen shock1_4 = 1 if house_e1event1 ==1 & house_e1event3 ==2 & house_e1event8==2 & house_e1event9 ==1
gen shock1_5 = 1 if house_e1event1 ==1 & house_e1event3 ==1 & house_e1event8==1 & house_e1event9 ==2
gen shock1_6 = 1 if house_e1event1 ==1 & house_e1event3 ==1 & house_e1event8==2 & house_e1event9 ==1
gen shock1_7 = 1 if house_e1event1 ==1 & house_e1event3 ==2 & house_e1event8==1 & house_e1event9 ==1
gen shock1_8 = 1 if house_e1event1 ==1 & house_e1event3 ==1 & house_e1event8==1 & house_e1event9 ==1


gen shock1_9  = 1 if house_e1event1 ==2 & house_e1event3 ==1 & house_e1event8==2 & house_e1event9 ==2
gen shock1_10 = 1 if house_e1event1 ==2 & house_e1event3 ==1 & house_e1event8==2 & house_e1event9 ==1
gen shock1_11 = 1 if house_e1event1 ==2 & house_e1event3 ==1 & house_e1event8==1 & house_e1event9 ==1
gen shock1_12 = 1 if house_e1event1 ==2 & house_e1event3 ==2 & house_e1event8==1 & house_e1event9 ==1
gen shock1_13 = 1 if house_e1event1 ==2 & house_e1event3 ==2 & house_e1event8==2 & house_e1event9 ==1
gen shock1_14 = 1 if house_e1event1 ==2 & house_e1event3 ==2 & house_e1event8==1 & house_e1event9 ==2
gen shock1_15 = 1 if house_e1event1 ==2 & house_e1event3 ==1 & house_e1event8==1 & house_e1event9 ==2


forval i =1/15{
	tab1 shock1_`i', miss
}
