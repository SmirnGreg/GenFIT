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


pro gengui_clear_textbox,Event
	outtext=WIDGET_INFO(Event.top, FIND_BY_UNAME='WID_TEXT_ProfStart');
	widget_control,outtext,SET_VALUE=''
	outtext=WIDGET_INFO(Event.top, FIND_BY_UNAME='WID_TEXT_ProfEnd');
	widget_control,outtext,SET_VALUE=''
	common flag_set_range, fsr
	fsr=0
	end
pro gengui_redraw_PV, Event
	print, 'START REDRAW'
	common data_PV, pv,h

	if N_elements(pv) gt 0 then begin
		print, "REDRAW IS OK'
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
   	common data_PV, pv,h
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
	vel=(findgen(NAXIS2)-CRPIX2)*CDELT2+CRVAL2
	pos=(findgen(NAXIS1)-CRPIX1)*CDELT1+CRVAL1
	print,pos
	wDraw = WIDGET_INFO(Event.top, FIND_BY_UNAME='WID_DRAW_PV');
    ;Make sure something was found.
    IF(wDraw GT 0)THEN BEGIN
      	 WIDGET_CONTROL, wDraw, GET_VALUE=idDraw
         WSET,idDraw
         im_pv=CONGRID(255-bytscl(sigrange(pv)), !D.X_SIZE, !D.Y_SIZE)
         cgimage,im_pv
		common flag_set_range, fsr
		fsr=0
      ENDIF
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
	common data_PV,pv,h
	print,event.x,event.y
	NAXIS1  =  sxpar(h, "NAXIS1")
	CRVAL2  =  sxpar(h, "CRVAL2")
	CDELT2  =  sxpar(h, "CDELT2")
	CRPIX2  =  sxpar(h, "CRPIX2")
	NAXIS2  =  sxpar(h, "NAXIS2")
	vel=(findgen(NAXIS2)-CRPIX2)*CDELT2+CRVAL2
	wDraw = WIDGET_INFO(Event.top, FIND_BY_UNAME='WID_DRAW_PV');
	WIDGET_CONTROL, wDraw, GET_VALUE=idDraw
	wset,idDraw
    ;Make sure something was found.
	common flag_set_range, fsr
	print,fsr
	if not fsr then begin ;first mark
		gengui_redraw_PV,Event
		outtext=WIDGET_INFO(Event.top, FIND_BY_UNAME='WID_TEXT_ProfStart');
		widget_control,outtext,SET_VALUE=string(event.x)
		plots, event.x, 0,/device,color='0000FF'x
		plots, event.x, 200,/device,/continue,color='0000FF'x
		fsr=1
		endif else begin  ;second mark
		outtext=WIDGET_INFO(Event.top, FIND_BY_UNAME='WID_TEXT_ProfEnd');
		widget_control,outtext,SET_VALUE=string(event.x)
		plots, event.x, 0,/device,color='00FF00'x
		plots, event.x, 200,/device,/continue,color='00FF00'x
		fsr=0

		endelse
	endif
end
