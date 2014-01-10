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