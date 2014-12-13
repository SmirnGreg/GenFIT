FUNCTION Average, array
return,total(array)/n_elements(array)
end

FUNCTION Dispersion, array
return,Average(array^2)-Average(array)^2
end

FUNCTION gen_VOIGT, x, param, inst_vel=inst_vel

  vel=inst_vel/2.35482
  disp=param[2]/2.35482
  b=(x-param[1])/(sqrt(2.)*disp)
  y=vel/(sqrt(2.)*disp)
  res=voigt(y,b)/(sqrt(2.*!pi)*disp)
  norm=max(res)
  res=param[0]*res/norm


RETURN, res
END


Function Generate_Profile,SN=SN,gaus1=gaus1,gaus2=gaus2,gaus3=gaus3,$
		do_voigt=do_voigt,inst_vel=inst_vel,fileroot=fileroot,poison=poison

;file parameter
if keyword_set(fileroot) eq 0 then begin
	fileroot='C:\astrowork\Genetic Algoritm\'
end
fileout=fileroot+'prof.fits'
fileps=fileroot+'prof.ps'
set_plot,'ps'
device,file=fileps,/color
;S/N
if keyword_set(SN) eq 0 then SN=30.
;gaussian parameters 1
if keyword_set(gaus1) eq 0 then begin
	ampl=3.
	v0=30.
	disp=15.
endif else begin
	ampl=gaus1[0]
	v0=gaus1[1]
	disp=gaus1[2]
end
;gaussian parameters 2
if keyword_set(gaus2) eq 0 then begin
	do_gauss_2=0
endif else begin
	do_gauss_2=1
	ampl2=gaus2[0]
	v02=gaus2[1]
	disp2=gaus2[2]
end
;gaussian parameters 3
if keyword_set(gaus3) eq 0 then begin
	do_gauss_3=0
endif else begin
	do_gauss_3=1
	ampl3=gaus3[0]
	v03=gaus3[1]
	disp3=gaus3[2]
end
;Voigt parameters
if keyword_set(inst_vel) eq 0 then inst_vel=22.

;bins
N=40
vmin=-20.
vpb=3.


vmax=vmin+(N-1)*vpb
V=findgen(N)*vpb+vmin
;print,'hello'
if do_VOIGT eq 0 then begin
	Y=gaussian(V,[ampl,v0,disp/2.35482])
	if do_gauss_2 eq 1 then Y=Y+gaussian(V,[ampl2,v02,disp2/2.35482])
	if do_gauss_3 eq 1 then Y=Y+gaussian(V,[ampl3,v03,disp3/2.35482])
	;print,'GAUSSIAN'
	endif else begin
	Y=gen_voigt(V,[ampl,v0,disp],inst_vel=inst_vel)
	if do_gauss_2 eq 1 then Y=Y+gen_voigt(V,[ampl2,v02,disp2],inst_vel=inst_vel)
	if do_gauss_3 eq 1 then Y=Y+gen_voigt(V,[ampl3,v03,disp3],inst_vel=inst_vel)
	;print, 'VOIGT'
	;print,y
	end
if keyword_set(poison) eq 0 then begin
	Noise=(randomn(seed,n_elements(Y)))/sqrt(SN);*sqrt(1/10) 	; S/N = const
endif else begin
	Noise=1/sqrt(SN)*randomn(seed,n_elements(Y))+$
	 randomn(seed,n_elements(Y))*(sqrt(Y))/sqrt(SN) ; poison noise
end
YN=Y+Noise
;print, dispersion(Noise)
;print,max(Y)/sqrt(Dispersion(Noise))
;print, total(Noise)
cgplot,V,YN,psym=2
cgoplot,V,Y,color='green'
cgoplot,V,YN
writefits,fileout,[[V],[YN],[Y]]
device,/close
set_plot,'win'
;print, inst_vel
return,[[V],[YN],[Y]]
end