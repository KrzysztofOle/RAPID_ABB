MODULE GalantSpawRCalib
    !===========================================
    !====== ZMIENNE DO KALIBRACJI TOOLA ========
    !===========================================

    !pozycja startowa kalibracji toola (w katach, dlatego nie wazne jakim toolem i wobj, zewn osi tez nie podajemy)
    PERS jointtarget calibStart:=[[-109.934,5.25399,5.00959,58.722,22.4838,-64.4582],[179.995,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS jointtarget overCalibStart:=[[-117.48,8.71354,-6.5234,53.2091,33.2298,-59.176],[179.999,9E+09,9E+09,9E+09,9E+09,9E+09]];
    !zmienne wyliczane podczas wykonywania kalibracji toola (musza byc globalne bo do jezdzenia wymagany jest PERS!)
    PERS tooldata calibTool:=[TRUE,[[39.6411,-0.0803447,415.175],[0.825601,-0.00204298,0.564249,0.00143596]],[1,[0.1,0.1,0.1],[1,0,0,0],0,0,0]];
    PERS wobjdata calibWobj:=[FALSE,TRUE,"",[[-384.581,-1193.04,895.853],[0.71128,-0.000686474,-0.00387087,-0.702898]],[[0,0,0],[1,0,0,0]]];
    !zmienne wewnetrzne
    CONST num lower:=1;
    CONST num upper:=2;
    !ustawienia sygnalow kalibracji toola (signalRise - szukanie ok gdy przejscie sygnalu 0 -> 1)
    VAR signaldi searchSignal;
    VAR string signalName:="RR_calibFork";
    PERS bool signalRise:=TRUE;
    !ile pozycji szukania dla korekty XY (obrot wokol osi Z: TYLKO NIEPARZYSTE - min. 3)
    CONST num posesNoXY:=3;
    !ile pozycji szukania dla korekty Z (pochylenie od osi X: TYLKO PARZYSTE - min. 2)
    CONST num posesNoZ:=2;
    !ile razy powtarzamy szukanie punktu przeciecia z wiazka
    CONST num searchTotalNo:=2;
    !ustawienia minimalnej i obecnej srednicy kalibrowanej koncowki palnika
    CONST num minDiameter:=0.2;
    PERS num toolDiameter:=8.66119;
    !ustawienia pochylen podczas kalibracji 
    PERS num angleRotZ:=45;
    PERS num angleSlope:=30;
    !ustawienia ruchow podczas kalibracji
    PERS num safeZ:=100;
    PERS num deltaUp:=15;
    PERS num deltaFast:=20;
    PERS num deltaSlow:=10;
    !ustawienia predkosci podczas kalibracji
    PERS speeddata calibTorchProcess:=[200,30,100,100];
    PERS speeddata calibTorchFast:=[25,30,10,10];
    PERS speeddata calibTorchSlow:=[2.5,30,10,10];

    !===========================================
    !==== ZMIENNE DO KALIBRACJI OBROTNIKA ======
    !===========================================

    !------ ZMIENNE OGOLNE
    PERS wobjdata calibRotatorWobj:=[FALSE,TRUE,"",[[1046.15,490.941,-129.034],[0.501416,0.498597,0.499592,-0.500391]],[[0,0,0],[1,0,0,0]]];
    VAR speeddata calibRotatorProcess:=[10,10,100,100];
    PERS bool calibDeviceOnRotator:=FALSE;
    !ile punktow kalibracji
    PERS num calibPts:=5;
    !jaki kat obrotu przy kalibracji automatycznej
    VAR num autoCalibAngleMin:=-60;
    VAR num autoCalibAngleMax:=40;
    !------ ZMIENNE POTRZEBNE DO KALIBRACJI AUTOMATYCZNEJ
    CONST jointtarget calibRotatorStartPos:=[[-1.17988,-67.9664,40.3017,-0.982726,49.186,0.554212],[0,9E+09,9E+09,9E+09,9E+09,9E+09]];
    !------ ZMIENNE POTRZEBNE DO KALIBRACJI MANUALNEJ
    VAR jointtarget actualRotatorPose;
    !punkty kalibracyjne
    VAR robtarget manualCalibPoints{10};
    VAR robtarget manualCalibPointZ;

    !===========================================
    !============ KALIBRACJA TOOLA =============
    !===========================================

    !procedura do kalibracji palnika w procesie auto (wolana z AVS2 + bez menu)
    PROC calibTorch()
        VAR bool calibResult:=FALSE;
        VAR jointtarget currJoint;
        VAR num backupWireLen:=-1;

        !wlaczamy zolta diode
        towerWarning\running;
        !zapamietujemy obecnie ustawiona dlugosc drutu
        backupWireLen:=currentWireLength;
        !zapamietujemy pozycje obrotnika
        currJoint:=CJointT();
        cleanTorchBasePos.extax:=currJoint.extax;
        cleanTorchPassPos.extax:=currJoint.extax;
        !podjezdzamy robotem (bez obrotnika) do pozycji domowej
        robSpawGoToHome FALSE;
        !przygotowujemy palnik do kalibracji
        froniusInspectTorch\singleAction:="ZDEJMIJ DYSZE PALNIKA I PRZYTNIJ DRUT NA 12mm",FALSE;
        restoreTorchTool;
        !wireCut\skipHomePos;
        !zaczynamy kalibracje narzedzia
        calibResult:=calibTorchMain(\autoAction:=2,torchToolOriginal);
        !po skonczeniu kalibracji przywracamy palnik do poprzedniego stanu
        froniusInspectTorch\singleAction:="ZALOZ DYSZE PALNIKA",FALSE;
        modifyTorchTool backupWireLen;
!        wireCut\skipHomePos;
        !wracamy do pozycji domowej (przez pozycje posrednia + bez obrotnika)       
        MoveAbsJ cleanTorchPassPos,robSpawSpeedFast,fine,tool0;
        robSpawGoToHome FALSE;
        !ustawiamy wynik do avs
        paramBool{1}:=calibResult;
        !wylaczamy zolta diode
        towerWarning\off;
    ENDPROC

    !glowna funkcja do kalibracji narzedzia na stanowisku robSpaw
    ! ret: bool = czy udalo sie poprawnie skalibrowac (TRUE) czy nie (FALSE)
    ! arg: autoAction - numer akcji ktora ma sie wykonac automatycznie (bez pytan do usera)
    ! arg: tool - jaki toolem chcemy skalibrowac
    LOCAL FUNC bool calibTorchMain(\num autoAction,INOUT tooldata tool)
        VAR bool result:=FALSE;
        !czy byla proba kalibrowania narzedzia
        VAR bool calibTry:=FALSE;
        VAR bool alwaysShowMenu:=TRUE;
        !zmienne wewnetrzne
        VAR num rotZ:=0.1;
        VAR robtarget calibStartPos;
        !zmienne do menu wyboru trybu kalibracji
        VAR btnres action:=-1;
        VAR string header:="TORCH CALIBRATION";
        VAR string message{5}:=["Co robimy?","FULL - pelna kalibracja","CORR - korekta narzedzia",stEmpty,stEmpty];
        VAR string buttons{5}:=["FULL","CORR","ROT Z","SETTINGS","EXIT"];
        VAR pose deltaTCP;
        VAR pos deltaAngles;


        !jedziemy nad pozycje startowa kalibracji (przez pozycje posrednia)
        MoveAbsJ cleanTorchBasePos,robSpawSpeedFast,fine,tool0;
        !tworzymy kopie toola ktora bedziemy modyfikowac
        calibTool:=tool;
        !wyliczamy globalnie wobj w ktorym bedziemy sie poruszac (wobj0->cleaningStation->uSensor)
        calibWobj.uframe:=PoseMult(cleaningStation.uframe,uSensor.uframe);
        !wyliczamy pozycje startowa w tym wobj
        WaitTime\InPos,0;
        calibStartPos:=CalcRobt(calibStart,calibTool\Wobj:=calibWobj);
        calibStartPos.extax:=readEax();
        !obsluga GUI
        WHILE action<>5 DO
            !sprawdzamy parametr opcjonalny - jezeli jest to z automatu jedziemy wybrana funkcje
            IF NOT Present(autoAction) THEN
                !jezeli byla proba kalibracji to sprawdzamy czy sie udala czy nie i wyswietlamy komunikat
                IF calibTry THEN
                    IF result THEN
                        message{5}:="Ostatnia kalibracja OK!";
                        buttons{5}:="DALEJ";
                    ELSE
                        message{5}:="Ostatnia kalibracjia NIEUDANA...";
                        buttons{5}:="EXIT";
                    ENDIF
                ENDIF
                !nie ma zdefiniowanej auto-akcji dlatego komunikat dla usera
                action:=UIMessageBox(\Header:=header\MsgArray:=message\BtnArray:=buttons);
            ELSE
                IF autoAction<3 action:=autoAction;
            ENDIF
            !wykonujemy wybrana operacje
            IF action=1 THEN
                !FULL - pelna kalibracja
                calibTry:=TRUE;
                result:=calibTorchAlgorithm(\full,calibStartPos,calibTool,calibWobj);
            ELSEIF action=2 THEN
                !CORR - korekta narzedzia
                calibTry:=TRUE;
                result:=calibTorchAlgorithm(\corr,calibStartPos,calibTool,calibWobj);
            ELSEIF action=3 THEN
                !ROT Z - obrot definicji narzedzia o odpowiedni kat
                WHILE rotZ<>0 DO
                    rotZ:=UINumEntry(\Header:="ROT Z"\Message:="Input rotation angle [EXIT=0]:"\InitValue:=rotZ\MinValue:=-10\MaxValue:=10);
                    calibTool:=calibTorchCorrTool(calibTool,0,0,0,0,0,rotZ);
                    MoveJ calibStartPos,calibTorchProcess,fine,calibTool\WObj:=calibWobj;
                ENDWHILE
                !przywracamy wartosc domyslna zeby jeszcze moc wejsc do tego menu
                rotZ:=0.1;
            ELSEIF action=4 THEN
                !SETTINGS - ustawienia
                calibTorchSettings;
            ENDIF
            !jezeli byla akcja automatyczna to od razu wychodzimy
            IF Present(autoAction) action:=5;
        ENDWHILE
        !koniec kalibracji - sprawdzamy czy sie udala
        IF result THEN
            !kalibracja sie udala - zastepujemy narzedzie (oraz robimy kopie poprzedniego)
            IF NOT Present(autoAction) OR alwaysShowMenu=TRUE THEN
                !wyswietlamy komunikat dla usera z decyzja czy nadpisac czy nie
                message{1}:="Update tool definition?";
                message{2}:=" OLD DEF: "+writePose(tool.tframe\precision:=4);
                message{3}:=" NEW DEF: "+writePose(calibTool.tframe\precision:=4);
                deltaTCP:=PoseMult(PoseInv(tool.tframe),calibTool.tframe);   
                message{4}:=" DELTA TCP:"+writePose(deltaTCP\precision:=4);
                deltaAngles.x:=EulerZYX(\X, deltaTCP.rot);
                deltaAngles.y:=EulerZYX(\Y, deltaTCP.rot);
                deltaAngles.z:=EulerZYX(\Z, deltaTCP.rot);
                message{5}:="       ANG:"+writePos(deltaAngles\precision:=4)+" deg";
                action:=UIMessageBox(\Header:="CALIB OK!"\MsgArray:=message\Buttons:=btnYesNo);
                IF action=resYes THEN
                    IF backupData("toolCalib.txt"\tool:=tool) tool:=calibTool;
                ENDIF
            ELSE
                IF backupData("toolCalib.txt"\tool:=tool) tool:=calibTool;
            ENDIF
        ENDIF
        !po wszystkim wracamy do pozycji przy stacji czyszczenia palnika
        MoveAbsJ cleanTorchBasePos,robSpawSpeedFast,fine,tool0;

        RETURN result;
    ENDFUNC

    !podstawowa funkcja do kalibracji palnika na czujniku widelkowym
    ! ret: bool = czy udalo sie poprawnie skalibrowac narzedzie (TRUE) czy nie (FALSE)
    ! arg: full - czy wykonac pelna kalibracje (ze wstepnie zdefiniowanym narzedziem)
    ! arg: corr - czy wykonac korekte definicji narzedzia (tylko X i Y)
    ! arg: startCalibRobt - pozycja poczatkowa kalibracji
    ! arg: tool - narzedzie ktorym sie poruszamy i ktore jednoczesnie jest kalibrowane
    ! arg: wobj - uklad wspolrzednych w ktorym sie poruszamy (wobj czujnika widelkowego)
    LOCAL FUNC bool calibTorchAlgorithm(\switch full|switch corr,robtarget startCalibRobt,INOUT tooldata tool,PERS wobjdata wobj)
        VAR bool result:=FALSE;

        !sprawdzamy czy wybrano dobry tryb kalibracji (pelna lub korekta
        IF Present(full) OR Present(corr) THEN
            !ustawienia poczatkowe
            AccSet 10,10;
            ConfJ\Off;
            ConfL\Off;
            !ustawiamy alias sygnalu 
            AliasIO signalName,searchSignal;
            !sprawdzamy przewidywana orientacje narzedzia wzgledem kalibratora
            IF NOT calibTorchCheckPos(startCalibRobt\corrTool:=tool) THEN
                ErrWrite "ERROR::calibTorch","Wrong start pos orient!"\RL2:="Check previous logs for details.";
                RETURN result;
            ENDIF
            !pozycja startowa jest ok mozemy nad nia podjechac
            MoveL Offs(startCalibRobt,0,0,safeZ),calibTorchProcess,z0,tool\WObj:=wobj;
            !teraz sprawdzamy czy kalibrator fizycznie nie jest przesuniety od definicji wobj
            IF NOT calibTorchCheckSensor(startCalibRobt,tool,wobj) THEN
                ErrWrite "ERROR::calibTorch","Fork sensor orient out of range!"\RL2:="Check previous logs for details.";
                RETURN result;
            ENDIF
            !--> w tym miejscu jest wszystko dobrze ustawione
            !kalibracja X i Y
            result:=calibTorchXY(startCalibRobt,tool,wobj,Present(corr));
            IF NOT result THEN
                ErrWrite "ERROR::calibTorch","Cant correct tool XY!"\RL2:="Check previous logs for details.";
            ELSE
                IF NOT Present(corr) THEN
                    !kalibracja Z - tylko gdy udala sie wczesniejsza czesc i jest wybrana opcja FULL 
                    result:=calibTorchZ(startCalibRobt,tool,wobj,Present(corr));
                    IF NOT result ErrWrite "ERROR::calibTorch","Cant correct tool Z!"\RL2:="Check previous logs for details.";
                ELSE    
                    ErrWrite \I,"GalantSpawRCalib::calibTorchAlgorithm pomijamy Z","Pomjamy korekte Z"; 
                ENDIF
            ENDIF
            !po wszystkim wracamy do pozycji nad start kalibracji
            MoveL Offs(startCalibRobt,0,0,safeZ),calibTorchProcess,z0,tool\WObj:=wobj;
        ELSE
            ErrWrite "ERROR::calibTorch","Undefined calibrate mode..."\RL2:="Check your code and select full or corr.";
        ENDIF

        RETURN result;
    ENDFUNC

    !funkcja do sprawdzania orientacji narzedzia do kalibracji
    ! ret: bool = orientacja jest poprawna (TRUE) lub nie (FALSE)
    ! arg: checkRobT - pozycja ktorej orientacje bedziemy sprawdzac
    ! arg: corrTool - czy od razu chcemy wstepnie poprawic toola zeby orient byl ok
    LOCAL FUNC bool calibTorchCheckPos(INOUT robtarget checkRobT\tooldata corrTool)
        VAR bool result:=FALSE;
        VAR pose corrPose;
        VAR pos vecTemp;
        VAR num angleY;
        VAR num angleZ;

        !sprawdzamy osie Y i Z toola (Y zgodna z wobj, Z przeciwna)
        vecTemp:=-poseToVec(robtToPose(checkRobT)\Y);
        angleY:=angleBetweenVectors(vecTemp,[0,1,0]);
        vecTemp:=-poseToVec(robtToPose(checkRobT)\Z);
        angleZ:=angleBetweenVectors(vecTemp,[0,0,1]);
        !zwracamy rezultat
        result:=Abs(angleY)<5 AND Abs(angleZ)>175;
        !sprawdzamy czy od razu poprawic definicje toola
        IF NOT result AND Present(corrTool) THEN
            corrTool:=calibTorchCorrTool(corrTool,0,0,0,0,angleY,angleZ);
            result:=TRUE;
        ENDIF

        RETURN result;
    ENDFUNC

    !funkcja do sprawdzania jak fizycznie przebiega wiazka czujnika widelkowego
    ! ret: bool = czy orientacja wiazki czujnika jest w zakresie dopusczalnym (TRUE) czy nie (FALSE)
    ! arg: calibRobt - pozycja kalibracyjna, ktora zostanie poprawiona tak by jej os Y byla rownolegla do wiazki
    ! arg: tool - narzedzie ktorym jezdzimy 
    ! arg: wobj - uklad wsporzednych w ktorym sie poruszamy
    LOCAL FUNC bool calibTorchCheckSensor(INOUT robtarget calibRobt,PERS tooldata tool,PERS wobjdata wobj)
        VAR bool result:=FALSE;
        VAR robtarget posLeft{2};
        VAR robtarget posRight{2};
        VAR num offset:=10;
        VAR num diffAngle:=0;
        VAR num maxAngle:=10;
        VAR pos vecOriginal;
        VAR pos vecCurrent;

        !definiujemy pozycje startowa po lewej stronie i szukamy punktu przeciecia
        posLeft{1}:=RelTool(calibRobt,0,offset,0);
        posLeft{2}:=calibTorchSearchPos(posLeft{1},\X,tool,wobj,signalRise);
        IF posLeft{2}=zeroRobt RETURN result;
        !definiujemy pozycje startowa po prawej stronie i szukamy punktu przeciecia
        posRight{1}:=RelTool(calibRobt,0,-offset,0);
        posRight{2}:=calibTorchSearchPos(posRight{1},\X,tool,wobj,signalRise);
        IF posRight{2}=zeroRobt RETURN result;
        !z tych czterech punktow wyznaczamy kat wiazki sensora w danym wobj
        vecOriginal:=calcVector(posLeft{1}.trans,posRight{1}.trans);
        vecCurrent:=calcVector(posLeft{2}.trans,posRight{2}.trans);
        diffAngle:=angleBetweenVectors(vecCurrent,vecOriginal);
        !sprawdzamy czy kat jest dopuszczalny
        IF Abs(diffAngle)<maxAngle THEN
            !na koniec modyfikujemy pozycje startowa
            calibRobt:=RelTool(calibRobt,0,0,0\Rz:=diffAngle);
            result:=TRUE;
        ELSE
            ErrWrite\W,"ERROR::checkSensorOrient","Current orient: "+NumToStr(diffAngle,3)+" > "+NumToStr(maxAngle,3);
        ENDIF

        RETURN result;
    ENDFUNC

    !funkcja do kalibracji osi X i Y palnika na czujniku widelkowym
    ! ret: bool = czy udalo sie poprawnie skalibrowac narzedzie (TRUE) czy nie (FALSE)
    ! arg: startCalibRobt - pozycja poczatkowa kalibracji
    ! arg: tool - narzedzie ktorym sie poruszamy i ktore jednoczesnie jest kalibrowane
    ! arg: wobj - uklad wspolrzednych w ktorym sie poruszamy (wobj czujnika widelkowego)
    ! arg: onlyCorr - czy wykonac tylko korekte narzedzia (TRUE) czy pelna kalibracje (FALSE)
    LOCAL FUNC bool calibTorchXY(robtarget startCalibRobt,INOUT tooldata tool,PERS wobjdata wobj,bool onlyCorr)
        VAR bool result:=FALSE;
        !zmienne do obliczania pozycji startowych
        VAR num currRotZ:=0;
        VAR num currPartZ:=0;
        VAR num zeroAnglePos:=0;
        !pozycje startowe szukania {nrPozycji,lower/upper}
        VAR robtarget posCalc{posesNoXY,posesNoXY};
        !pozycje znalezione srodka kalibrowanej koncowki roboczej {nrPozycji,lower/upper}
        VAR robtarget posFound{posesNoXY,posesNoXY};

        !musimy miec nieparzysta liczbe punktow by wyznaczyc pozycje z zerowym katem
        IF posesNoXY MOD 2<>0 THEN
            !budujemy pozycje startowe szukania
            FOR i FROM 1 TO posesNoXY DO
                !wyznaczamy obecny obrot wokol osi Z (zakres: -angleRotZ ... 0 ... angleRotZ)
                currPartZ:=(i-(Trunc(posesNoXY/2)+1))/Trunc(posesNoXY/2);
                currRotZ:=currPartZ*angleRotZ;
                IF currRotZ=0 zeroAnglePos:=i;
                !wyznaczamy teoretyczne pozycje srodka narzedzia do kalibracji
                posCalc{i,lower}:=RelTool(startCalibRobt,0,0,0\Rz:=currRotZ);
                posCalc{i,upper}:=RelTool(startCalibRobt,0,0,-deltaUp\Rz:=currRotZ);
            ENDFOR
            !----- szukamy dokladnych pozycji na podstawie wyliczonych -----
            !pierw pozycja bez zadnego kata wokol osi Z - jezeli jest to korekta to tylko pozycja gorna
            IF NOT onlyCorr posFound{zeroAnglePos,lower}:=calibTorchSearchPos(posCalc{zeroAnglePos,lower}\X,tool,wobj,signalRise);
            posFound{zeroAnglePos,upper}:=calibTorchSearchPos(posCalc{zeroAnglePos,upper}\X,tool,wobj,signalRise);
            !teraz jedziemy po pozycjach z obrotem wokol osi Z - jezeli jest to korekta to tylko pozycje gorne
            FOR i FROM 1 TO posesNoXY DO
                IF i<>zeroAnglePos THEN
                    IF NOT onlyCorr posFound{i,lower}:=calibTorchSearchPos(posCalc{i,lower}\Y,tool,wobj,signalRise);
                    posFound{i,upper}:=calibTorchSearchPos(posCalc{i,upper}\Y,tool,wobj,signalRise);
                    !podjezdzamy do pozycji nad punktem startowym calej kalibracji
                    MoveL Offs(CRobT(\Tool:=tool\WObj:=wobj),0,0,safeZ+100),calibTorchProcess,z0,tool\WObj:=wobj;
                    ConfJ\On;
                    MoveJ Offs(startCalibRobt,0,0,safeZ),calibTorchProcess,z0,tool\WObj:=wobj;
                    ConfJ\Off;
                    IF NOT onlyCorr MoveL startCalibRobt,calibTorchProcess,z0,tool\WObj:=wobj;
                ENDIF
            ENDFOR
            !korygujemy narzedzie na podstawie punktow obliczonch i znalezionych
            tool:=calibTorchCorrXY(tool,posCalc,posFound,zeroAnglePos,onlyCorr);
            !poprawiamy pozycje
            IF NOT onlyCorr MoveL startCalibRobt,calibTorchProcess,fine,tool\WObj:=wobj;
            !udalo sie skalibrowac narzedzie w XY
            result:=TRUE;
        ELSE
            ErrWrite\W,"ERROR::calibTorchXY","Variable 'posesNoXY' must be odd!";
        ENDIF

        RETURN result;
    ENDFUNC

    !funkcja do korekty narzedzia w osiach X i Y (zarowno przesuniecia jak i katy)
    ! ret: tooldata = skorygowana definicja narzedzia w X i Y
    ! arg: tool - oryginalne narzedzie, ktore bedzie poprawiane
    ! arg: calc - tablica punktow wyliczonych z aktualnej definicji narzedzia {lower,upper}
    ! arg: found - tablica punktow wyznaczonych na podstawie przeciecia z czujnikiem widelkowym {lower,upper}
    ! arg: zeroPosNo - numer elementu w powyzszych tablicach o zerowej korekcie kata wokol osi Z
    ! arg: onlyCorr - czy wykonac tylko obliczenia dla korekty narzedzia (TRUE) czy dla pelnej kalibracji (FALSE)
    LOCAL FUNC tooldata calibTorchCorrXY(tooldata tool,robtarget calc{*,*},robtarget found{*,*},num zeroPosNo,bool onlyCorr)
        VAR tooldata result;
        !zmienne do korekty narzedzia
        VAR pos corrPosC;
        VAR pos corrPosL;
        VAR pos corrPosR;
        VAR num angleX;
        VAR num angleY;
        VAR num corrX;
        VAR num corrY;

        !sprawdzamy czy pelna kalibracja XY czy tylko korekta polozenia
        IF NOT onlyCorr THEN
            !poprawiamy przesuniecie X
            corrX:=(((found{1,lower}.trans.x+found{posesNoXY,lower}.trans.x)/2-found{zeroPosNo,lower}.trans.x)+
                     ((found{1,upper}.trans.x+found{posesNoXY,upper}.trans.x)/2-found{zeroPosNo,upper}.trans.x))/2;
            !poprawiamy kat X         
            corrPosL:=(found{1,upper}.trans-calc{1,upper}.trans)-(found{1,lower}.trans-calc{1,lower}.trans);
            corrPosR:=(found{posesNoXY,upper}.trans-calc{posesNoXY,upper}.trans)-(found{posesNoXY,lower}.trans-calc{posesNoXY,lower}.trans);
            angleX:=(ATan2(corrPosL.x,safeZ)-ATan2(corrPosR.x,safeZ))/2;
            !poprawiamy przesuniecie Y
            corrY:=(((found{1,lower}.trans.x-found{posesNoXY,lower}.trans.x)/2)+
                     ((found{1,upper}.trans.x-found{posesNoXY,upper}.trans.x)/2))/2;
            !poprawiamy kat Y
            corrPosC:=((found{zeroPosNo,upper}.trans-calc{zeroPosNo,upper}.trans)-
                        (found{zeroPosNo,lower}.trans-calc{zeroPosNo,lower}.trans));
            angleY:=ATan2(corrPosC.x,safeZ);
            !logujemy stosowne informacje
            ErrWrite\I,"calib torch (XY)","Calculated corrections:"\RL2:="CORR X: "+NumToStr(corrX,3)+"[mm], CORR Y: "+NumToStr(corrY,3)+"[mm]"
                                                                   \RL3:="ANGLE X: "+NumToStr(angleX,3)+"[deg], CORR Y: "+NumToStr(angleY,3)+"[deg]";
            !wprowadzamy korekte
            result:=calibTorchCorrTool(tool,-corrX,corrY,0,-angleX,angleY,0);
        ELSE
            !wyliczamy i wprowadzamy korekte
            corrX:=((found{1,upper}.trans.x+found{posesNoXY,upper}.trans.x)/2-found{zeroPosNo,upper}.trans.x);
            corrY:=((found{1,upper}.trans.x-found{posesNoXY,upper}.trans.x)/2);
            !logujemy stosowne informacje
            ErrWrite\I,"calib torch (XY)","Calculated corrections:"\RL2:="CORR X: "+NumToStr(corrX,3)+"[mm], CORR Y: "+NumToStr(corrY,3)+"[mm]";
            result:=calibTorchCorrTool(tool,-corrX,corrY,0,0,0,0);
        ENDIF

        RETURN result;
    ENDFUNC

    !funkcja do kalibracji osi Z palnika na czujniku widelkowym
    ! ret: bool = czy udalo sie poprawnie skalibrowac narzedzie (TRUE) czy nie (FALSE)
    ! arg: startCalibRobt - pozycja poczatkowa kalibracji
    ! arg: tool - narzedzie ktorym sie poruszamy i ktore jednoczesnie jest kalibrowane
    ! arg: wobj - uklad wspolrzednych w ktorym sie poruszamy (wobj czujnika widelkowego)
    ! arg: onlyCorr - czy wykonac tylko korekte narzedzia (TRUE) czy pelna kalibracje (FALSE)
    LOCAL FUNC bool calibTorchZ(robtarget startCalibRobt,INOUT tooldata tool,PERS wobjdata wobj,bool onlyCorr)
        VAR bool result:=FALSE;
        !pozycje pomocnicze
        VAR robtarget startSearchPos;
        VAR robtarget torchZposition:=emptyRobt;
        VAR num zStep:=1;
        !pozycje startowe szukania {nrPozycji}
        VAR robtarget posCalc{posesNoZ};
        !pozycje znalezione srodka kalibrowanej koncowki roboczej {nrPozycji}
        VAR robtarget posFound{posesNoZ};
        !zmienne do obliczania pozycji startowych
        VAR num currPartX:=0;
        VAR num currRotX:=0;
        VAR num retryNo:=0;
        !zmienna tymczasowa
        VAR num temp;

        !musimy miec parzysta liczbe punktow bo zerowy kat wyznaczamy oddzielnie
        IF posesNoZ MOD 2=0 THEN
            !jedziemy do pozycji starowej 
            startSearchPos:=RelTool(startCalibRobt,0,0,-deltaUp);
            MoveL startSearchPos,calibTorchProcess,z0,tool\WObj:=wobj;
            !powtarzamy szukanie pozycji palnika w pozycji gornej
            WHILE torchZposition=emptyRobt AND retryNo<=5 DO
                torchZposition:=calibTorchSearchPos(startSearchPos\X,tool,wobj,signalRise);
                startSearchPos:=RelTool(startSearchPos,0,0,(retryNo+1)*zStep);
            ENDWHILE
            !sprawdzamy czy udalo sie znalezc pozycje
            IF torchZposition=emptyRobt THEN
                ErrWrite\W,"ERROR::calibTorchZ","Cant find torch X position!";
                RETURN result;
            ENDIF
            !szukanie polozenia TCP koncowki palnika
            torchZposition:=calibTorchSearchPos(torchZposition\Z,tool,wobj,NOT signalRise);
            !sprawdzamy czy udalo sie znalezc pozycje
            IF torchZposition=emptyRobt THEN
                ErrWrite\W,"ERROR::calibTorchZ","Cant find initial Z position!";
                RETURN result;
            ENDIF
            !sprawdzamy czy jest to pelna kalibracja czy tylko korekta
            IF NOT onlyCorr THEN
                !budujemy pozycje startowe szukania (odchylone wokol osi X) i od razu po nich jedziemy 
                FOR i FROM 1 TO posesNoZ DO
                    !wyznaczamy obecne pochylenie wokol osi X (zakres: -angleSlope ... angleSlope)  
                    currPartX:=-1+(i-1)*2/(posesNoZ-1);
                    currRotX:=currPartX*angleRotZ;
                    !wyznaczamy teoretyczne pozycje srodka narzedzia do kalibracji
                    posCalc{i}:=RelTool(torchZposition,0,0,1\Rx:=currRotX);
                    !szukamy dokladnych pozycji - pierw w osi X 
                    posFound{i}:=calibTorchSearchPos(posCalc{i}\X,tool,wobj,signalRise);
                    !teraz bedziemy jechac gora/dol, lecz w miejszym zakresie (ryzyko kolizji)
                    temp:=deltaUp;
                    deltaUp:=3;
                    posFound{i}:=calibTorchSearchPos(posFound{i}\Z,tool,wobj,signalRise);
                    !przywracamy oryginalne ustawienie parametru deltaUp
                    deltaUp:=temp;
                ENDFOR
            ENDIF
            !jezeli wszystko sie udalo to poprawiamy definicje Z narzedzia
            tool:=calibTorchCorrZ(tool,torchZposition,posFound,onlyCorr);
            !udalo sie skalibrowac os Z
            result:=TRUE;
        ELSE
            ErrWrite\W,"ERROR::calibTorchZ","Variable 'posesNoZ' must be even!";
        ENDIF

        RETURN result;
    ENDFUNC

    !funkcja do korekty narzedzia w osi Z (polozenie TCP)
    ! ret: tooldata = skorygowana definicja narzedzia w X i Y
    ! arg: tool - oryginalne narzedzie, ktore bedzie poprawiane
    ! arg: center - punkt bez zadnego odchylenia wyznaczony na podstawie przeciecia z wiazka
    ! arg: found - tablica punktow wyznaczonych na podstawie przeciecia z czujnikiem widelkowym {posNo}
    ! arg: onlyCorr - czy korygujemy tylko X i Y toola (TRUE) czy wykonujemy kompletna kalibracje (FALSE)
    LOCAL FUNC tooldata calibTorchCorrZ(tooldata tool,robtarget center,robtarget found{*},bool onlyCorr)
        VAR tooldata result;
        VAR num corrZ;
        VAR num numerator;
        VAR num denominator;

        !wyznaczamy kolejno: licznik, mianownik i ich iloraz jako finalna korekte
        IF NOT onlyCorr THEN
            numerator:=center.trans.z-(found{1}.trans.z+found{2}.trans.z)/2;
            denominator:=2*Pow(0.5*Cos(180-angleSlope),2);
        ELSE
            numerator:=center.trans.z;
            denominator:=1;
        ENDIF
        corrZ:=numerator/denominator;
        !logujemy stosowne informacje
        ErrWrite\I,"calib torch (Z)","Calculated correction:"\RL2:="CORR Z: "+NumToStr(corrZ,3)+"[mm]";
        !wprowadzamy korekte do definicji palnika
        result:=calibTorchCorrTool(tool,0,0,corrZ,0,0,0);

        RETURN result;
    ENDFUNC

    !funkcja do szukania pozycji przeciecia kalibrowanej koncowki z czujnikiem widelkowym
    ! ret: robtarget = pozycja przeciecia srodka koncowki i wiazki
    ! arg: startRobt - pozycja startowa od ktorej bedziemy szukac punktu przeciecia
    ! arg: X,Y,Z - wybrany kierunek szukania
    ! arg: tool - narzedzie robocze ktorym bedziemy sie poruszac
    ! arg: wobj - uklad wsporzedznych w ktorym jezdzimy robotem
    ! arg: sigRise - czy mamy reagowac na przejscie 0 -> 1 (TRUE) czy 1 -> 0 (FALSE)
    LOCAL FUNC robtarget calibTorchSearchPos(robtarget startRobt,\switch X|switch Y|switch Z,PERS tooldata tool,PERS wobjdata wobj,bool sigRise)
        VAR robtarget result;
        VAR robtarget limitPos{2};
        VAR robtarget foundPos{2};
        VAR speeddata currentSpeed:=[100,100,100,100];
        VAR num currentDelta:=0;
        VAR num toolFi:=0;

        !jedziemy do pozycji startowej szukania
        !MoveL startRobt,v200,z0,tool\WObj:=wobj;
        !SPRAWDZAMY JAKIEJ OSI SZUKAMY (inne bedzie szukanie w XY a inne w Z)
        IF Present(X) OR Present(Y) THEN
            !szukanie powtarzamy kilkukrotnie (domyslnie 2: szybko i wolno)
            FOR i FROM 1 TO searchTotalNo DO
                !wyliczamy obecne odsuniecie od pozycji
                currentDelta:=deltaFast-(i-1)*((deltaFast-deltaSlow)/(searchTotalNo-1))+toolFi/2;
                !wyliczamy obecna predkosc szukania
                currentSpeed.v_tcp:=calibTorchFast.v_tcp-(i-1)*((calibTorchFast.v_tcp-calibTorchSlow.v_tcp)/(searchTotalNo-1));
                !w zaleznosci od wyboru wyznaczamy skrajne pozycje szukania
                IF Present(X) THEN
                    limitPos{1}:=RelTool(startRobt,currentDelta,0,0);
                    limitPos{2}:=RelTool(startRobt,-currentDelta,0,0);
                ELSEIF Present(Y) THEN
                    limitPos{1}:=RelTool(startRobt,0,currentDelta,0);
                    limitPos{2}:=RelTool(startRobt,0,-currentDelta,0);
                ENDIF
                !jedziemy do punktu koncowego i szukamy w kierunku punktu poczatkowego
                MoveL limitPos{2},calibTorchProcess,fine,tool\WObj:=wobj;
                !sprawdzamy czy mamy reagowac na zbocze narastajace czy opadajace
                IF sigRise THEN
                    SearchL searchSignal\PosFlank,foundPos{1},limitPos{1},currentSpeed,tool\WObj:=wobj;
                ELSE
                    SearchL searchSignal\NegFlank,foundPos{1},limitPos{1},currentSpeed,tool\WObj:=wobj;
                ENDIF
                !jedziemy do punktu poczatkowego i szukamy w kierunku punktu koncowego
                MoveL limitPos{1},calibTorchProcess,fine,tool\WObj:=wobj;
                !sprawdzamy czy mamy reagowac na zbocze narastajace czy opadajace
                IF sigRise THEN
                    SearchL searchSignal\PosFlank,foundPos{2},limitPos{2},currentSpeed,tool\WObj:=wobj;
                ELSE
                    SearchL searchSignal\NegFlank,foundPos{2},limitPos{2},currentSpeed,tool\WObj:=wobj;
                ENDIF
                !sprawdzamy znaleziona srednice toola
                toolFi:=Distance(foundPos{1}.trans,foundPos{2}.trans);
                IF toolFi>minDiameter THEN
                    toolDiameter:=toolFi;
                ELSE
                    ErrWrite\W,"ERROR::calibSearchPos","Found tool diameter: "+NumToStr(toolFi,3)+" < "+NumToStr(minDiameter,3);
                    RETURN zeroRobt;
                ENDIF
                !wyznaczamy pozycje koncowa 
                result:=foundPos{1};
                result.trans.x:=(foundPos{1}.trans.x+foundPos{2}.trans.x)/2;
                result.trans.y:=(foundPos{1}.trans.y+foundPos{2}.trans.y)/2;
                result.trans.z:=(foundPos{1}.trans.z+foundPos{2}.trans.z)/2;
            ENDFOR
        ELSEIF Present(Z) THEN
            !wyznaczamy pozycje graniczne szukania
            limitPos{1}:=Offs(startRobt,0,0,-deltaUp);
            limitPos{2}:=Offs(startRobt,0,0,deltaUp+5);
            !jedziemy wolno
            currentSpeed:=calibTorchSlow;
            !sprawdzamy na jakie zbocze sygnalu mamy reagowac
            IF NOT sigRise THEN
                !jedziemy do punktu w ktorym powinno byc przeciecie wiazki
                MoveL limitPos{1},calibTorchProcess,fine,tool\WObj:=wobj;
                !szukamy zbocza opadajacego
                SearchL searchSignal\NegFlank,foundPos{2},limitPos{2},currentSpeed,tool\WObj:=wobj;
                !jedziemy do punktu w ktorym nie powinno byc przeciecia wiazki
                MoveL limitPos{2},calibTorchProcess,fine,tool\WObj:=wobj;
                !szukamy zbocza narastajacego
                SearchL searchSignal\PosFlank,foundPos{1},limitPos{1},currentSpeed,tool\WObj:=wobj;
            ELSE
                !jedziemy do punktu w ktorym nie powinno byc przeciecia wiazki
                MoveL limitPos{2},calibTorchProcess,fine,tool\WObj:=wobj;
                !szukamy zbocza narastajacego
                SearchL searchSignal\PosFlank,foundPos{1},limitPos{1},currentSpeed,tool\WObj:=wobj;
                !jedziemy do punktu w ktorym powinno byc przeciecie wiazki    
                MoveL limitPos{1},calibTorchProcess,fine,tool\WObj:=wobj;
                !szukamy zbocza opadajacego
                SearchL searchSignal\NegFlank,foundPos{2},limitPos{2},currentSpeed,tool\WObj:=wobj;
            ENDIF
            !wyznaczamy pozycje koncowa 
            result:=foundPos{1};
            result.trans.x:=(foundPos{1}.trans.x+foundPos{2}.trans.x)/2;
            result.trans.y:=(foundPos{1}.trans.y+foundPos{2}.trans.y)/2;
            result.trans.z:=(foundPos{1}.trans.z+foundPos{2}.trans.z)/2;
        ELSE
            ErrWrite\W,"ERROR::calibSearchPos","No search direction specified.";
            RETURN zeroRobt;
        ENDIF

        RETURN result;
    ERROR
        IF ERRNO=ERR_WHLSEARCH THEN
            ErrWrite\W,"ERROR::calibSearchPos","No signal detection or more than one signal detection on SearchL";
        ELSEIF ERRNO=ERR_SIGSUPSEARCH THEN
            ErrWrite\W,"ERROR::calibSearchPos","Bad signal state on SearchL start";
        ENDIF
        !podjezdzamy od obecnej pozycji do gory i zwracamy blad
        RETURN zeroRobt;
    ENDFUNC

    !procedura do ustawiania parametrow kalibracji
    LOCAL PROC calibTorchSettings()
        VAR btnres decision:=-1;
        VAR string buttons{5};
        VAR string message{5};

        WHILE decision<>5 DO
            !ustawienie odpowiednich buttonow i wiadomosci
            buttons:=["ANGLES","DISTANCES","SPEEDS","","BACK"];
            message:=["Select param group to change.","","","",""];
            !komunikat dla usera
            decision:=UIMessageBox(\Header:="CALIBRATION SETTINGS"\MsgArray:=message\BtnArray:=buttons);
            IF decision=1 THEN
                !wybrana opcja ANGLES
                WHILE decision<>5 DO
                    !ustawienie odpowiednich buttonow i wiadomosci
                    buttons:=["ROT Z","SLOPE","","","BACK"];
                    message:=["Select angle to change.","ROT Z: "+NumToStr(angleRotZ,1),"SLOPE: "+NumToStr(angleSlope,1),"",""];
                    !komunikat dla usera
                    decision:=UIMessageBox(\Header:="GROUP: ANGLES"\MsgArray:=message\BtnArray:=buttons);
                    IF decision=1 THEN
                        !wybrana opcja ROT Z
                        angleRotZ:=UINumEntry(\Header:="ANGLE ROT Z"\Message:="INPUT NEW VALUE"\InitValue:=angleRotZ\MinValue:=0\MaxValue:=90);
                    ELSEIF decision=2 THEN
                        !wybrana opcja SLOPE
                        angleSlope:=UINumEntry(\Header:="ANGLE SLOPE"\Message:="INPUT NEW VALUE"\InitValue:=angleSlope\MinValue:=0\MaxValue:=45);
                    ELSE
                        !not such case!
                    ENDIF
                ENDWHILE
                !musimy zmienic ostatni wybor zeby nie wyjsc od razu z menu glownego
                decision:=-1;
            ELSEIF decision=2 THEN
                !wybrana opcja DISTANCES
                WHILE decision<>5 DO
                    !ustawienie odpowiednich buttonow i wiadomosci
                    buttons:=["SAFE Z","DELTA UP","DELTA FAST","DELTA SLOW","BACK"];
                    message:=["Select distance to change.","SAFE Z: "+NumToStr(safeZ,1),"DELTA UP: "+NumToStr(deltaUp,1),
                              "DELTA FAST: "+NumToStr(deltaFast,1),"DELTA SLOW: "+NumToStr(deltaSlow,1)];
                    !komunikat dla usera
                    decision:=UIMessageBox(\Header:="GROUP: DISTANCES"\MsgArray:=message\BtnArray:=buttons);
                    IF decision=1 THEN
                        !wybrana opcja SAFE Z
                        safeZ:=UINumEntry(\Header:="DIST SAFE Z"\Message:="INPUT NEW VALUE"\InitValue:=safeZ\MinValue:=0\MaxValue:=500);
                    ELSEIF decision=2 THEN
                        !wybrana opcja DELTA UP
                        deltaUp:=UINumEntry(\Header:="DIST DELTA UP"\Message:="INPUT NEW VALUE"\InitValue:=deltaUp\MinValue:=0\MaxValue:=50);
                    ELSEIF decision=3 THEN
                        !wybrana opcja DELTA FAST
                        deltaFast:=UINumEntry(\Header:="DIST DELTA FAST"\Message:="INPUT NEW VALUE"\InitValue:=deltaFast\MinValue:=0\MaxValue:=50);
                    ELSEIF decision=4 THEN
                        !wybrana opcja DELTA SLOW
                        deltaSlow:=UINumEntry(\Header:="DIST DELTA SLOW"\Message:="INPUT NEW VALUE"\InitValue:=deltaSlow\MinValue:=0\MaxValue:=deltaFast);
                    ELSE
                        !not such case!
                    ENDIF
                ENDWHILE
                !musimy zmienic ostatni wybor zeby nie wyjsc od razu z menu glownego
                decision:=-1;
            ELSEIF decision=3 THEN
                !wybrana opcja SPEEDS
                WHILE decision<>5 DO
                    !ustawienie odpowiednich buttonow i wiadomosci
                    buttons:=["FAST","SLOW","PROCESS","","BACK"];
                    message:=["Select speed to change.","FAST: "+NumToStr(calibTorchFast.v_tcp,1),"SLOW: "+NumToStr(calibTorchSlow.v_tcp,1),
                              "PROCESS: "+NumToStr(calibTorchProcess.v_tcp,1),""];
                    !komunikat dla usera
                    decision:=UIMessageBox(\Header:="GROUP: SPEEDS"\MsgArray:=message\BtnArray:=buttons);
                    IF decision=1 THEN
                        !wybrana opcja SPEED FAST
                        calibTorchFast.v_tcp:=UINumEntry(\Header:="SPEED FAST"\Message:="INPUT NEW VALUE"\InitValue:=calibTorchFast.v_tcp\MinValue:=15\MaxValue:=50);
                    ELSEIF decision=2 THEN
                        !wybrana opcja SPEED SLOW
                        calibTorchSlow.v_tcp:=UINumEntry(\Header:="SPEED SLOW"\Message:="INPUT NEW VALUE"\InitValue:=calibTorchSlow.v_tcp\MinValue:=1\MaxValue:=15);
                    ELSEIF decision=3 THEN
                        !wybrana opcja SPEED PROCESS
                        calibTorchProcess.v_tcp:=UINumEntry(\Header:="SPEED PROCESS"\Message:="INPUT NEW VALUE"\InitValue:=calibTorchProcess.v_tcp\MinValue:=50\MaxValue:=500);
                    ELSE
                        !not such case!
                    ENDIF
                ENDWHILE
                !musimy zmienic ostatni wybor zeby nie wyjsc od razu z menu glownego
                decision:=-1;
            ELSE
                !not such case!
            ENDIF
        ENDWHILE
    ENDPROC

    !funkcja do korygowania narzedzia (lokalnie)
    ! ret: tooldata - nowe skorygowane lokalnie narzedzie
    ! arg: tool - pierwotne narzedzie
    ! arg: x, y, z - korekta przesuniecia TCP
    ! arg: rX, rY, rZ - korekta orientacji TCP
    LOCAL FUNC tooldata calibTorchCorrTool(tooldata tool,num x,num y,num z,num rX,num rY,num rZ)
        VAR tooldata result;
        VAR pose correction;

        !wyznaczenie korekty
        correction:=[[x,y,z],OrientZYX(rZ,rY,rX)];
        !modyfikujemy oryginalne narzedzie o korekte
        result.tframe:=PoseMult(tool.tframe,correction);
        !kopiujemy ustawienia z toola
        result.robhold:=tool.robhold;
        result.tload:=tool.tload;

        RETURN result;
    ENDFUNC

    !===========================================
    !========= KALIBRACJA OBROTNIKA ============
    !===========================================

    !procedura do kalibracji obrotnika w procesie auto (wolana z iProda przez AVS2 + bez menu)
    PROC calibRotator()
        VAR bool calibResult:=FALSE;

        !wlaczamy zolta diode
        towerWarning\running;
        !jedziemy do pozycji zaladunkowej
        calibRotatorBasePose;
        !zaczynamy kalibracje   
        calibResult:=calibRotatorMain(\autoAction:=1,rotatorWobj,torchTool);
        !po skonczeniu kalibracji wracamy do pozycji zaladunkowej       
        calibRotatorBasePose;
        !ustawiamy wynik do avs
        paramBool{1}:=calibResult;
        !wylaczamy zolta diode
        towerWarning\off;
    ENDPROC

    !opakowanie jazdy do pozycji zaladunku urzadzenia kalibracyjnego (wolane z AVS2)
    PROC calibRotatorBasePose()
        !podjezdzamy do pozycji zaladunowej
        MoveAbsJ robSpawRHome,robSpawSpeedFast,fine,torchTool\WObj:=wobj0;
    ENDPROC

    !glowna funkcja do kalibracji obrotnika na stanowisku robSpaw
    ! ret: bool = czy udalo sie poprawnie skalibrowac (TRUE) czy nie (FALSE)
    ! arg: autoAction - numer akcji ktora ma sie wykonac automatycznie (bez pytan do usera)
    ! arg: wobj - jaki workobject chcemy skalibrowac
    ! arg: tool - jakim toolem bedzie wykonywana kalibracja
    LOCAL FUNC bool calibRotatorMain(\num autoAction,INOUT wobjdata wobj,PERS tooldata tool)
        VAR bool result:=FALSE;
        VAR bool calibTry:=FALSE;
        !zmienne do menu wyboru trybu kalibracji
        VAR btnres action:=-1;
        VAR string header:="ROTATOR CALIBRATION";
        VAR string message{5}:=["Co robimy?","AUTO = z przyrzadem kalibracyjnym","MANUAL = pusty obrotnik",stEmpty,stEmpty];
        VAR string buttons{5}:=["AUTO","MANUAL","","SETTINGS","EXIT"];

        !tworzymy kopie wobj obrotnika ktora bedziemy modyfikowac
        calibRotatorWobj:=wobj;
        !rozpoczynamy kalibracje
        WHILE action<>5 DO
            !sprawdzamy parametr opcjonalny - jezeli jest to z automatu jedziemy wybrana funkcje
            IF NOT Present(autoAction) THEN
                !jezeli byla proba kalibracji to sprawdzamy czy sie udala czy nie i wyswietlamy komunikat
                IF calibTry THEN
                    IF result THEN
                        message{5}:="Ostatnia kalibracja OK!";
                        buttons{5}:="DALEJ";
                    ELSE
                        message{5}:="Ostatnia kalibracjia NIEUDANA...";
                        buttons{5}:="EXIT";
                    ENDIF
                ENDIF
                !nie ma zdefiniowanej auto-akcji dlatego komunikat dla usera
                action:=UIMessageBox(\Header:=header\MsgArray:=message\BtnArray:=buttons);
            ELSE
                IF autoAction=1 action:=autoAction;
            ENDIF
            !wykonujemy wybrana operacje
            IF action=1 THEN
                !AUTO - kalibracja automatyczna z przyrzadem kalibracyjnym
                calibTry:=TRUE;
                result:=calibRotatorAuto(calibPts,autoCalibAngleMin,autoCalibAngleMax,tool,calibRotatorWobj);
            ELSEIF action=2 THEN
                !MANUAL - kalibracja manualna na pustym obrotniku
                calibTry:=TRUE;
                result:=calibRotatorManual(calibPts,tool,calibRotatorWobj);
            ELSEIF action=4 THEN
                !SETTINGS - ustawienia parametrow kalibracji obrotnika
                calibRotatorSettings;
            ENDIF
            !jezeli byla akcja automatyczna to od razu wychodzimy
            IF Present(autoAction) action:=5;
        ENDWHILE
        !koniec kalibracji - sprawdzamy czy sie udala
        IF result THEN
            !kalibracja sie udala - zastepujemy narzedzie (oraz robimy kopie poprzedniego)
            IF NOT Present(autoAction) THEN
                !wyswietlamy komunikat dla usera z decyzja czy nadpisac czy nie
                message{1}:="Update wobj definition?";
                message{2}:="OLD DEF: "+writeWobj(wobj\precision:=4);
                message{3}:="NEW DEF: "+writeWobj(calibRotatorWobj\precision:=4);
                action:=UIMessageBox(\Header:="CALIB OK!"\MsgArray:=message\Buttons:=btnYesNo);
                IF action=resYes THEN
                    IF backupData("rotatorCalib.txt"\Wobj:=wobj) wobj:=calibRotatorWobj;
                ENDIF
            ELSE
                IF backupData("rotatorCalib.txt"\Wobj:=wobj) wobj:=calibRotatorWobj;
            ENDIF
        ELSE
            !jezeli byla proba kalibracji obrotnika to wyswietlamy koncowy log o niepowodzeniu
            IF calibTry ErrWrite "ERROR::calibRotator","Cant calibrate rotator..."\RL2:="Check previous logs.";
        ENDIF

        RETURN result;
    ENDFUNC

    !********* KALIBRACJA AUTOMATYCZNA ***************************************************************************

    !funkcja do automatycznej kalibracji obrotnika - modyfikuje parametr wobj (w ktorym sie poruszamy)
    ! ret: bool = czy udalo sie skalibrowac obrotnik (TRUE) lub nie (FALSE)
    ! arg: noOfPoses - ile pozycji ma skladac sie na kalibracje obrotnika (min: 4, max: 10)
    ! arg: rotationAngleMin - jaki minimalny kat obrotnika ma byc uzywany podczas kalibraji 
    ! arg: rotationAngleMax - jaki maksymalny kat obrotnika ma byc uzywany podczas kalibraji (zakres: rotationAngleMin do rotationAngleMax)
    ! arg: tool - jakim toolem sie poruszamy
    ! arg: wobj - w jakim ukladzie wspolrzednych sie poruszamy
    LOCAL FUNC bool calibRotatorAuto(num noOfPoses,num rotationAngleMin,num rotationAngleMax,PERS tooldata tool,INOUT wobjdata wobj)
        VAR bool result:=FALSE;
        VAR num max_err:=0;
        VAR num mean_err:=0;
        VAR num currentPos:=0;
        VAR num bestVertPos:=0;
        VAR num goodPosesNo:=0;
        VAR num currDist:=0;
        VAR num maxDist:=10;
        VAR num safeDist:=50;
        VAR pose foundPose;
        VAR pose tempPose;
        VAR pose tempPoseWobj;
        VAR robtarget destPositions{5};
        VAR robtarget foundPositions{5};
        VAR robtarget tempRobt;
        VAR navgeodata kulka:=[12.5,10];

        ConfL\Off;
        ConfJ\Off;
        !na wszelki wypadek inicjujemy polaczenie ze spawarka
        froniusInitialize;
        !podjezdzamy do pozycji startowej do kalibracji obrotnika
        MoveAbsJ calibRotatorStartPos,v200,fine,tool;
        !resetujemy dlugosc drutu zeby na pewno dobrze skalibrowac
        restoreTorchTool;
        !ustawiamy flage o koniecznosci wyczyszczenia palnika i obcinamy drut 
        needCleanTorch:=TRUE;
        cleanTorch\cleanSequence:=[cut];
        !wyliczamy pozycje 
        calibRotatorCalcPositions noOfPoses,rotationAngleMin,rotationAngleMax,calibRotatorStartPos.extax.eax_a,wobj,destPositions;
        !etap wstepny - sprawdzenie czy kulka jest tam gdzie powinna byc (sprawdzamy w pozycji najbliszej pionu)
        !dodatkowo jest to niezbedne w celu wykasowania ewentualnego bledu z brakiem sygnalu w dodatku        
        bestVertPos:=Trunc(noOfPoses/2)+1;
        !najpierw kontrolujemy jak zostal wlozony przyrzad kalibracyjny i wprowadzamy korekty
        IF calibRotatorCorrPositions(destPositions,bestVertPos,10,1,tool,wobj) THEN
            !kontynuujemy proces
            MoveJ RelTool(destPositions{bestVertPos},0,0,-safeDist),v200,fine,tool\WObj:=wobj;
            Search_1D foundPose,RelTool(destPositions{bestVertPos},0,0,-safeDist),destPositions{bestVertPos},v200,tool\WObj:=wobj;
            MoveJ RelTool(destPositions{bestVertPos},0,0,-safeDist),v200,fine,tool\WObj:=wobj;
            !sprawdzamy odleglosc miedzy pozycja znaleziona kuli a pozycja wyliczona
            currDist:=VectMagn(foundPose.trans);
            !jezeli kulka jest na swoim miejscu to rozpoczynamy kalibracje
            IF currDist<maxDist THEN
                !szukamy kuli we wszystkich zadanych pozycjach
                WHILE currentPos<noOfPoses DO
                    !zwiekszamy liczbe wykonanych pozycji
                    Incr currentPos;
                    !miedzy kolejnymi pozycjami pierw oddalamy sie bezpiecznie a pozniej zjezdzamy do pkt docelowego
                    IF currentPos>1 THEN
                        !podjezdzamy od obecnej pozycji do gory
                        tempRobt:=CRobT(\Tool:=tool\WObj:=wobj);
                        MoveL Offs(tempRobt,-150,0,0),v100,z0,tool\WObj:=wobj;
                        !jedziemy pierw obrotnikiem w miejsce docelowe
                        tempRobt.extax:=destPositions{currentPos}.extax;
                        MoveL Offs(tempRobt,-150,0,0),v100,z0,tool\WObj:=wobj;
                        !nastepnie dojezdzamy robotem (z reorientowaniem sie)
                        MoveJ Offs(destPositions{currentPos},-100,0,0),v200,z5,tool\WObj:=wobj;
                    ENDIF
                    !podjedz do pozycji bezpiecznej
                    MoveJ RelTool(destPositions{currentPos},0,0,-safeDist),v200,z5,tool\WObj:=wobj;
                    MoveL RelTool(destPositions{currentPos},0,0,-safeDist/2),v200,z0,tool\WObj:=wobj;
                    !szukaj sfery
                    SearchSpJ 20,foundPositions{currentPos},destPositions{currentPos},v200,z0,tool\WObj:=wobj,kulka;
                    !wracamy do pozycji bezpiecznej
                    MoveJ RelTool(destPositions{currentPos},0,0,-safeDist),v200,z0,tool\WObj:=wobj;
                    !czy proces znajdywania sfery przebiegl poprawnie?
                    IF foundPositions{currentPos}<>emptyRobt AND foundPositions{currentPos}<>zeroRobt THEN
                        !jest OK: liczba dobrych pozycji + 1 
                        Incr goodPosesNo;
                        !przeliczamy pozycje na uklad globalny (wyniki wtedy wychodza latwiejsze do interpretacji)
                        tempPoseWobj:=wobj.uframe;
                        tempPose:=robtToPose(foundPositions{currentPos});
                        tempPose:=PoseMult(tempPoseWobj,tempPose);
                        foundPositions{currentPos}.trans:=tempPose.trans;
                        foundPositions{currentPos}.rot:=tempPose.rot;
                        !sortujemy odpowiednio tablice pozycji znalezionych (potrzebne do funkcji CalcRotAxisFrame)
                        foundPositions{goodPosesNo}:=foundPositions{currentPos};
                    ENDIF
                ENDWHILE
                !sprawdzamy czy udalo sie znalezc co najmniej 4 dobre pozycje (minimum do wyznaczenia osi)
                IF goodPosesNo>=4 THEN
                    !znajdujemy os obrotnika na podstawie wyznaczonych punktow
                    foundPose:=CalcRotAxisFrame(M7DM1,foundPositions,goodPosesNo,max_err,mean_err);
                    !przesuwamy po Z znaleziony wobj do palcow obrotnika (273.5 = od baza do rury kuli, 29.66 = srednica rury kuli)
                    !od razu obracamy o wyliczony kat po osi Z tak by orient byl w miare zgodny
                    tempRobt.trans:=foundPose.trans;
                    tempRobt.rot:=foundPose.rot;
                    tempRobt:=RelTool(tempRobt,0,0,-(273.5-29.66/2)\Rz:=-(180+rotationAngleMin));
                    !modyfikujemy wobj
                    wobj.uframe.trans:=tempRobt.trans;
                    wobj.uframe.rot:=tempRobt.rot;
                    result:=TRUE;
                ELSE
                    result:=FALSE;
                ENDIF
            ELSE
                ErrWrite\W,"Kula w zlym miejscu","Znaleziona kula nie jest tam gdzie powinna [obecna odleglosc: "+NumToStr(currDist,3)+"]";
                result:=FALSE;
            ENDIF
            !na koniec podjezdzamy do pozycji startowej kalibracji obrotnika
            MoveAbsJ calibRotatorStartPos,v200,fine,tool;
        ENDIF

        !zwracamy wynik
        RETURN result;
    ERROR
        !jezeli blad = Navigator error (111755) to znaczy ze nie zdolano osiagnac zadanej dokladnosci
        IF errno=111755 THEN
            ErrWrite\W,"Nie znaleziono kuli","Dla pozycji "+NumToStr(currentPos,0)+" nie udalo sie znalezc sfery z zadana dokladnoscia";
            foundPositions{currentPos}:=emptyRobt;
            TRYNEXT;
        ENDIF
    ENDFUNC

    !procedura do wyznaczania pozycji kalibracyjnych robota i obrotnika (kalibracja obrotnika)
    ! arg: noOfPoses - ile pozycji ma byc wyznaczonych do kalibracji
    ! arg: rotationAngleMin - jaki minimalny kat obrotnika ma byc uzywany podczas kalibraji 
    ! arg: rotationAngleMax - jaki maksymalny kat obrotnika ma byc uzywany podczas kalibraji (zakres: rotationAngleMin do rotationAngleMax)
    ! arg: rotatorZero - pozycja kata zerowego obrotnika (od niego wyznaczamy pozycje -rotationAngle/2 do + rotationAngle/2)
    ! arg: wobj - workobject w ktorym wyznaczamy pozycje (zal. jego X patrzy pionowo w dol)
    ! arg: positions - tablica pozycji kalibracyjnych
    LOCAL PROC calibRotatorCalcPositions(num noOfPoses,num rotationAngleMin,num rotationAngleMax,num rotatorZero,wobjdata wobj,INOUT robtarget positions{*})
        !parametry miejsca w ktorym zdefiniowac pozycje
        VAR num radius:=380;
        VAR num distAlongZ:=259;
        VAR num singleAngleStep;
        VAR num currentAngle;
        VAR string robotName;

        !okreslamy wartosc kata o ktory bedziemy obracac pozycje (liczba odcinkow)
        singleAngleStep:=(rotationAngleMax-rotationAngleMin)/(noOfPoses-1);
        !definiujemy wszystkie pozycje
        FOR i FROM 1 TO noOfPoses DO
            !wyliczamy kat obrotu pozycji + obrotnika
            currentAngle:=rotatorZero+rotationAngleMin+(i-1)*singleAngleStep;
            !pierw kat obrotnika
            positions{i}.extax.eax_a:=currentAngle;
            !nastepnie wyznaczamy pozycje w danym wobj 
            positions{i}.trans.x:=-radius*Cos(currentAngle);
            positions{i}.trans.y:=-radius*Sin(currentAngle);
            positions{i}.trans.z:=distAlongZ;
            !na koniec ustawiamy jej orientacje + korekta wokol osi Z (zwiekszamy zasieg)
            !jest to zalezne od robota (robSpawL ma obrotnik po prawej, robSpawR po lewej)
            robotName:=GetSysInfo(\CtrlId);
            IF (robotName="1600-100732") THEN
                !robSpawL = "1600-100732"!
                positions{i}.rot:=[1,0,0,0];
                positions{i}:=RelTool(positions{i},0,0,0\Ry:=90);
                positions{i}:=RelTool(positions{i},0,0,0\Rz:=90);
                positions{i}:=RelTool(positions{i},0,0,0\Ry:=-currentAngle);
                !teraz jest orientacja taka ze tool skierowany jest Z+ to srodka wobj
                IF i<noOfPoses/2 THEN
                    positions{i}:=RelTool(positions{i},0,0,0\Rz:=0);
                ELSE
                    positions{i}:=RelTool(positions{i},0,0,0\Rz:=180);
                ENDIF
            ELSEIF (robotName="R3D_robSpawR") THEN
                !robSpawR = "1600-100731" = "R3D_robSpawR"!
                positions{i}.rot:=[1,0,0,0];
                positions{i}:=RelTool(positions{i},0,0,0\Ry:=90);
                positions{i}:=RelTool(positions{i},0,0,0\Rz:=-90);
                positions{i}:=RelTool(positions{i},0,0,0\Ry:=-currentAngle);
                !teraz jest orientacja taka ze tool skierowany jest Z+ to srodka wobj
                IF i<=Round(noOfPoses/2\Dec:=0) THEN
                    positions{i}:=RelTool(positions{i},0,0,0\Rz:=0);
                ELSE
                    IF i=4 THEN
                        positions{i}:=RelTool(positions{i},0,0,0\Rz:=225);
                    ELSE
                        positions{i}:=RelTool(positions{i},0,0,0\Rz:=180);
                    ENDIF
                ENDIF
            ELSE
                ErrWrite "Rotator calib points","Orient of calibration points on this robot may be wrong!"\RL2:="Stay cautious after PLAY!";
                towerWarning\handleHelpStop;
            ENDIF
        ENDFOR
    ENDPROC

    !funkcja do korygowania pozycji kalibracyjnych robota wynikajacych ze zlego wlozenia przyrzadu kalibracyjnego
    !(korekta ta jest wyznaczania na podstawie wstepnej lokalizacji kulki na przyrzadzie kalibracyjnym)
    ! ret: bool = czy udalo sie znalezc korekte punkotw kalibracyjnych (TRUE) czy nie (FALSE)
    ! arg: positions - tablica pozycji kalibracyjnych, ktora ewentualnie skorygujemy
    ! arg: vertPosNo - ktora pozycja z tablicy powyzej jest najblizej pionu
    ! arg: rotatorAngleDelta - w jakim zakresie katowym obrotnika szukamy pozycji (-arg ... +arg)
    ! arg: toolDelta - jaki zakres ruszania toolem przy szukaniu pozycji przyrzadu
    ! arg: tool - definicja narzedzia ktorym sie poruszamy
    ! arg: wobj - workobject w ktorym wyznaczamy pozycje (zal. jego X patrzy pionowo w dol)
    LOCAL FUNC bool calibRotatorCorrPositions(INOUT robtarget positions{*},num vertPosNo,num rotatorAngleDelta,num toolDelta,PERS tooldata tool,PERS wobjdata wobj)
        VAR bool result:=FALSE;
        VAR bool continueSearch:=TRUE;
        VAR bool checkSide{2};
        VAR num retryNo:=0;
        VAR num angleCorrection:=0;
        VAR robtarget foundPos;
        VAR robtarget currSearchPos;
        VAR speeddata fastSearchSpeed:=[20,30,100,10];
        VAR speeddata slowSearchSpeed:=[5,30,100,1];

        !sprawdzamy pierw czy zostal wlozony przyrzad kalibracyjny
        IF (rotatorPacketPresent()=1 AND RR_presentPacketSize5=0) THEN
            !wyznaczamy pozycje w ktorej powinna znajdowac sie kulka
            currSearchPos:=positions{vertPosNo};
            !jedziemy nad ta pozycje
            MoveJ RelTool(currSearchPos,0,0,-50),v200,fine,tool\WObj:=wobj;
            !sprawdzamy TouchSensigiem czy rzeczywiscie mamy tam kulke (oraz kierunek obrotu obrotnika do dokladnego szukania)
            foundPos:=searchTouchSense(currSearchPos,tool,wobj,toolDelta,fastSearchSpeed\secondSearchSpd:=slowSearchSpeed);
            IF foundPos=emptyRobt THEN
                !nie znaleziono nic na calej drodze szukania - zostajemy w pozycji koncowej i szukamy obrotnikiem az do znalezienia punktu
                WHILE foundPos=emptyRobt AND retryNo<=2 DO
                    Incr retryNo;
                    MoveL positions{vertPosNo},v100,fine,tool\WObj:=wobj;
                    currSearchPos.extax.eax_a:=positions{vertPosNo}.extax.eax_a+(2*(retryNo MOD 2)-1)*rotatorAngleDelta;
                    foundPos:=searchTouchSenseRotator(currSearchPos,tool,wobj,slowSearchSpeed);
                ENDWHILE
            ELSE
                !znalezlismy punkt wstepny - szukamy w ktora strone trzeba obracac obrotnikiem by znalezc punkt dokladny
                FOR i FROM 1 TO 2 DO
                    currSearchPos:=foundPos;
                    currSearchPos.extax.eax_a:=foundPos.extax.eax_a+(2*(i MOD 2)-1)*0.5;
                    !ustawiamy stan obrotnika: w ruchu
                    rotatorStatus\moving;
                    !jedziemy do wyliczonej pozycji
                    MoveL currSearchPos,v10,fine,tool\WObj:=wobj;
                    WaitTime\InPos,1;
                    !ustawiamy stan obrotnika: zatrzymany
                    rotatorStatus\stopped;
                    !sprawdzamy czy jest przejscie (jest kontakt z kulka)
                    checkSide{i}:=froniusCheckContact();
                ENDFOR
                !sprawdzamy czy tylko w jednym przypadku byla jedynka (OK)
                IF checkSide{1}XOR checkSide{2} THEN
                    IF checkSide{1}retryNo:=1;
                    IF checkSide{2}retryNo:=2;
                ELSE
                    RETURN result;
                ENDIF
            ENDIF
            !sprawdzamy czy udalo sie mniej wiecej zlokalizowac kulke
            IF foundPos=emptyRobt THEN
                !nie bylo kulki w calym zakresie szukania = totalnie zle wlozony przyrzad kalibracyjny
                ErrWrite\W,"ERROR::calibRotatorPoints","Szukanie obrotnikiem nieudane"\RL2:="Sprawdz przyrzad kalibracyjny";
            ELSE
                !mamy kulke zlokalizowana mniej wiecej - podjezdzamy pierw do znalezionego punktu 
                MoveL RelTool(foundPos,0,0,-1),v10,fine,tool\WObj:=wobj;
                MoveL foundPos,v10,fine,tool\WObj:=wobj;
                !szukamy dokladnej pozycji katowej obrotnika 
                WHILE continueSearch DO
                    !od wstepnie znalezionej pozycji podnosimy sie o podana wysokosc
                    currSearchPos:=RelTool(foundPos,0,0,-toolDelta);
                    MoveL currSearchPos,v100,fine,tool\WObj:=wobj;
                    WaitTime\InPos,0;
                    currSearchPos.extax.eax_a:=currSearchPos.extax.eax_a+(2*(retryNo MOD 2)-1)*1;
                    foundPos:=searchTouchSenseRotator(currSearchPos,tool,wobj,slowSearchSpeed);
                    !nie udalo sie wykryc - jestesmy juz blisko - zmniejszamy krok
                    IF foundPos=emptyRobt THEN
                        !przywracamy poprzednia pozycje
                        foundPos:=RelTool(currSearchPos,0,0,toolDelta);
                        foundPos.extax.eax_a:=currSearchPos.extax.eax_a-(2*(retryNo MOD 2)-1)*1;
                        !ustawiamy stan obrotnika: w ruchu
                        rotatorStatus\moving;
                        !wracamy do niej (pierw na starej wysokosci zeby nie uderzyc w kulke)
                        MoveL RelTool(foundPos,0,0,-toolDelta),v100,fine,tool\WObj:=wobj;
                        MoveL foundPos,v100,fine,tool\WObj:=wobj;
                        !ustawiamy stan obrotnika: zatrzymany
                        rotatorStatus\stopped;
                        !jezeli krok byl mniejszy od 0.25 to jest ok
                        IF toolDelta<=0.06 THEN
                            !udalo sie znalezc dokladnie pozycje
                            continueSearch:=FALSE;
                        ELSE
                            !zmniejszamy krok 
                            toolDelta:=toolDelta/2;
                            continueSearch:=TRUE;
                        ENDIF
                    ENDIF
                ENDWHILE
                !w tym miejscu mamy znaleziona dokladnie pozycje obrotnika z kulka mniej wiecej w dobrym polozeniu
                !wyliczamy poprawke katowa obrotnika miedzy obecna pozycja a wyliczona
                angleCorrection:=foundPos.extax.eax_a-positions{vertPosNo}.extax.eax_a;
                !poprawke ta uwzgledniamy w kazdej wyliczonej pozycji kalibracyjnej
                FOR i FROM 1 TO Dim(positions,1) DO
                    positions{i}.extax.eax_a:=positions{i}.extax.eax_a+angleCorrection;
                ENDFOR
                !zmieniamy wynik
                result:=TRUE;
            ENDIF
        ELSE
            !nie wykryto przyrzadu kalibracyjnego
            ErrWrite\W,"ERROR::calibRotatorPoints","Brak przyrzadu kalibracyjnego lub uszkodzone czujniki";
        ENDIF

        RETURN result;
    ENDFUNC

    !********* KALIBRACJA MANUALNA *******************************************************************************

    !glowna funkcja kalibracji manualnej pozycjonera ABB 
    ! ret: bool = czy kalibracja zakonczyla sie sukcesem (TRUE) czy nie (FALSE)
    ! arg: calibPoints - ile punktow kalibracyjnych ma sie skladac na kalibracje
    ! arg: tool - jakim toolem bedziemy zbierac punkty kalibracyjne
    ! arg: wobj - jaki workobject bedziemy kalibrowac
    LOCAL FUNC bool calibRotatorManual(num calibPoints,PERS tooldata tool,INOUT wobjdata wobj)
        VAR bool result:=FALSE;
        VAR num singleStepAngle:=0;

        TPErase;
        !podjazd obrotnikiem do pozycji zerowej
        rotatorMoveToHome;
        !wyliczenie kata jednostkowego na podstawie ilosci punktow
        singleStepAngle:=360/calibPts;
        !podjazd do kolejnych punktow kalibracyjnych
        calibRotatorReadPoint calibPoints,singleStepAngle,tool;
        !obliczenie osi obrotnika
        result:=calibRotatorCalcFrame(wobj);

        RETURN result;
    ENDFUNC

    !podjazd do kazdego punktu kalibracji i odczyt pozycji (do kalibracji)
    ! arg: howMany - jak duzo punktow kalibracyjnych mamy
    ! arg: calibAngle - jaki jest pojedynczy kat obrotu miedzy kolejnymi punktami
    ! arg: tool - jakim narzedziem mamy zbierac pozycje (w wobj0)
    LOCAL PROC calibRotatorReadPoint(num howMany,num calibAngle,PERS tooldata tool)
        !aktualna pozycja obrotnika 
        VAR robtarget pozycjaAktualObr;

        FOR i FROM 1 TO howMany DO
            !wyswietlenie komunikatu dla operatora
            TPWrite "Move to pos "+NumToStr(i,0)+" and press PLAY.";
            !wyczyszczenie zaprogramowanego ruchu robota 
            ClearPath;
            !zatrzymanie programu w celu manualnego podjazdu
            Stop;
            !-> PO PODJECHANIU I NACISNIECIU PRZYCISKU PLAY <-
            !Odczyt polozenia kolejnych punktow kalibracji osi obrotu
            pozycjaAktualObr:=CRobT(\Tool:=tool\WObj:=wobj0);
            manualCalibPoints{i}.trans:=pozycjaAktualObr.trans;
            manualCalibPoints{i}.rot:=pozycjaAktualObr.rot;
            !odjedz o 10 mm (dla bezpieczenstwa)
            MoveL RelTool(pozycjaAktualObr,0,0,-10),v20,z0,tool\WObj:=wobj0;
            !obrot obrotnika o odpowiedni kat
            rotatorMoveStep calibAngle;
        ENDFOR
        !--- teraz wyznaczamy zwrot osi Z
        TPWrite "Move down to measure Z and press PLAY";
        TPWrite "(Distance sensor should measure < 30mm!)";
        ClearPath;
        Stop;
        !odczyt polozenia punktu Z potrzebnego do kalibracji osi obrotu
        pozycjaAktualObr:=CRobT(\Tool:=tool\WObj:=wobj0);
        manualCalibPointZ.trans:=pozycjaAktualObr.trans;
        manualCalibPointZ.rot:=pozycjaAktualObr.rot;
    ENDPROC

    !funkcja wyliczajaca wobj skalibrowanego obrotnika na podstawie punktow na okregu oraz punktu osi Z
    ! ret: bool = czy udalo sie poprawie wyliczyc frame wobj (TRUE) lub nie (FALSE)
    ! arg: wobj - workobject ktorego frame wyliczamy
    LOCAL FUNC bool calibRotatorCalcFrame(INOUT wobjdata wobj)
        VAR bool result:=FALSE;
        VAR num maxError:=0;
        VAR num meanError:=0;

        !obliczenie osi obrotu pozycjonera z wykorzystaniem funkcji
        !CalcRotAxFrameZ (TargetList PointsUsedFromTarget PositiveZPoint MaxErr MeanErr)     
        wobj.uframe:=CalcRotAxFrameZ(manualCalibPoints,calibPts,manualCalibPointZ,maxError,meanError);
        !jezeli tu jestesmy to znaczy ze nie bylo bledu
        result:=TRUE;

        RETURN result;
    ERROR
        IF errno=ERR_FRAME THEN
            ErrWrite\W,"ERROR::rotAxisCalibration","Nie moge wyznaczyc wobj z recznie zebranych punktow.";
        ELSE
            ErrWrite\W,"ERROR::rotAxisCalibration","Nieznany blad - NR "+NumToStr(errno,0);
        ENDIF
        RETURN result;
    ENDFUNC

    !procedura do ustawiania parametrow kalibracji
    LOCAL PROC calibRotatorSettings()
        VAR btnres decision:=-1;
        VAR string buttons{5};
        VAR string message{5};

        WHILE decision<>5 DO
            !ustawienie odpowiednich buttonow i wiadomosci
            buttons:=["POINTS","ANGLE MIN","ANGLE MAX","SPEEDS","BACK"];
            message:=["No of points: "+NumToStr(calibPts,0),"Calib angle min: "+NumToStr(autoCalibAngleMin,0),
                      "Calib angle max: "+NumToStr(autoCalibAngleMax,0),"Rotator speed: "+NumToStr(calibRotatorProcess.v_reax,0)+"[deg/s]",""];
            !komunikat dla usera
            decision:=UIMessageBox(\Header:="CALIBRATION SETTINGS"\MsgArray:=message\BtnArray:=buttons);
            IF decision=1 THEN
                !wybrana opcja POINTS
                calibPts:=UINumEntry(\Header:="CALIB POINTS"\Message:="INPUT NEW VALUE"\InitValue:=calibPts\MinValue:=4\MaxValue:=10);
            ELSEIF decision=2 THEN
                !wybrana opcja ANGLE MIN
                autoCalibAngleMin:=UINumEntry(\Header:="CALIB ANGLE MIN (only auto)"\Message:="INPUT NEW VALUE"\InitValue:=autoCalibAngleMin\MinValue:=-60\MaxValue:=-45);
            ELSEIF decision=3 THEN
                !wybrana opcja ANGLE MAX
                autoCalibAngleMax:=UINumEntry(\Header:="CALIB ANGLE MAX (only auto)"\Message:="INPUT NEW VALUE"\InitValue:=autoCalibAngleMax\MinValue:=autoCalibAngleMin\MaxValue:=45);
            ELSEIF decision=4 THEN
                !wybrana opcja SPEED
                calibRotatorProcess.v_reax:=UINumEntry(\Header:="ROTATOR PROCESS SPEED"\Message:="INPUT NEW VALUE"\InitValue:=calibRotatorProcess.v_reax\MinValue:=50\MaxValue:=180);
            ELSE
                !not such case!
            ENDIF
        ENDWHILE

    ENDPROC

    !********* KALIBRACJA MANUALNA DLA ROBMONTAZ *****************************************************************

    !procedura specjalna robGalant do kalibracji obrotnika dla robMontaz
    !wynika ona z faktu ze czujnik ma robMontaz, zas obrotnikiem steruje robSpaw = komunikacja miedzy nimi
    PROC calibRotatorRobMontaz()
        VAR bool rotatorBased:=FALSE;
        VAR num calibAngle:=0;

        !pytamy ile punktow kalibracyjnych bedzie
        calibAngle:=calibRotatorPointsQuestion();
        WHILE RMR_startProcessSpawR=1 DO
            !czekaj na sygnal od robota montazowego ze jest bezpieczny
            WaitDI RMR_montazSafePosR,1;
            !skoro robot montaz jest bezpieczny to obracamy obrotnik
            IF NOT rotatorBased THEN
                rotatorMoveToHome;
                rotatorBased:=TRUE;
            ELSE
                !obracamy obrotnikiem do danej pozycji kalibracyjnej
                rotatorMoveStep calibAngle;
            ENDIF
            !ustawiamy sygnal ze obrotnik ustawiony
            Set RRM_rotatorInPosR;
            WaitDI RMR_montazSafePosR,0;
            Reset RRM_rotatorInPosR;
        ENDWHILE
        WaitDI RMR_stopProcessSpawR,1;
        rotatorMoveToHome;
    ENDPROC

    !komunikat dla usera (tylko w trybie kalibracji manualnej) z wyborem liczby punktow kalibracji
    ! ret: num = wyliczony na podstawie podanej liczbie punktow jednostkowy kat obrotu miedzy kolejnymi pozycjami
    LOCAL FUNC num calibRotatorPointsQuestion()
        VAR num result:=0;
        VAR num calibPts;

        !pytamy uzytkownika ile ma byc punktow kalibracyjnych
        calibPts:=UINumEntry(\Header:="MONTAZ ROTATOR CALIB"\Message:="How many calib points?"\InitValue:=4\MinValue:=4\MaxValue:=10);
        !ustawienie parametrow okna z wyborem
        result:=360/calibPts;
        !obliczenie kata obrotu
        TPWrite "Rotator angle = "\Num:=result;

        RETURN result;
    ENDFUNC

    !===========================================
    !================ TESTY ====================
    !===========================================

    !glowna procedura do testowania kalibracji narzedzia
    PROC testCalibTool()
        VAR jointtarget currJoint;
        VAR num backupWireLen:=-1;

        !wlaczamy zolta diode
        towerWarning\running;
        !zapamietujemy obecnie ustawiona dlugosc drutu
        backupWireLen:=currentWireLength;
        !zapamietujemy pozycje obrotnika
        currJoint:=CJointT();
        cleanTorchBasePos.extax:=currJoint.extax;
        cleanTorchPassPos.extax:=currJoint.extax;
        !podjezdzamy robotem (bez obrotnika) do pozycji domowej
        robSpawGoToHome FALSE;
        !przygotowujemy palnik do kalibracji
        froniusInspectTorch\singleAction:="ZDEJMIJ DYSZE PALNIKA",FALSE;
        restoreTorchTool;
        wireCut\skipHomePos;
        !zaczynamy kalibracje narzedzia       
        IF calibTorchMain(torchToolOriginal) THEN
            TPWrite "TEST CALIB TOOL - OK !!!";
        ELSE
            TPWrite "TEST CALIB TOOL - NOK...";
        ENDIF
        !po skonczeniu kalibracji przywracamy palnik do poprzedniego stanu
        froniusInspectTorch\singleAction:="ZALOZ DYSZE PALNIKA",FALSE;
        modifyTorchTool backupWireLen;
        wireCut\skipHomePos;
        !wracamy do pozycji domowej (przez pozycje posrednia + bez obrotnika)       
        MoveAbsJ cleanTorchPassPos,robSpawSpeedFast,fine,tool0;
        robSpawGoToHome FALSE;
        !wylaczamy zolta diode
        towerWarning\off;
    ENDPROC

    !glowna procedura do testowania kalibracji obrotnika
    PROC testCalibRotator()
        !wlaczamy zolta diode
        towerWarning\running;
        !uruchamiamy kalibracje
        IF calibRotatorMain(rotatorWobj,torchTool) THEN
            TPWrite "TEST CALIB ROTATOR - OK !!!";
        ELSE
            TPWrite "TEST CALIB ROTATOR - NOK...";
        ENDIF
        !wylaczamy zolta diode
        towerWarning\off;
    ENDPROC
ENDMODULE
