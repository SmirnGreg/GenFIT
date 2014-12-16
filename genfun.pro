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

function gen_gaus1,x,param
;Gaussian with FWHM as a 3rd parameter
	res=gaussian(x,[param[0:1],param[2]/2.35482])
	res+=param[3]
	return, res
end
function gen_gaus2,x,param
;Sum of 2 Gaussians with FWHM as a 3rd parameter
	res=gaussian(x,[param[0:1],param[2]/2.35482])
	res+=gaussian(x,[param[3:4],param[5]/2.35482])
	res+=param[6]
	return, res
end
function gen_gaus3,x,param
;Sum of 3 Gaussians with FWHM as a 3rd parameter
	res=gaussian(x,[param[0:1],param[2]/2.35482])
	res+=gaussian(x,[param[3:4],param[5]/2.35482])
	res+=gaussian(x,[param[6:7],param[8]/2.35482])
	res+=param[9]
	return, res
end

function gen_voigt1,x,param
;Voigt profile
	res=gen_voigt(x,param[0:2],inst_vel=param[4])
	res+=param[3]
	return, res
end
function gen_voigt2,x,param,inst_vel
;Sum of 2 Voigts
	res=gen_voigt(x,param[0:2],inst_vel=param[7])
	res+=gen_voigt(x,param[3:5],inst_vel=param[7])
	res+=param[6]
	return, res
end
function gen_voigt3,x,param,inst_vel
;Sum of 3 Voigts
	res=gen_voigt(x,param[0:2],inst_vel=param[10])
	res+=gen_voigt(x,param[3:5],inst_vel=param[10])
	res+=gen_voigt(x,param[6:8],inst_vel=param[10])
	res+=param[9]
	return, res
end

function gen_gauspoly1,x,param
;Gaussian with ax^2+bx+c continuum
	res=gaussian(x,[param[0:1],param[2]/2.35482])
	res+=poly(x,param[3:5])
	return, res
end
function gen_gauspoly2,x,param
;Sum of 2 Gaussians with ax^2+bx+c continuum
	res=gaussian(x,[param[0:1],param[2]/2.35482])
	res+=gaussian(x,[param[3:4],param[5]/2.35482])
	res+=poly(x,param[6:8])
	return, res
end
function gen_gauspoly3,x,param
;Sum of 3 Gaussians with ax^2+bx+c continuum
	res=gaussian(x,[param[0:1],param[2]/2.35482])
	res+=gaussian(x,[param[3:4],param[5]/2.35482])
	res+=gaussian(x,[param[6:7],param[8]/2.35482])
	res+=poly(x,param[9:11])
	return, res
end

function gen_voigtpoly1,x,param
;Voigt profile with ax^2+bx+c continuum
	res=gen_voigt(x,param[0:2],inst_vel=param[6])
	res+=poly(x,param[3:5])
	return, res
end
function gen_voigtpoly2,x,param,inst_vel
;Sum of 2 Voigts with ax^2+bx+c continuum
	res=gen_voigt(x,param[0:2],inst_vel=param[9])
	res+=gen_voigt(x,param[3:5],inst_vel=param[9])
	res+=poly(x,param[6:8])
	return, res
end
function gen_voigtpoly3,x,param,inst_vel
;Sum of 3 Voigts with ax^2+bx+c continuum
	res=gen_voigt(x,param[0:2],inst_vel=param[12])
	res+=gen_voigt(x,param[3:5],inst_vel=param[12])
	res+=gen_voigt(x,param[6:8],inst_vel=param[12])
	res+=poly(x,param[9:11])
	return, res
end


function gen_ResSumSquares,param,x,y,model_tN,inst_vel=inst_vel
;Returns Residual Sum of Squares for x,y with model_tN
;inst_vel is required fot voigt model
	if strmid(model_tN,0,5) eq 'voigt' then begin
		if not keyword_set(inst_vel) then begin
			print, 'INST_VEL???'
			stop
			endif
		modely=call_function('gen_'+model_tN,x,[param,inst_vel])
		endif else begin
		modely=call_function('gen_'+model_tN,x,param)
		endelse

	return, total((modely-y)^2)
end

