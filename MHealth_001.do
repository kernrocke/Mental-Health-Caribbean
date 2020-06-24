cls

*Set directory for data and do files
cd "/Users/kernrocke/Documents/Statistical Data Anlaysis/2019/Depression"

*Close existing log files
capture log close

*Create/Append log file
log using "Log Files/Depress_stress_Analysis.log", name(Depress_Stress_Results) replace


/*	Predictors and Barriers of Depression and Stress among University Students 
	in Trinidad and Tobago 
*/

**  GENERAL DO-FILE COMMENTS
**  program:		MHealth_001
**  project:      	Predictors of Depression and Stress
**  author:       	Kern Rocke 
** 	Date created	11-FEB-2019
**	Date modified	23-JUN-2020
**  task:          	Analysis Results for Manuscript
 
*-------------------------------------------------------------------------------
 
** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200

*-------------------------------------------------------------------------------

*Read in data file
use "Beck_Depress_Stress_v2", clear

*-------------------------------------------------------------------------------

*Table 1 : Sociodemographics by gender
tab age sex, 			row chi2
tab race sex, 			row chi2
tab living sex, 		row chi2
tab religion sex, 		row chi2
tab student_status sex, row chi2
tab year_study sex, 	row chi2
tab international sex, 	row chi2

*-------------------------------------------------------------------------------

*Table 2 : Lifestyle characeteristics by gender
ttest fish_meat, by(sex)
ttest fruit_veg, by(sex)
ttest western, by(sex)
ttest height, by(sex)
ttest weight, by(sex)
ttest bmi, by(sex)
tab bmi_cat sex, row chi2

*-------------------------------------------------------------------------------

*Table 3 : Depression and Stress Charactertics by gender
ttest daily_stress, by(sex)
ttest depress, by(sex)
ttest stress, by(sex)
tab cause_stress sex, row chi2
tab releve_stress sex, row chi2
tab depress_cat sex, row chi2
tab dep sex, row chi2
tab stress_cat sex, row chi2

*-------------------------------------------------------------------------------

* Set decimal format for regression results
set cformat %5.3f
*-------------------------------------------------------------------------------

/*	Logistic Regression for Beck's Depression and 
	Sociodeomographics and Lifestyle Characteristics
*/

*Univariate Models
logistic dep sex
logistic dep i.age
logistic dep ib2.living
logistic dep i.religion
logistic dep i.student_status1
logistic dep i.international
logistic dep bmi
logistic dep i.bmi_cat1
logistic dep fish_meat
logistic dep fruit_veg
logistic dep western

*Final Model
logistic dep i.sex i.age ib2.living i.student_status1 i.bmi_cat1, vce(robust)

*-------------------------------------------------------------------------------

/*	Logistic Regression for Cohen's Stress and 
	Sociodeomographics and Lifestyle Characteristics
*/

*Univariate Models
logistic stress_cat sex
logistic stress_cat i.age
logistic stress_cat ib2.living
logistic stress_cat i.religion
logistic stress_cat i.student_status1
logistic stress_cat i.international
logistic stress_cat bmi
logistic stress_cat i.bmi_cat1
logistic stress_cat fish_meat
logistic stress_cat fruit_veg
logistic stress_cat western

*Final Model
logistic stress_cat i.sex i.student_status1 fish_meat western, vce(robust)

*-------------------------------------------------------------------------------

/*	Logistic Regression for Beck's Depression and 
	Factors Causing Stress
*/

foreach x of varlist Question13a-Question13f {
logistic dep `x' , vce(robust)
}

*Final Model
logistic dep Question13b Question13d Question13f, vce(robust)

*-------------------------------------------------------------------------------

/*	Logistic Regression for Cohen's Stress and 
	Factors Causing Stress
*/

foreach x of varlist Question13a-Question13f {
logistic stress_cat `x' , vce(robust)
}

*Final Model
logistic stress_cat Question13a Question13c Question13d Question13e, vce(robust)

*-------------------------------------------------------------------------------

/*	Logistic Regression for Beck's Depression and 
	Factors Releaving Stress
*/

foreach x of varlist Question14a-Question14h {
logistic dep `x' , vce(robust)
}

*Final Model
logistic dep Question14c Question14d Question14e, vce(robust)

*-------------------------------------------------------------------------------

/*	Logistic Regression for Cohen's Stress and 
	Factors Releaving Stress
*/

foreach x of varlist Question14a-Question14h {
logistic stress_cat `x' , vce(robust)
}

*Final Model
logistic stress_cat Question14a Question14b Question14c Question14g, vce(robust)

*-------------------------------------------------------------------------------

*Analysis for table 3 (sex difference in contributors and relievers to stress and BDI (depression categories)
tab cause_stress , gen(cause_stress_)
tab releve_stress , gen(relieve_stress_)
tab depress_cat, gen(depress_cat_)

foreach x in cause_stress_1 cause_stress_2 cause_stress_3 cause_stress_4 ///
			cause_stress_5 cause_stress_6 ///
			relieve_stress_1 relieve_stress_2 relieve_stress_3 relieve_stress_4 ///
			relieve_stress_5 relieve_stress_6 relieve_stress_7 relieve_stress_8 ///
			depress_cat_1 depress_cat_2 depress_cat_3 depress_cat_4 depress_cat_5 ///
			depress_cat_6{

	tab `x' sex, chi2
	
	}
	
restore

*Close log file
log close Depress_Stress_Results
