;
; IDL Event Callback Procedures
; gen_gui_eventcb
;
; Generated on:	12/16/2014 21:37.03
;
;
; Empty stub procedure used for autoloading.
;
pro gen_gui_eventcb
end

pro gen_gui_loadcommons
common flag_set_range, fsr
common data_PV, pv,h
common data_prof, vel,prof
common gengui_N_Lines, N_Lines
common gengui_FWHM_EQ, FWHM_EQ
FWHM_EQ=intarr(3)
N_Lines=0
end

pro gengui_redrawprof,event
	common data_prof
	wGraph = WIDGET_INFO(Event.top, FIND_BY_UNAME='WID_DRAW_Profile')
	WIDGET_CONTROL, wGraph, GET_VALUE=idGraph
	wset,idGraph
	cgplot,vel,prof,charsize=.6
end
pro gengui_clear_textbox,Event
	outtext=WIDGET_INFO(Event.top, FIND_BY_UNAME='WID_TEXT_ProfStart');
	widget_control,outtext,SET_VALUE=''
	outtext=WIDGET_INFO(Event.top, FIND_BY_UNAME='WID_TEXT_ProfEnd');
	widget_control,outtext,SET_VALUE=''
	common flag_set_range
	fsr=0
	end
pro gengui_redraw_PV, Event
	;print, 'START REDRAW'
	common data_PV

	if N_elements(pv) gt 0 then begin
		;print, "REDRAW IS OK'
		wDraw = WIDGET_INFO(Event.top, FIND_BY_UNAME='WID_DRAW_PV');
    	;Make sure something was found.
    	IF(wDraw GT 0)THEN BEGIN
      	 	WIDGET_CONTROL, wDraw, GET_VALUE=idDraw
         	WSET,idDraw
         	im_pv=CONGRID(255-bytscl(sigrange(pv)), !D.X_SIZE, !D.Y_SIZE)
         	cgimage,im_pv
			gengui_clear_textbox,Event
      		ENDIF
		endif
end


;-----------------------------------------------------------------
; Activate Button Callback Procedure.
; Argument:
;   Event structure:
;
;   {WIDGET_BUTTON, ID:0L, TOP:0L, HANDLER:0L, SELECT:0}
;
;   ID is the widget ID of the component generating the event. TOP is
;       the widget ID of the top level widget containing ID. HANDLER
;       contains the widget ID of the widget associated with the
;       handler routine.

;   SELECT is set to 1 if the button was set, and 0 if released.
;       Normal buttons do not generate events when released, so
;       SELECT will always be 1. However, toggle buttons (created by
;       parenting a button to an exclusive or non-exclusive base)
;       return separate events for the set and release actions.

;   Retrieve the IDs of other widgets in the widget hierarchy using
;       id=widget_info(Event.top, FIND_BY_UNAME=name)

;-----------------------------------------------------------------
pro gen_menu_open_event, Event
sFile = DIALOG_PICKFILE(FILTER='*.f*s')
   IF(sFile NE "")THEN BEGIN
   	common data_PV
	pv=readfits(sFile,h)
	CRVAL1  =  sxpar(h, "CRVAL1")
	CDELT1  =  sxpar(h, "CDELT1")
	CRPIX1  =  sxpar(h, "CRPIX1")
	NAXIS1  =  sxpar(h, "NAXIS1")
	CRVAL2  =  sxpar(h, "CRVAL2")
	CDELT2  =  sxpar(h, "CDELT2")
	CRPIX2  =  sxpar(h, "CRPIX2")
	NAXIS2  =  sxpar(h, "NAXIS2")
	x0=10
	y0=10
	xs=0
	ys=0
	vel=(findgen(NAXIS2)-CRPIX2+1)*CDELT2+CRVAL2
	pos=(findgen(NAXIS1)-CRPIX1+1)*CDELT1+CRVAL1
	gengui_redraw_PV, Event
	;print,pos
	;wDraw = WIDGET_INFO(Event.top, FIND_BY_UNAME='WID_DRAW_PV');
    ;Make sure something was found.
    ;IF(wDraw GT 0)THEN BEGIN
    ;  	 WIDGET_CONTROL, wDraw, GET_VALUE=idDraw
    ;     WSET,idDraw
    ;     im_pv=CONGRID(255-bytscl(sigrange(pv)), !D.X_SIZE, !D.Y_SIZE)
    ;     cgimage,im_pv
	;	common flag_set_range
;		fsr=0
 ;     ENDIF
   ENDIF

end
;-----------------------------------------------------------------
; BUTTON_EVENTS Callback Procedure.
; Argument:
;   Event structure:
;
;   {WIDGET_DRAW, ID:0L, TOP:0L, HANDLER:0L, TYPE: 0, X:0, Y:0,
;       PRESS:0B, RELEASE:0B, CLICKS:0}

