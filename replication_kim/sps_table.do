use "sps_main.dta", clear 

ssc install estout 
* the module "estout" should be installed before running the following lines

*******************
* Main Manuscript *
*******************

* Table 1: Political Conflicts and Food Imports Refusals

eststo clear
eststo: xtreg sps_food_measures log_l1_gdelt_gs_conf_mil_nonecn, fe cluster(country_id)
eststo: xtreg sps_food_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr, fe cluster(country_id)
eststo: xtreg sps_food_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr i.yq_id, fe cluster(country_id)
eststo: xtreg sps_food_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr i.ym, fe cluster(country_id)

eststo: xtpoisson sps_food_measures log_l1_gdelt_gs_conf_mil_nonecn, fe robust
eststo: xtpoisson sps_food_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr, fe robust
eststo: xtpoisson sps_food_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr i.yq_id, fe robust
eststo: xtpoisson sps_food_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr i.ym, fe robust

esttab using "Table1.tex", label ///
 keep(log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr ) ///
 order(log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr ) ///
 nonotes se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps nodepvars mtitles("" "" "" "" "" "" "" "") 
 
* Command that generates the in-text numbers for the sentence "With monthly Goldstein scores ranging from 0 to 3327.4, this constitutes a substantial effect."

sum gdelt_gs_conf_mil_nonecon 
local intext_min = r(min)
local intext_max = r(max)

display `intext_min'
display `intext_max' 
 
* Table 2: Food Refusals: Two-Part Model

ssc install twopm 
* the module "twopm" should be installed before running the following lines

eststo clear
eststo: xi: twopm sps_food_measures log_l1_gdelt_gs_conf_mil_nonecn i.country_id , firstpart(probit) secondpart(regress) cluster(country_id)
eststo: xi: twopm sps_food_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr i.country_id , firstpart(probit) secondpart(regress) cluster(country_id)
eststo: xi: twopm sps_food_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr i.country_id i.yq_id , firstpart(probit) secondpart(regress) cluster(country_id)
eststo: xi: twopm sps_food_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr i.country_id i.ym , firstpart(probit) secondpart(regress) cluster(country_id)

esttab using "Table2.tex", label ///
 keep(log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr ) ///
 order(log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr ) ///
 nonotes se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps nodepvars mtitles("" "" "" "") 

* Command that generates information on the entry port of refusals of South Korean food products and cosmetics (footnote 19)
 
use "sps_korea_port.dta", clear
 
tab1 entry if ym > 201606 & ym < 201711 

**************************
* Supplementary Appendix *
**************************

use "sps_main.dta", clear 
 
* Table A1: Summary Statistics

label var log_l1_gdelt_gs_conf_mil_nonecn "Goldstein Conflict Score (Logged, t-1)"

eststo clear
estpost summarize sps_food_measures log_sps_food_measures sps_measures log_sps_measures  log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr log_l1_trade_im_relevant_yr
esttab using "TableA1.tex", cells("count mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") nomtitle nonumber label replace b(3)

* Table A2: List of countries with the most food refusals, 2011-2019

bysort country: egen total_sps = total(sps_food_measures)
bysort country: gen n = _n
sort total_sps
list country_name total_sps if n == 1 & total_sps > 890

* Talbe A3: Food Refusals: OLS with Log-Transformed Outcome Variable

eststo clear
eststo: xtreg log_sps_food_measures log_l1_gdelt_gs_conf_mil_nonecn , fe cluster(country_id)
eststo: xtreg log_sps_food_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr , fe cluster(country_id)
eststo: xtreg log_sps_food_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr i.yq_id , fe cluster(country_id)
eststo: xtreg log_sps_food_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr i.ym , fe cluster(country_id)

esttab using "TableA3.tex", label ///
 keep(log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr ) ///
 order(log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr ) ///
 nonotes se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps nodepvars mtitles("" "" "" "") 

* Table A4: Food & Cosmetics Refusals: OLS & Poisson

eststo clear
eststo: xtreg sps_measures log_l1_gdelt_gs_conf_mil_nonecn , fe cluster(country_id)
eststo: xtreg sps_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr , fe cluster(country_id)
eststo: xtreg sps_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr i.yq_id , fe cluster(country_id)
eststo: xtreg sps_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr i.ym , fe cluster(country_id)

eststo: xtpoisson sps_measures log_l1_gdelt_gs_conf_mil_nonecn , fe robust
eststo: xtpoisson sps_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr , fe robust
eststo: xtpoisson sps_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr i.yq_id , fe robust
eststo: xtpoisson sps_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr i.ym , fe robust

esttab using "TableA4.tex", label ///
 keep(log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr ) ///
 order(log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_food_yr ) ///
 nonotes se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps nodepvars mtitles("" "" "" "" "" "" "" "") 
 
* Table A5: Food & Cosmetics Refusals: Two-Part Model

eststo clear
eststo: xi: twopm sps_measures log_l1_gdelt_gs_conf_mil_nonecn i.country_id , firstpart(probit) secondpart(regress) cluster(country_id)
eststo: xi: twopm sps_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_relevant_yr i.country_id , firstpart(probit) secondpart(regress) cluster(country_id)
eststo: xi: twopm sps_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_relevant_yr i.country_id i.yq_id , firstpart(probit) secondpart(regress) cluster(country_id)
eststo: xi: twopm sps_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_relevant_yr i.country_id i.ym , firstpart(probit) secondpart(regress) cluster(country_id)

esttab using "TableA5.tex", label ///
 keep(log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_relevant_yr ) ///
 order(log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_relevant_yr ) ///
 nonotes se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps nodepvars mtitles("" "" "" "") 

* Table A6: Food & Cosmetics Refusals: OLS with Log-Transformed Outcome Variable

eststo clear
eststo: xtreg log_sps_measures log_l1_gdelt_gs_conf_mil_nonecn , fe cluster(country_id)
eststo: xtreg log_sps_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_relevant_yr , fe cluster(country_id)
eststo: xtreg log_sps_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_relevant_yr i.yq_id , fe cluster(country_id)
eststo: xtreg log_sps_measures log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_relevant_yr i.ym , fe cluster(country_id)

esttab using "TableA6.tex", label ///
 keep(log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_relevant_yr ) ///
 order(log_l1_gdelt_gs_conf_mil_nonecn log_l1_susceptible_all log_l1_trade_im_relevant_yr ) ///
 nonotes se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps nodepvars mtitles("" "" "" "") 
