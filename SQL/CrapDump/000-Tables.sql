CREATE TABLE clasSystem (
	intSystemId    int         NOT NULL PRIMARY KEY IDENTITY(1,1),
	strDescription varchar(64)     NULL,
	
)

CREATE TABLE clasValue (
	intSystemId    int          NOT NULL,
	strValue       varchar(32)  NOT NULL,
	strDescription varchar(256)     NULL,
	
	CONSTRAINT clasValue_PK            PRIMARY KEY (intSystemId, strValue),
	CONSTRAINT clasValue_FK_clasSystem FOREIGN KEY (intSystemId) REFERENCES clasSystem
)

CREATE TABLE SysCompareSimilarity (
	intSystemId1  int         NOT NULL,
	strValue1     varchar(32) NOT NULL,
	intSystemId2  int         NOT NULL,
	strValue2     varchar(32) NOT NULL,
	intSimilarity int             NULL,
	
	CONSTRAINT SysCompareSimilarity_PK            PRIMARY KEY (intSystemId1, strValue1, intSystemId2, strValue2),
	CONSTRAINT SysCompareSimilarity_FK_clasValue1 FOREIGN KEY (intSystemId1, strValue1) 
		REFERENCES clasValue(intSystemId, strValue),
	CONSTRAINT SysCompareSimilarity_FK_clasValue2 FOREIGN KEY (intSystemId2, strValue2) 
		REFERENCES clasValue(intSystemId, strValue)
)

CREATE TABLE clasMap (
	intSystem1Id int NOT NULL,
	intSystem2Id int NOT NULL,
	strValue1    varchar(32) NOT NULL,
	strValue2    varchar(32) NOT NULL,
	
	CONSTRAINT clasMap_PK            PRIMARY KEY (intSystem1Id, intSystem2Id, strValue1, strValue2),
	CONSTRAINT clasMap_FK_clasValue1 FOREIGN KEY (intSystem1Id, strValue1) REFERENCES clasValue (intSystemId, strValue),
	CONSTRAINT clasMap_FK_clasValue2 FOREIGN KEY (intSystem2Id, strValue2) REFERENCES clasValue (intSystemId, strValue)
)

CREATE TABLE SysValue(
	intYear      int         NOT NULL,
	intSystemId  int         NOT NULL,
	strValueFrom varchar(32) NOT NULL,
	strValueTo   varchar(32) NOT NULL,
	fltValue     float           NULL,
	
	CONSTRAINT SysValue_PK               PRIMARY KEY (intYear, intSystemId, strValueFrom, strValueTo),
	CONSTRAINT SysValue_FK_clasValueFrom FOREIGN KEY (intSystemId, strValueFrom) REFERENCES clasValue (intSystemId, strValue),
	CONSTRAINT SysValue_FK_clasValueTo   FOREIGN KEY (intSystemId, strValueTo)   REFERENCES clasValue (intSystemId, strValue)
)

CREATE TABLE MatchGuess (
	strSystem1Id         varchar(256) NOT NULL,
	strValue1            varchar(64)  NOT NULL,
	strSystem2Id         varchar(256) NOT NULL,
	strValue2            varchar(64)  NOT NULL,
	fltWordSimilarity    float            NULL,
	fltSynonymSimilarity float            NULL,
	fltWordSynSimilarity float            NULL,
	
	CONSTRAINT MatchGuess_PK PRIMARY KEY (strSystem1Id, strValue1, strSystem2Id, strValue2),
	CONSTRAINT MatchGuess_strSystem2_strValue2_IX INDEX (strSystem2Id, strValue2)
)

CREATE TABLE StopWord (
	strStopWord varchar(64) NOT NULL,
	
	CONSTRAINT StopWord_PK PRIMARY KEY (strStopWord)
)