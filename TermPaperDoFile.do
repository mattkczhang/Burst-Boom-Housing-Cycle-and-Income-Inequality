*Kaichong (Matt) Zhang
*Introduction to Econometrics ECON 381
*Term Paper do file

clear
capture log close
log using TermPaperLog.log, replace
ssc install ivreg2
ssc install ranktest

*Import and Merge data
cd "/Users/chonge/Documents/Document/Macalester/2020 Spring/Introduction to Econometrics/Term Paper/Data"

*Merging data
use GiniIndex2010, replace
merge 1:1 County using GiniIndex2011
keep if _merge == 3
drop _merge
merge 1:1 County using GiniIndex2012
keep if _merge == 3
drop _merge
merge 1:1 County using GiniIndex2013
keep if _merge == 3
drop _merge
merge 1:1 County using GiniIndex2014
keep if _merge == 3
drop _merge
merge 1:1 County using SalesData
keep if _merge == 3
drop _merge
merge 1:1 County using MedianPriceData
keep if _merge == 3
drop _merge
merge 1:1 County using Edu2010
keep if _merge == 3
drop _merge
merge 1:1 County using Edu2011
keep if _merge == 3
drop _merge
merge 1:1 County using Edu2012
keep if _merge == 3
drop _merge
merge 1:1 County using Edu2013
keep if _merge == 3
drop _merge
merge 1:1 County using Edu2014
keep if _merge == 3
drop _merge
merge 1:1 County using Race2010
keep if _merge == 3
drop _merge
merge 1:1 County using Race2011
keep if _merge == 3
drop _merge
merge 1:1 County using Race2012
keep if _merge == 3
drop _merge
merge 1:1 County using Race2013
keep if _merge == 3
drop _merge
merge 1:1 County using Race2014
keep if _merge == 3
drop _merge
merge 1:1 County using medianFamilyIncome2010
keep if _merge == 3
drop _merge
merge 1:1 County using medianFamilyIncome2011
keep if _merge == 3
drop _merge
merge 1:1 County using medianFamilyIncome2012
keep if _merge == 3
drop _merge
merge 1:1 County using medianFamilyIncome2013
keep if _merge == 3
drop _merge
merge 1:1 County using medianFamilyIncome2014
keep if _merge == 3
drop _merge
merge 1:1 County using IDR2010
keep if _merge == 3
drop _merge
merge 1:1 County using IDR2011
keep if _merge == 3
drop _merge
merge 1:1 County using IDR2012
keep if _merge == 3
drop _merge
merge 1:1 County using IDR2013
keep if _merge == 3
drop _merge
merge 1:1 County using IDR2014
keep if _merge == 3
drop _merge
merge 1:1 County using Mortgage2010
keep if _merge == 3
drop _merge
merge 1:1 County using Mortgage2011
keep if _merge == 3
drop _merge
merge 1:1 County using Mortgage2012
keep if _merge == 3
drop _merge
merge 1:1 County using Mortgage2013
keep if _merge == 3
drop _merge
merge 1:1 County using Mortgage2014
keep if _merge == 3
drop _merge
merge 1:1 County using Rent2010
keep if _merge == 3
drop _merge
merge 1:1 County using Rent2011
keep if _merge == 3
drop _merge
merge 1:1 County using Rent2012
keep if _merge == 3
drop _merge
merge 1:1 County using Rent2013
keep if _merge == 3
drop _merge
merge 1:1 County using Rent2014
keep if _merge == 3
drop _merge
merge 1:1 County using GDP2010
keep if _merge == 3
drop _merge
merge 1:1 County using GDP2011
keep if _merge == 3
drop _merge
merge 1:1 County using GDP2012
keep if _merge == 3
drop _merge
merge 1:1 County using GDP2013
keep if _merge == 3
drop _merge
merge 1:1 County using GDP2014
keep if _merge == 3
drop _merge

*reshape the data to the panel data
reshape long Gini_index Sales MedianPrice HighSchoolOrHigher BachelorOrHigher Whitepercentage Blackpercentage Nativepercentage Asianpercentage Pacificpercentage Otherpercentage MedianFamilyIncome IDRpercentage MortgageAvail Rent GDPP, i(County) j(year)
encode County, gen(Countyname)
drop County
order Countyname