;   ID is the widget ID of the component generating the event. TOP is
;       the widget ID of the top level widget containing ID. HANDLER
;       contains the widget ID of the widget associated with the
;       handler routine.

;   TYPE returns a value that describes the type of draw widget
;       interaction that generated an event: 0 - Button Press, 1 -
;       Button Release, 2 - Motion, 3 - Viewport Moved, 4 -
;       Visibility Changed (Expose)


;   Retrieve the IDs of other widgets in the widget hierarchy using
;       id=widget_info(Event.top, FIND_BY_UNAME=name)

;-----------------------------------------------------------------
pro gen_set_range, Event
if event.type eq 0 then begin
	common data_PV
	print,event.x,event.y
	NAXIS1  =  sxpar(h, "NAXIS1")
	CRVAL2  =  sxpar(h, "CRVAL2")
	CDELT2  =  sxpar(h, "CDELT2")
	CRPIX2  =  sxpar(h, "CRPIX2")
	NAXIS2  =  sxpar(h, "NAXIS2")
	wDraw = WIDGET_INFO(Event.top, FIND_BY_UNAME='WID_DRAW_PV');
	;WIDGET_CONTROL, wDraw,draw_xsize=NAXIS1,draw_ysize=NAXIS2
	WIDGET_CONTROL, wDraw, GET_VALUE=idDraw
	wset,idDraw
    ;Make sure something was found.
	common flag_set_range
	;print,fsr
	xdevice=event.x
	;print, NAXIS1
	xdata=round(1.*xdevice/400*NAXIS1)
	;print, xdevice
	;print,xdevice/400*NAXIS1
	xdeviceround=xdata*400/NAXIS1
	if not fsr then begin ;first mark
		gengui_redraw_PV,Event
		outtext=WIDGET_INFO(Event.top, FIND_BY_UNAME='WID_TEXT_ProfStart');
		widget_control,outtext,SET_VALUE=string(xdata)
		plots, xdeviceround, 0,/device,color='0000FF'x
		plots, xdeviceround, 200,/device,/continue,color='0000FF'x
		fsr=1
		endif else begin  ;second mark
		outtext=WIDGET_INFO(Event.top, FIND_BY_UNAME='WID_TEXT_ProfEnd');
		widget_control,outtext,SET_VALUE=string(xdata)
		plots, xdeviceround, 0,/device,color='00FF00'x
		plots, xdeviceround, 200,/device,/continue,color='00FF00'x
		fsr=0
		common data_prof
		Wprofstart = WIDGET_INFO(Event.top, FIND_BY_UNAME='WID_TEXT_ProfStart');
		Wprofend = WIDGET_INFO(Event.top, FIND_BY_UNAME='WID_TEXT_ProfEnd');
		WIDGET_CONTROL, Wprofstart, GET_VALUE=profstart
		WIDGET_CONTROL, Wprofend, GET_VALUE=profend
		if profstart gt profend then begin
			tempprof=profstart
			profstart=profend
			profend=tempprof
			end
		if profstart lt profend then begin
			prof=total(pv[profstart:profend-1,*],1)
			vel=(findgen(NAXIS2)-CRPIX2+1)*CDELT2+CRVAL2

			gengui_redrawprof,event
			;print,'========'
			;print, vel
			;print,'===='
			;print, prof
			wset,idDraw
			end
		endelse
	endif
end

;-----------------------------------------------------------------
; Post Create Widget Procedure.
; Argument:
;   wWidget - ID number of specific widget.
;
;   Any keywords passed into the generated widget creation procedure
;       are passed into this procudure.

;   Retrieve the IDs of other widgets in the widget hierarchy using
;       id=widget_info(Event.top, FIND_BY_UNAME=name)

;-----------------------------------------------------------------
pro gen_onstart, wWidget, _EXTRA=_VWBExtra_
gen_gui_loadcommons
end
;-----------------------------------------------------------------
; Activate Button Callback Procedure.
; Argument:
;   Event structure:
;
;   {WIDGET_BUTTON, ID:0L, TOP:0L, HANDLER:0L, SELECT:0}
;
;   ID is the widget ID of the component generating the event. TOP is
;       the widget ID of the top level widget containing ID. HANDLER
;       contains the widget ID of the widget associated with the
;       handler routine.

;   SELECT is set to 1 if the button was set, and 0 if released.
;       Normal buttons do not generate events when released, so
;       SELECT will always be 1. However, toggle buttons (created by
;       parenting a button to an exclusive or non-exclusive base)
;       return separate events for the set and release actions.

;   Retrieve the IDs of other widgets in the widget hierarchy using
;       id=widget_info(Event.top, FIND_BY_UNAME=name)