function gen_WeightSumSquares,param,x,y,err,model_tN,inst_vel=inst_vel
;Returns Weighted Residual Sum of Squares for x,y with model_tN
;inst_vel is required fot voigt model
	if strmid(model_tN,0,5) eq 'voigt' then begin
		if not keyword_set(inst_vel) then begin
			print, 'INST_VEL???'
			stop
			endif
		modely=call_function('gen_'+model_tN,x,[param,inst_vel])
		endif else begin
		modely=call_function('gen_'+model_tN,x,param)
		endelse

	return, total(((modely-y)/err)^2)
end


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
yn=yn[usemm[0]:usemm[1]]
xuse=x[usemm[0]:usemm[1]]

yn=yn/total(yn)
;print, total(yn)
moment1=total(xuse*yn)
moment2=total(xuse^2*yn)
moment3=total(xuse^3*yn)
moment4=total(xuse^4*yn)

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





FUNCTION genfun,x,y,err,model_type,N_lines,QUIET=QUIET,inst_vel=inst_vel,yfit=yfit,$
	reserror=reserror,SNR=SNR,FWHM_eq=FWHM_eq, AMP_ratio=AMP_ratio, POLY_cont=POLY_cont
;+
; NAME:
;   GENFUN
;
; AUTHOR:
;   Grigory V. Smirnov-Pnchukov, Moscow
;   SmirnGreg@mail.ru
;
; PURPOSE:
;   Perform least-squares fit using both genetic and MPFIT algorithms to spectral lines
;
; MAJOR TOPICS:
;    Fitting spectral lines
;
; CALLING SEQUENCE:
;   result = GENFUN(X, Y, ERR, model_type, N_lines, /Quiet, inst_vel=inst_vel, yfit=yfit)
;
; DESCRIPTION:
;
;  This function uses both genetic algorithm and MPFIT algorithm to fit x,y
;  with 'N_lines'-component 'model_type' profile. ERR -- errors of y.
;  Given the data, GENFUN finds the best set
;  of model parameters which match the data (in a least-squares
;  sense) and returns them in an array.
;  The main difference from MPFIT is no need in start_params, genetic algorithm founds it itself.
;
;  The user must supply the following items:
;   - An array of independent variable values ("X").
;   - An array of "measured" *dependent* variable values ("Y").
;   - Line a priori form: 'gaus' or 'voigt' ("model_type").
;   - Number of lines ("N_Lines")
;	- Instrunental velocity for voigt profile: ("inst_vel")
;
;   Optional parameters:
;   - /QUIET -- do not print text and plot
;   - yfit -- array that will contain fitted model(x,result)
;   - reserror -- array that will contain approximated errors
;	- SNR -- variable that will contain SNR
;   - FWHM_eq -- bool 1-dimension N_lines-size array. If FWHM_eq[i]=1 and FWHM_eq[j]=1 then FWHM[i]=FWHM[j],
; where components are sorted by velocity
; NOTE! Using FWHM_eq does NOT speed calculating of genetic algoritm
;	- AMP_ratio -- float 1-dimension N_lines-size array. If AMP_ratio[i]/AMP_ratio[j]=C then AMP[i]/AMP[j]=C,
; where components are sorted by velocity. If AMP_ratio[i]=0 then do not use.
; NOTE! AMP_ratio will be normalized to max(AMP_ratio)=1
;   - POLY_cont -- keyword for fitting with ax^2+bx+c continuum (constant continuum is set do default)

time=systime(1)
do_FWHM_eq=0
do_AMP_ratio=0
if keyword_set(FWHM_eq) then begin
	if N_elements(FWHM_eq) ne N_Lines then begin
		do_FWHM_eq=0
		print, '====ERROR===='
		print, 'FWHM_eq -- bool 1-dimension N_lines-size array. If FWHM_eq[i]=1 and FWHM_eq[j]=1 then FWHM[i]=FWHM[j],'
		print, 'where components are sorted by velocity'
		print, 'N_lines=',N_Lines
		print, 'Will not use FWHM_eq!'
		print, '==CONTINUE==='
		endif else begin
		FWHM_eq=FWHM_eq/FWHM_eq ;norm the array
		if total(FWHM_eq) ge 2 then begin
			do_FWHM_eq=1
			where_FWHM_eq=where(FWHM_eq eq 1)
			endif else begin
			do_FWHM_eq=0
			endelse
		endelse

	endif

