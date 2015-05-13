FUNCTION gen_VOIGT, x, param, inst_vel=inst_vel

  vel=inst_vel/2;.35482
  disp=param[2]/2.35482
  b=(x-param[1])/(sqrt(2.)*disp)
  y=vel/(sqrt(2.)*disp)
  res=voigt(y,b)/(sqrt(2.*!pi)*disp)
  norm=max(res)
  res=param[0]*res/norm


RETURN, res
END

FUNCTION gen_VOIGT_new, x, param, inst_vel=inst_vel
	res=voigt(inst_vel*0.832555/(param[2]),(x-param[1])*1.66511/param[2])
	res=res/max(res)*param[0]
RETURN, res

END


pro testvoigt
param=[1,0,20]
inst_vel=25.
x=findgen(1000)/10-50

y_old=gen_VOIGT(x,param,inst_vel=inst_vel)
y_new=gen_VOIGT_new(x,param,inst_vel=inst_vel)
y_gaus=gaussian(x,[param[0],param[1],param[2]/2.35482])
g=inst_vel/2

y_lorenz=1/(!pi*g*(1+(x-param[1])^2/g^2))
y_lorenz=y_lorenz*param[0]/max(y_lorenz)
fwhm=where(y_new ge 0.5)
print, x[fwhm]
print, (max(x[fwhm])-min(x[fwhm]))
cgplot, x,y_old,color='red'
cgoplot,x,y_new,color='green',psym=1
cgoplot, x,y_gaus,color='magenta'
cgoplot,x,y_lorenz,color='yellow'
end
