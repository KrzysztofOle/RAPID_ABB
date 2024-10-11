MODULE EfektorLibary
    PROC EL_Set(singdata digitalOut, singdata potwierdzenie)
        
    ENDPROC
    
    PROC EL_Gripper(\switch grOpen |switch grClose |switch grTake)
        VAR bool timeut_temp:=FALSE;
        
        IF (Present(grOpen) AND (NOT Present(grClose)) AND (NOT Present(grTake))) THEN
            ! otwiranie chwytaka    
            Reset RSH_gripperClose;
            Set RSH_gripperOpen;
!            WHILE TestDI(RSH_gripperIsClose) DO
!                WaitDI RSH_gripperIsClose,0\MaxTime:=2.5\TimeFlag:=timeut_temp;
!                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_Gripper grOpen", "Sprawdz czy dziala chwytak na glowicy laserowej." \RL2:="Sygnal RSH_gripperIsClose ciagle aktywny.";
!                    IF towerUse towerHelp \handleStop;      
!                ENDIF
!            ENDWHILE
!            WHILE (NOT TestDI(RSH_gripperIsOpen)) DO
!                WaitDI RSH_gripperIsOpen,1\MaxTime:=2.5\TimeFlag:=timeut_temp;
!                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_Gripper grOpen","Sprawdz czy dziala chwytak na glowicy laserowej."\RL2:="Sygnal RSH_gripperIsOpen nie aktywowal sie w wymaganym czasie.";
!                    IF towerUse towerHelp \handleStop;      
!                ENDIF
!            ENDWHILE
            
        ELSEIF ((NOT Present(grOpen)) AND Present(grClose) AND (NOT Present(grTake))) THEN
            ! zamykanie pustego chwytaka
            Reset RSH_gripperOpen;
            Set RSH_gripperClose;
!            WHILE TestDI(RSH_gripperIsOpen) DO
!                WaitDI RSH_gripperIsOpen,0\MaxTime:=2.5\TimeFlag:=timeut_temp;
!                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_Gripper grClose", "Sprawdz czy dziala chwytak na glowicy laserowej." \RL2:="Sygnal RSH_gripperIsOpen ciagle aktywny.";
!                    IF towerUse towerHelp \handleStop;      
!                ENDIF
!            ENDWHILE
!            WHILE (NOT TestDI(RSH_gripperIsClose)) DO
!                WaitDI RSH_gripperIsClose,1\MaxTime:=2.5\TimeFlag:=timeut_temp;
!                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_Gripper grClose","Sprawdz czy dziala chwytak na glowicy laserowej."\RL2:="Sygnal RSH_gripperIsClose nie aktywowal sie w wymaganym czasie.";
!                    IF towerUse towerHelp \handleStop;      
!                ENDIF            
!            ENDWHILE
            
        ELSEIF ((NOT Present(grOpen)) AND (NOT Present(grClose)) AND Present(grTake)) THEN    
            ! zamykanie chwytaka w celu pobrania korka/zatyczki
            Reset RSH_gripperOpen;
            Set RSH_gripperClose;
!            WHILE TestDI(RSH_gripperIsOpen) DO
!                WaitDI RSH_gripperIsOpen,0\MaxTime:=2.5\TimeFlag:=timeut_temp;
!                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_Gripper grClose", "Sprawdz czy dziala chwytak na glowicy laserowej." \RL2:="Sygnal RSH_gripperIsOpen ciagle aktywny.";
!                    IF towerUse towerHelp \handleStop;      
!                ENDIF
!            ENDWHILE 
!            WaitTime 1;
!            IF TestDI(RSH_gripperIsClose) THEN
!                ErrWrite "Error in EfektorLibary:EL_Gripper grTake", "Chwytak nie zlapal elementu." \RL2:="Sygnal RSH_gripperIsClose aktywowal sie.";  
!                IF towerUse towerHelp \handleStop; 
!            ENDIF 
        ELSE
            ! bledny przelacznik funkcji
!            ErrWrite "Error in EfektorLibary:EL_Gripper(grOpen lub grClose lub grGet)", "Bledny parametr funkcji EL_Gripper, musi byc urzyty tylko 1 przlacznik";
            ErrWriteID 25;
        ENDIF   
        

        
    ENDPROC
    
    PROC EL_IlluminatorCover(\switch icOpen |switch icClose)
        VAR bool timeut_temp:=FALSE;
        
        IF (Present(icOpen) AND (NOT Present(icClose))) THEN
            ! otwiranie klapki    
            Reset RSH_illuminatorCoverClose;
            Set RSH_illuminatorCoverOpen;
            WHILE TestDI(RSH_illuminatorCoverIsClose) DO
                WaitDI RSH_illuminatorCoverIsClose,0\MaxTime:=2.5\TimeFlag:=timeut_temp;
                IF timeut_temp THEN
!                    ErrWrite \W,"Error in EfektorLibary:EL_IlluminatorCover icOpen", "Sprawdz czy dziala klapka na glowicy laserowej." \RL2:="Sygnal RSH_illuminatorCoverIsClose ciagle aktywny.";
                    ErrWriteID 30;
                    IF towerUse towerHelp \handleStop;      
                ENDIF
            ENDWHILE 
            WHILE (NOT TestDI(RSH_illuminatorCoverIsOpen)) DO
                WaitDI RSH_illuminatorCoverIsOpen,1\MaxTime:=2.5\TimeFlag:=timeut_temp;
                IF timeut_temp THEN
!                    ErrWrite \W,"Error in EfektorLibary:EL_IlluminatorCover icOpen","Sprawdz czy dziala klapka na glowicy laserowej."\RL2:="Sygnal RSH_illuminatorCoverIsOpen nie aktywowal sie w wymaganym czasie.";
                    ErrWriteID 31;
                    IF towerUse towerHelp \handleStop;      
                ENDIF
            ENDWHILE 
        ELSEIF ((NOT Present(icOpen)) AND Present(icClose)) THEN
            ! zamykanie klapki
            Reset RSH_illuminatorCoverOpen;
            Set RSH_illuminatorCoverClose;
            WHILE TestDI(RSH_illuminatorCoverIsOpen) DO
                WaitDI RSH_illuminatorCoverIsOpen,0\MaxTime:=2.5\TimeFlag:=timeut_temp;
                IF timeut_temp THEN
