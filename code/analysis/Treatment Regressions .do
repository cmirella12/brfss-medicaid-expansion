*** Using appened data set 
*** creating treatment variables 
*** exporting table on probability of health risk 

    use "brfss_2010_2018_combined.dta", clear
    global lname "Charros"
    global ex 1
    log using "Project_${ex}_${lname}", replace
	
* Defining treatment group and control groups 
    generate expansion_state = 0
    replace expansion_state = 1 if inlist(_state, 4, 5, 6, 8, 9, 10, 11, 15, 17, 19, 21, 24, 25, 27, 32, 34, 35, 36, 38, 39, 41, 44, 50, 53, 54)
    generate post2014 = iyear >= 2014 // post 2014 
    label variable post2014 "Post-period (1 = 2014 and after)"
    generate DiD = expansion_state * post2014 // interaction term 
    label variable DiD "Interaction: Expansion × Post-2014"
    tab _state expansion_state if iyear == 2014 // check
    tab DiD 

* age restriction to 64 because of medicare coverage for elders 
    drop if _ageg5yr >= 10  // Since age group 10 = 65–69
	drop if _ageg5yr == 14

	label define ageg5yr_lbl ///
      1 "18–24" ///
      2 "25–29" ///
      3 "30–34" ///
      4 "35–39" ///
      5 "40–44" ///
      6 "45–49" ///
      7 "50–54" ///
      8 "55–59" ///
      9 "60–64"
    label values _ageg5yr ageg5yr_lbl
    label variable _ageg5yr "5-Year Age Category"

* genhlth 
    ologit genhlth i.expansion_state##i.post2014 i.sex i.race2 i.income2 i.educa, vce(cluster _state)
    margins expansion_state#post2014, predict(outcome(1))
    marginsplot, title("Probability of Excellent Health by Group") ylabel(, grid)
    graph export "fig_genhlth_dydx.png", replace width(1000)
	
* physhlth 
    nbreg physhlth i.expansion_state##i.post2014 i.sex i.race2 i.income2 i.educa, vce(cluster _state)
	margins expansion_state#post2014
    marginsplot, title("Physically Unhealthy Days by Group") ylabel(, grid)
    graph export "fig_physhlth_dydx.png", replace width(1000)
	
* menthlth
    nbreg menthlth i.expansion_state##i.post2014 ///
      i.sex i.race2 i.income2 i.educa, vce(cluster _state)
	margins expansion_state#post2014
    marginsplot, title("Mentally Unhealthy Days by Group") ylabel(, grid)
    graph export "fig_menthlth_dydx.png", replace width(1000)
	
* effect on personal doctor access after expansion 
    generate has_doc = . // create binary variable 
    replace has_doc = 1 if inlist(persdoc2, 1, 2)
    replace has_doc = 0 if persdoc2 == 3
    label var has_doc "Has a personal doctor"
    logit has_doc i.expansion_state##i.post2014 ///
      i.sex i.race2 i.income2 i.educa, vce(cluster _state)
    margins expansion_state#post2014
    marginsplot, title("Probability of Having a Personal Doctor") ylabel(, grid)
    graph export "fig_hasdoc_dydx.png", replace width(1000)
	
 * effect on medcost
    generate couldnt_afford = .
    replace couldnt_afford = 1 if medcost == 1
    replace couldnt_afford = 0 if medcost == 2
    label variable couldnt_afford "Could not see doctor due to cost"
    logit couldnt_afford i.expansion_state##i.post2014 ///
    i.sex i.race2 i.income2 i.educa, vce(cluster _state)
    margins expansion_state#post2014
    marginsplot, title("Probability of Cost-Related Care Barrier") ylabel(, grid)
    graph export "fig_medcost_dydx.png", replace width(1000)

* effect on checkup1
    drop if checkup1 > 4  // Optional if you want to restrict to clean ordinal levels
    ologit checkup1 i.expansion_state##i.post2014 ///
    i.sex i.race2 i.income2 i.educa, vce(cluster _state)
    margins expansion_state#post2014, predict(outcome(1))
    marginsplot, title("Probability of Recent Checkup by Group") ylabel(, grid)
    graph export "fig_checkup_dydx.png", replace width(1000)

* major health outcomes- diabetes 
    logit diabetes i.expansion_state##i.post2014 ///
    i.sex i.race2 i.income2 i.educa, vce(cluster _state)
    margins expansion_state#post2014
    marginsplot, title("Probability of Diabetes Diagnosis") ylabel(, grid)
    graph export "fig_diabetes_dydx.png", replace width(1000)


* heart attack 
    logit heart_attack i.expansion_state##i.post2014 ///
    i.sex i.race2 i.income2 i.educa, vce(cluster _state) 
    margins expansion_state#post2014
    marginsplot, title("Probability of Heart Attack History") ylabel(, grid)
    graph export "fig_heart_dydx.png", replace width(1000)


* stroke 
    logit stroke i.expansion_state##i.post2014 ///
    i.sex i.race2 i.income2 i.educa, vce(cluster _state)
    margins expansion_state#post2014
	margins, dydx(post2014) at(expansion_state=(0 1))
    marginsplot, title("Probability of Stroke History") ylabel(, grid)
    graph export "fig_stroke_dydx.png", replace width(1000)


    capture log close 
