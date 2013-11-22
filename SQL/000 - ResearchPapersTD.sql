-- TABLE DEFINITIONS --
CREATE DATABASE Papers

USE Papers   -- because apparently just because you've created a database there's no reason 
             -- to suppose you want to switch to it straight away


CREATE TABLE Paper
(
	intId          int          NOT NULL IDENTITY(1,1),
	intYear        int          NOT NULL,
	strTitle       varchar(max) NOT NULL,
	strType        varchar(64)      NULL, -- conference paper, journal paper etc.
	strPublication varchar(256)     NULL, -- name of conference, name of journal etc.
	strNotes       varchar(max)     NULL,
	
	CONSTRAINT Paper_PK PRIMARY KEY (intId)
)
CREATE TABLE Author
(
	strAuthor varchar(128) NOT NULL,
	
	CONSTRAINT Author_PK PRIMARY KEY (strAuthor)
)

CREATE TABLE Paper_Author
(
	intPaperId int         NOT NULL,
	strAuthor  varchar(128) NOT NULL,
	
	CONSTRAINT Paper_Author_PK        PRIMARY KEY (intPaperId, strAuthor),
	CONSTRAINT Paper_Author_FK_Paper  FOREIGN KEY (intPaperId) REFERENCES Paper  (intId) ON DELETE CASCADE,
	CONSTRAINT Paper_Author_FK_Author FOREIGN KEY (strAuthor)  REFERENCES Author (strAuthor) ON DELETE CASCADE,
)

CREATE TABLE Keyword
(
	strKeyword varchar(64) NOT NULL,
	
	CONSTRAINT Keyword_PK PRIMARY KEY (strKeyword)
)

CREATE TABLE Paper_Keyword
(
	intPaperId int          NOT NULL,
	strKeyword  varchar(64) NOT NULL,
	
	CONSTRAINT Paper_Keyword_PK          PRIMARY KEY (intPaperId, strKeyword),
	CONSTRAINT Paper_Keyword_FK_Paper   FOREIGN KEY (intPaperId)  REFERENCES Paper   (intId) ON DELETE CASCADE,
	CONSTRAINT Paper_Keyword_FK_Keyword FOREIGN KEY (strKeyword)  REFERENCES Keyword (strKeyword) ON DELETE CASCADE,
)
CREATE TABLE MendeleyPaper
(
	intId          int          NOT NULL PRIMARY KEY IDENTITY(1,1),
	intYear        int          NOT NULL,
	strTitle       varchar(max) NOT NULL,
	strType        varchar(64)      NULL, -- conference paper, journal paper etc.
	strPublication varchar(256)     NULL, -- name of conference, name of journal etc.
	strNotes       varchar(max)     NULL,
)

CREATE TABLE MendeleyAuthor
(
	intMendeleyPaperId int         NOT NULL,
	strAuthor          varchar(128) NOT NULL,
	
	CONSTRAINT MendeleyAuthor_PK PRIMARY KEY(intMendeleyPaperId, strAuthor),
	CONSTRAINT MendeleyAuthor_FK_MendeleyPaper FOREIGN KEY (intMendeleyPaperId) REFERENCES MendeleyPaper (intId)
)

CREATE TABLE PaperMendeleyPaper
(
	intPaperId int NOT NULL,
	intMendeleyPaperId int NOT NULL,
	
	CONSTRAINT PaperMendeleyPaper_PK PRIMARY KEY               (intPaperId, intMendeleyPaperId),
	CONSTRAINT PaperMendeleyPaper_FK_Paper FOREIGN KEY         (intPaperId)         REFERENCES Paper (intId),
	CONSTRAINT PaperMendeleyPaper_FK_MendeleyPaper FOREIGN KEY (intMendeleyPaperId) REFERENCES MendeleyPaper (intId)
)


-- USER PERMISSIONS --
IF NOT EXISTS (
	SELECT * FROM sys.server_principals WHERE name = 'Paper'
)
BEGIN
	CREATE LOGIN Paper WITH Password='Paper'
END

CREATE USER Paper FOR LOGIN Paper
EXEC sp_addrolemember 'db_datareader', 'Paper'
GRANT EXECUTE TO Paper

IF NOT EXISTS (
	SELECT * FROM sys.server_principals WHERE name = 'ukplcPageOrm'
)
BEGIN
	CREATE LOGIN ukplcPageOrm WITH Password='if47thfgisfuowi8o32hioffwefv'
END

CREATE USER ukplcPageOrm FOR LOGIN ukplcPageOrm
EXEC sp_addrolemember 'db_datareader', 'ukplcPageOrm'
EXEC sp_addrolemember 'db_datawriter', 'ukplcPageOrm'
EXEC sp_addrolemember 'db_ddladmin', 'ukplcPageOrm'
GRANT EXECUTE TO ukplcPageOrm

GRANT DELETE TO Paper

-- DATA (optional) --
--INSERT INTO Author (strAuthor) VALUES ('Christoph J Meinrenken')
--INSERT INTO Author (strAuthor) VALUES ('Scott M Kaufman')
--INSERT INTO Author (strAuthor) VALUES ('Siddharth Ramesh')
--INSERT INTO Author (strAuthor) VALUES ('Klaus S Lackner')

--INSERT INTO Keyword (strKeyword) VALUES ('Carbon footprinting model')
--INSERT INTO Keyword (strKeyword) VALUES ('Error calculation')
--INSERT INTO Keyword (strKeyword) VALUES ('hybrid')

--INSERT INTO Paper(intYear, strTitle, strType, 
--	strPublication, strNotes)
--VALUES(2012, 'Fast carbon footprinting for large product portfolios', 'Journal', 
--	'Journal of Industrial Ecology', 'Emissions factors are devised by aggregating differnet factors from the 
--	EcoInvent database, the factors are then averaged, and the standard deviation is used to provide an error 
--	estimate (+- percentage). Emissions factors seem a bit questionable because of the aggregation')

--DECLARE @paperId AS int

--SELECT @paperId = SCOPE_IDENTITY()

--INSERT INTO Paper_Author (intPaperId, strAuthor) VALUES (@paperId, 'Christoph J Meinrenken')
--INSERT INTO Paper_Author (intPaperId, strAuthor) VALUES (@paperId, 'Scott M Kaufman')
--INSERT INTO Paper_Author (intPaperId, strAuthor) VALUES (@paperId, 'Siddharth Ramesh')
--INSERT INTO Paper_Author (intPaperId, strAuthor) VALUES (@paperId, 'Klaus S Lackner')

--INSERT INTO Paper_Keyword (intPaperId, strKeyword) VALUES (@paperId, 'Carbon footprinting model')
--INSERT INTO Paper_Keyword (intPaperId, strKeyword) VALUES (@paperId, 'Error calculation')
--INSERT INTO Paper_Keyword (intPaperId, strKeyword) VALUES (@paperId, 'hybrid')