*variable adjustment
generate MedianPriceinThousands = 0
replace MedianPriceinThousands = MedianPrice/1000
generate SalesinThousand = 0
replace SalesinThousand = Sales/1000
generate NonWhitePercentage = 0
replace NonWhitePercentage = 1-Whitepercentage
generate MortgageRateQ1 = 0
replace MortgageRateQ1 = 4.995833333 if year == 2010
replace MortgageRateQ1 = 4.846923077 if year == 2011
replace MortgageRateQ1 = 3.922307692 if year == 2012
replace MortgageRateQ1 = 3.496923077 if year == 2013
replace MortgageRateQ1 = 4.364615385 if year == 2014
generate MortgageRateQ2 = 0
replace MortgageRateQ2 = 4.922307692 if year == 2010
replace MortgageRateQ2 = 4.650769231 if year == 2011
replace MortgageRateQ2 = 3.794615385 if year == 2012
replace MortgageRateQ2 = 3.672307692 if year == 2013
replace MortgageRateQ2 = 4.227692308 if year == 2014
generate MortgageRateQ3 = 0
replace MortgageRateQ3 = 4.447142857 if year == 2010
replace MortgageRateQ3 = 4.291538462 if year == 2011
replace MortgageRateQ3 = 3.553846154 if year == 2012
replace MortgageRateQ3 = 4.44 if year == 2013
replace MortgageRateQ3 = 4.135384615 if year == 2014
generate MortgageRateQ4 = 0
replace MortgageRateQ4 = 4.436153846 if year == 2010
replace MortgageRateQ4 = 4.002307692 if year == 2011
replace MortgageRateQ4 = 3.359230769 if year == 2012
replace MortgageRateQ4 = 4.293076923 if year == 2013
replace MortgageRateQ4 = 3.963571429 if year == 2014
generate RentMillion = 0
replace RentMillion = Rent/1000000
gen GDPPThousand = 0 
replace GDPPThousand = GDPP/1000
gen MedianFamilyIncomeT = MedianFamilyIncome/1000
gen bmt = HighSchoolOrHigher - BachelorOrHigher

*Label the variables:
lab var County "the name of counties"
lab var year "year of the data"
lab var Sales "average monthly volumne of sales"
lab var MedianPrice "annual median house price"
lab var HighSchoolOrHigher "percentage of population with high school or above degree"
lab var BachelorOrHigher "percentage of population with bachelor or above degree"
lab var Whitepercentage "percentage of while population"
lab var Blackpercentage "percentage of black population"
lab var Nativepercentage "percentage of native population"
lab var Asianpercentage "percentage of asian population"
lab var Pacificpercentage "percentage of pacific population"
lab var Otherpercentage "percentage of other population"
lab var MedianFamilyIncome "median family income in the past 12 months"
lab var MedianPriceinThousands "median price of housing market in thousands dollar"
lab var SalesinThousand "average sales of housig market in thousands dollar"
lab var NonWhitePercentage "percentage of non-white population"
lab var Rent "aggregate gross rent in dollar"
lab var GDPP "GDP per capita"
lab var bmt "percentage of population with only high school or college degree"
lab var GDPPThousand "GDP per capita in thousand dollars"
lab var RentMillion "aggregate gross rent in million dollars"
lab var MedianFamilyIncomeT "median family income in thousand dollars"

*Summarize each variable
sum 
sum Gini_index
sum MedianPrice
sum Sales
sktest Gini_index MedianPrice Sales 
outreg2 using SummStat.doc, word title(Table 1: Summary Statistics) sideway sum(log) keep(Gini_index Sales MedianPrice HighSchoolOrHigher BachelorOrHigher MedianFamilyIncome Rent GDPP NonWhitePercentage) eqkeep(N mean sd min max) replace dec(2) label addnote(Note: index is roughly normal and both average monthly sales and median house price are right skewed)