!                    ErrWrite \W,"Error in EfektorLibary:EL_IlluminatorCover icClose", "Sprawdz czy dziala klapka na glowicy laserowej." \RL2:="Sygnal RSH_illuminatorCoverIsOpen ciagle aktywny.";
                    ErrWriteID 30;
                    IF towerUse towerHelp \handleStop;      
                ENDIF
            ENDWHILE 
            WHILE (NOT TestDI(RSH_illuminatorCoverIsClose)) DO
            WaitDI RSH_illuminatorCoverIsClose,1\MaxTime:=2.5\TimeFlag:=timeut_temp;
                IF timeut_temp THEN
!                    ErrWrite \W,"Error in EfektorLibary:EL_IlluminatorCover icClose","Sprawdz czy dziala klapka na glowicy laserowej."\RL2:="Sygnal RSH_illuminatorCoverIsClose nie aktywowal sie w wymaganym czasie.";
                    ErrWriteID 31;
                    IF towerUse towerHelp \handleStop;      
                ENDIF  
            ENDWHILE 
            
        ELSE
            ! bledny przelacznik funkcji
!            ErrWrite "Error in EfektorLibary:EL_IlluminatorCover(icOpen lub icClose)", "Bledny parametr funkcji EL_IlluminatorCover, musi byc urzyty tylko 1 przlacznik";
            ErrWriteID 25;
            Stop;
            !EXIT;
        ENDIF   

    ENDPROC    
    
    PROC EL_RSC_piston(\switch down |switch up |switch press)
        VAR bool timeut_temp:=FALSE;
        
        IF Present(down) THEN
            ! silownik w dol bez elementu na obrotniku (musi zadzialac dolna krancowka)
            Reset RSC_pistonUp;
            Set RSC_pistonDown;
            WHILE TestDI(RSC_pistonIsUp) DO
                WaitDI RSC_pistonIsUp,0\MaxTime:=2\TimeFlag:=timeut_temp;
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSC_piston down", "Sprawdz czy dziala silownik po stronie spawania plaszcz." \RL2:="Sygnal RSC_pistonIsUp ciagle aktywny.";
                    ErrWriteID 32;
                    IF towerUse towerHelp \handleStop;      
                ENDIF   
            ENDWHILE
            WHILE (NOT TestDI(RSC_pistonIsDown)) DO
                WaitDI RSC_pistonIsDown,1\MaxTime:=10\TimeFlag:=timeut_temp;
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSC_piston down", "Sprawdz czy dziala silownik po stronie spawania plaszcz." \RL2:="Sygnal RSC_pistonIsDown nie katywowal sie.";
                    ErrWriteID 33;
                    IF towerUse towerHelp \handleStop;      
                ENDIF  
            ENDWHILE
            WHILE (NOT TestDI(RSC_pistonIsPressed)) DO
                WaitDI RSC_pistonIsPressed,1\MaxTime:=5\TimeFlag:=timeut_temp;
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSC_piston down", "Sprawdz czy dziala silownik i przekaznika cisnienia po stronie spawania plaszcz." \RL2:="Sygnal RSC_pistonIsPressed nie katywowal sie.";
                    ErrWriteID 34;
                    IF towerUse towerHelp \handleStop;      
                ENDIF
            ENDWHILE
                
        ELSEIF Present(up) THEN
            ! zwalniamy elementy na obrotniku
            Reset RSC_pistonDown;
            Set RSC_pistonUp;
            WHILE TestDI(RSC_pistonIsDown) DO
                WaitDI RSC_pistonIsDown,0\MaxTime:=2\TimeFlag:=timeut_temp;
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSC_piston up", "Sprawdz czy dziala silownik po stronie spawania plaszcz." \RL2:="Sygnal RSC_pistonIsDown ciagle aktywny.";
                    ErrWriteID 35;
                    IF towerUse towerHelp \handleStop;      
                ENDIF   
            ENDWHILE
            WHILE (NOT TestDI(RSC_pistonIsUp)) DO
                WaitDI RSC_pistonIsUp,1\MaxTime:=10\TimeFlag:=timeut_temp;
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSC_piston up", "Sprawdz czy dziala silownik po stronie spawania plaszcz." \RL2:="Sygnal RSC_pistonIsUp nie katywowal sie.";
                    ErrWriteID 36;
                    IF towerUse towerHelp \handleStop;      
                ENDIF  
            ENDWHILE
            WHILE TestDI(RSC_pistonIsPressed) DO
                WaitDI RSC_pistonIsPressed,0\MaxTime:=5\TimeFlag:=timeut_temp;
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSC_piston up", "Sprawdz czy dziala silownik i przekaznika cisnienia po stronie spawania plaszcz." \RL2:="Sygnal RSC_pistonIsPressed ciagle aktywny.";
                    ErrWriteID 37;
                    IF towerUse towerHelp \handleStop;      
                ENDIF
            ENDWHILE
        
        ELSEIF Present(press) THEN    
            ! dociskamy elementy na obrotniku
            Reset RSC_pistonUp;
            Set RSC_pistonDown;
            WHILE TestDI(RSC_pistonIsUp) DO
                WaitDI RSC_pistonIsUp,0\MaxTime:=2\TimeFlag:=timeut_temp;
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSC_piston press", "Sprawdz czy dziala silownik po stronie spawania plaszcz." \RL2:="Sygnal RSC_pistonIsUp ciagle aktywny.";
                    ErrWriteID 32;
                    IF towerUse towerHelp \handleStop;      
                ENDIF 
            ENDWHILE
            WHILE (NOT TestDI(RSC_pistonIsPressed)) DO
                WaitDI RSC_pistonIsPressed,1\MaxTime:=10\TimeFlag:=timeut_temp;
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSC_piston press", "Sprawdz czy dziala silownik i przekaznika cisnienia po stronie spawania plaszcz." \RL2:="Sygnal RSC_pistonIsPressed nie katywowal sie.";
                    ErrWriteID 34;
                    IF towerUse towerHelp \handleStop;      
                ENDIF     
            ENDWHILE
            WaitTime 1;
            IF TestDI(RSC_pistonIsDown) THEN
!                ErrWrite "Error in EfektorLibary:EL_RSC_piston press", "Chwytak nie zlapal elementu." \RL2:="Sygnal RSC_pistonIsDown aktywowal sie." \RL3:="Mozliwy brak detali na obrotniku";  
                ErrWriteID 38;
                IF towerUse towerHelp \handleStop;     
            ENDIF
            
        ELSE
            ! bledny przelacznik funkcji
