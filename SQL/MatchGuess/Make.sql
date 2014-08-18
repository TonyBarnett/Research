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

CREATE VIEW FinalGuess
AS
	SELECT r.strGuessType, r.strSystemId, r.strValue, r.strTargetValue, g.fltProbability
	FROM (
		SELECT strGuessType, strSystemId, strValue, strTargetValue, 
			ROW_NUMBER () OVER (PARTITION BY strSystemId, strValue ORDER BY fltProbability DESC) AS intRank
		FROM Guess
	) r
		INNER JOIN Guess g ON 
			g.strGuessType = r.strGuessType AND 
			g.strSystemId = r.strSystemId AND 
			g.strValue = r.strValue AND 
			g.strTargetValue = r.strTargetValue
	WHERE r.intRank = 1