;-----------------------------------------------------------------
pro gengui_run, Event
common data_prof
common gengui_N_Lines
common gengui_FWHM_EQ
;common gengui_AMP_Ratio
;print, N_Lines
if N_Lines eq 0 then begin
	N_Lines=gen_linecounter(vel,prof)
	wN_Lines = WIDGET_INFO(Event.top, FIND_BY_UNAME='WID_DROPLIST_N_Lines')
	WIDGET_CONTROL, wN_Lines, SET_DROPLIST_SELECT=N_Lines
	end
AMP_RATIO=fltarr(3)

for i=1, N_Lines do begin
	Wampr = WIDGET_INFO(Event.top, FIND_BY_UNAME=strcompress('WID_TEXT_AMP_RATIO'+string(i),/remove));
	;print,strcompress('WID_TEXT_AMP_RATIO'+string(i),/remove)
	;print, Wampr
	WIDGET_CONTROL, Wampr, GET_VALUE=AMP_RATIO_current
	AMP_RATIO[i-1]=AMP_RATIO_current
	;print,ololo
	end
AMP_RATIO_2use=AMP_RATIO[0:N_lines-1]
FWHM_eq_2use=FWHM_EQ[0:N_lines-1]
inst_vel=22.
model_type='voigt'
err=prof/prof*2
wGraph = WIDGET_INFO(Event.top, FIND_BY_UNAME='WID_DRAW_Profile')
WIDGET_CONTROL, wGraph, GET_VALUE=idGraph
wset,idGraph

print, minmax(prof)
;stop
gengui_redrawprof,event
res= genfun(vel,prof,err,model_type,N_lines,inst_vel=inst_vel,yfit=yfit,$
	reserror=reserror,SNR=SNR,FWHM_eq=FWHM_eq_2use, AMP_ratio=AMP_RATIO_2use,/quiet)

cgoplot,vel,yfit,color='blue',thick=2
model_tN_single=model_type + '1'
N_dots=300; to plot
xdots=findgen(N_dots)*(max(vel)-min(vel))/N_dots+min(vel)
for j=0, N_lines-1 do begin
		cgoplot,xdots,call_function('gen_'+model_tN_single $
			,xdots,[res[3*j:3*j+2],0,inst_vel]),color='cyan',thick=2
	endfor
cgoplot,vel,10*(yfit-prof)-min(10*(yfit-prof)),color='yellow',thick=2
cgoplot,vel,-min(10*(yfit-prof)),color='yellow',thick=2

table_out_arr=fltarr(3,4)
for i=0, N_lines-1 do begin
	table_out_arr[*,i]=res[0+3*i:2+3*i]
	end
table_out_arr[*,3]=res[3*N_lines:*]
wTable=widget_info(event.top, find_by_uname='WID_TABLE_OUT')
widget_control,wTable,set_value=string(table_out_arr)
end
;-----------------------------------------------------------------
; Droplist Select Item Callback Procedure.
; Argument:
;   Event structure:
;
;   {WIDGET_DROPLIST, ID:0L, TOP:0L, HANDLER:0L, INDEX:0L }
;
;   ID is the widget ID of the component generating the event. TOP is
;       the widget ID of the top level widget containing ID. HANDLER
;       contains the widget ID of the widget associated with the
;       handler routine.

;   INDEX returns the index of the selected item. This can be used to
;       index the array of names originally used to set the widget's
;       value.

;   Retrieve the IDs of other widgets in the widget hierarchy using
;       id=widget_info(Event.top, FIND_BY_UNAME=name)

;-----------------------------------------------------------------
pro gengui_N_Lines_select, Event
common gengui_N_Lines
N_Lines=Event.index
end
;-----------------------------------------------------------------
; Activate Button Callback Procedure.
; Argument:
;   Event structure:
;
;   {WIDGET_BUTTON, ID:0L, TOP:0L, HANDLER:0L, SELECT:0}
;
;   ID is the widget ID of the component generating the event. TOP is
;       the widget ID of the top level widget containing ID. HANDLER
;       contains the widget ID of the widget associated with the
;       handler routine.

;   SELECT is set to 1 if the button was set, and 0 if released.
;       Normal buttons do not generate events when released, so
;       SELECT will always be 1. However, toggle buttons (created by
;       parenting a button to an exclusive or non-exclusive base)
;       return separate events for the set and release actions.

;   Retrieve the IDs of other widgets in the widget hierarchy using
;       id=widget_info(Event.top, FIND_BY_UNAME=name)

;-----------------------------------------------------------------
pro gengui_FWHM_EQ_change, Event
common gengui_FWHM_EQ
widget_control,event.id,get_value=wNAME
FWHM_EQ_INDEX=wNAME-1
FWHM_EQ[FWHM_EQ_INDEX]=event.select

end
