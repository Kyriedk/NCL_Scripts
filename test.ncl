load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
dir  = "/gpfsES/geo/kding/MyData/"
name1 = "flnt2000.nc"
name2 = "fsnt2000.nc"

;fils = systemfunc("ls " + dir + name + "*.nc")

f1 = addfile(dir + name1, "r")
f2 = addfile(dir + name2, "r")
;ListSetType(f, "cat")
flnt = f1->FLNT
fsnt = f2->FSNT
printVarSummary(flnt)

flnt_ann = month_to_annual(flnt, 1)
fsnt_ann = month_to_annual(fsnt, 1)

lat = doubletofloat(f1->lat)
;;;;;;;;;calculate weights for global mean;;;;;;;;
rad    = 4.0*atan(1.0)/180.0
clat   = cos(lat*rad)
clat!0 = "lat"
clat&lat = lat
  flnt_glo = wgt_areaave_Wrap(flnt_ann, clat, 1., 0)
  fsnt_glo = wgt_areaave_Wrap(fsnt_ann, clat, 1., 0)

printVarSummary(flnt_glo)

fdiff = flnt_glo
fdiff = flnt_glo - fsnt_glo

dims = dimsizes(flnt_glo)
ntim = dims(0)
time = ispan(1,ntim,1)

;;;;;;;;;calculate running mean;;;;;;;;;;;;;
nrun = 11
fdiff_5 = runave_n_Wrap(fdiff,nrun,1,0)

 ;;;;;;;;;;arrange data;;;;;;;;;;;
  data = new((/2,ntim/),float)
  data(0,:) = fdiff
  data(1,:) = fdiff_5

;;;;;;;;;;;make plots;;;;;;;;;;;
; wks = gsn_open_wks("x11","temp")
 wks = gsn_open_wks("pdf","test")

plot = gsn_csm_xy(wks, time, data ,True)

end

