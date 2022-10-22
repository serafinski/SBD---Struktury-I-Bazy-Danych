--/SKŁADNIA MICROSOFT SQL SERVER/--

--1
--Wypisz wszystkich klientów hotelu w kolejności alfabetycznej (sortując po nazwisku i imieniu).
SELECT * FROM GOSC ORDER BY IMIE,NAZWISKO;
--2
--Podaj bez powtórzeń wszystkie występujące w tabeli wartości rabatu posortowane malejąco.
SELECT DISTINCT Procent_rabatu FROM GOSC ORDER BY Procent_rabatu DESC;
--3
--Wypisz wszystkie rezerwacje Ferdynanda Kiepskiego
SELECT * FROM Rezerwacja JOIN GOSC ON Rezerwacja.IdGosc = Gosc.IdGosc
WHERE IMIE = 'FERDYNAND' AND NAZWISKO = 'KIEPSKI';
--4
--Wypisz rezerwacje z 2008 roku klientów, których nazwisko zaczyna się na literę „K” lub „L”. Podaj imię, nazwisko oraz numer pokoju.
SELECT Imie, Nazwisko, NrPokoju FROM Rezerwacja JOIN GOSC ON Rezerwacja.IdGosc = Gosc.IdGosc
WHERE (NAZWISKO LIKE 'K%' OR NAZWISKO LIKE 'L%') AND YEAR(DataOD)=2008;
--5
--Wypisz numery pokoi wynajmowanych przez Andrzeja Nowaka.
SELECT POKOJ.NrPokoju FROM Pokoj
JOIN REZERWACJA ON Pokoj.NrPokoju = Rezerwacja.NrPokoju
JOIN GOSC ON Rezerwacja.IdGosc = Gosc.IdGosc
WHERE IMIE = 'ANDRZEJ' AND NAZWISKO = 'NOWAK';
--6
--Podaj liczbę pokoi w każdej kategorii.
SELECT NAZWA, COUNT(*) AS LICZBA_POKOI FROM Kategoria
JOIN POKOJ ON Kategoria.IdKategoria = Pokoj.IdKategoria
GROUP BY Kategoria.Nazwa, Kategoria.Cena;
--7
--Podaj dane klientów oraz ich rezerwacji tak, aby klient został wypisany nawet, jeśli nigdy nie rezerwował pokoju.
SELECT * FROM GOSC
LEFT JOIN Rezerwacja ON Gosc.IdGosc = Rezerwacja.IdGosc;
--8
--Wypisz klientów, którzy spali w pokoju 101 i zapłacili.
SELECT * FROM GOSC
JOIN REZERWACJA ON Gosc.IdGosc = Rezerwacja.IdGosc
WHERE NrPokoju = 101 AND Zaplacona = 'true';
--9
--Wypisz dane w postaci: Nazwisko i imię (w jednej kolumnie), DataOd, DataDo, NrPokoju, nazwa kategori
SELECT NAZWISKO+IMIE AS NAZWISKO_IMIE, DATAOD, DATADO, POKOJ.NRPOKOJU, NAZWA FROM Gosc
JOIN REZERWACJA ON Gosc.IdGosc = Rezerwacja.IdGosc
JOIN POKOJ ON Rezerwacja.NrPokoju = Pokoj.NrPokoju
JOIN KATEGORIA ON Pokoj.IdKategoria = Kategoria.IdKategoria;
--10
--Wypisz w jednym zapytaniu gości, którzy zarezerwowali pokój 101, mających nazwisko na literę „K” oraz tych, którzy zarezerwowali pokój 201, ale mających nazwisko na literę „P”.
SELECT * FROM GOSC
JOIN REZERWACJA ON Gosc.IdGosc = Rezerwacja.IdGosc
JOIN POKOJ ON Rezerwacja.NrPokoju = Pokoj.NrPokoju
WHERE (Pokoj.NrPokoju = 101 AND Nazwisko LIKE 'K%') OR
      (POKOJ.NrPokoju = 201 AND NAZWISKO LIKE 'P%');
--11
--Wypisz dane klientów, którzy nie mają rabatu (NULL) i wynajęli jakikolwiek pokój.
SELECT * FROM GOSC
JOIN REZERWACJA ON Gosc.IdGosc = Rezerwacja.IdGosc
WHERE Procent_rabatu IS NULL AND IdRezerwacja IS NOT NULL;
--12
--Wypisz dane wszystkich rezerwacji pokoi: 101, 102, 103, 104. Podaj imię, nazwisko i datę.
SELECT Imie, Nazwisko, DataOd, DataDo FROM Gosc
JOIN REZERWACJA ON Gosc.IdGosc = Rezerwacja.IdGosc
WHERE NrPokoju =101 OR NrPokoju=102 OR NrPokoju=103 OR NrPokoju=104;
--13
--Podaj kategorie z przedziału cenowego <10,100>.
SELECT * FROM Kategoria
WHERE Cena BETWEEN 10 AND 100;
--14
--Wypisz imiona i nazwiska (w jednej kolumnie) klientów, którzy zalegają z płatnościami (pole „zaplacona” = 0). Kolumnie z danymi klienta nadaj etykietę „dłużnik”. Posortuj w pierwszej kolejności po nazwiskach, a w drugiej po imionach
SELECT Imie+Nazwisko AS DŁUŻNIK FROM Gosc
JOIN REZERWACJA ON Gosc.IdGosc = Rezerwacja.IdGosc
WHERE Zaplacona = 0
ORDER BY Nazwisko, IMIE;
--15
--Podaj, ile jest łącznie rezerwacji zapłaconych.
SELECT COUNT(*) AS ZAPLACONE FROM REZERWACJA
WHERE Zaplacona = 1;
--16
--Wypisz, ile rezerwacji zostało złożonych w 2009 roku.
SELECT COUNT(*) AS ILOSC_2009 FROM Rezerwacja
WHERE YEAR(DATAOD)=2009;
--17
--Wstaw do bazy danych nowego gościa (wymyśl dowolne dane) oraz rezerwację dla niego.
INSERT INTO Gosc(IdGosc, Imie, Nazwisko, Procent_rabatu)
VALUES (17,'TOMASZ','SERAFINSKI',50);
INSERT INTO Rezerwacja(IdRezerwacja, DataOd, DataDo, IdGosc, NrPokoju, Zaplacona)
VALUES (21,'2022-09-22','2022-10-03',17,101,1);
--18
--Zmień dowolnie datę zakończenia wybranej rezerwacji.
UPDATE Rezerwacja
SET DataOd = '2022-05-30'
WHERE IdRezerwacja = 22;
--19
--Usuń wybraną rezerwację.
DELETE FROM REZERWACJA
WHERE IdRezerwacja =22;