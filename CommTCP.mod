MODULE CommTCP
	!-------------------------------------------------------------------------------
	!    VAR socketdev client_socket;
	!    VAR string receive_string;
	!    PROC client_messaging()
	! Create and connect the socket in error handlers
	!    SocketSend client_socket \Str := "Hello server";
	!    SocketReceive client_socket \Str := receive_string;
	!    SocketClose client_socket;
	!    ERROR
	!    IF ERRNO=ERR_SOCK_TIMEOUT THEN
	!    RETRY;
	!   ELSEIF ERRNO=ERR_SOCK_CLOSED THEN
	!    client_recover;
	!    RETRY;
	!    ELSE
	! No error recovery handling
	!    ENDIF
	!    ENDPROC
	!    PROC client_recover()
	!    SocketClose client_socket;
	!    SocketCreate client_socket;
	!    SocketConnect client_socket, "192.168.0.2", 1025;
	!    ERROR
	!    IF ERRNO=ERR_SOCK_TIMEOUT THEN
	!    RETRY;
	PROC testS()
		VAR socketstatus status;
		status := SocketGetStatus( Tcp_servSocket );
		IF status = SOCKET_CREATED THEN
			TPWrite "Serv SocketCreate";
		ELSEIF status = SOCKET_CLOSED THEN
			TPWrite "Serv SocketClose";
		ELSEIF status = SOCKET_BOUND THEN
			TPWrite "Serv SocketBind";
		ELSEIF status = SOCKET_LISTENING THEN
			TPWrite "Serv SocketListen or SocketAccept";
		ELSEIF status = SOCKET_CONNECTED THEN
			TPWrite "Serv SocketConnect, SocketReceive";
		ELSE
			TPWrite "Serv Unknown status";
		ENDIF
		return;
	ENDPROC
	
	PROC testC()
		VAR socketstatus status;
		status := SocketGetStatus( Tcp_SocketID );
		IF status = SOCKET_CREATED THEN
			TPWrite "Clt SocketCreate";
		ELSEIF status = SOCKET_CLOSED THEN
			TPWrite "Clt SocketClose";
		ELSEIF status = SOCKET_BOUND THEN
			TPWrite "Clt SocketBind";
		ELSEIF status = SOCKET_LISTENING THEN
			TPWrite "Clt SocketListen or SocketAccept";
		ELSEIF status = SOCKET_CONNECTED THEN
			TPWrite "Clt SocketConnect, SocketReceive";
		ELSE
			TPWrite "Clt Unknown status";
		ENDIF
		return;
	ENDPROC 
	!-------------------------------------------------------------------------------main
	PROC runTCP()
	!warunki poczatkowe
		ClearRawBytes Tcp_OutDataOrder;
		PackRawBytes Tcp_headOrder, Tcp_OutDataOrder, 1 \ASCII;      !tablica potwierdzenia z watku glownego
		
		ClearRawBytes Tcp_OutDataCom;
		PackRawBytes Tcp_headCom, Tcp_OutDataCom, 1 \ASCII;        !tablica potwierdzenia z watku komunikacji
		
	!create server
		SocketCreate Tcp_servSocket;
		SocketBind Tcp_servSocket, Tcp_servIP, Tcp_Port;
		
	!open port
		listenTCP;
	!TCP client accept
		acceptTCP;
		
	!Petla odbioru i nadawania
		WHILE Tcp_koniec=FALSE DO
			!recive data
			recvTCP;
		ENDWHILE
	!close socet
		closeTCP;
		endTCP;
		
	!Finish
		TPwrite "... end program";
		RETURN;
	ENDPROC
	!-----------------------------------------------------------------------------------------------------------------recvLast3TCP
	PROC testRecvTCP()
	!test dlugosci paczki i jej poprawnosci
		VAR NUM size := 0;
		VAR STRING labEnd;
		size := Tcp_InPosRecv+6;
		IF size > RawBytesLen(Tcp_InDataRecv) THEN
			TPwrite("ERR testSizeTCP za maly ciag");
			sendTextTCP("ERR  WRONG testRecvTCP");
			RETURN;
		ENDIF
		UnpackRawBytes Tcp_InDataRecv, Tcp_InPosRecv + 4, size \IntX := INT;
		IF Tcp_InPosRecv+size < RawBytesLen(Tcp_InDataRecv)+1 THEN
			ClearRawBytes Tcp_InDataRecv;
			TPwrite("ERR testSizeTCP za maly ciag 2");
			sendTextTCP("ERR WRONG testRecvTCP 2");
			RETURN;
			!STOP;
		ENDIF
	!    TPwrite " size: "\NUM:= size;
	!    konca paczki ENR,
		UnpackRawBytes Tcp_InDataRecv, Tcp_InPosRecv+size-3, labEnd \ASCII:=3;
	!    TPwrite " end: " + labEnd;
		IF Tcp_InActive=0 THEN
			Tcp_InSizeOrder := Tcp_InSizeOrder + 1;
			ClearRawBytes Tcp_InDataOrder{Tcp_InSizeOrder};
			CopyRawBytes Tcp_InDataRecv, Tcp_InPosRecv+6, Tcp_InDataOrder{Tcp_InSizeOrder}, 1, \NoOfBytes :=size-6;    !kopiuj reszete
	!        TPwrite " size Tcp_InSizeOrder" \NUM:= Tcp_InSizeOrder;
	!        TPwrite " size inDataOrder" \NUM:= RawBytesLen(Tcp_InDataOrder{Tcp_InSizeOrder});
			IF labEnd="ENR" THEN
				sendTextTCP("DCF");
				runOrder;
				!replyOrderTCP;
				RETURN;
			ELSEIF labEnd="ENP" THEN
				sendTextTCP("DCP");
			ELSE
				sendTextTCP("ERR bad label END: " + labEnd);
			ENDIF
		ELSE
		
		ENDIF
		RETURN;
	ENDPROC
	!-----------------------------------------------------------------------------------------------recvTCP
	PROC recvTCP()
	!odbieranie rozkazow od PC
		VAR NUM countRecv := 1;
		VAR STRING Label := "000";
		Tcp_InPosRecv := 1;
	recv:
		SocketReceive Tcp_SocketID \RawData:=Tcp_InDataRecv \Time:= Tcp_Timeout;  !odebranie paczki
		Tcp_CntTimeout := 0;        !ilosc cykli po ktorym reset komunikacji
		countRecv := RawBytesLen(Tcp_InDataRecv);
	!obsluga paczek
	check:
		IF countRecv < Tcp_InPosRecv THEN                !pusta paczka to przerwij
			RETURN;
		ENDIF
		
		UnpackRawBytes Tcp_InDataRecv, Tcp_InPosRecv, Label \ASCII:=3;
	!    TPwrite Label;
		IF StrMatch(Label, 1, "WDG")<3 THEN
			Tcp_Wdg := TRUE;                !WDG wlacza wotchdoga
			sendTextTCP("WDG");
			Tcp_InPosRecv := Tcp_InPosRecv + 3;
			GOTO check;                !gdy sklejone paczeki
		ELSEIF StrMatch(Label, 1, "R3C")<3 THEN
			Tcp_InActive := 1;                                          !wlacz aktywny bufor
			ClearRawBytes Tcp_OutDataCom;
			CopyRawBytes Tcp_InDataRecv, Tcp_InPosRecv, Tcp_OutDataCom, 1, \NoOfBytes:=4;    !przepisz znacznik rozkazu
			Tcp_InSizeCom := 1;
			Tcp_InNumCom :=  1;
			Tcp_InPosCom :=  1;
	!        IF testSizeTCP() THEN
	!            ClearRawBytes Tcp_InDataCom{1};
	!            CopyRawBytes Tcp_InDataRecv, Tcp_InPosRecv+6, Tcp_InDataCom{1}, 1;    !kopiuj reszete
	!        ENDIF
		
		ELSEIF StrMatch(Label, 1, "R3D")<3 THEN
			IF Tcp_workorder=TRUE THEN
				TPwrite "ERROR recvTCP order still work";
				sendTextTCP("ERR recvTCP order still work");
				RETURN;
			ENDIF
			Tcp_InActive := 0;                                          !wlacz aktywny bufor
			ClearRawBytes Tcp_OutDataOrder;
			CopyRawBytes Tcp_InDataRecv, Tcp_InPosRecv, Tcp_OutDataOrder, 1, \NoOfBytes:=4;    !przepisz znacznik rozkazu
			Tcp_InSizeOrder := 0;
			Tcp_InNumOrder := 1;
			Tcp_InPosOrder := 1;
			testRecvTCP;
		ELSEIF StrMatch(Label, 1, "R3P")<3 THEN
			testRecvTCP;
		ELSEIF StrMatch(Label, 1, "FIN")<3 THEN
			IF Tcp_workorder=FALSE THEN                    !odeslij odpowiedz
				replyOrderTCP;
			ELSE
				sendTextTCP("DCF");
			ENDIF
		ELSEIF StrMatch(Label, 1, "SET")<3 THEN
			sendTextTCP("SET");
		ELSEIF StrMatch(Label, 1, "CON")<3 THEN
			sendTextTCP("CON");
		ELSEIF StrMatch(Label, 1, "ERR")<3 THEN
	!        mainTListErr;
		ELSEIF StrMatch(Label, 1, "DIS")<3 THEN            !rozlaczenie szczegolnie dla sterownika D
			TPWrite "Odebrano polecenie DISconect";
			Tcp_workorder := FALSE;
			ClearRawBytes Tcp_OutDataOrder;
			PackRawBytes Tcp_headOrder, Tcp_OutDataOrder, 1 \ASCII;      !tablica potwierdzenia z watku glownego
			ClearRawBytes Tcp_OutDataCom;
			PackRawBytes Tcp_headCom, Tcp_OutDataCom, 1 \ASCII;        !tablica potwierdzenia z watku komunikacji
			
			closeTCP;
			acceptTCP;
		ELSE
			IF  Tcp_WaitPackEnd=TRUE THEN
				recvLast3TCP;
			ELSE
			sendTextTCP("DAF");             !niezrozumiany rozkaz jest odsylany
			WaitTime 0.2;
			reSendRecvTCP;
			ENDIF
		ENDIF
	!-------------------------------------ERR
	ERROR
		errorRecvTCP;
		RETURN;
	ENDPROC
	!-----------------------------------------------------------------------------------------------------------------reSendRecvTCP
	PROC reSendRecvTCP()
	!odeslanie paczki przychodzacej na TCP
		SocketSend Tcp_SocketID \RawData:= Tcp_InDataRecv; ! \NoOfBytes:=3;
	ERROR
		TPwrite "socketSend ERR: " \num:=ERRNO;
		closeTCP;
		acceptTCP;
		RETURN;
	ENDPROC
	!-----------------------------------------------------------------------------------------------------------------sendTextTCP
	PROC sendTextTCP(STRING sendString)
	!wysylanie stringa na TCP
		SocketSend Tcp_SocketID \Str:= sendString;
	ERROR
		TPwrite "socketSend ERR: " \num:=ERRNO;
		closeTCP;
		acceptTCP;
		RETURN;
	ENDPROC
	!-----------------------------------------------------------------------------------------------------------------replyOrderTCP
	PROC replyOrderTCP()
	!wysylanie odpowiedzi rozkazu order
		SocketSend Tcp_SocketID \RawData:= Tcp_OutDataOrder;
	ERROR
		TPwrite "socketSend ERR: " \num:=ERRNO;
		closeTCP;
		acceptTCP;
		RETURN;
	ENDPROC
	!-----------------------------------------------------------------------------------------------------------------replyComTCP
	PROC replyComTCP()
	!wysylanie odpowiedzi rozkazu order
		SocketSend Tcp_SocketID\RawData:= Tcp_OutDataCom;
	ERROR
		TPwrite "socketSend ERR: " \num:=ERRNO;
		closeTCP;
		acceptTCP;
		RETURN;
	ENDPROC
	!-----------------------------------------------------------------------------------------------------------------sendOrderTCP
	PROC sendOrderTCP()
	!odeslanie rozkazu order w tagu INF - testy
		sendTextTCP("INF ");
		SocketSend Tcp_SocketID \RawData:= Tcp_InDataOrder{Tcp_InSizeOrder};
		sendTextTCP("INFEND");
		RETURN;
	ENDPROC
	!-----------------------------------------------------------------------------------------------------------------sendComTCP
	PROC sendComTCP()
	!odeslanie rozkazu com w tagu INF - testy
	!    sendTextTCP("INF ");
	!    FOR .num = 1 TO Tcp_InSizeCom
	!        CALL sendTextTCP($Tcp_InDataCom[.num])
	!    END
	!    CALL sendTextTCP("INFEND")
		RETURN;
	ENDPROC
	!-----------------------------------------------------------------------------------------------------------------listenTCP
	PROC listenTCP()
		SocketListen Tcp_servSocket;
		IF Tcp_koniec THEN
			closeTCP;
			STOP;
		ENDIF
		TPwrite "open port: " \num:= Tcp_Port;
	ERROR
		IF Tcp_koniec THEN
			STOP;
		ENDIF
		RETRY;
		RETURN;
	ENDPROC
	!-----------------------------------------------------------------------------------------------------------------acceptInTCPIn
	FUNC BOOL acceptInTCPIn()
		VAR NUM fKey;
		VAR STRING fString;
		VAR STRING fString2;
		VAR errnum errvarFK;
		
		SocketAccept Tcp_servSocket, Tcp_SocketID  \ClientAddress:=Tcp_IP \Time:= 2;
		! Sprawdzamy czy mozemy sie polaczyc z robotem
		IF NOT (Tcp_IP=PcIPAddress) THEN
			fString  := "Komputer PC: " + Tcp_IP + " probuje przejac kontrole nad robotem!";
			fString2 := "Zezwolic na polaczenie z " + Tcp_IP + " ?";
			TPErase;
			TPWrite fString;
			TPReadFK fKey, fString,"NO","","ONCE","","YES"\MaxTime:= 180\BreakFlag:= errvarFK;
			IF fKey = 1 OR errvarFK = ERR_TP_MAXTIME THEN
				! nie potwierdzono polaczenia
				TPWrite "CONNECTION IS NOT ACCEPTED!!!";
				SocketSend Tcp_SocketID \Str := "CONNECTION IS NOT ACCEPTED: Robot is assigned to: "+PcIPAddress;
				!
				WaitTime 0.5;
				returnErrorToPC 0, 0, 0;
				WaitTime 1;
				SocketClose Tcp_SocketID;
				RETURN FALSE;
			ENDIF
			IF fKey = 5 THEN
				PcIPAddress := Tcp_IP;
			ENDIF
		ENDIF
