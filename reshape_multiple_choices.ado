********************************************************************************
* ADO file: reshape_multiple_choices

* This ado file is written to reshape the multiple choice variables from both 
* the CSP and customer survey. This do-file takes in variables which are asked
* multiple times in the survey (ex. source of income) or variables that were 
* multiple choice and have then been split into multiple variables.
* The first word after the command is the name of the original variable without
* the numbers that are attached to the variables. All following words are names
* of variables to be generated. The new varialbes are arranged in order of their
* numberical values in the multiple choice questions.  

* The do-file works with the "Baseline Survey data" file in the "dta"
* folder under the true crypt file:
* ".../Dropbox/FINO-IPA/Data/BCA Baseline Survey Data.xls"
********************************************************************************


program define reshape_multiple_choices
 	 	
 	local count = wordcount("`0'")
	di "Number of variables to be created = " (`count'-1)
	di ""	
	di ""
	forval i = 2/`count'{	
		if strmatch("``i''", "*(*)")==1 {
			local condition = substr("``i''", strpos("``i''", "(")+1 , strpos("``i''", ")")-strpos("``i''", "(")-1)
			local new_var = substr("``i''", 1 , strpos("``i''", "(")-1)

			cap gen `new_var' = 0

			replace `new_var' = 1 if `1' == `condition'
		}
		
		else{
			cap gen ``i'' = 0
			replace ``i'' = 1 if `1'==`i'-1
		}		
		di "The variable ``i'' has been created"
	}
	
end
