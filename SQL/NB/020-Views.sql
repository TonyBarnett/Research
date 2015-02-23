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
	SELECT strSystemId, strValue, MAX(fltProbability) * 1.1 AS maxProbability
	FROM NaiveBayes..mappingResults
	GROUP BY strSystemId, strValue
) m ON m.strSystemId = r.strSystemId AND m.strValue = r.strValue AND m.maxProbability <= r.fltProbability

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
	SELECT strSystemId, strValue, MAX(fltProbability) * 1.01 AS maxProbability
	FROM NaiveBayes..mappingResults
	GROUP BY strSystemId, strValue
) m ON m.strSystemId = r.strSystemId AND m.strValue = r.strValue AND m.maxProbability <= r.fltProbability