if keyword_set(AMP_ratio) then begin
	if (N_elements(AMP_ratio) ne N_lines) and (total(AMP_ratio^2) ne 0) then begin
		do_AMP_ratio=0
		print, '====ERROR===='
		print, 'AMP_ratio -- float 1-dimension N_lines-size array. If AMP_ratio[i]/AMP_ratio[j]=C then AMP[i]/AMP[j]=C,'
		print, 'where components are sorted by velocity. If AMP_ratio[i]=0 then do not use.'
		print, 'N_lines=',N_Lines
		print, 'Will not use AMP_ratio!'
		print, '==CONTINUE==='
		endif else begin
		AMP_ratio=AMP_ratio*1./max(AMP_ratio)
		where_AMP_ratio=where(AMP_ratio ne 0)
		if N_elements(where_AMP_ratio) ge 2 then begin
			do_AMP_ratio=1
			endif else begin
			do_AMP_ratio=0
			endelse
		endelse

	endif
;print, do_AMP_ratio
;stop

;print, do_FWHM_eq
;stop
if keyword_set(POLY_cont) then do_POLY_cont=1 else do_POLY_Cont=0
if keyword_set(QUIET) then do_QUIET = 1 else do_QUIET = 0
if keyword_set(inst_vel) then inst_vel=inst_vel else inst_vel = 22.
if do_POLY_cont then begin
	model_tN=STRCOMPRESS(model_type+ 'poly' + string(N_Lines),/remove)
	endif else begin
	model_tN=STRCOMPRESS(model_type + string(N_Lines),/remove)
	endelse


N_dots=300; to plot
xdots=findgen(N_dots)*(max(x)-min(x))/N_dots+min(x)
if ~ do_QUIET then cgplot,x,y,psym=7,color='red',thick=5
;cgoplot,x,nonoise,color='pink'

;calculates dispersion to predict FWHM
yn=(y-min(y))/(max(y)-min(y))
use=where(yn gt 0.1)
wherecont=where(yn lt 0.1)
;print, use
usemm=minmax(use)
if usemm[0] ge 2 then usemm[0]=usemm[0]-2
if usemm[1] lt N_Elements(yn)-3 then usemm[1]=usemm[1]+2
;print,usemm
;stop
yn=yn[usemm[0]:usemm[1]]
xuse=x[usemm[0]:usemm[1]]
yn=yn/total(yn)
moment1=total(xuse*yn)
moment2=total(xuse^2*yn)
disp=sqrt(moment2-moment1^2)


contmin=min(y[wherecont],contmini)
contmax=max(y[wherecont],contmaxi)
mut=0.35
vmin=min(x)
vmax=max(x)
ymin=max(y)*0.1
ymax=max(y)*1.2
dispmin=0.2*disp
dispmax=2.5*disp

par_min_i=[ymin,vmin,dispmin]
par_max_i=[ymax,vmax,dispmax]
param_min=par_min_i
param_max=par_max_i
for i=2,N_lines do begin
	param_min=[param_min,par_min_i]
	param_max=[param_max,par_max_i]
end

if do_POLY_cont then begin
	;continuum a priori set as ax^2+bx+c
	;fit with MPFIT y=P[0]+P[1]*x+P[2]*x^2 at x[wherecont]
	cont_0=[(contmin+contmax)*0.5,0,0]
	cont=mpfitfun('poly',x[wherecont],y[wherecont],err[wherecont],cont_0,contfit=contfit,quiet=do_QUIET)
	;if ~ do_QUIET then cgoplot,xdots,poly(xdots,cont),color='green',thick=2
	;if ~ do_QUIET then cgoplot,x[wherecont],y[wherecont],psym=7,color='green',thick=5
	contmin=cont
	contmax=cont ;it will mute anyway
	end
param_min=[param_min,contmin]
param_max=[param_max,contmax]


N=1000
N_param=N_elements(param_min)
param=fltarr(N_param,2*N)
wss=fltarr(2*N)
;generate