!            ErrWrite "Error in EfektorLibary:EL_RSC_piston(down lub up lub press)", "Bledny parametr funkcji EL_RSC_piston, musi byc urzyty tylko 1 przlacznik";  
            ErrWriteID 35;
        ENDIF
    ENDPROC
    
    PROC EL_RSI_piston(\switch down |switch up |switch press)
        VAR bool timeut_temp:=FALSE;
        
        IF Present(down) THEN
            ! silownik w dol bez elementu na obrotniku (musi zadzialac dolna krancowka)
            Reset RSI_pistonUp;
            Set RSI_pistonDown;
            WHILE TestDI(RSI_pistonIsUp) DO
                WaitDI RSI_pistonIsUp,0\MaxTime:=2\TimeFlag:=timeut_temp;
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSI_piston down", "Sprawdz czy dziala silownik po stronie spawania PKW." \RL2:="Sygnal RSI_pistonIsUp ciagle aktywny.";
                    ErrWriteID 39;
                    IF towerUse towerHelp \handleStop;      
                ENDIF   
            ENDWHILE
            WHILE (NOT TestDI(RSI_pistonIsDown)) DO
                WaitDI RSI_pistonIsDown,1\MaxTime:=10\TimeFlag:=timeut_temp;
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSI_piston down", "Sprawdz czy dziala silownik po stronie spawania PKW." \RL2:="Sygnal RSI_pistonIsDown nie atywowal sie.";
                    ErrWriteID 40;
                    IF towerUse towerHelp \handleStop;      
                ENDIF 
            ENDWHILE
            WHILE (NOT TestDI(RSI_pistonIsPressed)) DO
                WaitDI RSI_pistonIsPressed,1\MaxTime:=5\TimeFlag:=timeut_temp;
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSI_piston down", "Sprawdz czy dziala silownik i przekaznika cisnienia po stronie spawania PKW." \RL2:="Sygnal RSI_pistonIsPressed nie atywowal sie.";
                    ErrWriteID 41;
                    IF towerUse towerHelp \handleStop;      
                ENDIF
            ENDWHILE
            
        ELSEIF Present(up) THEN
            ! zwalniamy elementy na obrotniku
            Reset RSI_pistonDown;
            Set RSI_pistonUp;
            WHILE TestDI(RSI_pistonIsDown) DO
                WaitDI RSI_pistonIsDown,0\MaxTime:=2\TimeFlag:=timeut_temp;
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSI_piston up", "Sprawdz czy dziala silownik po stronie spawania PKW." \RL2:="Sygnal RSI_pistonIsDown ciagle aktywny.";
                    ErrWriteID 43;
                    IF towerUse towerHelp \handleStop;      
                ENDIF   
            ENDWHILE
            WHILE (NOT TestDI(RSI_pistonIsUp)) DO
                WaitDI RSI_pistonIsUp,1\MaxTime:=10\TimeFlag:=timeut_temp;
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSI_piston up", "Sprawdz czy dziala silownik po stronie spawania PKW." \RL2:="Sygnal RSI_pistonIsUp nie katywowal sie.";
                    ErrWriteID 43;
                    IF towerUse towerHelp \handleStop;      
                ENDIF 
            ENDWHILE
            WHILE TestDI(RSI_pistonIsPressed) DO
                WaitDI RSI_pistonIsPressed,0\MaxTime:=5\TimeFlag:=timeut_temp;
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSI_piston up", "Sprawdz czy dziala silownik i przekaznika cisnienia po stronie spawania PKW." \RL2:="Sygnal RSI_pistonIsPressed ciagle aktywny.";
                    ErrWriteID 42;
                    IF towerUse towerHelp \handleStop;      
                ENDIF
            ENDWHILE
        
        ELSEIF Present(press) THEN    
            ! dociskamy elementy na obrotniku
            Reset RSI_pistonUp;
            Set RSI_pistonDown;
            WHILE TestDI(RSI_pistonIsUp) DO
            WaitDI RSI_pistonIsUp,0\MaxTime:=2\TimeFlag:=timeut_temp;
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSI_piston press", "Sprawdz czy dziala silownik po stronie spawania PKW." \RL2:="Sygnal RSI_pistonIsUp ciagle aktywny.";
                    ErrWriteID 39;
                    IF towerUse towerHelp \handleStop;      
                ENDIF    
            ENDWHILE
            WHILE (NOT TestDI(RSI_pistonIsPressed)) DO
                WaitDI RSI_pistonIsPressed,1\MaxTime:=10\TimeFlag:=timeut_temp;
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSI_piston press", "Sprawdz czy dziala silownik i przekaznika cisnienia po stronie spawania PKW." \RL2:="Sygnal RSI_pistonIsPressed nie atywowal sie.";
                    ErrWriteID 41;
                    IF towerUse towerHelp \handleStop;      
                ENDIF   
            ENDWHILE
            WaitTime 1;
            IF TestDI(RSI_pistonIsDown) THEN
!                ErrWrite "Error in EfektorLibary:EL_RSI_piston press", "Chwytak nie zlapal elementu." \RL2:="Sygnal RSI_pistonIsDown aktywowal sie." \RL3:="Mozliwy brak detali na obrotniku";  
                ErrWriteID 44;
                IF towerUse towerHelp \handleStop;     
            ENDIF
            
        ELSE
            ! bledny przelacznik funkcji
!            ErrWrite "Error in EfektorLibary:EL_RSI_piston(down lub up lub press)", "Bledny parametr funkcji EL_RSI_piston, musi byc urzyty tylko 1 przlacznik";   
            ErrWriteID 25;
            Stop;
            !EXIT;
        ENDIF
    ENDPROC    
    
    PROC EL_BOFA(\switch on |switch off)
        VAR bool timeut_temp:=FALSE;
        
        IF Present(on) THEN
            Set RSH_BOFA;    
            WHILE (NOT TestDI(RSH_BofaOK)) DO
                WaitDI RSH_BofaOK,1\MaxTime:=20\TimeFlag:=timeut_temp;
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_BOFA on", "Blad wlaczania odciagu spalin BOFA."
!                    \RL2:="Brak sygnalu RSH_BofaOK" \RL3:="Sprawdz czy BOFA jest wlaczona"
!                    \RL4:="Sprawdz czy BOFA nie zglasza bledow";   
                    ErrWriteID 6;
                ENDIF  
            ENDWHILE
            
        ELSEIF Present(off) THEN
            Reset RSH_BOFA;
            
        ELSE
