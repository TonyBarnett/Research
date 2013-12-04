CREATE TRIGGER ABMapInsertTRG ON ABMap
INSTEAD OF INSERT
AS 
BEGIN
	INSERT INTO Category(intId) 
	SELECT intCategoryId
	FROM INSERTED i
	WHERE NOT EXISTS (
		SELECT NULL 
		FROM Category c
		WHERE c.intId = i.intCategoryId
	)
	
	
	INSERT INTO ABMap(strA, strB, intCategoryId,strDescription) 
	SELECT strA, strB, intCategoryId, strDescription
	FROM INSERTED
END