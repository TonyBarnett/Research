CREATE PROCEDURE AuthorGet @PaperId AS int
AS
BEGIN
	SELECT intId AS PaperId, strTitle AS PaperTitle
	FROM Paper
	WHERE intId = @PaperId
END