clear all
insheet using "/Users/rasmuswiese/Dropbox/Fiscal rules and fiscal consolidations/Data and dofile/fis.adj.L_R.csv" 
encode country, generate(identifier)
xtset identifier year
xtdes


rename country Country
replace Country = proper(Country)
merge 1:1 Country year using "/Users/rasmuswiese/Dropbox/Fiscal rules and fiscal consolidations/Data and dofile/fiscal_rule_database_own_cod_1967-2014 industrial v2.dta"
drop if _merge==2
drop _merge


merge 1:1 Country year using "/Users/rasmuswiese/Dropbox/Fiscal rules and fiscal consolidations/Data and dofile/ballance.dta"
drop if _merge==2
drop _merge

sort identifier year

*Generate stock-flow adjustments
gen sfa=d.debtgdp+ballance

//Difference debt outcomes
order identifier, after(Country)
sort identifier year
by identifier, sort: gen debtgdp1 = d.debtgdp 
by identifier, sort:replace debtgdp1=f.debtgdp1

by identifier, sort: gen debtgdp3 = debtgdp - l3.debtgdp 
by identifier, sort:replace debtgdp3=f3.debtgdp3

by identifier, sort:gen debtgdp5 = debtgdp - l5.debtgdp
by identifier, sort:replace debtgdp5 = f5.debtgdp5



*ideological position of gov.
replace ngov6seat=. if ngov6seat==0
replace ngov5seat=. if ngov5seat==0
replace ngov4seat=. if ngov4seat==0
replace ngov3seat=. if ngov3seat==0
replace ngov2seat=. if ngov2seat==0
replace ngov1seat=. if ngov1seat==0
gen ideol_gov6=(ngov6seat*ngov6rlc)
gen ideol_gov5=(ngov5seat*ngov5rlc)
gen ideol_gov4=(ngov4seat*ngov4rlc)
gen ideol_gov3=(ngov3seat*ngov3rlc)
gen ideol_gov2=(ngov2seat*ngov2rlc)
gen ideol_gov1=(ngov1seat*ngov1rlc)
replace ideol_gov6=0 if ideol_gov6==.
replace ideol_gov5=0 if ideol_gov5==.
replace ideol_gov4=0 if ideol_gov4==.
replace ideol_gov3=0 if ideol_gov3==.
replace ideol_gov2=0 if ideol_gov2==.
replace ideol_gov1=0 if ideol_gov1==.
gen ideol_gov=(ideol_gov1+ideol_gov2+ideol_gov3+ideol_gov4+ideol_gov5+ideol_gov6)/nnum_gov_seats
drop ideol_gov6-ideol_gov1

*ideological fragmentation of gov.
gen polfrag1=((ngov1seat/nnum_gov_seats)*(ngov1rlc-ideol_gov)^2)
gen polfrag2=((ngov2seat/nnum_gov_seats)*(ngov2rlc-ideol_gov)^2)
gen polfrag3=((ngov3seat/nnum_gov_seats)*(ngov3rlc-ideol_gov)^2)
gen polfrag4=((ngov4seat/nnum_gov_seats)*(ngov4rlc-ideol_gov)^2)
gen polfrag5=((ngov5seat/nnum_gov_seats)*(ngov5rlc-ideol_gov)^2)
gen polfrag6=((ngov6seat/nnum_gov_seats)*(ngov6rlc-ideol_gov)^2)
replace polfrag1=0 if polfrag1==.
replace polfrag2=0 if polfrag2==.
replace polfrag3=0 if polfrag3==.
replace polfrag4=0 if polfrag4==.
replace polfrag5=0 if polfrag5==.
replace polfrag6=0 if polfrag6==.
gen polfrag=polfrag1+polfrag2+polfrag3+polfrag4+polfrag5+polfrag6
replace polfrag=. if ngov1rlc==. & ngov2rlc==. & ngov3rlc==. & ngov4rlc==. & ngov5rlc==. & ngov6rlc==.
drop polfrag1-polfrag6

*maximum ideological distance in gov.
gen max_dist=max(ngov1rlc, ngov2rlc, ngov3rlc, ngov4rlc, ngov5rlc, ngov6rlc)-min(ngov1rlc, ngov2rlc, ngov3rlc, ngov4rlc, ngov5rlc, ngov6rlc)

*efective number of gov. parties
gen shareseats1=(ngov1seat/nnum_gov_seats)^2
gen shareseats2=(ngov2seat/nnum_gov_seats)^2
gen shareseats3=(ngov3seat/nnum_gov_seats)^2
gen shareseats4=(ngov4seat/nnum_gov_seats)^2
gen shareseats5=(ngov5seat/nnum_gov_seats)^2
gen shareseats6=(ngov6seat/nnum_gov_seats)^2
replace shareseats1=0 if shareseats1==.
replace shareseats2=0 if shareseats2==.
replace shareseats3=0 if shareseats3==.
replace shareseats4=0 if shareseats4==.
replace shareseats5=0 if shareseats5==.
replace shareseats6=0 if shareseats6==.
gen engp=1/(shareseats1+shareseats2+shareseats3+shareseats4+shareseats5+shareseats6)
drop shareseats1-shareseats6

*excess seats and strenght of gov. 
gen ex_seats=(nnum_gov_seats-(totalseats/2))/totalseats
gen strenghts=numgov/totalseats
gen nmonth=month/12
gen mstrength=strenghts*nmonth
replace strenghts=mstrength if election==1


* Economic vars. 
gen expend=(payment_min_i/gdp_value)*100
gen revenue=(receipts_min_i/gdp_value)*100
sort identifier year
by identifier , sort: gen d_expend=d.expend
by identifier , sort: gen d_revenue=d.revenue
gen d_capb=d.capb
gen debtgdp_1=l.debtgdp


gen lag_election= L.election
gen lead_election= F.election 
gen gov_bond_int_d=d.gov_bond_int
gen short_term_i_d=d.short_term_i

