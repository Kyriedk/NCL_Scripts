begin
dir = "/gpfsES/geo/zywang/TR21/TS/combined/"
file_name = "trace.12000BP-1990CE.TS.nc"
f1 = addfile(dir + file_name, "r")

;Temperature Processing
temperature_origin = f1->TS
stmon = 1
edmon = 12
printVarSummary(temperature_origin)
size = dimsizes(temperature_origin)
printVarSummary(size)
temperature_annual_avg = month_to_annual(temperature_origin, 1) ; opt=1  divide the unweighted sum by 12 to get the annual mean value(s)
printVarSummary(temperature_annual_avg)


;Get area_weighted lat 
lat = doubletofloat(f1->lat)
;;;;;;;;;calculate weights for global mean;;;;;;;;
rad    = 4.0*atan(1.0)/180.0
clat   = cos(lat*rad)
clat!0 = "lat"
clat&lat = lat

temperature_annavg_areawgt = wgt_areaave_Wrap(temperature_annual_avg, clat, 1.0, 1)
printVarSummary(temperature_annavg_areawgt)
temperature_processed = temperature_annavg_areawgt

;Time Processing
yrStrt=1
yrLast=12040
yyyy = ispan(yrStrt, yrLast, 1)
;yyyymm   = yyyymm_time(yrStrt, yrLast, "integer")
;yyyyfrac = yyyymm_to_yyyyfrac(yyyymm,0)
year=yyyy
printVarSummary(year)

; set 'eemd' arguments and options
 
nrep  = 500
nimf  = 0                     ; nimf=0 , function will calculate
noise = 0.25
dims  = 0
opt   = False

e     = eemd(temperature_processed,nimf,nrep,noise,opt,dims)     ; (nimf,N) 
e@long_name = "EEMD"

printVarSummary(e)

dime  = dimsizes(e)
NIMF  = dime(0)                               ; if input nimf=0 (NIMF is calculated)
NN    = dime(1)                               ; same as N

; plot

   wks   = gsn_open_wks("png","eemd")            ; send graphics to PNG file
   res   = True

   res@vpHeightF = 0.4                           ; change aspect ratio of plot
   res@vpWidthF  = 0.75                 
   res@vpXF      = 0.15                          ; start plot at x ndc coord 

                                                 ; for aesthetic purposes only
   ;res@trXMinF   = min(tt) - 10*(tt(1)-tt(0))    ; extra space at left  boundary
   ;res@trXMaxF   = max(tt) + 10*(tt(1)-tt(0))    ; extra space at right boundary
   
; Original Temperature Series

   res@tiMainString = "Holocene Temperature"
   plt  = gsn_csm_xy(wks,year,temperature_processed,res)              ; raw data
   delete(res@tiMainString)

; plot each IMF

   plot = new (NIMF,"graphic")

   res           = True
   res@gsnDraw   = False                         ; don't draw
   res@gsnFrame  = False                         ; don't advance frame

   do ni=0,NIMF-1                                ; loop over each IMF
      e@long_name = "NIMF_"+(ni+1)
      printMinMax(e(ni,:),0)                    
      delete(e@long_name)                        ; do not want on plot

     ;res@tiMainString = "EEMD: NIMF_"+(ni+1)
      plot(ni) = gsn_csm_xy(wks,year,e(ni,:),res)  ; each IMF

   end do

; create panel of IMFs

  resP = True                                          ; modify the panel plot
  resP@gsnMaximize           = True
  resP@gsnPanelMainString    = "eemd: sinusoid"        ; new resource added in NCL V6.4.0
  resP@gsnPanelFigureStrings = "IMF "+ispan(1,NIMF,1)  ; add strings to panel
  resP@gsnPanelFigureStringsJust = "TopLeft"           ; new resource added in NCL V6.4.0
  gsn_panel(wks,plot,(/5,2/),resP)                     ; now draw as one plot
end
