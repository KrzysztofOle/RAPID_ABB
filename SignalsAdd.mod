MODULE SignalsAdd

!   PROC GetDI17(INOUT BOOL odp) 
!     odp := TestDI(di17);  
!   ENDPROC
!   PROC GetDI18(INOUT BOOL odp) 
!     odp := TestDI(di18);  
!   ENDPROC
!   PROC GetDI19(INOUT BOOL odp) 
!     odp := TestDI(di19);  
!   ENDPROC
!   PROC GetDI20(INOUT BOOL odp) 
!     odp := TestDI(di20);  
!   ENDPROC
!   PROC GetDI21(INOUT BOOL odp) 
!     odp := TestDI(di21);  
!   ENDPROC
!   PROC GetDI22(INOUT BOOL odp) 
!     odp := TestDI(di22);  
!   ENDPROC
!   PROC GetDI23(INOUT BOOL odp) 
!     odp := TestDI(di23);  
!   ENDPROC
!   PROC GetDI24(INOUT BOOL odp) 
!     odp := TestDI(di24);  
!   ENDPROC
!   PROC GetDI25(INOUT BOOL odp) 
!     odp := TestDI(di25);  
!   ENDPROC
!   PROC GetDI26(INOUT BOOL odp) 
!     odp := TestDI(di26);  
!   ENDPROC 
!   PROC GetDI27(INOUT BOOL odp) 
!     odp := TestDI(di27);  
!   ENDPROC 
!   PROC GetDI28(INOUT BOOL odp) 
!     odp := TestDI(di28);  
!   ENDPROC 
!   PROC GetDI29(INOUT BOOL odp) 
!     odp := TestDI(di29);  
!   ENDPROC 
!   PROC GetDI30(INOUT BOOL odp) 
!     odp := TestDI(di30);  
!   ENDPROC 
!   PROC GetDI31(INOUT BOOL odp) 
!     odp := TestDI(di31);  
!   ENDPROC 
!   PROC GetDI32(INOUT BOOL odp) 
!     odp := TestDI(di32);  
!   ENDPROC 
  
  ! ustawianie wyjsc

!   PROC setDO17(bool value)
!     IF value THEN 
!       Set do17;
!       RETURN;
!     ENDIF
!     Reset do17;
!   ENDPROC
!   PROC setDO18(bool value)
!     IF value THEN 
!       Set do18;
!       RETURN;
!     ENDIF
!     Reset do18;
!   ENDPROC
!   PROC setDO19(bool value)
!     IF value THEN 
!       Set do19;
!       RETURN;
!     ENDIF
!     Reset do19;
!   ENDPROC
!   PROC setDO20(bool value)
!     IF value THEN 
!       Set do20;
!       RETURN;
!     ENDIF
!     Reset do20;
!   ENDPROC
!   PROC setDO21(bool value)
!     IF value THEN 
!       Set do21;
!       RETURN;
!     ENDIF
!     Reset do21;
!   ENDPROC
!   PROC setDO22(bool value)
!     IF value THEN 
!       Set do22;
!       RETURN;
!     ENDIF
!     Reset do22;
!   ENDPROC 
!   PROC setDO23(bool value)
!     IF value THEN 
!       Set do23;
!       RETURN;
!     ENDIF
!     Reset do23;
!   ENDPROC
!   PROC setDO24(bool value)
!     IF value THEN 
!       Set do24;
!       RETURN;
!     ENDIF
!     Reset do24;
!   ENDPROC
!   PROC setDO25(bool value)
!     IF value THEN 
!       Set do25;
!       RETURN;
!     ENDIF
!     Reset do25;
!   ENDPROC 
!   PROC setDO26(bool value)
!     IF value THEN 
!       Set do26;
!       RETURN;
!     ENDIF
!     Reset do26;
!   ENDPROC 
!   PROC setDO27(bool value)
!     IF value THEN 
!       Set do27;
!       RETURN;
!     ENDIF
!     Reset do27;
!   ENDPROC
!   PROC setDO28(bool value)
!     IF value THEN 
!       Set do28;
!       RETURN;
!     ENDIF
!     Reset do28;
!   ENDPROC
!   PROC setDO29(bool value)
!     IF value THEN 
!       Set do29;
!       RETURN;
!     ENDIF
!     Reset do29;
!   ENDPROC
!   PROC setDO30(bool value)
!     IF value THEN 
!       Set do30;
!       RETURN;
!     ENDIF
!     Reset do30;
!   ENDPROC
!   PROC setDO31(bool value)
!     IF value THEN 
!       Set do31;
!       RETURN;
!     ENDIF
!     Reset do31;
!   ENDPROC
!   PROC setDO32(bool value)
!     IF value THEN 
!       Set do32;
!       RETURN;
!     ENDIF
!     Reset do32;
!   ENDPROC
  
  ! puls na wyjsciu  