gen avg_3=(gdp_growth+f.gdp_growth+f2.gdp_growth)/3
gen avg_5=(gdp_growth+f.gdp_growth+f2.gdp_growth+f3.gdp_growth+f4.gdp_growth)/5

*replace ER=. if rule1==.
*replace r=0 if r==. & rule!=.
*replace BBR=0 if BBR==. & rule!=.
*replace DR=0 if DR==. & rule!=.

* Only indclude years where and adjustment took place

*drop if capb<0
*keep if bp_success_new==1 | bp_adj_new==1

*drop coutries where B&P filter cannot identify adjustments
drop if Country=="Greece"
drop if Country=="Ireland"
drop if Country=="Luxembourg"
*drop if Country=="new zealand"


*Generation of dummy for expenditure rule with statuary or constitutional basis*
generate statconER=0
replace statconER=1 if ER== 1 & legal_n_ER==3 |ER== 1 & legal_n_ER==5
replace statconER=. if ER==.

*Generation of dummy for revenue rule with statuary or constitutional basis*
generate statconRR=0
replace statconRR=1 if RR== 1 & legal_n_RR==3 |RR== 1 & legal_n_RR==5
replace statconRR=. if RR==.

*Generation of dummy for balanced budget rule with statuary or constitutional basis*
generate statconBBR=0
replace statconBBR=1 if BBR== 1 & legal_n_BBR==3 |BBR== 1 & legal_n_BBR==5
replace statconBBR=. if BBR==.



*Generation of dummy for debt rule with statuary or constitutional basis*
generate statconDR=0
replace statconDR=1 if DR== 1 & legal_n_DR==3 |DR== 1 & legal_n_DR==5
replace statconDR=. if DR==.



*Generation of reform expenditure rule*
generate reformER=0
replace reformER=1 if statconER==1 & l1.statconER==0
replace reformER=. if statconER==.

*Generation of reform revenue rule*
generate reformRR=0
replace reformRR=1 if statconRR==1 & l1.statconRR==0
replace reformRR=. if statconRR==.

*Generation of reform balance budget rule*
generate reformBBR=0
replace reformBBR=1 if statconBBR==1 & l1.statconBBR==0
replace reformBBR=. if statconBBR==.

*Generation of reform debt rule*
generate reformDR=0
replace reformDR=1 if statconDR==1 & l1.statconDR==0
replace reformDR=. if statconDR==.




*Generation of IMF national expenditure rules index* 
*Rescale cover of expenditure rule*
generate cover_n_er2= cover_n_ER/2

*Rescale legal scope of expenditure rule*
generate legal_n_er2= legal_n_ER/5

*generation of Expenditure rules strenght index* 
generate ER_n_strengh = cover_n_er2 + legal_n_er2 + enforce_n_ER + suport_ceil_n_a + frl + suport_budg_n + suport_impl_n


*Rescale cover of revenue rule*
generate cover_n_rr2= cover_n_RR/2

*Rescale legal scope of revenue rule*
generate legal_n_rr2= legal_n_RR/5

*generation of revenue rules strenght index*
generate RR_n_strengh= cover_n_rr2 + legal_n_rr2 + enforce_n_RR + frl + suport_budg_n + suport_impl_n

*Rescale cover of balanced budget rule*
generate cover_n_bbr2=cover_n_BBR/2

*Rescale legal scope of balanced budget rule*
generate legal_n_bbr2= legal_n_BBR/5

*generation of balanced budget rules strenght index*
generate BBR_n_strengh= cover_n_bbr2 + legal_n_bbr2 + enforce_n_BBR + suport_ceil_n_a + frl + suport_budg_n + suport_impl_n

*Rescale cover of debt rule*
generate cover_n_dr2= cover_n_DR/2

*Rescale legal scope of debt rule*
generate legal_n_dr2= legal_n_DR/2

*generation of debt rule strenght index*
generate DR_n_strengh= cover_n_dr2 + legal_n_dr2 + enforce_n_DR + suport_ceil_n_a + frl + suport_budg_n + suport_impl_n


*Generation of overal fiscal rules index*
generate nationalfiscalrulesindex=((DR_n_strengh*5/7) + (BBR_n_strengh*5/7) + (RR_n_strengh*5/6) + (ER_n_strengh*5/7))/4


*Generation of national fiscal rules in place*
generate nationaler=0
replace nationaler=1 if ER==1 & ER_supra!=2
replace nationaler=. if ER==. 

generate nationalrr=0
replace nationalrr=1 if RR==1 & RR_supra!=2
replace nationalrr=. if RR==. 

generate nationalbbr=0
replace nationalbbr=1 if BBR==1 & BBR_supra!=2
replace nationalbbr=. if BBR==. 

generate nationaldr=0
replace nationaldr=1 if DR==1 & DR_supra!=2
replace nationaldr=. if DR==. 


generate nationalfiscalrule=0
replace nationalfiscalrule=1 if nationaler==1 | nationalrr==1 | nationalbbr==1 | nationaldr==1
*replace nationalfiscalrule=. if year<1985


*Supranational rules= Stability and Growth Pact for EU countries*

generate supranationaler=0
replace supranationaler=1 if ER_supra==2 | ER_supra==3
replace supranationaler=. if ER_supra==.

generate supranationalrr=0
replace supranationalrr=1 if RR_supra==2 | RR_supra==3
replace supranationalrr=. if RR_supra==.

generate supranationalbbr=0
replace supranationalbbr=1 if BBR_supra==2 | BBR_supra==3
replace supranationalbbr=. if BBR_supra==.

generate supranationaldr=0
replace supranationaldr=1 if DR_supra==2 | DR_supra==3
replace supranationaldr=. if DR_supra==.

generate supranationalrules=0
replace supranationalrules=1 if supranationaler==1 | supranationalrr==1 | supranationalbbr==1 | supranationaldr==1
replace supranationalrules=. if DR_supra==.
rename supranationalrules sgp
replace sgp=0 if sgp==.


