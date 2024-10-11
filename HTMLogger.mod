MODULE HTMLogger

PERS bool htmlLogEnabled := false;
VAR iodev LogFile;

PROC logToHTML(
	string fileName,
	string logText
	\num logPriority
	\pos logPos)
	VAR num fileSizenum;
	VAR string logColor;
	VAR string dateString;

	! jesli wylaczone logowanie, to wychodzimy
	IF NOT htmlLogEnabled THEN
		RETURN;
	ENDIF
	
	! jesli rozmiar równy 0, to znaczy, ze mamy do czynienia z pustym plikiem
	fileSizenum := FileSize(fileName);
	IF fileSizenum=0 THEN
		writeTableHeader fileName\resetFile;
	ENDIF
	
	! kolor loga w zaleznoci od priorytetu
	IF Present(logPriority) THEN
		IF logPriority < 0 THEN
			logColor := "gray";
		ELSEIF logPriority > 0 AND logPriority <= 1 THEN
			logColor := "black";
		ELSEIF logPriority > 1 AND logPriority <= 2 THEN
			logColor := "green";
		ELSEIF logPriority > 2 AND logPriority <= 3 THEN
			logColor := "orange";
		ELSE
			logColor := "red";
		ENDIF
	ELSE
		logColor := "black";
	ENDIF
	dateString := getHourMinSec();
	Open diskhome\File:=fileName,LogFile\Append;
	Write LogFile,"<TR>"\NoNewLine;
	Write LogFile,"<TD width='10%'>" + dateString + "</TD>"\NoNewLine;
	Write LogFile,"<TD width='70%' align='left'><FONT color='" + logColor + "'>"\NoNewLine; 
	Write LogFile,logText\NoNewLine;
	Write LogFile,"</FONT></TD><TD width='20%'>UNKNOWN</TD></TR>";
	Close LogFile;

ERROR
	Open diskhome\File:=fileName,LogFile\Write;
	Close LogFile;
	RETRY;
ENDPROC

! Pobiera aktualna godzine i zwraca jako string
FUNC string getHourMinSec()
	VAR string dateString := "";
	VAR num tmpNum;
	dateString := "[";
	tmpNum := GetTime(\Hour);
	IF tmpNum < 10 THEN
		dateString := dateString + "0" + NumToStr(tmpNum,0) + ":";
	ELSE
		dateString := dateString + NumToStr(tmpNum,0) + ":";
	ENDIF
	tmpNum := GetTime(\Min);
	IF tmpNum < 10 THEN
		dateString := dateString + "0" + NumToStr(tmpNum,0) + ":";
	ELSE
		dateString := dateString + NumToStr(tmpNum,0) + ":";
	ENDIF
	tmpNum := GetTime(\Sec);
	IF tmpNum < 10 THEN
		dateString := dateString + "0" + NumToStr(tmpNum,0) + "]";
	ELSE
		dateString := dateString + NumToStr(tmpNum,0) + "]";
	ENDIF
	
	!dateString := "[" + NumToStr(GetTime(\Hour),0) + ":" + NumToStr(GetTime(\Min),0) + ":" + NumToStr(GetTime(\Sec),0) + "]";
	RETURN dateString;	
ENDFUNC

! Zapisuje do pliku naglówek tabeli w formacie HTML
PROC writeTableHeader(
		string fileName,
		\switch resetFile)
	VAR num fileSize;
	
	Close LogFile;
	IF Present(resetFile) THEN
		Open diskhome\File:=fileName,LogFile\Write;	
	ELSEIF NOT Present(resetFile) THEN
		Open diskhome\File:=fileName,LogFile\Append;
	ENDIF
	
	Write LogFile,"<TABLE width='100%'>" + ByteToStr(13\Char);
	Write LogFile,"<TBODY align='center'> "+ ByteToStr(13\Char);
	Write LogFile,"<TR>"\NoNewLine;
	Write LogFile,"<TH width='10%'>Time</TH>"\NoNewLine;
	Write LogFile,"<TH width='70%'>Log</TH>"\NoNewLine;
	Write LogFile,"<TH width='20%'>Modul</TH>"\NoNewLine;
	Write LogFile,"</TR>";
	Close LogFile;
ENDPROC

! Zapisuje do pliku stopke tabeli w formacie HTML
PROC writeTableFooter(string fileName)
	Close LogFile;
	Open diskhome\File:=fileName,LogFile\Append;
	Write LogFile,"</TBODY>";
	Write LogFile,"</TABLE>";
ENDPROC

ENDMODULE
