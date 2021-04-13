** effect on debt 3 yrs. 

gen cd_rule_in_place=rule_in_place*debtgdp3
replace cd_rule_in_place=. if cd_rule_in_place==0
gen no_rule_in_place=1 if rule_in_place==0
gen cd_no_rule_in_place=no_rule_in_place*debtgdp3
ttest cd_rule_in_place=cd_no_rule_in_place, unpaired unequal


gen cd_nationalfiscalrule=nationalfiscalrule*debtgdp3
replace cd_nationalfiscalrule=. if cd_nationalfiscalrule==0
gen no_nationalfiscalrule=1 if nationalfiscalrule==0
gen cd_no_nationalfiscalrule=no_nationalfiscalrule*debtgdp3
ttest cd_nationalfiscalrule=cd_no_nationalfiscalrule, unpaired unequal


gen cd_sgp=sgp*debtgdp3
replace cd_sgp=. if cd_sgp==0
gen no_sgp=1 if sgp==0
gen cd_no_sgp=no_sgp*debtgdp3
ttest cd_sgp=cd_no_sgp, unpaired unequal


gen cd_nat_supra_joint=nat_supra_joint*debtgdp3
replace cd_nat_supra_joint=. if cd_nat_supra_joint==0
gen no_nat_supra_joint=1 if nat_supra_joint==0
gen cd_no_nat_supra_joint=no_nat_supra_joint*debtgdp3
ttest cd_nat_supra_joint=cd_no_nat_supra_joint, unpaired unequal

** effect on debt 5 yrs. 
gen cd_rule_in_place1=rule_in_place*debtgdp5
replace cd_rule_in_place1=. if cd_rule_in_place1==0
gen no_rule_in_place1=1 if rule_in_place==0
gen cd_no_rule_in_place1=no_rule_in_place1*debtgdp5
ttest cd_rule_in_place1=cd_no_rule_in_place1, unpaired unequal


gen cd_nationalfiscalrule1=nationalfiscalrule*debtgdp5
replace cd_nationalfiscalrule1=. if cd_nationalfiscalrule1==0
gen no_nationalfiscalrule1=1 if nationalfiscalrule==0
gen cd_no_nationalfiscalrule1=no_nationalfiscalrule1*debtgdp5
ttest cd_nationalfiscalrule1=cd_no_nationalfiscalrule1, unpaired unequal


gen cd_sgp1=sgp*debtgdp5
replace cd_sgp1=. if cd_sgp1==0
gen no_sgp1=1 if sgp==0
gen cd_no_sgp1=no_sgp1*debtgdp5
ttest cd_sgp1=cd_no_sgp1, unpaired unequal


gen cd_nat_supra_joint1=nat_supra_joint*debtgdp5
replace cd_nat_supra_joint1=. if cd_nat_supra_joint1==0
gen no_nat_supra_joint1=1 if nat_supra_joint==0
gen cd_no_nat_supra_joint1=no_nat_supra_joint1*debtgdp5
ttest cd_nat_supra_joint1=cd_no_nat_supra_joint1, unpaired unequal

**Effect on growth

gen cd_rule_in_place=rule_in_place*avg_5
replace cd_rule_in_place=. if cd_rule_in_place==0
gen no_rule_in_place=1 if rule_in_place==0
gen cd_no_rule_in_place=no_rule_in_place*avg_5
ttest cd_rule_in_place=cd_no_rule_in_place, unpaired unequal


gen cd_nationalfiscalrule=nationalfiscalrule*avg_5
replace cd_nationalfiscalrule=. if cd_nationalfiscalrule==0
gen no_nationalfiscalrule=1 if nationalfiscalrule==0
gen cd_no_nationalfiscalrule=no_nationalfiscalrule*avg_5
ttest cd_nationalfiscalrule=cd_no_nationalfiscalrule, unpaired unequal


gen cd_sgp=sgp*avg_5
replace cd_sgp=. if cd_sgp==0
gen no_sgp=1 if sgp==0
gen cd_no_sgp=no_sgp*avg_5
ttest cd_sgp=cd_no_sgp, unpaired unequal


gen cd_nat_supra_joint=nat_supra_joint*avg_5
replace cd_nat_supra_joint=. if cd_nat_supra_joint==0
gen no_nat_supra_joint=1 if nat_supra_joint==0
gen cd_no_nat_supra_joint=no_nat_supra_joint*avg_5
ttest cd_nat_supra_joint=cd_no_nat_supra_joint, unpaired unequal
