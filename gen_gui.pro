; 
; IDL Widget Interface Procedures. This Code is automatically 
;     generated and should not be modified.

; 
; Generated on:	03/23/2015 13:30.31
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
    Widget_Info(wWidget, FIND_BY_UNAME='WID_DRAW_PV'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_DRAW' )then $
        if( Event.type eq 0 )then $
          gen_set_range, Event
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_DRAW' )then $
        if( Event.type eq 1 )then $
          gen_set_range, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME='WID_BUTTON_GENFIT'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        gengui_run, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME='WID_CHKbox_FWHM1'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        gengui_FWHM_EQ_change, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME='WID_CHKbox_FWHM2'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        gengui_FWHM_EQ_change, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME='WID_CHKbox_FWHM3'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        gengui_FWHM_EQ_change, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME='WID_DROPLIST_N_Lines'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_DROPLIST' )then $
        gengui_N_Lines_select, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME='WID_Radio_GAUS'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        gengui_gaus_radio, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME='WID_Radio_VOIGT'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        gengui_voigt_radio, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME='WID_POLY_CONT'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        gengui_changePOLYCONT, Event
    end
    else:
  endcase

end

pro WID_BASE_0, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  Resolve_Routine, 'gen_gui_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines
  
  WID_BASE_0 = Widget_Base( GROUP_LEADER=wGroup, UNAME='WID_BASE_0'  $
      ,SCR_XSIZE=733 ,SCR_YSIZE=435 ,TITLE='GENFit GUI | PV-analysis'+ $
      ' | G.V. Smirnov-Pinchukov' ,SPACE=3 ,XPAD=3 ,YPAD=3  $
      ,MBAR=WID_BASE_0_MBAR)

  
  gen_onstart, WID_BASE_0, _EXTRA=_VWBExtra_

  
  menu_file = Widget_Button(WID_BASE_0_MBAR, UNAME='menu_file' ,/MENU  $
      ,VALUE='File')

  
  menu_open = Widget_Button(menu_file, UNAME='menu_open' ,VALUE='Open'+ $
      ' PV')

  
  WID_DRAW_PV = Widget_Draw(WID_BASE_0, UNAME='WID_DRAW_PV' ,FRAME=1  $
      ,XOFFSET=40 ,YOFFSET=10 ,SCR_XSIZE=400 ,SCR_YSIZE=170  $
      ,/BUTTON_EVENTS)

  
  WID_DRAW_Profile = Widget_Draw(WID_BASE_0, UNAME='WID_DRAW_Profile'  $
      ,FRAME=1 ,XOFFSET=480 ,YOFFSET=10 ,SCR_XSIZE=220  $
      ,SCR_YSIZE=220)

  
  WID_TEXT_ProfStart = Widget_Text(WID_BASE_0,  $
      UNAME='WID_TEXT_ProfStart' ,XOFFSET=40 ,YOFFSET=190  $
      ,SCR_XSIZE=80 ,SCR_YSIZE=20 ,/WRAP ,VALUE=[ '' ] ,XSIZE=20  $
      ,YSIZE=1)

  
  WID_TEXT_ProfEnd = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_ProfEnd'  $
      ,XOFFSET=125 ,YOFFSET=190 ,SCR_XSIZE=80 ,SCR_YSIZE=20 ,XSIZE=20  $
      ,YSIZE=1)

  
  WID_BUTTON_GENFIT = Widget_Button(WID_BASE_0,  $
      UNAME='WID_BUTTON_GENFIT' ,XOFFSET=360 ,YOFFSET=190  $
      ,SCR_XSIZE=80 ,SCR_YSIZE=20 ,/ALIGN_CENTER ,VALUE='GenFIT!')

  
  WID_TABLE_OUT = Widget_Table(WID_BASE_0, UNAME='WID_TABLE_OUT'  $
      ,FRAME=1 ,XOFFSET=40 ,YOFFSET=230 ,SCR_XSIZE=400 ,SCR_YSIZE=111  $
      ,COLUMN_LABELS=[ 'Amplitude', 'Velocity', 'FWHM Gaus' ]  $
      ,ROW_LABELS=[ '1', '2', '3', 'Cont', '' ] ,XSIZE=3 ,YSIZE=4)

  
  WID_BASE_FWHM_eq = Widget_Base(WID_BASE_0, UNAME='WID_BASE_FWHM_eq'  $
      ,XOFFSET=480 ,YOFFSET=260 ,SCR_XSIZE=60 ,SCR_YSIZE=80  $
      ,TITLE='IDL' ,COLUMN=1 ,/NONEXCLUSIVE)

  
  WID_CHKbox_FWHM1 = Widget_Button(WID_BASE_FWHM_eq,  $
      UNAME='WID_CHKbox_FWHM1' ,SCR_XSIZE=58 ,SCR_YSIZE=26  $
      ,TAB_MODE=1 ,/ALIGN_LEFT ,VALUE='1st')

  
  WID_CHKbox_FWHM2 = Widget_Button(WID_BASE_FWHM_eq,  $
      UNAME='WID_CHKbox_FWHM2' ,YOFFSET=26 ,SCR_XSIZE=58  $
      ,SCR_YSIZE=26 ,TAB_MODE=1 ,/ALIGN_LEFT ,VALUE='2nd')

  
  WID_CHKbox_FWHM3 = Widget_Button(WID_BASE_FWHM_eq,  $
      UNAME='WID_CHKbox_FWHM3' ,YOFFSET=52 ,SCR_XSIZE=58  $
      ,SCR_YSIZE=26 ,TAB_MODE=1 ,/ALIGN_LEFT ,VALUE='3rd')

  
  WID_DROPLIST_N_Lines = Widget_Droplist(WID_BASE_0,  $
      UNAME='WID_DROPLIST_N_Lines' ,XOFFSET=210 ,YOFFSET=190  $
      ,SCR_XSIZE=100 ,SCR_YSIZE=30 ,VALUE=[ 'AUTO N_Lines', '1', '2',  $
      '3' ])

  
  WID_LABEL_0 = Widget_Label(WID_BASE_0, UNAME='WID_LABEL_0'  $
      ,XOFFSET=480 ,YOFFSET=240 ,SCR_XSIZE=60 ,SCR_YSIZE=20  $
      ,/ALIGN_CENTER ,VALUE='FWHM EQ')

  
  WID_BASE_AMP_ratio = Widget_Base(WID_BASE_0,  $
      UNAME='WID_BASE_AMP_ratio' ,XOFFSET=560 ,YOFFSET=260  $
      ,SCR_XSIZE=50 ,SCR_YSIZE=80 ,TITLE='IDL' ,SPACE=3 ,XPAD=3  $
      ,YPAD=3)

  
  WID_TEXT_AMP_RATIO1 = Widget_Text(WID_BASE_AMP_ratio,  $
      UNAME='WID_TEXT_AMP_RATIO1' ,YOFFSET=5 ,SCR_XSIZE=25  $
      ,SCR_YSIZE=20 ,TAB_MODE=1 ,/EDITABLE ,/ALL_EVENTS ,XSIZE=20  $
      ,YSIZE=1)

  
  WID_LABEL_1 = Widget_Label(WID_BASE_AMP_ratio, UNAME='WID_LABEL_1'  $
      ,XOFFSET=25 ,YOFFSET=7 ,SCR_XSIZE=23 ,SCR_YSIZE=20 ,/ALIGN_LEFT  $
      ,VALUE='1st')

  
  WID_TEXT_AMP_RATIO2 = Widget_Text(WID_BASE_AMP_ratio,  $
      UNAME='WID_TEXT_AMP_RATIO2' ,YOFFSET=30 ,SCR_XSIZE=25  $
      ,SCR_YSIZE=20 ,TAB_MODE=1 ,/EDITABLE ,/ALL_EVENTS ,XSIZE=20  $
      ,YSIZE=1)

  
  WID_LABEL_2 = Widget_Label(WID_BASE_AMP_ratio, UNAME='WID_LABEL_2'  $
      ,XOFFSET=25 ,YOFFSET=32 ,SCR_XSIZE=23 ,SCR_YSIZE=25  $
      ,/ALIGN_LEFT ,VALUE='2nd')

  
  WID_TEXT_AMP_RATIO3 = Widget_Text(WID_BASE_AMP_ratio,  $
      UNAME='WID_TEXT_AMP_RATIO3' ,YOFFSET=56 ,SCR_XSIZE=25  $
      ,SCR_YSIZE=20 ,TAB_MODE=1 ,/EDITABLE ,XSIZE=20 ,YSIZE=1)

  
  WID_LABEL_3 = Widget_Label(WID_BASE_AMP_ratio, UNAME='WID_LABEL_3'  $
      ,XOFFSET=25 ,YOFFSET=58 ,SCR_XSIZE=23 ,SCR_YSIZE=20  $
      ,/ALIGN_LEFT ,VALUE='3rd')

  
  WID_LABEL_4 = Widget_Label(WID_BASE_0, UNAME='WID_LABEL_4'  $
      ,XOFFSET=555 ,YOFFSET=240 ,SCR_XSIZE=60 ,SCR_YSIZE=20  $
      ,/ALIGN_CENTER ,VALUE='AMP Ratio')

  
  WID_BASE_GV = Widget_Base(WID_BASE_0, UNAME='WID_BASE_GV'  $
      ,XOFFSET=620 ,YOFFSET=260 ,SCR_XSIZE=64 ,SCR_YSIZE=54  $
      ,TITLE='IDL' ,COLUMN=1 ,/GRID_LAYOUT ,/EXCLUSIVE)

  
  WID_Radio_GAUS = Widget_Button(WID_BASE_GV, UNAME='WID_Radio_GAUS'  $
      ,SCR_XSIZE=74 ,SCR_YSIZE=26  $
      ,NOTIFY_REALIZE='gengui_gaus_defaultset' ,/ALIGN_LEFT  $
      ,VALUE='Gaussian')

  
  WID_Radio_VOIGT = Widget_Button(WID_BASE_GV,  $
      UNAME='WID_Radio_VOIGT' ,YOFFSET=26 ,SCR_XSIZE=54 ,SCR_YSIZE=26  $
      ,/ALIGN_LEFT ,VALUE='Voigt')

  
  WID_TEXT_inst_vel = Widget_Text(WID_BASE_0,  $
      UNAME='WID_TEXT_inst_vel' ,XOFFSET=620 ,YOFFSET=320  $
      ,SCR_XSIZE=29 ,SCR_YSIZE=20 ,VALUE=[ '22.0' ] ,XSIZE=20  $
      ,YSIZE=1)

  
  WID_LABEL_5 = Widget_Label(WID_BASE_0, UNAME='WID_LABEL_5'  $
      ,XOFFSET=649 ,YOFFSET=323 ,SCR_XSIZE=35 ,SCR_YSIZE=20  $
      ,/ALIGN_LEFT ,VALUE='inst vel')

  
  WID_LABEL_6 = Widget_Label(WID_BASE_0, UNAME='WID_LABEL_6'  $
      ,XOFFSET=620 ,YOFFSET=240 ,SCR_XSIZE=60 ,SCR_YSIZE=18  $
      ,/ALIGN_CENTER ,VALUE='Model')

  
  WID_BASE_1 = Widget_Base(WID_BASE_0, UNAME='WID_BASE_1'  $
      ,XOFFSET=480 ,YOFFSET=346 ,TITLE='IDL' ,COLUMN=1  $
      ,/NONEXCLUSIVE)

  
  WID_POLY_CONT = Widget_Button(WID_BASE_1, UNAME='WID_POLY_CONT'  $
      ,/ALIGN_LEFT ,VALUE='Quadratic cont')

  Widget_Control, /REALIZE, WID_BASE_0

  XManager, 'WID_BASE_0', WID_BASE_0, /NO_BLOCK  

end
; 
; Empty stub procedure used for autoloading.
; 
pro gen_gui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  WID_BASE_0, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end
