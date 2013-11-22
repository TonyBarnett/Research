CREATE PROCEDURE AuthorAdd @Author AS varchar(64), @PaperId AS int
AS
BEGIN
	IF NOT EXISTS
	(
		SELECT NULL
		FROM Author
		WHERE strAuthor = @Author
	)
	BEGIN
		INSERT INTO Author(strAuthor)
		VALUES(@Author)
	END
	
	INSERT INTO Paper_Author(intPaperId, strAuthor)
	VALUES(@PaperId, @Author)
END