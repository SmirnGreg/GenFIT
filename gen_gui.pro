; 
; IDL Widget Interface Procedures. This Code is automatically 
;     generated and should not be modified.

; 
; Generated on:	03/02/2015 12:11.32
; 
pro WID_BASE_0_event, Event

  wTarget = (widget_info(Event.id,/NAME) eq 'TREE' ?  $
      widget_info(Event.id, /tree_root) : event.id)


  wWidget =  Event.top

  case wTarget of

    Widget_Info(wWidget, FIND_BY_UNAME='menu_open'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        gen_menu_open_event, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME='menu_redraw'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        gengui_redraw_PV, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME='WID_DRAW_PV'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_DRAW' )then $
        if( Event.type eq 0 )then $
          gen_set_range, Event
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_DRAW' )then $
        if( Event.type eq 1 )then $
          gen_set_range, Event
    end
    else:
  endcase

end

pro WID_BASE_0, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  Resolve_Routine, 'gen_gui_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines
  
  WID_BASE_0 = Widget_Base( GROUP_LEADER=wGroup, UNAME='WID_BASE_0'  $
      ,SCR_XSIZE=660 ,SCR_YSIZE=300 ,TITLE='IDL' ,SPACE=3 ,XPAD=3  $
      ,YPAD=3 ,MBAR=WID_BASE_0_MBAR)

  
  menu_file = Widget_Button(WID_BASE_0_MBAR, UNAME='menu_file' ,/MENU  $
      ,VALUE='File')

  
  menu_open = Widget_Button(menu_file, UNAME='menu_open' ,VALUE='Open'+ $
      ' PV')

  
  menu_edit = Widget_Button(WID_BASE_0_MBAR, UNAME='menu_edit' ,/MENU  $
      ,VALUE='Edit')

  
  menu_redraw = Widget_Button(menu_edit, UNAME='menu_redraw'  $
      ,VALUE='Redraw')

  
  WID_DRAW_PV = Widget_Draw(WID_BASE_0, UNAME='WID_DRAW_PV' ,FRAME=1  $
      ,XOFFSET=40 ,YOFFSET=40 ,SCR_XSIZE=400 ,SCR_YSIZE=140  $
      ,/BUTTON_EVENTS)

  
  WID_DRAW_Profile = Widget_Draw(WID_BASE_0, UNAME='WID_DRAW_Profile'  $
      ,XOFFSET=480 ,YOFFSET=40 ,SCR_XSIZE=140 ,SCR_YSIZE=140)

  
  WID_TEXT_ProfStart = Widget_Text(WID_BASE_0,  $
      UNAME='WID_TEXT_ProfStart' ,XOFFSET=40 ,YOFFSET=190  $
      ,SCR_XSIZE=80 ,SCR_YSIZE=30 ,/EDITABLE ,/WRAP ,XSIZE=20  $
      ,YSIZE=1)

  
  WID_TEXT_ProfEnd = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_ProfEnd'  $
      ,XOFFSET=180 ,YOFFSET=190 ,SCR_XSIZE=80 ,SCR_YSIZE=30 ,XSIZE=20  $
      ,YSIZE=1)

  
  WID_BUTTON_GENFIT = Widget_Button(WID_BASE_0,  $
      UNAME='WID_BUTTON_GENFIT' ,XOFFSET=280 ,YOFFSET=190  $
      ,SCR_XSIZE=80 ,SCR_YSIZE=30 ,/ALIGN_CENTER ,VALUE='GenFIT!')

  Widget_Control, /REALIZE, WID_BASE_0

  XManager, 'WID_BASE_0', WID_BASE_0, /NO_BLOCK  

end
; 
; Empty stub procedure used for autoloading.
; 
pro gen_gui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  WID_BASE_0, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end