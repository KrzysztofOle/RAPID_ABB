# RAPID_ABB — biblioteka modułów ABB RAPID

Repozytorium zawiera źródła **RAPID** dla robotów ABB, w tym moduły `.mod` i systemowe `.sys`. Przykładowe obszary:
- `CommTCP.mod` — komunikacja TCP,
- `CalibTCP.mod`, `CalibFastTCP.mod` — kalibracja TCP,
- `WobjTools.mod` — narzędzia do obiektów roboczych,
- `SafeMoveSync.mod` oraz pliki `.sys` — elementy systemowe/konfiguracyjne,
- pozostałe biblioteki procesowe, efekktorów i spawania.

## Narzędzia i uruchomienie
Do przeglądu i kwalifikacji wymagane jest środowisko zgodne z robotem ABB, np. **RobotStudio** / odpowiednia wersja RobotWare. W repozytorium brak niezależnego builda i testów uruchamianych poza kontrolerem.

Nie wgrywać modułów bez zgodności wersji, mapowania I/O, zależności modułów, backupu kontrolera i weryfikacji safety. Kod RAPID może uruchamiać ruch robota i urządzenia technologiczne.

## Status
Biblioteka historyczna — aktualna kompatybilność sprzętowa niezweryfikowana.
