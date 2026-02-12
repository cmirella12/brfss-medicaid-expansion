*** Recode data sets from 2010 to 2015 
*** recode data sets from 2016-2020 
*** no age, _region, race2 instead _racegr3


    use "brfss2013.dta", clear 

	keep _state iyear genhlth physhlth menthlth poorhlth hlthpln1 persdoc2 medcost checkup1 exerany2 diabete3 cvdinfr4 cvdcrhd4 cvdstrk3 asthma3 asthnow qlactlm2 smoke100 educa employ income2  sex drnkany5 alcday5 drnk3ge5 maxdrnks emtsuprt lsatisfy qlmentl2 qlstres2 qlhlth2 sleptim1 renthom1 scntmony scntmeal _ststr _strwt _raw _race _racegr3 _rfhlth _hcvu65 marital hlthcvrg nocov121 _ageg5yr
	
*state
    label define state_lbl 1 "Alabama" 2 "Alaska" 4 "Arizona" 5 "Arkansas" 6 "California" 8 "Colorado" 9 "Connecticut" 10 "Delaware" 11 "District of Columbia" 12 "Florida" 13 "Georgia" 15 "Hawaii" 16 "Idaho" 17 "Illinois" 18 "Indiana" 19 "Iowa" 20 "Kansas" 21 "Kentucky" 22 "Louisiana" 23 "Maine" 24 "Maryland" 25 "Massachusetts" 26 "Michigan" 27 "Minnesota" 28 "Mississippi" 29 "Missouri" 30 "Montana" 31 "Nebraska" 32 "Nevada" 33 "New Hampshire" 34 "New Jersey" 35 "New Mexico" 36 "New York" 37 "North Carolina" 38 "North Dakota" 39 "Ohio" 40 "Oklahoma" 41 "Oregon" 42 "Pennsylvania" 44 "Rhode Island" 45 "South Carolina" 46 "South Dakota" 47 "Tennessee" 48 "Texas" 49 "Utah" 50 "Vermont" 51 "Virginia" 53 "Washington" 54 "West Virginia" 55 "Wisconsin" 56 "Wyoming" 66 "Guam" 72 "Puerto Rico" 78 "Virgin Islands"
  
	
* renaming variables for consistency 
    rename hlthpln1 hlthplan
	rename diabete3 diabete2
	rename asthma3 asthma2
	rename drnkany5 drnkany4
    rename alcday5 alcday4
    rename sleptim1 sleptime
* iyear 	
    destring iyear, replace
	drop if iyear != 2013
	
* genhlth
	replace genhlth = . if genhlth == 7 | genhlth == 9 
	label define genhlth_lbl 1 "Excellent" 2 "Very good" 3 "Good" 4 "Fair" 5 "Poor"
    label values genhlth genhlth_lbl
    label variable genhlth "Self-reported general health"
	
* physhlth
    replace physhlth = . if physhlth == 77 | physhlth == 99 
    replace physhlth = 0 if physhlth == 88
    label variable physhlth "Number of days physical health not good (past 30)"

* menthlth 
    replace menthlth = . if menthlth == 77 | menthlth == 99
    replace menthlth = 0 if menthlth == 88
    generate poor_menthlth = .
    replace poor_menthlth = 1 if menthlth >= 14
    replace poor_menthlth = 0 if menthlth < 14
    label variable poor_menthlth "1 = 14+ days poor mental health"
    label variable menthlth "Number of days mental health not good (past 30)"

* poorhlth 
    replace poorhlth = . if poorhlth == 77 | poorhlth == 99
    replace poorhlth = 0 if poorhlth == 88
    label variable poorhlth "Days poor health kept from usual activities (past 30)"
	replace poorhlth = 0 if missing(poorhlth) & physhlth == 0 & menthlth == 0
 
* hlthplan 
   replace hlthplan = . if hlthplan == 7 | hlthplan == 9
   label define hlthplan_lbl 1 "Yes - has coverage" 2 "No - no coverage"
   label values hlthplan hlthplan_lbl
   label variable hlthplan "Has any kind of health care coverage"
   generate uninsured = .
   replace uninsured = 1 if hlthplan == 2
   replace uninsured = 0 if hlthplan == 1
   label variable uninsured "1 = No coverage, 0 = Has coverage"

