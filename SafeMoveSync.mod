MODULE SafeMoveSync
    CONST robtarget syncPos:=[[2708.30,-971.48,1343.26],[0.229992,0.671732,0.239138,0.662329],[-1,-1,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST jointtarget syncPosJ:=[[-22.0117,35.5653,-11.2704,-46.3133,-31.8836,2.79134],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST jointtarget syncPosJSafe:=[[-33.1626,0.965845,32.508,-51.183,-45.2599,2.09749],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

    PROC Sync()
        SpeedRefresh 15;
        TPWrite "Ustawiono predkosc 10%";
        IF getTool(changerTool) THEN
            ConfJ\On;
            ConfL\On;
            MotionSup\on\TuneValue:=czulosc;
            goToSafePos syncPosJSafe;
            MoveL Offs(syncPos,-400,0,0),hiSpeed,z50,changer\WObj:=wobj0;
            MoveL Offs(syncPos,-50,0,0),lowSpeed,z10,changer\WObj:=wobj0;
            MoveL syncPos,v20,fine,changer\WObj:=wobj0;
            WaitTime\InPos,2;
            MoveL Offs(syncPos,-200,0,0),hiSpeed,z50,changer\WObj:=wobj0;
            MoveAbsJ syncPosJSafe,hiSpeed,fine,changer\WObj:=wobj0;
            SpeedRefresh 100;
            TPWrite "Ustawiono predkosc 100%";
        ENDIF
    ENDPROC
ENDMODULE