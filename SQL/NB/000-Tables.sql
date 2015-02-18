CREATE TABLE results (
	intRun         int          NOT NULL,
	strType        varchar(256) NOT NULL,
	strSource      varchar(256) NOT NULL,
	strValue       varchar(32)  NOT NULL,
	strGuess       varchar(16)  NOT NULL,
	fltProbability float            NULL,
	datTimeStamp   datetime     NOT NULL DEFAULT GETDATE(),
	
	CONSTRAINT results_PK PRIMARY KEY (intRun, strType, strSource, strValue, strGuess)
)

CREATE TABLE mappingResults (
	strTrainingMethod varchar(256) NOT NULL,
	strType           varchar(256) NOT NULL,
	strSystemId       varchar(64)  NOT NULL,
	strValue          varchar(32)  NOT NULL,
	strGuess          varchar(16)  NOT NULL,
	fltProbability    float            NULL,
	datTimeStamp      datetime     NOT NULL DEFAULT GETDATE(),
	
	CONSTRAINT mappingResults_PK PRIMARY KEY (strTrainingMethod, strType, strSystemId, strValue, strGuess)
)

CREATE TABLE vocabulary (
	strWord      varchar(256) NOT NULL PRIMARY KEY,
	intFrequency int              NULL,
)

CREATE TABLE DocumentWords (
	intDocumentId int          NOT NULL,
	strWord       varchar(256) NOT NULL,
	intFrequency  int          NOT NULL,
	
	CONSTRAINT DocumentWords_PK PRIMARY KEY (intDocumentId, strWord),
	CONSTRAINT DocumentWords_FK_vocabulary FOREIGN KEY (strWord) REFERENCES vocabulary (strWord)
)