* persdoc2
   replace persdoc2 = . if persdoc2 == 7 | persdoc2 == 9
   label define persdoc_lbl 1 "Yes, only one" 2 "More than one" 3 "No"
   label values persdoc2 persdoc_lbl
   label variable persdoc2 "Has personal doctor or health care provider"

* medcost
   replace medcost = . if medcost == 7 | medcost == 9
   label define medcost_lbl 1 "Yes - couldn't afford doctor" 2 "No - no cost barrier"
   label values medcost medcost_lbl
   label variable medcost "Could not see doctor in past 12 months due to cost"

* checkup1
   replace checkup1 = . if checkup1 == 7 | checkup1 == 9
   label define checkup_lbl ///
    1 "Past year" ///
    2 "Past 2 years" ///
    3 "Past 5 years" ///
    4 "5+ years ago" ///
    8 "Never had checkup"
   label values checkup1 checkup_lbl
   label variable checkup1 "Time since last routine checkup"

 
* exerany2 
    replace exerany2 = . if exerany2 == 7 | exerany2 == 9
    label define exer_lbl 1 "Yes - exercised" 2 "No - did not exercise"
    label values exerany2 exer_lbl
    label variable exerany2 "Any physical activity in past 30 days (not job)"
    generate exercised = .
    replace exercised = 1 if exerany2 == 1
    replace exercised = 0 if exerany2 == 2
    label variable exercised "1 = Participated in physical activity"


* diabete2 
    replace diabete2 = . if inlist(diabete2, 7, 9) //*Recode non-substantive responses to missing
    label define diabete2_lbl 1 "Yes" 2 "Gestational only" 3 "No" 4 "Pre-diabetes"
    label values diabete2 diabete2_lbl
    label variable diabete2 "Ever told by doctor you have diabetes"
    generate diabetes = .
    replace diabetes = 1 if diabete2 == 1
    replace diabetes = 0 if inlist(diabete2, 3, 4)  // excludes gestational
    label variable diabetes "Diagnosed diabetes (excludes gestational/pre-diabetes)"

* cvdinfr4 
    replace cvdinfr4 = . if inlist(cvdinfr4, 7, 9)
    label define cvdinfr4_lbl 1 "Yes" 2 "No"
    label values cvdinfr4 cvdinfr4_lbl
    label variable cvdinfr4 "Ever told had a heart attack (MI)"
	generate heart_attack = .
    replace heart_attack = 1 if cvdinfr4 == 1
    replace heart_attack = 0 if cvdinfr4 == 2
    label variable heart_attack "1 = Ever diagnosed with heart attack"

* cvdcrhd4 
   replace cvdcrhd4 = . if inlist(cvdcrhd4, 7, 9)
   label define cvdcrhd4_lbl 1 "Yes" 2 "No"
   label values cvdcrhd4 cvdcrhd4_lbl
   label variable cvdcrhd4 "Ever told had angina or coronary heart disease"
   generate chd = .
   replace chd = 1 if cvdcrhd4 == 1
   replace chd = 0 if cvdcrhd4 == 2
   label variable chd "1 = Ever diagnosed with CHD (angina/coronary heart disease)"

* cvdstrk3 
    replace cvdstrk3 = . if inlist(cvdstrk3, 7, 9)
    label define cvdstrk3_lbl 1 "Yes" 2 "No"
    label values cvdstrk3 cvdstrk3_lbl
    label variable cvdstrk3 "Ever told had a stroke"
    generate stroke = .
    replace stroke = 1 if cvdstrk3 == 1
    replace stroke = 0 if cvdstrk3 == 2
    label variable stroke "1 = Ever diagnosed with stroke"

* asthma2 
    replace asthma2 = . if inlist(asthma2, 7, 9)
    label define asthma2_lbl 1 "Yes" 2 "No"
    label values asthma2 asthma2_lbl
    label variable asthma2 "Ever diagnosed with asthma"

* asthnow 
    replace asthnow = . if inlist(asthnow, 7, 9) | asthma2 != 1
    label define asthnow_lbl 1 "Yes" 2 "No"
    label values asthnow asthnow_lbl
    label variable asthnow "Still have asthma (among those ever diagnosed)"
    generate current_asthma = .
    replace current_asthma = 1 if asthma2 == 1 & asthnow == 1
    replace current_asthma = 0 if asthma2 == 2
    label variable current_asthma "1 = Currently has asthma"

