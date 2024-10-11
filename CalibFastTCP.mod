MODULE CalibFastTCP
    ! modul zawiera procedure szybkiej kalibracji  punktu pracy palnika TCP
    ! przy czym korygowane sa tylko wspolrzedne X i Y punktu TCP
    ! katy rX, rY, rZ i wspolrzedna Z nie sa brane pod uwage

    ! UWAGA: procedura wymaga zaladowania modulu TCP ktory jest czescia oprogramowania AutoCall

    ! zdefiniowany punkt startowy kalibracji
    !!LOCAL PERS robtarget PunktKalTCP:=[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    LOCAL PERS robtarget Rot_A:=[[242.902,566.79,-1366.81],[3.09086E-08,-0.707107,-0.707107,-3.09086E-08],[0,0,-2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    LOCAL PERS robtarget Rot_B:=[[242.902,566.79,-1366.81],[3.09086E-08,-0.707107,0.707107,3.09086E-08],[0,0,-2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    LOCAL PERS robtarget Rot_C:=[[242.902,566.79,-1366.81],[4.37114E-08,-1,0,0],[0,0,-2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    LOCAL PERS pos Poczatek:=[273.661,1064.28,637.813];
    CONST robtarget AAACalibSupport:=[[-192.68,-795.66,456.25],[1.13796E-06,0.727571,0.686033,-2.82384E-06],[-2,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget AAAtestSupport:=[[-12.26,-731.86,118.76],[3.87751E-06,-0.50736,-0.861734,-6.82779E-06],[-1,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

    ! zakres szukania zgrubnego
    CONST num ZakresZgr:=10;
    ! zakres szukania dokladnego
    CONST num ZakresDok:=10;
    ! predkosci poruszania
    CONST speeddata PredkoscDok:=[10,300,5,100];
    CONST speeddata PredkoscZgr:=[20,600,5,100];
    CONST speeddata PredkoscRob:=[30,600,5,100];
    ! znalezione punkty przeciecia lasera
    LOCAL VAR num xA;
    LOCAL VAR num xB;
    LOCAL VAR num xC;
    ! korekty TCP
    LOCAL VAR num korX;
    LOCAL VAR num korY;
    ! poprzednie korekty TCP
    LOCAL VAR num POPkorX;
    LOCAL VAR num POPkorY;
    ! wymagana dokladnosc
    CONST num MaxKorX:=0.05;
    CONST num MAxKorY:=0.05;
    ! licznik powtorek
    LOCAL VAR num Licznik;
    LOCAL CONST num MaxLicznik:=1;
    !
    LOCAL PERS tooldata TempGrabki:=[TRUE,[[-35.4316,-302.657,70.5033],[0.707107,0.707107,0,0]],[5,[85,0,65],[1,0,0,0],0.01,0.01,0.01]];
    LOCAL PERS wobjdata U_kal:=[FALSE,TRUE,"",[[0,0,0],[0.707107,0.707107,0,0]],[[0,0,0],[1,0,0,0]]];

    PROC FastCorTCP()
        VAR pose PoseTool;
        VAR pose PoseKor;
        VAR pose PoseNEW;

        ConfL\Off;
        !sprawdzenie czy mamy do czynienia z obrotnikiem czy nie - jest to wazne z punktu widzenia sterowania zewnetrznymi osiami - Ponik
        !   ROT_modifyJointtEax bazaKPal1;
        !   ROT_modifyJointtEax bazaKPal2;

        !   MoveAbsJ bazaKPal1\NoEOffs,v200,fine,tool0\WObj:=wobj0;
        !   MoveAbsJ bazaKPal2\NoEOffs,v200,fine,tool0\WObj:=wobj0;
        ConfJ\Off;
        TempGrabki:=Support;

        ! obrocenie ukladu wspolrzednych tak by plaszczyzna KZ przechodzila przez punkt TCP narzedzia
        Poczatek:=CPos(\Tool:=tool0\WObj:=wobj0);
        TPWrite "kat obrotu Wobj= "\Num:=ATan2(Poczatek.y,Poczatek.x);
        U_kal.uframe:=[[0,0,0],OrientZYX(ATan2(Poczatek.y,Poczatek.x),0,0)];
        U_kal.oframe:=[[0,0,0],[1,0,0,0]];
        Rot_C:=CRobT(\Tool:=TempGrabki\WObj:=U_kal);
        Rot_C.rot:=O_Rownolegle(Rot_C.rot,90);
        ! wyznaczenie pozycji palnika do wyznaczania katow
        Rot_A:=RelTool(Rot_C,0,0,0\Rz:=-90);
        Rot_B:=RelTool(Rot_C,0,0,0\Rz:=+90);

        ! start
        korX:=10;
        korY:=10;
        POPkorX:=100;
        POPkorY:=100;
        Licznik:=0;

        WHILE ((abs(korX)>MaxKorX) OR (abs(korY)>MaxKorY)) AND Licznik<MaxLicznik DO
            ! ustawiamy palnik w pozycji srodkowej
            MoveL Rot_C,PredkoscRob,fine,TempGrabki\WObj:=U_kal;
            WaitUntil\InPos,TRUE;
            RobotXF 1,ZakresDok,PredkoscDok,PredkoscZgr,PredkoscRob,ZakresZgr,TempGrabki,U_kal\BezZgr;
            xC:=Robot_X;
            TPWrite " ---> xC: "\Num:=xC;
            ! ustawiamy palnik w pozycji bocznej
            MoveL Rot_A,PredkoscRob,fine,TempGrabki\WObj:=U_kal;
            WaitUntil\InPos,TRUE;
            RobotXF 1,ZakresDok,PredkoscDok,PredkoscZgr,PredkoscRob,ZakresZgr,TempGrabki,U_kal\BezZgr;
            xA:=Robot_X;
            TPWrite " ---> xA: "\Num:=xA;
            ! ustawiamy palnik w pozycji srodkowej
            MoveL Rot_C,PredkoscRob,z20,TempGrabki\WObj:=U_kal;
            ! ustawiamy palnik w pozycji drugiej bocznej
            MoveL Rot_B,PredkoscRob,fine,TempGrabki\WObj:=U_kal;
            WaitUntil\InPos,TRUE;
            RobotXF 1,ZakresDok,PredkoscDok,PredkoscZgr,PredkoscRob,ZakresZgr,TempGrabki,U_kal\BezZgr;
            xB:=Robot_X;
            TPWrite " ---> xB: "\Num:=xB;
            ! ---> obliczenia korekt   
            POPkorX:=korX;
            POPkorY:=korY;
            ! ------ obliczamy korekte Y tool
            korY:=(xA-xB)/2;
            TPWrite "korekta tool_Y [mm] "\Num:=korY;
            PoseTool:=TempGrabki.tframe;
            PoseKor:=[[0,korY,0],[1,0,0,0]];
            PoseNew:=PoseMult(PoseTool,PoseKor);
            TempGrabki.tframe:=PoseNew;
            !
            ! ------ obliczamy korekte X tool
            korX:=-(((xA+xB)/2)-xC);
            TPWrite "korekta tool_X [mm] "\Num:=korX;
            PoseTool:=TempGrabki.tframe;
            PoseKor:=[[korX,0,0],[1,0,0,0]];
            PoseNew:=PoseMult(PoseTool,PoseKor);
            TempGrabki.tframe:=PoseNew;
            !
            !
            Licznik:=Licznik+1;
            ! sprawdzamy czy nastapila poprawo dokladnosci TCP
            !      IF abs((POPkorX)-abs(korX))<-0.1 THEN
            !        !nastapilo pogorszenie
            !        TPWrite " POGORSZENIE DOKLADNOSCI X TCP";
            !        TPWrite " abs((POPkorX)-abs(korX))= "\Num:=abs((POPkorX)-abs(korX));
            !        TPWrite " +++++++++++++++++++++++++++++";
            !        !STOP;
            !      ENDIF
            !      IF (abs(POPkorY)-abs(korY))<-0.1 THEN
            !        !nastapilo pogorszenie
            !        TPWrite " POGORSZENIE DOKLADNOSCI Y TCP";
            !        TPWrite " abs((POPkorY)-abs(korY))= "\Num:=abs((POPkorY)-abs(korY));
            !        TPWrite " +++++++++++++++++++++++++++++";
            !        !STOP;
            !      ENDIF      
            !
            ! 
        ENDWHILE
        IF Licznik>MaxLicznik THEN
            TPWrite "PRZEKROCZONO LICZBE PROB KALIBRACJI";
            TPWrite "+++++++++++++++++++++++++++++++++++";
            STOP;
        ENDIF
        ! modyfikujemy grabki
        Support:=TempGrabki;
        TPWrite "Zmodyfikowano Support";
        !Stop;
        !    Save "defNarzedzia"\FilePath:="/grabkiFast_bak.sys";
        !
        !    MoveAbsJ bazaKPal1\NoEOffs,v20,fine,tool0\WObj:=wobj0; 
    ENDPROC

    PROC FastCorTCPTIG()
        VAR pose PoseTool;
        VAR pose PoseKor;
        VAR pose PoseNEW;

        ConfL\Off;
        !sprawdzenie czy mamy do czynienia z obrotnikiem czy nie - jest to wazne z punktu widzenia sterowania zewnetrznymi osiami - Ponik
        !   ROT_modifyJointtEax bazaKPal1;
        !   ROT_modifyJointtEax bazaKPal2;

        !   MoveAbsJ bazaKPal1\NoEOffs,v200,fine,tool0\WObj:=wobj0;
        !   MoveAbsJ bazaKPal2\NoEOffs,v200,fine,tool0\WObj:=wobj0;
        ConfJ\Off;
        TempGrabki:=TIG;

        ! obrocenie ukladu wspolrzednych tak by plaszczyzna KZ przechodzila przez punkt TCP narzedzia
        Poczatek:=CPos(\Tool:=tool0\WObj:=wobj0);
        TPWrite "kat obrotu Wobj= "\Num:=ATan2(Poczatek.y,Poczatek.x);
        U_kal.uframe:=[[0,0,0],[0.707106781,0.707106781,0,0]];
        U_kal.oframe:=[[0,0,0],[1,0,0,0]];
        Rot_C:=CRobT(\Tool:=TempGrabki\WObj:=U_kal);
        Rot_C.rot:=O_RownolegleTIG(Rot_C.rot,90);
        ! wyznaczenie pozycji palnika do wyznaczania katow
        Rot_A:=RelTool(Rot_C,0,0,0\Rz:=-90);
        Rot_B:=RelTool(Rot_C,0,0,0\Rz:=+90);

        ! start
        korX:=10;
        korY:=10;
        POPkorX:=100;
        POPkorY:=100;
        Licznik:=0;

        WHILE ((abs(korX)>MaxKorX) OR (abs(korY)>MaxKorY)) AND Licznik<MaxLicznik DO
            ! ustawiamy palnik w pozycji srodkowej
            MoveL Rot_C,PredkoscRob,fine,TempGrabki\WObj:=U_kal;
            WaitUntil\InPos,TRUE;
            RobotXFTIG 1,ZakresDok,PredkoscDok,PredkoscZgr,PredkoscRob,ZakresZgr,TempGrabki,U_kal\BezZgr;
            xC:=Robot_X;
            TPWrite " ---> xC: "\Num:=xC;
            ! ustawiamy palnik w pozycji bocznej
            MoveL Rot_A,PredkoscRob,fine,TempGrabki\WObj:=U_kal;
            WaitUntil\InPos,TRUE;
            RobotXFTIG 1,ZakresDok,PredkoscDok,PredkoscZgr,PredkoscRob,ZakresZgr,TempGrabki,U_kal\BezZgr;
            xA:=Robot_X;
            TPWrite " ---> xA: "\Num:=xA;
            ! ustawiamy palnik w pozycji srodkowej
            MoveL Rot_C,PredkoscRob,z20,TempGrabki\WObj:=U_kal;
            ! ustawiamy palnik w pozycji drugiej bocznej
            MoveL Rot_B,PredkoscRob,fine,TempGrabki\WObj:=U_kal;
            WaitUntil\InPos,TRUE;
            RobotXFTIG 1,ZakresDok,PredkoscDok,PredkoscZgr,PredkoscRob,ZakresZgr,TempGrabki,U_kal\BezZgr;
            xB:=Robot_X;
            TPWrite " ---> xB: "\Num:=xB;
            ! ---> obliczenia korekt   
            POPkorX:=korX;
            POPkorY:=korY;
            ! ------ obliczamy korekte Y tool
            korY:=(xB-xA)/2;
            TPWrite "korekta tool_Y [mm] "\Num:=korY;
            PoseTool:=TempGrabki.tframe;
            PoseKor:=[[0,korY,0],[1,0,0,0]];
            PoseNew:=PoseMult(PoseTool,PoseKor);
            TempGrabki.tframe:=PoseNew;
            !
            ! ------ obliczamy korekte X tool
            korX:=(((xA+xB)/2)-xC);
            TPWrite "korekta tool_X [mm] "\Num:=korX;
            PoseTool:=TempGrabki.tframe;
            PoseKor:=[[korX,0,0],[1,0,0,0]];
            PoseNew:=PoseMult(PoseTool,PoseKor);
            TempGrabki.tframe:=PoseNew;
            !
            !
            Licznik:=Licznik+1;
            ! sprawdzamy czy nastapila poprawo dokladnosci TCP
            !      IF abs((POPkorX)-abs(korX))<-0.1 THEN
            !        !nastapilo pogorszenie
            !        TPWrite " POGORSZENIE DOKLADNOSCI X TCP";
            !        TPWrite " abs((POPkorX)-abs(korX))= "\Num:=abs((POPkorX)-abs(korX));
            !        TPWrite " +++++++++++++++++++++++++++++";
            !        !STOP;
            !      ENDIF
            !      IF (abs(POPkorY)-abs(korY))<-0.1 THEN
            !        !nastapilo pogorszenie
            !        TPWrite " POGORSZENIE DOKLADNOSCI Y TCP";
            !        TPWrite " abs((POPkorY)-abs(korY))= "\Num:=abs((POPkorY)-abs(korY));
            !        TPWrite " +++++++++++++++++++++++++++++";
            !        !STOP;
            !      ENDIF      
            !
            ! 
        ENDWHILE
        IF Licznik>MaxLicznik THEN
            TPWrite "PRZEKROCZONO LICZBE PROB KALIBRACJI";
            TPWrite "+++++++++++++++++++++++++++++++++++";
            STOP;
        ENDIF
        ! modyfikujemy grabki
        TIG:=TempGrabki;
        TPWrite "Zmodyfikowano palnik TIG";
!        Stop;
        !    Save "defNarzedzia"\FilePath:="/grabkiFast_bak.sys";
        !
        !    MoveAbsJ bazaKPal1\NoEOffs,v20,fine,tool0\WObj:=wobj0; 
    ENDPROC
ENDMODULE
