DECLARE @index int = 1
DECLARE @rowCount int = 0
DECLARE @Year int = 2010
DECLARE @value float = 0.0
DECLARE @counter int= 0

CREATE TABLE #a(
	intFrom  int   NOT NULL,
	intTo    int   NOT NULL,
	monTotal float NOT NULL,
	CONSTRAINT apk PRIMARY KEY (intFrom, intTo)
)

CREATE TABLE #I(
	intFrom  int   NOT NULL,
	intTo    int   NOT NULL,
	monTotal float NOT NULL,
	CONSTRAINT ipk PRIMARY KEY (intFrom, intTo)
)

INSERT INTO #a
SELECT f.intCategoryId AS intFrom, 
	t.intCategoryId AS intTo, 
	CASE WHEN F.intCategoryId = t.intCategoryId 
		THEN SUM(1-a.monTotal) 
		ELSE SUM(a.monTotal) 
	END AS monTotal
FROM A a
	INNER JOIN (
		SELECT DISTINCT strA, intCategoryId
		FROM ABMap m
	) f ON f.strA = a.strSic2007From
	INNER JOIN (
		SELECT DISTINCT strA, intCategoryId
		FROM ABMap m
	) t ON t.strA = a.strSic2007To
WHERE a.intYear = @Year
GROUP BY f.intCategoryId, t.intCategoryId

INSERT INTO #I
SELECT intFrom, intTo, CASE WHEN intFrom = intTo THEN 1 ELSE 0 END AS monTotal
FROM #a


SELECT @rowCount = COUNT(*) + 1
FROM #a a
GROUP BY a.intFrom

-- Loop over each column
WHILE @index != @rowCount
BEGIN
	SELECT @value = monTotal
	FROM #a
	WHERE intFrom = @index AND intTo = @index
	
	IF @value != 0
		BEGIN
		UPDATE #a SET monTotal = monTotal / @value
		WHERE intFrom = @index
		
		UPDATE #I SET monTotal = monTotal / @value
		WHERE intFrom = @index
	END
	ELSE IF @value = 0
	BEGIN
		-- if (i,j) = 0 then find a cell (i, blah) that isn't and add to make it 0
		SELECT @counter = @index
		
		-- Find a row that has a non 0 value in the required column
		WHILE @value = 0 AND @counter < @rowCount
		BEGIN
			SELECT @counter = @counter + 1
			
			SELECT @value = monTotal
			FROM #a
			WHERE intFrom = @counter
				AND intTo = @index
		END

		
		-- Then add that row to the @index row and divide by that value
		UPDATE a SET a.monTotal = (a.monTotal + b.monTotal) / @value
		FROM #a a
			INNER JOIN #a b ON b.intTo = a.intTo
		WHERE a.intFrom = @index AND b.intFrom = @counter
		
		-- Also on (what was) the indentity matrix
		UPDATE a SET a.monTotal = (a.monTotal + b.monTotal) / @value
		FROM #I a
			INNER JOIN #I b ON b.intTo = a.intTo
		WHERE a.intFrom = @index AND b.intFrom = @counter
		
	END
	
	SELECT @counter = @index + 1
	
	WHILE @counter < @rowCount
	BEGIN	
	
		SELECT @value = monTotal
		FROM #a
		WHERE intFrom = @counter AND intTo = @index

		IF @value != 0
		BEGIN
			UPDATE a SET a.monTotal = a.monTotal - (b.monTotal * @value)
			FROM #a a 
				INNER JOIN #a b ON b.intFrom = @index AND b.intTo = a.intTo
			WHERE a.intFrom = @counter
			
			UPDATE a SET a.monTotal = a.monTotal - (b.monTotal * @value)
			FROM #I a 
				INNER JOIN #I b ON b.intFrom = @index AND b.intTo = a.intTo
			WHERE a.intFrom = @counter
		END
		SELECT @counter = @counter + 1
	END
	SELECT @index = @index +1
END

SELECT @index = @rowCount - 1

WHILE @index > 0
BEGIN
	SELECT @counter = @index - 1
	WHILE @counter > 0
	BEGIN

		SELECT @value = b.monTotal
		FROM #a a
			INNER JOIN #a b ON b.intTo = a.intTo AND b.intTo = a.intFrom
		WHERE a.intFrom = @index AND b.intFrom = @counter
		
		UPDATE b SET b.monTotal = b.monTotal - a.monTotal * @value
		FROM #a a
			INNER JOIN #a b ON b.intTo = a.intTo
		WHERE a.intFrom = @index AND b.intFrom = @counter
		
		
		UPDATE b SET b.monTotal = b.monTotal - a.monTotal * @value
		FROM #I a
			INNER JOIN #I b ON b.intTo = a.intTo
		WHERE a.intFrom = @index AND b.intFrom = @counter
		
		
		SELECT @counter = @Counter - 1
	END
	SELECT @index = @index - 1
END

SELECT *
FROM #a
ORDER BY intFrom, intTo

SELECT *
FROM #I
ORDER BY intFrom, intTo

DROP TABLE #a
DROP TABLE #I
