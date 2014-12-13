; �������� ����� ���������� ���������� ����� -- �������!

; ������ �������� -- ����!

; ���������� parinfo �� �����
; FWHM_equal=[1,1,0] -- ����!
; AMP_ratio=[3,2,0] -- ����!
pro gen
;Using genfun


;READ DATA FROM FILE
root='C:\astrowork\Genetic Algoritm\Function\'
data=readfits(root+'prof.fits',h)
;GENERATE DATA with gausI parameters
;gaussian1=randomu(seed,3)*40+15 ;gaus1 is random
gaussian1=[10,45,5] ;gaus1 is manually set
;SN=randomu(seed)*2
;print, gaussian1
inst_vel=22.
data=generate_profile(SN=1,gaus1=[40,10,10],gaus2=[60,60,10],inst_vel=inst_vel,fileroot=root,/do_voigt);,/poison)
;Function Generate_Profile,SN=SN,gaus1=gaus1,gaus2=gaus2,gaus3=gaus3,do_voigt=do_voigt,inst_vel=inst_vel,fileroot=fileroot ;description
;print, data
x=data[*,0]
y=data[*,1]
;print, x,y
;print,y
N_dots=300; to plot
xdots=findgen(N_dots)*(max(x)-min(x))/N_dots+min(x)

;stop
;PROFILE APRIORY PARAMETERS

N_lines=gen_linecounter(x,y,usemm=usemm)
model_type='voigt'
;call genfun
;N_lines=3
res= genfun(x,y,model_type,N_lines,FWHM_eq=[1,1],inst_vel=inst_vel,yfit=yfit,$
	reserror=reserror,SNR=SNR);, AMP_ratio=[4,8])
print,'Result ', res
print,'Errors ', reserror
print,'SNR ', SNR
print, inst_vel
;print,y
;cgplot, x,y,psym=1
;cgoplot, x, yfit


end

