SELECT 
	f.intCategoryId AS itnFrom, 
	t.intCategoryId AS intTo, 
	CASE 
		WHEN x.monTotalTotal = 0 THEN 0
		ELSE SUM(a.monTotal) / x.monTotalTotal
	END AS monTotal
FROM A a
	INNER JOIN ABMap f ON f.strA = a.strSic2007From
	INNER JOIN ABMap t ON t.strA = a.strSic2007To
	INNER JOIN (
		SELECT a.strSic2007From, SUM(monTotal) AS monTotalTotal
		FROM A
		GROUP BY a.strSic2007From
	) x ON x.strSic2007From = a.strSic2007From
GROUP BY f.intCategoryId, t.intCategoryId, x.monTotalTotal
ORDER BY 1,2

SELECT m.intCategoryId, 
SUM(b.fltCO2)
FROM B b
	INNER JOIN ABMap m ON m.strB = b.strSic2007
GROUP BY m.intCategoryId

SELECT i.intCategoryId, MIN(b.strDescription), MIN(i.fltIntensitiy)
FROM Intensity i
	INNER JOIN ABMap m ON m.intCategoryId = i.intCategoryId
	LEFT JOIN B b ON b.strSic2007 = m.strB
GROUP BY  i.intCategoryId
ORDER BY 1