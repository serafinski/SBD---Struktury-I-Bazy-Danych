--1
--Przy pomocy kursora przejrzyj wszystkich pracowników i zmodyfikuj wynagrodzenia tak, aby osoby zarabiające mniej niż 1000 miały zwiększone wynagrodzenie o 10%, natomiast osoby zarabiające powyżej 1500 miały zmniejszone wynagrodzenie o 10%. Wypisz na ekran każdą wprowadzoną zmianę.
DECLARE MODSAL CURSOR FOR
SELECT EMPNO, ENAME, SAL FROM EMP;

DECLARE @EMPNO INT, @ENAME VARCHAR(20), @SAL MONEY;
OPEN MODSAL;

FETCH NEXT FROM MODSAL INTO @EMPNO, @ENAME, @SAL;
WHILE @@FETCH_STATUS=0
BEGIN
    IF @SAL>1000 AND @SAL<1500
        BEGIN
            PRINT @ENAME + ' NIE DOSTAL ZMIANY PENSJI';
        end
    ELSE
        BEGIN
        IF @SAL<1000
            BEGIN
                SET @SAL = @SAL + (@SAL*0.1);
                UPDATE EMP SET SAL = @SAL WHERE EMPNO=@EMPNO;
                PRINT @ENAME + ' ZARABIA PO PODWYZCE ' + CAST(@SAL AS VARCHAR);
            end
        IF @SAL>1500
            BEGIN
                SET @SAL = @SAL - (@SAL*0.1);
                UPDATE EMP SET SAL = @SAL WHERE EMPNO=@EMPNO;
                PRINT @ENAME + ' ZARABIA PO OBNIZCE ' + CAST(@SAL AS VARCHAR);
            end
        END
FETCH NEXT FROM MODSAL INTO @EMPNO, @ENAME, @SAL;
END;
CLOSE MODSAL;
DEALLOCATE MODSAL;

--2
--Przerób kod z zadania 1 na procedurę tak, aby wartości zarobków (1000 i 1500) nie były stałe, tylko były parametrami procedury.
CREATE OR ALTER PROCEDURE MODSALPROC
    @MINSAL INT, @MAXSAL INT
AS
BEGIN

    DECLARE MODSAL CURSOR FOR
    SELECT EMPNO, ENAME, SAL FROM EMP;

    DECLARE @EMPNO INT, @ENAME VARCHAR(20), @SAL MONEY;
    OPEN MODSAL;

    FETCH NEXT FROM MODSAL INTO @EMPNO, @ENAME, @SAL;
    WHILE @@FETCH_STATUS=0
    BEGIN
        IF @SAL>@MINSAL AND @MAXSAL<1500
            BEGIN
                PRINT @ENAME + ' NIE DOSTAL ZMIANY PENSJI ';
            end
        ELSE
            BEGIN
            IF @SAL<@MINSAL
                BEGIN
                    SET @SAL = @SAL + (@SAL*0.1);
                    UPDATE EMP SET SAL = @SAL WHERE EMPNO=@EMPNO;
                    PRINT @ENAME + ' ZARABIA PO PODWYZCE ' + CAST(@SAL AS VARCHAR);
                end
            IF @SAL>@MAXSAL
                BEGIN
                    SET @SAL = @SAL - (@SAL*0.1);
                    UPDATE EMP SET SAL = @SAL WHERE EMPNO=@EMPNO;
                    PRINT @ENAME + ' ZARABIA PO OBNIZCE ' + CAST(@SAL AS VARCHAR);
                end
            END
    FETCH NEXT FROM MODSAL INTO @EMPNO, @ENAME, @SAL;
    END;
    CLOSE MODSAL;
    DEALLOCATE MODSAL;
END;
EXEC MODSALPROC 1000,1500;

--3
--W procedurze sprawdź średnią wartość zarobków z tabeli EMP z działu określonego parametrem procedury. Następnie należy dać prowizję (comm) tym pracownikom tego działu, którzy zarabiają poniżej średniej. Prowizja powinna wynosić 5% ich miesięcznego wynagrodzenia.
CREATE OR ALTER PROCEDURE MODPROV
    @DEPTNO INT
