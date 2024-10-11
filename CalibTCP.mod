MODULE CalibTCP
  PERS wobjdata U_kalibrator:=[FALSE,TRUE,"",[[0,0,0],[0.875716,0,0,0.482826]],[[0,0,0],[1,0,0,0]]];
  !
  PERS num Tool_fi:=0.995117;
  PERS num Robot_X:=1476.48;
  PERS num Robot_Z:=1016.74;
  PERS tooldata Temp_TOOL:=[TRUE,[[-1.62219,1.91136,247.013],[0.999958,-0.00301733,-0.00861432,9.56278E-05]],[2,[0.1,0,0],[1,0,0,0],0,0,0]];
  CONST robtarget p20:=[[843.69,130.87,1661.48],[0.629288,-5.4E-05,0.777172,0.000242],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
  CONST robtarget p10:=[[1057.35,-8.96,1319.61],[0,0,1,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
  VAR robtarget TestPoint;
  VAR robtarget LastPoint;
  VAR num Tool_X:=0;
  VAR num Tool_Y:=0;
  VAR num Tool_Z:=0;
  VAR pose R6;
  PERS tooldata Torch_TEST:=[TRUE,[[296,-141,299],[0.772667,0.149445,0.59954,-0.145613]],[3,[150,0,150],[1,0,0,0],0,0,0]];
  VAR robtarget T0;
  VAR robtarget ToolNew:=[[0,0,0],[0,0,-1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
  ! kat pochylenia palnika przy kalZ palnika
  PERS num pochylPalnika:=30;

  PROC ZapiszTool(
    tooldata ZapiszTool,
    num Nr)

    VAR iodev DoPlik;

    !Open "flp1:"\File:="TCP_cal.txt",DoPlik\Append;
    !Write DoPlik,"TOOL: "\Num:=Nr;
    !Write DoPlik,"[["\Pos:=ZapiszTool.tframe.trans;
    !Write DoPlik,"],["\Orient:=ZapiszTool.tframe.rot;
    !Write DoPlik,"]]";
    !Close DoPlik;
  ERROR
    IF ERRNO=ERR_FILEOPEN THEN
      !Close DoPlik;
      RETRY;
    ELSEIF ERRNO=ERR_FILEACC THEN
      !Close DoPlik;
      !Open "HOME:"\File:="TCP_cal.txt",DoPlik\Append;
      RETRY;
    ELSE
      TPWrite NumToStr(ERRNO,0);
    ENDIF
  ENDPROC

  PROC RobotXF(
    num Pwt_,
    num Mrg_,
    speeddata Vszuk_,
    speeddata Vzgr_,
    speeddata Vrob_,
    num Xran_,
    PERS tooldata TempPalnik,
    PERS wobjdata U_kalibrator_
    \switch BezZgr)

    !
    ! Wyznaczanie wspolrzednej Y i Srednicy
    !
    VAR testsignal Test_X1;
    VAR robtarget YF_Pl50;
    VAR robtarget YF_Mi50;
    VAR robtarget YF_0;
    VAR robtarget FindA{10};
    VAR robtarget FindB{10};
    VAR robtarget FindZA;
    VAR robtarget FindZB;
    VAR num Licznik;
    VAR num SumaA:=0;
    VAR num SumaB:=0;
    VAR num x;
    VAR num StanSzukania:=0;
    VAR num LiczBledySzuk:=0;
    VAR robtarget YF_A:=[[0,0,0],[1,0,0,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget YF_B:=[[0,0,0],[1,0,0,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
        
    !sprawdzenie czy mamy do czynienia z obrotnikiem czy nie - jest to wazne z punktu widzenia sterowania zewnetrznymi osiami - Ponik
    ROT_modifyRobtEax YF_A;
    ROT_modifyRobtEax YF_B;
    
    YF_0:=CRobT(\Tool:=TempPalnik\WObj:=U_kalibrator_);
    IF (NOT Present(BezZgr)) THEN
          YF_Mi50:=Offs(YF_0,-Xran_,0,0);
          YF_Pl50:=Offs(YF_0,Xran_,0,0);
          MoveL YF_Pl50,Vrob_,fine,TempPalnik\WObj:=U_kalibrator_;
          ! wyszukiwanie zgrubne
          StanSzukania:=1;
          LiczBledySzuk:=0;
          SearchL\Sup,cal,FindZA,YF_Mi50,Vzgr_,TempPalnik\WObj:=U_kalibrator_;
          StanSzukania:=2;
          LiczBledySzuk:=0;
          SearchL\Sup,cal,FindZB,YF_Pl50,Vzgr_,TempPalnik\WObj:=U_kalibrator_;
          StanSzukania:=20;
    ELSE
          FindZA:=YF_0;
          FindZB:=YF_0;
    ENDIF
    ! Wyszukiwanie precyzyjne
    YF_A:=Offs(FindZA,Mrg_,0,0);
    YF_B:=Offs(FindZB,-Mrg_,0,0);
    MoveL YF_A,Vrob_,fine,TempPalnik\WObj:=U_kalibrator_;
    SumaA:=0;
    SumaB:=0;
    FOR Licznik FROM 1 TO Pwt_ DO
      StanSzukania:=3;
      LiczBledySzuk:=0;
      SearchL\Sup,cal,FindA{Licznik},YF_B,Vszuk_,TempPalnik\WObj:=U_kalibrator_;
      StanSzukania:=4;
      LiczBledySzuk:=0;
      SearchL\Sup,cal,FindB{Licznik},YF_A,Vszuk_,TempPalnik\WObj:=U_kalibrator_;
      StanSzukania:=40;
      SumaA:=SumaA+FindA{Licznik}.trans.x;
      SumaB:=SumaB+FindB{Licznik}.trans.x;
    ENDFOR
    Robot_X:=((SumaA/Pwt_)+(SumaB/Pwt_))/2;
    Tool_fi:=Abs((SumaA/Pwt_)-(SumaB/Pwt_));
    MoveL YF_0,Vrob_,fine,TempPalnik\WObj:=U_kalibrator_;
  ERROR
     LiczBledySzuk:=LiczBledySzuk+1;
     IF LiczBledySzuk>3 THEN
          TPWrite " Krytyczny blad w funkcji TCP.mod-->RobotXF: "\Num:=StanSzukania;
          TPWrite " Przekroczono liczbe prob szukania ! ! ! !";
          TPWrite " Sprawdz dzialanie czujnika widelkowego.";
          STOP;     
     ENDIF
     TEST StanSzukania
     CASE 1:
          ! blad szukania zgrubnego
          YF_Mi50:=Offs(YF_0,-Xran_*2,0,0);
          YF_Pl50:=Offs(YF_0,Xran_*2,0,0);
          MoveL YF_Pl50,Vrob_,fine,TempPalnik\WObj:=U_kalibrator_;
          RETRY;
     CASE 2:
          ! blad szukania zgrubnego
          YF_Mi50:=Offs(YF_0,-Xran_*2,0,0);
          YF_Pl50:=Offs(YF_0,Xran_*2,0,0);
          MoveL YF_Mi50,Vrob_,fine,TempPalnik\WObj:=U_kalibrator_;
          RETRY;
     CASE 3:
          YF_A:=Offs(FindZA,Mrg_*2,0,0);
          YF_B:=Offs(FindZB,-Mrg_*2,0,0);
          MoveL YF_A,Vrob_,fine,TempPalnik\WObj:=U_kalibrator_;
          RETRY;
     CASE 4:
          YF_A:=Offs(FindZA,Mrg_*2,0,0);
          YF_B:=Offs(FindZB,-Mrg_*2,0,0);
          MoveL YF_B,Vrob_,fine,TempPalnik\WObj:=U_kalibrator_;
          RETRY;
     DEFAULT:
          TPWrite " Krytyczny blad w funkcji TCP.mod-->RobotXF: "\Num:=StanSzukania;
          TPWrite " Powiesic za jaja Krzysztofa O";
          EXIT;
     ENDTEST
  ENDPROC

  !
  FUNC pose Pose_NewR(
    num x,
    num y,
    num z)

    VAR robtarget X00;
    VAR pose X1;
    VAR pose X2;
    VAR pose X2_X1;
    VAR pose Akt;
    VAR pose PoseNew:=[[0,0,0],[1,0,0,0]];
    VAR num Rx;
    VAR num Ry;
    VAR num Rz;

    ! nowe okreslanie katów
    !
    X00:=CRobT(\Tool:=tool0\WObj:=wobj0);
    X1:=[[0,0,0],X00.rot];
    X2:=[[0,0,0],[0,0,1,0]];
    X2_X1:=PoseMult(PoseInv(X2),X1);
    X2_X1.trans:=[0,0,0];
    !
    PoseNew:=PoseInv(X2_X1);
    !
    PoseNew.trans.x:=x;
    PoseNew.trans.y:=y;
    PoseNew.trans.z:=z;
    !
    RETURN PoseNew;
  ENDFUNC

  FUNC orient O_Rownolegle(
    orient OdoR,
    num Kat)

    VAR num Rx;
    VAR num Ry;
    VAR num Rz;
    VAR num wRx:=0;
    VAR num wRy:=0;
    VAR num wRz:=0;
    VAR orient Owy:=[1,0,0,0];

    ! ***************************************************
    ! *     Korekta orientacji do równoleglej z UR      *
    ! ***************************************************
    !
    ! ustawienie ukladu rownolegle
    Rx:=EulerZYX(\X,OdoR);
    Ry:=EulerZYX(\Y,OdoR);
    Rz:=EulerZYX(\Z,OdoR);
    !
    wRx:=(Kat*Round(Rx/Kat));
    wRy:=(Kat*Round(Ry/Kat));
    wRz:=(Kat*Round(Rz/Kat));
    !
    Owy:=OrientZYX(wRz,wRy,wRx);
    RETURN Owy;
  ENDFUNC

  FUNC orient Rot_O(
    orient inOrient,
    num OX,
    num OY,
    num OZ)

    VAR num O_Rx;
    VAR num O_Ry;
    VAR num O_Rz;
    VAR orient Wy;

    !
    ! ***************************************************
    ! *      Korekta orientacji wg zadanych katow       *
    ! ***************************************************
    !
    O_Rx:=EulerZYX(\X,inOrient)+OX;
    O_Ry:=EulerZYX(\Y,inOrient)+OY;
    O_Rz:=EulerZYX(\Z,inOrient)+OZ;
    Wy:=OrientZYX(O_Rz,O_Ry,O_Rx);
    RETURN Wy;
  ENDFUNC

  PROC RobotZ(
    num UpA_,
    num UpB_,
    num Mrg_,
    num Pwt_,
    speeddata Vszuk_,
    speeddata Vzgr_,
    speeddata Vrob_,
    num Zran_,
    PERS wobjdata U_kalibrator_)

    !
    ! Wyznaczanie wspurzednej Y i Srednicy
    !
    VAR testsignal Test_X1;
    VAR robtarget YF_Pl50:=[[0,0,0],[1,0,0,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget YF_Mi50:=[[0,0,0],[1,0,0,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget YF_0:=[[0,0,0],[1,0,0,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget Center:=[[0,0,0],[1,0,0,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget CenterUp:=[[0,0,0],[1,0,0,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget FindA:=[[0,0,0],[1,0,0,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget FindB:=[[0,0,0],[1,0,0,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget FindEnd:=[[0,0,0],[1,0,0,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget FindZA:=[[0,0,0],[1,0,0,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget FindZB:=[[0,0,0],[1,0,0,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR num Suma;
    VAR num Licznik;
    VAR num Srodek:=0;
    VAR robtarget YF_A:=[[0,0,0],[1,0,0,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget YF_B:=[[0,0,0],[1,0,0,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR num x;
    VAR num Fi;
    VAR num dZ:=2;
    VAR bool JestEnd;
    VAR robtarget NewEnd;
    VAR num StanSzukania:=0;
    VAR num LiczBledySzuk:=0;

    StanSzukania:=0;
    JestEnd:=FALSE;
    YF_0:=CRobT(\Tool:=Temp_TOOL\WObj:=U_kalibrator_);
    YF_Mi50:=Offs(YF_0,-Zran_,0,0);
    YF_Pl50:=Offs(YF_0,Zran_,0,0);
    MoveL YF_Pl50,Vrob_,fine,Temp_TOOL\WObj:=U_kalibrator_;
    ! wyszukiwanie zgrubne
    StanSzukania:=1;
    SearchL\Sup,cal,FindZA,YF_Mi50,Vzgr_,Temp_TOOL\WObj:=U_kalibrator_;
    StanSzukania:=2;
    SearchL\Sup,cal,FindZB,YF_Pl50,Vzgr_,Temp_TOOL\WObj:=U_kalibrator_;
    StanSzukania:=20;
    !
    !
    ! Wyszukiwanie precyzyjne srodka
    ! szukanie zygzakiem
    YF_A:=Offs(FindZA,Mrg_,0,0);
    YF_B:=Offs(FindZB,-Mrg_,0,0);
    JestEnd:=FALSE;
SzukanieKonca:
    MoveL YF_A,Vrob_,fine,Temp_TOOL\WObj:=U_kalibrator_;
    StanSzukania:=3;
    SearchL\Sup,cal,FindA,YF_B,Vszuk_,Temp_TOOL\WObj:=U_kalibrator_;
    StanSzukania:=4;
    SearchL\Sup,cal,FindB,YF_A,Vszuk_,Temp_TOOL\WObj:=U_kalibrator_;
    StanSzukania:=40;
    Srodek:=(YF_A.trans.x+YF_B.trans.x)/2;
    Fi:=YF_A.trans.x-YF_B.trans.x;
    YF_A:=Offs(FindA,Mrg_,0,dZ);
    YF_B:=Offs(FindB,-Mrg_,0,dZ);
    YF_A.rot:=O_Rownolegle(YF_A.rot,pochylPalnika);
    YF_B.rot:=O_Rownolegle(YF_B.rot,pochylPalnika);
    IF JestEnd GOTO PrecSzuk;
    GOTO SzukanieKonca;
    !
PrecSzuk:
    !
    NewEnd:=FindA;
    NewEnd.trans.x:=Srodek;
    NewEnd.trans.z:=(FindA.trans.z+FindB.trans.z)/2;
    NewEnd.rot:=O_Rownolegle(NewEnd.rot,pochylPalnika);
    !
    Center:=NewEnd;
    CenterUp:=Offs(NewEnd,0,0,UpA_);
    !
    ! mamy srodek szukamy konca po Z
    MoveL CenterUp,Vrob_,fine,Temp_TOOL\WObj:=U_kalibrator_;
    StanSzukania:=5;
    SearchL\Stop,cal,FindEnd,Center,Vszuk_,Temp_TOOL\WObj:=U_kalibrator_;
    StanSzukania:=50;
    ! szukamy ponownie srodka bysie upewnic ze to koniec
    YF_A:=Offs(FindEnd,(Fi/2)+Mrg_,0,-1);
    YF_B:=Offs(FindEnd,-(Fi/2)-Mrg_,0,-1);
    MoveL YF_A,Vrob_,fine,Temp_TOOL\WObj:=U_kalibrator_;
    StanSzukania:=6;
    SearchL\Sup,cal,FindA,YF_B,Vszuk_,Temp_TOOL\WObj:=U_kalibrator_;
    StanSzukania:=7;
    SearchL\Sup,cal,FindB,YF_A,Vszuk_,Temp_TOOL\WObj:=U_kalibrator_;
    StanSzukania:=70;
    Srodek:=(YF_A.trans.x+YF_B.trans.x)/2;
    Center:=Offs(FindEnd,0,0,-3);
    Center.trans.x:=Srodek;
    CenterUp:=Offs(Center,0,0,UpB_);
    !
    ! mamy srodek szukamy konca po Z
    !
    MoveL CenterUp,Vzgr_,fine,Temp_TOOL\WObj:=U_kalibrator_;
    Suma:=0;
    FOR Licznik FROM 1 TO Pwt_ DO
      StanSzukania:=8;
      SearchL\Stop,cal,FindEnd,Center,Vszuk_,Temp_TOOL\WObj:=U_kalibrator_;
      StanSzukania:=80;
      CenterUp:=Offs(FindEnd,0,0,3);
      MoveL CenterUp,Vzgr_,fine,Temp_TOOL\WObj:=U_kalibrator_;
      Suma:=Suma+FindEnd.trans.z;
    ENDFOR
    !
    Robot_Z:=Suma/Pwt_;
    LastPoint:=FindEnd;
    LastPoint.trans.z:=Robot_Z;
    MoveL YF_0,Vrob_,fine,Temp_TOOL\WObj:=U_kalibrator_;
  ERROR
     LiczBledySzuk:=LiczBledySzuk+1;
     IF LiczBledySzuk>3 THEN
          TPWrite " Krytyczny blad w funkcji TCP.mod-->RobotXF: "\Num:=StanSzukania;
          TPWrite " Przekroczono liczbe prob szukania ! ! ! !";
          TPWrite " Sprawdz dzialanie czujnika widelkowego.";
          STOP;     
     ENDIF
    TEST StanSzukania
    CASE 1:
      ! wyszukiwanie zgrubne
      TPWrite " (wyszukiwanie zgrubne) blad w funkcji TCP.mod-->RobotZ: "\Num:=StanSzukania;
      YF_Mi50:=Offs(YF_0,-Zran_*2,0,-5);
      YF_Pl50:=Offs(YF_0,Zran_*2,0,-5);
      MoveL YF_Pl50,Vrob_,fine,Temp_TOOL\WObj:=U_kalibrator_;
      RETRY;
    CASE 2:
      ! wyszukiwanie zgrubne
      TPWrite " (wyszukiwanie zgrubne) blad w funkcji TCP.mod-->RobotZ: "\Num:=StanSzukania;
      YF_Mi50:=Offs(YF_0,-Zran_*2,0,-5);
      YF_Pl50:=Offs(YF_0,Zran_*2,0,-5);
      MoveL YF_Mi50,Vrob_,fine,Temp_TOOL\WObj:=U_kalibrator_;  
      RETRY;  
    CASE 3,4:
      IF JestEnd=FALSE THEN
        YF_A:=Offs(YF_A,0,0,-dZ-0.5);
        YF_B:=Offs(YF_B,0,0,-dZ-0.5);
        MoveL YF_A,Vrob_,fine,Temp_TOOL\WObj:=U_kalibrator_;
        JestEnd:=TRUE;
        RETRY;
      ELSE
        TPWrite "Nie znany blad";
        STOP;
      ENDIF    
    CASE 5:
      ! blad szukania konca
      TPWrite " (szukanie konca) blad w funkcji TCP.mod-->RobotZ: "\Num:=StanSzukania;
      NewEnd:=FindA;
      NewEnd.trans.x:=Srodek;
      NewEnd.trans.z:=(FindA.trans.z+FindB.trans.z)/2;
      NewEnd.rot:=O_Rownolegle(NewEnd.rot,pochylPalnika);
      !
      Center:=Offs(NewEnd,0,0,-3);
      CenterUp:=Offs(NewEnd,0,0,UpA_);
      !
      ! mamy srodek szukamy konca po Z
      MoveL CenterUp,Vrob_,fine,Temp_TOOL\WObj:=U_kalibrator_;
      RETRY;
    DEFAULT:
      TPWrite " Krytyczny blad w funkcji TCP.mod-->RobotZ: "\Num:=StanSzukania;
      TPWrite " Powiesic za jaja Krzysztofa O";
      STOP;
      EXIT;
    ENDTEST
  ENDPROC

  FUNC pose Pose_Tool(
    num Z_pszod,
    num X_dol,
    num Y_lewo,
    num rot_X,
    num rot_Y,
    num rot_Z)

    VAR pose PT:=[[0,0,0],[1,0,0,0]];

    !
    ! ***************************************************
    ! *     Nowa orientacja z wspolrzednych i katow     *
    ! ***************************************************
    !
    PT.trans.x:=X_dol;
    PT.trans.y:=Y_lewo;
    PT.trans.z:=Z_pszod;
    PT.rot:=OrientZYX(rot_Z,rot_Y,rot_X);
    RETURN PT;
  ENDFUNC

  PROC TCPmain()
    !
    ! Program do sprawdzania i korekty palników spawalniczych
    !  wymaga wstepnie zdefiniowanego palnika +-10mm +-5deg
    !  korekta = 1  to tylko korygujemy  0 to nowy uklad
    !
    VAR bool korekta:=TRUE;
    VAR robtarget Start_0:=[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR pose xxx:=[[0,0,0],[1,0,0,0]];
    VAR tooldata X_Tool:=[TRUE,[[0,0,0],[0,0,0,0]],[0,[0,0,0],[0,0,0,0],0,0,0]];
    VAR robtarget Rot_A:=[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget Rot_B:=[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget Rot_C:=[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget Rot_D:=[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget Rot_E:=[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget Rot_F:=[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget Rot_X1:=[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget Rot_X2:=[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR orient Orientacja;
    VAR num Rx;
    VAR num Ry;
    VAR num Rz;
    VAR num Yra;
    VAR num Yrb;
    VAR num Yrc;
    VAR num Yrd;
    VAR num Yre;
    VAR num Yrf;
    VAR num Zr1;
    VAR num Zr2;
    VAR num Zrc;
    VAR num Y_td;
    VAR num Z_td;
    VAR num X_td;
    VAR num Ry_td;
    VAR num Rx_td;
    !!!VAR num Up;
    !!!VAR num UpA;
    !!!VAR num UpB;
    !!!VAR num Mrg;
    !!!VAR num Pwt;
    !!!VAR speeddata Vszuk;
    !!!VAR speeddata Vzgr;
    !!!VAR speeddata Vrob;
    VAR iodev PlikWynikowy;
    !!!VAR num Xran;
    !!!VAR num Zran;
    VAR num   x;
    VAR num   y;
    VAR num   a;
    VAR num   b;
    VAR num   c;
    VAR pose  PoseTool;
    VAR pose  PoseNew;
    VAR pose  PoseKor;
    VAR num   LiczCal:=0;
    VAR iodev DoPliku;
    !
    VAR pos   Poczatek;
    !
    VAR bool  zmnGrabki;

    AccSet 10,10;
    TPErase;
    TPWrite "Korekta palnika :";
    ConfJ\Off;
    ConfL\Off;
    !
    !
    !$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    !$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
StartPocz:
    !
    Temp_TOOL:=grabki;
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    ! obrocenie ukladu wspolrzednych tak by plaszczyzna KZ przechodzila przez punkt TCP narzedzia
    Poczatek:=CPos(\Tool:=tool0\WObj:=wobj0);
    !
    TPWrite "kat obrotu Wobj= "\Num:=ATan2(Poczatek.y,Poczatek.x);
    U_kalibrator.uframe:=[[0,0,0],OrientZYX(ATan2(Poczatek.y,Poczatek.x),0,0)];
    U_kalibrator.oframe:=[[0,0,0],[1,0,0,0]];
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    !
    Rot_C:=CRobT(\Tool:=Temp_TOOL\WObj:=U_kalibrator);
    LiczCal:=0;
Powtorka:
    LiczCal:=LiczCal+1;
    ZapiszTool Temp_TOOL,LiczCal;
    !Open "flp1:"\File:="TCP_cal.txt",DoPliku\Append;
    MoveJ Rot_C,v100,fine,Temp_TOOL\WObj:=U_kalibrator;
    TPErase;
    TPReadFK x,"Korekta czy wyznaczenie nowych wspolrzednych","","KOREKTA","rot Z","NOWE","";
    IF x=3 THEN
      ! obracanie po osi Z
      x:=999;
      WHILE x<>5 DO
        TEST x
        CASE 1:
          grabki:=toolKorekta(grabki,0,0,0,0,0,-5);
          Temp_TOOL:=grabki;
          MoveJ Rot_C,v100,fine,Temp_TOOL\WObj:=U_kalibrator;
        CASE 2:
          grabki:=toolKorekta(grabki,0,0,0,0,0,-1);
          Temp_TOOL:=grabki;
          MoveJ Rot_C,v100,fine,Temp_TOOL\WObj:=U_kalibrator;
        CASE 3:
          grabki:=toolKorekta(grabki,0,0,0,0,0,1);
          Temp_TOOL:=grabki;
          MoveJ Rot_C,v100,fine,Temp_TOOL\WObj:=U_kalibrator;
        CASE 4:
          grabki:=toolKorekta(grabki,0,0,0,0,0,5);
          Temp_TOOL:=grabki;
          MoveJ Rot_C,v100,fine,Temp_TOOL\WObj:=U_kalibrator;
        ENDTEST
        TPReadFK x,"Obracanie po osi Z","-5","-1","+1","+5","exit";
      ENDWHILE
      !
      GOTO StartPocz;
    ENDIF
    IF x=4 korekta:=FALSE;
    IF x=2 korekta:=TRUE;
    IF korekta THEN
      ! ustawienie ukladu nazedzia rownolegle do ukladu podstawy robota
      Rot_C.rot:=O_Rownolegle(Rot_C.rot,90);
    ELSE
      ! wyznaczamy nowy uklad narzedzia
      TPErase;
      TPWrite "Prosze podac pozycje koncowki palnika wzgledem mniejsca mocowania";
      TPReadNum Tool_X,"X - odsuniecie w dól ?";
      TPReadNum Tool_Y,"Y - odsuniecie w lewo ?";
      TPReadNum Tool_Z,"Z - odsuniecie w przód ?";
      Temp_TOOL.tframe:=Pose_NewR(Tool_X,Tool_Y,Tool_Z);
      TPErase;
      TPWrite "Tool_pos:"\Pos:=Temp_TOOL.tframe.trans;
      TPWrite "Tool_pos:"\Orient:=Temp_TOOL.tframe.rot;
      Rot_C:=CRobT(\Tool:=Temp_TOOL\WObj:=U_kalibrator);
      Rot_C.rot:=O_Rownolegle(Rot_C.rot,90);
    ENDIF
    !
    MoveJ Rot_C,v100,fine,Temp_TOOL\WObj:=U_kalibrator;
    ! wyznaczenie pozycji palnika do wyznaczania katow
    Rot_A:=RelTool(Rot_C,0,0,0\Rz:=-90);
    Rot_B:=RelTool(Rot_C,0,0,0\Rz:=+90);
    Rot_D:=RelTool(Rot_C,0,0,Up);
    Rot_E:=RelTool(Rot_D,0,0,0\Rz:=-90);
    Rot_F:=RelTool(Rot_D,0,0,0\Rz:=+90);
    !
    !######################
    ! #  korekta kata Rx  #
    !######################
    ! dol
    MoveL Rot_A,Vrob,fine,Temp_TOOL\WObj:=U_kalibrator;
    RobotXF Pwt,Mrg,Vszuk,Vzgr,Vrob,Xran,Temp_TOOL,U_kalibrator;
    Yra:=Robot_X;
    ! gora
    MoveL Rot_E,Vrob,fine,Temp_TOOL\WObj:=U_kalibrator;
    RobotXF Pwt,Mrg,Vszuk,Vzgr,Vrob,Xran,Temp_TOOL,U_kalibrator;
    Yre:=Robot_X;
    !
    MoveL Rot_A,Vrob,z5,Temp_TOOL\WObj:=U_kalibrator;
    MoveL Rot_C,Vrob,z10,Temp_TOOL\WObj:=U_kalibrator;
    ! dol
    MoveL Rot_B,Vrob,fine,Temp_TOOL\WObj:=U_kalibrator;
    RobotXF Pwt,Mrg,Vszuk,Vzgr,Vrob,Xran,Temp_TOOL,U_kalibrator;
    Yrb:=Robot_X;
    ! gora
    MoveL Rot_F,Vrob,fine,Temp_TOOL\WObj:=U_kalibrator;
    RobotXF Pwt,Mrg,Vszuk,Vzgr,Vrob,Xran,Temp_TOOL,U_kalibrator;
    Yrf:=Robot_X;
    !
    ! obliczamy kat do korekty
    Rx_td:=ATan(((Yre-Yra+Yrb-Yrf)/2)/Up);
    ! korygujemy narzedzie
    TPWrite "korekta Rx [deg] "\Num:=Rx_td;
    !Write DoPliku,"Rx (deg) = "\Num:=Rx_td;
    Temp_TOOL:=toolKorekta(Temp_TOOL,0,0,0,Rx_td,0,0);
    !
    !Rot_C.rot:=O_Rownolegle(Rot_C.rot);
    MoveL Rot_B,Vrob,z5,Temp_TOOL\WObj:=U_kalibrator;
    MoveL Rot_C,Vrob,z5,Temp_TOOL\WObj:=U_kalibrator;
    MoveL Rot_D,Vrob,fine,Temp_TOOL\WObj:=U_kalibrator;
    !
    !######################
    ! #  korekta kata Ry  #
    !######################
    ! Y robota w pozycji dolnej
    MoveL Rot_C,Vrob,fine,Temp_TOOL\WObj:=U_kalibrator;
    RobotXF Pwt,Mrg,Vszuk,Vzgr,Vrob,Xran,Temp_TOOL,U_kalibrator;
    Yrc:=Robot_X;
    ! Y robota w pozycji gornej
    MoveL Rot_D,Vrob,fine,Temp_TOOL\WObj:=U_kalibrator;
    RobotXF Pwt,Mrg,Vszuk,Vzgr,Vrob,Xran,Temp_TOOL,U_kalibrator;
    Yrd:=Robot_X;
    ! obliczamy kat do korekty
    Ry_td:=-ATan((Yrd-Yrc)/Up);
    ! korygujemy narzedzie
    TPWrite "korekta Ry [deg] "\Num:=Ry_td;
    !Write DoPliku,"Ry (deg) = "\Num:=Ry_td;
    Temp_TOOL:=toolKorekta(Temp_TOOL,0,0,0,0,Ry_td,0);
    !###########################
    ! #  korekta wsp. Y tool   #
    !###########################
    !
    MoveL Rot_A,Vrob,fine,Temp_TOOL\WObj:=U_kalibrator;
    RobotXF Pwt,Mrg,Vszuk,Vzgr,Vrob,Xran,Temp_TOOL,U_kalibrator;
    Yra:=Robot_X;
    !
    MoveL Rot_C,Vrob,z20,Temp_TOOL\WObj:=U_kalibrator;
    MoveL Rot_B,Vrob,fine,Temp_TOOL\WObj:=U_kalibrator;
    RobotXF Pwt,Mrg,Vszuk,Vzgr,Vrob,Xran,Temp_TOOL,U_kalibrator;
    Yrb:=Robot_X;
    ! obliczamy korekte Y tool
    Y_td:=(Yrb-Yra)/2;
    TPWrite "korekta tool_Y [mm] "\Num:=Y_td;
    !Write DoPliku,"tool_Y (mm) = "\Num:=Y_td;
    !
    PoseTool:=Temp_TOOL.tframe;
    PoseKor:=[[0,-Y_td,0],[1,0,0,0]];
    PoseNew:=PoseMult(PoseTool,PoseKor);
    Temp_TOOL.tframe:=PoseNew;
    !
    !Temp_Tool.tframe.trans.y:=Temp_Tool.tframe.trans.y-Y_td;
    ! korekta punktu obrotu
    Rot_C.trans.y:=Rot_C.trans.y-Y_td;
    Rot_A.trans.y:=Rot_C.trans.y;
    Rot_B.trans.y:=Rot_C.trans.y;
    MoveL Rot_C,Vrob,fine,Temp_TOOL\WObj:=U_kalibrator;
    !
    !###########################
    ! #  korekta wsp. Z tool  - przesowamy po tool_X #
    !###########################
    !
    MoveL Rot_A,Vrob,fine,Temp_TOOL\WObj:=U_kalibrator;
    RobotXF Pwt,Mrg,Vszuk,Vzgr,Vrob,Xran,Temp_TOOL,U_kalibrator;
    Yra:=Robot_X;
    !
    MoveL Rot_C,Vrob,z20,Temp_TOOL\WObj:=U_kalibrator;
    MoveL Rot_B,Vrob,fine,Temp_TOOL\WObj:=U_kalibrator;
    RobotXF Pwt,Mrg,Vszuk,Vzgr,Vrob,Xran,Temp_TOOL,U_kalibrator;
    Yrb:=Robot_X;
    !
    MoveL Rot_C,Vrob,fine,Temp_TOOL\WObj:=U_kalibrator;
    RobotXF Pwt,Mrg,Vszuk,Vzgr,Vrob,Xran,Temp_TOOL,U_kalibrator;
    Yrc:=Robot_X;
    ! wyznaczamy korekte Z tool
    Z_td:=-(((Yrb+Yra)/2)-Yrc);
    !
    TPWrite "korekta tool_X [mm] "\Num:=Z_td;
    !Write DoPliku,"tool_X (mm) = "\Num:=Z_td;
    !Temp_Tool.tframe.trans.z:=Temp_Tool.tframe.trans.z-Z_td;
    !
    PoseTool:=Temp_TOOL.tframe;
    PoseKor:=[[Z_td,0,0],[1,0,0,0]];
    PoseNew:=PoseMult(PoseTool,PoseKor);
    Temp_TOOL.tframe:=PoseNew;
    ! korekta punktu obrotu
    Rot_C.trans.x:=Rot_C.trans.x+Z_td;
    MoveL Rot_C,Vrob,fine,Temp_TOOL\WObj:=U_kalibrator;
    !
    !###########################
    ! #  korekta wsp. X tool  przesowamy po osi tool_Z #
    !###########################
    !
    ! Z robota w pozycji 0
    MoveL Rot_C,Vrob,fine,Temp_TOOL\WObj:=U_kalibrator;
    RobotZ UpA,UpB,Mrg,Pwt,Vszuk,Vzgr,Vrob,Zran,U_kalibrator;
    Zrc:=Robot_Z;
    TestPoint:=Offs(LastPoint,0,0,-4);
    ! korekta punktu
    Rot_C.trans.z:=Zrc-5;
    ! wyznaczmy nowe pozycje +pochylPalnika i -pochylPalnika stopni X
    Rot_X1:=RelTool(Rot_C,0,0,0\Rx:=-pochylPalnika);
    Rot_X2:=RelTool(Rot_C,0,0,0\Rx:=+pochylPalnika);
    ! Z robota w pozycji -pochylPalnika
    MoveL Rot_X1,Vrob,fine,Temp_TOOL\WObj:=U_kalibrator;
    RobotZ UpA,UpB,Mrg,Pwt,Vszuk,Vzgr,Vrob,Zran,U_kalibrator;
    Zr1:=Robot_Z;
    !
    ! Z robota w pozycji +pochylPalnika
    MoveL Rot_X2,Vrob,fine,Temp_TOOL\WObj:=U_kalibrator;
    RobotZ UpA,UpB,Mrg,Pwt,Vszuk,Vzgr,Vrob,Zran,U_kalibrator;
    Zr2:=Robot_Z;
    !
    ! wyznaczamy korekte X tool
    X_td:=(Zrc-((Zr1+Zr2)/2))/(2*Pow(Cos((180-pochylPalnika)/2),2));
    !
    TPWrite "korekta tool_Z [mm] "\Num:=X_td;
    !Write DoPliku,"tool_Z (mm) = "\Num:=X_td;
    !Temp_Tool.tframe.trans.x:=Temp_Tool.tframe.trans.x+X_td;
    !
    PoseTool:=Temp_TOOL.tframe;
    PoseKor:=[[0,0,X_td],[1,0,0,0]];
    PoseNew:=PoseMult(PoseTool,PoseKor);
    Temp_TOOL.tframe:=PoseNew;
    WaitTime 1;
    !Close DoPliku;
    ZapiszTool Temp_TOOL,LiczCal;
    !Open "flp1:"\File:="TCP_cal.txt",DoPliku\Append;
    !Write DoPliku,"";
    !Write DoPliku,"###################";
    !Write DoPliku,"";
    !Close DoPliku;
    TPReadFK x,"","","","","","dalej";
    !
    TPWrite "Temp_Tool :";
    TPWrite ""\Pos:=Temp_TOOL.tframe.trans;
    TPWrite ""\Orient:=Temp_TOOL.tframe.rot;
    !
    TPWrite "Zaktualizowano wspulrzedne palnika.";
    TPWrite "Rx = "\Num:=EulerZYX(\X,Temp_TOOL.tframe.rot);
    TPWrite "Ry = "\Num:=EulerZYX(\Y,Temp_TOOL.tframe.rot);
    TPWrite "Rz = "\Num:=EulerZYX(\Z,Temp_TOOL.tframe.rot);
    zmnGrabki:=FALSE;
EndMenu:
    IF zmnGrabki THEN
      TPReadFK x,"","","","test","repeat","end";
    ELSE
      TPReadFK x,"","mod.grabki","","test","repeat","end";
    ENDIF
    !
    TEST x
    CASE 1:
      ! modyfikacja grabek
      IF zmnGrabki GOTO EndMenu;
      TPReadFK y," NA PEWNO ZMODYFIKOWAC TOOL grabki ?","","TAK","","NIE","";
      IF y=2 THEN
        grabki:=Temp_TOOL;
        Save "defNarzedzia"\FilePath:="/grabki_bak.sys";
        zmnGrabki:=TRUE;
        TPWrite " Zmodyfikowano grabki !";
      ELSE
        TPWrite " Grabki pozostaly bez zmian";
      ENDIF
    CASE 4:
      Rot_C:=TestPoint;
      MoveL Rot_C,v100,fine,Temp_TOOL\WObj:=U_kalibrator;
      GOTO Powtorka;
    CASE 5:
      ! end
      Rot_C:=TestPoint;
      MoveL Rot_C,v100,fine,Temp_TOOL\WObj:=U_kalibrator;
      GOTO KoniecPrg;
    ENDTEST
    !
!     Rot_C:=TestPoint;
!     MoveL Rot_C,v100,fine,Temp_TOOL\WObj:=U_kalibrator;
!     ! wyznaczenie pozycji palnika do wyznaczania katow
!     Rot_A:=RelTool(Rot_C,0,0,0\Rz:=-90);
!     Rot_B:=RelTool(Rot_C,0,0,0\Rz:=+90);
!     MoveL Rot_A,v100,fine,Temp_TOOL\WObj:=U_kalibrator;
!     MoveL Rot_C,v100,z20,Temp_TOOL\WObj:=U_kalibrator;
!     MoveL Rot_B,v100,fine,Temp_TOOL\WObj:=U_kalibrator;
!     MoveL Rot_C,v100,z20,Temp_TOOL\WObj:=U_kalibrator;
!     MoveL Rot_A,v100,fine,Temp_TOOL\WObj:=U_kalibrator;
!     MoveL Rot_C,v100,z20,Temp_TOOL\WObj:=U_kalibrator;
!     MoveL Rot_B,v100,fine,Temp_TOOL\WObj:=U_kalibrator;
!     MoveL Rot_C,v100,z20,Temp_TOOL\WObj:=U_kalibrator;
    GOTO EndMenu;
KoniecPrg:
    !
  ENDPROC
ENDMODULE
