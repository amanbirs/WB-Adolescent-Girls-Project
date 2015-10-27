********************************************************************** 
* Jharkhand Adolescent Girls Study- Master .do file
* Date Created: 14th September 2015
* author: Amanbir Singh, amanbir.s@gmail.com
* 
* 
* This do-file runs all cleaning, labeling and related do-files 
* for adolescent, household and community surveys. The output is 
* cleaned datasets for the adolescent, household and community 
* datasets.
********************************************************************** 


local jharkhand_folder "/Users/Sabinadewan/Box Sync/Jharkhand Statewide Adolescent Girls Study"
do "`jharkhand_folder'/Quantitative data and outputs/Do-Files/1. Listing Survey_Aggregating, Cleaning, Labeling.do"
do "`jharkhand_folder'/Quantitative data and outputs/Do-Files/2. Adolescent Girls_Appending data.do"
do "`jharkhand_folder'/Quantitative data and outputs/Do-Files/3. Adolescent Girls_Cleaning and Labeling.do"
do "`jharkhand_folder'/Quantitative data and outputs/Do-Files/4. Adolescent Girls_Generating Variables.do"
do "`jharkhand_folder'/Quantitative data and outputs/Do-Files/5. Household_Appending data.do"
do "`jharkhand_folder'/Quantitative data and outputs/Do-Files/6. Household_Cleaning and Labeling.do"
do "`jharkhand_folder'/Quantitative data and outputs/Do-Files/7. Commuity_Cleaning and Labeling.do"
