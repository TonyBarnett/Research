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