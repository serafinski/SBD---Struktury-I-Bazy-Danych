-- ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
-- ALTER SESSION SET NLS_TERRITORY = AMERICA;
ALTER SESSION SET NLS_DATE_FORMAT = 'dd-mm-yyyy';

-- DROP TABLE Oceny;
-- DROP TABLE Przedmioty;
-- DROP TABLE Studenci;
-- DROP TABLE Dydaktycy;
-- DROP TABLE Stopnie_tytuly;
-- DROP TABLE Osoba;

CREATE TABLE Osoba (
	Osoba_Id Int Not Null Primary Key,
	Nazwisko Varchar2(30) Not Null,
	Imie Varchar2(30) Not Null);
  
CREATE TABLE Stopnie_tytuly (
	Stopien_Id Int Not Null Primary Key,
	Stopien_skrot Varchar2(20) Not Null,
	Stopien Varchar2(35) Not Null);
  
ALTER TABLE Stopnie_tytuly ADD (CONSTRAINT Unique_Stopien_skrot Unique (Stopien_skrot));
ALTER TABLE Stopnie_tytuly ADD (CONSTRAINT Unique_Stopien Unique (Stopien));

CREATE TABLE Dydaktycy (
	Osoba_Id Int NOT NULL,
	Podlega int NULL,
	Data_zatrudnienia Date NULL,
	Stopien_Id int NULL,
 CONSTRAINT PK_Dydaktycy PRIMARY KEY (Osoba_Id));

ALTER TABLE Dydaktycy ADD (CONSTRAINT FK_osoba_Dydaktyk FOREIGN KEY(Osoba_Id)
REFERENCES Osoba (Osoba_Id)
ON DELETE CASCADE);

ALTER TABLE Dydaktycy ADD (CONSTRAINT FK_Dydaktycy_Stopnie_tytuly FOREIGN KEY(Stopien_Id)
REFERENCES Stopnie_tytuly (Stopien_Id));

CREATE TABLE Studenci (
	Osoba_Id Int NOT NULL,
	Nr_Indeksu Varchar2(6) NULL,
	Data_rekrutacji Date NULL,
	CONSTRAINT PK_Studenci PRIMARY KEY (Osoba_Id));
	
ALTER TABLE Studenci ADD (CONSTRAINT FK_Osoba_Student FOREIGN KEY(Osoba_Id)
REFERENCES Osoba (Osoba_Id)
ON DELETE CASCADE);
	
CREATE TABLE Przedmioty (
	Przedmiot_Id Int Not Null Primary Key,
	Przedmiot_skrot Varchar2(4) Not Null,
	Przedmiot Varchar2(30) Not Null,
	CONSTRAINT Unique_Przedmiot_skrot Unique (Przedmiot_skrot),
	CONSTRAINT Unique_Przedmiot Unique (Przedmiot));
	
CREATE TABLE Oceny (
	Przedmiot_Id Int Not Null,
	Data_wystawienia Date,
	Student Int Not Null,
	Dydaktyk Int Not Null,
	Ocena Numeric(2,1),
	CONSTRAINT PK_Oceny PRIMARY KEY (Przedmiot_Id, Data_wystawienia, Student));
  
ALTER TABLE Oceny ADD (CONSTRAINT FK_Oceny_Dydaktycy FOREIGN KEY(Dydaktyk)
REFERENCES Dydaktycy (Osoba_Id));

ALTER TABLE Oceny ADD (CONSTRAINT FK_Oceny_Studenci FOREIGN KEY(Student)
REFERENCES Studenci (Osoba_Id));

ALTER TABLE Oceny ADD (CONSTRAINT FK_Oceny_Przedmioty FOREIGN KEY(Przedmiot_Id)
REFERENCES Przedmioty (Przedmiot_Id));

INSERT INTO Stopnie_tytuly (Stopien_Id, Stopien_skrot, Stopien)
VALUES	(1, 'Prof. Dr hab.', 'Profesor Doktor habilitowany');

INSERT INTO Stopnie_tytuly (Stopien_Id, Stopien_skrot, Stopien)
VALUES	(2, 'Dr hab.', 'Doktor habilitowany');

INSERT INTO Stopnie_tytuly (Stopien_Id, Stopien_skrot, Stopien)
VALUES	(3, 'Dr', 'Doktor');

INSERT INTO Stopnie_tytuly (Stopien_Id, Stopien_skrot, Stopien)
VALUES	(4, 'Mgr', 'Magister');

INSERT INTO Stopnie_tytuly (Stopien_Id, Stopien_skrot, Stopien)
VALUES	(5, 'Inz', 'Inzynier');

INSERT INTO Stopnie_tytuly (Stopien_Id, Stopien_skrot, Stopien)
VALUES	(6, 'Bac', 'Bachelor');