!            ErrWrite "Error in EfektorLibary:EL_BOFA(on lub off)", "Bledny parametr funkcji EL_BOFA, musi byc urzyty tylko 1 przlacznik";  
            ErrWriteID 25;
            Stop;
            !Exit;
        ENDIF
        
    ENDPROC
    
    PROC EL_RSC_changer(\switch on |switch on_empty |switch off )
        VAR bool timeut_temp:=FALSE;
        VAR num changerCode_temp;
        
        IF Present(on) THEN
            ! sprawdzamy czy jest cos do chwycenia - a powinno byc
            changerCode_temp := GInput(RSC_changerCode);
            WHILE changerCode_temp=0 DO
                IF changerCode_temp=0 THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSC_changer on", "Brak taleza do chwycenia."
!                    \RL2:="Brak kodu taleza. RSC_changerCode=0"
!                    \RL3:="Sprawdz czujniki w zmieniarce i kodowanie w talerzu"
!                    \RL4:="Uzyj innego przelacznika.";
                    ErrWriteID 45;
                    IF towerUse towerHelp \handleStop;       
                ENDIF
                changerCode_temp := GInput(RSC_changerCode);
            ENDWHILE
            Reset RSC_changerOff;
            Set RSC_changerOn;
            WHILE TestDI(RSC_changerIsOff) DO
                WaitDI RSC_changerIsOff,0\MaxTime:=1\TimeFlag:=timeut_temp;    
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSC_changer on", "Sprawdz czy dziala zmieniarka schunk po stronie spawania plaszcza." \RL2:="Sygnal RSC_changerIsOff ciagle aktywny.";
                    ErrWriteID 47;
                    IF towerUse towerHelp \handleStop;      
                ENDIF 
            ENDWHILE
            ! czekamy az sie zablokuje i sprawdzamy sygnal zablokowania
            ! przy obecnym talezu sygnal nie powinien sie pojawic
            WaitTime 1;
            WHILE TestDI(RSC_changerIsOn) DO       
                IF TestDI(RSC_changerIsOn) THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSC_changer on", "Brak taleza do chwycenia."
!                    \RL2:="Aktywowal sie sygnal RSC_changerIsOn a nie powinien."
!                    \RL3:="Sygnal RSC_changerIsOn aktywuje sie tylko przy pustej zmieniarce"
!                    \RL4:="Uzyj innego przelacznika jak blokujesz pusta zmieniarke";
                    ErrWriteID 48;
                    IF towerUse towerHelp \handleStop;      
                ENDIF
            ENDWHILE
    
        ELSEIF Present(on_empty) THEN
            ! sprawdzamy czy jest cos do chwycenia - a nie powinno byc
            changerCode_temp := GInput(RSC_changerCode);
            WHILE changerCode_temp<>0 DO
                IF changerCode_temp<>0 THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSC_changer on", "Obecny talerz na zmieniarce."
!                    \RL2:="Odczytano kod talerza. RSC_changerCode<>0"
!                    \RL3:="Sprawdz czujniki w zmieniarce i kodowanie w talerzu"
!                    \RL4:="Uzyj innego przelacznika jak blokujesz zaladowana zmieniarke";
                    ErrWriteID 49;
                    IF towerUse towerHelp \handleStop;       
                ENDIF
                changerCode_temp := GInput(RSC_changerCode);
            ENDWHILE
            Reset RSC_changerOff;
            Set RSC_changerOn;
            WHILE TestDI(RSC_changerIsOff) DO
                WaitDI RSC_changerIsOff,0\MaxTime:=1\TimeFlag:=timeut_temp;    
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSC_changer on", "Sprawdz czy dziala zmieniarka schunk po stronie spawania plaszcza." \RL2:="Sygnal RSC_changerIsOff ciagle aktywny.";
                    ErrWriteID 47;
                    IF towerUse towerHelp \handleStop;      
                ENDIF 
            ENDWHILE
            WHILE (NOT TestDI(RSC_changerIsOn)) DO
                WaitDI RSC_changerIsOn,1\MaxTime:=1\TimeFlag:=timeut_temp;         
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSC_changer on", "Sprawdz czy dziala zmieniarka schunk po stronie spawania plaszcza." \RL2:="Sygnal RSC_changerIsOn nie atywowal sie.";
                    ErrWriteID 50;
                    IF towerUse towerHelp \handleStop;      
                ENDIF 
            ENDWHILE           
        ELSEIF Present(off) THEN
            Reset RSC_changerOn;
            Set RSC_changerOff;
            WHILE TestDI(RSC_changerIsOn) DO
                WaitDI RSC_changerIsOn,0\MaxTime:=1\TimeFlag:=timeut_temp;    
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSC_changer on", "Sprawdz czy dziala zmieniarka schunk po stronie spawania plaszcza." \RL2:="Sygnal RSC_changerIsOn ciagle aktywny.";
                    ErrWriteID 51;
                    IF towerUse towerHelp \handleStop;      
                ENDIF 
            ENDWHILE
            WHILE (NOT TestDI(RSC_changerIsOff)) DO
                WaitDI RSC_changerIsOff,1\MaxTime:=1\TimeFlag:=timeut_temp;         
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSC_changer on", "Sprawdz czy dziala zmieniarka schunk po stronie spawania plaszcza." \RL2:="Sygnal RSC_changerIsOff nie atywowal sie.";
                    ErrWriteID 52;
                    IF towerUse towerHelp \handleStop;      
                ENDIF 
            ENDWHILE  
            
        ELSE
!            ErrWrite "Error in EfektorLibary:EL_RSC_changer(on lub off)", "Bledny parametr funkcji EL_RSC_changer, musi byc urzyty tylko 1 przlacznik";
            ErrWriteID 25;
            Stop;
            !Exit;
        ENDIF
        
    ENDPROC
    
    PROC EL_RSI_changer(\switch on |switch on_empty |switch off )
        VAR bool timeut_temp:=FALSE;
        VAR num changerCode_temp;
        
        IF Present(on) THEN
            ! sprawdzamy czy jest cos do chwycenia - a powinno byc
            changerCode_temp := GInput(RSI_changerCode);
            WHILE changerCode_temp=0 DO
                IF changerCode_temp=0 THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSI_changer on", "Brak rozpieraka do chwycenia."
