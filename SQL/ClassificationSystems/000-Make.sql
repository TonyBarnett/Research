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

CREATE TABLE clasMap_old (
	strSystem1Id    varchar(128) NOT NULL,
	strSystem1Value varchar(32)  NOT NULL,
	strSystem2Id    varchar(128) NOT NULL,
	strSystem2Value varchar(32)  NOT NULL,
	fltWeight       float            NULL,
	
	CONSTRAINT classMap_old_PK             PRIMARY KEY (strSystem1Id, strSystem1Value, strSystem2Id, strSystem2Value),
	CONSTRAINT classMap_old_FK_clasValue_1 FOREIGN KEY (strSystem1Id, strSystem1Value) REFERENCES clasValue (strSystemId, strValue),
	CONSTRAINT classMap_old_FK_clasValue_2 FOREIGN KEY (strSystem2Id, strSystem2Value) REFERENCES clasValue (strSystemId, strValue)
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

CREATE TABLE DocumentSample (
	strSystemId varchar(128) NOT NULL,
	strValue    varchar(32)  NOT NULL,
	
	CONSTRAINT DocumentSample_PK           PRIMARY KEY (strSystemId, strValue),
	CONSTRAINT DocumentSample_FK_clasValue FOREIGN KEY (strSystemId, strValue) REFERENCES clasValue (strSystemId, strValue)
)

-- S Y S T E M S
INSERT INTO clasSystem VALUES('SIC3', 'Standard Industry classification version 3', 0)
INSERT INTO clasSystem VALUES('SIC31', 'Standard Industry classification version 3.1', 0)
INSERT INTO clasSystem VALUES('SIC4', 'Standard Industry classification version 4', 1)
INSERT INTO clasSystem VALUES('SITC3', 'Standard Industry trade classification version 3', 0)
INSERT INTO clasSystem VALUES('SITC4', 'Standard Industry trade classification version 4', 1)
INSERT INTO clasSystem VALUES ('UNFCCC', 'UNFCCC''s bespoke classification system', 1)
INSERT INTO clasSystem VALUES ('Censa123', 'Censa123 codes used by GreenInsight', 0)
INSERT INTO clasSystem VALUES ('Nace2', 'Nace version 2', 0)
INSERT INTO clasSystem VALUES ('Nace11', 'Nace version 1', 1)

-- V A L U E S
INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) 
SELECT 'SIC3', strCode, strDescription, LEN(strCode)
FROM RawData..SIC3

INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) 
SELECT 'SIC31', strCode, strDescription, LEN(strCode)
FROM RawData..SIC31

UPDATE v
SET v.strValue = 
	SELECT CASE 
		WHEN LEN(strValue) = 2 THEN REPLACE(strValue, '.', '') + '000'
		WHEN LEN(strValue) = 4 THEN REPLACE(strValue, '.', '') + '00'
		WHEN LEN(strValue) = 5 THEN REPLACE(strValue, '.', '') + '0'
		WHEN LEN(strValue) > 5 THEN REPLACE(SUBSTRING(strValue, 0, 5), '.', '') + '0'
	END
FROM clasValue v
WHERE v.strSystemId = 'SIC4' AND LEN(strValue) > 1

INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) 
SELECT 'SIC4', 
	CASE 
		WHEN LEN(strCode) = 2 THEN REPLACE(strcode, '.', '') + '000'
		WHEN LEN(strcode) = 4 THEN REPLACE(strcode, '.', '') + '00'
		WHEN LEN(strcode) = 5 THEN REPLACE(strcode, '.', '') + '0'
	END, strDescription, 
	CASE 
		WHEN LEN(strCode) > 5 THEN 5
		ELSE LEN(strcode)
	END
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

INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) VALUES ('Nace2', 'A', 'AGRICULTURE, FORESTRY AND FISHING', 1)
INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) VALUES ('Nace2', 'B', 'MINING AND QUARRYING', 1)
INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) VALUES ('Nace2', 'C', 'MANUFACTURING', 1)
INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) VALUES ('Nace2', 'D', 'ELECTRICITY,  GAS,  STEAM AND AIR CONDITIONING SUPPLY', 1)
INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) VALUES ('Nace2', 'E', 'WATER SUPPLY; SEWERAGE, WASTE MANAGEMENT AND REMEDIATION ACTIVITIES', 1)
INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) VALUES ('Nace2', 'F', 'CONSTRUCTION', 1)
INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) VALUES ('Nace2', 'G', 'WHOLESALE AND RETAIL TRADE; REPAIR OF MOTOR VEHICLES AND MOTORCYCLES', 1)
INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) VALUES ('Nace2', 'H', 'TRANSPORTATION AND STORAGE', 1)
INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) VALUES ('Nace2', 'I', 'ACCOMMODATION AND FOOD SERVICE ACTIVITIES', 1)
INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) VALUES ('Nace2', 'J', 'INFORMATION AND COMMUNICATION', 1)
INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) VALUES ('Nace2', 'K', 'FINANCIAL AND INSURANCE ACTIVITIES', 1)
INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) VALUES ('Nace2', 'L', 'REAL ESTATE ACTIVITIES', 1)
INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) VALUES ('Nace2', 'M', 'PROFESSIONAL, SCIENTIFIC AND TECHNICAL ACTIVITIES', 1)
INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) VALUES ('Nace2', 'N', 'ADMINISTRATIVE AND SUPPORT SERVICE ACTIVITIES', 1)
INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) VALUES ('Nace2', 'O', 'PUBLIC ADMINISTRATION AND DEFENCE; COMPULSORY SOCIAL SECURITY', 1)
INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) VALUES ('Nace2', 'P', 'EDUCATION', 1)
INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) VALUES ('Nace2', 'Q', 'HUMAN HEALTH AND SOCIAL WORK ACTIVITIES', 1)
INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) VALUES ('Nace2', 'R', 'ARTS, ENTERTAINMENT AND RECREATION', 1)
INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) VALUES ('Nace2', 'S', 'OTHER SERVICE ACTIVITIES', 1)
INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) VALUES ('Nace2', 'T', 'ACTIVITIES OF HOUSEHOLDS AS EMPLOYERS; U0NDIFFERENTIATED GOODS- AND SERVICES-PRODUCING ACTIVITIES OF HOUSEHOLDS FOR OWN USE', 1)
INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel) VALUES ('Nace2', 'U', 'ACTIVITIES OF EXTRATERRITORIAL ORGANISATIONS AND BODIES', 1)

INSERT INTO clasValue (strSystemId, strValue, strDescription, intLevel)
SELECT 'Nace11', strCode, strDescription, 
	CASE 
		WHEN LEN(strCode)> 3 THEN LEN(strCode) - 1 
		ELSE LEN(strCode) 
	END
FROM RawData..Nace11


-- M A P S
INSERT INTO clasMap_old (strSystem1Id, strSystem1Value, strSystem2Id, strSystem2Value)
SELECT 'SIC3', strRev3, 'SIC31', strRev31
FROM RawData..SIC3_SIC31

INSERT INTO clasMap_old (strSystem1Id, strSystem1Value, strSystem2Id, strSystem2Value)
SELECT 'SIC3', strSIC3, 'SITC3', strSITC3
FROM RawData..SIC3_SITC3

INSERT INTO clasMap_old (strSystem1Id, strSystem1Value, strSystem2Id, strSystem2Value)
SELECT 'SIC4', strISIC4code, 'SIC31', strISIC31Code
FROM RawData..SIC4_SIC31

INSERT INTO clasMap_old (strSystem1Id, strSystem1Value, strSystem2Id, strSystem2Value)
SELECT 'SITC3', strS3, 'SITC4', strS4
FROM RawData..SITC3_SITC4