!   PROC pulseDO17(num pTime)
!     PulseDO \PLength:=pTime, do17;
!   ENDPROC
!   PROC pulseDO18(num pTime)
!     PulseDO \PLength:=pTime, do18;
!   ENDPROC
!   PROC pulseDO19(num pTime)
!     PulseDO \PLength:=pTime, do19;
!   ENDPROC
!   PROC pulseDO20(num pTime)
!     PulseDO \PLength:=pTime, do20;
!   ENDPROC
!   PROC pulseDO21(num pTime)
!     PulseDO \PLength:=pTime, do21;
!   ENDPROC
!   PROC pulseDO22(num pTime)
!     PulseDO \PLength:=pTime, do22;
!   ENDPROC
!   PROC pulseDO23(num pTime)
!     PulseDO \PLength:=pTime, do23;
!   ENDPROC
!   PROC pulseDO24(num pTime)
!     PulseDO \PLength:=pTime, do24;
!   ENDPROC
!   PROC pulseDO25(num pTime)
!     PulseDO \PLength:=pTime, do25;
!   ENDPROC
!   PROC pulseDO26(num pTime)
!     PulseDO \PLength:=pTime, do26;
!   ENDPROC
!   PROC pulseDO27(num pTime)
!     PulseDO \PLength:=pTime, do27;
!   ENDPROC
!   PROC pulseDO28(num pTime)
!     PulseDO \PLength:=pTime, do28;
!   ENDPROC
!   PROC pulseDO29(num pTime)
!     PulseDO \PLength:=pTime, do29;
!   ENDPROC
!   PROC pulseDO30(num pTime)
!     PulseDO \PLength:=pTime, do30;
!   ENDPROC
!   PROC pulseDO31(num pTime)
!     PulseDO \PLength:=pTime, do31;
!   ENDPROC
!   PROC pulseDO32(num pTime)
!     PulseDO \PLength:=pTime, do32;
!   ENDPROC
     
  !szukanie Sup

!   PROC searchLSupDI17()
!     SearchL\Sup,di17,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSupDI17 ERROR</FONT><BR>";
!     RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSupDI18()
!     SearchL\Sup,di18,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSupDI18 ERROR</FONT><BR>";
!     RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSupDI19()
!     SearchL\Sup,di19,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSupDI19 ERROR</FONT><BR>";
!     RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSupDI20()
!     SearchL\Sup,di20,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSupDI20 ERROR</FONT><BR>";
!     RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSupDI21()
!     SearchL\Sup,di21,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSupDI21 ERROR</FONT><BR>";
!     RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSupDI22()
!     SearchL\Sup,di22,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSupDI22 ERROR</FONT><BR>";
!     RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSupDI23()
!     SearchL\Sup,di23,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSupDI23 ERROR</FONT><BR>";
!     RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSupDI24()
!     SearchL\Sup,di24,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSupDI24 ERROR</FONT><BR>";
!     RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSupDI25()
!     SearchL\Sup,di25,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSupDI25 ERROR</FONT><BR>";
!     RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSupDI26()
!     SearchL\Sup,di26,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSupDI26 ERROR</FONT><BR>";
!     RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSupDI27()
!     SearchL\Sup,di27,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSupDI27 ERROR</FONT><BR>";
!     RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSupDI28()
!     SearchL\Sup,di28,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSupDI28 ERROR</FONT><BR>";
!     RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSupDI29()
!     SearchL\Sup,di29,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSupDI29 ERROR</FONT><BR>";
!     RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSupDI30()
!     SearchL\Sup,di30,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSupDI30 ERROR</FONT><BR>";
!     RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSupDI31()
!     SearchL\Sup,di31,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSupDI31 ERROR</FONT><BR>";
!     RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSupDI32()
!     SearchL\Sup,di32,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSupDI32 ERROR</FONT><BR>";
!     RAISE ERR_MY_ERR;
!   ENDPROC
  
  
  !szukanie PStop (hardStop)
  ! flank is true  - reagujemy na sygnal niski (zbocze opadajace)
  ! flank is false - reagujemy na sygnal wysoki (zbocze narastajace)

     