!                    \RL2:="Brak kodu taleza. RSI_changerCode=0"
!                    \RL3:="Sprawdz czujniki w zmieniarce i kodowanie w rozpieraku"
!                    \RL4:="Uzyj innego przelacznika jak blokujesz pusta zmieniarke";
                    ErrWriteID 53;
                    IF towerUse towerHelp \handleStop;       
                ENDIF
                changerCode_temp := GInput(RSI_changerCode);
            ENDWHILE
            Reset RSI_changerOff;
            Set RSI_changerOn;
            WHILE TestDI(RSI_changerIsOff) DO
                WaitDI RSI_changerIsOff,0\MaxTime:=1\TimeFlag:=timeut_temp;    
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSI_changer on", "Sprawdz czy dziala zmieniarka schunk po stronie spawania PKW." \RL2:="Sygnal RSI_changerIsOff ciagle aktywny.";
                    ErrWriteID 54;
                    IF towerUse towerHelp \handleStop;      
                ENDIF 
            ENDWHILE
            ! czekamy az sie zablokuje i sprawdzamy sygnal zablokowania
            ! przy obecnym talezu sygnal nie powinien sie pojawic
            WaitTime 1;
            WHILE TestDI(RSI_changerIsOn) DO       
                IF TestDI(RSI_changerIsOn) THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSI_changer on", "Brak taleza do chwycenia."
!                    \RL2:="Aktywowal sie sygnal RSI_changerIsOn a nie powinien."
!                    \RL3:="Sygnal RSI_changerIsOn aktywuje sie tylko przy pustej zmieniarce"
!                    \RL4:="Uzyj innego przelacznika jak blokujesz pusta zmieniarke";
                    ErrWriteID 55;
                    IF towerUse towerHelp \handleStop;      
                ENDIF
            ENDWHILE
    
        ELSEIF Present(on_empty) THEN
            ! sprawdzamy czy jest cos do chwycenia - a nie powinno byc
            changerCode_temp := GInput(RSI_changerCode);
            WHILE changerCode_temp<>0 DO
                IF changerCode_temp<>0 THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSI_changer on", "Obecny talerz na zmieniarce."
!                    \RL2:="Odczytano kod talerza. RSI_changerCode<>0"
!                    \RL3:="Sprawdz czujniki w zmieniarce i kodowanie w talerzu"
!                    \RL4:="Uzyj innego przelacznika jak blokujesz zaladowana zmieniarke";
                    ErrWriteID 56;
                    IF towerUse towerHelp \handleStop;       
                ENDIF
                changerCode_temp := GInput(RSI_changerCode);
            ENDWHILE
            Reset RSI_changerOff;
            Set RSI_changerOn;
            WHILE TestDI(RSI_changerIsOff) DO
                WaitDI RSI_changerIsOff,0\MaxTime:=1\TimeFlag:=timeut_temp;    
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSI_changer on", "Sprawdz czy dziala zmieniarka schunk po stronie spawania PKW." \RL2:="Sygnal RSI_changerIsOff ciagle aktywny.";
                    ErrWriteID 54;
                    IF towerUse towerHelp \handleStop;      
                ENDIF 
            ENDWHILE
            WHILE (NOT TestDI(RSI_changerIsOn)) DO
                WaitDI RSI_changerIsOn,1\MaxTime:=1\TimeFlag:=timeut_temp;         
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSI_changer on", "Sprawdz czy dziala zmieniarka schunk po stronie spawania PKW." \RL2:="Sygnal RSI_changerIsOn nie atywowal sie.";
                    ErrWriteID 57;
                    IF towerUse towerHelp \handleStop;      
                ENDIF 
            ENDWHILE           
        ELSEIF Present(off) THEN
            Reset RSI_changerOn;
            Set RSI_changerOff;
            WHILE TestDI(RSI_changerIsOn) DO
                WaitDI RSI_changerIsOn,0\MaxTime:=1\TimeFlag:=timeut_temp;    
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSI_changer on", "Sprawdz czy dziala zmieniarka schunk po stronie spawania PKW." \RL2:="Sygnal RSI_changerIsOn ciagle aktywny.";
                    ErrWriteID 58;
                    IF towerUse towerHelp \handleStop;      
                ENDIF 
            ENDWHILE
            WHILE (NOT TestDI(RSI_changerIsOff)) DO
                WaitDI RSI_changerIsOff,1\MaxTime:=1\TimeFlag:=timeut_temp;         
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSI_changer on", "Sprawdz czy dziala zmieniarka schunk po stronie spawania PKW." \RL2:="Sygnal RSI_changerIsOff nie atywowal sie.";
                    ErrWriteID 59;
                    IF towerUse towerHelp \handleStop;      
                ENDIF 
            ENDWHILE  
            
        ELSE
!            ErrWrite "Error in EfektorLibary:EL_RSI_changer(on lub off)", "Bledny parametr funkcji EL_RSI_changer, musi byc urzyty tylko 1 przlacznik";
            ErrWriteID 25;
            Stop;
            !Exit;
        ENDIF
        
    ENDPROC
    
    PROC EL_InnerDoorSafe(\switch right |switch left)
        VAR bool timeut_temp:=FALSE;
        
        IF Present(right) THEN
            !przesowamy drzwi w prawo
            
            IF (NOT((DOutput(RS_innerDoorRightClose)=1) And (DOutput(RS_innerDoorLeftClose)=0))) THEN
                ! sprawdzamy czy drzwi sa na koncu
                IF TestDI(RS_innerDoorLeftIsClosed) THEN
                    ! zapalniamy silownik by lepej dzialalo tlumienie
                    Reset RS_innerDoorRightCloseSafe;
                    Set RS_innerDoorLeftCloseSafe;
                    IF DOutput(RS_innerDoorLeftClose)=0 THEN
                        !sygnal nie zostal przekazany - nie spelniony warunek cros-conection
