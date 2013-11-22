CREATE PROCEDURE MendeleyPaperAdd @PaperId AS int
AS 
BEGIN 
	INSERT INTO Paper (intYear, strTitle, strType, strPublication)
	SELECT intYear, strTitle, strType, strPublication
	FROM MendeleyPaper m
	WHERE intId = @PaperId AND
		NOT EXISTS (
			SELECT NULL
			FROM PaperMendeleyPaper p
			WHERE p.intMendeleyPaperId = m.intId
		)
		
	DECLARE @NewId AS int = SCOPE_IDENTITY()

	-- If you try and re-enter a paper no insert will 
	-- occur so no new identity...
	IF @NewId IS NOT NULL
	BEGIN
		INSERT INTO PaperMendeleyPaper (intMendeleyPaperId, intPaperId)
		VALUES (@PaperId, @NewId)
		
		INSERT INTO Author (strAuthor)
		SELECT m.strAuthor
		FROM MendeleyAuthor m
		WHERE intMendeleyPaperId = @PaperId AND 
			NOT EXISTS(
				SELECT NULL 
				FROM Author a
				WHERE a.strAuthor = m.strAuthor
			)
		INSERT INTO Paper_Author (intPaperId, strAuthor)
		SELECT @NewId, strAuthor
		FROM MendeleyAuthor
		WHERE intMendeleyPaperId = @PaperId
	END
END