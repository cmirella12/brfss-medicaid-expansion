*** summary stats 

    use "brfss_2010_2018_cleaned.dta", clear 
	
	
* Keep analysis sample
keep if iyear >= 2010 & iyear <= 2018 & age >= 19 & age <= 64

* Label variables (optional, if not done yet)
label variable has_doc "Has personal doctor (1=yes)"
label variable couldnt_afford "Couldn't afford care (1=yes)"
label variable diabetes "Has diabetes (1=yes)"
label variable heart_attack "Had heart attack (1=yes)"
label variable stroke "Had stroke (1=yes)"
label variable sex "Female (1=yes)"
label variable race2 "Race category"
label variable income2 "Income category"
label variable educa "Education category"

    tab income2 
	tab educa 
	tab race2, missing 
	summarize physhlth menthlth checkup1

* Generate summary stats table
estpost summarize has_doc couldnt_afford diabetes ///
    heart_attack stroke sex race2 income2 educa, detail

esttab using "summary_binary_vars.tex", ///
    cells("mean(fmt(2)) sd(fmt(2)) min max") ///
    label nonumber nomtitle booktabs ///
    title("Summary Statistics for Binary and Categorical Variables") ///
    alignment(c) ///
    replace
