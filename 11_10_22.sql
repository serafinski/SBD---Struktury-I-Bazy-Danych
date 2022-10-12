--1
SELECT * FROM GOSC ORDER BY IMIE,NAZWISKO;
--2
SELECT DISTINCT Procent_rabatu FROM GOSC ORDER BY Procent_rabatu DESC;
--3
SELECT * FROM Rezerwacja JOIN GOSC ON Rezerwacja.IdGosc = Gosc.IdGosc
WHERE IMIE = 'FERDYNAND' AND NAZWISKO = 'KIEPSKI';
--4
SELECT Imie, Nazwisko, NrPokoju FROM Rezerwacja JOIN GOSC ON Rezerwacja.IdGosc = Gosc.IdGosc
WHERE (NAZWISKO LIKE 'K%' OR NAZWISKO LIKE 'L%') AND YEAR(DataOD)=2008;
--5
SELECT POKOJ.NrPokoju FROM Pokoj
JOIN REZERWACJA ON Pokoj.NrPokoju = Rezerwacja.NrPokoju
JOIN GOSC ON Rezerwacja.IdGosc = Gosc.IdGosc
WHERE IMIE = 'ANDRZEJ' AND NAZWISKO = 'NOWAK';
--6
SELECT NAZWA, COUNT(*) AS LICZBA_POKOI FROM Kategoria
JOIN POKOJ ON Kategoria.IdKategoria = Pokoj.IdKategoria
GROUP BY Kategoria.Nazwa, Kategoria.Cena;
--7
SELECT * FROM GOSC
LEFT JOIN Rezerwacja ON Gosc.IdGosc = Rezerwacja.IdGosc;
--8
SELECT * FROM GOSC
JOIN REZERWACJA ON Gosc.IdGosc = Rezerwacja.IdGosc
WHERE NrPokoju = 101 AND Zaplacona = 'true';
--9
SELECT NAZWISKO+IMIE AS NAZWISKO_IMIE, DATAOD, DATADO, POKOJ.NRPOKOJU, NAZWA FROM Gosc
JOIN REZERWACJA ON Gosc.IdGosc = Rezerwacja.IdGosc
JOIN POKOJ ON Rezerwacja.NrPokoju = Pokoj.NrPokoju
JOIN KATEGORIA ON Pokoj.IdKategoria = Kategoria.IdKategoria;
--10
SELECT * FROM GOSC
JOIN REZERWACJA ON Gosc.IdGosc = Rezerwacja.IdGosc
JOIN POKOJ ON Rezerwacja.NrPokoju = Pokoj.NrPokoju
WHERE (Pokoj.NrPokoju = 101 AND Nazwisko LIKE 'K%') OR
      (POKOJ.NrPokoju = 201 AND NAZWISKO LIKE 'P%');
--11
SELECT * FROM GOSC
JOIN REZERWACJA ON Gosc.IdGosc = Rezerwacja.IdGosc
WHERE Procent_rabatu IS NULL AND IdRezerwacja IS NOT NULL;
--12
SELECT Imie, Nazwisko, DataOd, DataDo FROM Gosc
JOIN REZERWACJA ON Gosc.IdGosc = Rezerwacja.IdGosc
WHERE NrPokoju =101 OR NrPokoju=102 OR NrPokoju=103 OR NrPokoju=104;
--13
SELECT * FROM Kategoria
WHERE Cena BETWEEN 10 AND 100;
--14
SELECT Imie+Nazwisko AS DŁUŻNIK FROM Gosc
JOIN REZERWACJA ON Gosc.IdGosc = Rezerwacja.IdGosc
WHERE Zaplacona = 0
ORDER BY Nazwisko, IMIE;
--15
SELECT COUNT(*) AS ZAPLACONE FROM REZERWACJA
WHERE Zaplacona = 1;
--16
SELECT COUNT(*) AS ILOSC_2009 FROM Rezerwacja
WHERE YEAR(DATAOD)=2009;
--17
INSERT INTO Gosc(IdGosc, Imie, Nazwisko, Procent_rabatu)
VALUES (17,'TOMASZ','SERAFINSKI',50);

INSERT INTO Rezerwacja(IdRezerwacja, DataOd, DataDo, IdGosc, NrPokoju, Zaplacona)
VALUES (21,'2022-09-22','2022-10-03',17,101,1);
--18
UPDATE Rezerwacja
SET DataOd = '2022-05-30'
WHERE IdRezerwacja = 22;
--19
DELETE FROM REZERWACJA
WHERE IdRezerwacja =22;