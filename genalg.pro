FUNCTION Average, array
return,total(array)/n_elements(array)
end

FUNCTION Dispersion, array
return,Average(array^2)-Average(array)^2
end

function modelgen,x,param
	inst_vel=22.

	;choose model
	res=gaussian(x,param[0:1],param[2]/2.35482)
	;res=gaussian2(x,param)
	;res=gaussian3(x,param)
	;res=clb_voigt(x,param,inst_vel=inst_vel)
	;res=voigt2(x,param,inst_vel=inst_vel)
	;res=voigt3(x,param,inst_vel=inst_vel)
	;print, inst_vel
	return, res
end
FUNCTION CLB_VOIGT, x, param, inst_vel=inst_vel

  vel=inst_vel/2.35482
  param2=param[2]/2.35482
  b=(x-param[1])/(sqrt(2.)*param2)
  y=vel/(sqrt(2.)*param[2])
  res=voigt(y,b)/(sqrt(2.*!pi)*param2)
  norm=max(res)
  res=param[0]*res/norm


RETURN, res
END
function gaussian2,x,param
	res=gaussian(x,param[0:1],param[2]/2.35482)
	res+=gaussian(x,param[3:4],param[5]/2.35482)
	return, res
end
function gaussian3,x,param
	res=gaussian(x,param[0:1],param[2]/2.35482)
	res+=gaussian(x,param[3:4],param[5]/2.35482)
	res+=gaussian(x,param[6:7],param[8]/2.35482)
	return, res
end
function voigt2,x,param, inst_vel=inst_vel
	res=clb_voigt(x,param[0:2],inst_vel=inst_vel)
	res+=clb_voigt(x,param[3:5],inst_vel=inst_vel)
	return, res
end
function voigt3,x,param, inst_vel=inst_vel
	res=clb_voigt(x,param[0:2],inst_vel=inst_vel)
	res+=clb_voigt(x,param[3:5],inst_vel=inst_vel)
	res+=clb_voigt(x,param[6:8],inst_vel=inst_vel)
	return, res
end

function lesssquare,param,x,y
	return, total((modelgen(x,param)-y)^2)
end

pro genalg
;generate_profile

N_lines=1
model_type='gaus'

time=systime(1)
root='C:\astrowork\Genetic Algoritm\'
data=readfits('C:\astrowork\Genetic Algoritm\prof.fits',h)
;gaussian1=randomu(seed,3)*40+15
;gaussian1=[10,5,12]
;SN=randomu(seed)*2
;print, gaussian1

;data=generate_profile(SN=SN,gaus1=gaussian1,/do_voigt,inst_vel=22.,fileroot=root);,/poison)
;Function Generate_Profile,SN=SN,gaus1=gaus1,gaus2=gaus2,gaus3=gaus3,do_voigt=do_voigt,inst_vel=inst_vel,fileroot=fileroot
;print, data
x=data[*,0]
N_dots=300; to plot
xdots=findgen(N_dots)*(max(x)-min(x))/N_dots+min(x)
y=data[*,1]
nonoise=data[*,2]
cgplot,x,y,psym=7,color='red',thick=5
cgoplot,x,nonoise,color='pink'

mut=0.35
vmin=min(x)
vmax=max(x)
ymin=0.
ymax=max(y)*1.2
dispmin=0.
dispmax=0.02
par_min_i=[ymin,vmin,dispmin]
par_max_i=[ymax,vmax,dispmax]
print, par_min_i
print, par_max_i
param_min=par_min_i
param_max=par_max_i
for i=2,N_lines do begin
	param_min=[param_min,par_min_i]
	param_max=[param_max,par_max_i]
end
N=1000
N_param=N_elements(param_min)
param=fltarr(2*N,N_param)
errors=fltarr(2*N)
;generate
for i=0, N-1 do begin
	for j=0, N_param-1 do param[i,j]=(param_max[j]-param_min[j])*randomu(seed)+param_min[j]
	;sort by velocity
	;sort_by_vel=sort(param[i,[1,4,7]])
	;sbv=3*sort_by_vel
	;param[i,*]=param[i,[sbv[0],sbv[0]+1,sbv[0]+2,sbv[1],sbv[1]+1,sbv[1]+2,sbv[2],sbv[2]+1,sbv[2]+2]]
end
eps=2
color=200
oldtotal=0
while eps gt 1 do begin
	;shuffle first N (all) params
	shuffleorder=indgen(N)
	shuffleorder=shuffleorder(sort(randomu(seed,N)))
	param[0:N-1,*]=param[shuffleorder,*]
	;breeding
	for i=0, N-1,2 do begin
		;first child
		for j=0, N_param-1 do param[i+N,j]=(param[i,j]+round(randomu(seed))*(param[i+1,j]-param[i,j])) * (1+mut*randomn(seed)) ; (1-x)A+xB=A+x(A-B) -> A or B
		;second child
		for j=0, N_param-1 do param[i+N+1,j]=(param[i,j]+round(randomu(seed))*(param[i+1,j]-param[i,j])) * (1+mut*randomn(seed))
		end
	;looking for best params, sorting
	for i=0,2*N-1 do begin
		errors[i]=lesssquare(param[i,*],x,y)
	end
	order=sort(errors)
	param=(param[order,*])
	;kill the worst N params
	param[N:2*N-1,*]=0
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
	newtotal=total(errors)
	epserror=abs(newtotal-oldtotal)/newtotal
	if epserror lt 0.03 then eps=0
	;next
	eps=eps-0.0005
	oldtotal=newtotal
	;print, total(errors)
	;if total(errors) lt 1000 then eps=0
end
;looking for best params and one more sorting
for i=0,2*N-1 do begin
	errors[i]=lesssquare(param[i,*],x,y)
end
order=sort(errors)
param=(param[order,*])

;print, transpose(param[0:N-1,*])
newparam=param(0,*)
print,'===GEN TIME==='
print, systime(1)-time
cgoplot, xdots,modelgen(xdots,newparam),color='yellow',thick=3
print,'========GEN========='
print, newparam

;mpfit

  	model_param=newparam

  	parinfo=replicate({limited:[0,0],limits:[0,0]},3*N_lines)
  	for i=0, N_Lines-1 do begin
  		parinfo[i*3].limited=[1,1]
  		parinfo[i*3].limits=[ymin,ymax]
  	end
 	;parinfo[6].limited=[1,1]
 	;parinfo[6].limits=[1e-6,1e6]
  	err=0.1*(y/y)

  	res=mpfitfun("modelgen",x,y,err,model_param,yfit=yfit,parinfo=parinfo,quiet=1)
	;cgoplot,x,y,psym=1,color='green'
	print,'=====mpfit====='
	print,res
	cgoplot,xdots,modelgen(xdots,res),color='blue',thick=2
	;cgoplot,xdots,voigt2(xdots,res,inst_vel=22.)
	;cgoplot,xdots,clb_voigt(xdots,res[0:2],inst_vel=22.),color='blue'
	;cgoplot,xdots,clb_voigt(xdots,res[3:5],inst_vel=22.),color='blue'
	;cgoplot,xdots,clb_voigt(xdots,res[6:8],inst_vel=22.),color='blue'
print,'===TOTAL TIME==='
print, systime(1)-time
;print, gaussian1
;print, res
;print, max(Y)/sqrt(Dispersion(nonoise-y)),(abs(gaussian1-res)/gaussian1)
end