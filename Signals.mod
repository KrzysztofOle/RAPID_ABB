MODULE Signals
	
	! ustawianie wyjsc
	PROC setDO1(bool value)
		IF value THEN 
			Set do1;
			RETURN;
		ENDIF
		Reset do1;
	ENDPROC
	PROC setDO2(bool value)
		IF value THEN 
			Set do2;
			RETURN;
		ENDIF
		Reset do2;
	ENDPROC
	PROC setDO3(bool value)
		IF value THEN 
			Set do3;
			RETURN;
		ENDIF
		Reset do3;
	ENDPROC
	PROC setDO4(bool value)
		IF value THEN 
			Set do4;
			RETURN;
		ENDIF
		Reset do4;
	ENDPROC
	PROC setDO5(bool value)
		IF value THEN 
			Set do5;
			RETURN;
		ENDIF
		Reset do5;
	ENDPROC
	PROC setDO6(bool value)
		IF value THEN 
			Set do6;
			RETURN;
		ENDIF
		Reset do6;
	ENDPROC
	PROC setDO7(bool value)
		IF value THEN 
			Set do7;
			RETURN;
		ENDIF
		Reset do7;
	ENDPROC
	PROC setDO8(bool value)
		IF value THEN 
			Set do8;
			RETURN;
		ENDIF
		Reset do8;
	ENDPROC
	PROC setDO9(bool value)
		IF value THEN 
			Set do9;
			RETURN;
		ENDIF
		Reset do9;
	ENDPROC
	PROC setDO10(bool value)
		IF value THEN 
			Set do10;
			RETURN;
		ENDIF
		Reset do10;
	ENDPROC
	PROC setDO11(bool value)
		IF value THEN 
			Set do11;
			RETURN;
		ENDIF
		Reset do11;
	ENDPROC
	PROC setDO12(bool value)
		IF value THEN 
			Set do12;
			RETURN;
		ENDIF
		Reset do12;
	ENDPROC 
	PROC setDO13(bool value)
		IF value THEN 
			Set do13;
			RETURN;
		ENDIF
		Reset do13;
	ENDPROC
	PROC setDO14(bool value)
		IF value THEN 
			Set do14;
			RETURN;
		ENDIF
		Reset do14;
	ENDPROC
	PROC setDO15(bool value)
		IF value THEN 
			Set do15;
			RETURN;
		ENDIF
		Reset do15;
	ENDPROC
	PROC setDO16(bool value)
		IF value THEN 
			Set do16;
			RETURN;
		ENDIF
		Reset do16;
	ENDPROC
	
	! odczyt wejsc
	PROC GetDI1(INOUT BOOL odp) 
		odp := TestDI(di1);  
	ENDPROC
	PROC GetDI2(INOUT BOOL odp) 
		odp := TestDI(di2);  
	ENDPROC
	PROC GetDI3(INOUT BOOL odp) 
		odp := TestDI(di3);  
	ENDPROC
	PROC GetDI4(INOUT BOOL odp) 
		odp := TestDI(di4);  
	ENDPROC
	PROC GetDI5(INOUT BOOL odp) 
		odp := TestDI(di5);  
	ENDPROC
	PROC GetDI6(INOUT BOOL odp) 
		odp := TestDI(di6);  
	ENDPROC
	PROC GetDI7(INOUT BOOL odp) 
		odp := TestDI(di7);  
	ENDPROC
	PROC GetDI8(INOUT BOOL odp) 
		odp := TestDI(di8);  
	ENDPROC
	PROC GetDI9(INOUT BOOL odp) 
		odp := TestDI(di9);  
	ENDPROC
	PROC GetDI10(INOUT BOOL odp) 
		odp := TestDI(di10);  
	ENDPROC
	PROC GetDI11(INOUT BOOL odp) 
		odp := TestDI(di11);  
	ENDPROC
	PROC GetDI12(INOUT BOOL odp) 
		odp := TestDI(di12);  
	ENDPROC
	PROC GetDI13(INOUT BOOL odp) 
		odp := TestDI(di13);  
	ENDPROC
	PROC GetDI14(INOUT BOOL odp) 
		odp := TestDI(di14);  
	ENDPROC
	PROC GetDI15(INOUT BOOL odp) 
		odp := TestDI(di15);  
	ENDPROC
	PROC GetDI16(INOUT BOOL odp) 
		odp := TestDI(di16);  
	ENDPROC
	
	! puls na wyjsciu  
	PROC pulseDO1(num pTime)
		PulseDO \PLength:=pTime, do1;
	ENDPROC  
	PROC pulseDO2(num pTime)
		PulseDO \PLength:=pTime, do2;
	ENDPROC  
	PROC pulseDO3(num pTime)
		PulseDO \PLength:=pTime, do3;
	ENDPROC  
	PROC pulseDO4(num pTime)
		PulseDO \PLength:=pTime, do4;
	ENDPROC  
	PROC pulseDO5(num pTime)
		PulseDO \PLength:=pTime, do5;
	ENDPROC  
	PROC pulseDO6(num pTime)
		PulseDO \PLength:=pTime, do6;
	ENDPROC  
	PROC pulseDO7(num pTime)
		PulseDO \PLength:=pTime, do7;
	ENDPROC  
	PROC pulseDO8(num pTime)
		PulseDO \PLength:=pTime, do8;
	ENDPROC  
	PROC pulseDO9(num pTime)
		PulseDO \PLength:=pTime, do9;
	ENDPROC
	PROC pulseDO10(num pTime)
		PulseDO \PLength:=pTime, do10;
	ENDPROC
	PROC pulseDO11(num pTime)
		PulseDO \PLength:=pTime, do11;
	ENDPROC
	PROC pulseDO12(num pTime)
		PulseDO \PLength:=pTime, do12;
	ENDPROC
	PROC pulseDO13(num pTime)
		PulseDO \PLength:=pTime, do13;
	ENDPROC
	PROC pulseDO14(num pTime)
	PulseDO \PLength:=pTime, do14;
	ENDPROC
	PROC pulseDO15(num pTime)
		PulseDO \PLength:=pTime, do15;
	ENDPROC
	PROC pulseDO16(num pTime)
		PulseDO \PLength:=pTime, do16;
	ENDPROC
	
	!szukanie Sup
	PROC searchLSupDI1(BOOL flank)
		IF flank THEN
			SearchL di1\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ELSE
			SearchL di1,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		IF ERRNO = ERR_WHLSEARCH THEN
			TPWrite "No signal detection or more than one signal detection on SearchL"; 
			stopSuccess := FALSE;
			TRYNEXT;
		ELSEIF ERRNO = ERR_SIGSUPSEARCH  THEN
			TPWrite "Bad signal state on SearchL start";  
		ENDIF
		ToFile "log.html","<FONT color=red>searchLSupDI1 ERROR</FONT><BR>";
		RAISE;
	ENDPROC
	PROC searchLSupDI2(BOOL flank)
		IF flank THEN     
			TPWrite "SearchL di2-Flanks";
			SearchL di2\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ELSE
			TPWrite "SearchL di2";
			SearchL di2,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		IF ERRNO = ERR_WHLSEARCH THEN
			TPWrite "No signal detection or more than one signal detection on SearchL"; 
			stopSuccess := FALSE;
			TRYNEXT;
		ELSEIF ERRNO = ERR_SIGSUPSEARCH  THEN
			TPWrite "Bad signal state on SearchL start";  
		ENDIF
		ToFile "log.html","<FONT color=red>searchLSupDI1 ERROR</FONT><BR>";
		RAISE;
	ENDPROC
	PROC searchLSupDI3(BOOL flank)
		IF flank THEN
			SearchL\Sup,di3\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ELSE
			SearchL\Sup,di3,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		IF ERRNO = ERR_WHLSEARCH THEN
			TPWrite "No signal detection or more than one signal detection on SearchL"; 
			stopSuccess := FALSE;
			TRYNEXT;
		ELSEIF ERRNO = ERR_SIGSUPSEARCH  THEN
			TPWrite "Bad signal state on SearchL start";  
		ENDIF
		ToFile "log.html","<FONT color=red>searchLSupDI1 ERROR</FONT><BR>";
		RAISE;
	ENDPROC
	PROC searchLSupDI4(BOOL flank)
		IF flank THEN
			SearchL\Sup,di4\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ELSE
			SearchL\Sup,di4,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSupDI4 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSupDI5(BOOL flank)
		IF flank THEN
			SearchL\Sup,di5\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ELSE
			SearchL\Sup,di5,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSupDI5 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSupDI6(BOOL flank)
		IF flank THEN
			SearchL\Sup,di6\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ELSE
			SearchL\Sup,di6,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSupDI6 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSupDI7(BOOL flank)
		IF flank THEN
			SearchL\Sup,di7\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ELSE
			SearchL\Sup,di7,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSupDI7 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSupDI8(BOOL flank)
		IF flank THEN
			SearchL\Sup,di8\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ELSE
			SearchL\Sup,di8,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSupDI8 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC 
	PROC searchLSupDI9(BOOL flank)
		IF flank THEN
			SearchL\Sup,di9\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ELSE
			SearchL\Sup,di9,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSupDI9 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC   
	PROC searchLSupDI10(BOOL flank)
		IF flank THEN
			SearchL\Sup,di10\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ELSE
			SearchL\Sup,di10,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSupDI10 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSupDI11(BOOL flank)
		IF flank THEN
			SearchL\Sup,di11\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ELSE
			SearchL\Sup,di11,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSupDI11 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSupDI12(BOOL flank)
		IF flank THEN
			SearchL\Sup,di12\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ELSE
			SearchL\Sup,di12,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSupDI12 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSupDI13(BOOL flank)
		IF flank THEN
			SearchL\Sup,di13\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ELSE
			SearchL\Sup,di13,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSupDI13 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSupDI14(BOOL flank)
		IF flank THEN
			SearchL\Sup,di14\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ELSE
			SearchL\Sup,di14,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSupDI14 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSupDI15(BOOL flank)
		IF flank THEN
			SearchL\Sup,di15\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ELSE
			SearchL\Sup,di15,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSupDI15 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSupDI16(BOOL flank)
		IF flank THEN
			SearchL\Sup,di16\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ELSE
			SearchL\Sup,di16,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSupDI16 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	
	!szukanie PStop (hardStop)
	! flank is true  - reagujemy na sygnal niski (zbocze opadajace)
	! flank is false - reagujemy na sygnal wysoki (zbocze narastajace)
	PROC searchLPStopDI1(BOOL flank)
		IF flank THEN
			SearchL\PStop,di1\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\PStop,di1,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLPStopDI1 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLPStopDI2(BOOL flank)
		IF flank THEN
			SearchL\PStop,di2\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\PStop,di2,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLPStopDI2 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR; 
		TRYNEXT;
	ENDPROC
	PROC searchLPStopDI3(BOOL flank)
		IF flank THEN
			SearchL\PStop,di3\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\PStop,di3,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLPStopDI3 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLPStopDI4(BOOL flank)
		IF flank THEN
			SearchL\PStop,di4\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\PStop,di4,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLPStopDI4 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLPStopDI5(BOOL flank)
		IF flank THEN
			SearchL\PStop,di5\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\PStop,di5,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLPStopDI5 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLPStopDI6(BOOL flank)
		IF flank THEN
			SearchL\PStop,di6\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\PStop,di6,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLPStopDI6 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLPStopDI7(BOOL flank)
		IF flank THEN
			SearchL\PStop,di7\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\PStop,di7,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLPStopDI7 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLPStopDI8(BOOL flank)
		IF flank THEN
			SearchL\PStop,di8\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\PStop,di8,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLPStopDI8 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLPStopDI9(BOOL flank)
		IF flank THEN
			SearchL\PStop,di9\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\PStop,di9,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLPStopDI9 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC    
	PROC searchLPStopDI10(BOOL flank)
		IF flank THEN
			SearchL\PStop,di10\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\PStop,di10,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLPStopDI10 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC    
	PROC searchLPStopDI11(BOOL flank)
		IF flank THEN
			SearchL\PStop,di11\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\PStop,di11,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLPStopDI11 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC    
	PROC searchLPStopDI12(BOOL flank)
		IF flank THEN
			SearchL\PStop,di12\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\PStop,di12,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLPStopDI12 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC    
	PROC searchLPStopDI13(BOOL flank)
		IF flank THEN
			SearchL\PStop,di13\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\PStop,di13,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLPStopDI13 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC    
	PROC searchLPStopDI14(BOOL flank)
		IF flank THEN
			SearchL\PStop,di14\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\PStop,di14,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLPStopDI14 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC    
	PROC searchLPStopDI15(BOOL flank)
		IF flank THEN
			SearchL\PStop,di15\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\PStop,di15,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLPStopDI15 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC    
	PROC searchLPStopDI16(BOOL flank)
		IF flank THEN
			SearchL\PStop,di6\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\PStop,di6,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLPStopDI16 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC    
	
	!szukanie SStop (softStop)
	PROC searchLSStopDI1(BOOL flank)
		IF flank THEN
			SearchL\SStop,di1\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\SStop,di1,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSStopDI1 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSStopDI2(BOOL flank)
		IF flank THEN
			SearchL\SStop,di2\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\SStop,di2,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSStopDI2 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSStopDI3(BOOL flank)
		IF flank THEN
			SearchL\SStop,di3\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\SStop,di3,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSStopDI3 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSStopDI4(BOOL flank)
		IF flank THEN
			SearchL\SStop,di4\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\SStop,di4,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSStopDI4 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSStopDI5(BOOL flank)
		IF flank THEN
			SearchL\SStop,di5\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\SStop,di5,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSStopDI5 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSStopDI6(BOOL flank)
		IF flank THEN
			SearchL\SStop,di6\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\SStop,di6,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSStopDI6 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSStopDI7(BOOL flank)
		IF flank THEN
			SearchL\SStop,di7\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\SStop,di7,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSStopDI7 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSStopDI8(BOOL flank)
		IF flank THEN
			SearchL\SStop,di8\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\SStop,di8,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSStopDI8 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSStopDI9(BOOL flank)
		IF flank THEN
			SearchL\SStop,di9\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\SStop,di9,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSStopDI9 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSStopDI10(BOOL flank)
		IF flank THEN
			SearchL\SStop,di10\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\SStop,di10,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSStopDI10 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSStopDI11(BOOL flank)
		IF flank THEN
			SearchL\SStop,di11\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\SStop,di11,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSStopDI11 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSStopDI12(BOOL flank)
		IF flank THEN
			SearchL\SStop,di12\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\SStop,di12,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSStopDI12 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSStopDI13(BOOL flank)
		IF flank THEN
			SearchL\SStop,di13\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\SStop,di13,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSStopDI13 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSStopDI14(BOOL flank)
		IF flank THEN
			SearchL\SStop,di14\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\SStop,di14,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSStopDI14 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSStopDI15(BOOL flank)
		IF flank THEN
			SearchL\SStop,di15\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\SStop,di15,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSStopDI15 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	PROC searchLSStopDI16(BOOL flank)
		IF flank THEN
			SearchL\SStop,di16\Flanks,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;  
		ELSE
			SearchL\SStop,di16,aRobTarget,cuRobTarget,cuSpeed,cuTool\WObj:=cuWobj;
		ENDIF
	ERROR
		ToFile "log.html","<FONT color=red>searchLSStopDI16 ERROR</FONT><BR>";
		stopSuccess := FALSE;
		!RAISE ERR_MY_ERR;
		TRYNEXT;
	ENDPROC
	
	PROC WaitHDI1(NUM maxTime) 
		WaitDI DI1,high\MaxTime:=maxTime;
	ERROR
		ToFile "log.html","<FONT color=red> przypisanie</FONT><BR>";
		RAISE ERRNO;
	ENDPROC
	PROC WaitHDI2(NUM maxTime)   
		WaitDI DI2,high\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC 
	PROC WaitHDI3(NUM maxTime) 
		WaitDI DI3,high\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC   
	PROC WaitHDI4(NUM maxTime) 
		WaitDI DI4,high\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC  
	PROC WaitHDI5(NUM maxTime) 
		WaitDI DI5,high\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC   
	PROC WaitHDI6(NUM maxTime) 
		WaitDI DI6,high\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC   
	PROC WaitHDI7(NUM maxTime) 
		WaitDI DI7,high\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC   
	PROC WaitHDI8(NUM maxTime) 
		WaitDI DI8,high\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC   
	PROC WaitHDI9(NUM maxTime) 
		WaitDI DI9,high\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC   
	PROC WaitHDI10(NUM maxTime) 
		WaitDI DI10,high\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC  
	PROC WaitHDI11(NUM maxTime)
		ToFile "log.html","<FONT color=red> waitHDI11</FONT><BR>"; 
		WaitDI DI11,high\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC   
	PROC WaitHDI12(NUM maxTime) 
		ToFile "log.html","<FONT color=red> waitHDI12</FONT><BR>";      
		WaitDI DI12,high\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC  
	PROC WaitHDI13(NUM maxTime)
		ToFile "log.html","<FONT color=red> waitHDI13</FONT><BR>"; 
		WaitDI DI13,high\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC  
	PROC WaitHDI14(NUM maxTime) 
		WaitDI DI14,high\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC  
	PROC WaitHDI15(NUM maxTime) 
		WaitDI DI15,high\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC      
	PROC WaitHDI16(NUM maxTime) 
		WaitDI DI16,high\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC 
	!
	PROC WaitLDI1(NUM maxTime) 
		WaitDI DI1,low\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC    
	PROC WaitLDI2(NUM maxTime) 
		WaitDI DI2,low\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC 
	PROC WaitLDI3(NUM maxTime) 
		WaitDI DI3,low\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC   
	PROC WaitLDI4(NUM maxTime) 
		WaitDI DI4,low\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC  
	PROC WaitLDI5(NUM maxTime) 
		WaitDI DI5,low\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC   
	PROC WaitLDI6(NUM maxTime) 
		WaitDI DI6,low\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC   
	PROC WaitLDI7(NUM maxTime) 
		WaitDI DI7,low\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC   
	PROC WaitLDI8(NUM maxTime) 
		WaitDI DI8,low\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC   
	PROC WaitLDI9(NUM maxTime) 
		WaitDI DI9,low\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC   
	PROC WaitLDI10(NUM maxTime) 
		WaitDI DI10,low\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC  
	PROC WaitLDI11(NUM maxTime) 
		WaitDI DI11,low\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC   
	PROC WaitLDI12(NUM maxTime)
		WaitDI DI12,low\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC  
	PROC WaitLDI13(NUM maxTime) 
		WaitDI DI13,low\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC  
	PROC WaitLDI14(NUM maxTime) 
		WaitDI DI14,low\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC  
	PROC WaitLDI15(NUM maxTime) 
		WaitDI DI15,low\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;  
	ENDPROC
	PROC WaitLDI16(NUM maxTime) 
		WaitDI DI16,low\MaxTime:=maxTime;
	ERROR
		RAISE ERRNO;
	ENDPROC

ENDMODULE