for i=0, N-1 do begin
	for j=0, N_param-1 do begin
		param[j,i]=(param_max[j]-param_min[j])*randomu(seed)+param_min[j]
		end
	if do_FWHM_eq then begin
		;sort by velocity
		vel2sort=param[1,i]
		for j=1, N_lines-1 do vel2sort=[vel2sort,param[j*3+1,i]]
		sort_by_vel=sort(vel2sort)
		;print, vel2sort
		;print, sort_by_vel
		FWHM_sbv=sort_by_vel*3+2 ;indexes of FWHM, sorted by velocity
		for j=1, N_elements(where_FWHM_eq)-1 do begin
			param[FWHM_sbv[where_FWHM_eq[j]],i]=param[FWHM_sbv[where_FWHM_eq[0]],i]
			end
		;print, FWHM_sbv
		;print, where_FWHM_eq
		;print, param[*,i]
		;stop
		end
	if do_AMP_ratio then begin
		;sort by velocity
		vel2sort=param[1,i]
		for j=1, N_lines-1 do vel2sort=[vel2sort,param[j*3+1,i]]
		sort_by_vel=sort(vel2sort)
		AMP_sbv=sort_by_vel*3 ;indexes of AMP, sorted by velocity
		maxAMP=max(param[AMP_sbv,i])
		;print, param[*,i]
		;print, maxAMP
		for j=0, N_elements(where_AMP_ratio)-1 do begin
			param[AMP_sbv[where_AMP_ratio[j]],i]=maxAMP*AMP_ratio[where_AMP_ratio[j]]
			end
		;print, param[*,i]
		;stop
		end

	;sbv=3*sort_by_vel
	;param[i,*]=param[i,[sbv[0],sbv[0]+1,sbv[0]+2,sbv[1],sbv[1]+1,sbv[1]+2,sbv[2],sbv[2]+1,sbv[2]+2]]
end
eps=1
color=200
oldtotal=0
while eps gt 0 do begin
	;shuffle first N (all) params
	shuffleorder=indgen(N)
	shuffleorder=shuffleorder(sort(randomu(seed,N)))
	param[*,0:N-1]=param[*,shuffleorder]
	;breeding
	for i=0, N-1,2 do begin
		;first child
		for j=0, N_param-1 do param[j,i+N]=(param[j,i]+round(randomu(seed))*(param[j,i+1]-param[j,i])) * (1+mut*randomn(seed)) ; (1-x)A+xB=A+x(A-B) -> A or B
		;second child
		for j=0, N_param-1 do param[j,i+N+1]=(param[j,i]+round(randomu(seed))*(param[j,i+1]-param[j,i])) * (1+mut*randomn(seed))
		end

	if do_FWHM_eq then begin
		for i=N, 2*N-1 do begin
			;sort by velocity
			vel2sort=param[1,i]
			for j=1, N_lines-1 do vel2sort=[vel2sort,param[j*3+1,i]]
			sort_by_vel=sort(vel2sort)
			;print, vel2sort
			;print, sort_by_vel
			FWHM_sbv=sort_by_vel*3+2 ;indexes of FWHM, sorted by velocity
			for j=1, N_elements(where_FWHM_eq)-1 do begin
				param[FWHM_sbv[where_FWHM_eq[j]],i]=param[FWHM_sbv[where_FWHM_eq[0]],i]
				end
			;print, FWHM_sbv
			;print, where_FWHM_eq
			;print, transpose(param[i,*])
			;stop
			end
		end
	if do_AMP_ratio then begin
		for i=N, 2*N-1 do begin
			;sort by velocity
			vel2sort=param[1,i]
			for j=1, N_lines-1 do vel2sort=[vel2sort,param[j*3+1,i]]
			sort_by_vel=sort(vel2sort)
			AMP_sbv=sort_by_vel*3 ;indexes of AMP, sorted by velocity
			maxAMP=max(param[AMP_sbv,i])
			;print, param[*,i]
			;print, maxAMP
			for j=0, N_elements(where_AMP_ratio)-1 do begin
				param[AMP_sbv[where_AMP_ratio[j]],i]=maxAMP*AMP_ratio[where_AMP_ratio[j]]
				end
			;print, param[*,i]
			;stop
			end
		end
	;looking for best params, sorting
	for i=0,2*N-1 do begin
		;rss[i]=gen_ResSumSquares(param[*,i],x,y,model_tN,inst_vel=inst_vel)
		wss[i]=gen_WeightSumSquares(param[*,i],x,y,err,model_tN,inst_vel=inst_vel)
	end
	order=sort(wss)
	param=(param[*,order])
	;kill the worst N params
	param[*,N:2*N-1]=0
	;sort by velocity
	;for i=0, N-1 do begin
	;	sort_by_vel=sort(param[i,[1,4,7]])
	;	sbv=3*sort_by_vel
	;	param[i,*]=param[i,[sbv[0],sbv[0]+1,sbv[0]+2,sbv[1],sbv[1]+1,sbv[1]+2,sbv[2],sbv[2]+1,sbv[2]+2]]
	;end
	;oplot the best one
	;cgoplot,xdots,modelgen(xdots,param[0,*]),color=color
	if color gt 2 then color=color-1
	;exit if slow
	newtotal=total(wss)
	epserror=abs(newtotal-oldtotal)/newtotal
	if epserror lt 0.03 then eps=eps-0.1
	;next
	eps=eps-0.0005
	oldtotal=newtotal
	;print, total(errors)
	;if total(errors) lt 1000 then eps=0
