CREATE TABLE GuessType (
	strType varchar(32) NOT NULL,
	
	CONSTRAINT GuessType_PK PRIMARY KEY (strType)
)

CREATE TABLE Guess (
	strGuessType         varchar(32)  NOT NULL,
	strSystemId          varchar(256) NOT NULL,
	strValue             varchar(64)  NOT NULL,
	strTargetValue       varchar(64)  NOT NULL,
	fltProbability       float            NULL,
	fltWordSimilarity    float            NULL,
	fltSynWordSimilarity float            NULL,
	fltSynonymSimilarity float            NULL,
	
	CONSTRAINT Guess_PK           PRIMARY KEY (strGuessType, strSystemId, strValue, strTargetValue),
	CONSTRAINT Guess_FK_GuessType FOREIGN KEY (strGuessType) REFERENCES GuessType (strType)
)

INSERT INTO GuessType VALUES('NB Words')
INSERT INTO GuessType VALUES('NB Source Synonyms')
INSERT INTO GuessType VALUES('NB Target Synonyms')
INSERT INTO GuessType VALUES('NB All Synonyms')

INSERT INTO GuessType VALUES('Synonym compare')