!                        ErrWrite "Error in EfektorLibary:EL_InnerDoorSafe right", "Sprawdz czy dzialaja drzwi wewnetrzne." \RL2:="Nie spelniony warunek umozliwiajacy przesowanie drzwi wew.";
                        ErrWriteID 60;
                        IF towerUse towerHelp \handleStop;   
                    ENDIF
                    WaitTime 1;
                ENDIF
            ENDIF
            Reset RS_innerDoorLeftCloseSafe;
            Set RS_innerDoorRightCloseSafe;
            IF DOutput(RS_innerDoorRightCloseSafe)=0 THEN
                !sygnal nie zostal przekazany - nie spelniony warunek cros-conection
!                ErrWrite "Error in EfektorLibary:EL_InnerDoorSafe right", "Sprawdz czy dzialaja drzwi wewnetrzne." \RL2:="Nie spelniony warunek umozliwiajacy przesowanie drzwi wew.";
                ErrWriteID 61;
                IF towerUse towerHelp \handleStop;   
            ENDIF
            ! sprawdzamy krancowki
            WHILE TestDi(RS_innerDoorLeftIsClosed) DO    
                waitdi RS_innerDoorLeftIsClosed,0\MaxTime:=3\TimeFlag:=timeut_temp;  
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_InnerDoorSafe right", "Sprawdz czy dzialaja drzwi wewnetrzne." \RL2:="Sygnal RS_innerDoorLeftIsClosed ciagle aktywny."\RL3:="Sprawdz polozenie drzwi i dzialanie krancowki";
                    ErrWriteID 62;
                    IF towerUse towerHelp \handleStop;      
                ENDIF        
            ENDWHILE   
             WHILE (NOT TestDi(RS_innerDoorRightIsClosed)) DO    
                waitdi RS_innerDoorRightIsClosed,0\MaxTime:=10\TimeFlag:=timeut_temp;  
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_InnerDoorSafe right", "Sprawdz czy dzialaja drzwi wewnetrzne." \RL2:="Sygnal RS_innerDoorRightIsClosed nie aktywowal sie."\RL3:="Sprawdz polozenie drzwi i dzialanie krancowki";
                    ErrWriteID 63;
                    IF towerUse towerHelp \handleStop;      
                ENDIF        
            ENDWHILE   
            
        
        ELSEIF Present(left) THEN
                     !przesowamy drzwi w prawo
            
            IF (NOT((DOutput(RS_innerDoorRightClose)=0) And (DOutput(RS_innerDoorLeftClose)=1))) THEN
                ! sprawdzamy czy drzwi sa na przeciwnym koncu celu
                IF TestDI(RS_innerDoorrightIsClosed) THEN
                    ! zapalniamy silownik by lepej dzialalo tlumienie
                    Reset RS_innerDoorLeftCloseSafe;
                    Set RS_innerDoorRightCloseSafe;
                    IF DOutput(RS_innerDoorRightClose)=0 THEN
                        !sygnal nie zostal przekazany - nie spelniony warunek cros-conection
!                        ErrWrite "Error in EfektorLibary:EL_InnerDoorSafe right", "Sprawdz czy dzialaja drzwi wewnetrzne." \RL2:="Nie spelniony warunek umozliwiajacy przesowanie drzwi wew.";
                        ErrWriteID 65;
                        IF towerUse towerHelp \handleStop;   
                    ENDIF
                    WaitTime 1;
                ENDIF
            ENDIF
            Reset RS_innerDoorRightCloseSafe;
            Set RS_innerDoorLeftCloseSafe;
            IF DOutput(RS_innerDoorLeftCloseSafe)=0 THEN
                !sygnal nie zostal przekazany - nie spelniony warunek cros-conection
!                ErrWrite "Error in EfektorLibary:EL_InnerDoorSafe right", "Sprawdz czy dzialaja drzwi wewnetrzne." \RL2:="Nie spelniony warunek umozliwiajacy przesowanie drzwi wew.";
                ErrWriteID 64;
                IF towerUse towerHelp \handleStop;   
            ENDIF
            ! sprawdzamy krancowki
            WHILE TestDi(RS_innerDoorRightIsClosed) DO    
                waitdi RS_innerDoorRightIsClosed,0\MaxTime:=3\TimeFlag:=timeut_temp;  
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_InnerDoorSafe right", "Sprawdz czy dzialaja drzwi wewnetrzne." \RL2:="Sygnal RS_innerDoorRightIsClosed ciagle aktywny."\RL3:="Sprawdz polozenie drzwi i dzialanie krancowki";
                    ErrWriteID 63;
                    IF towerUse towerHelp \handleStop;      
                ENDIF        
            ENDWHILE   
             WHILE (NOT TestDi(RS_innerDoorLeftIsClosed)) DO    
                waitdi RS_innerDoorLeftIsClosed,0\MaxTime:=10\TimeFlag:=timeut_temp;  
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_InnerDoorSafe right", "Sprawdz czy dzialaja drzwi wewnetrzne." \RL2:="Sygnal RS_innerDoorLeftIsClosed nie aktywowal sie."\RL3:="Sprawdz polozenie drzwi i dzialanie krancowki";
                    ErrWriteID 62;
                    IF towerUse towerHelp \handleStop;      
                ENDIF        
            ENDWHILE             
            
        ELSE
!            ErrWrite "Error in EfektorLibary:EL_InnerDoorSafe(left lub roght)", "Bledny parametr funkcji EL_InnerDoorSafe, musi byc urzyty tylko 1 przlacznik";    
            ErrWriteID 25;
            Stop;
            !Exit;
        ENDIF
        
        
    ENDPROC
    
    PROC EL_OuterDoorSafe(\switch right |switch left)
        VAR bool timeut_temp:=FALSE;
        
        IF Present(right) THEN
            !przesowamy drzwi w prawo
            
            IF (NOT((DOutput(RS_outerDoorRightClose)=1) And (DOutput(RS_outerDoorLeftClose)=0))) THEN
                ! sprawdzamy czy drzwi sa na koncu
                IF TestDI(RS_outerDoorLeftIsClosed) THEN
                    ! zapalniamy silownik by lepej dzialalo tlumienie
                    Reset RS_outerDoorRightCloseSafe;
                    Set RS_outerDoorLeftCloseSafe;
                    IF DOutput(RS_outerDoorLeftClose)=0 THEN
                        !sygnal nie zostal przekazany - nie spelniony warunek cros-conection