*run the simple regression
reg Gini_index SalesinThousand, robust
outreg2 using Table_2.doc, word title(Table 2: Pooled Ordinary Least Square Models) ctitle(MODEL bivariate_1) replace label addnote(Note: two bivariate models show significant correlations; two partial models show much less economically signfiicant estimated coefficients of both variables of interest; two full models suggest that the variables of interest are statistically significant again)
reg Gini_index MedianPriceinThousands, robust
outreg2 using Table_2.doc, ctitle(MODEL bivariate_2) append label
reg Gini_index SalesinThousand HighSchoolOrHigher BachelorOrHigher MedianFamilyIncomeT, robust
outreg2 using Table_2.doc, ctitle(MODEL partial_1) append label
reg Gini_index MedianPriceinThousands HighSchoolOrHigher BachelorOrHigher MedianFamilyIncomeT, robust
outreg2 using Table_2.doc, ctitle(MODEL partial_2) append label 
reg Gini_index SalesinThousand HighSchoolOrHigher BachelorOrHigher NonWhitePercentage MedianFamilyIncomeT RentMillion GDPPThousand, robust
outreg2 using Table_2.doc, ctitle(MODEL full_1) append label
reg Gini_index MedianPriceinThousands HighSchoolOrHigher BachelorOrHigher NonWhitePercentage MedianFamilyIncomeT RentMillion GDPPThousand, robust
outreg2 using Table_2.doc, ctitle(MODEL full_2) append label 

*multicolinearity
estat vif

*heteroskedasticity
estat hettest

*basic visualization
*residual plot
rvfplot, yline(0) title("Residual plot for the full model")
*scatterplot
twoway (scatter Gini_index MedianPrice) (lfitci Gini_index MedianPrice), title("Figure 1: Relationship between Gini index and median house price", size(medium large)) ytitle("Gini index")
scatter Gini_index MedianPrice if Gini_index>0.55, mlabel(Countyname) mlabsize(1)
twoway (scatter Gini_index Sales) (lfitci Gini_index Sales), title("Figure 2: Relationship between Gini index and average monthly sales", size(medium large)) ytitle("Gini index")
twoway (scatter Gini_index BachelorOrHigher) (lfitci Gini_index BachelorOrHigher), title("Figure 3: Relationship between Gini index and percentage of Bachelor or above", size(medium small)) ytitle("Gini index")
twoway (scatter Gini_index HighSchoolOrHigher) (lfitci Gini_index HighSchoolOrHigher), title("Figure 4: Relationship between Gini index and percentage of high school or above", size(Medium small)) ytitle("Gini index")
twoway (scatter Sales BachelorOrHigher) (lfitci Gini_index BachelorOrHigher)
twoway (scatter Sales HighSchoolOrHigher) (lfitci Gini_index HighSchoolOrHigher)
twoway (scatter Gini_index Rent) (lfitci Gini_index Rent), title("Figure 8: Relationship between Gini index and total rent", size(medium)) ytitle("Gini index")
twoway (scatter Gini_index NonWhitePercentage) (lfitci Gini_index NonWhitePercentage), title("Figure 7: Relationship between Gini index and percentage of nonwhite", size(medium)) ytitle("Gini index")
twoway (scatter Gini_index MedianFamilyIncome) (lfitci Gini_index MedianFamilyIncome), title("Figure 6: Relationship between Gini index and median family income", size(medium large)) ytitle("Gini index")
twoway (scatter Gini_index bmt) (lfitci Gini_index bmt), title("Figure 5: Relationship between Gini index and percentage of high school and college", size(medium large)) ytitle("Gini index")
twoway (scatter Gini_index GDPP) (lfitci Gini_index GDPP), title("Figure 9: Relationship between Gini index and GDP per capita", size(medium)) ytitle("Gini index")
twoway (scatter GDPP Sales) (lfitci GDPP Sales), title("Figure 10: Relationship between GDP per capita and average monthly sales", size(medium)) ytitle("GDP per capita")
twoway (scatter GDPP MedianPrice) (lfitci GDPP MedianPrice), title("Figure 11: Relationship between GDP per capita and median house price", size(medium)) ytitle("GDP per capita")



*kdensity
kdensity Gini_index, title("Kdensity for Gini index")
kdensity MedianPrice, title("Kdensity for median house price")
kdensity Sales, title("Kdensity for house sales")


*fixed effect model
*entity-demeaned
xtset Countyname year
xtsum Gini_index
xtreg Gini_index SalesinThousand  HighSchoolOrHigher BachelorOrHigher MedianFamilyIncomeT, fe
outreg2 using Table_3.doc, word title(Table 3: Fixed Effect models) ctitle(MODEL entity_demeaned_1) replace label addtext(Country FE, YES) e(corr, F_f) addnote(Note: the average monthly sales is both statistically and economically signfiicant, implying the causality between the dynamic of housing market and income inequality)
xtreg Gini_index MedianPriceinThousands HighSchoolOrHigher BachelorOrHigher MedianFamilyIncomeT, fe
outreg2 using Table_3.doc, ctitle(MODEL entity_demeaned_2) append label addtext(Country FE, YES) e(corr, F_f)