end
;looking for best params and one more sorting
for i=0,2*N-1 do begin
	;rss[i]=gen_ResSumSquares(param[*,i],x,y,model_tN,inst_vel=inst_vel)
	wss[i]=gen_WeightSumSquares(param[*,i],x,y,err,model_tN,inst_vel=inst_vel)
end
order=sort(wss)
param=(param[*,order])

;print, transpose(param[0:N-1,*])
bestparam=param[*,0]
;print, bestparam[7]
;sort by velocity
vel2sort=bestparam[1]
for j=1, N_lines-1 do vel2sort=[vel2sort,bestparam[j*3+1]]
sort_by_vel=sort(vel2sort)
sbv=3*sort_by_vel
genparam=bestparam[[sbv[0],sbv[0]+1,sbv[0]+2]]
for j=1, N_lines-1 do genparam=[genparam,bestparam[[sbv[j],sbv[j]+1,sbv[j]+2]]]
if do_POLY_cont then genparam=[genparam,bestparam[N_param-3:N_param-1]] $
	else genparam=[genparam,bestparam[N_param-1]]
;print, genparam

;	param[i,*]=param[i,[sbv[0],sbv[0]+1,sbv[0]+2,sbv[1],sbv[1]+1,sbv[1]+2,sbv[2],sbv[2]+1,sbv[2]+2]]

if ~ do_QUIET then begin
	print,'======GEN TIME======'
	print, systime(1)-time
	cgoplot, xdots,call_function('gen_'+model_tN,xdots,[genparam,inst_vel]),color='yellow',thick=3
	print,'========GEN========='
	print, genparam
	end

;mpfit

model_param=genparam
if model_type eq 'voigt' then begin
	parinfo=replicate({limited:[0,0],limits:[0,0],fixed:0,tied:''},N_param+1)
	parinfo[N_Param].fixed=1
	model_param=[model_param,inst_vel]
	endif else begin
	parinfo=replicate({limited:[0,0],limits:[0,0],tied:''},N_param)
	endelse
for i=0, N_Lines-1 do begin
	parinfo[i*3].limited=[1,1]
	parinfo[i*3].limits=[ymin,ymax]
	;If genetic algorithm calculated fit out from limit or close to limit, change it.
	if model_param[i*3] ge ymax-0.05*(ymax-ymin) then begin
		model_param[i*3]=ymax-0.05*(ymax-ymin)
		endif
  	if model_param[i*3] le ymin+0.05*(ymax-ymin) then begin
  		model_param[i*3]=ymin+0.05*(ymax-ymin)
  		endif
  	end
