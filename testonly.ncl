begin
;Time Processing
yrStrt=1
yrLast=12040
year=ispan(yrStrt, yrLast, 1)
;yyyymm   = yyyymm_time(yrStrt, yrLast, "integer")
;yyyyfrac = yyyymm_to_yyyyfrac(yyyymm,0)
;year=yyyymm
printVarSummary(year)
end