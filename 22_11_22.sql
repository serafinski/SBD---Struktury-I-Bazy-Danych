--1
--Utwórz wyzwalacz, który nie pozwoli usunąć rekordu z tabeli Emp.
CREATE TRIGGER DONTDELETE
ON EMP
FOR DELETE
AS
ROLLBACK;
--2
--Utwórz wyzwalacz, który przy wstawianiu pracownika do tabeli Emp,
--wstawi prowizję równą 0, jeśli prowizja była pusta.
--Uwaga: Zadanie da się wykonać bez użycia wyzwalaczy przy pomocy DEFAULT.
--Użyjmy jednak wyzwalacza w celach treningowych.
CREATE TRIGGER COMM0
ON EMP
FOR INSERT
AS
BEGIN
    DECLARE @BASECOMM MONEY = 0;
    IF (SELECT COMM FROM inserted) IS NULL
        BEGIN
           UPDATE EMP SET COMM = @BASECOMM WHERE EMPNO = (SELECT EMPNO FROM inserted);
        END
END
--3
--Utwórz wyzwalacz, który przy wstawianiu lub modyfikowaniu danych w tabeli Emp
--sprawdzi czy nowe zarobki (wstawiane lub modyfikowane) są większe niż 1000.
--W przeciwnym przypadku wyzwalacz powinien zgłosić błąd i nie dopuścić do
--wstawienia rekordu.
--Uwaga: Ten sam efekt można uzyskać łatwiej przy pomocy więzów spójności typu CHECK.
--Użyjmy wyzwalacza w celach treningowych.
CREATE TRIGGER CHECKSAL
ON EMP
FOR INSERT, UPDATE
AS
BEGIN
   IF EXISTS (SELECT SAL FROM inserted WHERE SAL <1000)
    BEGIN
       THROW 50001, 'NIEDOPUSZCZALNA WARTOSC SAL!',2;
    END
END
--4
--Utwórz tabelę budzet:
--CREATE TABLE budzet (wartosc INT NOT NULL)
--W tabeli tej będzie przechowywana łączna wartość wynagrodzenia wszystkich pracowników.
--Tabela będzie zawsze zawierała jeden wiersz.
--Należy najpierw obliczyć początkową wartość zarobków:
--INSERT INTO budzet (wartosc) SELECT SUM(sal) FROM emp
--Utwórz wyzwalacz, który będzie pilnował, aby wartość w tabeli budzet była zawsze aktualna,
--a więc przy wszystkich operacjach aktualizujących tabelę emp (INSERT, UPDATE, DELETE),
--wyzwalacz będzie aktualizował wpis w tabeli budżet
CREATE TABLE BUDZET (WARTOSC INT NOT NULL);

INSERT INTO BUDZET(WARTOSC)
SELECT SUM(SAL) FROM EMP;

CREATE TRIGGER CONTROL
ON EMP
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    UPDATE BUDZET SET WARTOSC = (SELECT SUM(SAL) FROM EMP);
END
--5
--Napisz wyzwalacz, który nie pozwoli modyfikować nazw działów w tabeli dept.
--Powinno być jednak możliwe wstawianie nowych działów.
CREATE TRIGGER NOTMODFNAMES
ON DEPT
FOR UPDATE
AS
BEGIN
    DECLARE @NAME VARCHAR = (SELECT DNAME FROM deleted);
    DECLARE @INSERTEDNAME VARCHAR = (SELECT DNAME FROM inserted)

    IF (@NAME!=@INSERTEDNAME)
    BEGIN
       THROW 50002, 'NIEDOPUSZCZALNA WARTOSC DNAME!',2;
    END
END;
--6
--Napisz jeden wyzwalacz, który:
--Nie pozwoli usunąć pracownika, którego pensja jest większa od 0.
--Nie pozwoli zmienić nazwiska pracownika.
--Nie pozwoli wstawić pracownika, który już istnieje (sprawdzając po nazwisku).
CREATE TRIGGER ZAD6
ON EMP
FOR DELETE, UPDATE, INSERT
AS
BEGIN
        -- update jest wtedy kiedy jest inserted i deleted
        -- insert jest tylko jesli inserted
        -- delete jest tylko jesli deleted
        IF EXISTS(SELECT SAL FROM EMP WHERE SAL > 0)
            BEGIN
                ROLLBACK
            END

        IF EXISTS(SELECT ENAME FROM inserted) AND EXISTS(SELECT ENAME FROM deleted)
            BEGIN
                ROLLBACK
            END
        DECLARE @POPRZEDNIA VARCHAR = (SELECT ENAME FROM inserted);
        DECLARE @TERAZ VARCHAR = (SELECT ENAME FROM deleted);
        IF @POPRZEDNIA != @TERAZ
            BEGIN
                ROLLBACK;
            END
    ROLLBACK;
END
--7
--Napisz wyzwalacz, który:
--Nie pozwoli zmniejszać pensji.
--Nie pozwoli usuwać pracowników.
CREATE TRIGGER ZAD7
ON EMP
FOR UPDATE,DELETE
AS
BEGIN
    -- update jest wtedy kiedy jest inserted i deleted
    -- delete jest tylko jesli deleted
    DECLARE @POPRZEDNIA VARCHAR = (SELECT SAL FROM inserted);
    DECLARE @TERAZ VARCHAR = (SELECT SAL FROM deleted);
    IF @POPRZEDNIA<@TERAZ
        BEGIN
           ROLLBACK
        END
    IF EXISTS(SELECT ENAME FROM deleted)
        BEGIN
           ROLLBACK
        END
END