* qlactlm2 
    replace qlactlm2 = . if inlist(qlactlm2, 7, 9)
    label define qlactlm2_lbl 1 "Yes - Limited" 2 "No - Not limited"
    label values qlactlm2 qlactlm2_lbl
    label variable qlactlm2 "Limited in activities due to health problems"
    generate limited_activities = .
    replace limited_activities = 1 if qlactlm2 == 1
    replace limited_activities = 0 if qlactlm2 == 2
    label variable limited_activities "1 = Limited in activities"


* smoke100 
    replace smoke100 = . if inlist(smoke100, 7, 9)
    label define smoke100_lbl 1 "Yes - Smoked 100+ cigarettes" 2 "No"
    label values smoke100 smoke100_lbl
    label variable smoke100 "Ever smoked 100+ cigarettes in lifetime"
    generate ever_smoked = .
    replace ever_smoked = 1 if smoke100 == 1
    replace ever_smoked = 0 if smoke100 == 2
    label variable ever_smoked "1 = Ever smoked 100+ cigarettes"

* educa 
    replace educa = . if educa == 9
    label define educa_lbl ///
     1 "No school / Kindergarten only" ///
     2 "Grades 1–8" ///
     3 "Some high school" ///
     4 "High school graduate / GED" ///
     5 "Some college or tech school" ///
     6 "College graduate"
    label values educa educa_lbl
    label variable educa "Education level"
	generate educ_level = .
    replace educ_level = 1 if inlist(educa, 1, 2, 3) // Less than HS
    replace educ_level = 2 if educa == 4             // High school
    replace educ_level = 3 if educa == 5             // Some college
    replace educ_level = 4 if educa == 6             // College grad+
    label define educ_level_lbl 1 "Less than HS" 2 "HS Grad" 3 "Some college" 4 "College+"
    label values educ_level educ_level_lbl
    label variable educ_level "Grouped education level"


* employ 
    replace employ = . if employ == 9
    label define employ_lbl ///
     1 "Employed for wages" ///
     2 "Self-employed" ///
     3 "Out of work > 1 year" ///
     4 "Out of work < 1 year" ///
     5 "Homemaker" ///
     6 "Student" ///
     7 "Retired" ///
     8 "Unable to work"
    label values employ employ_lbl
    label variable employ "Current employment status"


* income2  
    replace income2 = . if inlist(income2, 77, 99)
    label define income2_lbl ///
     1 "< $10,000" ///
     2 "$10k–14,999" ///
     3 "$15k–19,999" ///
     4 "$20k–24,999" ///
     5 "$25k–34,999" ///
     6 "$35k–49,999" ///
     7 "$50k–74,999" ///
     8 "$75k or more"
    label values income2 income2_lbl
    label variable income2 "Annual household income (categorical)"
    generate income_group = .
    replace income_group = 1 if inlist(income2, 1, 2, 3)  // <$20K
    replace income_group = 2 if inlist(income2, 4, 5, 6)  // $20K–49,999
    replace income_group = 3 if inlist(income2, 7, 8)     // $50K+
    label define incomegrp_lbl 1 "Low" 2 "Mid" 3 "High"
    label values income_group incomegrp_lbl
    label variable income_group "Grouped household income"

* sex 
    label define sex_lbl 1 "Male" 2 "Female"
    label values sex sex_lbl
    label variable sex "Sex of respondent"
    generate female = (sex == 2)
    label variable female "1 = Female, 0 = Male"

* drnkany4 
    replace drnkany4 = . if inlist(drnkany4, 7, 9)
    label define drnkany_lbl 1 "Yes" 2 "No"
    label values drnkany4 drnkany_lbl
    label variable drnkany4 "Had alcoholic drink in past 30 days"
    generate drank_alcohol = .
    replace drank_alcohol = 1 if drnkany4 == 1
    replace drank_alcohol = 0 if drnkany4 == 2
    label variable drank_alcohol "1 = Drank alcohol in past 30 days"

* alcday4 
    replace alcday4 = . if inlist(alcday4, 777, 888, 999)
    generate alc_days = .
    replace alc_days = (alcday4 - 100) * 4.3 if inrange(alcday4, 101, 199) // If coded as weekly (e.g., 101 = 1 day/week), multiply by 4.3
    replace alc_days = (alcday4 - 200) if inrange(alcday4, 201, 299) //If coded as days in past 30 (e.g., 203 = 3 days), subtract 200
    label variable alc_days "Days drank alcohol in past 30 days (standardized)"
    generate alc_freq = .
    replace alc_freq = 0 if alc_days == 0
    replace alc_freq = 1 if inrange(alc_days, 1, 4)
    replace alc_freq = 2 if inrange(alc_days, 5, 15)
    replace alc_freq = 3 if alc_days > 15
    label define alc_freq_lbl 0 "None" 1 "Occasional" 2 "Moderate" 3 "Frequent"
    label values alc_freq alc_freq_lbl
    label variable alc_freq "Alcohol drinking frequency (grouped)"

