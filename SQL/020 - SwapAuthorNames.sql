CREATE FUNCTION dbo.SwapAuthorNames(@Author varchar(64))
RETURNS varchar(64)
AS
BEGIN
	DECLARE @returnAuthor AS varchar(64)
	DECLARE @LastSpace AS int
	
	SELECT @LastSpace = CHARINDEX(' ', REVERSE(@Author), 0)
	
	SELECT @LastSpace = 
	CASE WHEN 
			RIGHT(LEFT(@Author, LEN(@Author) - @lastSpace), 3) = 'von' THEN 
				CHARINDEX(' ', REVERSE(@Author), 0) + 3
				ELSE
				@LastSpace
		END
		
	SELECT @returnAuthor = RIGHT(@Author, @LastSpace)
	
	RETURN @returnAuthor + ', ' + LEFT(@Author, LEN(@Author) - @lastSpace)
END