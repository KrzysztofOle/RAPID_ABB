MODULE library
	!struktura dla zmiennych przesylanych do AVS2
	RECORD avsVar
		string varName;
		num varVal;
	ENDRECORD
	    
	!niezbedne do przesylania zmiennych do AVS2
	VAR avsVar sendToAvsVar{10};
	VAR num nextSendToAvs:=1;
	VAR avsVar recvFromAvsVar{10};
	VAR num nextRecvFromAvs:=1;
	!zmienne do raportowania
	PERS bool display:=true;
	PERS bool raport:=FALSE;
	VAR iodev PlikRaportu;
	
	!=============================================
	!===  USER INTERFACE + WYSWIETLANIE
	!=============================================
	 
	PROC wyswietlPose(string nazwaPliku,pose pose_,string kolor)
		ToFile nazwaPliku,"<FONT color="+kolor+"> "+NumToStr(pose_.trans.x,3)+";"+NumToStr(pose_.trans.y,3)+";"+NumToStr(pose_.trans.z,3)+";";
		ToFile nazwaPliku,NumToStr(pose_.rot.q1,3)+";"+NumToStr(pose_.rot.q2,3)+";";
		ToFile nazwaPliku,NumToStr(pose_.rot.q3,3)+";"+NumToStr(pose_.rot.q4,3)+"</FONT><BR>";
	ENDPROC
	
	! wyswietlanie obudowane zeby szybko je wylaczac w razie czego, zmienna wyswietlanie jest globalna
	PROC TPWrite2(string tekst\num Num2|bool Bool2|pos Pos2|orient Orient2)
		IF display THEN
			IF Present(Num2) THEN
				TPWrite tekst\Num:=Num2;
			ELSEIF Present(Bool2) THEN
				TPWrite tekst\Bool:=Bool2;
			ELSEIF Present(Pos2) THEN
				TPWrite tekst\Pos:=Pos2;
			ELSEIF Present(Orient2) THEN
				TPWrite tekst\Orient:=Orient2;
			ELSE
				TPWrite tekst;
			ENDIF
		ENDIF
	ENDPROC
	
	!procedura sluzaca do logowania do pliku
	PROC ToFile(string sPlik,string komunikat\num sNum\pos sPos\switch reset\switch noNewL\switch tab\switch noOpenClose)
		! zmienna lokalna pers bool raportowanie wlacza i wylacza raport do pliku
		IF raport THEN
			IF Present(tab) komunikat:=ByteToStr(9\Char)+komunikat;
			IF Present(reset) THEN
				! nowy plik
				IF NOT Present(noOpenClose) Open diskhome\File:=sPlik,PlikRaportu\Write;
			ELSE
				! dopisujemy do starego
				IF NOT Present(noOpenClose) Open diskhome\File:=sPlik,PlikRaportu\Append;
			ENDIF
			IF Present(noNewL) THEN
				! bez nowego wiersza
				IF ((Present(sNum)) AND (NOT Present(sPos))) Write PlikRaportu,komunikat\Num:=sNum\NoNewLine;
				IF ((NOT Present(sNum)) AND (Present(sPos))) Write PlikRaportu,komunikat\Pos:=sPos\NoNewLine;
				IF ((NOT Present(sNum)) AND (NOT Present(sPos))) Write PlikRaportu,komunikat\NoNewLine;
			ELSE
				! z nowym wierszem
				IF ((Present(sNum)) AND (NOT Present(sPos))) Write PlikRaportu,komunikat+NumToStr(sNum,3)+ByteToStr(13\Char);
				IF ((NOT Present(sNum)) AND (Present(sPos))) Write PlikRaportu,komunikat+NumToStr(sPos.x,3)+","+NumToStr(sPos.y,3)+","+NumToStr(sPos.z,3)+ByteToStr(13\Char);
				IF ((NOT Present(sNum)) AND (NOT Present(sPos))) Write PlikRaportu,komunikat+ByteToStr(13\Char);
			ENDIF
			IF NOT Present(noOpenClose) Close PlikRaportu;
		ENDIF
	ERROR
		IF ERRNO=ERR_FILEACC THEN
			Close PlikRaportu;
			Open diskhome\File:=sPlik,PlikRaportu\Append;
			RETRY;
		ENDIF
	ENDPROC
	
	!=============================================
	!===  MATEMATYKA
	!============================================= 
	
	!funkcja do mnozenia dwoch pozycji w postaci robtargetow
	! ret: robtarget = wynik mnozenia
	! arg: robt1 - pierwszy robtarget do mnozenia
	! arg: robt2 - drugi robtarget do mnozenia
	FUNC robtarget robtMult(robtarget robt1, robtarget robt2)
		VAR robtarget result;
		VAR pose tempPose1;
		VAR pose tempPose2;
		VAR pose resultPose;
		
		tempPose1:=robtToPose(robt1);
		tempPose2:=robtToPose(robt2);
		resultPose:=PoseMult(tempPose1,tempPose2);
		
		result:=robt1;
		result.trans:=resultPose.trans;
		result.rot:=resultPose.rot;
		
		RETURN result;
	ENDFUNC
	
	!funkcja do obliczania odleglosci miedzy dwoma robtargetami
	! ret: num = odleglosc miedzy zadanymi robtargetami
	! arg: robt1 - pierwszy robtarget
	! arg: robt2 - drugi robtarget
	FUNC num robtDistance(robtarget robt1,robtarget robt2)
		VAR num result:=0;
		result:=Distance(robt1.trans,robt2.trans);
		RETURN result;
	ENDFUNC
	
	!funkcja zamieniajaca kod bledu na odpowiedni tekst dla usera
	! ret: string = opis bledu
	! arg: errorNo - numer bledu ktory chcemy zamienic na tekst
	FUNC string errorReason(ERRNUM errorNo)
		VAR string result;
		
		IF errorNo=ERR_ACC_TOO_LOW THEN
			result:="Too low acc/dec in instruction PathAccLim or WorldAccLim";
		ELSEIF errorNo=ERR_ACTIV_PROF THEN
			result:="Error in activate profile data";
		ELSE
			result:="Unknown error - add descr in library!";
		ENDIF
		
		RETURN result;
	ENDFUNC
	
	!funkcja wyliczajaca wektor jednostkowy miedzy dwoma pozycjami
	! ret: pos = znaleziony wektor
	! arg: firstPos - pierwszy punkt (punkt poczatkowy wektora)
	! arg: secondPos - drugi punkt (punkt koncowy wektora)
	FUNC pos calcVector(pos firstPos,pos secondPos)
		VAR pos result;
		VAR num ptsDistance;
		
		ptsDistance:=Distance(firstPos,secondPos);
		result.x:=(firstPos.x-secondPos.x)/ptsDistance;
		result.y:=(firstPos.y-secondPos.y)/ptsDistance;
		result.z:=(firstPos.z-secondPos.z)/ptsDistance;
		
		RETURN result;
	ENDFUNC 
	
	!procedura normalizujaca wektor (do wektora jednostkowego)
	! arg: vector - wektor poddany normalizacji
	FUNC pos normVector(INOUT POS vector)
		VAR num vecLen;
		VAR pos result;
		
		vecLen:=VectMagn(vector);
		result.x:=vector.x/vecLen;
		result.y:=vector.y/vecLen;
		result.z:=vector.z/vecLen;
		
		RETURN result;
	ENDFUNC
	
	!funkcja informujaca o znaku zmiennej
	! ret: num = jezeli liczba dodatnia to 1, jezeli ujemna to -1
	! arg: value - liczba ktora sprawdzamy
	FUNC num sign(num value)
		VAR num result:=0;
		
		IF value>0 result:=1;
		IF value<0 result:=-1;
		
		RETURN result;
	ENDFUNC
	
	!=============================================
	!===  READ/SEND ZMIENNYCH NUM DO AVS2
	!=============================================
	
	!*** AVS -> ROBOT ****************************
	PROC addToRecvAvs(string variableName, num variableValue)
		!wstaw zmienna do tablicy
		recvFromAvsVar{nextRecvFromAvs}.varName:=variableName;
		recvFromAvsVar{nextRecvFromAvs}.varVal:=variableValue;
		!odpowiednio zmien "wskaznik" do kolejnego elementu tablicy
		IF nextRecvFromAvs < 10 THEN
			Incr nextRecvFromAvs;
		ELSE
			nextRecvFromAvs:=1;
		ENDIF
	ENDPROC

	FUNC num readFromRecvAvs(string variableName)
		VAR num result:=0;

		FOR i FROM 1 TO Dim(recvFromAvsVar,1) DO
			IF (recvFromAvsVar{i}.varName=variableName) THEN
				result:=recvFromAvsVar{i}.varVal;
			ENDIF
		ENDFOR

		RETURN result;
	ENDFUNC  

	!*** ROBOT -> AVS ****************************
	PROC addToSendAvs(string variableName, num variableValue)
		!wstaw zmienna do tablicy
		sendToAvsVar{nextSendToAvs}.varName:=variableName;
		sendToAvsVar{nextSendToAvs}.varVal:=variableValue;
		!odpowiednio zmien "wskaznik" do kolejnego elementu tablicy
		IF nextSendToAvs < 10 THEN
			Incr nextSendToAvs;
		ELSE
			nextSendToAvs:=1;
		ENDIF
	ENDPROC

	FUNC num readFromSendAvs(string variableName)
		VAR num result:=9E9;

		FOR i FROM 1 TO Dim(sendToAvsVar,1) DO
			IF (sendToAvsVar{i}.varName=variableName) THEN
				result:=sendToAvsVar{i}.varVal;
			ENDIF
		ENDFOR

		RETURN result;
	ENDFUNC
    
        ! funkcja wylicza nowy wobj tak by pozycja byla zerowa
    FUNC wobjdata calcZeroTarget(wobjdata wobj_in, robtarget target_in)
        VAR POSE wobjIn;
        VAR POSE targetIn;
        VAR POSE wobjTemp;
        VAR wobjdata resultwobj;
        
        wobjIn.trans:=wobj_in.oframe.trans;
        wobjIn.rot:=wobj_in.oframe.rot;
        
        targetIn.trans:=target_in.trans;
        targetIn.rot:=target_in.rot;
        
        wobjTemp:=PoseMult(wobjIn,targetIn);
        
        resultwobj:=wobj_in;
        
        resultwobj.oframe.trans:=wobjTemp.trans;
        resultwobj.oframe.rot:=wobjTemp.rot;
        
        !stop;
        RETURN resultwobj;
        
    ENDFUNC  
    
    FUNC bool compareTransAndRot(robtarget rtA, robtarget rtB)
        VAR bool result:=TRUE;
        
        result:= (result AND (rtA.trans = rtB.trans));
        result:= (result AND (rtA.rot = rtB.rot));
        
        RETURN result;
        
    ENDFUNC

ENDMODULE