INSERT	INTO Osoba (Osoba_Id, Imie, Nazwisko) VALUES (1, 'Apolinary', 'Bigos');
INSERT	INTO Dydaktycy (Osoba_Id, Data_zatrudnienia, Stopien_Id)
VALUES	(1, '03-12-2001',1);

INSERT	INTO Osoba (Osoba_Id, Imie, Nazwisko) VALUES (2, 'Gryzelda', 'Kapusta');
INSERT	INTO Dydaktycy (Osoba_Id, Data_zatrudnienia, Stopien_Id)
VALUES	(2, '21-11-2005',4);

INSERT	INTO Osoba (Osoba_Id, Imie, Nazwisko) VALUES (3, 'Baltazar', 'Pietruszka');
INSERT	INTO Dydaktycy (Osoba_Id, Data_zatrudnienia, Stopien_Id)
VALUES	(3, '5-02-2001',5);

INSERT	INTO Osoba (Osoba_Id, Imie, Nazwisko) VALUES (4, 'Kleofas', 'Barszcz');
INSERT	INTO Dydaktycy (Osoba_Id, Data_zatrudnienia, Stopien_Id)
VALUES	(4, '24-10-2004',1);

INSERT	INTO Osoba (Osoba_Id, Imie, Nazwisko) VALUES (5, 'Konstanty', 'Pyra');
INSERT	INTO Dydaktycy (Osoba_Id, Data_zatrudnienia, Stopien_Id)
VALUES	(5, '02-10-2004',3);

INSERT	INTO Osoba (Osoba_Id, Imie, Nazwisko) VALUES (6, 'Rufus', 'Baklazan');
INSERT	INTO Dydaktycy (Osoba_Id, Data_zatrudnienia, Stopien_Id)
VALUES	(6, '12-05-2003',2);

INSERT	INTO Osoba (Osoba_Id, Imie, Nazwisko) VALUES (7, 'Atanazy', 'Kalafior');
INSERT	INTO Dydaktycy (Osoba_Id, Data_zatrudnienia, Stopien_Id)
VALUES	(7, '12-05-2003',4);

INSERT	INTO Osoba (Osoba_Id, Imie, Nazwisko) VALUES (8, 'Apolinary', 'Karp');
INSERT	INTO Dydaktycy (Osoba_Id, Data_zatrudnienia, Stopien_Id)
VALUES	(8, '03-05-2003',5);

INSERT	INTO Osoba (Osoba_Id, Imie, Nazwisko) VALUES (9, 'Eustachy', 'Jajecznica');
INSERT	INTO Dydaktycy (Osoba_Id, Data_zatrudnienia, Stopien_Id)
VALUES	(9, '12-05-2004',2);

INSERT	INTO Osoba (Osoba_Id, Imie, Nazwisko) VALUES (10, 'Archibald', 'Pudding');
INSERT	INTO Dydaktycy (Osoba_Id, Data_zatrudnienia, Stopien_Id)
VALUES	(10, '12-05-2002',3);

INSERT	INTO Osoba (Osoba_Id, Imie, Nazwisko) VALUES (11, 'Kunegunda', 'Klops');
INSERT	INTO Dydaktycy (Osoba_Id, Data_zatrudnienia, Stopien_Id)
VALUES	(11, '18-06-1998',4);

UPDATE Dydaktycy SET Podlega = 1 WHERE Osoba_Id IN (4, 6, 9);
UPDATE Dydaktycy SET Podlega = 4 WHERE Osoba_Id IN (5, 10);
UPDATE Dydaktycy SET Podlega = 6 WHERE Osoba_Id IN (2, 7, 11);
UPDATE Dydaktycy SET Podlega = 9 WHERE Osoba_Id IN (3, 8);

INSERT INTO Przedmioty (Przedmiot_Id, Przedmiot, Przedmiot_skrot) VALUES (1,'Matematyka', 'Mat');

INSERT INTO Przedmioty (Przedmiot_Id, Przedmiot, Przedmiot_skrot) VALUES (2, 'Fizyka', 'Fiz');

INSERT INTO Przedmioty (Przedmiot_Id, Przedmiot, Przedmiot_skrot) VALUES (3, 'Bazy danych', 'BD');

INSERT INTO Przedmioty (Przedmiot_Id, Przedmiot, Przedmiot_skrot) VALUES (4, 'Inzynieria oprogramowania', 'IO');
												
INSERT INTO Przedmioty (Przedmiot_Id, Przedmiot, Przedmiot_skrot) VALUES (5, 'Algorytmy', 'ASD');

INSERT INTO Przedmioty (Przedmiot_Id, Przedmiot, Przedmiot_skrot) VALUES (6, 'Elektronika', 'El');