* drnk3ge5
    replace drnk3ge5 = . if inlist(drnk3ge5, 77, 99)
    replace drnk3ge5 = 0 if drnk3ge5 == 88
    label variable drnk3ge5 "Times binge drank (4+/5+ drinks) in past 30 days"
    generate binge_drinker = .
    replace binge_drinker = 1 if drnk3ge5 > 0
    replace binge_drinker = 0 if drnk3ge5 == 0
    label variable binge_drinker "1 = Any binge drinking in past 30 days"

* maxdrnks 
    replace maxdrnks = . if inlist(maxdrnks, 77, 99)
    label variable maxdrnks "Max drinks on any day in past 30 days"
	generate high_maxdrinks = .
    replace high_maxdrinks = 1 if maxdrnks >= 8
    replace high_maxdrinks = 0 if maxdrnks < 8
    label variable high_maxdrinks "1 = Max drinks ≥ 8 in past 30 days"

* emtsuprt 
    replace emtsuprt = . if inlist(emtsuprt, 7, 9)
	label define emtsuprt_lbl ///
     1 "Always" ///
     2 "Usually" ///
     3 "Sometimes" ///
     4 "Rarely" ///
     5 "Never"
    label values emtsuprt emtsuprt_lbl
    label variable emtsuprt "How often get emotional support"

* lsatisfy 
    replace lsatisfy = . if inlist(lsatisfy, 7, 9)
    label define lsatisfy_lbl ///
     1 "Very satisfied" ///
     2 "Satisfied" ///
     3 "Dissatisfied" ///
     4 "Very dissatisfied"
    label values lsatisfy lsatisfy_lbl
    label variable lsatisfy "Satisfaction with life"

* qlmentl2
    replace qlmentl2 = . if inlist(qlmentl2, 77, 99)
    replace qlmentl2 = 0 if qlmentl2 == 88
    label variable qlmentl2 "Days felt depressed in past 30"

 * QLSTRES2 (anxious days)
    replace qlstres2 = . if inlist(qlstres2, 77, 99)
    replace qlstres2 = 0 if qlstres2 == 88
    label variable qlstres2 "Days felt anxious in past 30"

* QLHLTH2 (days full of energy)
    replace qlhlth2 = . if inlist(qlhlth2, 77, 99)
    replace qlhlth2 = 0 if qlhlth2 == 88
    label variable qlhlth2 "Days felt healthy/full of energy in past 30"
	
* sleptime 
    replace sleptime = . if inlist(sleptime, 77, 99)
    label variable sleptime "Average hours of sleep in 24-hour period"
    generate short_sleep = .
    replace short_sleep = 1 if sleptime < 7
    replace short_sleep = 0 if sleptime >= 7
    label variable short_sleep "1 = Sleeps <7 hours per night"

* renthom1 
    replace renthom1 = . if inlist(renthom1, 7, 9)
    label define renthom1_lbl ///
     1 "Own" ///
     2 "Rent" ///
     3 "Other arrangement"
    label values renthom1 renthom1_lbl
    label variable renthom1 "Housing status: own or rent"

* scntmony 
    replace scntmony = . if inlist(scntmony, 7, 8, 9)
    label define scntmony_lbl ///
     1 "Always" ///
     2 "Usually" ///
     3 "Sometimes" ///
     4 "Rarely" ///
     5 "Never"
label values scntmony scntmony_lbl
label variable scntmony "How often worried about paying rent/mortgage (past 12 months)"
    generate housing_stress = .
    replace housing_stress = 1 if inlist(scntmony, 1, 2, 3)
    replace housing_stress = 0 if inlist(scntmony, 4, 5)
    label variable housing_stress "1 = Worried about housing costs (past year)"
	