AS
    BEGIN
        IF NOT EXISTS(SELECT DEPTNO FROM EMP WHERE DEPTNO=@DEPTNO)
            THROW 50000,'DANY DEPARTAMENT NIE ISTNIEJE',1;
        DECLARE @AVGSAL INT = (SELECT AVG(SAL) FROM EMP WHERE DEPTNO = @DEPTNO);



        DECLARE CHECKAVGSAL CURSOR FOR
        SELECT EMPNO, ENAME, SAL, COMM FROM EMP WHERE DEPTNO = @DEPTNO;

        DECLARE @EMPNO INT, @ENAME VARCHAR(20), @SAL MONEY, @COMM MONEY;

        OPEN CHECKAVGSAL;
        FETCH NEXT FROM CHECKAVGSAL INTO @EMPNO, @ENAME, @SAL, @COMM;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            IF @SAL < @AVGSAL
                BEGIN
                SET @COMM = 0.05*@SAL
                UPDATE EMP SET COMM = @COMM WHERE EMPNO = @EMPNO;
                PRINT @ENAME + ' DOSTAL COMM WYNOSZACA 5% JEGO PENSJI!'
                END
            ELSE
                BEGIN
                PRINT @ENAME + ' NIE DOSTAL COMM!'
                END

        FETCH NEXT FROM CHECKAVGSAL INTO @EMPNO, @ENAME, @SAL, @COMM;
        end
        CLOSE CHECKAVGSAL
        DEALLOCATE CHECKAVGSAL
end;
EXEC MODPROV 20

--4
--(bez kursora) Utwórz tabelę Magazyn (IdPozycji, Nazwa, Ilosc) zawierającą ilości poszczególnych towarów w magazynie i wstaw do niej kilka przykładowych rekordów. W bloku Transact-SQL sprawdź, którego artykułu jest najwięcej w magazynie i zmniejsz ilość tego artykułu o 5 (jeśli stan jest większy lub równy 5, w przeciwnym wypadku zgłoś błąd).
CREATE TABLE MAGAZYN(
    IDPOZYCJI INTEGER PRIMARY KEY,
    NAZWA VARCHAR(20),
    ILOSC INTEGER
)

INSERT INTO MAGAZYN(IDPOZYCJI, NAZWA, ILOSC)
VALUES(1,'JABLKA',400);

INSERT INTO MAGAZYN(IDPOZYCJI, NAZWA, ILOSC)
VALUES(2,'GRUSZKI',300);

INSERT INTO MAGAZYN(IDPOZYCJI, NAZWA, ILOSC)
VALUES(3,'BANANY',200);

INSERT INTO MAGAZYN(IDPOZYCJI, NAZWA, ILOSC)
VALUES(4,'AWOKADO',5);


-- UPDATE MAGAZYN SET ILOSC = 400
-- WHERE IDPOZYCJI = 1;
-- UPDATE MAGAZYN SET ILOSC = 300
-- WHERE IDPOZYCJI = 2;
-- UPDATE MAGAZYN SET ILOSC = 200
-- WHERE IDPOZYCJI = 3;
-- UPDATE MAGAZYN SET ILOSC = 5
-- WHERE IDPOZYCJI = 4;



CREATE PROCEDURE DECT5
AS
    BEGIN
        DECLARE @ILOSC INT;
        SET @ILOSC = 5;
        DECLARE @IDMAX INT;
        SET @IDMAX = (SELECT IDPOZYCJI FROM MAGAZYN WHERE ILOSC = (SELECT MAX(ILOSC) FROM MAGAZYN));

        IF (SELECT ILOSC FROM MAGAZYN WHERE IDPOZYCJI=@IDMAX) < @ILOSC
            BEGIN
                PRINT 'BLAD - PODANA WARTOSC PRZEWYZSZA ILOSC TOWARU O MAKSYMALNEJ ILOSCI'
            END
        ELSE
            BEGIN
                UPDATE MAGAZYN
                SET ILOSC = ILOSC-@ILOSC
                WHERE IDPOZYCJI = @IDMAX;
            END
    END
EXEC DECT5

--5
--Przerób kod z zadania 4 na procedurę, której będziemy mogli podać wartość, o którą zmniejszamy stan (zamiast wpisanego „na sztywno” 5).
CREATE PROCEDURE DECREMENTVAL
    @ILOSC INT
AS
    BEGIN
        DECLARE @IDMAX INT;
        SET @IDMAX = (SELECT IDPOZYCJI FROM MAGAZYN WHERE ILOSC = (SELECT MAX(ILOSC) FROM MAGAZYN));

        IF (SELECT ILOSC FROM MAGAZYN WHERE IDPOZYCJI=@IDMAX) < @ILOSC
            BEGIN
                PRINT 'BLAD - PODANA WARTOSC PRZEWYZSZA ILOSC TOWARU O MAKSYMALNEJ ILOSCI'
            END
        ELSE
            BEGIN
                UPDATE MAGAZYN
                SET ILOSC = ILOSC-@ILOSC
                WHERE IDPOZYCJI = @IDMAX;
            END
    END
EXEC DECREMENTVAL 250
