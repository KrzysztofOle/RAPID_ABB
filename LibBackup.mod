MODULE LibBackup(NOSTEPIN, VIEWONLY)
    
    !funkcja zapisujaca wybrane przez uzytkownika dane do pliku w katalogu HOME:/ARCHIVE/
	!jezeli takiego katalogu nie ma to funkcja automatycznie go utworzy (patrz obsluga bledu)
	! ret: bool = informacja czy udalo sie zapisac do pliku (TRUE), czy nie (FALSE)
	! arg: fileName - nazwa pliku do ktorego zapisujemy - moze byc z rozszerzeniem lub bez (wtedy *.txt)
	! arg: Wobj - argument opcjonalny - czy zapisujemy dane odnosnie workobjectu
	! arg: Tool - argument opcjonalny - czy zapisujemy dane odnosnie narzedzia
	FUNC bool backupData(string fileName,\wobjdata Wobj,\tooldata Tool \num maxError \num meanError)
		VAR bool result:=FALSE;
		VAR bool continue:=TRUE;
		VAR bool dirExists:=FALSE;
		!flaga informujaca o tym czy katalog istnieje (do obslugi bledu)
		VAR dir directory;
		VAR iodev backupFile;
		VAR string messageString;
		!tresc wiadomosci dla uzytkownika
		VAR string finalFileName;
		!ostateczna nazwa pliku (zawiera date stworzenia)
		VAR string name;
		!nazwa pliku
		VAR string extension;
		!rozszerzenie pliku
        VAR pos rotAngle;
		
		!sprawdzenie czy podano rozszerzenie czy nie
		checkFileExt fileName,name,extension,".txt";
		!stworz koncowa nazwe pliku
		finalFileName:=name+"_"+CDate()+extension;
		WHILE continue DO
			!sprawdzamy czy istnieje katalog "BACKUP" w HOME
			IF IsFile("HOME:/ARCHIVE"\Directory) THEN
				!jezeli katalog istnieje to sprawdz czy juz nie istnieje w nim zadany plik
				dirExists:=TRUE;
				OpenDir directory,"HOME:/ARCHIVE";
				IF NOT IsFile("HOME:/ARCHIVE/"+finalFileName) THEN
					!takiego pliku nie ma - nalezy go stworzyc
					Open "HOME:/ARCHIVE/"+finalFileName,backupFile\Write;
				ELSE
					!taki plik istnieje - bedziemy do niego dopisywac
					Open "HOME:/ARCHIVE/"+finalFileName,backupFile\Append;
				ENDIF
				Write backupFile,"========= "+CTime()+" =========";
				IF Present(Wobj) THEN
					Write backupFile,"WOBJ: "+ArgName(Wobj);
					Write backupFile,"TRANS = ["+NumToStr(Wobj.uframe.trans.x,5)+", "+NumToStr(Wobj.uframe.trans.y,5)+", "+NumToStr(Wobj.uframe.trans.z,5)+"]";
					Write backupFile,"ROT = ["+NumToStr(Wobj.uframe.rot.q1,5)+", "+NumToStr(Wobj.uframe.rot.q2,5)+", "+NumToStr(Wobj.uframe.rot.q3,5)+", "+NumToStr(Wobj.uframe.rot.q4,5)+"]";
                    rotAngle.x:=EulerZYX(\X,Wobj.uframe.rot);
                    rotAngle.y:=EulerZYX(\Y,Wobj.uframe.rot);
                    rotAngle.z:=EulerZYX(\Z,Wobj.uframe.rot);
                    Write backupFile,"ROT.deg = ["+NumToStr(rotAngle.x,5)+", "+NumToStr(rotAngle.y,5)+", "+NumToStr(rotAngle.z,5)+"]";
				ENDIF
				IF Present(Tool) THEN
					Write backupFile,"TOOL: "+ArgName(Tool);
					Write backupFile,"TRANS = ["+NumToStr(Tool.tframe.trans.x,5)+", "+NumToStr(Tool.tframe.trans.y,5)+", "+NumToStr(Tool.tframe.trans.z,5)+"]";
					Write backupFile,"ROT = ["+NumToStr(Tool.tframe.rot.q1,5)+", "+NumToStr(Tool.tframe.rot.q2,5)+", "+NumToStr(Tool.tframe.rot.q3,5)+", "+NumToStr(Tool.tframe.rot.q4,5)+"]";
                    rotAngle.x:=EulerZYX(\X,Tool.tframe.rot);
                    rotAngle.y:=EulerZYX(\Y,Tool.tframe.rot);
                    rotAngle.z:=EulerZYX(\Z,Tool.tframe.rot);
                    Write backupFile,"ROT.deg = ["+NumToStr(rotAngle.x,5)+", "+NumToStr(rotAngle.y,5)+", "+NumToStr(rotAngle.z,5)+"]";
                    IF Present(maxError) Write backupFile,"maxError = ["+NumToStr(maxError,3)+"]";
                    IF Present(meanError) Write backupFile,"meanError = ["+NumToStr(meanError,3)+"]";
                    ! excel
                    IF Present(maxError) AND Present(meanError) Write backupFile,"["+NumToStr(Tool.tframe.trans.x,5)+", "+NumToStr(Tool.tframe.trans.y,5)+", "+NumToStr(Tool.tframe.trans.z,5)+"],["+NumToStr(maxError,3)+"],["+NumToStr(meanError,3)+"]";
				ENDIF
				Close backupFile;
				CloseDir directory;
				ErrWrite\I,"ARCHIVE","Stworzono kopie";
				continue:=FALSE;
				result:=TRUE;
			ENDIF
		ENDWHILE
		
		RETURN result;
	ERROR
		IF ERRNO=ERR_FILEACC THEN
			IF NOT dirExists THEN
				!jezeli nie istnieje to stworz taki katalog
				MakeDir "HOME:/ARCHIVE/";
				ErrWrite\I,"KATALOG GLOWNY","Stworzono katalog glowny";
				continue:=TRUE;
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
		ErrWrite \W,"ERROR BACKUP",messageString;
		continue:=FALSE;
		result:=FALSE;
		RETURN result;
	ENDFUNC
ENDMODULE