!                        ErrWrite "Error in EfektorLibary:EL_outerDoorSafe right", "Sprawdz czy dzialaja drzwi wewnetrzne." \RL2:="Nie spelniony warunek umozliwiajacy przesowanie drzwi wew.";
                        ErrWriteID 91;
                        IF towerUse towerHelp \handleStop;   
                    ENDIF
                    WaitTime 1;
                ENDIF
            ENDIF
            Reset RS_outerDoorLeftCloseSafe;
            Set RS_outerDoorRightCloseSafe;
            IF DOutput(RS_outerDoorRightCloseSafe)=0 THEN
                !sygnal nie zostal przekazany - nie spelniony warunek cros-conection
!                ErrWrite "Error in EfektorLibary:EL_outerDoorSafe right", "Sprawdz czy dzialaja drzwi wewnetrzne." \RL2:="Nie spelniony warunek umozliwiajacy przesowanie drzwi wew.";
                ErrWriteID 92;
                IF towerUse towerHelp \handleStop;   
            ENDIF
            ! sprawdzamy krancowki
            WHILE TestDi(RS_outerDoorLeftIsClosed) DO    
                waitdi RS_outerDoorLeftIsClosed,0\MaxTime:=3\TimeFlag:=timeut_temp;  
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_outerDoorSafe right", "Sprawdz czy dzialaja drzwi wewnetrzne." \RL2:="Sygnal RS_outerDoorLeftIsClosed ciagle aktywny."\RL3:="Sprawdz polozenie drzwi i dzialanie krancowki";
                    IF towerUse towerHelp \handleStop;     
                    ErrWriteID 93;
                ENDIF        
            ENDWHILE   
             WHILE (NOT TestDi(RS_outerDoorRightIsClosed)) DO    
                waitdi RS_outerDoorRightIsClosed,0\MaxTime:=10\TimeFlag:=timeut_temp;  
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_outerDoorSafe right", "Sprawdz czy dzialaja drzwi wewnetrzne." \RL2:="Sygnal RS_outerDoorRightIsClosed nie aktywowal sie."\RL3:="Sprawdz polozenie drzwi i dzialanie krancowki";
                    ErrWriteID 94;
                    IF towerUse towerHelp \handleStop;      
                ENDIF        
            ENDWHILE   
            
        
        ELSEIF Present(left) THEN
                     !przesowamy drzwi w prawo
            
            IF (NOT((DOutput(RS_outerDoorRightClose)=0) And (DOutput(RS_outerDoorLeftClose)=1))) THEN
                ! sprawdzamy czy drzwi sa na przeciwnym koncu celu
                IF TestDI(RS_outerDoorrightIsClosed) THEN
                    ! zapalniamy silownik by lepej dzialalo tlumienie
                    Reset RS_outerDoorLeftCloseSafe;
                    Set RS_outerDoorRightCloseSafe;
                    IF DOutput(RS_outerDoorRightClose)=0 THEN
                        !sygnal nie zostal przekazany - nie spelniony warunek cros-conection
!                        ErrWrite "Error in EfektorLibary:EL_outerDoorSafe right", "Sprawdz czy dzialaja drzwi wewnetrzne." \RL2:="Nie spelniony warunek umozliwiajacy przesowanie drzwi wew.";
                        ErrWriteID 95;
                        IF towerUse towerHelp \handleStop;   
                    ENDIF
                    WaitTime 1;
                ENDIF
            ENDIF
            Reset RS_outerDoorRightCloseSafe;
            Set RS_outerDoorLeftCloseSafe;
            IF DOutput(RS_outerDoorLeftCloseSafe)=0 THEN
                !sygnal nie zostal przekazany - nie spelniony warunek cros-conection
                !ErrWrite "Error in EfektorLibary:EL_outerDoorSafe right", "Sprawdz czy dzialaja drzwi wewnetrzne." \RL2:="Nie spelniony warunek umozliwiajacy przesowanie drzwi wew.";
                ErrWriteID 96;
                IF towerUse towerHelp \handleStop;   
            ENDIF
            ! sprawdzamy krancowki
            WHILE TestDi(RS_outerDoorRightIsClosed) DO    
                waitdi RS_outerDoorRightIsClosed,0\MaxTime:=3\TimeFlag:=timeut_temp;  
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_outerDoorSafe right", "Sprawdz czy dzialaja drzwi wewnetrzne." \RL2:="Sygnal RS_outerDoorRightIsClosed ciagle aktywny."\RL3:="Sprawdz polozenie drzwi i dzialanie krancowki";
                    ErrWriteID 94;
                    IF towerUse towerHelp \handleStop;      
                ENDIF        
            ENDWHILE   
             WHILE (NOT TestDi(RS_outerDoorLeftIsClosed)) DO    
                waitdi RS_outerDoorLeftIsClosed,0\MaxTime:=10\TimeFlag:=timeut_temp;  
                IF timeut_temp THEN
                    ErrWrite "Error in EfektorLibary:EL_outerDoorSafe right", "Sprawdz czy dzialaja drzwi wewnetrzne." \RL2:="Sygnal RS_outerDoorLeftIsClosed nie aktywowal sie."\RL3:="Sprawdz polozenie drzwi i dzialanie krancowki";
                    ErrWriteID 93;
                    IF towerUse towerHelp \handleStop;      
                ENDIF        
            ENDWHILE             
            
        ELSE
            ErrWrite "Error in EfektorLibary:EL_outerDoorSafe(left lub roght)", "Bledny parametr funkcji EL_outerDoorSafe, musi byc urzyty tylko 1 przlacznik";      
        ENDIF
        
        
    ENDPROC
    
    PROC EL_RSI_Spread(\switch on |switch off)
        VAR bool timeut_temp:=FALSE;    
        VAR num changerCode_temp;
        
        IF Present(on) THEN
            !sprawdzamy obecnosc rozpieraka
            changerCode_temp := GInput(RSI_changerCode);
            WHILE changerCode_temp=0 DO
                IF changerCode_temp=0 THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSI_Spread on", "Brak rozpieraka do sterowania."
