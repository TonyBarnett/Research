CREATE VIEW topTenPercentResults
AS 
SELECT r.strTrainingMethod,
       r.strType,
       r.strSystemId,
       REPLACE(r.strValue,'_', '.') AS strValue,
       r.strGuess,
       r.fltProbability
FROM NaiveBayes..mappingResults r
INNER JOIN (
	SELECT strTrainingMethod, strType, strSystemId, strValue, MAX(fltProbability) * 1.1 AS maxProbability
	FROM NaiveBayes..mappingResults
	GROUP BY strTrainingMethod, strType,strSystemId, strValue
) m 
	ON m.strTrainingMethod = r.strTrainingMethod 
		AND m.strType = r.strType 
		AND m.strSystemId = r.strSystemId 
		AND m.strValue = r.strValue 
		AND m.maxProbability <= r.fltProbability

GO

CREATE VIEW topOnePercentResults
AS 
SELECT r.strTrainingMethod,
       r.strType,
       r.strSystemId,
       REPLACE(r.strValue,'_', '.') AS strValue,
       r.strGuess,
       r.fltProbability
FROM NaiveBayes..mappingResults r
INNER JOIN (
	SELECT strTrainingMethod, strType, strSystemId, strValue, MAX(fltProbability) * 1.01 AS maxProbability
	FROM NaiveBayes..mappingResults
	GROUP BY strTrainingMethod, strType,strSystemId, strValue
) m 
	ON m.strTrainingMethod = r.strTrainingMethod 
		AND m.strType = r.strType 
		AND m.strSystemId = r.strSystemId 
		AND m.strValue = r.strValue 
		AND m.maxProbability <= r.fltProbability

