MODULE GalantSpawRLibrary
    !===========================================
    !======= OBSLUGA PAKIETOW I DETALI =========
    !===========================================

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

    !funkcja do pobierania ktory w kolejnosci spawania/sczepiania jest dany detal
    ![potrzebne gdy nie chcemy spawac od pierwszego detalu, tylko np. od wieszakaMiski]
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

    !funkcja ktora zwraca liczbe punktow trajektorii przy sczepianiu/spawaniu
    ! ret: num = szukana liczba punktow
    ! arg: detailNo - jakiego detalu szukamy punktow
    ! arg: heft - czy chcemy poznac ilosc punktow sczepiania
    ! arg: weld - czy chcemy poznac ilosc punktow spawania
    ! arg: provided - przewidziana maksymalna ilosc punktow (taka jak wielkosc tablicy)
    ! arg: used - obecnie uzywana liczba punktow (np. gdy mniejsza ilosc sczepow)
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
                    result:=6;
                    IF upBracketHeftPoint=TRUE result:=8;
                ENDIF
                IF Present(toSave) THEN
                    result:=6;
                    IF upBracketHeftPoint=TRUE result:=8;
                ENDIF
            ENDIF
        CASE wieszakMiski1,wieszakMiski2,wieszakMiski3,wieszakMiski4,wieszakMiski5,wieszakMiski6:
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
        CASE uchwytRuryWej,uchwytRuryWyj:
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
        CASE krociecInlet1,krociecInlet2,krociecOutlet1,krociecOutlet2:
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
        CASE krociecCzujka1,krociecCzujka2:
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
            towerError\handleStop;
        ENDIF

        RETURN resultAngle;
    ENDFUNC

    !funkcja wyliczajaca kat miedzy dwoma detalami (na podstawie ich lokacji)
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

    !funkcja wyliczajaca kat miedzy dwoma detalami galanterii reprezentowanymi przez num (ich nazwe)
    ! ret: num = kat miedzy dwoma detalami galanterii (miedzy galant1 a galant2)
    ! arg: packetNo - typ pakietu z jakiego beda brane detale galanterii
    ! arg: galant1 - numer pierwszego detalu uwzglednianego do obliczenia kata
    ! arg: galant2 - numer drugiego detalu  uwzglednianego do obliczenia kata
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

    !funkcja zwracajaca istniejace w danym pakiecie elementow oraz dokladna liczbe kroccow, wieszakow, itd
    ! ret: bool = czy udalo sie poprawnie pobrac wszystkie dane pakietu
    ! arg: packet - typ pakietu ktory sprawdzamy
    ! arg: elemTableCount - tabica zawierajaca obecnosc lub nie danych elementow
    ! arg: nozzles - liczba kroccow w danym pakiecie
    ! arg: sensors - liczba czujek w danym pakiecie
    ! arg: lidBrackets - liczba uchwytow miski w danym pakiecie
    ! arg: stands - liczba wieszakow w danym pakiecie
    ! arg: holders - liczba uchwytow rur w danym pakiecie
    FUNC bool getPacketData(packetType packet,INOUT num elemTableCount{*},\INOUT num nozzles,\INOUT num sensors,\INOUT num lidBrackets,\INOUT num stands,\INOUT num holders)
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

    !===========================================
    !============ LOGIKA PROCESU ===============
    !===========================================

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
    ! ret: bool = oby dwa workobjecty sa takie same (TRUE) lub nie (FALSE)
    ! arg: baseWobj - uklad bazowy (referencyjny) do ktorego porownujemy inny wobj
    ! arg: currentWobj - uklad porownywany do referencyjnego
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

    !funkcja sprawdzajaca tryb procesu (produkcja/testowy) i wyswietla ewentualny komunikat (TESTOWY)
    ! ret: bool = czy kontynujemy proces (TRUE) czy nie (FALSE)
    FUNC bool adjustProcessFlow()
        VAR bool result;

        IF productionMode AND RMR_avsAutoMode=1 THEN
            result:=TRUE;
        ELSE
            result:=UIMessageBox(\Header:="PROCESS"\Message:="Continue?"\Buttons:=btnYesNo)=resYes;
        ENDIF

        RETURN result;
    ENDFUNC

    !procedura ustawiajaca predkosci procesu w zalezonosci od wybranego trybu pracy
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

    !funkcja przesuwajaca dany wobj wzdluz jego osi Z w celu uwzglednieniu rozmiaru pakietu (rozne lapanie na szczekach)
    ! ret: wobjdata = pozycja nowego ukladu przesunietego o offset wynikajacy z rozmiaru pakietu
    ! arg: wobj - uklad wspolrzednych ktory chcemy przesunac
    ! arg: packetSize - rozmiar pakietu decydujacy o offsecie o ktorym chcemy przesunac 
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
    ! arg: front - czy narzedzie ma byc zwrocone przodem do osi +X detalu
    ! arg: back - czy narzedzie ma byc zwrocone tylem do osi +X detalu
    ! arg: xOffset - odsuniecie pozycji domowej w osi X detalu
    ! arg: yOffset - odsuniecie pozycji domowej w osi Y detalu
    ! arg: zOffset - odsuniecie pozycji domowej w osi Z detalu
    ! arg: watchConf - czy pilnowac konfiguracji podczas dojazdu (jazda po najkrotszej drodze lub do okreslonej konfiguracji robota)
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

    !funkcja wyliczajaca offset do kolejnej pozycji lezacej na okregu o okreslonym promieniu 
    ! ret: num = wyliczony offset do zadanej pozycji
    ! arg: nextPos - pozycja do ktorej chcemy wyliczyc offset
    ! arg: safeRadius - promien okregu offsetu
    ! arg: wobj - w jakim ukladzie wyliczamy offset
    ! arg: X - pobieramy tylko skladowa X offsetu
    ! arg: Y - pobieramy tylko skladowa Y offsetu
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

    !procedura do resetowania sygnalu stopRequest po zatrzymaniu programu [event routine]
    PROC resetStopRequest()
        Reset stopRequest;
    ENDPROC

    !procedura do ograniczania ruchow robota
    ! arg: limitSpd - predkosc do jakiej chcemy ograniczyc ruchy robota
    ! arg: axis - ktora os chcemy ograniczyc (jezeli nie podane to zwalniamy ruch TCP)
    ! arg: all - gdy wybrano axis to podajemy ze zmiana ma byc zaplikowana do wszystkich osi
    PROC limitRobSpeed(num limitSpd,\num axis\switch all)
        !sprawdzam czy bedziemy chcieli zwolnic poszczegolna os czy TCP
        IF Present(axis) THEN
            !chcemy zwolnic osie - spr czy wszystkie czy pojedyncza
            IF Present(all) THEN
                !wszystkie osie zwalniamy
                SpeedLimAxis ROB_1,1,limitSpd;
                SpeedLimAxis ROB_1,2,limitSpd;
                SpeedLimAxis ROB_1,3,limitSpd;
                SpeedLimAxis ROB_1,4,limitSpd;
                SpeedLimAxis ROB_1,5,limitSpd;
                SpeedLimAxis ROB_1,6,limitSpd;
            ELSE
                !zwalniamy wybrana os
                SpeedLimAxis ROB_1,axis,limitSpd;
            ENDIF
        ELSE
            !zwalniamy ruch TCP
            SpeedLimCheckPoint limitSpd;
        ENDIF
    ENDPROC

    !========================================
    !=======  WIEZYCZKA STANOWISKOWA ========
    !========================================    

    !procedura do zmiany stanu czekania robota na wykonanie dowolnego procesu
    ! arg: on - wlaczamy stan czekania robota
    ! arg: off - wylaczamy stan czekania robota
    PROC towerWaiting(\switch on|switch off)
        IF Present(on) THEN
            Set RRM_waiting;
        ELSEIF Present(off) THEN
            Reset RRM_waiting;
        ENDIF
    ENDPROC

    !procedura do zmiany stanu ostrzezenia robota podczas wykonywania danego procesu
    ! arg: running - robot przechodzi w stan ostrzezenia ale jeszcze dziala
    ! arg: handleRunStop - obsluga running warningu, stop i wszystko OK
    ! arg: help - robot zatrzymuje sie i oczekuje na pomoc operatora
    ! arg: handleHelpStop - obsluga help warningu, stop i wszystko OK 
    ! arg: off - wylaczamy stan ostrzezenia
    PROC towerWarning(\switch running|switch handleRunStop|switch help|switch handleHelpStop|switch off)
        IF Present(running) THEN
            !wlaczamy zolta diode (brzeczyk OFF)
            Set RRM_warningRun;
            Reset RRM_warningHelp;
        ELSEIF Present(handleRunStop) THEN
            !wlaczamy zolta diode (brzeczyk OFF)
            Set RRM_warningRun;
            Reset RRM_warningHelp;
            !obsluzone zatrzymanie programu (tylko watek glowny [on ma warning])
            Stop;
            !wylacz zolta diode i brzeczyk
            Reset RRM_warningRun;
            Reset RRM_warningHelp;
        ELSEIF Present(help) THEN
            !wlaczamy zolta diode i brzeczyk
            Reset RRM_warningRun;
            Set RRM_warningHelp;
        ELSEIF Present(handleHelpStop) THEN
            !wlaczamy zolta diode i brzeczyk
            Reset RRM_warningRun;
            Set RRM_warningHelp;
            !obsluzone zatrzymanie programu (tylko watek glowny [on ma warning])
            Stop;
            !wylacz zolta diode i brzeczyk
            Reset RRM_warningRun;
            Reset RRM_warningHelp;
        ELSEIF Present(off) THEN
            !wylacz zolta diode i brzeczyk 
            Reset RRM_warningRun;
            Reset RRM_warningHelp;
        ENDIF
    ENDPROC

    !procedura do zmiany stanu erroru robota podczas wykonywania danego procesu
    ! arg: on - robot przechodzi w stan bledu
    ! arg: handleStop - wiezyczka NOK, program STOP
    ! arg: off - wylaczamy stan bledu
    PROC towerError(\switch on|switch handleStop|switch off)
        IF Present(on) THEN
            !wlacz czerwona diode i brzeczyk
            Set spawSoftwareError;
        ELSEIF Present(handleStop) THEN
            !wlacz czerwona diode i brzeczyk
            Set spawSoftwareError;
            !obsluzone zatrzymanie programu (wszystkie watki)
            Stop\AllMoveTasks;
            !wylacz czerwona diode i brzeczyk
            Reset spawSoftwareError;
        ELSEIF Present(off) THEN
            !wylacz czerwona diode i brzeczyk
            Reset spawSoftwareError;
        ENDIF
    ENDPROC

    !procedura do testowania logiki wiezyczki
    PROC towerLogicTest()
        VAR btnres selected;
        VAR bool end:=FALSE;
        VAR string buttons{5}:=["ERROR","WARN RUN","WARN HELP","WAIT","OK"];

        WHILE NOT end DO
            !wyswietlamy menu dla uzytkownika
            selected:=UIMessageBox(\Header:="TOWER LOGIC TEST"\Message:="Wybierz opcje"\BtnArray:=buttons\Icon:=iconInfo);
            !resetujemy obecny stan wiezyczki
            towerWarning\off;
            towerWaiting\off;
            towerError\off;
            !ustawiamy tryb zgodnie z wyborem
            IF selected=1 THEN
                !wybrano opcje ERROR - symulujemy typowa sytuacje w skrypcie
                ErrWrite "TOWER LOGIC TEST","Test logiki: error stop"\RL2:="Wcisnij PLAY aby kontynuowac!";
                towerError\handleStop;
            ELSEIF selected=2 THEN
                !wybrano opcje WARN RUN - symulujemy typowa sytuacje w skrypcie
                towerWarning\running;
            ELSEIF selected=3 THEN
                !wybrano opcje WARN HELP - symulujemy typowa sytuacje w skrypcie
                ErrWrite "TOWER LOGIC TEST","Test logiki: warning stop"\RL2:="Wcisnij PLAY aby kontynuowac!";
                towerWarning\handleHelpStop;
            ELSEIF selected=4 THEN
                !wybrano opcje WAIT - symulujemy typowa sytuacje w skrypcie       
                towerWaiting\on;
            ELSEIF selected=5 THEN
                !wybrano opcje OK - czekamy 2 sekundy i pytamy uzytkownika czy zakonczyc
                WaitTime 2;
                end:=UIMessageBox(\Header:="TOWER LOGIC TEST"\Message:="Czy zakonczyc testy"\Buttons:=btnYesNo\Icon:=iconInfo)=resYes;
            ENDIF
        ENDWHILE
    ENDPROC

    !===========================================
    !============= LOGOWANIE ===================
    !===========================================

    !procedura do logowania statusu o obecnym pakiecie
    ! arg: packetType - typ pakietu ktory chcemy wylogowac
    ! arg: elemTableCount - tabela obecnosci detali ktore chcemy wylogowac
    ! arg: currDetail - numer obecnego detalu jako wyznacznik czy zaczynamy proces i logujemy czy nie
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

    !===========================================
    !=============== KONWERSJE =================
    !===========================================

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
        CASE PG32NPG:
            result:="PG32NPG";
        CASE PG45ANPG:
            result:="PG45ANPG";
        CASE PG75NPG:
            result:="PG75NPG";
        CASE PG100NPG:
            result:="PG100NPG";
        CASE PG120NPG:
            result:="PG120NPG";
        CASE NPG32NTI:
            result:="NPG32NTI";
        CASE NPG32IBC:
            result:="NPG32IBC";
        CASE NPG45ALVR:
            result:="NPG45ALVR";
        CASE NPG45ANTI:
            result:="NPG45ANTI";
        DEFAULT:
            ErrWrite "GalantSpawRLibary::packetToString:","Brak obslugi tego typu pakietu";
            Stop;
            Stop;
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

    !funkcja pobierajaca rozmiar pakietu na podstawie jego typu
    ! ret: num = rozmiar pakietu (1-5)
    ! arg: packetType - typ pakietu
    FUNC num packetSizeFromType(num packetType)
        VAR num result;

        TEST packetType
        CASE PG32NPG:
            result:=2;
        CASE PG45ANPG:
            result:=3;
        CASE PG75NPG:
            result:=4;
        CASE PG100NPG:
            result:=5;
        CASE PG120NPG:
            result:=5;
        CASE NPG32NTI:
            result:=2;
        CASE NPG32IBC:
            result:=2;
        CASE NPG45ALVR:
            result:=3;
        CASE NPG45ANTI:
            result:=3;
        DEFAULT:
            ErrWrite "GalantSpawRLibary::packetSizeFromType:","Brak obslugi tego typu pakietu";
            Stop;
            Stop;
        ENDTEST

        RETURN result;
    ENDFUNC

    !========================================
    !========  PRZEGLAD STANOWISKA  =========
    !========================================

    !glowna procedura do okresowych przegladow stanowiska
    PROC stationInspectService()
        VAR num inspectionTest:=0;
        VAR num testValue:=0;
        VAR errnum breakVal;
        VAR string headMsg:="INSPEKCJA STANOWISKA";

        !wlaczamy zolta diode
        towerWarning\running;
        !logujemy informacje o starcie testu
        stationInspectSave 0\start\saveMessage:=">>>>>>>> INSPECT START - ROBOT:";
        !ogledziny zewnetrzne
        WHILE inspectionTest<inspectEyeOK DO
            UIMsgBox\Header:=headMsg,"TEST 1/7: ogledziny zewnetrzne."\Buttons:=btnOK\Icon:=iconInfo\MaxTime:=inspectUserWait\BreakFlag:=breakVal;
            inspectionTest:=stationInspectEye();
        ENDWHILE
        !sprawdzenie WAGO + czujnikow
        WHILE inspectionTest<inspectSensorsOK DO
            UIMsgBox\Header:=headMsg,"TEST 2/7: sprawdzenie czujnikow."\Buttons:=btnOK\Icon:=iconInfo\MaxTime:=inspectUserWait\BreakFlag:=breakVal;
            inspectionTest:=stationInspectSensors();
        ENDWHILE
        !sprawdzenie sprezonego powietrza
        WHILE inspectionTest<inspectAirOK DO
            UIMsgBox\Header:=headMsg,"TEST 3/7: sprawdzenie sprezonego powietrza."\Buttons:=btnOK\Icon:=iconInfo\MaxTime:=inspectUserWait\BreakFlag:=breakVal;
            inspectionTest:=stationInspectAir(\getValue);
        ENDWHILE
        !sprawdzenie komunikacji z robMontaz
        WHILE inspectionTest<inspectCommOK DO
            UIMsgBox\Header:=headMsg,"TEST 4/7: sprawdzenie komunikacji."\Buttons:=btnOK\Icon:=iconInfo\MaxTime:=inspectUserWait\BreakFlag:=breakVal;
            inspectionTest:=stationInspectComm(\robMontaz);
        ENDWHILE
        !sprawdzenie pozycji zerowej 
        WHILE inspectionTest<inspectZeroPosOK DO
            UIMsgBox\Header:=headMsg,"TEST 5/7: sprawdzenie pozycji zerowej."\Buttons:=btnOK\Icon:=iconInfo\MaxTime:=inspectUserWait\BreakFlag:=breakVal;
            inspectionTest:=stationInspectZeroPos();
        ENDWHILE
        !sprawdzenie palnika
        WHILE inspectionTest<inspectTorchOK DO
            UIMsgBox\Header:=headMsg,"TEST 6/7: sprawdzenie palnika."\Buttons:=btnOK\Icon:=iconInfo\MaxTime:=inspectUserWait\BreakFlag:=breakVal;
            inspectionTest:=stationInspectTorch();
        ENDWHILE
        !sprawdzenie spawarki
        WHILE inspectionTest<inspectFroniusOK DO
            UIMsgBox\Header:=headMsg,"TEST 7/7: sprawdzenie spawarki."\Buttons:=btnOK\Icon:=iconInfo\MaxTime:=inspectUserWait\BreakFlag:=breakVal;
            inspectionTest:=stationInspectFronius();
        ENDWHILE
        !zapisujemy informacje o koncu inspekcji
        stationInspectSave 0\saveMessage:="<<<<<<<< INSPECT STOP - ROBOT!";
        stationInspectSave 0\saveMessage:="";
        !zakanczamy raport testow
        stationInspectSave 0\stop;
        !informujemy operatora o koncu inspekcji 
        UIMsgBox\Header:="INSPEKCJA STANOWISKA","Koniec sprawdznia stanowiska robSpawR."\Buttons:=btnOK\Icon:=iconInfo
                                                        \MaxTime:=inspectUserWait\BreakFlag:=breakVal;
        !wylaczamy zolta diode
        towerWarning\off;
    ENDPROC

    !funkcja do ogledzin zewnetrznych stacji
    ! ret: num = status ogledzin OK [>0] lub NOK [<0]
    FUNC num stationInspectEye()
        VAR num result:=0;
        VAR btnres selected:=-1;
        VAR string reportCorr:="";
        VAR string msg{5};
        VAR string btn{5}:=["UWAGI","","","","OK"];

        msg{1}:="Sprawdz stan zewnetrzny stanowiska.";
        msg{2}:="";
        msg{3}:=" Gdy skonczysz kliknij:";
        msg{4}:="  UWAGI - gdy cos wymagalo poprawy";
        msg{5}:="  OK - gdy wszystko OK";
        selected:=UIMessageBox(\Header:="OGLEDZINY ZEWNETRZNE"\MsgArray:=msg\BtnArray:=btn\Icon:=iconWarning);
        IF selected=1 THEN
            !prosimy uzytkownika zeby wpisal swoje uwagi
            reportCorr:=UIAlphaEntry(\Header:="OGLEDZINY ZEWNETRZNE"\Message:="Napisz co wymagalo poprawy [max 80 znakow]:"
                                     \Icon:=iconWarning\InitString:=reportCorr);
        ELSE
            !uzytkownik wcisnal OK
            reportCorr:="WSZYSTKO OK!";
        ENDIF
        !uaktualniamy status
        result:=inspectEyeOK;
        !zapisz uwagi do pliku
        stationInspectSave inspectEyeOK\saveMessage:=reportCorr;

        RETURN result;
    ERROR
        !sprawdzamy czy przypadkiem nie wpisano za dlugiego opisu
        IF ERRNO=ERR_STRTOOLNG THEN
            ErrWrite "ERROR::stationInspectEye","Podales za dlugi opis... Musisz go skrocic do 80 znakow";
            RETRY;
        ENDIF
    ENDFUNC

    !funkcja do sprawdzenia czujnikow (a wiec i wyspy WAGO) w stacji
    ! ret: num = status sprawdzenia czujnikow OK [>0] lub NOK [<0]
    FUNC num stationInspectSensors()
        VAR num result:=0;
        VAR num userGripperCnt:=0;
        VAR bool timeout:=FALSE;
        VAR bool retryCheck:=TRUE;
        VAR bool userPacketPresent:=FALSE;
        VAR errnum breakVal;

        !pierw sprawdzamy komunikacje z modulem WAGO
        IF IOUnitState("WAGO")=IOUNIT_RUNNING THEN
            !komunikacja OK
            !=========================== sprawdzamy stan czujnikow pakietu
            userPacketPresent:=UIMessageBox(\Header:="CZUJNIKI [1/3]"\Message:="Czy na stanowisku robSpawR jest wymiennik?"\Buttons:=btnYesNo\Icon:=iconWarning)=resYes;
            !spawdzamy stan czujnikow obecnosci pakietu (w szczekach obrotnika)
            WHILE NOT ((userPacketPresent=TRUE AND rotatorPacketPresent()=1) OR (userPacketPresent=FALSE AND rotatorPacketPresent()=0)) DO
                !inny status czujnikow z tym co podal uzytkownik
                result:=-inspectSensorsOK;
                !zapisz uwagi do pliku
                stationInspectSave -inspectSensorsOK\saveMessage:="CZUJNIKI PAKIETU NOK!";
                !log dla uzytkownika
                ErrWrite "ERROR::stationInspectSensors","Stan pakietu niezgodny z rzeczywistoscia... Sprawdz:"
                                                  \RL2:="1. zaslianie czujnikow w szczece?"\RL3:="2. poprawnosc stanu diod czujnikow?";
                !dajemy uzytkownikowi mozliwosc reakcji
                Stop;
            ENDWHILE
            !informujemy uzytkownika o tym ze wszystko jest OK
            UIMsgBox\Header:="CZUJNIKI [1/3]","Czujniki pakietu OK!"\Buttons:=btnOK\Icon:=iconInfo\MaxTime:=inspectUserWait\BreakFlag:=breakVal;
            !zapisujemy ze czujniki pakietu OK
            stationInspectSave inspectSensorsOK\saveMessage:="CZUJNIKI PAKIETU OK!";
            !=========================== sprawdzamy stan czujnikow docisku
            UIMsgBox\Header:="CZUJNIKI [2/3]","Robot wykona testy docisku - zachowaj ostroznosc!!!"\Buttons:=btnOK\Icon:=iconWarning;
            WHILE retryCheck DO
                IF userPacketPresent=FALSE THEN
                    !chowamy tlok dociskajacy
                    timeout:=TRUE;
                    WHILE timeout=TRUE DO
                        Reset RR_clampActuatorOn;
                        Set RR_clampActuatorOff;
                        WaitDI RR_clampActuatorClosed,1\MaxTime:=5\TimeFlag:=timeout;
                        IF timeout THEN
                            !przekroczono czas oczekiwania na sygnal = wynik NOK
                            result:=-inspectSensorsOK;
                            !zapisz uwagi do pliku
                            stationInspectSave -inspectSensorsOK\saveMessage:="CZUJNIK COFNIECIA TLOKA NOK!";
                            !czujnik cofniecia docisku nie dziala dobrze... log dla uzytkownika
                            ErrWrite "ERROR::stationInspectSensors","Czujnik cofniecia tloka docisku nie dziala... Sprawdz:"
                                                          \RL2:="1. pozycje kontaktronu?"\RL3:="2. zasilanie i diode kontaktronu?";
                            !dajemy uzytkownikowi mozliwosc reakcji
                            Stop;
                        ELSE
                            !wynik OK
                            result:=inspectSensorsOK;
                            !zapisz uwagi do pliku
                            stationInspectSave inspectSensorsOK\saveMessage:="CZUJNIK COFNIECIA TLOKA OK!";
                        ENDIF
                    ENDWHILE
                    !wysuwamy tlok dociskajacy
                    timeout:=TRUE;
                    WHILE timeout=TRUE DO
                        Reset RR_clampActuatorOff;
                        Set RR_clampActuatorOn;
                        WaitDI RR_clampActuatorOpened,1\MaxTime:=5\TimeFlag:=timeout;
                        IF timeout THEN
                            !przekroczono czas oczekiwania na sygnal = wynik NOK
                            result:=-inspectSensorsOK;
                            !zapisz uwagi do pliku
                            stationInspectSave -inspectSensorsOK\saveMessage:="CZUJNIK WYSUNIECIA TLOKA NOK!";
                            !czujnik wysuniecia docisku nie dziala dobrze... log dla uzytkownika
                            ErrWrite "ERROR::stationInspectSensors","Czujnik wysuniecia tloka docisku nie dziala... Sprawdz:"
                                                          \RL2:="1. pozycje kontaktronu?"\RL3:="2. zasilanie i diode kontaktronu?";
                            !dajemy uzytkownikowi mozliwosc reakcji
                            Stop;
                        ELSE
                            !wynik OK
                            result:=inspectSensorsOK;
                            !zapisz uwagi do pliku
                            stationInspectSave inspectSensorsOK\saveMessage:="CZUJNIK WYSUNIECIA TLOKA OK!";
                            !sprawdzamy jeszcze czujnik cisnienia
                            WaitDI RR_pressureControlClamp,1\MaxTime:=5\TimeFlag:=timeout;
                            IF timeout THEN
                                !przekroczono czas oczekiwania na sygnal = wynik NOK
                                result:=-inspectSensorsOK;
                                !zapisz uwagi do pliku
                                stationInspectSave -inspectSensorsOK\saveMessage:="CZUJNIK CISNIENIA NOK!";
                                !czujnik wysuniecia docisku nie dziala dobrze... log dla uzytkownika
                                ErrWrite "ERROR::stationInspectSensors","Czujnik cisnienia nie dziala... Sprawdz:"
                                                          \RL2:="1. zasilanie czujnika?"\RL3:="2. ustawienia czujnika?";
                                !dajemy uzytkownikowi mozliwosc reakcji
                                Stop;
                            ELSE
                                !wynik OK
                                result:=inspectSensorsOK;
                                !zapisz uwagi do pliku
                                stationInspectSave inspectSensorsOK\saveMessage:="CZUJNIK CISNIENIA OK!";
                            ENDIF
                        ENDIF
                    ENDWHILE
                    !konczymy sprawdzenie - wszystko OK
                    retryCheck:=FALSE;
                ELSE
                    !jezeli nie sa wlaczone sygnaly docisku to teraz je wlaczamy
                    IF NOT (DOutput(RR_clampActuatorOff)=0 AND DOutput(RR_clampActuatorOn)=1) THEN
                        Reset RR_clampActuatorOff;
                        Set RR_clampActuatorOn;
                    ENDIF
                    !czekamy na potwierdzenie wykrycia oporu (cisnienie wzrosnie)
                    WaitDI RR_pressureControlClamp,1\MaxTime:=5\TimeFlag:=timeout;
                    IF timeout THEN
                        !przekroczono czas oczekiwania na sygnal = wynik NOK
                        result:=-inspectSensorsOK;
                        !zapisz uwagi do pliku
                        stationInspectSave -inspectSensorsOK\saveMessage:="CZUJNIK CISNIENIA NOK!";
                        !czujnik cisnienia nie dziala dobrze... log dla uzytkownika
                        ErrWrite "ERROR::stationInspectSensors","Brak cisnienia w obwodzie docisku... Sprawdz:"\RL2:="1. zaslianie powietrza?"
                                                  \RL3:="2. ustawienia progu czujnika?";
                        !dajemy uzytkownikowi mozliwosc reakcji
                        Stop;
                    ELSE
                        !konczymy sprawdzenie - wszystko OK
                        retryCheck:=FALSE;
                        !wynik OK
                        result:=inspectSensorsOK;
                        !zapisz uwagi do pliku
                        stationInspectSave inspectSensorsOK\saveMessage:="CZUJNIK CISNIENIA OK!";
                    ENDIF
                ENDIF
            ENDWHILE
            !informujemy uzytkownika o tym ze wszystko jest OK
            UIMsgBox\Header:="CZUJNIKI [2/3]","Czujniki docisku OK!"\Buttons:=btnOK\Icon:=iconInfo\MaxTime:=inspectUserWait\BreakFlag:=breakVal;
            !zapisujemy ze czujniki docisku OK
            stationInspectSave inspectSensorsOK\saveMessage:="CZUJNIKI DOCISKU OK!";
            !=========================== sprawdzamy stan czujnikow szczek
            IF userPacketPresent=FALSE THEN
                retryCheck:=TRUE;
                UIMsgBox\Header:="CZUJNIKI [3/3]","Robot wykona test szczek - obserwuj je!!!"\Buttons:=btnOK\Icon:=iconWarning;
                WHILE retryCheck DO
                    !otworz szczeki
                    Reset RR_graspActuatorOff;
                    Set RR_graspActuatorOn;
                    WaitTime\InPos,3;
                    !schowaj szczeki
                    Reset RR_graspActuatorOn;
                    Set RR_graspActuatorOff;
                    WaitTime\InPos,3;
                    !pytanie do uzytkownika czy szczeki sie ruszyly
                    retryCheck:=UIMessageBox(\Header:="SZCZEKI"\Message:="Czy szczeki wykonaly ruch?"\Buttons:=btnYesNo\Icon:=iconWarning)<>resYes;
                    IF retryCheck THEN
                        !przekroczono czas oczekiwania na sygnal = wynik NOK
                        result:=-inspectSensorsOK;
                        !zapisz uwagi do pliku
                        stationInspectSave -inspectSensorsOK\saveMessage:="SZCZEKI NOK!";
                        !czujnik cisnienia nie dziala dobrze... log dla uzytkownika
                        ErrWrite "ERROR::stationInspectSensors","Brak powietrza w obwodzie szczek... Sprawdz:"
                                                          \RL2:="1. zaslianie powietrza?"\RL3:="2. dzialanie przekaznika?";
                        !dajemy uzytkownikowi mozliwosc reakcji
                        Stop;
                    ENDIF
                ENDWHILE
                !informujemy uzytkownika o tym ze wszystko jest OK
                UIMsgBox\Header:="CZUJNIKI [3/3]","Czujniki szczek OK!"\Buttons:=btnOK\Icon:=iconInfo\MaxTime:=inspectUserWait\BreakFlag:=breakVal;
                !zapisujemy ze czujniki szczek OK
                stationInspectSave inspectSensorsOK\saveMessage:="SZCZEKI OK!";
            ELSE
                UIMsgBox\Header:="CZUJNIKI [3/3]","Zakladam ze szczeki sa OK - nie moge ich sprawdzic bo jest pakiet..."\Buttons:=btnOK\Icon:=iconWarning;
                !zapisujemy ze czujniki szczek PRAWDOPODOBNIE OK
                stationInspectSave inspectSensorsOK\saveMessage:="SZCZEKI OK (PAKIET)!";
            ENDIF
            !wszystkie czujniki dzialaja poprawnie
            result:=inspectSensorsOK;
            !zapisz uwagi do pliku
            stationInspectSave inspectSensorsOK\saveMessage:="WSZYSTKO OK!";
            !na koniec informujemy uzytkownika ze wszystko jest OK
            UIMsgBox\Header:="CZUJNIKI","Dzialanie czujnikow OK!"\Buttons:=btnOK\Icon:=iconInfo\MaxTime:=inspectUserWait\BreakFlag:=breakVal;
        ELSE
            !komunikacja NOK
            result:=-inspectSensorsOK;
            !zapisz uwagi do pliku
            stationInspectSave inspectSensorsOK\saveMessage:="WAGO NOK!";
            !logujemy info dla uzytkownika
            ErrWrite "ERROR::stationInspectSensors","Brak komunikacji z modulem WAGO"\RL2:="Zrestartuj Wago LUB robMontaz i wcisnij START";
            !zatrzymujemy proces zeby uzytkownik mogl zareagowac
            Stop;
        ENDIF

        RETURN result;
    ENDFUNC

    !funkcja do sprawdzenia sprezonego powietrza w stacji
    ! ret: num = status sprawdzenia powietrza OK [>0] lub NOK [<0]
    ! arg: getValue - czy pytac uzytkownika o wartosc ze wskaznika
    FUNC num stationInspectAir(\switch getValue)
        VAR num result:=0;
        VAR num airValue:=0;
        VAR num packetValue:=0;
        VAR bool timeout:=FALSE;
        VAR errnum breakVal;

        !jezeli nie sa wlaczone sygnaly docisku to teraz je wlaczamy
        IF NOT (DOutput(RR_clampActuatorOff)=0 AND DOutput(RR_clampActuatorOn)=1) THEN
            UIMsgBox\Header:="SPREZONE POWIETRZE","Tlok wysunie sie po wcisnieciu OK."\Buttons:=btnOK\Icon:=iconWarning;
            Reset RR_clampActuatorOff;
            Set RR_clampActuatorOn;
        ENDIF
        !sprawdzamy czy jest sprezone powietrze
        WaitDI RR_pressureControlClamp,1\MaxTime:=5\TimeFlag:=timeout;
        IF timeout=FALSE THEN
            !powietrze OK
            result:=inspectAirOK;
            !prosba do usera aby podal wartosc ze wskaznika
            IF Present(getValue) THEN
                airValue:=UINumEntry(\Header:="SPREZONE POWIETRZE"\Message:="Powietrze OK. Podaj wartosc ze wskaznika."\Icon:=iconWarning\MinValue:=0\MaxValue:=10);
            ELSE
                UIMsgBox\Header:="SPREZONE POWIETRZE","Sprezone powietrze OK."\Buttons:=btnOK\Icon:=iconInfo\MaxTime:=inspectUserWait\BreakFlag:=breakVal;
            ENDIF
            !zapisz wynik i wartosc
            stationInspectSave result\saveMessage:="WSZYSTKO OK!"\saveValue:=airValue;
            !mozemy cofnac tlok (jezeli nie ma wymiennika)
            packetValue:=rotatorPacketPresent();
            IF packetValue=0 THEN
                Reset RR_clampActuatorOn;
                Set RR_clampActuatorOff;
            ELSEIF packetValue=-1 THEN
                ErrWrite "ERROR::stationInspectAir","Nie moge cofnac docisku... Zly stan czujnikow pakietu!";
            ENDIF
        ELSE
            !powietrze NOK
            result:=-inspectAirOK;
            !loguj informacje do pliku (log do usera procedurze checkAir)
            stationInspectSave result\saveMessage:="SPREZONE POWIETRZE NOK!";
            !wyrzuc informacje dla uzytkownika
            ErrWrite "ERROR::stationInspectAir","Brak sprezonego powietrza... Sprawdz:"
                                          \RL2:="1. zaslianie powietrza?"\RL3:="2. dzialanie przekaznika?";
            !dajemy uzytkownikowi mozliwosc reakcji
            Stop;
        ENDIF

        RETURN result;
    ENDFUNC

    !funkcja do sprawdzenia komunikacji z robotem robMontaz
    ! ret: num = status sprawdzenia komunikacji OK [>0] lub NOK [<0]
    ! arg: robMontaz - czy chcemy sprawdzic komunikacje z robMontaz
    FUNC num stationInspectComm(\switch robMontaz)
        VAR num result:=0;
        VAR errnum breakVal;
        VAR bool timeout:=FALSE;
        VAR bool retryTest:=TRUE;
        VAR bool robComm;

        !czy chcemy sprawdzic komunikacje z obecnym robotem
        WHILE Present(robMontaz) AND retryTest DO
            !sprawdzamy stan UNITu
            IF IOUnitState("robMontaz")=IOUNIT_RUNNING THEN
                !sprawdzamy czy otrzymamy handshake od robBig
                Set RRM_testConnection;
                WaitDI RMR_testConnection,1\MaxTime:=3\TimeFlag:=timeout;
                Reset RRM_testConnection;
                IF timeout THEN
                    !nie otrzymalismy odpowiedzi
                    robComm:=FALSE;
                    retryTest:=TRUE;
                    !uaktualniamy rezultat
                    result:=-inspectCommOK;
                    !zapisujemy informacje
                    stationInspectSave result\saveMessage:="ROBMONTAZ HANDSHAKE NOK!";
                    !logujemy info dla uzytkownika
                    ErrWrite "ERROR::stationInspectComm","Brak komunikacji z robMontaz"\RL2:="Polaczenie OK ale brak odpowiedzi"
                                                       \RL3:="Zrestartuj robMontaz lub sprawdz robMontaz";
                    !zatrzymujemy proces zeby uzytkownik mogl zareagowac
                    Stop;
                ELSE
                    !otrzymalismy odpowiedz - wszystko OK
                    robComm:=TRUE;
                    retryTest:=FALSE;
                    !uaktualniamy rezultat
                    result:=inspectCommOK;
                    !zapisujemy informacje
                    stationInspectSave result\saveMessage:="ROBMONTAZ OK!";
                    !informujemy uzytkownika o poprawnej komunikacji
                    UIMsgBox\Header:="KOMUNIKACJA ROBOT","Komunikacja robSpawR <-> robMontaz OK."\Buttons:=btnOK
                                                                  \Icon:=iconInfo\MaxTime:=inspectUserWait\BreakFlag:=breakVal;
                ENDIF
            ELSE
                !unit komunikacyjny w ogole nie dziala
                robComm:=FALSE;
                retryTest:=TRUE;
                !uaktualniamy rezultat
                result:=-inspectCommOK;
                !zapisujemy informacje
                stationInspectSave result\saveMessage:="ROBMONTAZ COMM NOK!";
                !logujemy info dla uzytkownika
                ErrWrite "ERROR::stationInspectComm","Brak komunikacji z robMontaz"
                                                   \RL2:="Brak polaczenia..."\RL3:="Zrestartuj robMontaz lub sprawdz robMontaz";
                !zatrzymujemy proces zeby uzytkownik mogl zareagowac
                Stop;
            ENDIF
        ENDWHILE
        !po sprawdzeniu wszystkich robotow wystawiamy rezultat
        IF robComm THEN
            result:=inspectCommOK;
        ELSE
            result:=-inspectCommOK;
        ENDIF

        RETURN result;
    ENDFUNC

    !funkcja do sprawdzenia pozycji zerowej robota
    ! ret: num = status sprawdzenia pozycji zerowej OK [>0] lub NOK [<0]
    FUNC num stationInspectZeroPos()
        VAR num result:=0;
        VAR num airValue:=0;
        VAR errnum breakVal;
        VAR jointtarget currJ;

        !podjezdzamy robotem do pozycji zerowej
        MoveAbsJ zeroRobJoint,robSpawSpeedNormal,fine,tool0\Wobj:=wobj0;
        !sprawdzamy czy robot jest w pozycji zerowej
        IF UIMessageBox(\Header:="POZYCJA ZEROWA"\Message:="Czy znaczniki w pozycji zerowej robota sa OK?"\Buttons:=btnYesNo\Icon:=iconWarning)=resYes THEN
            !pozycja zerowa OK
            result:=inspectZeroPosOK;
            !zapisz wynik i wartosc
            stationInspectSave result\saveMessage:="POZYCJA ZEROWA OK!";
            !wracamy do pozycji domowej
            robSpawGoToHome TRUE;
        ELSE
            !powietrze NOK
            result:=-inspectZeroPosOK;
            !loguj informacje do pliku (log do usera procedurze checkAir)
            stationInspectSave result\saveMessage:="POZYCJA ZEROWA NOK!";
            !logujemy info dla uzytkownika
            ErrWrite "ERROR::stationInspectZeroPos","Pozycja zerowa NOK..."
               \RL2:="W trybie MANUAL podjedz tak, aby znaczniki sie zgadzaly."\RL3:="Skalibruj robota.";
            !zatrzymujemy proces zeby uzytkownik mogl zareagowac
            Stop;
        ENDIF

        RETURN result;
    ENDFUNC

    !funkcja do sprawdzenia palnika
    ! ret: num = status palnika OK [>0] lub NOK [<0]
    FUNC num stationInspectTorch()
        VAR num result:=-1;
        VAR btnres selected:=-1;
        VAR string reportCorr:="WSZYSTKO OK!";
        VAR string msg{5}:=["Inspekcja palnika",""," Kliknij:","  SPRAWDZ - by podjechac robotem do inspekcji",""];
        VAR string btn{5}:=["SPRAWDZ","","","",""];

        !sprawdzamy czy robot jest w pozycji domowej (musi byc ale na wszelki wypadek)
        IF robotInHomePos(FALSE)=FALSE robSpawGoToHome FALSE;
        !podjezdzamy do pozycji inspekcyjnej palnika
        WHILE selected<=4 DO
            selected:=UIMessageBox(\Header:="SPRAWDZENIE PALNIKA"\MsgArray:=msg\BtnArray:=btn\Icon:=iconWarning);
            IF selected=1 THEN
                froniusInspectTorch\fullInspect,TRUE;
                !byl podjazd do pozycji inspekcyjnej = pokazujemy wszystkie opcje
                msg{5}:="  OK - gdy palnik gotowy";
                btn:=["SPRAWDZ","","","","OK"];
            ELSEIF selected=5 THEN
                !prosimy uzytkownika zeby wpisal swoje uwagi
                msg:=["Sprawdzenie zakonczone!","","Czy cos wymagalo poprawy?","  - jezeli wszystko bylo ok to nic nie zmieniaj","  - w przeciwnym wypadku wpisz uwagi [max 80 znakow]"];
                reportCorr:=UIAlphaEntry(\Header:="SPRAWDZENIE PALNIKA"\MsgArray:=msg\Icon:=iconWarning\InitString:=reportCorr);
                !jezeli uzytkownik nic nie wpisal to znaczy ze wszystko bylo OK
                IF reportCorr="" reportCorr:="WSZYSTKO OK!";
            ENDIF
        ENDWHILE
        !uaktualniamy status
        result:=inspectTorchOK;
        !zapisz uwagi do pliku
        stationInspectSave inspectTorchOK\saveMessage:=reportCorr;

        RETURN result;
    ERROR
        !sprawdzamy czy przypadkiem nie wpisano za dlugiego opisu
        IF ERRNO=ERR_STRTOOLNG THEN
            ErrWrite "ERROR::stationInspectTorch","Podales za dlugi opis... Musisz go skrocic do 80 znakow";
            RETRY;
        ENDIF
    ENDFUNC

    !funkcja do sprawdzenia spawarki
    ! ret: num = status spawarki OK [>0] lub NOK [<0]
    FUNC num stationInspectFronius()
        VAR num result:=-1;
        VAR bool gasCheck:=TRUE;
        VAR errnum breakVal;
        VAR string msg{5};
        VAR string reportCorr:="WSZYSTKO OK!";

        !========================================= pytanie czy w spawarce jest drut 
        IF UIMessageBox(\Header:="SPRAWDZENIE SPAWARKI [1/5]"\Message:="Czy w spawarce jest wystarczajaca ilosc drutu?"\Buttons:=btnYesNo\Icon:=iconWarning)=resNo THEN
            !uaktualniamy status
            result:=-inspectFroniusOK;
            !zapisz uwagi do pliku
            stationInspectSave -inspectFroniusOK\saveMessage:="UZUPELNIENIE DRUTU.";
            !brak odpowiedniej ilosci drutu w spawarce
            ErrWrite "ERROR::stationInspectFronius","Przygotuj nowa szpule drutu i w razie potrzeby wymien juz teraz."\RL2:="Jak skonczysz wcisnij PLAY!";
            !dajemy uzytkownikowi mozliwosc zareagowania
            Stop;
        ELSE
            !uaktualniamy status
            result:=inspectFroniusOK;
            !zapisz uwagi do pliku
            stationInspectSave inspectFroniusOK\saveMessage:="DRUT OK!";
        ENDIF
        !========================================= pytanie odnosnie sprawdzenia poziomu wody destylowanej do chlodzenia
        IF UIMessageBox(\Header:="SPRAWDZENIE SPAWARKI [2/5]"\Message:="Czy poziom wody destylowanej OK?"\Buttons:=btnYesNo\Icon:=iconWarning)=resNo THEN
            !uaktualniamy status
            result:=-inspectFroniusOK;
            !zapisz uwagi do pliku
            stationInspectSave -inspectFroniusOK\saveMessage:="UZUPELNIENIE WODY.";
            !brak odpowiedniej ilosci drutu w spawarce
            ErrWrite "ERROR::stationInspectFronius","Uzupelnij wode destylowana do poziomu > minimum!"\RL2:="Jak skonczysz wcisnij PLAY!";
            !dajemy uzytkownikowi mozliwosc zareagowania
            Stop;
        ELSE
            !uaktualniamy status
            result:=inspectFroniusOK;
            !zapisz uwagi do pliku
            stationInspectSave inspectFroniusOK\saveMessage:="WODA OK!";
        ENDIF
        !========================================= pytanie o stan filtru w obiegu wodnym
        IF UIMessageBox(\Header:="SPRAWDZENIE SPAWARKI [3/5]"\Message:="Czy filtr w obiegu wodnym OK?"\Buttons:=btnYesNo\Icon:=iconWarning)=resNo THEN
            !uaktualniamy status
            result:=-inspectFroniusOK;
            !zapisz uwagi do pliku
            stationInspectSave -inspectFroniusOK\saveMessage:="CZYSZCZENIE FILTRU.";
            !brak odpowiedniej ilosci drutu w spawarce
            ErrWrite "ERROR::stationInspectFronius","Wyczysc filtr obiegu wodnego (z tylu spawarki)!"\RL2:="Jak skonczysz wcisnij PLAY!";
            !dajemy uzytkownikowi mozliwosc zareagowania
            Stop;
        ELSE
            !uaktualniamy status
            result:=inspectFroniusOK;
            !zapisz uwagi do pliku
            stationInspectSave inspectFroniusOK\saveMessage:="FILTR OK!";
        ENDIF
        !========================================= sprawdzenie gazu oslonowego
        UIMsgBox\Header:="SPRAWDZENIE SPAWARKI [4/5]","Za chwile nastapi sprawdzenie gazu oslonowego."\Buttons:=btnOK
                                            \Icon:=iconInfo\MaxTime:=inspectUserWait\BreakFlag:=breakVal;
        WHILE gasCheck DO
            Set doFr1GasTest;
            WaitTime\InPos,0.5;
            IF RR_torchGasPresent=1 THEN
                !uaktualniamy status
                gasCheck:=FALSE;
                result:=inspectFroniusOK;
                !zapisz uwagi do pliku
                stationInspectSave inspectFroniusOK\saveMessage:="GAZ OK!"\saveValue:=RR_torchGasFlow;
                !wylaczamy gaz
                Reset doFr1GasTest;
                !potwierdzamy uzytkownikowi ze gaz OK
                UIMsgBox\Header:="SPRAWDZENIE SPAWARKI [4/5]","Gaz OK!"\Buttons:=btnOK\Icon:=iconInfo\MaxTime:=inspectUserWait\BreakFlag:=breakVal;
            ELSE
                !uaktualniamy status
                gasCheck:=TRUE;
                result:=-inspectFroniusOK;
                !zapisz uwagi do pliku
                stationInspectSave -inspectFroniusOK\saveMessage:="GAZ NOK.";
                !brak odpowiedniej ilosci drutu w spawarce
                ErrWrite "ERROR::stationInspectFronius","Brak gazu oslonowego!"\RL2:="Sprawdz reduktor glowny oraz reduktor w spawarce.";
                !dajemy uzytkownikowi mozliwosc zareagowania
                Stop;
            ENDIF
        ENDWHILE
        !========================================= pytanie o inne niezgodnosci (polaczenia, itp)
        msg:=["Czy zauwazyles jakies inne niezgodnosci?","","  - jezeli nie to nic nie zmieniaj","  - w przeciwnym wypadku wpisz uwagi [max 80 znakow]",""];
        reportCorr:=UIAlphaEntry(\Header:="SPRAWDZENIE SPAWARKI [5/5]"\MsgArray:=msg\Icon:=iconWarning\InitString:=reportCorr);
        !jezeli uzytkownik nic nie wpisal to znaczy ze wszystko bylo OK
        IF reportCorr="" reportCorr:="WSZYSTKO OK!";
        !na koniec wszystkich testow uaktualniamy rezultat
        result:=inspectFroniusOK;
        stationInspectSave inspectFroniusOK\saveMessage:=reportCorr;
        !========================================= informujemy uzytkownika o koncu testow
        UIMsgBox\Header:="SPRAWDZENIE SPAWARKI","Koniec sprawdzania spawarki!"\Buttons:=btnOK\Icon:=iconInfo\MaxTime:=inspectUserWait\BreakFlag:=breakVal;

        RETURN result;
    ENDFUNC

    !procedura do zapisywania wyniku testu oraz ewentualnej wiadomosci i wartosci testu
    ! arg: testProgress - etap inspekcji procesu jaki chcemy zapisac
    ! arg: start - flaga informujaca o poczatku inspekcji stanowiska
    ! arg: stop - flaga informujaca o koncu inspekcji stanowiska
    ! arg: saveMessage - wiadomosc ktora chcemy umiescic w pliku
    ! arg: saveValue - wartosc ktora chcemy umiescic w pliku
    PROC stationInspectSave(num testProgress\switch start|switch stop\string saveMessage\num saveValue)
        VAR bool continue:=TRUE;
        VAR bool dirExists:=FALSE;
        VAR string testName:="";
        VAR num suffixPos:=0;
        !do obslugi plikow
        VAR dir directory;
        VAR iodev backupFile;
        VAR string messageString:="Unknown error... Check code...";
        !informacje odnosnie pliku        
        VAR string fileName;
        VAR string dirName;

        !tworzymy foldery
        !KOL: Symulacja RobotStudio
        IF RobOS() THEN
            dirName:="HOME:/STATS/"+CDate()+"/";    
        ELSE
            dirName:="E:/Vrobots/robMontazV2/HOME/STATS/"+CDate()+"/";    
        ENDIF
        !tworzymy nowa nazwe pliku
        fileName:="INSPECT.txt";
        WHILE continue DO
            !sprawdzamy czy istnieje katalog folderName w HOME
            IF IsFile(dirName\Directory) THEN
                !jezeli katalog istnieje to sprawdz czy juz nie istnieje w nim zadany plik
                dirExists:=TRUE;
                OpenDir directory,dirName;
                IF NOT IsFile(dirName+fileName) THEN
                    !takiego pliku nie ma - nalezy go stworzyc
                    Open dirName+fileName,backupFile\Write;
                ELSE
                    !taki plik juz istnieje - pozycje dopisujemy do niego
                    Open dirName+fileName,backupFile\Append;
                ENDIF
                !sprawdzamy czy chcemy pierw zapisac tytul nowej sekcji
                IF testProgress>0 THEN
                    IF inspectLastStatus<>Abs(testProgress) THEN
                        Write backupFile,stationInspectToStr(testProgress\uppercase\headerStyle);
                    ENDIF
                    !zapisujemy pozycje do pliku
                    IF Present(saveMessage) THEN
                        Write backupFile,"DETAILS: "+saveMessage;
                    ENDIF
                    IF Present(saveValue) THEN
                        Write backupFile,"VALUE:   "+NumToStr(saveValue,3);
                    ENDIF
                ELSE
                    IF Present(start) THEN
                        !jezeli to pierwszy test inspekcji to dodajemy czas startowy
                        Write backupFile,"**************************************************************";
                        Write backupFile,"***  INSPECTION START ****************************************";
                        Write backupFile,"***  DATE: "+CDate()+" ****************************************";
                        Write backupFile,"***  TIME: "+CTime()+"   ****************************************";
                        Write backupFile,"";
                    ELSEIF Present(stop) THEN
                        Write backupFile,"***  INSPECTION STOP  ****************************************";
                        Write backupFile,"***  DATE: "+CDate()+" ****************************************";
                        Write backupFile,"***  TIME: "+CTime()+"   ****************************************";
                        Write backupFile,"**************************************************************";
                        Write backupFile,"";
                        Write backupFile,"";
                    ENDIF
                    !zapisujemy przeslana wiadomosc 
                    IF Present(saveMessage) THEN
                        Write backupFile,saveMessage;
                    ENDIF
                ENDIF
                !uaktualniamy ostatni status
                inspectLastStatus:=Abs(testProgress);
                !zamykamy plik i folder
                Close backupFile;
                CloseDir directory;
                !zeby wyjsc z petli glownej
                continue:=FALSE;
            ENDIF
        ENDWHILE
    ERROR
        IF ERRNO=ERR_FILEACC THEN
            IF NOT dirExists THEN
                !jezeli nie istnieje to stworz taki katalog
                createDir dirName;
                continue:=TRUE;
                SkipWarn;
                RETRY;
            ENDIF
            messageString:="Niepoprawny sposob odwolania sie do pliku/folderu.";
        ELSEIF ERRNO=ERR_FILEOPEN THEN
            messageString:="Wskazany plik/folder nie moze zostac otwarty.";
        ELSEIF ERRNO=ERR_FILNOTFND THEN
            messageString:="Nie znaleziono pliku/folderu";
        ELSEIF ERRNO=ERR_FILEEXIST THEN
            messageString:="Plik/folder juz istnieje w pamieci kontrolera";
        ENDIF
        ErrWrite "ERROR::stationInspectSave",messageString;
        continue:=FALSE;
    ENDPROC

    !funkcja sluzaca do zamiany obecnego statusu inspekcji na ciag znakow
    ! ret: string - ciag znakow reprezentujacy obecny status
    ! arg: inspectStatus - status do zamiany na string
    ! arg: uppercase - czy wynikowy tekst ma byc tylko duzymi literami
    ! arg: headerStyle - czy wynikowy string ma byc w formacie naglowka
    FUNC string stationInspectToStr(num inspectStatus\switch uppercase\switch headerStyle)
        VAR string result;

        IF inspectStatus=inspectEyeOK THEN
            result:="ogledziny zewnetrzne";
        ELSEIF inspectStatus=inspectSensorsOK THEN
            result:="czujniki";
        ELSEIF inspectStatus=inspectAirOK THEN
            result:="sprezone powietrze";
        ELSEIF inspectStatus=inspectCommOK THEN
            result:="komunikacja roboty";
        ELSEIF inspectStatus=inspectZeroPosOK THEN
            result:="pozycja zerowa";
        ELSEIF inspectStatus=inspectTorchOK THEN
            result:="palnik";
        ELSEIF inspectStatus=inspectFroniusOK THEN
            result:="spawarka";
        ELSE
            result:="nieznane...";
        ENDIF
        !sprawdzamy czy tekst ma byc duzymi literami
        IF Present(uppercase) THEN
            result:=StrMap(result,STR_LOWER,STR_UPPER);
        ENDIF
        !sprawdzamy czy ma byc styl naglowka
        IF Present(headerStyle) THEN
            result:=styleHeader(result);
        ENDIF

        RETURN result;
    ENDFUNC

    !===========================================
    !=========== KOMUNIKACJA IPROD =============
    !===========================================

    !procedura do wysylania informacji do iProda o spawaniu detalu
    ! arg: detailNo - numer detalu ktory chcemy przeslac do iProda
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
    ! arg: errorNo - numer bledu ktory chcemy wyslac do iProda
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
        IF NOT checkSafeDistances(PG32NPG,checkElement,closeElement,angleClosest,posClosest) THEN
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
ENDMODULE