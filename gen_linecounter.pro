function gen_linecounter,x,y,usemm=usemm,moments=moments,QUIET=QUIET
;Speculates number of lines must be used to fit y=model(x)
if keyword_set(QUIET) then QUIET = 1 else QUIET = 0
yn=(y-min(y))/(max(y)-min(y))
use=where(yn gt 0.1)
usemm=minmax(use)
;print, usemm
;usemm[0]=max([usemm[0]-2,0])
;usemm[1]=min([usemm[1]+2,N_elements(x)-1])
;print,usemm

;stop
if usemm[0] ge 2 then usemm[0]=usemm[0]-2
if usemm[1] lt N_Elements(yn)-3 then usemm[1]=usemm[1]+2
print, usemm
yn=double(yn[usemm[0]:usemm[1]])
xuse=double(x[usemm[0]:usemm[1]])

yn=yn/total(yn)
print,yn
print, total(yn)
print,'====='
print, total(xuse^2*yn)-total(xuse*yn)^2
;print, total(yn)
moment1=DOUBLE(total(xuse*yn))
moment2=DOUBLE(total(xuse^2*yn))
moment3=DOUBLE(total(xuse^3*yn))
moment4=DOUBLE(total(xuse^4*yn))

sigm=sqrt(moment2-moment1^2)
FWHM=2.35482*sigm
if ~ QUIET then print, 'FWHM=',FWHM
asymmetry=(moment3-3*moment1*moment2+2*moment1^3)/sigm^3
if ~ QUIET then print, 'asymmetry=',asymmetry
excess=(moment4-4*moment1*moment3+6*moment1^2*$
	moment2-3*moment1^4)/sigm^4-3
if ~ QUIET then print, 'excess=',excess
if (abs(asymmetry) gt 0.1) or (excess lt -0.7) then N_lines=2 else N_lines=1
if (abs(asymmetry) gt 0.5) and (excess gt -0.5) then N_lines=3
;if (excess+0.55)^2+asymmetry^2 le (2*0.04)^2 then N_lines=1 else N_lines=2 tested for gaussian, good enough
moments=[moment1,FWHM,asymmetry,excess]
return,N_lines
end




