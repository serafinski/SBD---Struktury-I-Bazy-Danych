--/SKŁADNIA ORACLE/--

--1
--Wypisz gości wraz z liczbą dokonanych przez nich rezerwacji.
--Nie wypisuj informacji o gościach, którzy złożyli tylko jedną rezerwację.
SELECT IMIE, Nazwisko, COUNT(*) AS ILOSC FROM GOSC
JOIN REZERWACJA ON Gosc.IdGosc = Rezerwacja.IdGosc
GROUP BY IMIE, Nazwisko
HAVING COUNT(*) > 1;

--2
--Wypisz pokoje o największej liczbie miejsc.
SELECT NrPokoju FROM POKOJ
WHERE Liczba_miejsc = (SELECT MAX(Liczba_miejsc) FROM Pokoj);

--3
--Dla każdego pokoju wypisz, kiedy był ostatnio wynajmowany.
SELECT * FROM Rezerwacja R
WHERE R.DataOd =
(SELECT MAX(DATAOD) FROM Rezerwacja R2 WHERE R2.NrPokoju = R.NrPokoju);

--4
--Wypisz liczbę rezerwacji dla każdego pokoju.
--Nie wypisuj pokoi, które były rezerwowane tylko raz oraz pokoi z
-- kategorii „luksusowy”.
SELECT R.NrPokoju, COUNT(*) AS LICZBA_REZERWACJI FROM Rezerwacja R
JOIN Pokoj P on R.NrPokoju = P.NrPokoju
JOIN Kategoria K on P.IdKategoria = K.IdKategoria
WHERE K.NAZWA = 'LUKSUSOWY'
GROUP BY R.NrPokoju
HAVING COUNT(*) > 1;

--5
--Podaj dane (imię, nazwisko, numer pokoju) najnowszej rezerwacji.
SELECT G.Imie, G.Nazwisko, R.NrPokoju FROM Rezerwacja R
JOIN Gosc G on R.IdGosc = G.IdGosc
WHERE R.DataOd = (SELECT MAX(DataOd) FROM Rezerwacja);

--6 (CHYBA OK?)
--Wypisz dane pokoju, który nie był nigdy wynajmowany
SELECT P.NrPokoju, P.IdKategoria, P.Liczba_miejsc FROM Pokoj P
LEFT JOIN Rezerwacja R2 on P.NrPokoju = R2.NrPokoju
WHERE DataOd IS NULL;

--ALTERNATYWNIE
SELECT NRPOKOJU FROM POKOJ
WHERE NRPOKOJU NOT IN (SELECT NRPOKOJU FROM REZERWACJA);

--7
--Używając operatora NOT EXISTS wypisz gości, którzy nigdy nie wynajmowali
-- pokoju luksusowego.
SELECT * FROM Gosc G
WHERE NOT EXISTS (SELECT * FROM Rezerwacja R
                          JOIN Pokoj P on R.NrPokoju = P.NrPokoju
                          JOIN Kategoria K on K.IdKategoria = P.IdKategoria
                          WHERE K.NAZWA = 'Luksusowy' AND R.IdGosc = G.IdGosc);

--8
--W jednym zapytaniu wypisz gości, którzy wynajmowali pokój 101
-- (imię, nazwisko, data rezerwacji) oraz gości, którzy nigdy nie wynajmowali
-- żadnego pokoju (imię, nazwisko, ‘brak’).
SELECT G.IMIE, G.NAZWISKO, NVL(TO_CHAR(DATAOD),'brak') AS DATA_REZERWACJI FROM GOSC G
JOIN REZERWACJA R on G.IDGOSC = R.IDGOSC
WHERE NRPOKOJU = 101
UNION
SELECT G.IMIE, G.NAZWISKO, 'BRAK' FROM GOSC G
LEFT JOIN REZERWACJA R2 on G.IDGOSC = R2.IDGOSC
WHERE R2.IDREZERWACJA IS NULL;


--9
--Znajdź kategorię, w której liczba pokoi jest największa.
SELECT NAZWA, COUNT(*) AS LICZBA_POKOI FROM KATEGORIA
JOIN POKOJ P on KATEGORIA.IDKATEGORIA = P.IDKATEGORIA
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM KATEGORIA
                  JOIN POKOJ P2 on KATEGORIA.IDKATEGORIA = P2.IDKATEGORIA
                  GROUP BY NAZWA)
GROUP BY NAZWA;

--10
--Dla każdej kategorii podaj pokój o największej liczbie miejsc.
SELECT NRPOKOJU,NAZWA,LICZBA_MIEJSC FROM POKOJ
JOIN KATEGORIA K on K.IDKATEGORIA = POKOJ.IDKATEGORIA
WHERE LICZBA_MIEJSC = (SELECT MAX(LICZBA_MIEJSC) FROM POKOJ
JOIN KATEGORIA K2 on K2.IDKATEGORIA = POKOJ.IDKATEGORIA
WHERE K.IDKATEGORIA = K2.IDKATEGORIA);