MODULE GalantSpawRLibrary
    !funkcja sprawdzajaca odleglosc miedzy obecnym detalem a najblizszymy sasiadami
    ! ret: bool = czy sasiedzi sa dostatecznie daleko (TRUE) czy minimum jeden z nich jest za blisko (FALSE)
    ! arg: packetNo - jaki typ pakietu analizujemy
    ! arg: currDetail - dla jakiego detalu szukamy najblizszych sasiadow
    ! arg: closeElement - znaleziony typ galanterii BLISKIEGO sasiada
    ! arg: angleDiff - znaleziona roznica pozycji katowej miedzy obecnym detalem a BLISKIM sasiadem
    ! arg: posDiff - znaleziona roznica pozycji XYZ miedzy obecnym detalem a BLISKIM sasiadem
    FUNC bool checkSafeDistances(num packetNo,num currDetail,INOUT num closeElement{*},INOUT num angleDiff{*},INOUT pos posDiff{*})
        VAR bool result:=TRUE;
        VAR num minAngle:=30;
        VAR num minDist:=60;
        VAR num closeElementsNo:=0;
        VAR num packetAngles{maxElementNo};
        VAR location currDetailInPacket;
        VAR location closeDetailInPacket;

        !pobieramy informacje o katach detali wzgledem obecnego
        IF getPacketAngles(packetNo,currDetail,packetAngles)>0 THEN
            !pobieramy pozycje obecnego detalu
            currDetailInPacket:=getDetailLocation(packetNo,currDetail);
            FOR i FROM 1 TO maxElementNo DO
                !dla kazdego (oprocz obecnego) detalu sprawdzamy czy kat jest mniejszy od zalozonego
                IF i<>currDetail AND Abs(packetAngles{i})<minAngle THEN
                    !sprawdzamy jeszcze czy jest na tej samej wysokosci pakietu
                    closeDetailInPacket:=getDetailLocation(packetNo,i);
                    IF Distance(currDetailInPacket.elementWObj.trans,closeDetailInPacket.elementWObj.trans)<minDist THEN
                        !detal jest za blisko - sprawdzamy czy juz jest zamontowany (sczepiony)
                        IF detailStatusHeft{i}=TRUE THEN
                            !detal juz jest na pakiecie wrzucamy odpowiedzi do tablicy
                            Incr closeElementsNo;
                            closeElement{closeElementsNo}:=i;
                            angleDiff{closeElementsNo}:=packetAngles{i};
                            posDiff{closeElementsNo}:=currDetailInPacket.elementWObj.trans-closeDetailInPacket.elementWObj.trans;
                            !ustawiamy flage wyjsciowa
                            result:=FALSE;
                        ENDIF
                    ENDIF
                ENDIF
            ENDFOR
        ENDIF

        RETURN result;
    ENDFUNC

    !funkcja sprawdzajaca czy oby dwa wobj sa takie same 
    FUNC bool compareWobjs(wobjdata baseWobj,wobjdata currentWObj)
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

    !funkcja liczaca wszystkie elementy danego pakietu
    ! ret: num = liczba zliczonych elementow galanterii 
    ! arg: packet - analizowany typ pakietu
    ! arg: elemTableCount - tablica zawierajaca obecnosc wszystkich elementow
    FUNC num countElements(packetType packet,INOUT num elemTableCount{*})
        VAR num result:=0;

        IF Dim(elemTableCount,1)>=maxElementNo THEN
            !sprawdzamy czy jest wieszak gorny
            IF packet.wieszakGorny.name<>"" THEN
                elemTableCount{wieszakGorny}:=1;
                Incr result;
            ELSE
                elemTableCount{wieszakGorny}:=0;
            ENDIF
            !sprawdzamy czy jest wieszak dolny
            IF packet.wieszakDolny.name<>"" THEN
                elemTableCount{wieszakDolny}:=1;
                Incr result;
            ELSE
                elemTableCount{wieszakDolny}:=0;
            ENDIF
            !sprawdzamy czy jest uchwyt rury wejsciowej
            IF packet.uchwytRuryWej.name<>"" THEN
                elemTableCount{uchwytRuryWej}:=1;
                Incr result;
            ELSE
                elemTableCount{uchwytRuryWej}:=0;
            ENDIF
            !sprawdzamy czy jest uchwyt rury wyjsciowej
            IF packet.uchwytRuryWyj.name<>"" THEN
                elemTableCount{uchwytRuryWyj}:=1;
                Incr result;
            ELSE
                elemTableCount{uchwytRuryWyj}:=0;
            ENDIF
            !sprawdzamy czy jest uchwyt miski 1
            IF packet.wieszakMiski1.name<>"" THEN
                elemTableCount{wieszakMiski1}:=1;
                Incr result;
            ELSE
                elemTableCount{wieszakMiski1}:=0;
            ENDIF
            !sprawdzamy czy jest uchwyt miski 2
            IF packet.wieszakMiski2.name<>"" THEN
                elemTableCount{wieszakMiski2}:=1;
                Incr result;
            ELSE
                elemTableCount{wieszakMiski2}:=0;
            ENDIF
            !sprawdzamy czy jest uchwyt miski 3
            IF packet.wieszakMiski3.name<>"" THEN
                elemTableCount{wieszakMiski3}:=1;
                Incr result;
            ELSE
                elemTableCount{wieszakMiski3}:=0;
            ENDIF
            !sprawdzamy czy jest uchwyt miski 4
            IF packet.wieszakMiski4.name<>"" THEN
                elemTableCount{wieszakMiski4}:=1;
                Incr result;
            ELSE
                elemTableCount{wieszakMiski4}:=0;
            ENDIF
            !sprawdzamy czy jest uchwyt miski 5
            IF packet.wieszakMiski5.name<>"" THEN
                elemTableCount{wieszakMiski5}:=1;
                Incr result;
            ELSE
                elemTableCount{wieszakMiski5}:=0;
            ENDIF
            !sprawdzamy czy jest uchwyt miski 6
            IF packet.wieszakMiski6.name<>"" THEN
                elemTableCount{wieszakMiski6}:=1;
                Incr result;
            ELSE
                elemTableCount{wieszakMiski6}:=0;
            ENDIF
            !sprawdzamy czy jest wieszak transportowy
            IF packet.wieszakTransportowy.name<>"" THEN
                elemTableCount{wieszakTransportowy}:=1;
                Incr result;
            ELSE
                elemTableCount{wieszakTransportowy}:=0;
            ENDIF
            !sprawdzamy czy jest wieszak specjalny
            IF packet.wieszakSpecjalny.name<>"" THEN
                elemTableCount{wieszakSpecjalny}:=1;
                Incr result;
            ELSE
                elemTableCount{wieszakSpecjalny}:=0;
            ENDIF
            !sprawdzamy czy jest krociec wejsciowy 1
            IF packet.krociecInlet1.name<>"" THEN
                elemTableCount{krociecInlet1}:=1;
                Incr result;
            ELSE
                elemTableCount{krociecInlet1}:=0;
            ENDIF
            !sprawdzamy czy jest krociec wejsciowy 2
            IF packet.krociecInlet2.name<>"" THEN
                elemTableCount{krociecInlet2}:=1;
                Incr result;
            ELSE
                elemTableCount{krociecInlet2}:=0;
            ENDIF
            !sprawdzamy czy jest krociec wyjsciowy 1
            IF packet.krociecOutlet1.name<>"" THEN
                elemTableCount{krociecOutlet1}:=1;
                Incr result;
            ELSE
                elemTableCount{krociecOutlet1}:=0;
            ENDIF
            !sprawdzamy czy jest krociec wyjsciowy 2
            IF packet.krociecOutlet2.name<>"" THEN
                elemTableCount{krociecOutlet2}:=1;
                Incr result;
            ELSE
                elemTableCount{krociecOutlet2}:=0;
            ENDIF
            !sprawdzamy czy jest czujka 1
            IF packet.krociecCzujka1.name<>"" THEN
                elemTableCount{krociecCzujka1}:=1;
                Incr result;
            ELSE
                elemTableCount{krociecCzujka1}:=0;
            ENDIF
            !sprawdzamy czy jest czujka 2
            IF packet.krociecCzujka2.name<>"" THEN
                elemTableCount{krociecCzujka2}:=1;
                Incr result;
            ELSE
                elemTableCount{krociecCzujka2}:=0;
            ENDIF
            !sprawdzamy czy jest zaslepka
            IF packet.zaslepka.name<>"" THEN
                elemTableCount{krociecZaslepka}:=1;
                Incr result;
            ELSE
                elemTableCount{krociecZaslepka}:=0;
            ENDIF
        ELSE
            ErrWrite "countElements::ERROR","Za mala tablica do przechowania liczby elementow!";
            result:=-1;
        ENDIF

        !uzupelniamy informacje o lacznej liczbie detali do przymocowania
        GUI_statsCalcElementsToDo elemTableCount;

        RETURN result;
    ENDFUNC

    !wrapper do powyzszej funkcji - oprocz liczby elementow zwraca nam dokladna liczbe kroccow, wieszakow, itd
    ! ret: bool = czy udalo sie poprawnie pobrac wszystkie dane pakietu
    ! arg: packet - typ pakietu ktory sprawdzamy
    ! arg: elemTableCount - tabica zawierajaca obecnosc lub nie danych elementow
    ! arg: nozzles - liczba kroccow w danym pakiecie
    ! arg: sensors - liczba czujek w danym pakiecie
    ! arg: lidBrackets - liczba uchwytow miski w danym pakiecie
    ! arg: stands - liczba wieszakow w danym pakiecie
    ! arg: holders - liczba uchwytow rur w danym pakiecie
    FUNC bool getPacketData(packetType packet,INOUT num elemTableCount{*},INOUT num nozzles,INOUT num sensors,INOUT num lidBrackets,INOUT num stands,INOUT num holders)
        VAR bool result:=FALSE;
        VAR num elementsNo;

        !pobranie calkowitej liczby detali
        elementsNo:=countElements(packet,elemTableCount);
        !pobranie liczby poszczegolnych elementow
        nozzles:=elemTableCount{krociecInlet1}+elemTableCount{krociecInlet2}+elemTableCount{krociecOutlet1}+elemTableCount{krociecOutlet2};
        sensors:=elemTableCount{krociecCzujka1}+elemTableCount{krociecCzujka2}+elemTableCount{krociecZaslepka};
        lidBrackets:=elemTableCount{wieszakMiski1}+elemTableCount{wieszakMiski2}+elemTableCount{wieszakMiski3}+elemTableCount{wieszakMiski4};
        stands:=elemTableCount{wieszakDolny}+elemTableCount{wieszakGorny}+elemTableCount{wieszakSpecjalny}+elemTableCount{wieszakTransportowy};
        holders:=elemTableCount{uchwytRuryWej}+elemTableCount{uchwytRuryWyj};
        !sprawdzenie czy liczba sie zgadza
        IF nozzles+sensors+lidBrackets+stands+holders=elementsNo THEN
            result:=TRUE;
        ELSE
            result:=FALSE;
        ENDIF

        RETURN result;
    ENDFUNC

    !funkcja zwracajaca ID kolejnego istniejacego detalu (iterujemy po sekwencji skladania/spawania)
    ! ret: num = ID kolejnego istniejacego detalu w sekwencji 
    ! arg: curr - numer obecnego detalu w danej sekwencji (rozpoczynamy szukanie od kolejnego elementu)
    ! arg: seq - sekwencja skladania/spawania
    ! arg: elemTableCount - tablica zawierajace informacje o obecnosci/nieobecnosci danego detalu w pakiecie (z funkcji countElements!)
    FUNC num nextExistingDetail(num curr,num seq{*},num elemTableCount{*})
        VAR num result:=0;
        VAR num currDetail:=0;
        VAR bool gotResult:=FALSE;

        !na starcie dajemy obecny detal (to oznacza ze sie nie udalo)
        result:=curr;
        IF curr<maxElementNo THEN
            !szukamy w sekwencji kolejnego istniejacego detalu po obecnym 
            FOR i FROM curr+1 TO Dim(seq,1) STEP 1 DO
                !sprawdzamy czy juz mamy wynik
                IF NOT gotResult THEN
                    currDetail:=seq{i};
                    IF elemTableCount{currDetail}=1 THEN
                        result:=currDetail;
                        gotResult:=TRUE;
                    ENDIF
                ENDIF
            ENDFOR
        ENDIF

        RETURN result;
    ENDFUNC

    !funkcja wyliczajaca, ktory w obecnej sekwencji jest dany detal
    ! ret: num = ktory w danej sekwencji jest dany detal
    ! arg: whichDetail - ID detalu ktory chcemy znalezc w sekwencji
    ! arg: seq - sekwencja ktora przeszukujemy pod katem detalu
    FUNC num countDetailInSequence(num whichDetail,num seq{*})
        VAR num result:=-1;
        VAR bool gotResult:=FALSE;

        !przeszukujemy cala sekwencje
        FOR i FROM 1 TO Dim(seq,1) DO
            IF NOT gotResult THEN
                IF seq{i}=whichDetail THEN
                    result:=i;
                    gotResult:=TRUE;
                ENDIF
            ENDIF
        ENDFOR

        RETURN result;
    ENDFUNC

    !funkcja wyliczajaca kat miedzy dwoma wektorami
    ! ret: num = kat miedzy dwoma wektorami
    ! arg: vector1 - pierwszy wektor
    ! arg: vector2 - drugi wektor
    LOCAL FUNC num angleBetweenVectors(pos vector1,pos vector2)
        VAR num angle:=9E9;

        !musimy znormalizowac wektory
        normVector vector1;
        normVector vector2;
        !wyliczamy kat miedzy wektorami
        angle:=ACos(DotProd(vector1,vector2)/(VectMagn(vector1)*VectMagn(vector2)));

        RETURN angle;
    ENDFUNC

    !funkcja wyliczajaca kat miedzy detalem galanterii a baza danego wymiennika
    ! ret: num = kat miedzy baza a detalem
    ! arg: packetType - ktory pakiet jest mierzony (ktora baza wziac pod uwage)
    ! arg: galant - jakieg detalu kat zmierzyc
    FUNC num angleGalantBase(num packetType,pose galant)
        VAR num resultAngle;
        VAR num angleBase:=0;
        VAR num angle:=9E9;

        IF galant.trans.x<>0 OR galant.trans.y<>0 THEN
            !pierw sprawdzamy czy osie X i Z dwoch ukladow sa do siebie rownlolegle
            IF EulerZYX(\Y,galantPosition{packetType}.wieszakGorny.elementWobj.rot)-EulerZYX(\Y,galant.rot)=0 THEN
                !osie sa rownolegle
                angleBase:=EulerZYX(\X,galantPosition{packetType}.wieszakGorny.elementWobj.rot);
                angle:=EulerZYX(\X,galant.rot);
            ELSE
                !jest roznica miedzy osiami
                angleBase:=EulerZYX(\Z,galantPosition{packetType}.wieszakGorny.elementWobj.rot);
                angle:=EulerZYX(\Z,galant.rot);
            ENDIF
            resultAngle:=angleBase-angle;
        ELSE
            ErrWrite "angleGalantBase::ERROR","Nie ma takiego elementu w wymienniku by zmierzyc kat do bazy!";
            Stop;
        ENDIF

        RETURN resultAngle;
    ENDFUNC

    !funkcja wyliczajaca kat miedzy dwoma detalami galanterii - wersja dokladniejsza
    ! ret: num = kat miedzy dwoma detalami galanterii
    ! arg: galant1 - pozycja pierwszego detalu
    ! arg: galant2 - pozycja drugiego detalu
    FUNC num angleBetweenGalant(pose galant1,pose galant2)
        VAR num result;
        VAR pos vecCross;
        VAR pos vec1;
        VAR pos vec2;

        vec1:=poseToVec(galant1\Y);
        vec2:=poseToVec(galant2\Y);
        result:=angleBetweenVectors(vec1,vec2);
        vecCross:=crossProd(vec1,vec2);
        IF vecCross.z<0 result:=-result;

        RETURN result;
    ENDFUNC

    !wrapper powyzszej funkcji tak aby mozna bylo obliczac katy miedzy kolejnymi galanteriami
    ! ret: num = kat miedzy dwoma detalami galanterii
    ! arg: packetType - typ pakietu z jakiego beda brane detale galanterii
    ! arg: galant - numer nowego detalu (bedzie obliczany kat miedzy nowym a poprzednim detalem)
    FUNC num angleBetweenGalantNum(num packetNo,num galant1,num galant2)
        VAR num angle:=9E9;
        VAR location firstDetailPos;
        VAR location secondDetailPos;

        firstDetailPos:=getDetailLocation(packetNo,galant1);
        secondDetailPos:=getDetailLocation(packetNo,galant2);
        !znajdujemy kat miedzy zadanymi elementami galanterii
        angle:=angleBetweenGalant(firstDetailPos.elementWObj,secondDetailPos.elementWObj);

        RETURN angle;
    ENDFUNC

    !procedura liczaca katy miedzy poszczegolnymi detalami na danym pakiecie
    ! ret: num = ile detali jest w danym pakiecie galanterii
    ! arg: referenceDetailNo - ktory detal jest naszym odniesieniem
    ! arg: packetAngles - katy miedzy danym elementem galanterii a wybranym odniesieniem
    FUNC num getPacketAngles(num packetNo,num referenceDetailNo,INOUT num packetAngles{*})
        VAR num elementsNo:=9E9;
        VAR num currentAngle:=9E9;

        !liczymy ilosc elementow i ktore konkretnie sa w danym pakiecie
        elementsNo:=countElements(galantPacket{packetNo},packetAngles);
        IF elementsNo>0 THEN
            FOR i FROM 1 TO maxElementNo DO
                IF packetAngles{i}=1 THEN
                    IF i<>referenceDetailNo THEN
                        packetAngles{i}:=angleBetweenGalantNum(packetNo,referenceDetailNo,i);
                    ELSE
                        packetAngles{i}:=0;
                    ENDIF
                ELSE
                    packetAngles{i}:=9E9;
                ENDIF
            ENDFOR
        ENDIF

        RETURN elementsNo;
    ENDFUNC

    !procedura do czyszczenia tablic
    ! arg: numTable - tablica NUM do wyczyszczenia
    ! arg: posTable - tablica POS do wyczyszczenia
    PROC clearTables(\INOUT num numTable{*},\INOUT pos posTable{*})
        VAR num zeroNumElement:=0;
        VAR pos zeroPosElement:=[0,0,0];

        !sprawdzamy czy zdefiniowano tablice NUM
        IF Present(numTable) THEN
            FOR i FROM 1 TO Dim(numTable,1) DO
                numTable{i}:=zeroNumElement;
            ENDFOR
        ENDIF
        !sprawdzamy czy zdefiniowano tablice POS
        IF Present(posTable) THEN
            FOR i FROM 1 TO Dim(posTable,1) DO
                posTable{i}:=zeroPosElement;
            ENDFOR
        ENDIF
    ENDPROC

    !funkcja pobierajaca pozycje detalu
    ! ret: location = pozycja detalu
    ! num: packetNo - z jakiego typu pakietu nalezy odczytac pozycje
    ! num: detailType - jakiego detalu odczytac pozycje
    FUNC location getDetailLocation(num packetNo,num detailType)
        VAR location result;

        TEST detailType
        CASE wieszakGorny:
            result:=galantPosition{packetNo}.wieszakGorny;
        CASE wieszakDolny:
            result:=galantPosition{packetNo}.wieszakDolny;
        CASE wieszakTransportowy:
            result:=galantPosition{packetNo}.wieszakTransportowy;
        CASE wieszakSpecjalny:
            result:=galantPosition{packetNo}.wieszakSpecjalny;
        CASE uchwytRuryWej:
            result:=galantPosition{packetNo}.uchwytRuryWej;
        CASE uchwytRuryWyj:
            result:=galantPosition{packetNo}.uchwytRuryWyj;
        CASE wieszakMiski1:
            result:=galantPosition{packetNo}.wieszakMiski1;
        CASE wieszakMiski2:
            result:=galantPosition{packetNo}.wieszakMiski2;
        CASE wieszakMiski3:
            result:=galantPosition{packetNo}.wieszakMiski3;
        CASE wieszakMiski4:
            result:=galantPosition{packetNo}.wieszakMiski4;
        CASE wieszakMiski5:
            result:=galantPosition{packetNo}.wieszakMiski5;
        CASE wieszakMiski6:
            result:=galantPosition{packetNo}.wieszakMiski6;
        CASE krociecInlet1:
            result:=galantPosition{packetNo}.krociecInlet1;
        CASE krociecInlet2:
            result:=galantPosition{packetNo}.krociecInlet2;
        CASE krociecOutlet1:
            result:=galantPosition{packetNo}.krociecOutlet1;
        CASE krociecOutlet2:
            result:=galantPosition{packetNo}.krociecOutlet2;
        CASE krociecCzujka1:
            result:=galantPosition{packetNo}.krociecCzujka1;
        CASE krociecCzujka2:
            result:=galantPosition{packetNo}.krociecCzujka2;
        CASE krociecZaslepka:
            result:=galantPosition{packetNo}.zaslepka;
        DEFAULT:
        ENDTEST

        RETURN result;
    ENDFUNC

    !====================================
    !=========  LOGOWANIE  ==============
    !====================================    

    !procedura do logowania statusu o obecnym packiecie
    PROC logCurrPacketStatus(num packetType,num elemTableCount{*},\num currDetail)
        VAR num elementsPresentNo:=0;
        VAR string header:="";
        VAR string title:="";
        VAR num whichPart:=1;
        VAR num allStringsLength:=-1;
        VAR string elementsPresent{3}:=["","",""];

        !sprawdzamy czy jest podany argument opcjonalny
        IF Present(currDetail) THEN
            !jezeli obecny detal > 1 to nie ma sensu wyswietlac ponownie tego komunikatu
            IF currDetail>1 RETURN ;
        ENDIF
        !updateujemy zmienne globalne
        currentPacketString:=packetToString(packetType);
        currPacketNo:=packetType;
        !budujemy naglowek wiadomosci
        header:="CURR PACKET: "+currentPacketString;
        title:=NumToStr(elementsPresentNo,0)+" ELEMENTS IN PACKET:";
        !budujemy tresc wiadomosci
        FOR i FROM 1 TO Dim(elemTableCount,1) DO
            IF elemTableCount{i}=1 THEN
                !sprawdzamy ktora tablice mozemy wypelniac
                IF (StrLen(elementsPresent{whichPart})+StrLen(detailToString(i))+StrLen(", "))>80 Incr whichPart;
                !wypelniamy pierwsza czesc
                elementsPresent{whichPart}:=elementsPresent{whichPart}+detailToString(i);
                IF i<Dim(elemTableCount,1) elementsPresent{whichPart}:=elementsPresent{whichPart}+", ";
                Incr elementsPresentNo;
            ENDIF
        ENDFOR
        !sprawdzamy czy dlugosc header+reason+rl2+rl3+rl4 < 195
        allStringsLength:=StrLen(header)+StrLen(title)+StrLen(elementsPresent{1})+StrLen(elementsPresent{2})+StrLen(elementsPresent{3});
        IF allStringsLength>195 THEN
            !wypisanie wiadomosci w pamieci robota
            ErrWrite\I,header,title\RL2:="STRING TO LONG!";
        ELSE
            !wypisanie wiadomosci w pamieci robota
            ErrWrite\I,header,title\RL2:=elementsPresent{1}\RL3:=elementsPresent{2}\RL4:=elementsPresent{3};
        ENDIF

    ENDPROC

    !procedura do logowania informacji o obecnym detalu
    ! arg: packetType - numer obecnego pakietu
    ! arg: currentDetail - numer obecnego detalu
    PROC logCurrentDetail(num packetType,num currentDetail)
        VAR bool showLog:=TRUE;
        VAR string header:="";
        VAR string message:="";

        header:=packetToString(packetType)+": "+detailToString(currentDetail);
        IF showLog ErrWrite\I,header,message;
    ENDPROC

    !procedura do logowania pojedynczej wartosci 
    ! arg: header - tytul pod jakim ma pojawic sie wiadomosc
    ! arg: value - wartosc jaka ma byc wylogowana
    PROC logSingleValue(string header,num value)
        VAR bool showLog:=TRUE;

        IF showLog ErrWrite\I,header,ArgName(value)+": "+NumToStr(value,2);
    ENDPROC

    !funkcja sprawdzajaca tryb procesu (produkcja/testowy) i wyswietla ewentualny komunikat (TESTOWY)
    ! ret: bool = czy kontynujemy proces (TRUE) czy nie (FALSE)
    FUNC bool adjustProcessFlow()
        VAR bool result;

        IF productionMode THEN
            result:=TRUE;
        ELSE
            result:=UIMessageBox(\Header:="PROCESS"\Message:="Continue?"\Buttons:=btnYesNo)=resYes;
        ENDIF

        RETURN result;
    ENDFUNC

    !funkcja ustawiajaca predkosci procesu w zalezonosci od wybranego trybu pracy
    PROC adjustProcessSpeed()
        IF productionMode THEN
            robSpawSpeedVFast:=productionModeSpeeds{veryFast};
            robSpawSpeedFast:=productionModeSpeeds{fast};
            robSpawSpeedNormal:=productionModeSpeeds{medium};
            robSpawSpeedSlow:=productionModeSpeeds{slow};
            robSpawSpeedVSlow:=productionModeSpeeds{verySlow};
        ELSE
            robSpawSpeedVFast:=testModeSpeeds{veryFast};
            robSpawSpeedFast:=testModeSpeeds{fast};
            robSpawSpeedNormal:=testModeSpeeds{medium};
            robSpawSpeedSlow:=testModeSpeeds{slow};
            robSpawSpeedVSlow:=testModeSpeeds{verySlow};
        ENDIF
    ENDPROC

    !funkcja do pobierania ktory w kolejnosci spawania/sczepiania jest dany detal
    !(potrzebne gdy nie chcemy spawac od pierwszego detalu, tylko np. od wieszakaMiski)
    ! ret: num = ktory w kolejnosci spawania/sczepiania jest dany detal
    ! arg: selectedDetail - detal ktorego pozycji w sekwencji szukamy
    ! arg: packetType - w jakim pakiecie/sekwencji szukamy detalu
    FUNC num getDetailNumber(num selectedDetail,num packetType)
        VAR num result:=-1;
        VAR num currentIterator:=1;
        VAR bool continueSearch:=TRUE;

        !sprawdzamy jaki jest tryb pracy robota
        IF NOT productionMode THEN
            !jezeli jest to tryb testowy to szukamy od JAKIEGO detalu zaczynamy spawac (np. czujka, krociec, itp)
            WHILE continueSearch DO
                IF galantSequence{packetType,currentIterator}=selectedDetail THEN
                    continueSearch:=FALSE;
                    result:=currentIterator;
                ELSE
                    continueSearch:=TRUE;
                    Incr currentIterator;
                ENDIF
            ENDWHILE
        ELSE
            !jezeli jest to tryb produkcyjny to szukamy od KTOREGO detalu zaczynamy spawac 
            !w tym trybie zawsze zaczynamy od pierwszego, niewazne jakiego typu jest !!!
            result:=1;
        ENDIF

        RETURN result;
    ENDFUNC

    !funkcja przesuwajacy dany wobj wzdluz jego osi Z w celu uwzglednieniu rozmiaru pakietu (rozne lapanie na szczypcach)
    FUNC wobjdata moveWobjToPacketSize(PERS wobjdata wobj,num packetSize)
        VAR wobjdata result;
        VAR robtarget temp;
        VAR wobjdata backup;
        VAR num offsetVal;

        backup:=wobj;
        !wyznaczamy o ile trzeba przesunac wobj
        TEST packetSize
        CASE 1:
            offsetVal:=106.5;
        CASE 2:
            offsetVal:=106.5;
        CASE 3:
            offsetVal:=71.1;
        CASE 4:
            offsetVal:=33.85;
        CASE 5:
            offsetVal:=0;
        DEFAULT:
        ENDTEST
        !przesuwamy wobj Z+
        temp:=RelTool(poseToRobt(backup.uframe),0,0,offsetVal);
        result.uframe:=robtToPose(temp);

        RETURN result;
    ENDFUNC

    !podjazd do pozycji domowej nad danym detalem galanterii
    ! arg: posDetail - pozycja danego detalu galanterii
    ! arg: wobj - workobject w ktorym nalezy odjechac do pozycji domowej
    ! arg: front / back (switch) - czy podjechac frontem czy odwrocony do wobj
    PROC galantDetailHomePos(location posDetail,PERS wobjdata wobj\switch front|switch back\num xOffset\num yOffset\num zOffset\switch watchConf)
        VAR robtarget tempPoint;
        VAR num xOffsetCurr:=0;
        VAR num yOffsetCurr:=0;
        VAR num zOffsetCurr:=100;
        VAR num zAngle:=0;
        VAR num detailSide:=0;

        IF Present(xOffset) xOffsetCurr:=xOffset;
        IF Present(yOffset) yOffsetCurr:=yOffset;
        IF Present(zOffset) zOffsetCurr:=zOffset;

        !nadajemy odpowiednia orientacje i pozycje
        WaitTime\InPos,0;
        tempPoint:=CRobT(\Tool:=torchTool\WObj:=destWobj);
        !skladamy odpowiednia pozycje
        tempPoint.trans:=[0,0,0];
        tempPoint.rot:=[0,0,1,0];
        !sprawdzamy z ktorej strony to ma byc pozycja bazowa
        IF Present(front) THEN
            zAngle:=1;
            detailSide:=0;
            tempPoint.robconf:=[0,-1,0,0];
        ELSEIF Present(back) THEN
            zAngle:=179;
            detailSide:=2.5;
            tempPoint.robconf:=[0,0,-2,0];
        ELSE
            !not such case!            
        ENDIF
        tempPoint.trans.x:=detailSide;
        tempPoint.trans.y:=0;
        tempPoint.trans.z:=zOffsetCurr;
        tempPoint:=RelTool(tempPoint,0,0,0\Rz:=zAngle);
        tempPoint:=RelTool(tempPoint,0,0,0\Ry:=45);
        !przesuwamy o zadany offset
        tempPoint:=Offs(tempPoint,xOffsetCurr,yOffsetCurr,0);
        !podjezdzamy do zera wobj z zadanym offsetem
        IF Present(watchConf) THEN
            ConfL\On;
            SingArea\Wrist;
        ELSE
            ConfL\Off;
            SingArea\Wrist;
        ENDIF
        MoveL tempPoint,robSpawSpeedFast,fine,torchTool\WObj:=destWobj;
        WaitTime\InPos,0;
    ENDPROC

    FUNC num safeOffset(robtarget nextPos,num safeRadius,wobjdata wobj\switch X|switch Y)
        VAR num result:=0;
        VAR pos safeVec;

        IF Present(X) OR Present(Y) THEN
            safeVec:=nextPos.trans;
            normVector safeVec;
            !obliczamy wektor 'bezpieczny'
            safeVec.x:=safeVec.x*safeRadius;
            safeVec.y:=safeVec.y*safeRadius;
            safeVec.z:=safeVec.z*safeRadius;
            !zwracamy to co potrzeba
            IF Present(X) result:=safeVec.x;
            IF Present(Y) result:=safeVec.y;
        ENDIF

        RETURN result;
    ENDFUNC

    !funkcja do generowania unikalnego ID pakietu (na podstawie daty i godziny)
    ! ret: num = unikalny ID pakietu
    FUNC num generateID()
        VAR num result:=1;
        VAR num token:=0;
        VAR num i:=1;
        VAR string temp;
        VAR string dateTime;

        !pobieramy obecna date
        dateTime:=CDate();
        !generujemy poczatkowa wartosc liczby losowej (na podstawie daty)
        WHILE StrFind(dateTime,1,"-")<StrLen(dateTime)+1 DO
            token:=StrFind(dateTime,1,"-");
            temp:=StrPart(dateTime,1,token-1);
            dateTime:=StrPart(dateTime,token+1,StrLen(dateTime)-token);
            IF StrToVal(temp,token) THEN
                result:=result*token;
                Incr i;
            ENDIF
        ENDWHILE
        IF StrToVal(dateTime,token) result:=result*token;
        !pobieramy obecna godzine
        dateTime:=CTime();
        !generujemy koncowa wartosc liczby losowej (na podstawie godziny) 
        WHILE StrFind(dateTime,1,":")<StrLen(dateTime)+1 DO
            token:=StrFind(dateTime,1,":");
            temp:=StrPart(dateTime,1,token-1);
            dateTime:=StrPart(dateTime,token+1,StrLen(dateTime)-token);
            IF StrToVal(temp,token) THEN
                result:=result+token;
                Incr i;
            ENDIF
        ENDWHILE
        IF StrToVal(dateTime,token) result:=result+token;

        RETURN result;
    ENDFUNC

    !funkcja sprawdzajaca czy numer pakietu jest poprawny 
    ! ret: bool = czy podany nr pakietu miesci sie w zakresie 1-howManyTypes (TRUE) czy nie (FALSE)
    ! arg: packetNo - sprawdzany typ (numer) pakietu
    FUNC bool checkPacketNo(num packetNo)
        IF packetNo>=1 AND packetNo<=howManyTypes THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        ENDIF
    ENDFUNC

    !funkcja sprawdzajaca czy numer detalu jest poprawny 
    ! ret: bool = czy podany nr detalu miesci sie w zakresie 1-maxElementNo (TRUE) czy nie (FALSE)
    ! arg: detailNo - sprawdzany typ (numer) detalu
    FUNC bool checkDetailNo(num detailNo)
        IF detailNo>=1 AND detailNo<=maxElementNo THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        ENDIF
    ENDFUNC

    !========= PROCEDURY DO LOGOWANIA INPODSTAWOWYCH INFORMACJI =============
    !funkcja pobierajaca nazwe typu obecnego detalu skladanego
    ! ret: string = nazwa obecnie skladanego detalu
    ! arg: detailNo - numer obecnie skladanego detalu
    FUNC string detailToString(num detailNo)
        VAR string result:="";

        TEST detailNo
        CASE krociecOutlet1:
            result:="krociecOutlet1";
        CASE krociecOutlet2:
            result:="krociecOutlet2";
        CASE krociecInlet1:
            result:="krociecInlet1";
        CASE krociecInlet2:
            result:="krociecInlet2";
        CASE krociecCzujka1:
            result:="krociecCzujka1";
        CASE krociecCzujka2:
            result:="krociecCzujka2";
        CASE krociecZaslepka:
            result:="zaslepka";
        CASE wieszakGorny:
            result:="wieszakGorny";
        CASE wieszakDolny:
            result:="wieszakDolny";
        CASE uchwytRuryWej:
            result:="uchwytRuryWej";
        CASE uchwytRuryWyj:
            result:="uchwytRuryWyj";
        CASE wieszakMiski1:
            result:="wieszakMiski1";
        CASE wieszakMiski2:
            result:="wieszakMiski2";
        CASE wieszakMiski3:
            result:="wieszakMiski3";
        CASE wieszakMiski4:
            result:="wieszakMiski4";
        CASE wieszakMiski5:
            result:="wieszakMiski5";
        CASE wieszakMiski6:
            result:="wieszakMiski6";
        CASE wieszakSpecjalny:
            result:="wieszakSpecjalny";
        CASE wieszakTransportowy:
            result:="wieszakTransportowy";
        DEFAULT:
            result:="UNKNOWN";
        ENDTEST

        RETURN result;
    ENDFUNC

    !funkcja pobierajaca nazwe obecnie skladanego pakietu
    ! ret: string = nazwa obecnie skladanego pakietu
    ! arg: packetNo - numer obecnie skladanego pakietu
    FUNC string packetToString(num packetNo)
        VAR string result:="";

        TEST packetNo
        CASE PG16ALVR:
            result:="PG16ALVR";
        CASE PG24ALVR:
            result:="PG24ALVR";
        CASE PG16ANTI:
            result:="PG16ANTI";
        CASE PG32ACV:
            result:="PG32ACV";
        CASE PG16HTP:
            result:="PG16HTP";
        CASE PG24HTP:
            result:="PG24HTP";
        CASE PG32HTP:
            result:="PG32HTP";
        CASE PG32IBC:
            result:="PG32IBC";
        CASE PG32NTI:
            result:="PG32NTI";
        CASE PG24RAY:
            result:="PG24RAY";
        CASE PG32RAY:
            result:="PG32RAY";
        CASE PG32WMCLLC:
            result:="PG32WMCLLC";
        CASE PG32WMCL:
            result:="PG32WMCL";
        CASE PG45AACV:
            result:="PG45AACV";
        CASE PG32ALVR:
            result:="PG32ALVR";
        CASE PG45ALVR:
            result:="PG45ALVR";
        CASE PG45AIBC:
            result:="PG45AIBC";
        CASE PG45ANTI:
            result:="PG45ANTI";
        CASE PG45AWMCLLC:
            result:="PG45AWMCLLC";
        CASE PG45AWMCL:
            result:="PG45AWMCL";
        CASE PG50ACV:
            result:="PG50ACV";
        CASE PG75ACV:
            result:="PG75ACV";
        CASE PG40HTP:
            result:="PG40HTP";
        CASE PG50HTP:
            result:="PG50HTP";
        CASE PG75HTP:
            result:="PG75HTP";
        CASE PG60IBC:
            result:="PG60IBC";
        CASE PG80IBC:
            result:="PG80IBC";
        CASE PG60LVR:
            result:="PG60LVR";
        CASE PG80LVR:
            result:="PG80LVR";
        CASE PG75NTI:
            result:="PG75NTI";
        CASE PG60RAY:
            result:="PG60RAY";
        CASE PG80RAY:
            result:="PG80RAY";
        CASE PG75WMCL:
            result:="PG75WMCL";
        CASE PG100ACV:
            result:="PG100ACV";
        CASE PG120ACV:
            result:="PG120ACV";
        CASE PG120HTP:
            result:="PG120HTP";
        CASE PG120IBC:
            result:="PG120IBC";
        CASE PG120LVR:
            result:="PG120LVR";
        CASE PG100NTI:
            result:="PG100NTI";
        CASE PG120NTI:
            result:="PG120NTI";
        CASE PG120RAY:
            result:="PG120RAY";
        CASE PG100WMCL:
            result:="PG100WMCL";
        CASE PG120WMCL:
            result:="PG120WMCL";
        DEFAULT:
        ENDTEST
        RETURN result;
    ENDFUNC

    !funkcja zwracajaca numer aktualnej galanterii na podstawie jego nazwy
    ! ret: num = numer detalu galanterii
    ! arg: galantName - nazwa detalu galanterii
    FUNC num galantNumFromName(string galantName)
        VAR num result:=-1;

        TEST galantName
        CASE "krociecOutlet1":
            result:=krociecOutlet1;
        CASE "krociecOutlet2":
            result:=krociecOutlet2;
        CASE "krociecInlet1":
            result:=krociecInlet1;
        CASE "krociecInlet2":
            result:=krociecInlet2;
        CASE "krociecCzujka1":
            result:=krociecCzujka1;
        CASE "krociecCzujka2":
            result:=krociecCzujka2;
        CASE "zaslepka":
            result:=krociecZaslepka;
        CASE "wieszakGorny":
            result:=wieszakGorny;
        CASE "wieszakDolny":
            result:=wieszakDolny;
        CASE "uchwytRuryWej":
            result:=uchwytRuryWej;
        CASE "uchwytRuryWyj":
            result:=uchwytRuryWyj;
        CASE "wieszakMiski1":
            result:=wieszakMiski1;
        CASE "wieszakMiski2":
            result:=wieszakMiski2;
        CASE "wieszakMiski3":
            result:=wieszakMiski3;
        CASE "wieszakMiski4":
            result:=wieszakMiski4;
        CASE "wieszakMiski5":
            result:=wieszakMiski5;
        CASE "wieszakMiski6":
            result:=wieszakMiski6;
        CASE "wieszakSpecjalny":
            result:=wieszakSpecjalny;
        CASE "wieszakTransportowy":
            result:=wieszakTransportowy;
        DEFAULT:
            result:=-1;
        ENDTEST

        RETURN result;
    ENDFUNC

    !funkcja zwracajacy dokladny numer detalu na podstawie jego polozenia w danym pakiecie
    ! ret: num = numer detalu galanterii
    ! arg: packetType - w jakim pakiecie mamy szukac
    ! arg: galantLocation - polozenie detalu w danym pakiecie
    FUNC num galantNumFromLocation(num packetType,location galantLocation)
        VAR num result:=-1;

        TEST galantLocation
        CASE galantPosition{packetType}.krociecOutlet1:
            result:=krociecOutlet1;
        CASE galantPosition{packetType}.krociecOutlet2:
            result:=krociecOutlet2;
        CASE galantPosition{packetType}.krociecInlet1:
            result:=krociecInlet1;
        CASE galantPosition{packetType}.krociecInlet2:
            result:=krociecInlet2;
        CASE galantPosition{packetType}.krociecCzujka1:
            result:=krociecCzujka1;
        CASE galantPosition{packetType}.krociecCzujka2:
            result:=krociecCzujka2;
        CASE galantPosition{packetType}.zaslepka:
            result:=krociecZaslepka;
        CASE galantPosition{packetType}.wieszakGorny:
            result:=wieszakGorny;
        CASE galantPosition{packetType}.wieszakDolny:
            result:=wieszakDolny;
        CASE galantPosition{packetType}.uchwytRuryWej:
            result:=uchwytRuryWej;
        CASE galantPosition{packetType}.uchwytRuryWyj:
            result:=uchwytRuryWyj;
        CASE galantPosition{packetType}.wieszakMiski1:
            result:=wieszakMiski1;
        CASE galantPosition{packetType}.wieszakMiski2:
            result:=wieszakMiski2;
        CASE galantPosition{packetType}.wieszakMiski3:
            result:=wieszakMiski3;
        CASE galantPosition{packetType}.wieszakMiski4:
            result:=wieszakMiski4;
        CASE galantPosition{packetType}.wieszakMiski5:
            result:=wieszakMiski5;
        CASE galantPosition{packetType}.wieszakMiski6:
            result:=wieszakMiski6;
        CASE galantPosition{packetType}.wieszakSpecjalny:
            result:=wieszakSpecjalny;
        CASE galantPosition{packetType}.wieszakTransportowy:
            result:=wieszakTransportowy;
        DEFAULT:
            result:=-1;
        ENDTEST

        RETURN result;
    ENDFUNC

    FUNC num packetSizeFromType(num packetType)
        VAR num result;

        TEST packetType
        CASE PG16ALVR:
            result:=1;
        CASE PG24ALVR:
            result:=1;
        CASE PG16ANTI:
            result:=1;
        CASE PG32ACV:
            result:=2;
        CASE PG16HTP:
            result:=2;
        CASE PG24HTP:
            result:=2;
        CASE PG32HTP:
            result:=2;
        CASE PG32IBC:
            result:=2;
        CASE PG32NTI:
            result:=2;
        CASE PG24RAY:
            result:=2;
        CASE PG32RAY:
            result:=2;
        CASE PG32WMCLLC:
            result:=2;
        CASE PG32WMCL:
            result:=2;
        CASE PG45AACV:
            result:=3;
        CASE PG32ALVR:
            result:=3;
        CASE PG45ALVR:
            result:=3;
        CASE PG45AIBC:
            result:=3;
        CASE PG45ANTI:
            result:=3;
        CASE PG45AWMCLLC:
            result:=3;
        CASE PG45AWMCL:
            result:=3;
        CASE PG50ACV:
            result:=4;
        CASE PG75ACV:
            result:=4;
        CASE PG40HTP:
            result:=4;
        CASE PG50HTP:
            result:=4;
        CASE PG75HTP:
            result:=4;
        CASE PG60IBC:
            result:=4;
        CASE PG80IBC:
            result:=4;
        CASE PG60LVR:
            result:=4;
        CASE PG80LVR:
            result:=4;
        CASE PG75NTI:
            result:=4;
        CASE PG60RAY:
            result:=4;
        CASE PG80RAY:
            result:=4;
        CASE PG75WMCL:
            result:=4;
        CASE PG100ACV:
            result:=5;
        CASE PG120ACV:
            result:=5;
        CASE PG120HTP:
            result:=5;
        CASE PG120IBC:
            result:=5;
        CASE PG120LVR:
            result:=5;
        CASE PG100NTI:
            result:=5;
        CASE PG120NTI:
            result:=5;
        CASE PG120RAY:
            result:=5;
        CASE PG100WMCL:
            result:=5;
        CASE PG120WMCL:
            result:=5;
        DEFAULT:
        ENDTEST

        RETURN result;
    ENDFUNC

    !funkcja ktora zwraca liczbe punktow trajektorii przy sczepianiu/spawaniu
    ! ret: num = szukana liczba punktow
    ! arg: detailNo - jakiego detalu szukamy punktow
    ! arg: heft - czy chcemy poznac ilosc punktow sczepiania
    ! arg: weld - czy chcemy poznac ilosc punktow spawania
    ! arg: provided - przewidziana maksymalna ilosc punktow (taka jak wielkosc tablicy)
    ! arg: toSave - liczba punktow zapisanych do pliku (do aproksymacji)
    FUNC num getDetailPointsNo(num detailNo\switch heft|switch weld,\switch provided|switch used|switch toSave)
        VAR num result:=-1;

        TEST (detailNo)
        CASE wieszakDolny:
            IF Present(heft) THEN
                !chcemy policzyc punkty sczepow
                IF Present(provided) result:=5;
                IF Present(used) result:=2;
                IF Present(toSave) result:=2;
            ELSEIF Present(weld) THEN
                !chcemy policzyc punkty spawania
                IF Present(provided) result:=4;
                IF Present(used) result:=4;
                IF Present(toSave) result:=4;
            ENDIF
        CASE wieszakGorny:
            IF Present(heft) THEN
                !chcemy policzyc punkty sczepow
                IF Present(provided) result:=10;
                IF Present(used) result:=4;
                IF Present(toSave) result:=2;
            ELSEIF Present(weld) THEN
                !chcemy policzyc punkty spawania
                IF Present(provided) result:=10;
                IF Present(used) THEN
                    IF upBracketHeftPoint=TRUE THEN
                        result:=8;
                    ELSE
                        result:=6;
                    ENDIF
                ENDIF
                IF Present(toSave) THEN
                    IF upBracketHeftPoint=TRUE THEN
                        result:=8;
                    ELSE
                        result:=6;
                    ENDIF
                ENDIF
            ENDIF
        CASE wieszakMiski1:
            IF Present(heft) THEN
                !chcemy policzyc punkty sczepow
                IF Present(provided) result:=7;
                IF Present(used) result:=2;
                IF Present(toSave) result:=2;
            ELSEIF Present(weld) THEN
                !chcemy policzyc punkty spawania
                IF Present(provided) result:=7;
                IF Present(used) result:=5;
                IF Present(toSave) result:=2;
            ENDIF
        CASE wieszakMiski2:
            IF Present(heft) THEN
                !chcemy policzyc punkty sczepow
                IF Present(provided) result:=7;
                IF Present(used) result:=2;
                IF Present(toSave) result:=2;
            ELSEIF Present(weld) THEN
                !chcemy policzyc punkty spawania
                IF Present(provided) result:=7;
                IF Present(used) result:=5;
                IF Present(toSave) result:=2;
            ENDIF
        CASE wieszakMiski3:
            IF Present(heft) THEN
                !chcemy policzyc punkty sczepow
                IF Present(provided) result:=7;
                IF Present(used) result:=2;
                IF Present(toSave) result:=2;
            ELSEIF Present(weld) THEN
                !chcemy policzyc punkty spawania
                IF Present(provided) result:=7;
                IF Present(used) result:=5;
                IF Present(toSave) result:=2;
            ENDIF
        CASE wieszakMiski4:
            IF Present(heft) THEN
                !chcemy policzyc punkty sczepow
                IF Present(provided) result:=7;
                IF Present(used) result:=2;
                IF Present(toSave) result:=2;
            ELSEIF Present(weld) THEN
                !chcemy policzyc punkty spawania
                IF Present(provided) result:=7;
                IF Present(used) result:=5;
                IF Present(toSave) result:=2;
            ENDIF
        CASE wieszakMiski5:
            IF Present(heft) THEN
                !chcemy policzyc punkty sczepow
                IF Present(provided) result:=7;
                IF Present(used) result:=2;
                IF Present(toSave) result:=2;
            ELSEIF Present(weld) THEN
                !chcemy policzyc punkty spawania
                IF Present(provided) result:=7;
                IF Present(used) result:=5;
                IF Present(toSave) result:=2;
            ENDIF
        CASE wieszakMiski6:
            IF Present(heft) THEN
                !chcemy policzyc punkty sczepow
                IF Present(provided) result:=7;
                IF Present(used) result:=2;
                IF Present(toSave) result:=2;
            ELSEIF Present(weld) THEN
                !chcemy policzyc punkty spawania
                IF Present(provided) result:=7;
                IF Present(used) result:=5;
                IF Present(toSave) result:=2;
            ENDIF
        CASE wieszakSpecjalny:
            IF Present(heft) THEN
                !chcemy policzyc punkty sczepow
                IF Present(provided) result:=8;
                IF Present(used) result:=4;
                IF Present(toSave) result:=2;
            ELSEIF Present(weld) THEN
                !chcemy policzyc punkty spawania
                IF Present(provided) result:=8;
                IF Present(used) result:=4;
                IF Present(toSave) result:=2;
            ENDIF
        CASE wieszakTransportowy:
            IF Present(heft) THEN
                !chcemy policzyc punkty sczepow
                IF Present(provided) result:=7;
                IF Present(used) result:=2;
                IF Present(toSave) result:=2;
            ELSEIF Present(weld) THEN
                !chcemy policzyc punkty spawania
                IF Present(provided) result:=7;
                IF Present(used) result:=6;
                IF Present(toSave) result:=6;
            ENDIF
        CASE uchwytRuryWej:
            IF Present(heft) THEN
                !chcemy policzyc punkty sczepow
                IF Present(provided) result:=5;
                IF Present(used) result:=2;
                IF Present(toSave) result:=2;
            ELSEIF Present(weld) THEN
                !chcemy policzyc punkty spawania
                IF Present(provided) result:=5;
                IF Present(used) result:=4;
                IF Present(toSave) result:=4;
            ENDIF
        CASE uchwytRuryWyj:
            IF Present(heft) THEN
                !chcemy policzyc punkty sczepow
                IF Present(provided) result:=5;
                IF Present(used) result:=2;
                IF Present(toSave) result:=2;
            ELSEIF Present(weld) THEN
                !chcemy policzyc punkty spawania
                IF Present(provided) result:=5;
                IF Present(used) result:=4;
                IF Present(toSave) result:=4;
            ENDIF
        CASE krociecInlet1:
            IF Present(heft) THEN
                !chcemy policzyc punkty sczepow
                IF Present(provided) result:=9;
                IF Present(used) result:=4;
                IF Present(toSave) result:=4;
            ELSEIF Present(weld) THEN
                !chcemy policzyc punkty spawania
                IF Present(provided) result:=9;
                IF Present(used) result:=9;
                IF Present(toSave) result:=9;
            ENDIF
        CASE krociecInlet2:
            IF Present(heft) THEN
                !chcemy policzyc punkty sczepow
                IF Present(provided) result:=9;
                IF Present(used) result:=4;
                IF Present(toSave) result:=4;
            ELSEIF Present(weld) THEN
                !chcemy policzyc punkty spawania
                IF Present(provided) result:=9;
                IF Present(used) result:=9;
                IF Present(toSave) result:=9;
            ENDIF
        CASE krociecOutlet1:
            IF Present(heft) THEN
                !chcemy policzyc punkty sczepow
                IF Present(provided) result:=9;
                IF Present(used) result:=4;
                IF Present(toSave) result:=4;
            ELSEIF Present(weld) THEN
                !chcemy policzyc punkty spawania
                IF Present(provided) result:=9;
                IF Present(used) result:=9;
                IF Present(toSave) result:=9;
            ENDIF
        CASE krociecOutlet2:
            IF Present(heft) THEN
                !chcemy policzyc punkty sczepow
                IF Present(provided) result:=9;
                IF Present(used) result:=4;
                IF Present(toSave) result:=4;
            ELSEIF Present(weld) THEN
                !chcemy policzyc punkty spawania
                IF Present(provided) result:=9;
                IF Present(used) result:=9;
                IF Present(toSave) result:=9;
            ENDIF
        CASE krociecCzujka1:
            IF Present(heft) THEN
                !chcemy policzyc punkty sczepow
                IF Present(provided) result:=7;
                IF Present(used) result:=3;
                IF Present(toSave) result:=3;
            ELSEIF Present(weld) THEN
                !chcemy policzyc punkty spawania
                IF Present(provided) result:=7;
                IF Present(used) result:=7;
                IF Present(toSave) result:=7;
            ENDIF
        CASE krociecCzujka2:
            IF Present(heft) THEN
                !chcemy policzyc punkty sczepow
                IF Present(provided) result:=7;
                IF Present(used) result:=3;
                IF Present(toSave) result:=3;
            ELSEIF Present(weld) THEN
                !chcemy policzyc punkty spawania
                IF Present(provided) result:=7;
                IF Present(used) result:=7;
                IF Present(toSave) result:=7;
            ENDIF
        CASE krociecZaslepka:
            IF Present(heft) THEN
                !chcemy policzyc punkty sczepow
                IF Present(provided) result:=9;
                IF Present(used) result:=4;
                IF Present(toSave) result:=4;
            ELSEIF Present(weld) THEN
                !chcemy policzyc punkty spawania
                IF Present(provided) result:=9;
                IF Present(used) result:=9;
                IF Present(toSave) result:=9;
            ENDIF
        ENDTEST

        RETURN result;
    ENDFUNC

    !====================================
    !=========  TESTY  ==================
    !====================================

    !procedura do testowania procedury pobierajacej miejsce w sekwencji spawania/sczepiania danego detalu
    PROC testStartDetailNo()
        VAR btnres result:=-1;
        VAR string message{5}:=[stEmpty,stEmpty,stEmpty,stEmpty,stEmpty];
        VAR string buttons{5}:=["PACKET","DETAIL","TEST",stEmpty,"EXIT"];
        VAR num selectedPacketNo:=1;
        VAR num selectedDetailNo:=1;
        VAR num lastResult:=-1;

        WHILE result<5 DO
            message:=["CURRENT PACKET NO: "+NumToStr(selectedPacketNo,0),"SELECTED DETAIL: "+NumToStr(selectedDetailNo,0),"LAST RESULT: "+NumToStr(lastResult,0),stEmpty,"SELECT OPTION:"];
            result:=UIMessageBox(\Header:="TEST"\MsgArray:=message\BtnArray:=buttons);
            IF result=1 THEN
                selectedPacketNo:=UINumEntry(\Header:="PACKET NO"\Message:="INPUT PACKET NO:"\InitValue:=selectedPacketNo\MinValue:=1\MaxValue:=35\AsInteger);
            ELSEIF result=2 THEN
                selectedDetailNo:=UINumEntry(\Header:="DETAIL NO"\Message:="INPUT DETAIL NO:"\InitValue:=selectedDetailNo\MinValue:=1\MaxValue:=19\AsInteger);
            ELSEIF result=3 THEN
                lastResult:=getDetailNumber(selectedDetailNo,selectedPacketNo);
            ELSE
                !not such case!
            ENDIF
        ENDWHILE
    ENDPROC

    !procedura testowa do sprawdzenia czy wyznaczanie najblizszych sasiadow dziala
    PROC testSafeDistances()
        VAR num checkElement;
        VAR num closeElement{maxElementNo};
        VAR num angleClosest{maxElementNo};
        VAR pos posClosest{maxElementNo};

        !czyscimy tablice
        clearTables\numTable:=angleClosest\posTable:=posClosest;
        !wybieramy element jaki szukamy
        checkElement:=wieszakMiski3;
        !sprawdzamy czy jest jakis najblizszy detal
        IF NOT checkSafeDistances(PG32IBC,checkElement,closeElement,angleClosest,posClosest) THEN
            FOR i FROM 1 TO Dim(closeElement,1) DO
                IF closeElement{i}<>0 THEN
                    TPWrite "============================";
                    TPWrite detailToString(checkElement)+"->"+detailToString(closeElement{i})+"!";
                    IF angleClosest{i}>0 THEN
                        TPWrite "Znajduje sie po jego lewej stronie!";
                    ELSE
                        TPWrite "Znajduje sie po jego prawej stronie!";
                    ENDIF
                    TPWrite "Kat "+NumToStr(angleClosest{i},2)+" Odleglosc "+NumToStr(VectMagn(posClosest{i}),2);
                ENDIF
            ENDFOR
        ENDIF
    ENDPROC

    !procedura do wysylania informacji do iProda o spawaniu detalu
    PROC iProdSendWeldDetail(num detailNo)
        !uzupelniamy tablice do komunikacji z iProdem
        !numer detalu do spawania
        cmdToSend{4}:=detailNo-1;
        !spawanie = 3
        cmdToSend{3}:=3;
        !stanowisko prawe = 2
        cmdToSend{2}:=2;
        !id rozkazu = 2
        cmdToSend{1}:=2;
    ENDPROC

    !procedura do wysylania informacji do iProda o bledzie
    PROC iProdSendError(num errorNo)
        !uzupelniamy tablice do komunikacji z iProdem
        !numer detalu do spawania
        cmdToSend{4}:=-9000;
        !numer bledu
        cmdToSend{3}:=errorNo;
        !stanowisko prawe = 2
        cmdToSend{2}:=2;
        !id rozkazu = 3
        cmdToSend{1}:=3;
    ENDPROC
ENDMODULE