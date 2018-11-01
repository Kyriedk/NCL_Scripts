
  load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
  load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
  load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
  load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
  latS   = -90.
  latN   =  90.
  lonL   = 0.
  lonR   = 360.
  diri = "/gpfsES/geo/zywang/Rec_Obs_For_DATA/forcings/solar/PMIP/done/"
  fils = systemfunc ("ls "+ diri + "tsi_VK.txt")
  data = asciiread(fils,(/1000,2/),"float")
  tsi_vk=data(:,1)
  tsi_vk=tsi_vk*0.9965
;*********************************** tsi_vk
  tsi_vk_spec=specx_anal(tsi_vk,0,0,0.1)
  tsi_vk_splt0 = specx_ci (tsi_vk_spec, 0.1, 0.90)
  tsi_vk_splt1 = specx_ci (tsi_vk_spec, 0.05, 0.95)
  tsi_vk_splt2 = specx_ci (tsi_vk_spec, 0.01, 0.99)
  printVarSummary(tsi_vk_splt1)
  yy_tsi_vk = new((/4,500/),float)
  yy_tsi_vk(0,:) = tsi_vk_splt1(0,:)
  yy_tsi_vk(1,:) = tsi_vk_splt0(3,:)
  yy_tsi_vk(2,:) = tsi_vk_splt1(3,:)
  yy_tsi_vk(3,:) = tsi_vk_splt2(3,:)
;*****************************************************************
  wks=gsn_open_wks("ps","Period_vk")
  res=True
  res@gsnDraw             = False       ; Do not draw plot
  res@gsnFrame            = False       ; Do not advance frome
  res@xyLineThicknesses = (/ 3.0, 3.0, 3.0, 3.0/)          ; make second line thicker
  res@xyLineColors      = (/"black","blue","red","green"/)          ; change line color
  res@trXMinF = 0
  res@trXMaxF = 100
  res@trYMinF = 0
  res@trYMaxF = 25
; res@tiMainString  = ""     ; title
  res@tiXAxisString = "Period (year)"  ; xaxis string
  res@tiYAxisString = "Variance"                  ; yaxis string
  res@pmLegendDisplayMode    = "Always"            ; turn on legend
  res@pmLegendZone = 0 ; Change the location
  res@pmLegendOrthogonalPosF = 0.25 ; of the legend
  res@pmLegendSide           = "Top"               ; Change location of
  res@pmLegendWidthF         = 0.08                ; Change width and
  res@pmLegendHeightF        = 0.15                ; height of legend.
  res@lgPerimOn              = False               ; turn off box around
  res@lgJustification = "BottomRight"
  res@lgLabelFontHeightF     = .02                 ; label font height
  res@xyExplicitLegendLabels = (/"TSI_VK","90% Confidence","95% Confidence","99% Confidence"/)  
  res@gsnLeftStringFontHeightF=0.03
;  res@gsnLeftString  = "TSI_VK"
  plot1=gsn_csm_xy(wks,1/tsi_vk_spec@frq,yy_tsi_vk,res)
  draw(plot1)
  frame(wks)  
end
