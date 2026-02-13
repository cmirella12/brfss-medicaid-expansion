# Medicaid Expansion and Health Outcomes (BRFSS 2010–2018)

## Project Overview
This project evaluates the effects of the Affordable Care Act (ACA) Medicaid expansion on health outcomes, access to care, and major health conditions among non-elderly adults in the United States.

Because Medicaid expansion was adopted at different times across states, the policy provides a natural experiment that allows comparison between expansion and non-expansion states over time.

## Data
Behavioral Risk Factor Surveillance System (BRFSS), 2010–2018.

Due to file size and data-sharing restrictions, the combined dataset is not included in this repository. Instructions for replication are provided in the `data/` folder.

## Methodology
A difference-in-differences (DiD) framework is used to estimate the effect of Medicaid expansion by comparing:

- Expansion vs. non-expansion states  
- Pre-2014 vs. post-2014 periods  

Models control for demographic characteristics including sex, race, income, and education, with standard errors clustered at the state level.

## Key Findings
Results suggest that Medicaid expansion was associated with:

- Increased likelihood of having a personal doctor  
- Reduced cost-related barriers to care  
- Modest changes in self-reported health outcomes  

Changes in major health conditions such as diabetes, heart attack, and stroke were not statistically significant during the study period, though patterns may reflect gradual improvements in prevention and earlier diagnosis.

Overall, the findings highlight the role of Medicaid expansion in improving access to care and reducing disparities among non-elderly adults.

