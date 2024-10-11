MODULE HTML  (NOSTEPIN, VIEWONLY)
	VAR iodev html_file{11};
	VAR BOOL opened{11};
	VAR num ostatniPlik := 10;
	CONST byte Log1:=1;
	CONST byte Log2:=2;
	CONST byte Log3:=3;
	CONST byte Log4:=4;
	CONST byte Log5:=5;
	CONST byte Log6:=6;
	CONST byte Log7:=7;
	CONST byte Log8:=8;
	CONST byte Log9:=9;
	CONST byte Log10:=10;
	CONST byte LogHead:=11;
	CONST byte LogHeadNW:=12;
	CONST byte LogHeadEnd:=13;
	CONST byte LogData1:=14;
	CONST byte LogData2:=15;
	CONST byte LogData3:=16;
	CONST byte LogWarn:=17;
	CONST byte LogError:=18;
	CONST byte LogComm:=19;
	CONST byte LogCommByte:=20;
	! wlaczniki iwylaczniki logow
	PERS bool OnOffLogs{20}:=[TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE];
	PERS BOOL logowanie := FALSE;
	!licznik zagniezdzania
	VAR num addTab:=0;
	
	!! proste formatowanie tekstu HTML
	CONST BYTE f_b      := 1;
	CONST BYTE f_strong := 2;
	CONST BYTE f_i      := 3;
	CONST BYTE f_em     := 4;
	CONST BYTE f_big    := 5;
	CONST BYTE f_small  := 6;
	CONST BYTE f_sup    := 7;
	CONST BYTE f_sub    := 8;
	CONST BYTE f_pre    := 9;
	CONST BYTE f_code   := 10;
	CONST BYTE f_tt     := 11;
	CONST BYTE f_kbd    := 12;
	CONST BYTE f_var    := 13;
	CONST BYTE f_samp   := 14;
	
	PROC LOG(
		byte level,
		string logTekst,
		\num nm,
		\pose pe,
		\orient o,
		\pos ps)
		
		VAR STRING Tcolor;
		VAR BYTE format;
		
		IF NOT logowanie RETURN;
		ostatniPlik := 10;
		TEST level
			CASE Log1:
				IF NOT OnOffLogs{Log1} RETURN;
				Tcolor:="gray";
				format := 0;
			CASE Log2:
				IF NOT OnOffLogs{Log2} RETURN;
				Tcolor:="DarkGreen";
				format := 0;
			CASE Log3:
				IF NOT OnOffLogs{Log3} RETURN;
				Tcolor:="DarkBlue";
				format := 0;
			CASE Log4:
				IF NOT OnOffLogs{Log4} RETURN;
				Tcolor:="gray";
				format := 0;
			CASE Log5:
				IF NOT OnOffLogs{Log5} RETURN;
				Tcolor:="gray";
				format := 0;
			CASE Log6:
				IF NOT OnOffLogs{Log6} RETURN;
				Tcolor:="gray";
				format := 0;
			CASE Log7:
				IF NOT OnOffLogs{Log7} RETURN;
				Tcolor:="gray";
				format := 0;
			CASE Log8:
				IF NOT OnOffLogs{Log8} RETURN;
				Tcolor:="gray";
				format := 0;
			CASE Log9:
				IF NOT OnOffLogs{Log9} RETURN;
				Tcolor:="gray";
				format := 0;
			CASE Log10:
				IF NOT OnOffLogs{Log10} RETURN;
				Tcolor:="gray";
				format := 0;
			CASE LogHead:
				! HEAD
				IF NOT OnOffLogs{LogHead} RETURN;
				Tcolor:="Navy";
				format := f_big;
				Incr addTab;
			CASE LogHeadNW:
				IF NOT OnOffLogs{LogHead} RETURN;
				Tcolor:="Navy";
				format := f_big;
			CASE LogHeadEND:
				IF NOT OnOffLogs{LogHead} RETURN;
				Tcolor:="Navy";
				format := f_big;
				Decr addTab;
			CASE LogData1:
				IF NOT OnOffLogs{LogData1} RETURN;
				Tcolor:="green";
				format := f_tt;
			CASE LogData2:
				IF NOT OnOffLogs{LogData2} RETURN;
				Tcolor:="green";
				format := f_tt;
			CASE LogData3:
				IF NOT OnOffLogs{LogData3} RETURN;
				Tcolor:="green";
				format := f_tt;
			CASE LogWarn:
				IF NOT OnOffLogs{LogWarn} RETURN;
				Tcolor:="purple";
				format := f_b;
			CASE LogError:
				IF NOT OnOffLogs{LogError} RETURN;
				Tcolor:="red";
				format := f_b;
			CASE LogComm:
				IF NOT OnOffLogs{LogError} RETURN;
				Tcolor:="teal";
				format := f_b;
			CASE LogCommByte:
		ENDTEST
		!
		HTML_text logTekst\Color:=Tcolor\format:=format;
		!
		IF Present(nm) THEN
			HTML_num nm\Color:=Tcolor\format:=format;
		ENDIF
		IF Present(pe) THEN
			HTML_pose pe\Color:=Tcolor\format:=format;
		ENDIF
		IF Present(o) THEN
			HTML_rot o\Color:=Tcolor\format:=format;
		ENDIF
		IF Present(ps) THEN
			HTML_pos ps\Color:=Tcolor\format:=format;
		ENDIF
		!
	ERROR
		TPWrite "error in LOG...";
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC LOG_Start(STRING file \switch Reset)
	
		IF Present(Reset) THEN
			TPWrite "...LOG_Start(" + file + "\\Reset)";
			HTML_create diskhome,file,10\Reset;
		ELSE
			TPWrite "...LOG_Start("+file+")";
			HTML_create diskhome,file,10;
		ENDIF
	ERROR
		TPWrite "error in LOG_Start...";
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC LOG_End()
	
		TPWrite "...LOG_End";
		HTML_close 10;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_text_nw(STRING Tekst)
	
		addTab:=0;
		Write html_file{ostatniPlik},Tekst+"<br/>";
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	! generator plikow html
	! wersja: alfa
	! data: 2007-16-11
	!
	PROC HTML_text(STRING Tekst\STRING Color\NUM format\switch no_br)
		VAR STRING TColor;
		IF Present(Color) THEN
			TColor := Color;
		ELSE
			TColor := "Black";
		ENDIF
		
		IF NOT Present(no_br) THEN
			Write html_file{ostatniPlik},"<BR>";
		ENDIF
		
		IF Present(format) THEN
		TEST format
			CASE f_b:
				! tekst pogrubiony
				Write html_file{ostatniPlik},"<b style='color: "+TColor+";'>";
				Write html_file{ostatniPlik},Tekst+"</b>";
			CASE f_strong:
				! tekst pogrubiony
				Write html_file{ostatniPlik},"<strong style='color: "+TColor+";'>";
				Write html_file{ostatniPlik},Tekst+"</strong>";
			CASE f_i:
				! tekst pisany kursywa
				Write html_file{ostatniPlik},"<i style='color: "+TColor+";'>";
				Write html_file{ostatniPlik},Tekst+"</i>";
			CASE f_em:
				! tekst pisany ala kursywa
				Write html_file{ostatniPlik},"<em style='color: "+TColor+";'>"+Tekst+"</em>";
			CASE f_big:
				! tekst wiekszy
				Write html_file{ostatniPlik},"<big style='color: "+TColor+";'>"+Tekst+"</big>";
			CASE f_small:
				! tekst mniejszy
				Write html_file{ostatniPlik},"<small style='color: "+TColor+";'>"+Tekst+"</small>";
			CASE f_sup:
				! indeks dolny
				Write html_file{ostatniPlik},"<sup style='color: "+TColor+";'>"+Tekst+"</sup>";
			CASE f_sub:
				! index gorny
				Write html_file{ostatniPlik},"<sub style='color: "+TColor+";'>"+Tekst+"</sub>";
			CASE f_pre:
				! tekst preformatowany
				Write html_file{ostatniPlik},"<pre style='color: "+TColor+";'>"+Tekst+"</pre>";
			CASE f_code:
				! tekst kod - czcionka o stalej szerokosci
				Write html_file{ostatniPlik},"<code style='color: "+TColor+";'>"+Tekst+"</code>";
			CASE f_tt:
				! tekst czcionka o stalej szerokosci
				Write html_file{ostatniPlik},"<tt style='color: "+TColor+";'>"+Tekst+"</tt>";
			CASE f_kbd:
				! tekst czcionka komputerowa
				Write html_file{ostatniPlik},"<kbd style='color: "+TColor+";'>"+Tekst+"</kbd>";
			CASE f_var:
				! tekst dla zmiennych
				Write html_file{ostatniPlik},"<var style='color: "+TColor+";'>"+Tekst+"</var>";
			CASE f_samp:
				! tekst dla kodu
				Write html_file{ostatniPlik},"<samp style='color: "+TColor+";'>"+Tekst+"</samp>";
			DEFAULT:
				Write html_file{ostatniPlik},"<font style='color: "+TColor+";'>";
				Write html_file{ostatniPlik},Tekst+"</font>";
		ENDTEST
	ELSE
		Write html_file{ostatniPlik},"<font style='color: "+TColor+";'>";
		Write html_file{ostatniPlik},Tekst+"</font>";
	ENDIF
		!IF NOT Present(no_br) Write html_file{ostatniPlik},"<br/>";
	ERROR
		TPWrite "error in HTML_text...";
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_maly(
		string Tekst,
		num NumFile
		\string Color)
		
		Write html_file{NumFile},"<small>"+Tekst+"</small>";
		IF Present(Color) THEN
			Write html_file{NumFile},"<small style='color: "+Color+"; '>"+Tekst+"</small>";
		ELSE
			Write html_file{NumFile},"<small>"+Tekst+"</small>";
		ENDIF
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_num(NUM wartosc\STRING Color\NUM format\switch no_br)
		VAR STRING c := "Black";
		VAR NUM f := f_tt;
		
		IF Present(Color) c := Color;
		IF Present(format) f := format;
		IF Present(no_br) THEN
			HTML_text NumToStr(wartosc,3)\Color:=c\format:=f\no_br;
		ELSE
			HTML_text NumToStr(wartosc,3)\Color:=c\format:=f;
		ENDIF
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_pos(POS wartosc\STRING Color\NUM format\switch no_br)
		VAR STRING c := "Black";
		VAR NUM f := f_tt;
		
		IF Present(Color) c := Color;
		IF Present(format) f := format;
		
		HTML_text "["\Color:=c\format:=f\no_br;
		HTML_num wartosc.x\Color:=c\format:=f\no_br;
		HTML_text ","\Color:=c\format:=f\no_br;
		HTML_num wartosc.y\Color:=c\format:=f\no_br;
		HTML_text ","\Color:=c\format:=f\no_br;
		HTML_num wartosc.z\Color:=c\format:=f\no_br;
		IF Present(no_br) THEN
			HTML_text "]"\Color:=c\format:=f\no_br;
		ELSE
			HTML_text "]"\Color:=c\format:=f;
		ENDIF
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_rot(ORIENT wartosc\STRING Color\NUM format\switch no_br)
		VAR STRING c := "Black";
		VAR NUM f := f_tt;
		
		IF Present(Color) c := Color;
		IF Present(format) f := format;
		
		HTML_text "["\Color:=c\format:=f\no_br;
		HTML_num wartosc.q1\Color:=c\format:=f\no_br;
		HTML_text ","\Color:=c\format:=f\no_br;
		HTML_num wartosc.q2\Color:=c\format:=f\no_br;
		HTML_text ","\Color:=c\format:=f\no_br;
		HTML_num wartosc.q3\Color:=c\format:=f\no_br;
		HTML_text ","\Color:=c\format:=f\no_br;
		HTML_num wartosc.q4\Color:=c\format:=f\no_br;
		IF Present(no_br) THEN
			HTML_text "]"\Color:=c\format:=f\no_br;
		ELSE
			HTML_text "]"\Color:=c\format:=f;
		ENDIF
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_pose(POSE wartosc\STRING Color\NUM format\switch no_br)
		VAR STRING c := "Black";
		VAR NUM f := f_tt;
		
		IF Present(Color) c := Color;
		IF Present(format) f := format;
		
		HTML_text "["\Color:=c\format:=f\no_br;
		HTML_pos(wartosc.trans);
		HTML_text ","\Color:=c\format:=f\no_br;
		HTML_rot(wartosc.rot);
		IF Present(no_br) THEN
			HTML_text "]"\Color:=c\format:=f\no_br;
		ELSE
			HTML_text "]"\Color:=c\format:=f;
		ENDIF
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
!   PROC main()
!     TPErase;
!     TPWrite "--> TEST RAPORTOWANIA HTML <--";
!     !   -> tworzymy plik
!     HTML_create diskhome,"raporcik.html",1\Reset;
!     !   -> zapisujemy dane
!     HTML_title "TYTUL POZIOM 3",3,1;
!     HTML_akapit "Akapit bez ustawionego koloru",1;
!     HTML_akapit "Akapit z kolorem = red"\Color:="red",1;
!     HTML_akapit "Akapit z kolorem = blue"\Color:="blue",1;
!     HTML_duzy "tekst durzy ... yellow",1\Color:="yellow";
!     HTML_maly "tekst maly  ... aqua",1\Color:="aqua";
!     HTML_pusty_w;
!     HTML_pusty_w;
!     HTML_text_nw "normalny tekst";
!     HTML_text_nw "  2spacje + normalny tekst";
!     HTML_text_nw "    4spacje + normalny tekst";
!     HTML_text_nw "        8spacje + normalny tekst";
!     HTML_pusty_w;
!     HTML_title "LISTA NUMEROWANA:",2,1;
!     HTML_num_start 1;
!     HTML_do_listy "pierwszy",1;
!     HTML_do_listy "drugi",1;
!     HTML_do_listy "trzeci",1;
!     HTML_num_end 1;
!     HTML_title "LISTA ZWYKLA:",2,1;
!     HTML_lista_start 1;
!     HTML_do_listy "pierwszy",1;
!     HTML_do_listy "drugi",1;
!     HTML_do_listy "trzeci",1;
!     HTML_llista_end 1;
!     !   -> parametry
!     HTML_table_start\Tytul:="Tabelka zparametrem POS"\AllColor:="blue",1;
!     HTML_wiersz;
!     HTML_komurki_pos [1.6002,20.64,300.53];
!     HTML_wiersz_end;
!     HTML_wiersz;
!     HTML_komurki_pos [101.45,204231,301];
!     HTML_wiersz_end;
!     HTML_wiersz;
!     HTML_komurki_pos [10.6752,2.7502,34.7602];
!     HTML_wiersz_end;
!     HTML_table_end;
!     !   -> na koniec zamykamy plik
!     HTML_close 1;
!     EXIT;
!   ENDPROC

	PROC HTML_table_pos(
		pos tablica{*},
		string Tytul,
		num NumFile)
		
		VAR num rozmiar;
		
		rozmiar:=Dim(tablica,1);
		HTML_table_start\Tytul:=Tytul,NumFile;
		FOR w FROM 1 TO rozmiar DO
			HTML_wiersz;
			HTML_komurka_num w;
			HTML_komurki_pos tablica{w};
			HTML_wiersz_end;
		ENDFOR
		HTML_table_end;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_komurki_rot(orient wartosc)
	
		HTML_komurka_num wartosc.q1;
		HTML_komurka_num wartosc.q2;
		HTML_komurka_num wartosc.q3;
		HTML_komurka_num wartosc.q4;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_komurki_pos(pos wartosc)
		HTML_komurka_num wartosc.x;
		HTML_komurka_num wartosc.y;
		HTML_komurka_num wartosc.z;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_komurka_num(num wartosc)
		HTML_komorka;
		Write html_file{ostatniPlik},""\Num:=wartosc\NoNewLine;
		HTML_komorka_end;
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_kom_pose(pose wartosc)
		HTML_komurki_pos wartosc.trans;
		HTML_komurki_rot wartosc.rot;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_table_pose(pose tablica{*},string Tytul,	num NumFile)
		
		VAR num rozmiar;
		
		rozmiar:=Dim(tablica,1);
		HTML_table_start\Tytul:=Tytul,NumFile;
		FOR w FROM 1 TO rozmiar DO
			HTML_wiersz;
			HTML_komurka_num w;
			HTML_kom_pose tablica{w};
			HTML_wiersz_end;
		ENDFOR
		HTML_table_end;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_wiersz_end()
		Write html_file{ostatniPlik},"</tr>";
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_wiersz(\NUM plikNo)
		IF Present(plikNo) ostatniPlik := plikNo;
		Write html_file{ostatniPlik},"<tr>";
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_table_end()
		Write html_file{ostatniPlik},"</table>";
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	! Otwiera komorke tabeli
	!  NUM colspan - na ile kolumn komorka jest rozciagnieta
	PROC HTML_komorka(\STRING Align\STRING bgcolor\NUM colspan)
		VAR STRING a := "left";
		VAR STRING bgc := "White";
		IF Present(Align) a := Align;
		IF Present(bgcolor) bgc := bgcolor;
		IF Present(colspan) THEN
			Write html_file{ostatniPlik},"<td bgcolor='"+ bgc +"' align='"+ a +"' colspan='"+NumToStr(colspan,0)+"'>"\NoNewLine;
		ELSE
			Write html_file{ostatniPlik},"<td bgcolor='"+ bgc +"' align='"+ a +"'>"\NoNewLine;
		ENDIF
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	! Zamyka komurke tabeli
	PROC HTML_komorka_end()
		Write html_file{ostatniPlik},"</td>";
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	! Otwiera tabele
	!  string Tytul - tytul tabeli
	!  string Tcolor - kolor tytulu
	!  string AllColor - kolor tabeli (ramek)
	PROC HTML_table_start(\string Tytul \string Tcolor \string AllColor, num NumFile)
	
		ostatniPlik:=NumFile;
		IF Present(AllColor) THEN
			Write html_file{NumFile},"<table border='1' rules='all' style='color: "+AllColor+"; >";
		ELSE
			Write html_file{NumFile},"<table border='1' rules='all'>";
		ENDIF
		IF Present(Tytul) THEN
			IF Present(Tcolor) THEN
				Write html_file{NumFile},"<caption style='color: "+Tcolor+" style='caption-side: top'>";
				Write html_file{NumFile},Tytul+"</caption>";
			ELSE
				Write html_file{NumFile},"<caption STYLE='caption-side: top'>"+Tytul+"</caption>";
			ENDIF
		ENDIF
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_pochylony(string Tekst, num NumFile)
		Write html_file{NumFile},"<em>"+Tekst+"</em>";
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_pusty_w()
		Write html_file{ostatniPlik},"<br/>";
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_akapit(string Tekst \string Color, num NumFile)
		IF Present(Color) THEN
			Write html_file{NumFile},"<p style='color: "+Color+"; '>"+Tekst+"</p>";
		ELSE
			Write html_file{NumFile},"<p>"+Tekst+"</p>";
		ENDIF
		ostatniPlik:=NumFile;
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_title_start(num Poziom, num NumFile \string Color)
		IF Present(Color) THEN
			Write html_file{NumFile},"<h"+NumToStr(Poziom,0)+" style='color: "+Color+"; '>"\NoNewLine;
		ELSE
			Write html_file{NumFile},"<h"+NumToStr(Poziom,0)+">"\NoNewLine;
		ENDIF
		ostatniPlik:=NumFile;
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_title_end(num Poziom, num NumFile)
		Write html_file{NumFile},"</h"+NumToStr(Poziom,0)+">"\NoNewLine;
		ostatniPlik:=NumFile;
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_title(string Tytul, num Poziom, num NumFile \string Color)
		IF Present(Color) THEN
			HTML_title_start Poziom, NumFile \Color:=Color;
		ELSE
			HTML_title_start Poziom, NumFile;
		ENDIF
		Write html_file{NumFile},Tytul\NoNewLine;
		HTML_title_end Poziom, NumFile;
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_pogrubiony(string Tekst, num NumFile)
		Write html_file{NumFile},"<strong>"+Tekst+"</strong>";
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_duzy(string Tekst, num NumFile \string Color)
		IF Present(Color) THEN
			Write html_file{NumFile},"<big style='color: "+Color+"; '>"+Tekst+"</big>";
		ELSE
			Write html_file{NumFile},"<big>"+Tekst+"</big>";
		ENDIF
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_terminal(string Tekst, num NumFile)
		Write html_file{NumFile},"<tt>"+Tekst+"</tt>";
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_llista_end(num NumFile)
		Write html_file{NumFile},"</ul>";
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_lista_start(num NumFile)
		Write html_file{NumFile},"<ul>";
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_tab(string Tytul, num IleTab, num NumFile)
		!
		Write html_file{NumFile},"<span style='mso-tab-count:"+NumToStr(IleTab,0)+"'>   </span>"\NoNewLine;
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_linia(num NumFile)
		Write html_file{NumFile},"<hr>";
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_num_start(num NumFile)
		Write html_file{NumFile},"<ol>";
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_do_listy(string Tekst, num NumFile)
		Write html_file{NumFile},"<li>"+Tekst+"</li>";
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	PROC HTML_num_end(num NumFile)
		Write html_file{NumFile},"</ol>";
	ERROR
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	!! Zamyka plik HTML
	!! num NumFile - numer zamykanego pliku
	PROC HTML_close(num NumFile)
		Write html_file{NumFile},"</BODY>";
		Write html_file{NumFile},"</HTML>";
		Close html_file{NumFile};
		opened{NumFile} := FALSE;
	ERROR
		IF ERRNO<>0 THEN
			TPWrite " HTML_close: wystapil error nr.: "\Num:=ERRNO;
		ENDIF
		IF ERRNO=ERR_FILEACC THEN
			opened{NumFile} := FALSE;
			return;
		ENDIF
		HTML_logErr;
		RAISE ERR_MY_ERR;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	!! Zamyka wszystkie otwarte pliki
	PROC HTML_closeAll()
		FOR i FROM 1 TO 11 DO
			! zamykamy plik gdybyl otwarty
			IF opened{i} HTML_close(i);
		ENDFOR
	ERROR
		TRYNEXT;
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	!! Otwiera/tworzy plik HTML do zapisu
	!! string Object - urzadzenie wejscia wyjscia np "HOME:" lub diskhome
	!! string File   - nazwa pliku
	!! num NumFile   - numer uchwytu w tablicy pod ktory podpiety bedzie plik 10 zarezerwowane dla LOGOW
	!! \switch Reset - otwiera plik od nowa (kasuje zawartosc)
	PROC HTML_create(string Object, string File, num NumFile \switch Reset)
		IF Present(Reset) THEN
			TPWrite "Write";
			Open Object\File:=File,html_file{NumFile}\Write;
		ELSE
			TPWrite "Append";
			Open Object\File:=File,html_file{NumFile}\Append;
		ENDIF
		opened{NumFile} := TRUE;
		ostatniPlik:=NumFile;
		!
		Write html_file{NumFile},"<HTML>";
		Write html_file{NumFile},"<HEAD>";
		Write html_file{NumFile},"<title>HTML file created by rapid module HTML</title>";
		Write html_file{NumFile},"</HEAD>";
		Write html_file{NumFile},"<BODY>";
	ERROR
		IF ERRNO<>0 THEN
			TPWrite " wystapil error nr.: "\Num:=ERRNO;
		ENDIF
		IF ERRNO=ERR_FILEOPEN THEN
			TPWrite "   zamykamy plik: " + File;
			Close html_file{NumFile};
			RETRY;
		ENDIF
	ENDPROC
	!-------------------------------------------------------------------------------------------------------
	
	! loguje stan po bledzie
	PROC HTML_logErr()
		TPWrite "=== E R R O R ===";
		TPWrite "ERRNO: "\num:=ERRNO;
		TPWrite "NumFile: "\num:=ostatniPlik;
		!
		IF ERRNO=1025 TPWrite "Zamkniety lub brak pliku LOG "\num:=ostatniPlik;
		IF NOT opened{ostatniPlik} TPWrite "Zamkniety plik LOG "\num:=ostatniPlik;
	ENDPROC
	
	PROC logOrder(byte orderNo\switch in|switch out)
		return;
	ENDPROC
	
	PROC poczTabBuf(\switch in|switch out|switch conf)
		IF NOT logowanie RETURN;
		IF PRESENT (in)
		HTML_table_start \Tytul:="IN/OUT BUFFER",10;
		IF PRESENT (out)
		HTML_table_start \Tytul:="IN/OUT BUFFER",10;
		IF PRESENT (conf)
		HTML_table_start \Tytul:="CONFIRMATION",10;
		
		Write html_file{10},"<tr><th>first</th>"\NoNewLine;
		Write html_file{10},"<th>type</th>"\NoNewLine;
		Write html_file{10},"<th>real</th>"\NoNewLine;
		Write html_file{10},"<th>data bytes</th>"\NoNewLine;
		Write html_file{10},"<th>last</th></tr>";
	ENDPROC
	!--------------------------------------------------------------------------
	
	PROC addTabSection(STRING sec)
		IF NOT logowanie RETURN;
		HTML_wiersz\plikNo:=10;
		HTML_komorka \Align:="Center"\colspan:=5;
		Write html_file{10},sec\NoNewLine;
		HTML_text ","\format:=f_b\no_br;
		HTML_komorka_end;
		HTML_wiersz_end;
	ENDPROC
	!--------------------------------------------------------------------------
	
	PROC addTabBuf(STRING name, STRING data, NUM start, NUM ile\switch in|switch out|switch conf)
		VAR BYTE b;
		VAR STRING bc;
		
		IF NOT logowanie RETURN;
		bc := "White";
		IF Present(out) THEN
			bc := "GreenYellow";
		ENDIF
		IF Present(in) THEN
			bc := "LightPink";
		ENDIF
		ostatniPlik := 10;
		HTML_wiersz;
		! first
		HTML_komorka\bgcolor:=bc;
		HTML_text NumToStr(start,0)\Color:="Gray"\no_br;
		HTML_komorka_end;
		! typ
		HTML_komorka\bgcolor:=bc;
		Write html_file{ostatniPlik},name\NoNewLine;
		HTML_komorka_end;
		! wartosc
		HTML_komorka\bgcolor:=bc;
		Write html_file{ostatniPlik},data\NoNewLine;
		HTML_komorka_end;
		! bajty
		HTML_komorka\bgcolor:=bc;
		FOR i FROM start TO (start+ile-1) DO
			IF Present(in) THEN
!PF          UnpackRawBytes inBuffer{inBufferNo}, i, b \Hex1;
			ELSEIF Present(out) THEN
!PF          UnpackRawBytes outBuffer{outBufferNo}, i, b \Hex1;
			ELSEIF Present(conf) THEN
!PF          UnpackRawBytes confBuffer, i, b \Hex1;
			ENDIF
			Write html_file{ostatniPlik},ByteToStr(b)+"; "\NoNewLine;
		ENDFOR
		HTML_komorka_end;
		! last
		HTML_komorka\bgcolor:=bc;
		HTML_text NumToStr((start+ile-1),0)\Color:="Gray"\no_br;
		HTML_komorka_end;
		!
		HTML_wiersz_end;
	ENDPROC
	!--------------------------------------------------------------------------
	
	PROC konTabBuf()
		IF NOT logowanie RETURN;
		HTML_table_end;
	ENDPROC
	
ENDMODULE

