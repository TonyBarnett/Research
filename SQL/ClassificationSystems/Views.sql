CREATE VIEW AncestorValues
AS
WITH cteAncestorOrSelf AS (
	SELECT strSystemId, strValue, strValue AS strAncestor, 0 AS intBlob FROM clasValue
	
	UNION ALL
	
	SELECT cte.strSystemId, cte.strValue, v.strParent, intBlob + 1
	FROM cteAncestorOrSelf cte
		INNER JOIN clasValue v ON cte.strSystemId = v.strSystemId AND cte.strAncestor = v.strValue
)
SELECT * 
FROM cteAncestorOrSelf



CREATE VIEW MapMissingValues
AS
SELECT *
FROM (
	SELECT a.strSystemId, a.strValue, a.strAncestor, m.*,
		RANK() OVER (PARTITION BY a.strSystemId, a.strValue, m.strSystem2Id ORDER BY a.intBlob) AS intLevel
	FROM AncestorValues a
		INNER JOIN PotentialMatches2 m ON m.strSystem1Id = a.strSystemId AND m.strSystem1Value = a.strAncestor
) s
WHERE s.intLevel = 1