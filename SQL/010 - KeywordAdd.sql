CREATE PROCEDURE KeywordAdd @Keyword AS varchar(64), @PaperId AS int
AS
BEGIN
	IF NOT EXISTS
	(
		SELECT NULL
		FROM Keyword
		WHERE strKeyword = @Keyword
	)
	BEGIN
		INSERT INTO Keyword(strKeyword)
		VALUES(@Keyword)
	END
	
	INSERT INTO Paper_Keyword(intPaperId, strKeyword)
	VALUES(@PaperId, @Keyword)
END