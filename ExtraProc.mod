MODULE ExtraProc
    !zmienne do przechowywania parametrow odebranych z AVS2
    !(procedura AVS2 runCommand + parametry z commandPacka)
	 PERS bool paramBool{20};
    PERS byte paramByte{20};
    PERS num paramInt{20};
    PERS num paramFloat{20};    
    PERS pose paramPose{20};
    PERS wobjdata paramWobj{20};
    !zmienne do odbierania parametrow NIE Z COMMAND PACKA
    PERS bool gotNoOfParams:=FALSE;
    PERS num noOfParams:=4;
    PERS num lastReadParam:=1.23457E+08;
    !zmienne do wysylania rezultatow funkcji
    PERS num resultsReaded:=0;
    PERS bool startGetResults:=FALSE;
    !tablica iteratorow po kolejnych typach zmiennych
    ![ bool , byte , int , float , pose , wobj ]
    PERS num readParamIterator{6}:=[1,1,2,5,1,1];
	 PERS num getResultsIterator{6}:=[1,1,1,1,1,1];    
    !zmienne wewnetrzne
    PERS wobjdata currWobj;
    
    PROC displayON()
        TPWrite "--> displayOn <--";
        ! wyswietlanie napisow na panelu
        display:=TRUE;
    ENDPROC

    PROC displayOFF()
        TPWrite "--> displayOFF <--";
        ! wylaczenie wyswietlania napisow na panelu
        display:=FALSE;
    ENDPROC

    PROC logON()
        TPWrite "--> logOn <--";
        ! nowe logowanie
        raport:=TRUE;
        ! stare logowanie
        logowanie:=TRUE;
        LOG_Start "LogKomunikacja.html"\Reset;
        logBUF:=TRUE;
        logKOM:=TRUE;
    ENDPROC

    PROC logOFF()
        TPWrite "--> LogOFF <--";
        ! nowe logowanie
        raport:=FALSE;
        ! stare logowanie
        logowanie:=FALSE;
        ! konczenie logowania
        LOG_End;
        logBUF:=FALSE;
        logKOM:=FALSE;
    ENDPROC
  
    PROC dogON()
        watchdog:=TRUE;
    ENDPROC

    PROC dogOff()
        watchdog:=FALSE;
    ENDPROC
  
    PROC dataOn()
        sendDataConf:=TRUE;
    ENDPROC

    PROC dataOff()
        sendDataConf:=FALSE;
    ENDPROC
  
    PROC testOn()
        testConnect:=TRUE;
    ENDPROC

    PROC testOff()
        testConnect:=FALSE;
    ENDPROC
  
    PROC tPosOn()
        testPos:=TRUE;
    ENDPROC

    PROC tPosOff()
        testPos:=FALSE;
    ENDPROC
  
    PROC syncMeas()
       PulseDO do1;
    ENDPROC
    

    PROC activateUnit()
        !!! ROB_ID <- zmien na nazwe obrotnika !!!
        ActUnit ROB_ID;
    ENDPROC

    PROC deactivateUnit()
        !!! ROB_ID <- zmien na nazwe obrotnika !!!
        DeactUnit ROB_ID;
    ENDPROC

    PROC tuneExtServo()
        !!! ROB_ID <- zmien na nazwe obrotnika !!!
        VAR jointtarget startPos;
        VAR jointtarget endPos;
        VAR jointtarget currPos;
        VAR clock clk;
        VAR btnres answer:=-1;
        VAR num Kp:=100;
        VAR num Kv:=100;
        VAR num Ti:=100;
        VAR string my_message{5};
        CONST string my_buttons{5}:=["Kp","Kv","Ti","END","START"];

        startPos:=CJointT();
        startPos.extax.eax_a:=0;
        endPos:=startPos;
        endPos.extax.eax_a:=endPos.extax.eax_a+720;
        !podjazd do start
        MoveAbsJ startPos,v200,fine,tool0\WObj:=wobj0;

        WHILE answer<>4 DO
            my_message:=["Kp: "+NumToStr(Kp,0),"Kv: "+NumToStr(Kv,0),"Ti: "+NumToStr(Ti,0),stEmpty,stEmpty];
            answer:=UIMessageBox(\Header:="UIMessageBox Header"\MsgArray:=my_message\BtnArray:=my_buttons\Icon:=iconInfo);
            IF answer=1 THEN
                Kp:=UINumEntry(\InitValue:=Kp\MinValue:=1\MaxValue:=500);
            ELSEIF answer=2 THEN
                Kv:=UINumEntry(\InitValue:=Kv\MinValue:=1\MaxValue:=500);
            ELSEIF answer=3 THEN
                Ti:=UINumEntry(\InitValue:=Ti\MinValue:=1\MaxValue:=500);
            ELSEIF answer=5 THEN
                TuneReset;
                TuneServo ROB_ID,1,Kp\Type:=TUNE_KP;
                TuneServo ROB_ID,1,Kv\Type:=TUNE_KV;
                TuneServo ROB_ID,1,Ti\Type:=TUNE_TI;

                ClkReset clk;
                ClkStart clk;

                currPos:=CJointT();
                IF abs(currPos.extax.eax_a-endPos.extax.eax_a)<10 THEN
                    MoveAbsJ startPos,v200,fine,tool0\WObj:=wobj0;
                ELSE
                    MoveAbsJ endPos,v200,fine,tool0\WObj:=wobj0;
                ENDIF

                ClkStop clk;
                TPWrite "TIME: "+NumToStr(ClkRead(clk\HighRes),3);
            ENDIF
        ENDWHILE
    ENDPROC
    
    !funkcja sprawdzajaca czy oby dwa wobj sa takie same 
    FUNC bool checkWobj(wobjdata baseWobj, wobjdata currentWObj)
        VAR bool result:=FALSE;
        VAR wobjdata testedWobjs{2};
        VAR bool transOK:=FALSE;
        VAR bool rotOK:=FALSE;
        
        testedWobjs:=[baseWobj,currentWObj];
        !zaokraglamy kazda wartosc wobj do 3ch miejsc po przecinku
        FOR i FROM 1 TO Dim(testedWobjs,1) DO
           testedWobjs{i}.uframe.trans.x:=Round(testedWobjs{i}.uframe.trans.x\Dec:=3);
           testedWobjs{i}.uframe.trans.y:=Round(testedWobjs{i}.uframe.trans.y\Dec:=3);
           testedWobjs{i}.uframe.trans.z:=Round(testedWobjs{i}.uframe.trans.z\Dec:=3);
           testedWobjs{i}.uframe.rot.q1:=Round(testedWobjs{i}.uframe.rot.q1\Dec:=3);
           testedWobjs{i}.uframe.rot.q2:=Round(testedWobjs{i}.uframe.rot.q2\Dec:=3);
           testedWobjs{i}.uframe.rot.q3:=Round(testedWobjs{i}.uframe.rot.q3\Dec:=3);
           testedWobjs{i}.uframe.rot.q4:=Round(testedWobjs{i}.uframe.rot.q4\Dec:=3);           
        ENDFOR
        !porownujemy ze soba trans i rot
        IF testedWobjs{1}.uframe.trans=testedWobjs{2}.uframe.trans transOK:=TRUE;
        IF testedWobjs{1}.uframe.rot=testedWobjs{2}.uframe.rot rotOK:=TRUE;
        
        result:=transOK AND rotOK;
        
        RETURN result;
    ENDFUNC    

    PROC cleanParamBuffers()
        paramBool:=[FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,
                    FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE];
        paramByte:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
        paramFloat:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
        paramInt:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
        paramPose:=[[[0,0,0],[0,0,0,0]],[[0,0,0],[0,0,0,0]],[[0,0,0],[0,0,0,0]],[[0,0,0],[0,0,0,0]],[[0,0,0],[0,0,0,0]],
                    [[0,0,0],[0,0,0,0]],[[0,0,0],[0,0,0,0]],[[0,0,0],[0,0,0,0]],[[0,0,0],[0,0,0,0]],[[0,0,0],[0,0,0,0]],
                    [[0,0,0],[0,0,0,0]],[[0,0,0],[0,0,0,0]],[[0,0,0],[0,0,0,0]],[[0,0,0],[0,0,0,0]],[[0,0,0],[0,0,0,0]],
                    [[0,0,0],[0,0,0,0]],[[0,0,0],[0,0,0,0]],[[0,0,0],[0,0,0,0]],[[0,0,0],[0,0,0,0]],[[0,0,0],[0,0,0,0]]];
        paramWobj:=[[FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]],[FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]],
                    [FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]],[FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]],
                    [FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]],[FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]],
                    [FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]],[FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]],
                    [FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]],[FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]],
                    [FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]],[FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]],
                    [FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]],[FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]],
                    [FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]],[FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]],
                    [FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]],[FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]],
                    [FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]],[FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]]];
    ENDPROC

    !funkcja sluzaca do rozpakowywania parametrow przesylanych w commandPacku (AVS2)
    ! ret: bool - czy udalo sie rozpakowac parametry
    FUNC bool unpackProcParams(num count,\INOUT bool boolean{*},\INOUT byte bajt{*},\INOUT num integer{*},\INOUT num float{*},\INOUT pose poz{*},\INOUT wobjdata wobj{*})
        VAR bool result:=TRUE;
        VAR num noOfParams:=-1;
        VAR byte procParamID;
        VAR byte currentParamType;
        VAR num boolSize:=0;
        VAR num bajtSize:=0;
        VAR num integerSize:=0;
        VAR num floatSize:=0;
        VAR num pozSize:=0;
        VAR num wobjSize:=0;
        VAR string head:="";
        VAR string descrLine1:="";
        VAR string descrLine2:="";
        VAR string descrLine3:="";
        VAR string descrLine4:="";        

        !sprawdzamy ile parametrow       
        noOfParams:=unpackINT();
        IF noOfParams=count THEN
        		head:="UNPACK PARAMS ["+NumToStr(noOfParams,0)+"]";
            FOR i FROM 1 TO noOfParams DO
                procParamID:=unpackBYTE();
                ! sprawdzenie, czy przeslano parametry
                IF procParamID=RCBC_addProcParam THEN
                    !rozpakowujemy bajt z informacja o typie parametru
                    currentParamType:=unpackBYTE();
                    !UDCT_Bool = 0
                    IF Present(boolean)AND currentParamType=0 THEN
                        IF Dim(boolean,1)>boolSize THEN
                            boolean{boolSize+1}:=unpackBOOL();
                            Incr boolSize;
                        ELSE
                            result:=FALSE;
                            TPWrite "Za malo miejsca na BOOL!";
                        ENDIF
                    ENDIF
                    !UDCT_Byte = 1
                    IF Present(bajt)AND currentParamType=1 THEN
                        IF Dim(bajt,1)>bajtSize THEN
                            bajt{bajtSize+1}:=unpackBYTE();
                            Incr bajtSize;
                        ELSE
                            result:=FALSE;
                            TPWrite "Za malo miejsca na BAJT!";
                        ENDIF
                    ENDIF
                    !UDCT_Int = 2
                    IF Present(integer)AND currentParamType=2 THEN
                        IF Dim(integer,1)>integerSize THEN
                            integer{integerSize+1}:=unpackINT();
                            Incr integerSize;
                        ELSE
                            result:=FALSE;
                            TPWrite "Za malo miejsca na INTEGER!";
                        ENDIF
                    ENDIF
                    !UDCT_Float = 3 
                    IF Present(float)AND currentParamType=3 THEN
                        IF Dim(float,1)>floatSize THEN
                            float{floatSize+1}:=unpackNUM();
                            Incr floatSize;
                        ELSE
                            result:=FALSE;
                            TPWrite "Za malo miejsca na FLOAT!";
                        ENDIF
                    ENDIF
                    !UDCT_Pose = 11
                    IF Present(poz)AND currentParamType=11 THEN
                        IF Dim(poz,1)>pozSize THEN
                            poz{pozSize+1}:=unpackPOSE();
                            Incr pozSize;
                        ELSE
                            result:=FALSE;
                            TPWrite "Za malo miejsca na POSE!";
                        ENDIF
                    ENDIF
                    !UDCT_Workobject = 20
                    IF Present(wobj)AND currentParamType=20 THEN
                        IF Dim(wobj,1)>wobjSize THEN
                            wobj{wobjSize+1}:=unpackWOBJ();
                            Incr wobjSize;
                        ELSE
                            result:=FALSE;
                            TPWrite "Za malo miejsca na WOBJ!";
                        ENDIF
                    ENDIF
                ENDIF
            ENDFOR
        ELSE
            result:=FALSE;
            TPWrite "Nie odczytano zadanej liczby parametrow!";
        ENDIF
        !logujemy odpowiednia informacje
        !ErrWrite\I,head,descrLine1\RL2:=descrLine2\RL3:=descrLine3\RL4:=descrLine4;

        RETURN result;
    ENDFUNC

    !procedura do odbierania parametrow przesylanych z AVS2 bez command packa
    PROC setProcParams()
        VAR bool result:=TRUE;
        VAR byte currentParamType;

        currentParamType:=unpackBYTE();
        !UDCT_Bool = 0
        IF currentParamType=0 THEN
            paramBool{readParamIterator{1}}:=unpackBOOL();
            Incr readParamIterator{1};
        ENDIF
        !UDCT_Byte = 1
        IF currentParamType=1 THEN
            paramByte{readParamIterator{2}}:=unpackBYTE();
            Incr readParamIterator{2};
        ENDIF
        !UDCT_Int = 2
        IF currentParamType=2 THEN
            paramInt{readParamIterator{3}}:=unpackINT();
            Incr readParamIterator{3};
        ENDIF
        !UDCT_Float = 3 
        IF currentParamType=3 THEN
            paramFloat{readParamIterator{4}}:=unpackNUM();
            Incr readParamIterator{4};
        ENDIF
        !UDCT_Pose = 11
        IF currentParamType=11 THEN
            paramPose{readParamIterator{5}}:=unpackPOSE();
            Incr readParamIterator{5};            
        ENDIF
        !UDCT_Workobject = 20
        IF currentParamType=20 THEN
            paramWobj{readParamIterator{6}}:=unpackWOBJ();
            Incr readParamIterator{6};            
        ENDIF
    ENDPROC
    
    !procedura do odbierania parametrow przesylanych z AVS2 bez command packa
    PROC getProcResult()
        VAR bool result:=TRUE;
        VAR byte currentParamType;

        currentParamType:=unpackBYTE();
        !UDCT_Bool = 0
        IF currentParamType=0 THEN
            packBOOL(paramBool{getResultsIterator{1}});
            Incr getResultsIterator{1};
            Incr resultsReaded;
        ENDIF
        !UDCT_Byte = 1
        IF currentParamType=1 THEN
            packBYTE(paramByte{getResultsIterator{2}});
            Incr getResultsIterator{2};
            Incr resultsReaded;
        ENDIF
        !UDCT_Int = 2
        IF currentParamType=2 THEN
            packINT(paramInt{getResultsIterator{3}});
            Incr getResultsIterator{3};
            Incr resultsReaded;
        ENDIF
        !UDCT_Float = 3 
        IF currentParamType=3 THEN
            packNUM(paramFloat{getResultsIterator{4}});
            Incr getResultsIterator{4};
            Incr resultsReaded;
        ENDIF
        !UDCT_Pose = 11
        IF currentParamType=11 THEN
            packPOSE(paramPose{getResultsIterator{5}});
            Incr getResultsIterator{5};
            Incr resultsReaded;
        ENDIF
        !UDCT_Workobject = 20
        IF currentParamType=20 THEN
            packWOBJ(paramWobj{getResultsIterator{6}});
            Incr getResultsIterator{6};
            Incr resultsReaded;
        ENDIF
    ENDPROC

    !procedura do resetowania zmiennych odczytywania rezultatow funkcji
    PROC cleanProcResults()
        !===========================================
        !czyscimy bufor odczytanych rezultatow BOOL
        IF getResultsIterator{1}>1 THEN
            !przesuwamy nieodczytane wartosci na poczatek bufora
            FOR i FROM getResultsIterator{1}TO Dim(paramBool,1) DO
                paramBool{i-(getResultsIterator{1}-1)}:=paramBool{i};
            ENDFOR
            !koncowke uzupelniamy FALSE
            FOR i FROM (Dim(paramBool,1)-getResultsIterator{1})+2 TO Dim(paramBool,1) DO
                paramBool{i}:=FALSE;
            ENDFOR
        ENDIF
        !===========================================
        !czyscimy bufor odczytanych rezultatow BYTE
        IF getResultsIterator{2}>1 THEN
            !przesuwamy nieodczytane wartosci na poczatek bufora
            FOR i FROM getResultsIterator{2}TO Dim(paramByte,1) DO
                paramByte{i-(getResultsIterator{2}-1)}:=paramByte{i};
            ENDFOR
            !koncowke uzupelniamy zerami
            FOR i FROM (Dim(paramByte,1)-getResultsIterator{2})+2 TO Dim(paramByte,1) DO
                paramByte{i}:=0;
            ENDFOR
        ENDIF
        !===========================================
        !czyscimy bufor odczytanych rezultatow INT
        IF getResultsIterator{3}>1 THEN
            !przesuwamy nieodczytane wartosci na poczatek bufora
            FOR i FROM getResultsIterator{3}TO Dim(paramInt,1) DO
                paramInt{i-(getResultsIterator{3}-1)}:=paramInt{i};
            ENDFOR
            !koncowke uzupelniamy zerami
            FOR i FROM (Dim(paramInt,1)-getResultsIterator{3})+2 TO Dim(paramInt,1) DO
                paramInt{i}:=0;
            ENDFOR
        ENDIF
        !============================================
        !czyscimy bufor odczytanych rezultatow FLOAT
        IF getResultsIterator{4}>1 THEN
            !przesuwamy nieodczytane wartosci na poczatek bufora
            FOR i FROM getResultsIterator{4}TO Dim(paramFloat,1) DO
                paramFloat{i-(getResultsIterator{4}-1)}:=paramFloat{i};
            ENDFOR
            !koncowke uzupelniamy zerami
            FOR i FROM (Dim(paramFloat,1)-getResultsIterator{4})+2 TO Dim(paramFloat,1) DO
                paramFloat{i}:=0;
            ENDFOR
        ENDIF
        !===========================================
        !czyscimy bufor odczytanych rezultatow POSE
        IF getResultsIterator{5}>1 THEN
            !przesuwamy nieodczytane wartosci na poczatek bufora
            FOR i FROM getResultsIterator{5}TO Dim(paramPose,1) DO
                paramPose{i-(getResultsIterator{5}-1)}:=paramPose{i};
            ENDFOR
            !koncowke uzupelniamy zerowa pose
            FOR i FROM (Dim(paramPose,1)-getResultsIterator{5})+2 TO Dim(paramPose,1) DO
                paramPose{i}:=[[0,0,0],[1,0,0,0]];
            ENDFOR
        ENDIF
        !============================================
        !czyscimy bufor odczytanych rezultatow WOBJ
        IF getResultsIterator{6}>1 THEN
            !przesuwamy nieodczytane wartosci na poczatek bufora
            FOR i FROM getResultsIterator{6}TO Dim(paramWobj,1) DO
                paramWobj{i-(getResultsIterator{6}-1)}:=paramWobj{i};
            ENDFOR
            !koncowke uzupelniamy zerowym wobj
            FOR i FROM (Dim(paramWobj,1)-getResultsIterator{6})+2 TO Dim(paramWobj,1) DO
                paramWobj{i}:=[FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]];
            ENDFOR
        ENDIF
        !==================================================
        !na koniec ustawiamy defaultowe wartosci zmiennych
        getResultsIterator:=[1,1,1,1,1,1];
        resultsReaded:=0;
        startGetResults:=FALSE;
    ENDPROC    

    !procedura do testowania wysylania parametrow z AVS2
    PROC testProcParams()
        !parametry pomocznicze
        VAR bool updateOK;
        !parametry do odbioru
        VAR byte cuByte;
        VAR num cuNum;
        VAR pose cuPose;
        VAR wobjdata cuWObj;

        !pobranie parametrow
        updateOK:=unpackProcParams(6\boolean:=paramBool\bajt:=paramByte\integer:=paramInt\float:=paramFloat\poz:=paramPose\wobj:=paramWobj);
        IF updateOK THEN
            cuBool:=paramBool{1};
            TPWrite "Odebrano BOOL: "+ValToStr(cuBool);
            cuByte:=paramByte{1};
            TPWrite "Odebrano BYTE: "+ByteToStr(cuByte);
            cuNum:=paramInt{1};
            TPWrite "Odebrano INT: "+ValToStr(cuNum);
            cuNum:=paramFloat{1};
            TPWrite "Odebrano FLOAT: "+ValToStr(cuNum);
            aPose:=paramPose{1};
            TPWrite "Odebrano POSE: "+ValToStr(aPose);
            cuWObj:=paramWobj{1};
            TPWrite "Odebrano WOBJ: "+ValToStr(cuWObj);
        ENDIF
    ENDPROC
    
    !funkcja do odczytywania wartosci zmiennej robota przez AVS2
    ! ret: bool = czy znaleziono zmienna i poprawnie odczytano jej wartosc (TRUE)
    ! arg: varName - nazwa zmiennej ktorej wartosci szukamy
    ! arg: varType - typ zmiennej ktorej wartosci szukamy
    ! arg: sendToAVS - od razu wyslij odpowiedz do AVS2
    FUNC bool getVarVal(string varName,byte varType\switch sendToAVS)
        VAR bool result:=FALSE;
        VAR bool stateError:=FALSE;
        !zmienne tymczasowe do kryteriow wyszukiwania
        VAR string name;
        VAR datapos block;
        !obslugiwane typy zmiennych
        VAR bool boolVal;
        VAR byte byteVal;
        VAR num numVal;
        VAR pose poseVal;
        VAR robtarget robtVal;
        VAR wobjdata wobjVal;
        VAR tooldata toolVal;

        TEST varType
        CASE 0:
            !zmienna typu BOOL - definiujemy kryteria szukania
            SetDataSearch "bool"\Object:=varName;
            IF GetNextSym(varName,block\Recursive) THEN
                !znalezlismy szukana zmienna
                GetDataVal varName,boolVal;
                !jezeli nie bylo bledu to wszystko OK
                IF NOT stateError result:=TRUE;
            ENDIF
            !odsylamy znaleziony/zerowy bool (+ result)
            IF Present(sendToAVS) THEN
                packBYTE(BoolToByte(boolVal));
            ENDIF
        CASE 1:
            !zmienna typu BYTE - definiujemy kryteria szukania
            SetDataSearch "byte"\Object:=varName;
            IF GetNextSym(varName,block\Recursive) THEN
                !znalezlismy szukana zmienna
                GetDataVal varName,byteVal;
                !jezeli nie bylo bledu to wszystko OK
                IF NOT stateError result:=TRUE;
            ENDIF
            !odsylamy znaleziony/zerowy byte (+ result)
            IF Present(sendToAVS) THEN
                packBYTE(byteVal);
            ENDIF
        CASE 2:
            !zmienna typu INT - definiujemy kryteria szukania
            SetDataSearch "num"\Object:=varName;
            IF GetNextSym(varName,block\Recursive) THEN
                !znalezlismy szukana zmienna
                GetDataVal varName,numVal;
                !jezeli nie bylo bledu to wszystko OK
                IF NOT stateError result:=TRUE;
            ENDIF
            !odsylamy znaleziony/zerowy int (+ result)
            IF Present(sendToAVS) THEN
                packINT(numVal);
            ENDIF
        CASE 3:
            !zmienna typu FLOAT - definiujemy kryteria szukania
            SetDataSearch "num"\Object:=varName;
            IF GetNextSym(name,block\Recursive) THEN
                !znalezlismy szukana zmienna
                GetDataVal varName,numVal;
                !jezeli nie bylo bledu to wszystko OK
                IF NOT stateError result:=TRUE;
            ENDIF
            !odsylamy znaleziony/zerowy float (+ result)
            IF Present(sendToAVS) THEN
                packNUM(numVal);
            ENDIF
        CASE 11:
            !zmienna typu POSE - ustawiamy kryteria szukania
            SetDataSearch "pose"\Object:=varName;
            IF GetNextSym(varName,block\Recursive) THEN
                !znalezlismy szukana zmienna
                GetDataVal varName,poseVal;
                !jezeli nie bylo bledu to wszystko OK
                IF NOT stateError result:=TRUE;
            ENDIF
            !odsylamy znalezione pose (+ result)
            IF result AND Present(sendToAVS) THEN
                packPOSE(poseVal);
            ELSE
                !jezeli nie znaleziono POSE to szukamy ROBTARGET (dla AVS2 to samo)
                SetDataSearch "robtarget"\Object:=varName;
                IF GetNextSym(varName,block\Recursive) THEN
                    !zmienna typu POSE
                    GetDataVal varName,robtVal;
                    !jezeli nie bylo bledu to wszystko OK
                    IF NOT stateError result:=TRUE;
                ENDIF
                !odsylamy znaleziony/zerowy robt (+ result)
                IF Present(sendToAVS) THEN
                    packPOSE(poseVal);
                ENDIF
            ENDIF
        CASE 19:
            !zmienna typu TOOL- ustawiamy kryteria szukania
            SetDataSearch "tooldata"\Object:=varName;
            !szukamy w systemie wszystkich zmiennych pasujacych do zadanego kryterium
            IF GetNextSym(varName,block\Recursive) THEN
                !mamy zmienna spelniajaca warunki - pobieramy jej wartosc
                GetDataVal varName,toolVal;
                !jezeli nie bylo bledu to wszystko OK
                IF NOT stateError result:=TRUE;
            ENDIF
            !odsylamy znaleziony/zerowy tool (+ result)
            IF Present(sendToAVS) THEN
                packTOOL(toolVal);
            ENDIF
        CASE 20:
            !zmienna typu WOBJ - ustawiamy kryteria szukania
            SetDataSearch "wobjdata"\Object:=varName;
            !szukamy w systemie wszystkich zmiennych pasujacych do zadanego kryterium
            IF GetNextSym(varName,block\Recursive) THEN
                !mamy zmienna spelniajaca warunki - pobieramy jej wartosc
                GetDataVal varName,wobjVal;
                !jezeli nie bylo bledu to wszystko OK
                IF NOT stateError result:=TRUE;
            ENDIF
            !odsylamy znaleziony/zerowy wobj (+ result)
            IF Present(sendToAVS) THEN
                packWOBJ(wobjVal);
            ENDIF
        DEFAULT:
        ENDTEST

        RETURN result;
    ERROR
        TPWrite "ERROR::getVarVal [errno = "+NumToStr(ERRNO,0)+"]";
        stateError:=TRUE;
        TRYNEXT;
    ENDFUNC

    FUNC bool setVarVal(string varName,byte varType)
        VAR bool result:=FALSE;
        VAR string name;
        VAR datapos block;
        VAR byte byteVal;
        VAR bool boolVal;
        VAR num numVal;
        VAR pose poseVal;
        VAR robtarget robtVal;
        VAR robtarget tempVal;
        VAR tooldata toolVal;
        VAR wobjdata wobjVal;

        TEST varType
        CASE 0:
            !zmienna typu BOOL
            boolVal:=unpackBOOL();
            SetDataSearch "bool"\Object:=varName\PersSym\VarSym;
            WHILE GetNextSym(name,block\Recursive) DO
                SetDataVal varName,boolVal;
                result:=TRUE;
            ENDWHILE
        CASE 1:
            !zmienna typu BYTE
            byteVal:=unpackBYTE();
            SetDataSearch "byte"\Object:=varName\PersSym\VarSym;
            WHILE GetNextSym(name,block\Recursive) DO
                SetDataVal varName,byteVal;
                result:=TRUE;
            ENDWHILE
        CASE 2:
            !zmienna typu INT
            numVal:=unpackINT();
            SetDataSearch "num"\Object:=varName\PersSym\VarSym;
            WHILE GetNextSym(name,block\Recursive) DO
                SetDataVal varName,numVal;
                result:=TRUE;
            ENDWHILE
        CASE 3:
            !zmienna typu FLOAT
            numVal:=unpackNUM();
            SetDataSearch "num"\Object:=varName\PersSym\VarSym;
            WHILE GetNextSym(name,block\Recursive) DO
                SetDataVal varName,numVal;
                result:=TRUE;
            ENDWHILE
        CASE 11:
            !zmienna typu POSE
            poseVal:=unpackPOSE();
            SetDataSearch "pose"\Object:=varName\PersSym\VarSym;
            WHILE GetNextSym(name,block\Recursive) DO
                SetDataVal varName,poseVal;
                result:=TRUE;
            ENDWHILE
            !jezeli nie znaleziono POSE to szukamy ROBTARGET (dla AVS2 to samo)
            IF NOT result THEN
                !zmienna typu ROBTARGET
                robtVal:=poseToRobt(poseVal);
                SetDataSearch "robtarget"\Object:=varName\PersSym\VarSym;
                WHILE GetNextSym(name,block\Recursive) DO
                    !chcemy zmienic robtarget - pierw musimy go pobrac
                    GetDataVal varName,tempVal;
                    !zapamietujemy zewn osie i konfiguracje
                    robtVal.robconf:=tempVal.robconf;
                    robtVal.extax:=tempVal.extax;
                    !nastepnie podmieniamy pose w robt
                    SetDataVal varName,robtVal;
                    result:=TRUE;
                ENDWHILE
            ENDIF
        CASE 19:
            !zmienna typu TOOL
            toolVal:=unpackTOOL();
            SetDataSearch "tooldata"\Object:=varName\PersSym\VarSym;
            WHILE GetNextSym(name,block\Recursive) DO
                SetDataVal varName,toolVal;
                result:=TRUE;
            ENDWHILE
        CASE 20:
            !zmienna typu WOBJ
            wobjVal:=unpackWOBJ();
            SetDataSearch "wobjdata"\Object:=varName\PersSym\VarSym;
            WHILE GetNextSym(name,block\Recursive) DO
                SetDataVal varName,wobjVal;
                result:=TRUE;
            ENDWHILE
        DEFAULT:
        ENDTEST

        RETURN result;
    ENDFUNC    
ENDMODULE

