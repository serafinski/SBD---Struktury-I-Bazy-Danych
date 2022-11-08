--1
/*
 Napisz prosty program w Transact-SQL. Zadeklaruj zmienną, przypisz na tą zmienną liczbę rekordów w tabeli Emp (lub jakiejkolwiek innej) i wypisz uzyskany wynik używając instrukcji PRINT, w postaci napisu np. "W tabeli jest 10 osób".
 */
DECLARE @ILE INT =(SELECT COUNT(*) FROM EMP)
PRINT 'W tabeli jest ' + CAST(@ILE AS VARCHAR) + ' OSOB';
--2
/*
 Używając Transact-SQL, policz liczbę pracowników z tabeli EMP. Jeśli liczba jest mniejsza niż 16, wstaw pracownika Kowalskiego i wypisz komunikat. W przeciwnym przypadku wypisz komunikat informujący o tym, że nie wstawiono danych.
 */
DECLARE @INFO VARCHAR(50);
IF @ILE < 16
    BEGIN
        INSERT INTO EMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
        VALUES (15,'KOWALSKI','CLERK',7902,SYSDATETIME(),800,NULL,20);
        SET @INFO = 'WSTAWIONO KOWALSKIEGO';
    end
ELSE
    SET @INFO = 'NIE WSTAWIONO DANYCH';
PRINT @INFO;

--3
/*
 Napisz procedurę zwracającą pracowników, którzy zarabiają więcej niż wartość zadana parametrem procedury.
 */
CREATE PROCEDURE return_higher_than @val INT
AS
BEGIN
SELECT * FROM EMP
WHERE SAL>@VAL
END;
EXEC return_higher_than 1100;
--4
/*
Napisz procedurę służącą do wstawiania działów do tabeli Dept. Procedura będzie pobierać jako parametry: nr_działu, nazwę i lokalizację. Należy sprawdzić, czy dział o takiej nazwie lub lokalizacji już istnieje. Jeżeli istnieje, to nie wstawiamy nowego rekordu.
*/
CREATE PROCEDURE add_dept
    @nr_dzialu INT, @nazwa varchar(50),@lokalizacja varchar(50)
AS
    BEGIN
        if exists(SELECT * from DEPT where DNAME = @nazwa OR LOC = @lokalizacja)
        print ('Podany dzial istnieje')
        else
            INSERT INTO DEPT(DEPTNO, DNAME, LOC)
            VALUES (@nr_dzialu,@nazwa,@lokalizacja)
    end;
EXEC add_dept 50,'IT','WARSAW';

--5
/*
 Napisz procedurę umożliwiającą użytkownikowi wprowadzanie nowych pracowników do tabeli EMP. Jako parametry będziemy podawać nazwisko i nr działu zatrudnianego pracownika. Procedura powinna wprowadzając nowy rekord sprawdzić, czy wprowadzany dział istnieje (jeżeli nie, to należy zgłosić błąd) oraz obliczyć mu pensję równą minimalnemu zarobkowi w tym dziale. EMPNO nowego pracownika powinno zostać wyliczone jako najwyższa istniejąca wartość w tabeli + 1.
 */
CREATE PROCEDURE add_emp
    @nazwisko varchar(50),@nr_dzialu INT
AS
    BEGIN
        DECLARE @min_sal INT = (SELECT MIN(SAL) FROM EMP WHERE DEPTNO = @nr_dzialu)
        DECLARE @NR_PRAC INT = (SELECT MAX(EMPNO) FROM EMP)+1
        IF NOT exists(SELECT * FROM DEPT WHERE DEPTNO = @nr_dzialu)
            print ('Podany dzial nie istnieje')
        ELSE
            INSERT INTO EMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
            VALUES (@NR_PRAC,@nazwisko,'ZAD5','555',SYSDATETIME(),@min_sal,NULL,@nr_dzialu)
            print ('Minimalna pensja wynosi ' + cast(@min_sal AS VARCHAR))
    end;
EXEC ADD_EMP 'SERAFINSKI',50;