*Generation of IMF supranational expenditure rules index* 

*Rescale cover of expenditure rule*
generate cover_s_er2= cover_s_ER/2

*Rescale legal scope of expenditure rule*
generate legal_s_er2= legal_s_ER/5

*generation of Expenditure rules strenght index* 
generate ER_s_strengh = cover_s_er2 + legal_s_er2 + enforce_s_ER + suport_ceil_n_a + frl + suport_budg_n + suport_impl_n

*Rescale cover of revenue rule*
generate cover_s_rr2= cover_s_RR/2

*Rescale legal scope of revenue rule*
generate legal_s_rr2= legal_s_RR/5

*generation of revenue rules strenght index*
generate RR_s_strengh= cover_s_rr2 + legal_s_rr2 + enforce_s_RR + frl + suport_budg_n + suport_impl_n

*Rescale cover of balanced budget rule*
generate cover_s_bbr2=cover_s_BBR/2

*Rescale legal scope of balanced budget rule*
generate legal_s_bbr2= legal_s_BBR/5

*generation of balanced budget rules strenght index*
generate BBR_s_strengh= cover_s_bbr2 + legal_s_bbr2 + enforce_s_BBR + suport_ceil_n_a + frl + suport_budg_n + suport_impl_n

*Rescale cover of debt rule*
generate cover_s_dr2= cover_s_DR/2

*Rescale legal scope of debt rule*
generate legal_s_dr2= legal_s_DR/2

*generation of debt rule strenght index*
generate DR_s_strengh= cover_s_dr2 + legal_s_dr2 + enforce_s_DR + suport_ceil_n_a + frl + suport_budg_n + suport_impl_n

*Generation of overal supranational fiscal rules index with national support institutions*  
generate suprafiscalrulesindex=((DR_s_strengh*5/7) + (BBR_s_strengh*5/7) + (RR_s_strengh*5/6) + (ER_s_strengh*5/7))/4

*Generation of overal supranational fiscal rules indexes without national support institutions. All run from 0 to 3*  
generate ER_s_strengh2 = cover_s_er2 + legal_s_er2 + enforce_s_ER 
generate RR_s_strengh2= cover_s_rr2 + legal_s_rr2 + enforce_s_RR 
generate BBR_s_strengh2= cover_s_bbr2 + legal_s_bbr2 + enforce_s_BBR 
generate DR_s_strengh2= cover_s_dr2 + legal_n_dr2 + enforce_s_DR 
generate suprafiscalrulesindex2=(DR_s_strengh2 + BBR_s_strengh2 + RR_s_strengh2 +ER_s_strengh2 )/4

* Generate extra rule indicators
gen rule_in_place=1 if ER==1 | RR==1 | BBR==1 | DR==1 | sgp==1
replace rule_in_place=0 if rule_in_place==.

gen number_nat_rule_in_place=nationaler+nationalrr+nationalbbr+nationaldr

gen nat_supra_joint=1 if sgp==1 & nationalfiscalrule==1
replace nat_supra_joint=0 if nat_supra_joint==.

gen num__nat_rules=RR+ER+BBR+DR

gen intera=sgp*nationalfiscalrule



*Alternative fiscal rules strenght indexes: Without ceilings and fiscal responsibility law:

*National fiscal rules*
*generation of Expenditure rules strenght index* 
generate ER_n_strengh2 = cover_n_er2 + legal_n_er2 + enforce_n_ER  + suport_budg_n + suport_impl_n


*generation of revenue rules strenght index*
generate RR_n_strengh2= cover_n_rr2 + legal_n_rr2 + enforce_n_RR +  suport_budg_n + suport_impl_n

*generation of balanced budget rules strenght index*
generate BBR_n_strengh2= cover_n_bbr2 + legal_n_bbr2 + enforce_n_BBR +  suport_budg_n + suport_impl_n

*generation of debt rule strenght index*
generate DR_n_strengh2= cover_n_dr2 + legal_n_dr2 + enforce_n_DR + suport_budg_n + suport_impl_n


*Generation of overal fiscal rules index*
generate nationalfiscalrulesindex2=((DR_n_strengh*5/5) + (BBR_n_strengh*5/5) + (RR_n_strengh*5/5) + (ER_n_strengh*5/5))/4


*Supranational fiscal rules*
*generation of Expenditure rules strenght index* 
generate ER_s_strengh2 = cover_s_er2 + legal_s_er2 + enforce_s_ER  + suport_budg_n + suport_impl_n

*generation of revenue rules strenght index*
generate RR_s_strengh2= cover_s_rr2 + legal_s_rr2 + enforce_s_RR  + suport_budg_n + suport_impl_n

*generation of balanced budget rules strenght index*
generate BBR_s_strengh2= cover_s_bbr2 + legal_s_bbr2 + enforce_s_BBR  + suport_budg_n + suport_impl_n

*generation of debt rule strenght index*
generate DR_s_strengh2= cover_s_dr2 + legal_s_dr2 + enforce_s_DR  + suport_budg_n + suport_impl_n

*Generation of overal supranational fiscal rules index with national support institutions*  
generate suprafiscalrulesindex2=((DR_s_strengh*5/5) + (BBR_s_strengh*5/5) + (RR_s_strengh*5/5) + (ER_s_strengh*5/5))/4




//suprafiscalrulesindex//
//suprafiscalrulesindex2//
//nationalfiscalrulesindex//

** baseline specification: effect on debt
sort identifier year


global cont "d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa"


// 3 year effect of rules//
qui xtreg debtgdp3 bp_adj_new##rule_in_place bp_adj_new##nationalfiscalrule bp_adj_new##sgp bp_adj_new##nat_supra_joint bp_adj_new##c.nationalfiscalrulesindex bp_adj_new##c.suprafiscalrulesindex2 bp_adj_new##c.suprafiscalrulesindex $cont $cont i.year, fe
outreg2 using "/Users/rasmuswiese/Desktop/table1", pvalue bdec(3) pdec(3) excel replace

