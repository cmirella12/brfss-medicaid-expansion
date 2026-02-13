*** Append fixed data sets by sections 
*** 



    cd "~/Documents/ECO722_Project/Analysis"

    *1st chunk 
    use "../Data/brfss2010_fix.dta", clear
    generate year = 2010
    append using "../Data/brfss2011_fix.dta"
    append using "../Data/brfss2012_fix.dta"
    append using "../Data/brfss2013_fix.dta"
    append using "../Data/brfss2014_fix.dta"
    append using "../Data/brfss2015_fix.dta"
    compress
    save "../Data/brfss_2010_2015.dta", replace
	* 2nd chunk 
	use "../Data/brfss2016_fix.dta", clear
    append using "../Data/brfss2017_fix.dta"
    append using "../Data/brfss2018_fix.dta"
    append using "../Data/brfss2019_fix.dta"
    append using "../Data/brfss2020_fix.dta"
    compress
    save "../Data/brfss_2016_2020.dta", replace
    * Final merge 
	use "../Data/brfss_2010_2015.dta", clear
    append using "../Data/brfss_2016_2020.dta"
    compress
    save "../Data/brfss_2010_2020_all.dta", replace
	
	 use "../Data/brfss_2010_2020_all.dta", clear 
	 
	 
	
	
	
	
