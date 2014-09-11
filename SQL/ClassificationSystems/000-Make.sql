--DROP TABLE clasMap
--DROP TABLE clasValue
--DROP TABLE clasSystem

CREATE TABLE clasSystem (
	strName        varchar(128) NOT NULL,
	strDescription varchar(256) NOT NULL,
	bolUsed        bit          NOT NULL,
	
	CONSTRAINT clasSystem_PK PRIMARY KEY (strName)
)


CREATE TABLE clasValue (
	strSystemId    varchar(128) NOT NULL,
	strValue       varchar(32)  NOT NULL,
	strDescription varchar(256) NOT NULL,
	intLevel       int              NULL,
	strParent      varchar(32)      NULL,
	
	CONSTRAINT clasValue_PK                     PRIMARY KEY (strSystemId, strValue),
	CONSTRAINT clasValue_FK_clasSystem          FOREIGN KEY (strSystemId) REFERENCES clasSystem (strName),
	CONSTRAINT clasValue_FK_clasValue_strParent FOREIGN KEY (strSystemId, strParent) REFERENCES clasValue (strSystemId, strValue)
)

CREATE TABLE clasMap (
	strSystem1Id    varchar(128) NOT NULL,
	strSystem1Value varchar(32)  NOT NULL,
	strSystem2Id    varchar(128) NOT NULL,
	strSystem2Value varchar(32)  NOT NULL,
	fltWeight       float            NULL,
	
	CONSTRAINT clasMap_PK             PRIMARY KEY (strSystem1Id, strSystem1Value, strSystem2Id, strSystem2Value),
	CONSTRAINT clasMap_FK_clasValue_1 FOREIGN KEY (strSystem1Id, strSystem1Value) REFERENCES clasValue (strSystemId, strValue),
	CONSTRAINT clasMap_FK_clasValue_2 FOREIGN KEY (strSystem2Id, strSystem2Value) REFERENCES clasValue (strSystemId, strValue)
)

CREATE TABLE PotentialMatches (
	strSystem1Id    varchar(128) NOT NULL,
	strSystem1Value varchar(32)  NOT NULL,
	strSystem2Id    varchar(128) NOT NULL,
	strSystem2Value varchar(32)  NOT NULL,
	fltWeight       float            NULL,
	
	CONSTRAINT PotentialMatches_PK             PRIMARY KEY (strSystem1Id, strSystem1Value, strSystem2Id, strSystem2Value),
	CONSTRAINT PotentialMatches_FK_clasValue_1 FOREIGN KEY (strSystem1Id, strSystem1Value) REFERENCES clasValue (strSystemId, strValue),
	CONSTRAINT PotentialMatches_FK_clasValue_2 FOREIGN KEY (strSystem2Id, strSystem2Value) REFERENCES clasValue (strSystemId, strValue)
)

CREATE TABLE ManualMatches (
	strSystem1Id    varchar(128) NOT NULL,
	strSystem1Value varchar(32)  NOT NULL,
	strSystem2Id    varchar(128) NOT NULL,
	strSystem2Value varchar(32)  NOT NULL,
	
	CONSTRAINT ManualMatches_PK             PRIMARY KEY (strSystem1Id, strSystem1Value, strSystem2Id, strSystem2Value),
	CONSTRAINT ManualMatches_FK_clasValue_1 FOREIGN KEY (strSystem1Id, strSystem1Value) REFERENCES clasValue (strSystemId, strValue),
	CONSTRAINT ManualMatches_FK_clasValue_2 FOREIGN KEY (strSystem2Id, strSystem2Value) REFERENCES clasValue (strSystemId, strValue)
)

-- S Y S T E M S
INSERT INTO clasSystem VALUES('SIC3', 'Standard Industry classification version 3', 0)
INSERT INTO clasSystem VALUES('SIC31', 'Standard Industry classification version 3.1', 0)
INSERT INTO clasSystem VALUES('SIC4', 'Standard Industry classification version 4', 1)
INSERT INTO clasSystem VALUES('SITC3', 'Standard Industry trade classification version 3', 0)
INSERT INTO clasSystem VALUES('SITC4', 'Standard Industry trade classification version 4', 1)
INSERT INTO clasSystem VALUES ('UNFCCC', 'UNFCCC''s bespoke classification system', 1)
INSERT INTO clasSystem VALUES ('Censa123', 'Censa123 codes used by GreenInsight', 0)
INSERT INTO clasSystem VALUES ('Nace2', 'Nace version 2', 1)

-- V A L U E S
INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) 
SELECT 'SIC3', strCode, strDescription, LEN(strCode)
FROM RawData..SIC3

INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) 
SELECT 'SIC31', strCode, strDescription, LEN(strCode)
FROM RawData..SIC31

INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) 
SELECT 'SIC4', strCode, strDescription, LEN(strCode)
FROM RawData..SIC4

INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) 
SELECT 'SITC3', strCode, strDescription,
	CASE 
		WHEN LEN(strCode) > 3 THEN LEN(strCode) - 1
		ELSE LEN(strCode)
	END
FROM RawData..SITC3

INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) 
SELECT 'SITC4', strCode, strText,
	CASE 
		WHEN LEN(strCode) > 3 THEN LEN(strCode) - 1
		ELSE LEN(strCode)
	END
FROM RawData..SITC4

INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel)
SELECT 'UNFCCC', strSector_code, strSector_name, (LEN(strSector_code) + 1) / 2
FROM RawData..UNFCCC

INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel)
SELECT 'Censa123', intIndex, strProductCategory, 1
FROM RawData..Censa123

INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel)
SELECT 'Nace2', strvalue, strDescription, 
	CASE 
		WHEN LEN(strValue)> 3 THEN LEN(strvalue) - 1 
		ELSE LEN(strvalue) 
	END
FROM RawData..Nace2

-- M A P S
INSERT INTO clasMap (strSystem1Id, strSystem1Value, strSystem2Id, strSystem2Value)
SELECT 'SIC3', strRev3, 'SIC31', strRev31
FROM RawData..SIC3_SIC31

INSERT INTO clasMap (strSystem1Id, strSystem1Value, strSystem2Id, strSystem2Value)
SELECT 'SIC3', strSIC3, 'SITC3', strSITC3
FROM RawData..SIC3_SITC3

INSERT INTO clasMap (strSystem1Id, strSystem1Value, strSystem2Id, strSystem2Value)
SELECT 'SIC4', strISIC4code, 'SIC31', strISIC31Code
FROM RawData..SIC4_SIC31

INSERT INTO clasMap (strSystem1Id, strSystem1Value, strSystem2Id, strSystem2Value)
SELECT 'SITC3', strS3, 'SITC4', strS4
FROM RawData..SITC3_SITC4