!   PROC searchLPStopDI17()
!     SearchL\PStop,di17\Flanks:=flank,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLPStopDI17 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC    
!   PROC searchLPStopDI18()
!     SearchL\PStop,di18\Flanks:=flank,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLPStopDI18 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC    
!   PROC searchLPStopDI19()
!     SearchL\PStop,di19\Flanks:=flank,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLPStopDI19 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC    
!   PROC searchLPStopDI20()
!     SearchL\PStop,di20\Flanks:=flank,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLPStopDI20 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC    
!   PROC searchLPStopDI21()
!     SearchL\PStop,di21\Flanks:=flank,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLPStopDI21 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC    
!   PROC searchLPStopDI22()
!     SearchL\PStop,di22\Flanks:=flank,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLPStopDI22 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC    
!   PROC searchLPStopDI23()
!     SearchL\PStop,di23\Flanks:=flank,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLPStopDI23 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC    
!   PROC searchLPStopDI24()
!     SearchL\PStop,di24\Flanks:=flank,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLPStopDI24 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC    
!   PROC searchLPStopDI25()
!     SearchL\PStop,di25\Flanks:=flank,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLPStopDI25 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC    
!   PROC searchLPStopDI26()
!     SearchL\PStop,di26\Flanks:=flank,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLPStopDI26 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC    
!   PROC searchLPStopDI27()
!     SearchL\PStop,di27\Flanks:=flank,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLPStopDI27 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC    
!   PROC searchLPStopDI28()
!     SearchL\PStop,di28\Flanks:=flank,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLPStopDI28 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC    
!   PROC searchLPStopDI29()
!     SearchL\PStop,di29\Flanks:=flank,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLPStopDI29 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC    
!   PROC searchLPStopDI30()
!     SearchL\PStop,di30\Flanks:=flank,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLPStopDI30 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC    
!   PROC searchLPStopDI31()
!     SearchL\PStop,di31\Flanks:=flank,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLPStopDI31 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLPStopDI32()
!     SearchL\PStop,di32\Flanks:=flank,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLPStopDI32 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC
    
  
  !szukanie SStop (softStop)

