CREATE PROCEDURE dbo.AddMissingValuesFromParent
AS
BEGIN
	SELECT *
	INTO #missing
	FROM clasValue v
	WHERE v.strSystemId != 'Censa123' AND 
		NOT EXISTS (
			SELECT NULL
			FROM PotentialMatches p
			WHERE p.strSystem1Id = v.strSystemId AND p.strSystem1Value = v.strValue
		)
		

	INSERT INTO PotentialMatches (strSystem1Id, strSystem1Value, strSystem2Id, strSystem2Value, fltWeight)
	SELECT DISTINCT v.strSystemId, v.strValue, 'Censa123',
		COALESCE(pm.strSystem2Value, pmm.strSystem2Value, pmmm.strSystem2Value),
		COALESCE(pm.fltWeight, pmm.fltWeight, pmmm.fltWeight)
	FROM #missing v
		INNER JOIN clasValue vp ON vp.strSystemId = v.strSystemId AND vp.strValue = v.strParent
		LEFT JOIN clasValue vpp ON vpp.strSystemId = vp.strSystemId AND vpp.strValue = vp.strParent
		LEFT JOIN clasValue vppp ON vppp.strSystemId = vpp.strSystemId AND vppp.strValue = vpp.strParent
		LEFT JOIN PotentialMatches pm ON pm.strSystem1Id = v.strSystemId AND pm.strSystem1Value = vp.strValue
		LEFT JOIN PotentialMatches pmm ON pmm.strSystem1Id = v.strSystemId AND pmm.strSystem1Value = vpp.strValue
		LEFT JOIN PotentialMatches pmmm ON pmmm.strSystem1Id = v.strSystemId AND pmmm.strSystem1Value = vppp.strValue
		LEFT JOIN clasValue c ON c.strSystemId = 'Censa123' AND c.strValue = pm.strSystem2Value

	DROP TABLE #missing
END