!                    \RL2:="Brak kodu rozpieraka. RSI_changerCode=0"
!                    \RL3:="Sprawdz czujniki w zmieniarce i kodowanie w rozpieraku"
!                    \RL4:="Uzyj innego przelacznika jak blokujesz pusta zmieniarke";
                    ErrWriteID 97;
                    IF towerUse towerHelp \handleStop;       
                ENDIF
                changerCode_temp := GInput(RSI_changerCode);
            ENDWHILE  
            !sprawdzamy obecnosc komory - musi byc bo inaczej uszkodzimy rozpierak
            WHILE (NOT TestDI(RSI_furnacePresent)) DO
!                ErrWrite "Error in EfektorLibary:EL_RSI_Spread on", "Brak komory na rozpieraku PKW."
!                \RL2:="Komora powinna byc obecna."
!                \RL3:="Brak sygnalu RSI_furnacePresent z czujnika obecnosci komory.";
                ErrWriteID 98;
                IF towerUse towerHelp \handleStop;  
            ENDWHILE
            Set RSI_spreadDistendSafe;
            !sprawdzamy przekazanie sygnalu przez cross-conection
            IF DOutput(RSI_spreadOpen)=0 THEN
!                ErrWrite "Error in EfektorLibary:EL_RSI_Spread on", "Sygnal RSI_spreadOpen nie aktywowal sie"
!                \RL2:="Zabezpieczenie wymaga sygnalu (RSI_furnacePresent) obecnosci komory.";
                ErrWriteID 99;
                IF towerUse towerHelp \handleStop;    
            ENDIF
            !czekamy na potwierdzenie z czujnika cisnienia
            WHILE (NOT TestDi(RSI_spreadDistended)) DO    
                waitdi RSI_spreadDistended,1\MaxTime:=5\TimeFlag:=timeut_temp;  
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSI_Spread on", "Sprawdz czy dziala rozpierak PKW."
!                    \RL2:="Sygnal RSI_spreadDistended nie aktywowal sie."
!                    \RL3:="Sprawdz dzialanie zaworu sterujacego rozpierakiem PKW."
!                    \RL4:="Sprawdz obecnosc cisnienia powietrza i przekaznik cisnienia.";
                    ErrWriteID 100;
                    IF towerUse towerHelp \handleStop;      
                ENDIF        
            ENDWHILE 
            
        ELSEIF Present(off) THEN
            Reset RSI_spreadDistendSafe;
            WHILE (TestDi(RSI_spreadDistended)) DO    
                waitdi RSI_spreadDistended,0\MaxTime:=5\TimeFlag:=timeut_temp;  
                IF timeut_temp THEN
!                    ErrWrite "Error in EfektorLibary:EL_RSI_Spread on", "Sprawdz czy dziala rozpierak PKW."
!                    \RL2:="Sygnal RSI_spreadDistended ciagle aktywny."
!                    \RL3:="Sprawdz dzialanie zaworu sterujacego rozpierakiem PKW."
!                    \RL4:="Sprawdz obecnosc cisnienia powietrza i przekaznik cisnienia.";
                    ErrWriteID 101;
                    IF towerUse towerHelp \handleStop;      
                ENDIF        
            ENDWHILE     
        ELSE
!            ErrWrite "Error in EfektorLibary:EL_RSI_Spread(on lub off)", "Bledny parametr funkcji EL_RSI_Spread, musi byc urzyty tylko 1 przlacznik"; 
            ErrWriteID 102;
        ENDIF    
        
    ENDPROC
    
    
    PROC TestEffektors()
        VAR num tempNum;
        
        IF FALSE THEN
            TPWrite "Testujemy chwytak... START aby kontynuowac";
            Stop;
            !
            FOR tempNum FROM 1 TO 20 DO
                EL_Gripper \grClose;
                EL_Gripper \grOpen;           
            ENDFOR
        ENDIF
        !
        IF FALSE THEN
            TPWrite "Testujemy klapke oswietlacza... START aby kontynuowac";
            Stop;
            !
            EL_IlluminatorCover \icClose;
            EL_IlluminatorCover \icOpen;
            EL_IlluminatorCover \icClose;
            EL_IlluminatorCover \icOpen;
            !
        ENDIF
        !
        IF FALSE THEN
            TPWrite "Testujemy silownik dociskowy po stronie plaszcza... START aby kontynuowac";
            Stop;
            EL_RSC_piston \down;
            EL_RSC_piston \up;
            EL_RSC_piston \down;
            EL_RSC_piston \up;
        ENDIF
        !
        IF FALSE THEN
            TPWrite "Testujemy silownik dociskowy po stronie pkw... START aby kontynuowac";
            Stop;
            EL_RSI_piston \down;
            EL_RSI_piston \up;
            EL_RSI_piston \down;
            EL_RSI_piston \up;
        ENDIF
        !
        IF FALSE THEN
            TPWrite "Testujemy sterowanie bofa... START aby kontynuowac";
            Stop;
            !
            EL_BOFA \off;
            WaitTime 3;
            EL_BOFA \on;
            WaitTime 5;
            EL_BOFA \off;
            WaitTime 3;
            EL_BOFA \on;
            WaitTime 5;
            EL_BOFA \off;
        ENDIF
        !
        TPWrite "Testujemy zmieniarke po stranie plaszcz... START aby kontynuowac";
        Stop;
        !
        EL_RSC_changer \off;
        EL_RSC_changer \on;
        EL_RSC_changer \off;
        EL_RSC_changer \on;
        !
        TPWrite "Testujemy zmieniarke po stranie pkw... START aby kontynuowac";
        Stop;
        !
        EL_RSI_changer \off;
        EL_RSI_changer \on;
        EL_RSI_changer \off;
        EL_RSI_changer \on;
        !
        TPWrite "Testujemy rozpierak stranie pkw... START aby kontynuowac";
        Stop;
        !
        EL_RSI_Spread \on;
        EL_RSI_Spread \off;
        EL_RSI_Spread \on;
        EL_RSI_Spread \off;
        !
        TPWrite "Testujemy drzwi wew... START aby kontynuowac";
        Stop;
        !
        EL_InnerDoorSafe \left;
        EL_InnerDoorSafe \right;
        EL_InnerDoorSafe \left;
        EL_InnerDoorSafe \right;
        !
        TPWrite "Testujemy drzwi zew... START aby kontynuowac";
        Stop;
        !
        EL_OuterDoorSafe \left;
        EL_OuterDoorSafe \right;
        EL_OuterDoorSafe \left;
        EL_OuterDoorSafe \right;
        
    ENDPROC 
    
ENDMODULE