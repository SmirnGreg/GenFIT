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

