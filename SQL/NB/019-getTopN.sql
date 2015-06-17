CREATE FUNCTION getTopNResults(@N float)
RETURNS @results table (
strTrainingMethod varchar(256),
strType           varchar(128),
strSystemId       varchar(128),
strValue          varchar(128),
strGuess          varchar(16),
fltProbability    float
)
AS
BEGIN
INSERT INTO @results (strTrainingMethod, strType, strSystemId, strValue, strGuess, fltProbability)
SELECT r.strTrainingMethod,
       r.strType,
       r.strSystemId,
       REPLACE(r.strValue,'_', '.') AS strValue,
       r.strGuess,
       r.fltProbability
FROM NaiveBayes..mappingResults r
INNER JOIN (
	SELECT strTrainingMethod, strType, strSystemId, strValue, MAX(fltProbability) - @N  AS maxProbability
	FROM NaiveBayes..mappingResults
	WHERE fltProbability IS NOT NULL
	GROUP BY strTrainingMethod, strType,strSystemId, strValue
) m 
	ON m.strTrainingMethod = r.strTrainingMethod 
		AND m.strType = r.strType 
		AND m.strSystemId = r.strSystemId 
		AND m.strValue = r.strValue 
		AND m.maxProbability <= r.fltProbability
		
UNION 
-- This is for KNN as you want all the results it spits out
SELECT r.strTrainingMethod,
       r.strType,
       r.strSystemId,
       REPLACE(r.strValue,'_', '.') AS strValue,
       r.strGuess,
       NULL
FROM NaiveBayes..mappingResults r
WHERE r.fltProbability IS NULL

RETURN
END