* scntmeal 
    replace scntmeal = . if inlist(scntmeal, 7, 8, 9)
    label define scntmeal_lbl ///
     1 "Always" ///
     2 "Usually" ///
     3 "Sometimes" ///
     4 "Rarely" ///
     5 "Never"
    label values scntmeal scntmeal_lbl
    label variable scntmeal "How often worried about buying nutritious meals"

* _rfhlth 
    replace _rfhlth = . if _rfhlth == 9
    label define rfhlth_lbl 1 "Good or better health" 2 "Fair or poor health"
    label values _rfhlth rfhlth_lbl
    label variable _rfhlth "Self-rated health: good or better vs fair/poor"


* _hcvu65 
    replace _hcvu65 = . if _hcvu65 == 9
    label define hcvu65_lbl 1 "Insured (age 18–64)" 2 "Uninsured (age 18–64)"
    label values _hcvu65 hcvu65_lbl
    label variable _hcvu65 "Health insurance coverage status (ages 18–64)"
	
* race2/ _race 
    generate race2 = _race
    replace race2 = . if race2 == 9  // Drop missing/don't know/refused
    label define race2_lbl ///
     1 "White NH" ///
     2 "Black NH" ///
     3 "AI/AN NH" ///
     4 "Asian NH" ///
     5 "NH/PI NH" ///
     6 "Other NH" ///
     7 "Multiracial NH" ///
     8 "Hispanic"
    label values race2 race2_lbl
    label variable race2 "Race/Ethnicity (mutually exclusive)"

* marital
    replace marital = . if marital == 9
    label define marital_lbl ///
     1 "Married" ///
     2 "Divorced" ///
     3 "Widowed" ///
     4 "Separated" ///
     5 "Never married" ///
     6 "Unmarried couple"
    label values marital marital_lbl
    label variable marital "Marital status"

* hlthcvrg - Insurance type breakdown

    generate has_medicaid = strpos(hlthcvrg, "04") > 0 if !missing(hlthcvrg)
    gen has_employer = strpos(hlthcvrg, "01") > 0 if !missing(hlthcvrg)
    generate uninsured_now = hlthcvrg == "88" if !missing(hlthcvrg)
    generate other_ins = strpos(hlthcvrg, "07") > 0 if !missing(hlthcvrg)
    generate ins_type = . // Mutually exclusive category
    replace ins_type = 1 if has_medicaid == 1
    replace ins_type = 2 if has_employer == 1 & ins_type == .
    replace ins_type = 3 if uninsured_now == 1
    replace ins_type = 4 if other_ins == 1 & ins_type == .
    label define ins_type_lbl 1 "Medicaid" 2 "Employer" 3 "Uninsured" 4 "Other"
    label values ins_type ins_type_lbl
    label variable ins_type "Main insurance type (from HLTHCVRG)"
	
* nocov121
    generate ever_uninsured = .
    replace ever_uninsured = 1 if nocov121 == 1
    replace ever_uninsured = 0 if nocov121 == 2
    label variable ever_uninsured "Uninsured at any time in past 12 months"
     
* _ageg5yr

    replace _ageg5yr = . if _ageg5yr == 14
    label variable _ageg5yr "Reported age in 5-year categories"
	generate agecat4 = .
    replace agecat4 = 1 if inlist(_ageg5yr, 1, 2, 3)
    replace agecat4 = 2 if inlist(_ageg5yr, 4, 5, 6)
    replace agecat4 = 3 if inlist(_ageg5yr, 7, 8, 9)
    replace agecat4 = 4 if inlist(_ageg5yr, 10, 11, 12, 13)
    label define agecat4_lbl 1 "18–34" 2 "35–49" 3 "50–64" 4 "65+"
    label values agecat4 agecat4_lbl
    label variable agecat4 "Grouped age category"
	
* _racegr3 
    generate race4 = .
    replace race4 = 1 if _racegr3 == 1   // White NH
    replace race4 = 2 if _racegr3 == 2   // Black NH
    replace race4 = 3 if _racegr3 == 5   // Hispanic
    replace race4 = 4 if inlist(_racegr3, 3, 4)   // Other + Multiracial
    label define race4_lbl 1 "White NH" 2 "Black NH" 3 "Hispanic" 4 "Other"
    label values race4 race4_lbl
    label variable race4 "Race/Ethnicity (collapsed from _RACEGR3)"
	
capture confirm numeric variable hlthcvrg
if !_rc {
    tostring hlthcvrg, replace
}


		
	save "brfss2013_cleaned.dta", replace
	
	
	capture log close 
