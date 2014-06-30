EXEC sys.sp_configure
    @configname = 'clr enabled',
    @configvalue = 1;
RECONFIGURE;

--BREAK--Command for SQL runner.
CREATE ASSEMBLY SQLFunctions
FROM 'C:\Custom-CLR-Functions\Cloudbuy.SQLFunctions.dll'
WITH PERMISSION_SET = SAFE;

--BREAK--Command for SQL runner.
CREATE AGGREGATE dbo.STRING_JOIN (@value nvarchar(max)) RETURNS nvarchar(max)
EXTERNAL NAME SQLFunctions.[CloudBuy.SQLFunctions.StringJoin];


--DROP FUNCTION dbo.STRING_SPLIT;

--DROP ASSEMBLY SqlFunctions;
--BREAK--Command for SQL runner .
--CREATE ASSEMBLY SQLFunctions
--FROM 'C:\Custom-CLR-Functions\Cloudbuy.SQLFunctions.dll'
--WITH PERMISSION_SET = SAFE;

--CREATE AGGREGATE dbo.STRING_JOIN (@value nvarchar(max)) RETURNS nvarchar(max)
--EXTERNAL NAME SQLFunctions.[CloudBuy.SQLFunctions.StringJoin];

----BREAK--Command for SQL runner.
--CREATE FUNCTION dbo.STRING_SPLIT
--    (@Input nvarchar(max), @Delimiter nvarchar(max))
--RETURNS TABLE
--    (strValue nvarchar(MAX), lngIndex int)
--AS
--EXTERNAL NAME SQLFunctions.[CloudBuy.SQLFunctions.Split].SplitString_Multi;