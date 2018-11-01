;*************************************************
; spec_1.ncl
;
; Concepts illustrated:
;   - Calculating and plotting spectra
;************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
;************************************************
begin

;********************************************
;read txt file
;*********************************************
flnm = "/gpfsES/geo/kding/Mycode/PDOI/pc1.txt"
strs = asciiread(flnm,-1,"string")

delim = " "
nfields = str_fields_count(strs(0), delim)   ; Count the fields separated
                                              ; by one or more spaces.
print(nfields)                               ; nfields = 20

field = 1
index_pc1 =stringtofloat(str_get_field(strs, field, delim))
;print(index_pc1)

;************************************************
; set function arguments
;************************************************
; detrending opt: 0=>remove mean 1=>remove mean and detrend
  d = 0
; smoothing periodogram: (0 <= sm <= ??.) should be at least 3 and odd
  sm = 5
; percent tapered: (0.0 <= pct <= 1.0) 0.10 common.
  pct = 0.10
;************************************************
; calculate spectrum
;************************************************
  sdof = specx_anal(index_pc1,d,sm,pct)
  splt = specx_ci(sdof, 0.05, 0.95)             ; calc confidence interval
  printVarSummary(splt)

  ;;;;; Set up arrays to hold bar coordinates
  width=0.05
  xmin = 0.2
  xmax = 0.3
  ymin = 0
  ymax = 35
  xbars = (/xmin, xmax, xmax, xmin, xmin/)
;
  ybars = (/ymin, ymin, ymax, ymax, ymin/)


;************************************************
; plotting
;************************************************
  wks  = gsn_open_wks("pdf","spec")                         ; Opens a ps file

  res                       = True					                ; no plot mods desired
  res@tiMainString          = "PDOI"		                    ; title
  res@tiXAxisString         = "Frequency (cycles/year)"     ; xaxis
  res@tiYAxisString         = "Variance"                    ; yaxis

  gres                      = True
  gres@gsFillColor          = "lightgray"


  plot = gsn_csm_xy(wks,sdof@frq, splt ,res)
  poly = gsn_add_polygon(wks,plot,xbars,ybars,gres)


;************************************************
end
