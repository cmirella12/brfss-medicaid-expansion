*** append all years into master data set 

    cd "~/Documents/ECO722_Project/Analysis"

* Start with 2010
use "../Data/brfss2010_cleaned.dta", clear

* Append remaining years
local years 2011 2012 2013 2014 2015 2016 2017 2018  

foreach y of local years {
    append using "../Data/brfss`y'_cleaned.dta"
}

    drop qlmentl2 qlstres2 qlhlth2 emtsuprt drnkdri2 alc_days _race _racegr3 
	
* Save the full dataset
save "../Data/brfss_2010_2018_combined.dta", replace
