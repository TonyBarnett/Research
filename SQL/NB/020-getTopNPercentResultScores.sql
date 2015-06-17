CREATE PROCEDURE dbo.getTopNPercentResultScores (@N float)
AS
BEGIN
	SELECT r.strTrainingMethod, r.strType, r.strSystemId, r.strValue, r.strGuess
	INTO #Guesses
	FROM dbo.getTopNPercentResults(@N) r
		INNER JOIN ClassificationSystems..ManualMatches m ON m.strSystem1Id = r.strSystemId AND m.strSystem1Value = r.strValue
		
	SELECT m.strSystem1Id, m.strSystem1Value, m.strSystem2Value, strTrainingMethod, strType
	INTO #ManualMaps
	FROM ClassificationSystems..ManualMatches m
		CROSS APPLY (
			SELECT strTrainingMethod, strType
			FROM #Guesses
			GROUP BY strTrainingMethod, strType
		) g



	SELECT COALESCE(AnB.strTrainingMethod, AuB.strTrainingMethod), 
		COALESCE(AnB.strType, AuB.strType),
		SUM(COALESCE(AnB.fltIntersect, 0)/ COALESCE(AuB.fltUnion, 0)),
		AVG(COALESCE(AnB.fltIntersect, 0)/ COALESCE(AuB.fltUnion, 0))
	FROM (
		SELECT i.strTrainingMethod, i.strType, i.strSystemId, i.strValue, CAST(COUNT(*) AS float) AS fltIntersect
		FROM (
			SELECT g.strTrainingMethod, g.strType, g.strSystemId, g.strValue, g.strGuess
			FROM #Guesses g
				INNER JOIN #ManualMaps mm
					ON mm.strTrainingMethod = g.strTrainingMethod 
						AND mm.strType = g.strType 
						AND mm.strSystem1Id = g.strSystemId
						AND mm.strSystem1Value = g.strValue
						AND mm.strSystem2Value = g.strGuess
			GROUP BY g.strTrainingMethod, g.strType, g.strSystemId, g.strValue, g.strGuess
		) AS i
		GROUP BY i.strTrainingMethod, i.strType, i.strSystemId, i.strValue
	) AnB
	FULL JOIN (
		SELECT u.strTrainingMethod, u.strType, u.strSystemId, u.strValue, CAST(COUNT(*) AS float) AS fltUnion
		FROM (
			SELECT strTrainingMethod, strType, strSystemId, strValue, strGuess 
			FROM #Guesses

			UNION 

			SELECT strTrainingMethod, strType, strSystem1Id, strSystem1Value, strSystem2Value
			FROM #ManualMaps
		) AS u
		GROUP BY u.strTrainingMethod, u.strType, u.strSystemId, u.strValue
	) AuB 
		ON AuB.strTrainingMethod = AnB.strTrainingMethod
			AND AuB.strType = AnB.strType
			AND AuB.strSystemId = AnB.strSystemId
			AND AuB.strValue = AnB.strValue
	GROUP BY COALESCE(AnB.strTrainingMethod, AuB.strTrainingMethod), 
		COALESCE(AnB.strType, AuB.strType)
	ORDER BY 3 DESC


	DROP TABLE #Guesses
	DROP TABLE #ManualMaps
END