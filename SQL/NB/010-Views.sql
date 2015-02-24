CREATE VIEW topTenPercentResults
AS 
SELECT r.strTrainingMethod,
       r.strType,
       r.strSystemId,
       REPLACE(r.strValue,'_', '.') AS strValue,
       r.strGuess,
       r.fltProbability
FROM NaiveBayes..mappingResults r
LEFT JOIN (
	SELECT strTrainingMethod, strType, strSystemId, strValue, MAX(fltProbability) * 1.1 AS maxProbability
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
       r.fltProbability
FROM NaiveBayes..mappingResults r
WHERE r.fltProbability IS NULL

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
LEFT JOIN (
	SELECT strTrainingMethod, strType, strSystemId, strValue, MAX(fltProbability) * 1.01 AS maxProbability
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
       r.fltProbability
FROM NaiveBayes..mappingResults r
WHERE r.fltProbability IS NULL