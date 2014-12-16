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
	  pv=readfits(sFile,h)
	  wDraw = WIDGET_INFO(Event.top, FIND_BY_UNAME='WID_DRAW_PV');
      ; Make sure something was found.
      IF(wDraw GT 0)THEN BEGIN
      	 WIDGET_CONTROL, wDraw, GET_VALUE=idDraw
         WSET,idDraw
         im_pv=CONGRID(255-bytscl(sigrange(pv)), !D.X_SIZE, !D.Y_SIZE)
         tv,im_pv
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
if event.type eq 0 then print,event.x,event.y

end
