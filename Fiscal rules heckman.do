clear all
run "/Users/rasmuswiese/Desktop/Dataset prep. fiscal rules.do"
*** Manual heckman
reg debtgdp5 bp_adj_new d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend

xi: probit bp_adj_new d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend sfa if e(sample), vce(cluster iden) 
outreg2 using table1, pvalue bdec(3) pdec(3) e(ll) word replace


predict zg if e(sample), xb

g phi=normalden(zg)

g PHI=normal(zg)

g lambda=phi/PHI

xtset,clear
xi: reg debtgdp5 nationalfiscalrule d_expend d_revenue d_capb capb_1 debtgdp_1 gdp_growth short_term_i expend lambda, vce(bootstrap, seed(234) cluster(identifier) reps(500))
outreg2 using table1, pvalue bdec(3) pdec(3) word append

drop zg phi PHI lambda