INSERT INTO Przedmioty (Przedmiot_Id, Przedmiot, Przedmiot_skrot) VALUES (7, 'Data mining', 'DM');

INSERT INTO Przedmioty (Przedmiot_Id, Przedmiot, Przedmiot_skrot) VALUES (8, 'Systemy operacyjne', 'SOP');

INSERT	INTO Osoba (Osoba_Id, Imie, Nazwisko)
VALUES (12,'Roza', 'Ananas');

INSERT	INTO Studenci (Osoba_Id, Data_rekrutacji, Nr_Indeksu)
VALUES	(12, '12-09-2002','s2121');

INSERT	INTO Osoba (Osoba_Id, Imie, Nazwisko)
VALUES (13, 'Eulalia', 'Sliwka');

INSERT	INTO Studenci (Osoba_Id, Data_rekrutacji, Nr_Indeksu)
VALUES	(13, '12-09-2002','s2226');

INSERT	INTO Osoba (Osoba_Id, Imie, Nazwisko)
VALUES (14, 'Anastazja', 'Paczek');

INSERT	INTO Studenci (Osoba_Id, Data_rekrutacji, Nr_Indeksu)
VALUES	(14, '12-09-2003','s3271');

INSERT	INTO Osoba (Osoba_Id, Imie, Nazwisko)
VALUES (15, 'Alojzy', 'Gruszka');

INSERT	INTO Studenci (Osoba_Id, Data_rekrutacji, Nr_Indeksu)
VALUES	(15, '01-10-2003','s3184');

INSERT	INTO Osoba (Osoba_Id, Imie, Nazwisko)
VALUES (16, 'Zenobi', 'Truten');

INSERT	INTO Studenci (Osoba_Id, Data_rekrutacji, Nr_Indeksu)
VALUES	(16, '12-10-2004','s4162');

INSERT	INTO Osoba (Osoba_Id, Imie, Nazwisko)
VALUES (17, 'Klara', 'Bluszcz');

INSERT	INTO Studenci (Osoba_Id, Data_rekrutacji, Nr_Indeksu)
VALUES	(17, '22-09-2004','s4162');

INSERT	INTO Osoba (Osoba_Id, Imie, Nazwisko)
VALUES (18, 'Ambrozy', 'Melon');

INSERT	INTO Studenci (Osoba_Id, Data_rekrutacji, Nr_Indeksu)
VALUES	(18, '22-02-2004','s4232');

INSERT	INTO Osoba (Osoba_Id, Imie, Nazwisko)
VALUES (19, 'Hieronim', 'Dynia');

INSERT	INTO Studenci (Osoba_Id, Data_rekrutacji, Nr_Indeksu)
VALUES	(19, '05-08-2005','s5420');

INSERT	INTO Osoba (Osoba_Id, Imie, Nazwisko)
VALUES (20, 'Hiacynta', 'Banan');

INSERT	INTO Studenci (Osoba_Id, Data_rekrutacji, Nr_Indeksu)
VALUES	(20, '06-07-2005','s5852');

INSERT	INTO Dydaktycy (Osoba_Id, Data_zatrudnienia, Stopien_Id, Podlega)
VALUES	(12, '28-09-2008',5, 9);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (1, '21-01-2003', 12,4,4.5);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (1, '21-01-2003', 13,4,3.0);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (1, '01-02-2004', 14,4,5);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (1, '01-02-2004', 15,4,2.0);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (1, '31-01-2005', 16,5,4.5);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (1, '31-01-2005', 17,5,4.0);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (1, '31-01-2005', 18,5,5.0);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (1, '31-01-2005', 15,4,3.0);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (3, '25-01-2003', 12,6,3.5);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (3, '25-01-2003', 13,6,3.5);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (3, '25-02-2004', 14,6,4.5);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (3, '25-02-2004', 15,6,5.0);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (3, '03-02-2005', 16,7,4.5);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (3, '03-02-2005', 17,7,4.5);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (3, '03-02-2005', 18,7,4.0);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (1, '02-02-2006', 19,5,3.5);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (1, '02-02-2006', 20,5,4.5);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (2, '30-01-2003', 12,1,4.5);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (2, '30-01-2003', 13,1,4.0);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (2, '08-02-2004', 14,1,4.0);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (2, '08-02-2004', 15,1,3.0);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (2, '07-02-2005', 16,1,4.5);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (2, '07-02-2005', 17,1,4.5);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (2, '07-02-2005', 18,9,5.0);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (2, '06-02-2006', 19,9,4.5);

INSERT INTO Oceny (Przedmiot_Id, Data_wystawienia, Student, Dydaktyk, Ocena)
VALUES (2, '06-02-2006', 20,9,3.5);

COMMIT;