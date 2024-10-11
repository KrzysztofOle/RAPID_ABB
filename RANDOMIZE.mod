MODULE RANDOMIZE
    VAR signalai wejSzumu;
    VAR num szumMax:=-999;
    VAR num szumMin:=999;
    
PROC UstawWejSzumu(VAR signalai stgnalSzumu)
    AliasIO stgnalSzumu,wejSzumu;
ENDPROC    
    
PROC AnalizaSzumu()
    VAR num sygnal;
    FOR i FROM 1 TO 100 DO
        sygnal:=AInput(wejSzumu);    
        IF szumMax<sygnal szumMax:=sygnal;
        IF szumMin>sygnal szumMin:=sygnal;
        WaitTime 0.1;
        !TPWrite ""\Num:=sygnal;
    ENDFOR
    
ENDPROC

FUNC num Random(num min, num max)
    VAR num sygnal;
    VAR num signalBase;
    VAR num szum;
    VAR num zakres;
    VAR num result;
    
    sygnal:=AInput(wejSzumu);
    signalBase:=Trunc(sygnal\Dec:=1);
    szum:=(sygnal-signalBase)*10;
    
    zakres:=max-min;
    result:=min+(zakres*szum);
    
    RETURN result;
    
ENDFUNC

PROC testRandom()

    FOR i FROM 1 TO 10 DO
        ErrWrite \I,"Random(-1,1) = "+NumToStr(Random(-1,1),5),"";
        WaitTime 0.2;
    ENDFOR
ENDPROC

ENDMODULE