qui xtreg debtgdp3 bp_adj_new##rule_in_place $cont i.year, fe
outreg2 using "/Users/rasmuswiese/Desktop/table1", pvalue bdec(3) pdec(3) excel append
qui xtreg debtgdp3 bp_adj_new##rule_in_place $cont i.year, fe vce(cluster identifier)
boottest 1.bp_adj_new, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.rule_in_place, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.bp_adj_new#1.rule_in_place, gridmin(-50) gridmax(50) gridpoints(25) noci
foreach var of varlist d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa{
boottest `var', gridmin(-50) gridmax(50) gridpoints(25) noci
}

qui xtreg debtgdp3 bp_adj_new##nationalfiscalrule $cont i.year, fe
outreg2 using "/Users/rasmuswiese/Desktop/table1", pvalue bdec(3) pdec(3) excel append
qui xtreg debtgdp3 bp_adj_new##nationalfiscalrule $cont i.year, fe vce(cluster identifier)
boottest 1.bp_adj_new, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.nationalfiscalrule, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.bp_adj_new#1.nationalfiscalrule, gridmin(-50) gridmax(50) gridpoints(25) noci
foreach var of varlist d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa{
boottest `var', gridmin(-50) gridmax(50) gridpoints(25) noci
}

qui xtreg debtgdp3 bp_adj_new##sgp $cont i.year, fe
outreg2 using "/Users/rasmuswiese/Desktop/table1", pvalue bdec(3) pdec(3) excel append
qui xtreg debtgdp3 bp_adj_new##sgp $cont i.year, fe vce(cluster identifier)
boottest 1.bp_adj_new, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.sgp, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.bp_adj_new#1.sgp, gridmin(-50) gridmax(50) gridpoints(25) noci
foreach var of varlist d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa{
boottest `var', gridmin(-50) gridmax(50) gridpoints(25) noci
}

qui xtreg debtgdp3 bp_adj_new##nationalfiscalrule bp_adj_new##sgp $cont i.year, fe
outreg2 using "/Users/rasmuswiese/Desktop/table1", pvalue bdec(3) pdec(3) excel append
xtreg debtgdp3 bp_adj_new##nationalfiscalrule bp_adj_new##sgp $cont i.year, fe vce(cluster identifier)
boottest 1.bp_adj_new, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.nationalfiscalrule, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.bp_adj_new#1.nationalfiscalrule, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.sgp, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.bp_adj_new#1.sgp, gridmin(-50) gridmax(50) gridpoints(25) noci
foreach var of varlist d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa{
boottest `var', gridmin(-50) gridmax(50) gridpoints(25) noci
}

qui xtreg debtgdp3 bp_adj_new##nationalfiscalrule bp_adj_new##sgp bp_adj_new##nat_supra_joint $cont i.year, fe
outreg2 using "/Users/rasmuswiese/Desktop/table1", pvalue bdec(3) pdec(3) excel append
qui xtreg debtgdp3 bp_adj_new##nationalfiscalrule bp_adj_new##sgp bp_adj_new##nat_supra_joint $cont i.year, fe vce(cluster identifier)
boottest 1.bp_adj_new, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.nationalfiscalrule, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.bp_adj_new#1.nationalfiscalrule, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.sgp, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.bp_adj_new#1.sgp, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.nat_supra_joint, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.bp_adj_new#1.nat_supra_joint, gridmin(-50) gridmax(50) gridpoints(25) noci
foreach var of varlist d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa{
boottest `var', gridmin(-50) gridmax(50) gridpoints(25) noci
}

// 3 year effect of rule strenght
qui xtreg debtgdp3 bp_adj_new##c.nationalfiscalrulesindex $cont i.year, fe 
outreg2 using "/Users/rasmuswiese/Desktop/table1", pvalue bdec(3) pdec(3) excel append
qui xtreg debtgdp3 bp_adj_new##c.nationalfiscalrulesindex $cont i.year, fe vce(cluster identifier)
boottest 1.bp_adj_new, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest c.nationalfiscalrulesindex, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.bp_adj_new#c.nationalfiscalrulesindex, gridmin(-50) gridmax(50) gridpoints(25) noci
foreach var of varlist d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa{
boottest `var', gridmin(-50) gridmax(50) gridpoints(25) noci
}

qui xtreg debtgdp3 bp_adj_new##c.suprafiscalrulesindex2 $cont i.year, fe
outreg2 using "/Users/rasmuswiese/Desktop/table1", pvalue bdec(3) pdec(3) excel append
qui xtreg debtgdp3 bp_adj_new##c.suprafiscalrulesindex2 $cont i.year, fe vce(cluster identifier)
boottest 1.bp_adj_new, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest c.suprafiscalrulesindex2, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.bp_adj_new#c.suprafiscalrulesindex2, gridmin(-50) gridmax(50) gridpoints(25) noci
foreach var of varlist d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa{
boottest `var', gridmin(-50) gridmax(50) gridpoints(25) noci
}

qui xtreg debtgdp3 bp_adj_new##c.suprafiscalrulesindex $cont i.year, fe
outreg2 using "/Users/rasmuswiese/Desktop/table1", pvalue bdec(3) pdec(3) excel append
qui xtreg debtgdp3 bp_adj_new##c.suprafiscalrulesindex $cont i.year, fe vce(cluster identifier)
boottest 1.bp_adj_new, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest c.suprafiscalrulesindex, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.bp_adj_new#c.suprafiscalrulesindex, gridmin(-50) gridmax(50) gridpoints(25) noci
foreach var of varlist d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa{
boottest `var', gridmin(-50) gridmax(50) gridpoints(25) noci
}