!		ToFile "log.html","<FONT color=green>polaczenie z klientem: "+Tcp_IP+"</FONT><BR>";
		!
		IF Tcp_koniec THEN
			closeTCP;
			endTCP;
			STOP;
		ENDIF
		RETURN TRUE;
	ERROR
		skipwarn;
		IF Tcp_koniec THEN
			closeTCP;
			endTCP;
			STOP;
		ENDIF
		RETURN FALSE;
	ENDFUNC
	!----------------------------------------------------------------------------------------------------------------acceptTCP
	PROC acceptTCP()
		WHILE NOT acceptInTCPIn() DO
	!        WaitTime 1;
		ENDWHILE
		RETURN;
	ENDPROC
	!-----------------------------------------------------------------------------------------------------------------closeTCP
	PROC closeTCP()
	!close socet
		SocketClose Tcp_SocketID;
		Tcp_CntTimeout := 0;                    !warunki poczatkowe
		Tcp_Wdg := FALSE;
		TPwrite "close socket";
		RETURN;
	ENDPROC
	!-----------------------------------------------------------------------------------------------------------------endTCP
	PROC endTCP()
		SocketClose Tcp_servSocket;
		RETURN;
	ENDPROC
	!-----------------------------------------------------------------------------------------------------------------errorRecvTCP
	PROC errorRecvTCP() 
		IF ERRNO=ERR_SOCK_TIMEOUT THEN        !ERR timeOUT
            !KOL: dodalem by nie logowac informacji o przekroczeniu czasu oczekiwania na rozkaz z AVS
            SkipWarn;
			IF Tcp_Wdg=TRUE THEN
				Tcp_CntTimeout := Tcp_CntTimeout + 1;
				IF Tcp_CntTimeout>Tcp_SizeTimeout THEN
					TPwrite "TCP WDG sizetimeout";
					closeTCP;
					acceptTCP;
					RETURN;
				ENDIF
			ENDIF
		ELSEIF ERRNO=ERR_SOCK_CLOSED THEN
			TPwrite "TCP_RECV ERR_SOCK_CLOSED";
			closeTCP;
			acceptTCP;
			RETURN;
		ELSE
			TPwrite "TCP_RECV NEW ERR: " \num:= ERRNO;
			closeTCP;
			endTCP;
			STOP;
		ENDIF
		RETURN;
	ENDPROC
	!-----------------------------------------------------------------------------------------------------------------recvLast3TCP
	PROC recvLast3TCP()
		RETURN;
	ENDPROC
	!--------------------------------------------------------------------------
	! obsluga bledu - wyslanie do robota informacji o bledzie
	PROC returnErrorToPC (BYTE masterCommand, NUM basicCommandNo, NUM debugPointer)
		 
		!num  errNo;           // numer bledu 
		!byte masterCommand;   // identyfikator rozkazu w ktorym wystapil blad 
		!word basicCommandNo;  // numer elementarnego rokazu w pakiecie ktory wygenerowa³ blad 
		!num  debugPointer;    // miejsce w kodzie gdzie wystapil blad 
		
		! zapakowanie odpowiedzi o bledzie
	!	clearOutBuffer;
		! zapakowanie naglowka
	!	prepareOutBufor;
		! ustawiamy poczatek bloku danych
	!	outDataPointer := 7;
		! pakowanie ErrorEvent
	!	pack_BYTE(RCMC_ErrorEvent);
		! zapakowanie debugPointera - mowi w ktorym miejscu procedury byl problem
	!	packINT(AVS_ERROR(errNo));
	!	pack_BYTE(masterCommand);
	!	packWORD(basicCommandNo);
	!	packINT(debugPointer);
	!	finishOutBufor;
		
		!ToFile "log.html","<FONT color=red>SocketSend returnErrorToPc</FONT><BR>";
		!ToFile "log.html","<FONT color=red>ErrorEvent: errNo ="+NumToStr(errNo,0)+" </FONT><BR>";
		!ToFile "log.html","<FONT color=red>ErrorEvent: masterCommand ="+NumToStr(masterCommand,0)+"   ";
		!ToFile "log.html","ErrorEvent: basicCommandNo ="+NumToStr(basicCommandNo,0)+"   ";
		!ToFile "log.html","ErrorEvent: debugPointer ="+NumToStr(debugPointer,0)+"</FONT><BR>";
		
	!	SocketSend PcMasterClient \RawData:=outBuffer{1}; 
	!	ClearRawBytes outBuffer{1};
	!	afterError := TRUE;
	ENDPROC	
	!--------------------------------------------------------------------------
ENDMODULE


