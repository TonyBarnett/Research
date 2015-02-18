CREATE PROCEDURE runRAS @BatchNumber int
AS 
BEGIN
	IF NOT EXISTS ( SELECT COUNT(*) FROM sourceData WHERE intBatchNumber=@BatchNumber)
	BEGIN
		RAISERROR('batch number doesn''t exist', 20,1)
	END
	
	CREATE TABLE #data (
		intFrom  int NOT NULL,
		intTo    int NOT NULL,
		fltvalue float   NULL,
		
		CONSTRAINT dpk PRIMARY KEY (intFrom, intTo)
	)
	
	CREATE TABLE #distinctValues (
		intIndex int         NOT NULL,
		strType  varchar(8)  NOT NULL,
		strValue varchar(16) NOT NULL,
		
		CONSTRAINT vpk PRIMARY KEY (intIndex, strType)
	)
	
	-- Convert the product and industry indices to integers
	INSERT INTO #distinctValues (intIndex, strType, strValue)
	SELECT ROW_NUMBER() OVER (PARTITION BY strProductId ORDER BY strProductId) 'row', strProductId
	FROM sourceData
	GROUP BY strProductId
	
	INSERT INTO #distinctValues (intIndex, strType, strValue)
	SELECT ROW_NUMBER() OVER (PARTITION BY strIndustryId ORDER BY strIndustryId) 'column', strIndustryId
	FROM sourceData
	GROUP BY strIndustryId
	
	
	INSERT INTO #data (intFrom, intTo, fltvalue)
	SELECT row.intIndex, col.intIndex, fltValue
	FROM sourceData data
		LEFT JOIN #distinctValues row ON row.strType = 'row' AND row.strValue = data.strProductId
		LEFT JOIN #distinctValues col ON col.strType = 'column' AND col.strValue = data.strIndustryId
	WHERE intBatchNumber = @BatchNumber

	DROP TABLE #data
	DROP TABLE #distinctValues
END