// 5 year effect of rule//
qui xtreg debtgdp5 bp_adj_new##rule_in_place bp_adj_new##nationalfiscalrule bp_adj_new##sgp bp_adj_new##nat_supra_joint bp_adj_new##c.nationalfiscalrulesindex bp_adj_new##c.suprafiscalrulesindex2 bp_adj_new##c.suprafiscalrulesindex $cont $cont i.year, fe
outreg2 using "/Users/rasmuswiese/Desktop/table2", pvalue bdec(3) pdec(3) excel replace

qui xtreg debtgdp5 bp_adj_new##rule_in_place $cont i.year, fe
outreg2 using "/Users/rasmuswiese/Desktop/table1", pvalue bdec(3) pdec(3) excel append
qui xtreg debtgdp5 bp_adj_new##rule_in_place $cont i.year, fe vce(cluster identifier)
boottest 1.bp_adj_new, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.rule_in_place, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.bp_adj_new#1.rule_in_place, gridmin(-50) gridmax(50) gridpoints(25) noci
foreach var of varlist d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa{
boottest `var', gridmin(-50) gridmax(50) gridpoints(25) noci
}

qui xtreg debtgdp5 bp_adj_new##nationalfiscalrule $cont i.year, fe
outreg2 using "/Users/rasmuswiese/Desktop/table1", pvalue bdec(3) pdec(3) excel append
qui xtreg debtgdp5 bp_adj_new##nationalfiscalrule $cont i.year, fe vce(cluster identifier)
boottest 1.bp_adj_new, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.nationalfiscalrule, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.bp_adj_new#1.nationalfiscalrule, gridmin(-50) gridmax(50) gridpoints(25) noci
foreach var of varlist d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa{
boottest `var', gridmin(-50) gridmax(50) gridpoints(25) noci
}

qui xtreg debtgdp5 bp_adj_new##sgp $cont i.year, fe
outreg2 using "/Users/rasmuswiese/Desktop/table1", pvalue bdec(3) pdec(3) excel append
qui xtreg debtgdp5 bp_adj_new##sgp $cont i.year, fe vce(cluster identifier)
boottest 1.bp_adj_new, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.sgp, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.bp_adj_new#1.sgp, gridmin(-50) gridmax(50) gridpoints(25) noci
foreach var of varlist d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa{
boottest `var', gridmin(-50) gridmax(50) gridpoints(25) noci
}

qui xtreg debtgdp5 bp_adj_new##nationalfiscalrule bp_adj_new##sgp $cont i.year, fe
outreg2 using "/Users/rasmuswiese/Desktop/table1", pvalue bdec(3) pdec(3) excel append
xtreg debtgdp5 bp_adj_new##nationalfiscalrule bp_adj_new##sgp $cont i.year, fe vce(cluster identifier)
boottest 1.bp_adj_new, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.nationalfiscalrule, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.bp_adj_new#1.nationalfiscalrule, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.sgp, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.bp_adj_new#1.sgp, gridmin(-50) gridmax(50) gridpoints(25) noci
foreach var of varlist d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa{
boottest `var', gridmin(-50) gridmax(50) gridpoints(25) noci
}

qui xtreg debtgdp5 bp_adj_new##nationalfiscalrule bp_adj_new##sgp bp_adj_new##nat_supra_joint $cont i.year, fe
outreg2 using "/Users/rasmuswiese/Desktop/table1", pvalue bdec(3) pdec(3) excel append
qui xtreg debtgdp5 bp_adj_new##nationalfiscalrule bp_adj_new##sgp bp_adj_new##nat_supra_joint $cont i.year, fe vce(cluster identifier)
boottest 1.bp_adj_new, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.nationalfiscalrule, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.bp_adj_new#1.nationalfiscalrule, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.sgp, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.bp_adj_new#1.sgp, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.nat_supra_joint, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.bp_adj_new#1.nat_supra_joint, gridmin(-50) gridmax(50) gridpoints(25) noci
foreach var of varlist d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa{
boottest `var', gridmin(-50) gridmax(50) gridpoints(25) noci
}

// 5 year effect of rule strenght
qui xtreg debtgdp5 bp_adj_new##c.nationalfiscalrulesindex $cont i.year, fe 
outreg2 using "/Users/rasmuswiese/Desktop/table1", pvalue bdec(3) pdec(3) excel append
qui xtreg debtgdp5 bp_adj_new##c.nationalfiscalrulesindex $cont i.year, fe vce(cluster identifier)
boottest 1.bp_adj_new, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest c.nationalfiscalrulesindex, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.bp_adj_new#c.nationalfiscalrulesindex, gridmin(-50) gridmax(50) gridpoints(25) noci
foreach var of varlist d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa{
boottest `var', gridmin(-50) gridmax(50) gridpoints(25) noci
}