if do_FWHM_eq then begin
	for i=1, N_elements(where_FWHM_eq)-1 do begin
		parinfo[where_FWHM_eq[i]*3+2].tied=STRCOMPRESS('P('+string(where_FWHM_eq[0]*3+2)+')',/remove)
		end
	end
if do_AMP_ratio then begin
	maxAMP=max(AMP_ratio,max_AMP_index)
	;print, AMP_ratio
	;print, max_AMP_index
	for i=0, N_elements(where_AMP_ratio)-1 do begin
		if i ne max_AMP_index then parinfo[where_AMP_ratio[i]*3].tied=$
			STRCOMPRESS('P('+string(max_AMP_index*3)+')*'+string(AMP_ratio[where_AMP_ratio[i]]),/remove)
		end
	print, transpose(parinfo[*].tied)
	;stop
	end
	mpfitparam=mpfitfun('gen_'+model_tN,x,y,err,model_param,yfit=yfit,parinfo=parinfo,quiet=do_QUIET)
	;sort by velocity
	vel2sort=mpfitparam[1]
	for j=1, N_lines-1 do vel2sort=[vel2sort,mpfitparam[j*3+1]]
	sort_by_vel=sort(vel2sort)
	sbv=3*sort_by_vel
	res=mpfitparam[[sbv[0],sbv[0]+1,sbv[0]+2]]
	for j=1, N_lines-1 do res=[res,mpfitparam[[sbv[j],sbv[j]+1,sbv[j]+2]]]
	if do_POLY_cont then res=[res,mpfitparam[N_param-3:N_param-1]] $
		else res=[res,mpfitparam[N_param-1]] ;continuum
	;cgoplot,x,y,psym=1,color='green'
	yfit=call_function('gen_'+model_tN,x,[res,inst_vel])
	if ~ do_QUIET then begin
		print,'=====mpfit====='
		print,res
		model_tN_single=model_type + '1'
		for j=0, N_lines-1 do begin
			cgoplot,xdots,call_function('gen_'+model_tN_single $
				,xdots,[res[3*j:3*j+2],0,inst_vel]),color='cyan',thick=2
			endfor
		if do_POLY_cont then ycont=poly(xdots,res[N_param-3:N_param-1]) $
			else ycont=intarr(N_elements(xdots))+res[N_param-1]
		cgoplot,xdots,ycont,color='cyan',thick=2
		cgoplot,xdots,call_function('gen_'+model_tN,xdots,[res,inst_vel]),color='blue',thick=3
		cgoplot,x[usemm],[0,0],psym=2,thick=10,color='green'
		print,'===TOTAL TIME==='
		print, systime(1)-time
		endif
	;cgoplot,xdots,voigt2(xdots,res,inst_vel=22.)
	;if ~ do_QUIET then cgoplot,xdots,gen_voigt(xdots,res[0:2],inst_vel=22.),color='blue'
	;if ~ do_QUIET then cgoplot,xdots,gen_voigt(xdots,res[3:5],inst_vel=22.),color='blue'
	;if ~ do_QUIET then cgoplot,xdots,gen_voigt(xdots,res[6:8],inst_vel=22.),color='blue'
	;cgoplot,cdots,
;print, gaussian1
;if not do_QUIET then print, res
;this string is used if profile was created with generate_profile
;print, max(Y)/sqrt(Dispersion(nonoise-y)),(abs(gaussian1-res)/gaussian1)
lines_amp=res[0]
for i=1,N_Lines-1 do begin
	lines_amp=res[3*i]
	end
SNR=max(lines_amp)/sqrt(variance(y-yfit))
;Param errors calculate as
;abs(dAmp/Amp)=0.3705/SNR
;abs(dVel/Vel)=0.2593/SNR
;abs(dFWHM/FWHM)=0.5989/SNR
errorK=[0.3705,0.2593,0.5989]
reserror=res
for i=0,N_Lines-1 do begin
	for j=0,2 do  reserror[3*i+j]=res[3*i+j]*errorK[j]/SNR
	end

reserror[N_param-1]=!VALUES.F_NAN
if do_POLY_cont then reserror[N_param-3:N_param-2]=!VALUES.F_NAN ; we haven't yet measured continuum errors

if ~ do_QUIET then print, 'inst_vel=',inst_vel
return,res
end