xtreg Gini_index  SalesinThousand HighSchoolOrHigher BachelorOrHigher MedianFamilyIncomeT GDPPThousand, fe
outreg2 using Table_5.doc, word title(Table 5: Fixed Effect models with GDP per capita) ctitle(MODEL sales) replace label addtext(Country FE, YES) e(corr, F_f) addnote(Note: GDP per capita is also significant in the entity demeaned model, implying that the macro level factors are also affecting income inequality)
xtreg Gini_index  MedianPriceinThousands HighSchoolOrHigher BachelorOrHigher MedianFamilyIncomeT GDPPThousand, fe
outreg2 using Table_5.doc, ctitle(MODEL median_price) append label addtext(Country FE, YES) e(corr, F_f)

*time effect
xtreg Gini_index SalesinThousand  HighSchoolOrHigher BachelorOrHigher MedianFamilyIncomeT i.year, fe
outreg2 using Table_4.doc, word title(Table 4: Fixed Effect models) ctitle(MODEL time_simple_1 ) replace label addtext(Country FE, YES, Year FE, YES) addnote(Note: GDP per capita is significant in the time fixed effect models, implying that the dynamic of housing market failed to affect the income inequality when we consider both cross time and cross county variations)
xtreg Gini_index  SalesinThousand HighSchoolOrHigher BachelorOrHigher MedianFamilyIncomeT GDPPThousand i.year, fe
outreg2 using Table_4.doc, ctitle(MODEL time_full_1) append label addtext(Country FE, YES, Year FE, YES)
xtreg Gini_index  MedianPriceinThousands HighSchoolOrHigher BachelorOrHigher MedianFamilyIncomeT i.year, fe
outreg2 using Table_4.doc, ctitle(MODEL time_simple_2) append label addtext(Country FE, YES, Year FE, YES)
xtreg Gini_index  MedianPriceinThousands HighSchoolOrHigher BachelorOrHigher MedianFamilyIncomeT GDPPThousand i.year, fe
outreg2 using Table_4.doc, ctitle(MODEL time_full_2) append label addtext(Country FE, YES, Year FE, YES)

*instrumental variable
reg SalesinThousand RentMillion NonWhitePercentage HighSchoolOrHigher BachelorOrHigher MedianFamilyIncomeT
outreg2 using Table_6.doc, word title(Table 6: Instrumental Variable models) ctitle(MODEL iv_1_FirstStage) replace label e(F) addtext(Prob>F, 0.0000) addnote(Note: the instrumental variable models show that that rent is a valid instrumental variable and reconfirm the impact of the dynamic of housing market on income inequality)
reg SalesinThousand RentMillion NonWhitePercentage HighSchoolOrHigher BachelorOrHigher MedianFamilyIncomeT
outreg2 using Table_6.doc, ctitle(MODEL iv_1_FirstStage_rentonly) append label e(F) addtext(Prob>F, 0.0000)
ivreg2 Gini_index (SalesinThousand = RentMillion) HighSchoolOrHigher BachelorOrHigher MedianFamilyIncomeT, first
outreg2 using Table_6.doc, ctitle(MODEL iv_1_SecondStage) append label
reg MedianPriceinThousands RentMillion NonWhitePercentage HighSchoolOrHigher BachelorOrHigher MedianFamilyIncomeT
outreg2 using Table_6.doc, ctitle(MODEL iv_1_FirstStage) append label e(F) addtext(Prob>F, 0.0000)
reg MedianPriceinThousands RentMillion HighSchoolOrHigher BachelorOrHigher MedianFamilyIncomeT
outreg2 using Table_6.doc, ctitle(MODEL iv_1_FirstStage_rentonly) append label e(F) addtext(Prob>F, 0.0000)
ivreg2 Gini_index (MedianPriceinThousands = RentMillion) HighSchoolOrHigher BachelorOrHigher NonWhitePercentage MedianFamilyIncomeT, first
outreg2 using Table_6.doc, ctitle(MODEL iv_2) append label
