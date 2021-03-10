MODULE Simple_iProdGS
!    
! Uniwersalny modul do komunikacji z serwerami iProdGS
!
! najnowszy kod powinien znajdowac sie w tym miejscu:
! https://github.com/KrzysztofOle/RAPID_ABB/blob/21c66f2aabd7a47c91d81cea9138b9c671ab3c0d/Simple_iProdGS.mod
!   
!
    !
    !rekord przechowujacy ramke podzielona na parametry
    RECORD frameTCP
        string ID;
        string p1;
        string p2;
        string p3;
        string p4;
        string p5;
        string p6;
        string p7;
        string p8;
        string p9;
        string p10;
        string p11;
        string p12;
        string p13;
        string p14;
        string p15;
        num paramNo;
    ENDRECORD

    !! IProdCommand - przechowuje specyfikacje rozkazow
    RECORD IProdGSCommand
        string Komenda;
        !! Zmienna ta zawiera ilosc parametrow, ktora kazda z komend moze posiadac. Przyjete zostalo, iz brak parametrow oznaczany jest wartoscia -1
        num ileParKom;
        !! Odpowiedz serwera iProdGS
        string Odpowiedz;
        !! ile parametrow bedzie w odpowiedzi
        num ileParOdp;
    ENDRECORD

    !superiorClientTCP - przechowuje parametry polaczenia. Zmienne pozwalajace na utworzenie obiektu clientTCP, a w konsekwencji polaczenia z serwerem
    RECORD superiorClientTCP
        string ipAddress;
        num portNo;
        !! Host    
        string prefix;
        !! Znak poczatku ramki
        string suffix;
        !! Znak konca ramki
        string split;
        !! Znak rozdzielajacy parametry
        num retryNo;
    ENDRECORD
    
    RECORD operacjaProdGS
        num id_operacji;
        string opis;
        string lok1;
        string lok2;
    ENDRECORD

    PERS bool TCPLogSwitch:=TRUE;

    ! komunikacja z iProdGS na 1 watku
    !
    LOCAL VAR socketstatus state;
    LOCAL VAR socketdev superiorSocket;
    LOCAL PERS num socketTimeWait:=20;
    LOCAL CONST num maxRetryNo:=3;
    !
    LOCAL VAR string frameRecieved;
    LOCAL VAR string singleFrame;
    LOCAL VAR num commandInNum;

    ! przelacznik czy serwer ma odpowiadac echcem
    LOCAL CONST bool echo:=FALSE;

    LOCAL CONST IProdGSCommand iProdGSCommandList{5}:=[["GET_PLAN",0,"PLAN_RESULT",4],
                                            ["WHAT_ABOUT",1,"ABOUT_RESULT",3],
                                            ["SKIP_ELEMENT",1,"SKIP_RESULT",1],
                                            ["DONE",4,"DONE_OK",0],
                                            ["MOVE",2,"MOVE_OK",0]];

    !! @6.1 okreslenie danych dla  serwera
    LOCAL CONST superiorClientTCP clientTCP:=["10.16.48.129",9197,"","q",",",10];


    CONST num GET_PLAN:=1;
    CONST num WHAT_ABOUT:=2;
    CONST num SKIP_ELEMENT:=3;
    CONST num DONE:=4;
    CONST num MOVE:=5;

    !Stale przechowujace ID stanowisk
    CONST string sT_robBig:="RB";
    CONST string sT_alejkaKJ:="ALK";
    CONST string sT_robWklad:="SPWK";
    CONST string sT_robPrasa:="PRS";
    CONST string sT_robPlaszcz:="SPLA";
    CONST string sT_robGalantL:="GL";
    CONST string sT_robGalantR:="GP";
    CONST string sT_buforPKW:="BPKW";
    CONST string sT_buforPKWP:="BPKWP";
    CONST string sT_buforSolniczki:="BSOL";
    CONST string sT_finalConveyor:="KNC";
    CONST string sT_empty:="";
    
    !! Zdefiniowane operacje iProdGS
    CONST operacjaProdGS OP_sczepianiePKW:=             [6600, "Wykonanie spoin sczepnych PKW",  sT_robWklad,    sT_empty];
    CONST operacjaProdGS OP_spawaniePKW:=               [6601, "Spawanie PKW",                   sT_robWklad,    sT_empty];
    CONST operacjaProdGS OP_montazPlaszcza:=            [6700, "Montaz plaszcza",                sT_robPrasa,    sT_empty];
    CONST operacjaProdGS OP_sczepianiePlaszcza:=        [6701, "Sczepianie plaszcza",            sT_robPlaszcz,  sT_empty];
    CONST operacjaProdGS OP_spawaniePlaszcza:=          [6702, "Spawanie plaszcza",              sT_robPlaszcz,  sT_empty];
    !! 
    CONST operacjaProdGS OP_sczepianieWieszakGorny:=    [6801, "Sczepianie-wieszakGorny",        sT_robGalantL,  sT_robGalantR];
    
    
    PERS string temp_idPKW:="DE.ANPG275825";
    PERS num temp_ilePKW:=12;
    PERS string temp_idWym:="DE.ANPG275825";
    PERS num temp_ileWym:=3;



    LOCAL PERS string temp_id:="";
    LOCAL PERS bool temp_hold:=FALSE;
    LOCAL PERS num temp_idOper:=6700;
    LOCAL PERS string temp_partIndex:="DE.ACPR247300";
    LOCAL PERS string temp_placeId:="";
    LOCAL PERS num temp_howManyParts:=0;
    LOCAL PERS bool temp_continue:=FALSE;
    LOCAL PERS string temp_sourceStId:="";
    LOCAL PERS string temp_destStId:="";


    ! otwiera polaczenie z serwerem iProdGS
    LOCAL PROC iProdGS_open()

        ! na poczatek sprawdzamy stan polaczenia
        state:=SocketGetStatus(superiorSocket);
        WHILE state<>SOCKET_CONNECTED DO

            IF state=SOCKET_CLOSED THEN
                !!TPWrite "Status: Closed --> SocketCreate";
                ! proba utworzenia socketa
                SocketCreate superiorSocket;
            ENDIF
            state:=SocketGetStatus(superiorSocket);
            IF state=SOCKET_CREATED THEN
                !!TPWrite "Status: Created --> SocketConnect";
                ! proba nawiazania polaczenia
                !!SocketConnect  nazwa_zmiennej_pozwalajacej_na_tworzenie_punktu_dostepu, adresIP, Host\Czas_przez_ktory_program_czeka_na_polaczenie
                SocketConnect superiorSocket,clientTCP.ipAddress,clientTCP.portNo\Time:=socketTimeWait;
            ENDIF
            ! tutaj powinno byc juz poloczenie
            state:=SocketGetStatus(superiorSocket);
            IF state<>SOCKET_CONNECTED THEN
                ! zamykamy by ponowic probe otwarcia
                SocketClose superiorSocket;
                WaitTime 3;
            ENDIF

        ENDWHILE
        ErrWrite\I,"Simple_iProdGS:: OPEN","";
    ENDPROC

    LOCAL PROC iProdGS_close()
        state:=SocketGetStatus(superiorSocket);
        IF state<>SOCKET_CLOSED THEN
            ! zamykamy
            SocketClose superiorSocket;
            ErrWrite\I,"Simple_iProdGS:: CLOSE","";
        ELSE
            ErrWrite\I,"Simple_iProdGS:: nie ma potrzeby robic CLOSE","";
        ENDIF
    ENDPROC

    LOCAL PROC iProdGS_send(string ramka)
        VAR num sendFrameState;
        VAR num currentRetryNo;
        !!
        !! czesc odpowiedzialna za wysylanie komunikatow
        !!
        sendFrameState:=0;
        state:=SocketGetStatus(superiorSocket);
        IF state=SOCKET_CONNECTED THEN
            !!TPWrite "Status: Connected --> SocketSend ?";
            !!
            !! sprawdzamy czy jest cos do wyslania
            IF ramka<>"" THEN
                TPWrite "WAIT FOR SEND :"+ramka;
                !! wysylamy to co jest w buforze do wyslania
                frameRecieved:="";
                currentRetryNo:=0;
                WHILE frameRecieved<>ramka DO
                    !!Utworzenie ramki z danymi. Ramka ta zawierac bedzie numer ID czwarty z obiektu ROBASS.
                    !! @3 SocketSend nazwa_punktu_dostepu\Str:=Tekst_do_przeslania -> 
                    !! ->W naszym przypadku do serwera zostaje przeslany komunikat zawarty w zmiennej frameToSend, czyli cyfra 4. Str- skrot od string-> mozliwosc przesylu danych tekstowych
                    sendFrameState:=1;
                    SocketSend superiorSocket\Str:=ramka;
                    sendFrameState:=2;
                    !! @4 odebranie od serwera ramki z danymi -> serwer odeslal ramke, ktora odebral od urzadzenia w celu sprawdzenia poprawnosci danych
                    !!SocketReceive nazwa_punktu_dostepu_od_ktorego_pochodza_dane\Str:=miejsce_w_ktorym_maja_zostac_przechowane_przeslane_dane\Time:=Maksymalny_czas_oczekiwania_na_odpowiez
                    sendFrameState:=10;

                    IF echo THEN
                        SocketReceive superiorSocket\Str:=frameRecieved\Time:=10;
                        ! + \NoRecBytes    
                    ELSE
                        ! przepisujemy by oszukac system
                        frameRecieved:=ramka;
                    ENDIF

                    sendFrameState:=11;
                    IF TCPLogSwitch TPWrite "recive2: "+frameRecieved;
                    currentRetryNo:=currentRetryNo+1;
                    IF currentRetryNo>maxRetryNo THEN
                        ErrWrite "ERROR::ClientStringTCP","Przekroczono maksymalna ilosc prob wyslania ramki rozkazu. maxRetryNo = "+NumToStr(maxRetryNo,0)\RL2:="Nie prawidlowy rozkaz lub serwer nie odpowiada.";
                    ELSEIF frameRecieved<>ramka THEN
                        ErrWrite "ERROR::ClientStringTCP","HANSHAKE NOK!!!"\RL2:="SEND: "+ramka\RL3:="RECEIVED: "+frameRecieved;
                    ENDIF
                ENDWHILE
                !jezeli nie bylo bledu to frameReceived=frameToSend --> HANDSHAKE
                IF frameRecieved=ramka THEN
                    IF echo THEN
                        ErrWrite\I,"Procedura SendFrame","WYSLANO OK!!!"\RL2:="SEND: "+ramka\RL3:="RECEIVED ECHO: "+frameRecieved;
                    ELSE
                        ErrWrite\I,"Procedura SendFrame","WYSLANO OK!!!"\RL2:="SEND: "+ramka;
                    ENDIF
                ENDIF
            ENDIF
        ENDIF
    ERROR
        IF ERRNO=ERR_SOCK_TIMEOUT THEN
            ErrWrite "Blad polaczenia-serwer nie odpowiada","podejmuje kolejna probe"\RL2:="ERR_SOCK_TIMEOUT";
            WaitTime 2;
            RETRY;
        ENDIF


    ENDPROC

    LOCAL FUNC frameTCP iProdGS_reciveFrame()
        VAR num found;
        VAR num recordNo;
        VAR num numOfCommands;
        VAR num reciveFrameState;
        VAR string uruchomOdp;
        VAR frameTCP result;

        !!
        !! czesc odpowiedzialna za odbieranie komunikatow
        !!
        reciveFrameState:=0;
        frameRecieved:="";
        state:=SocketGetStatus(superiorSocket);
        IF state=SOCKET_CONNECTED THEN
            !!TPWrite "Status: Connected --> SocketReceive";
            !!
            !! sprawdzamy czy jest cos do odebrania
            reciveFrameState:=1;
            SocketReceive superiorSocket\Str:=frameRecieved\Time:=1;
            ! + \NoRecBytes
            IF frameRecieved="" RETURN result;
            reciveFrameState:=2;
            IF TCPLogSwitch TPWrite "recive: "+frameRecieved;
            ErrWrite\I,"clientStringTCP::reciveFrame()","Odebrano:"\RL2:=frameRecieved;
            !! analiza odebranej ramki
            iProdGS_clearFrame result;
            !!
            IF clientTCP.prefix<>"" THEN
                !szukamy najpierw poczatku ramki
                found:=StrFind(frameRecieved,1,clientTCP.prefix);
                IF found<=StrLen(frameRecieved) THEN
                    !wycinamy smieci
                    frameRecieved:=StrPart(frameRecieved,found,StrLen(frameRecieved)-found);
                    ErrWrite\I,"clientStringTCP::reciveFrame()","Po czyszczeniu:"\RL2:=frameRecieved;
                ELSE
                    ! brak znaku poczatku ramki
                    ErrWrite\W,"clientStringTCP::reciveFrame()","Brak znaku poczatku ramki:"\RL2:=frameRecieved;
                    frameRecieved:="";
                ENDIF
            ENDIF

            ! sprawdzamy czy wystepuje znak konca ramki
            found:=StrFind(frameRecieved,1,clientTCP.suffix);
            ! jak mamy koniec to wycinamy fragment
            IF found<=StrLen(frameRecieved) THEN
                singleFrame:=StrPart(frameRecieved,1,found);
                !! ODSYLAMY RAMKE W CELU JEJ POTWIERDZENIA
                reciveFrameState:=10;
                IF TCPLogSwitch THEN
                    TPWrite "Potwierdzamy: "+singleFrame;
                    ErrWrite\I,"reciveFrame: ","Potwierdzamy: "+singleFrame;
                ENDIF
                IF echo SocketSend superiorSocket\Str:=singleFrame;
                reciveFrameState:=11;
                ! extrakcja parametrow do ramki
                iProdGS_extractFrame singleFrame,result;
                IF TCPLogSwitch TPWrite "Odczytano parametrow: "\Num:=result.paramNo;
                iProdGS_TPWriteFrame result;
                !! sprawdzamy ilosc mozliwych odpowiedzi
                numOfCommands:=Dim(iProdGSCommandList,1);
                recordNo:=1;

                !! sprawdzamy czy odebralismy znana ramke (szukamy w tablicy ROBASS)
                WHILE recordNo<=numOfCommands AND result.ID<>iProdGSCommandList{recordNo}.Odpowiedz DO
                    !!
                    Incr recordNo;
                ENDWHILE
                IF recordNo>numOfCommands THEN
                    !! nieznany identyfikator ramki
                    ErrWrite "ERROR::ClientStringTCP","Odebrano nieznany identyfikator rozkazu. recivedtFrameTCP.ID = "+result.ID\RL2:="Nie prawidlowe ID rozkazu.";
                ELSE
                    !! sprawdzamy ilosc parametrow
                    IF result.paramNo<>iProdGSCommandList{recordNo}.ileParOdp THEN
                        !! nieprawidlowa ilosc parametow
                        ErrWrite "ERROR::ClientStringTCP","Nie prawidlowa ilosc parametrow w ramce rozkazu. recivedtFrameTCP.paramNo = "+NumToStr(result.paramNo,0)\RL2:="Spodziewano sie iProdGSCommandList{recordNo}.ileParOdp = "+NumToStr(iProdGSCommandList{recordNo}.ileParOdp,0);
                    ENDIF
                    ErrWrite\I,"reciveFrame: "+result.ID,"";
                ENDIF

                !! odebrano prawidlowa ramke
                !!
                IF TCPLogSwitch TPWrite "Odebrano prawidlowa ramke o ID: "+result.ID;
                ErrWrite\W,"iProdGS_reciveFrame:","Odebrano prawidlowa ramke o ID: "+result.ID;
                !

                RETURN result;
            ELSE
                !! brak znaku konca ramki
                RETURN result;
            ENDIF
            WaitTime 1;
        ENDIF
        !        IF frameRecieved=frameToSend2 THEN

        !            !!TPWrite "Server potwierdzil odebranie danych za: "\Num:=currentRetryNo;
        !        ENDIF
        RETURN result;
    ERROR
        IF ERRNO=ERR_SOCK_TIMEOUT THEN
            SkipWarn;
            TRYNEXT;
        ELSEIF ERRNO=ERR_SOCK_CLOSED THEN
            TPWrite "Client disconnected----->SocketClose";
            SocketClose superiorSocket;
            TPWrite "=========================";
        ENDIF

        IF reciveFrameState=1 THEN
            TRYNEXT;
        ELSEIF reciveFrameState=10 THEN
            TPWrite "! nie udane wyslanie potwierdzenia !";
            RETRY;
        ELSE
        ENDIF

    ENDFUNC

    !! aTest_Simple_iProdGS - procedura do testowania komunikacji z iProdGS
    PROC aTest_Simple_iProdGS()

        VAR string idPKW;
        VAR num ilePKW;
        VAR string placeID;
        VAR string idWym;
        VAR num ileWym;
        VAR bool hold;
        VAR string holdStr;
        VAR num idOper;
        VAR string partIndex;
        VAR num howManyParts;
        VAR string sourceStId;
        VAR string destStId;
        VAR bool czyKontynuowac;
        VAR string czyKontynuowacStr;
        !



        ! test GET_PLAN
        iProdGS_GET_PLAN idPKW,ilePKW,idWym,ileWym;
        ErrWrite\I,"iProdGS::test GET_PLAN"," idPKW: "+idPKW+" - "+NumToStr(ilePKW,0)
        \RL2:=" idWym:"+idWym+" - "+NumToStr(ileWym,0);

        ! test WHAT_ABOUT
        placeID:="ALK";
        idWym:="";
        hold:=TRUE;
        idOper:=-1;
        !PROC iProdGS_WHAT_ABOUT(string ID_miejsca, inout string IndexProduktu, inout bool stan, inout num ID_nastepnaOperacja)
        iProdGS_WHAT_ABOUT placeID,idWym,hold,idOper;

        holdStr:="FALSE";
        IF hold holdStr:="TRUE";

        ErrWrite\I,"iProdGS::test WHAT_ABOUT"," placeID: "+placeID
        \RL2:="  idWym: "+idWym
        \RL3:="   hold: "+holdStr
        \RL4:=" idOper: "+NumToStr(idOper,0);

        ! test SKIP_ELEMENT
        partIndex:="DE.ACPR247300";
        iProdGS_SKIP_ELEMENT partIndex,czyKontynuowac;
        czyKontynuowacStr:="FALSE";
        IF czyKontynuowac czyKontynuowacStr:="TRUE";
        ErrWrite\I,"iProdGS::test SKIP_ELEMENT"," partIndex: "+partIndex
        \RL2:="   czy kontynuowac: "+czyKontynuowacStr;

        ! test DONE
        idOper:=6706;
        placeID:="GR";
        partIndex:="";
        howManyParts:=0;
        iProdGS_DONE idOper,placeID,partIndex,howManyParts;
        ErrWrite\I,"iProdGS::test DONE"," idOper: "+NumToStr(idOper,0)
        \RL2:="      placeID:"+placeID
        \RL3:="    partIndex:"+partIndex
        \RL4:=" howManyParts:"+NumToStr(howManyParts,0);
        
        ! test MOVE
        sourceStId:=sT_robWklad;
        destStId:=sT_buforPKWP;
        
        iProdGS_MOVE sourceStId, destStId;
        ErrWrite \I, "iProdGS::test DONE", " sourceStId: "+sourceStId
        \RL2:="      destStId:"+destStId;
        
        !
        ErrWrite \I, "iProdGS::Koniec testu.", "Koniec testu komunikacji z serveram iProdGS";

    ENDPROC

    LOCAL PROC iProdGS_clearFrame(INOUT frameTCP toClearFrameTCP)
        toClearFrameTCP.ID:="";
        toClearFrameTCP.p1:="";
        toClearFrameTCP.p2:="";
        toClearFrameTCP.p3:="";
        toClearFrameTCP.p4:="";
        toClearFrameTCP.p5:="";
        toClearFrameTCP.p6:="";
        toClearFrameTCP.p7:="";
        toClearFrameTCP.p8:="";
        toClearFrameTCP.p9:="";
        toClearFrameTCP.p10:="";
        toClearFrameTCP.p11:="";
        toClearFrameTCP.p12:="";
        toClearFrameTCP.p13:="";
        toClearFrameTCP.p14:="";
        toClearFrameTCP.p15:="";
        toClearFrameTCP.paramNo:=0;
    ENDPROC

    LOCAL PROC iProdGS_extractFrame(string recivedFrame,INOUT frameTCP resultFrameTCP)
        VAR bool foundParam;
        ! ramka zostala juz sprawdzona pod katem znakow rozpoczenia i zakonczenia
        resultFrameTCP.ID:=getSingleParam(recivedFrame,foundParam);
        resultFrameTCP.paramNo:=-1;
        IF NOT foundParam RETURN ;
        resultFrameTCP.p1:=getSingleParam(recivedFrame,foundParam);
        resultFrameTCP.paramNo:=0;
        IF NOT foundParam RETURN ;
        resultFrameTCP.p2:=getSingleParam(recivedFrame,foundParam);
        resultFrameTCP.paramNo:=1;
        IF NOT foundParam RETURN ;
        resultFrameTCP.p3:=getSingleParam(recivedFrame,foundParam);
        resultFrameTCP.paramNo:=2;
        IF NOT foundParam RETURN ;
        resultFrameTCP.p4:=getSingleParam(recivedFrame,foundParam);
        resultFrameTCP.paramNo:=3;
        IF NOT foundParam RETURN ;
        resultFrameTCP.p5:=getSingleParam(recivedFrame,foundParam);
        resultFrameTCP.paramNo:=4;
        IF NOT foundParam RETURN ;
        resultFrameTCP.p6:=getSingleParam(recivedFrame,foundParam);
        resultFrameTCP.paramNo:=5;
        IF NOT foundParam RETURN ;
        resultFrameTCP.p7:=getSingleParam(recivedFrame,foundParam);
        resultFrameTCP.paramNo:=6;
        IF NOT foundParam RETURN ;
        resultFrameTCP.p8:=getSingleParam(recivedFrame,foundParam);
        resultFrameTCP.paramNo:=7;
        IF NOT foundParam RETURN ;
        resultFrameTCP.p9:=getSingleParam(recivedFrame,foundParam);
        resultFrameTCP.paramNo:=8;
        IF NOT foundParam RETURN ;
        resultFrameTCP.p10:=getSingleParam(recivedFrame,foundParam);
        resultFrameTCP.paramNo:=9;
        IF NOT foundParam RETURN ;
        resultFrameTCP.p11:=getSingleParam(recivedFrame,foundParam);
        resultFrameTCP.paramNo:=10;
        IF NOT foundParam RETURN ;
        resultFrameTCP.p12:=getSingleParam(recivedFrame,foundParam);
        resultFrameTCP.paramNo:=11;
        IF NOT foundParam RETURN ;
        resultFrameTCP.p13:=getSingleParam(recivedFrame,foundParam);
        resultFrameTCP.paramNo:=12;
        IF NOT foundParam RETURN ;
        resultFrameTCP.p14:=getSingleParam(recivedFrame,foundParam);
        resultFrameTCP.paramNo:=13;
        IF NOT foundParam RETURN ;
        resultFrameTCP.p15:=getSingleParam(recivedFrame,foundParam);
        resultFrameTCP.paramNo:=14;
        IF NOT foundParam RETURN ;
        resultFrameTCP.paramNo:=15;
        ! 
        IF StrLen(recivedFrame)>1 THEN
            ErrWrite "ERROR::ClientStringTCP","Ramka zawiera za duzo parametrow n>10."\RL2:="Skontroluj wielkosc ramki lub zwieksz maksymalna ilosc parametrow.";
        ENDIF
    ENDPROC

    LOCAL PROC iProdGS_TPWriteFrame(frameTCP frameTCPToWrite)
        TPWrite "ID:"+frameTCPToWrite.ID;
        IF frameTCPToWrite.p1<>"" TPWrite "p1:"+frameTCPToWrite.p1;
        IF frameTCPToWrite.p2<>"" TPWrite "p2:"+frameTCPToWrite.p2;
        IF frameTCPToWrite.p3<>"" TPWrite "p3:"+frameTCPToWrite.p3;
        IF frameTCPToWrite.p4<>"" TPWrite "p4:"+frameTCPToWrite.p4;
        IF frameTCPToWrite.p5<>"" TPWrite "p5:"+frameTCPToWrite.p5;
        IF frameTCPToWrite.p6<>"" TPWrite "p6:"+frameTCPToWrite.p6;
        IF frameTCPToWrite.p7<>"" TPWrite "p7:"+frameTCPToWrite.p7;
        IF frameTCPToWrite.p8<>"" TPWrite "p8:"+frameTCPToWrite.p8;
        IF frameTCPToWrite.p9<>"" TPWrite "p9:"+frameTCPToWrite.p9;
        IF frameTCPToWrite.p10<>"" TPWrite "p10:"+frameTCPToWrite.p10;
        IF frameTCPToWrite.p11<>"" TPWrite "p11:"+frameTCPToWrite.p11;
        IF frameTCPToWrite.p12<>"" TPWrite "p12:"+frameTCPToWrite.p12;
        IF frameTCPToWrite.p13<>"" TPWrite "p13:"+frameTCPToWrite.p13;
        IF frameTCPToWrite.p14<>"" TPWrite "p14:"+frameTCPToWrite.p14;
        IF frameTCPToWrite.p15<>"" TPWrite "p15:"+frameTCPToWrite.p15;
    ENDPROC

    LOCAL FUNC string getSingleParam(INOUT string recivedFrame,INOUT bool foundParam)
        !pobiera pierwszy parametr jako string
        VAR num found;
        VAR num lenght;
        VAR string param;
        lenght:=StrLen(recivedFrame);
        found:=StrFind(recivedFrame,1,",");
        IF found<=lenght THEN
            param:=StrPart(recivedFrame,1,found-1);
            recivedFrame:=StrPart(recivedFrame,found+1,StrLen(recivedFrame)-found);
            foundParam:=TRUE;
            RETURN param;
        ELSE
            IF lenght>1 THEN
                param:=StrPart(recivedFrame,1,lenght-1);
                recivedFrame:=StrPart(recivedFrame,lenght,1);
                foundParam:=TRUE;
                RETURN param;
            ELSE
                param:="";
                foundParam:=FALSE;
                RETURN param;
            ENDIF
        ENDIF
    ENDFUNC

    !################################################################################################
    ! 
    PROC iProdGS_GET_PLAN(inout string idPKW,inout num ilePKW,inout string idWym,inout num ileWym)
        VAR num licznik:=0;
        VAR string ramkaDoWyslania;
        VAR frameTCP reciveFrame;
        VAR bool result:=FALSE;

        !
        ! do 3 razy sztuka
        WHILE result=FALSE AND licznik<3 DO

            iProdGS_open;
            ramkaDoWyslania:=iProdGS_sendCommandTCP(iProdGSCommandList{GET_PLAN});
            iProdGS_send ramkaDoWyslania;
            reciveFrame:=iProdGS_reciveFrame();
            !PLAN_RESULT
            IF reciveFrame.ID="PLAN_RESULT" THEN
                commandInNum:=commandInNum+1;
                !
                result:=TRUE;
                result:=result AND StrToVal(reciveFrame.p2,ilePKW);
                result:=result AND StrToVal(reciveFrame.p4,ileWym);
                result:=result AND reciveFrame.p1<>"";
                result:=result AND reciveFrame.p3<>"";
                IF result THEN
                    !set_PlanResult recivedtFrameTCP.p1, ilePKW, recivedtFrameTCP.p3, ileWym;
                    idPKW:=reciveFrame.p1;
                    idWym:=reciveFrame.p3;
                ENDIF
            ELSE
                ErrWrite "iProdGS_GET_PLAN: ERROR: Odebrano nie prawidlowe ID",
                        "  reciveFrame.ID="+reciveFrame.ID
                \RL2:="   p1="+reciveFrame.p1+"   p2="+reciveFrame.p2
                \RL3:="   p3="+reciveFrame.p3+"   p4="+reciveFrame.p4
                \RL4:="   licznik="+NumToStr(licznik,0);
                result:=FALSE;
            ENDIF
            iProdGS_close;
            !
            licznik:=licznik+1;
            IF result=FALSE WaitTime 1;
        ENDWHILE
        !
    ENDPROC

    !################################################################################################
    ! 
    PROC iProdGS_WHAT_ABOUT(string ID_miejsca,inout string IndexProduktu,inout bool stan,inout num ID_nastepnaOperacja)
        VAR num licznik:=0;
        VAR string ramkaDoWyslania;
        VAR frameTCP reciveFrame;
        VAR bool result:=FALSE;

        !
        ! do 3 razy sztuka
        WHILE result=FALSE AND licznik<3 DO

            iProdGS_open;
            ramkaDoWyslania:=iProdGS_sendCommandTCP(iProdGSCommandList{WHAT_ABOUT}\s1:=ID_miejsca);
            iProdGS_send ramkaDoWyslania;
            reciveFrame:=iProdGS_reciveFrame();
            !PLAN_RESULT
            IF reciveFrame.ID="ABOUT_RESULT" THEN
                commandInNum:=commandInNum+1;
                !
                result:=TRUE;
                ! INDEX_PRODUKTU
                result:=result AND reciveFrame.p1<>"";
                ! czy wstrzymac
                result:=result AND (reciveFrame.p2="0" OR reciveFrame.p2="1");
                ! ID_OPERACJI 
                result:=result AND StrToVal(reciveFrame.p3,ID_nastepnaOperacja);
                IF result THEN
                    IndexProduktu:=reciveFrame.p1;
                    stan:=FALSE;
                    IF reciveFrame.p2="1" stan:=TRUE;
                ENDIF
            ELSE
                ErrWrite "iProdGS_WHAT_ABOUT: ERROR: Odebrano nie prawidlowe ID",
                        "  reciveFrame.ID="+reciveFrame.ID
                \RL2:="   p1="+reciveFrame.p1+"   p2="+reciveFrame.p2
                \RL3:="   p3="+reciveFrame.p3+"   p4="+reciveFrame.p4
                \RL4:="   licznik="+NumToStr(licznik,0);
                result:=FALSE;
            ENDIF
            iProdGS_close;
            !
            licznik:=licznik+1;
            IF result=FALSE WaitTime 1;
        ENDWHILE
        !
    ENDPROC

    !################################################################################################
    PROC iProdGS_MOVE(string sourceStId,string destStId)

        VAR bool timeut;
        VAR num licznik:=0;
        VAR string ramkaDoWyslania;
        VAR frameTCP reciveFrame;
        VAR bool result:=FALSE;

        !
        ! do 3 razy sztuka
        WHILE result=FALSE AND licznik<3 DO

            iProdGS_open;
            ramkaDoWyslania:=iProdGS_sendCommandTCP(iProdGSCommandList{MOVE}\s1:=sourceStId\s2:=destStId);
            iProdGS_send ramkaDoWyslania;
            reciveFrame:=iProdGS_reciveFrame();
            !PLAN_RESULT
            IF reciveFrame.ID="MOVE_OK" THEN
                commandInNum:=commandInNum+1;
                result:=TRUE;
            ELSE
                ErrWrite "iProdGS_MOVE: ERROR: Odebrano nie prawidlowe ID",
                        "  reciveFrame.ID="+reciveFrame.ID
                \RL2:="   p1="+reciveFrame.p1+"   p2="+reciveFrame.p2
                \RL3:="   licznik="+NumToStr(licznik,0);
                result:=FALSE;
            ENDIF
            iProdGS_close;
            !
            licznik:=licznik+1;
            IF result=FALSE WaitTime 1;
        ENDWHILE

    ENDPROC

    !################################################################################################
    ! 
    PROC iProdGS_SKIP_ELEMENT(string IndexElementu,inout bool kontynuacja)
        VAR num licznik:=0;
        VAR string ramkaDoWyslania;
        VAR frameTCP reciveFrame;
        VAR bool result:=FALSE;

        !
        ! do 3 razy sztuka
        WHILE result=FALSE AND licznik<3 DO

            iProdGS_open;
            ramkaDoWyslania:=iProdGS_sendCommandTCP(iProdGSCommandList{SKIP_ELEMENT}\s1:=IndexElementu);
            iProdGS_send ramkaDoWyslania;
            reciveFrame:=iProdGS_reciveFrame();
            !PLAN_RESULT
            IF reciveFrame.ID="SKIP_RESULT" THEN
                commandInNum:=commandInNum+1;
                !
                result:=TRUE;
                ! czy kontynuowac
                result:=result AND (reciveFrame.p1="0" OR reciveFrame.p1="1");
                IF result THEN
                    kontynuacja:=FALSE;
                    IF reciveFrame.p2="1" kontynuacja:=TRUE;
                ENDIF
            ELSE
                ErrWrite "iProdGS_SKIP_ELEMENT: ERROR: Odebrano nie prawidlowe ID",
                        "  reciveFrame.ID="+reciveFrame.ID
                \RL2:="   p1="+reciveFrame.p1+"   p2="+reciveFrame.p2
                \RL3:="   p3="+reciveFrame.p3+"   p4="+reciveFrame.p4
                \RL4:="   licznik="+NumToStr(licznik,0);
                result:=FALSE;
            ENDIF
            iProdGS_close;
            !
            licznik:=licznik+1;
            IF result=FALSE WaitTime 1;
        ENDWHILE
        !
    ENDPROC



    
    !################################################################################################
    ! 
    PROC iProdGS_DONE(num ID_operacji,string ID_miejsca,string Index,num ile)
        VAR num licznik:=0;
        VAR string ramkaDoWyslania;
        VAR frameTCP reciveFrame;
        VAR bool result:=FALSE;

        !
        ! do 3 razy sztuka
        WHILE result=FALSE AND licznik<3 DO

            iProdGS_open;
            ramkaDoWyslania:=iProdGS_sendCommandTCP(iProdGSCommandList{DONE}\n1:=ID_operacji\s2:=ID_miejsca\s3:=Index\n4:=ile);
            iProdGS_send ramkaDoWyslania;
            reciveFrame:=iProdGS_reciveFrame();
            !PLAN_RESULT
            IF reciveFrame.ID="DONE_OK" THEN
                commandInNum:=commandInNum+1;
                result:=TRUE;
            ELSE
                ErrWrite "iProdGS_DONE: ERROR: Odebrano nie prawidlowe ID",
                        "  reciveFrame.ID="+reciveFrame.ID
                \RL2:="   p1="+reciveFrame.p1+"   p2="+reciveFrame.p2
                \RL3:="   p3="+reciveFrame.p3+"   p4="+reciveFrame.p4
                \RL4:="   licznik="+NumToStr(licznik,0);
                result:=FALSE;
            ENDIF
            iProdGS_close;
            !
            licznik:=licznik+1;
            IF result=FALSE WaitTime 1;
        ENDWHILE
        !
    ENDPROC
    
    PROC iProdGS_DONE_(operacjaProdGS operacjaProd,string ID_miejsca,string Index,num ile)
        ! sprawdzamy czy operacja dozwolona jest dla tego miejsca
        IF operacjaProd.lok1=ID_miejsca OR operacjaProd.lok2=ID_miejsca THEN
            iProdGS_DONE operacjaProd.id_operacji, ID_miejsca, Index, ile;    
        ELSE
            ErrWrite "iProdGS:: Operacja: "+operacjaProd.opis+" nie jest dozolona dla: "+ ID_miejsca,"";
            Stop;
        ENDIF
    ENDPROC

    !! funkcja tworzy ramke typu string z zestawu parametrow typu string lub num (maksymalnie 10 parametrow)
    FUNC string iProdGS_sendCommandTCP(IProdGSCommand command\string s1\num n1\string s2\num n2\string s3\num n3\string s4\num n4\string s5\num n5\string s6\num n6\string s7\num n7\string s8\num n8\string s9\num n9\string s10\num n10)
        VAR num paramsCount:=0;
        VAR bool showFrame:=FALSE;
        !! przygotowanie danych do wyslania
        VAR string result;

        result:=clientTCP.prefix;

        result:=result+command.Komenda;
        IF Present(s1) addStrToFrame result,paramsCount,s1;
        IF Present(n1) addNumToFrame result,paramsCount,n1;
        IF Present(s2) addStrToFrame result,paramsCount,s2;
        IF Present(n2) addNumToFrame result,paramsCount,n2;
        IF Present(s3) addStrToFrame result,paramsCount,s3;
        IF Present(n3) addNumToFrame result,paramsCount,n3;
        IF Present(s4) addStrToFrame result,paramsCount,s4;
        IF Present(n4) addNumToFrame result,paramsCount,n4;
        IF Present(s5) addStrToFrame result,paramsCount,s5;
        IF Present(n5) addNumToFrame result,paramsCount,n5;
        IF Present(s6) addStrToFrame result,paramsCount,s6;
        IF Present(n6) addNumToFrame result,paramsCount,n6;
        IF Present(s7) addStrToFrame result,paramsCount,s7;
        IF Present(n7) addNumToFrame result,paramsCount,n7;
        IF Present(s8) addStrToFrame result,paramsCount,s8;
        IF Present(n8) addNumToFrame result,paramsCount,n8;
        IF Present(s9) addStrToFrame result,paramsCount,s9;
        IF Present(n9) addNumToFrame result,paramsCount,n9;
        IF Present(s10) addStrToFrame result,paramsCount,s10;
        IF Present(n10) addNumToFrame result,paramsCount,n10;
        !! w ostatecznosci ramka, czyli zmienna result=prefix,numerID, parametr(1,2,3 badz zaden),suffix
        result:=result+clientTCP.suffix;
        IF showFrame ErrWrite\I,"sendCommandTCP","FRAME: "+result;
        !! sprawdzamy czy zgadza sie liczba parametrow
        IF paramsCount<>command.ileParKom THEN
            ErrWrite "ERROR::translateFrameOUT","Nie prawidlowa ilosc parametrow dla rozkazu o ID: "+command.Komenda\RL2:="Skontroluj ilosc parametrow w wywolaniu procedury sendCommand(...).";
            Stop;
        ENDIF
        RETURN result;
    ENDFUNC


    !! dodaje parametr typu string do stringa wstawiajac separator
    PROC addStrToFrame(INOUT string frame,INOUT num paramsCount,string s)
        IF Present(s) frame:=frame+","+s;
        Incr paramsCount;
    ENDPROC

    !! dodaje parametr typu num do stringa wstawiajac separator
    PROC addNumToFrame(INOUT string frame,INOUT num paramsCount,num n)
        IF Present(n) frame:=frame+","+NumToStr(n,0);
        Incr paramsCount;
    ENDPROC

ENDMODULE