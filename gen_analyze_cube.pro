pro gen_analyze_cube

root='C:\astrowork\Genetic Algoritm\GenFIT\'
file=root+'Ho_I_B_obj_lin.fts'
cpu,tpool_min=10000

cube=readfits(file,h)

x0=230
x1=500
y0=84
y1=365

;cube=cube[250:375 ,125:225 , *]
;x0=285
;x1=324
;y0=182
;y1=212
cube=cube[x0:x1 ,y0:y1 , *]
cube4=congrid(cube,(x1-x0)/10,(y1-y0)/10,40)
cubeuse=cube4
image=total(cubeuse,3)
NAXIS3  =  sxpar(h, "NAXIS3")
CRPIX3  =  sxpar(h, "CRPIX3")
CDELT3  =  sxpar(h, "CDELT3")
CRVAL3  =  sxpar(h, "CRVAL3")

cgimage,255-sigrange(image),/window

;stop

siz=size(cubeuse)
print, 'SIZE=',siz[1]*siz[2]
print, 'Est. time =',siz[1]*siz[2]*4/60.,'min'
stop
time=systime(1)
dvel=fltarr(siz[1],siz[2])
amp=fltarr(siz[1],siz[2])
vel=0.001*((findgen(NAXIS3)-CRPIX3+1)*CDELT3+CRVAL3)
err=(vel/vel)+.1

N_Lines=2
inst_vel=22.
for x=0,siz[1]-1 do begin
	for y=0, siz[2]-1 do begin
		;print,x,y
		prof=transpose(cubeuse[x,y,*])
		;window,1
		;cgplot,vel,prof
		;stop
		fitres= genfun(vel,prof,err,'voigt',N_lines,FWHM_eq=[1,1],inst_vel=inst_vel,/quiet)
		;print, fitres
		;cgplot,vel,prof
		;cgoplot,vel,yfit
		;stop
		dvel[x,y]=abs(fitres[4]-fitres[1])
		amp[x,y]=total(prof);sqrt(fitres[0]^2+fitres[3]^2)
		end
	end
cgimage,sigrange(dvel),/window
writefits,root+'HoI_dvel.fits',dvel
writefits,root+'HoI_amp.fits',amp
;print, dvel
print, systime(1)-time


end

pro gen_an_makeimage
root='C:\astrowork\Genetic Algoritm\GenFIT\'
dvel=readfits(root+'dvel.fits',hdvel)
amp =readfits(root+ 'amp.fits',hamp )

dcolor=bytscl(dvel,0,100)
print, dcolor
;stop

amp=alog10(amp)
amp=amp/max(amp)
print,[[[amp*(255-dcolor)]],[[amp*dcolor]]]
;stop
image=[[[amp*(dcolor)]],[[amp*(255-dcolor)]],[[0*amp]]]
print, size(image)
;stop
;ImageDims = SIZE(image, /DIMENSIONS)
;interleaving = WHERE((imageDims NE imageSize[0]) AND $
;   (imageDims NE imageSize[1])) + 1
;PRINT, 'Type of Interleaving = ', interleaving
;WINDOW, 0, XSIZE = imageSize[0], YSIZE = imageSize[1], $
;   TITLE = 'An RGB Image'
;TV, image, TRUE = interleaving[0]
cgimage,image,/window


end