MODULE WobjTools
    
    ! obraca Orient by kat obrotu wgledem optymalnej orientacji byl minimalny
    
    FUNC orient dokrecPoZ(orient in, orient optymalna)
        VAR pose inP:=[[0,0,0],[0,0,0,0]];
        VAR pose optimP:=[[0,0,0],[0,0,0,0]];
        VAR pose delta:=[[0,0,0],[0,0,0,0]];
        VAR num deltaRotZ;
        VAR pose poprawka:=[[0,0,0],[0,0,0,0]];
        VAR pose result:=[[0,0,0],[0,0,0,0]];
        
        inP.rot:=in;
        optimP.rot:=optymalna;
        delta:=PoseMult(PoseInv(inP),optimP);
        deltaRotZ:=EulerZYX(\Z,delta.rot);
        ErrWrite \I,"WobjTools:dokrecPoZ()","Poprawka orientacji"\RL2:= "obracamy o kat po osi Z rZ="+NumToStr(deltaRotZ,3);
        poprawka.rot:=OrientZYX(deltaRotZ,0,0);
        result:=PoseMult(inP, poprawka);
        
        RETURN result.rot;
    ENDFUNC 
ENDMODULE