!   PROC searchLSStopDI17()
!     SearchL\SStop,di17,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSStopDI17 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSStopDI18()
!     SearchL\SStop,di18,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSStopDI18 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSStopDI19()
!     SearchL\SStop,di19,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSStopDI19 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSStopDI20()
!     SearchL\SStop,di20,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSStopDI20 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSStopDI21()
!     SearchL\SStop,di21,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSStopDI21 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSStopDI22()
!     SearchL\SStop,di22,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSStopDI22 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;  
!   ENDPROC
!   PROC searchLSStopDI23()
!     SearchL\SStop,di23,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSStopDI23 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR; 
!   ENDPROC
!   PROC searchLSStopDI24()
!     SearchL\SStop,di24,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSStopDI24 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSStopDI25()
!     SearchL\SStop,di25,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSStopDI25 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSStopDI26()
!     SearchL\SStop,di26,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSStopDI26 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSStopDI27()
!     SearchL\SStop,di27,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSStopDI27 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR; 
!   ENDPROC
!   PROC searchLSStopDI28()
!     SearchL\SStop,di28,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSStopDI28 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;  
!   ENDPROC
!   PROC searchLSStopDI29()
!     SearchL\SStop,di29,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSStopDI29 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSStopDI30()
!     SearchL\SStop,di30,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSStopDI30 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;
!   ENDPROC
!   PROC searchLSStopDI31()
!     SearchL\SStop,di31,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSStopDI31 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR;  
!   ENDPROC
!   PROC searchLSStopDI32()
!     SearchL\SStop,di32,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
!   ERROR
!     ToFile "log.html","<FONT color=red>searchLSStopDI32 ERROR</FONT><BR>";
!     stopSuccess = FALSE;
!    !RAISE ERR_MY_ERR; 
!   ENDPROC

	! pobieranie wejsc
	PROC GetAI1(INOUT NUM odp) 
		ToFile "log.html","<FONT color=orange>GetAI1 </FONT><BR>";
		ToFile "log.html","<FONT color=red>not supported yet</FONT><BR>";
		! not supported yet
	ENDPROC 
	PROC GetAI2(INOUT NUM odp) 
		ToFile "log.html","<FONT color=orange>GetAI2 </FONT><BR>";
		ToFile "log.html","<FONT color=red>not supported yet</FONT><BR>";
	ENDPROC 
	PROC GetAI3(INOUT NUM odp) 
		ToFile "log.html","<FONT color=orange>GetAI3 </FONT><BR>";
		ToFile "log.html","<FONT color=red>not supported yet</FONT><BR>";
	ENDPROC 
	PROC GetAI4(INOUT NUM odp) 
		ToFile "log.html","<FONT color=orange>GetAI4 </FONT><BR>";
		ToFile "log.html","<FONT color=red>not supported yet</FONT><BR>";
	ENDPROC 
	PROC GetAI5(INOUT NUM odp) 
		ToFile "log.html","<FONT color=orange>GetAI5 </FONT><BR>";
		ToFile "log.html","<FONT color=red>not supported yet</FONT><BR>";
	ENDPROC 
	PROC GetAI6(INOUT NUM odp) 
		ToFile "log.html","<FONT color=orange>GetAI6 </FONT><BR>";
		ToFile "log.html","<FONT color=red>not supported yet</FONT><BR>";
	ENDPROC 
	PROC GetAI7(INOUT NUM odp) 
		ToFile "log.html","<FONT color=orange>GetAI7 </FONT><BR>";
		ToFile "log.html","<FONT color=red>not supported yet</FONT><BR>";
	ENDPROC 
	PROC GetAI8(INOUT NUM odp) 
		ToFile "log.html","<FONT color=orange>GetAI8 </FONT><BR>";
		ToFile "log.html","<FONT color=red>not supported yet</FONT><BR>";
	ENDPROC
    
	PROC SetAI1(NUM value) 
		ToFile "log.html","<FONT color=orange>SetAI1 </FONT><BR>";
		ToFile "log.html","<FONT color=red>not supported yet</FONT><BR>";
	ENDPROC 
	PROC SetAI2(NUM value) 
		ToFile "log.html","<FONT color=orange>SetAI2 </FONT><BR>";
		ToFile "log.html","<FONT color=red>not supported yet</FONT><BR>";
	ENDPROC 
	PROC SetAI3(NUM value) 
		ToFile "log.html","<FONT color=orange>SetAI3 </FONT><BR>";
		ToFile "log.html","<FONT color=red>not supported yet</FONT><BR>";
	ENDPROC 
	PROC SetAI4(NUM value) 
		ToFile "log.html","<FONT color=orange>SetAI4 </FONT><BR>";
		ToFile "log.html","<FONT color=red>not supported yet</FONT><BR>";
	ENDPROC 
	PROC SetAI5(NUM value) 
		ToFile "log.html","<FONT color=orange>SetAI5 </FONT><BR>";
		ToFile "log.html","<FONT color=red>not supported yet</FONT><BR>";
	ENDPROC 
	PROC SetAI6(NUM value) 
		ToFile "log.html","<FONT color=orange>SetAI6 </FONT><BR>";
		ToFile "log.html","<FONT color=red>not supported yet</FONT><BR>";
	ENDPROC 
	PROC SetAI7(NUM value) 
		ToFile "log.html","<FONT color=orange>SetAI7 </FONT><BR>";
		ToFile "log.html","<FONT color=red>not supported yet</FONT><BR>";
	ENDPROC 
	PROC SetAI8(NUM value) 
		ToFile "log.html","<FONT color=orange>SetAI8 </FONT><BR>";
		ToFile "log.html","<FONT color=red>not supported yet</FONT><BR>";
	ENDPROC
      
ENDMODULE
