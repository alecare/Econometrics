//ssc install ivreg2, replace
global path "C:\Users\acarelli\OneDrive - London Business School\Desktop\Econometrics"
cd "$path"
clear all
import excel "PS4data.xlsx",cellrange(A1) firstrow

gen date = yq(year, quarter)
format date %tq
tsset date

*(a)
gen consump= (realconsumptionofnondurables+realconsumptionofservices)/population
reg consump l(1/4).consump

test L2.consump=L3.consump=L4.consump=0

*(c)
gen y=realdisposableincome/pop
gen lnconsump=log(consump/l1.consump)
gen lny=log(y/l1.y)
ivregress 2sls lnconsump (lny=l(2/5).lnconsump),robust
estat firststage // F-stat from 1st stage reg is 3.13315 < 10, indicating that it is a weak instrument. Inference testing may be flawed.

*(d)
*test the exogeneity
reg lny l(2/5).lnconsump
predict e,resid
reg lnconsump lny e,robust

*test the over-identifying restrictions
gen residuals=lnconsump-.0026129-0.4369273*lny
reg residuals l(2/5).lnconsump