qui xtreg debtgdp5 bp_adj_new##c.suprafiscalrulesindex2 $cont i.year, fe
outreg2 using "/Users/rasmuswiese/Desktop/table1", pvalue bdec(3) pdec(3) excel append
qui xtreg debtgdp5 bp_adj_new##c.suprafiscalrulesindex2 $cont i.year, fe vce(cluster identifier)
boottest 1.bp_adj_new, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest c.suprafiscalrulesindex2, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.bp_adj_new#c.suprafiscalrulesindex2, gridmin(-50) gridmax(50) gridpoints(25) noci
foreach var of varlist d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa{
boottest `var', gridmin(-50) gridmax(50) gridpoints(25) noci
}

qui xtreg debtgdp5 bp_adj_new##c.suprafiscalrulesindex $cont i.year, fe
outreg2 using "/Users/rasmuswiese/Desktop/table1", pvalue bdec(3) pdec(3) excel append
qui xtreg debtgdp5 bp_adj_new##c.suprafiscalrulesindex $cont i.year, fe vce(cluster identifier)
boottest 1.bp_adj_new, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest c.suprafiscalrulesindex, gridmin(-50) gridmax(50) gridpoints(25) noci
boottest 1.bp_adj_new#c.suprafiscalrulesindex, gridmin(-50) gridmax(50) gridpoints(25) noci
foreach var of varlist d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa{
boottest `var', gridmin(-50) gridmax(50) gridpoints(25) noci


*** effect on successful fiscal adjustment

// rule in place

clogit bp_success_new rule_in_place $cont, group(identifier)

qui xtprobit bp_success_new rule_in_place d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa
qui xtprobit bp_success_new rule_in_place d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa Mav_nationalfiscalrulesindex Mav_d_expend Mav_d_revenue Mav_d_capb Mav_capb_1 Mav_debtgdp_1 Mav_gdp_growth Mav_short_term_i Mav_expend Mav_sfa
qui test Mav_nationalfiscalrulesindex Mav_d_expend Mav_d_revenue Mav_d_capb Mav_capb_1 Mav_debtgdp_1 Mav_gdp_growth Mav_short_term_i Mav_expend Mav_sfa
local w=r(p)
xtprobit bp_success_new rule_in_place d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa
outreg2 using "/Users/rasmuswiese/Desktop/table1", addstat(Log-likelihood, `e(ll)') pvalue bdec(3) pdec(3) excel replace 
local ll=e(ll)
qui margins, post predict(pu0) dydx(*) atmeans
outreg2 using "/Users/rasmuswiese/Desktop/table2", addstat(Log-likelihood, `ll', Wald-test of Mundlak averages,`w' ) pvalue bdec(3) pdec(3) excel replace

qui xtprobit bp_success_new nationalfiscalrule d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa
qui xtprobit bp_success_new nationalfiscalrule d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa Mav_nationalfiscalrulesindex Mav_d_expend Mav_d_revenue Mav_d_capb Mav_capb_1 Mav_debtgdp_1 Mav_gdp_growth Mav_short_term_i Mav_expend Mav_sfa
qui test Mav_nationalfiscalrulesindex Mav_d_expend Mav_d_revenue Mav_d_capb Mav_capb_1 Mav_debtgdp_1 Mav_gdp_growth Mav_short_term_i Mav_expend Mav_sfa
local w=r(p)
qui xtprobit bp_success_new nationalfiscalrule d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa
outreg2 using "/Users/rasmuswiese/Desktop/table1", addstat(Log-likelihood, `e(ll)') pvalue bdec(3) pdec(3) excel append 
local ll=e(ll)
qui margins, post predict(pu0) dydx(*) atmeans
outreg2 using "/Users/rasmuswiese/Desktop/table2", addstat(Log-likelihood, `ll', Wald-test of Mundlak averages,`w' ) pvalue bdec(3) pdec(3) excel append

qui xtprobit bp_success_new sgp d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa
qui xtprobit bp_success_new sgp d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa Mav_nationalfiscalrulesindex Mav_d_expend Mav_d_revenue Mav_d_capb Mav_capb_1 Mav_debtgdp_1 Mav_gdp_growth Mav_short_term_i Mav_expend Mav_sfa
qui test Mav_nationalfiscalrulesindex Mav_d_expend Mav_d_revenue Mav_d_capb Mav_capb_1 Mav_debtgdp_1 Mav_gdp_growth Mav_short_term_i Mav_expend Mav_sfa
local w=r(p)
xtprobit bp_success_new sgp d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa
outreg2 using "/Users/rasmuswiese/Desktop/table1", addstat(Log-likelihood, `e(ll)') pvalue bdec(3) pdec(3) excel append 
local ll=e(ll)
qui margins, post predict(pu0) dydx(*) atmeans
outreg2 using "/Users/rasmuswiese/Desktop/table2", addstat(Log-likelihood, `ll', Wald-test of Mundlak averages,`w' ) pvalue bdec(3) pdec(3) excel append

qui xtprobit bp_success_new nationalfiscalrule sgp d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa
qui xtprobit bp_success_new nationalfiscalrule sgp d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa Mav_nationalfiscalrulesindex Mav_d_expend Mav_d_revenue Mav_d_capb Mav_capb_1 Mav_debtgdp_1 Mav_gdp_growth Mav_short_term_i Mav_expend Mav_sfa
qui test Mav_nationalfiscalrulesindex Mav_d_expend Mav_d_revenue Mav_d_capb Mav_capb_1 Mav_debtgdp_1 Mav_gdp_growth Mav_short_term_i Mav_expend Mav_sfa
local w=r(p)
xtprobit bp_success_new nationalfiscalrule sgp d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa
outreg2 using "/Users/rasmuswiese/Desktop/table1", addstat(Log-likelihood, `e(ll)') pvalue bdec(3) pdec(3) excel append 
local ll=e(ll)
qui margins, post predict(pu0) dydx(*) atmeans
outreg2 using "/Users/rasmuswiese/Desktop/table2", addstat(Log-likelihood, `ll', Wald-test of Mundlak averages,`w' ) pvalue bdec(3) pdec(3) excel append

qui xtprobit bp_success_new nationalfiscalrule sgp nat_supra_joint d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa
qui xtprobit bp_success_new nationalfiscalrule sgp nat_supra_joint d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa Mav_nationalfiscalrulesindex Mav_d_expend Mav_d_revenue Mav_d_capb Mav_capb_1 Mav_debtgdp_1 Mav_gdp_growth Mav_short_term_i Mav_expend Mav_sfa
qui test Mav_nationalfiscalrulesindex Mav_d_expend Mav_d_revenue Mav_d_capb Mav_capb_1 Mav_debtgdp_1 Mav_gdp_growth Mav_short_term_i Mav_expend Mav_sfa
local w=r(p)
xtprobit bp_success_new nationalfiscalrule sgp nat_supra_joint d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa
outreg2 using "/Users/rasmuswiese/Desktop/table1", addstat(Log-likelihood, `e(ll)') pvalue bdec(3) pdec(3) excel append 
local ll=e(ll)
qui margins, post predict(pu0) dydx(*) atmeans
outreg2 using "/Users/rasmuswiese/Desktop/table2", addstat(Log-likelihood, `ll', Wald-test of Mundlak averages,`w' ) pvalue bdec(3) pdec(3) excel append


// Strength of rules

qui xtprobit bp_success_new nationalfiscalrulesindex d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa
qui xtprobit bp_success_new nationalfiscalrulesindex d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa Mav_nationalfiscalrulesindex Mav_d_expend Mav_d_revenue Mav_d_capb Mav_capb_1 Mav_debtgdp_1 Mav_gdp_growth Mav_short_term_i Mav_expend Mav_sfa
qui test Mav_nationalfiscalrulesindex Mav_d_expend Mav_d_revenue Mav_d_capb Mav_capb_1 Mav_debtgdp_1 Mav_gdp_growth Mav_short_term_i Mav_expend Mav_sfa
local w=r(p)
qui xtprobit bp_success_new nationalfiscalrulesindex d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa
outreg2 using "/Users/rasmuswiese/Desktop/table1", addstat(Log-likelihood, `e(ll)') pvalue bdec(3) pdec(3) excel append 
local ll=e(ll)
qui margins, post predict(pu0) dydx(*) atmeans
outreg2 using "/Users/rasmuswiese/Desktop/table2", addstat(Log-likelihood, `ll', Wald-test of Mundlak averages,`w' ) pvalue bdec(3) pdec(3) excel append

qui xtprobit bp_success_new suprafiscalrulesindex2 d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa
qui xtprobit bp_success_new suprafiscalrulesindex2 d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa Mav_nationalfiscalrulesindex Mav_d_expend Mav_d_revenue Mav_d_capb Mav_capb_1 Mav_debtgdp_1 Mav_gdp_growth Mav_short_term_i Mav_expend Mav_sfa
qui test Mav_nationalfiscalrulesindex Mav_d_expend Mav_d_revenue Mav_d_capb Mav_capb_1 Mav_debtgdp_1 Mav_gdp_growth Mav_short_term_i Mav_expend Mav_sfa
local w=r(p)
qui xtprobit bp_success_new suprafiscalrulesindex2 d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa
outreg2 using "/Users/rasmuswiese/Desktop/table1", addstat(Log-likelihood, `e(ll)') pvalue bdec(3) pdec(3) excel append 
local ll=e(ll)
qui margins, post predict(pu0) dydx(*) atmeans
outreg2 using "/Users/rasmuswiese/Desktop/table2", addstat(Log-likelihood, `ll', Wald-test of Mundlak averages,`w' ) pvalue bdec(3) pdec(3) excel append


qui xtprobit bp_success_new suprafiscalrulesindex d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa
qui xtprobit bp_success_new suprafiscalrulesindex d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa Mav_nationalfiscalrulesindex Mav_d_expend Mav_d_revenue Mav_d_capb Mav_capb_1 Mav_debtgdp_1 Mav_gdp_growth Mav_short_term_i Mav_expend Mav_sfa
qui test Mav_nationalfiscalrulesindex Mav_d_expend Mav_d_revenue Mav_d_capb Mav_capb_1 Mav_debtgdp_1 Mav_gdp_growth Mav_short_term_i Mav_expend Mav_sfa
local w=r(p)
qui xtprobit bp_success_new suprafiscalrulesindex d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa
outreg2 using "/Users/rasmuswiese/Desktop/table1", addstat(Log-likelihood, `e(ll)') pvalue bdec(3) pdec(3) excel append 
local ll=e(ll)
qui margins, post predict(pu0) dydx(*) atmeans
outreg2 using "/Users/rasmuswiese/Desktop/table2", addstat(Log-likelihood, `ll', Wald-test of Mundlak averages,`w' ) pvalue bdec(3) pdec(3) excel append


*random effects probit, robustness gov. ideology

sort identifier year

qui xtprobit bp_success_new ER d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend ideol_gov  
outreg2 using "/Users/rasmuswiese/Desktop/table1", addstat(Log-likelihood, `e(ll)') pvalue bdec(3) pdec(3) excel replace 
qui margins, post predict(pu0) dydx(*) atmeans
outreg2 using "/Users/rasmuswiese/Desktop/table2", pvalue bdec(3) pdec(3) excel replace

qui xtprobit bp_success_new RR d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend ideol_gov  
outreg2 using "/Users/rasmuswiese/Desktop/table1", addstat(Log-likelihood, `e(ll)') pvalue bdec(3) pdec(3) excel append 
qui margins, post predict(pu0) dydx(*) atmeans
outreg2 using "/Users/rasmuswiese/Desktop/table2", pvalue bdec(3) pdec(3) excel append

qui xtprobit bp_success_new BBR d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend ideol_gov  
outreg2 using "/Users/rasmuswiese/Desktop/table1", addstat(Log-likelihood, `e(ll)') pvalue bdec(3) pdec(3) excel append 
qui margins, post predict(pu0) dydx(*) atmeans
outreg2 using "/Users/rasmuswiese/Desktop/table2", pvalue bdec(3) pdec(3) excel append

qui xtprobit bp_success_new DR d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend ideol_gov  
outreg2 using "/Users/rasmuswiese/Desktop/table1", addstat(Log-likelihood, `e(ll)') pvalue bdec(3) pdec(3) excel append 
qui margins, post predict(pu0) dydx(*) atmeans
outreg2 using "/Users/rasmuswiese/Desktop/table2", pvalue bdec(3) pdec(3) excel append

qui xtprobit bp_success_new rule_in_place d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend ideol_gov  
outreg2 using "/Users/rasmuswiese/Desktop/table1", addstat(Log-likelihood, `e(ll)') pvalue bdec(3) pdec(3) excel append 
qui margins, post predict(pu0) dydx(*) atmeans
outreg2 using "/Users/rasmuswiese/Desktop/table2", pvalue bdec(3) pdec(3) excel append

qui xtprobit bp_success_new num_sig_rules d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend ideol_gov  
outreg2 using "/Users/rasmuswiese/Desktop/table1", addstat(Log-likelihood, `e(ll)') pvalue bdec(3) pdec(3) excel append 
qui margins, post predict(pu0) dydx(*) atmeans
outreg2 using "/Users/rasmuswiese/Desktop/table2", pvalue bdec(3) pdec(3) excel append

qui xtprobit bp_success_new sgp d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend ideol_gov  
outreg2 using "/Users/rasmuswiese/Desktop/table1", addstat(Log-likelihood, `e(ll)') pvalue bdec(3) pdec(3) excel append 
qui margins, post predict(pu0) dydx(*) atmeans
outreg2 using "/Users/rasmuswiese/Desktop/table2", pvalue bdec(3) pdec(3) excel append

** Robustness size fragmentation
sort identifier year

qui xtprobit bp_success_new ER d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend engp  
outreg2 using "/Users/rasmuswiese/Desktop/table1", addstat(Log-likelihood, `e(ll)') pvalue bdec(3) pdec(3) excel replace 
qui margins, post predict(pu0) dydx(*) atmeans
outreg2 using "/Users/rasmuswiese/Desktop/table2", pvalue bdec(3) pdec(3) excel replace

qui xtprobit bp_success_new RR d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend engp  
outreg2 using "/Users/rasmuswiese/Desktop/table1", addstat(Log-likelihood, `e(ll)') pvalue bdec(3) pdec(3) excel append 
qui margins, post predict(pu0) dydx(*) atmeans
outreg2 using "/Users/rasmuswiese/Desktop/table2", pvalue bdec(3) pdec(3) excel append

qui xtprobit bp_success_new BBR d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend engp  
outreg2 using "/Users/rasmuswiese/Desktop/table1", addstat(Log-likelihood, `e(ll)') pvalue bdec(3) pdec(3) excel append 
qui margins, post predict(pu0) dydx(*) atmeans
outreg2 using "/Users/rasmuswiese/Desktop/table2", pvalue bdec(3) pdec(3) excel append

qui xtprobit bp_success_new DR d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend engp  
outreg2 using "/Users/rasmuswiese/Desktop/table1", addstat(Log-likelihood, `e(ll)') pvalue bdec(3) pdec(3) excel append 
qui margins, post predict(pu0) dydx(*) atmeans
outreg2 using "/Users/rasmuswiese/Desktop/table2", pvalue bdec(3) pdec(3) excel append

qui xtprobit bp_success_new rule_in_place d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend engp  
outreg2 using "/Users/rasmuswiese/Desktop/table1", addstat(Log-likelihood, `e(ll)') pvalue bdec(3) pdec(3) excel append 
qui margins, post predict(pu0) dydx(*) atmeans
outreg2 using "/Users/rasmuswiese/Desktop/table2", pvalue bdec(3) pdec(3) excel append

qui xtprobit bp_success_new num_sig_rules d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend engp  
outreg2 using "/Users/rasmuswiese/Desktop/table1", addstat(Log-likelihood, `e(ll)') pvalue bdec(3) pdec(3) excel append 
qui margins, post predict(pu0) dydx(*) atmeans
outreg2 using "/Users/rasmuswiese/Desktop/table2", pvalue bdec(3) pdec(3) excel append

qui xtprobit bp_success_new sgp d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend engp  
outreg2 using "/Users/rasmuswiese/Desktop/table1", addstat(Log-likelihood, `e(ll)') pvalue bdec(3) pdec(3) excel append 
qui margins, post predict(pu0) dydx(*) atmeans
outreg2 using "/Users/rasmuswiese/Desktop/table2", pvalue bdec(3) pdec(3) excel append






*fixed effect estimation (Correlated radom effects, Mundalk 1978), the F-test tells us whehter there is evidence of fixed-effects
order identifier year ER d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend
drop Country

foreach var of varlist expend - short_term_i_d {
by identifier, sort: egen Mav_`var'=mean(`var') if e(sample)
}

xtprobit bp_success_new d_expend d_revenue gdp_growth capb_1 rule Mav_d_expend Mav_d_revenue Mav_gdp_growth Mav_capb_1 Mav_rule 
test Mav_d_expend Mav_d_revenue Mav_gdp_growth Mav_capb_1 Mav_rule

xtprobit bp_success_new ER d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend Mav_d_expend Mav_d_revenue Mav_gdp_growth Mav_capb_1 Mav_er Mav_debtgdp_1 Mav_short_term_i Mav_expend


xtprobit bp_success_new d_expend d_revenue gdp_growth capb_1 ER Mav_d_expend Mav_d_revenue Mav_gdp_growth Mav_capb_1 Mav_ER
test Mav_d_expend Mav_d_revenue Mav_gdp_growth Mav_capb_1 Mav_ER

xtprobit bp_success_new d_expend d_revenue gdp_growth capb_1 RR Mav_d_expend Mav_d_revenue Mav_gdp_growth Mav_capb_1 Mav_RR
test Mav_d_expend Mav_d_revenue Mav_gdp_growth Mav_capb_1 Mav_RR

xtprobit bp_success_new d_expend d_revenue gdp_growth capb_1 BBR Mav_d_expend Mav_d_revenue Mav_gdp_growth Mav_capb_1 Mav_BBR
test Mav_d_expend Mav_d_revenue Mav_gdp_growth Mav_capb_1 Mav_BBR

xtprobit bp_success_new d_expend d_revenue gdp_growth capb_1 DR Mav_d_expend Mav_d_revenue Mav_gdp_growth Mav_capb_1 Mav_DR
test Mav_d_expend Mav_d_revenue Mav_gdp_growth Mav_capb_1 Mav_DR


