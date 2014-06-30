CREATE PROCEDURE GetSynonyms @casedWord varchar(256)
AS 
BEGIN
   	SELECT w.lemma, w2.lemma, lt.link
 	FROM words w
 		INNER JOIN senses   sen  ON sen.wordid    = w.wordid
 		INNER JOIN synsets  syn  ON syn.synsetid  = sen.synsetid
 		INNER JOIN semlinks l    ON l.synset1id   = syn.synsetid
 		INNER JOIN synsets  syn2 ON syn2.synsetid = l.synset2id 		
		INNER JOIN senses   sen2 ON sen2.synsetid = syn2.synsetid
 		INNER JOIN words    w2   ON w2.wordid     = sen2.wordid
 		INNER JOIN linktypes lt  ON lt.linkid = l.linkid
 	WHERE w.lemma = @casedWord
 	
 	UNION 
 	
 	SELECT w.lemma, t.lemma, 'Synonym'
	FROM words w
		INNER JOIN senses s ON s.wordid = w.wordid
		INNER JOIN senses ss ON ss.synsetid = s.synsetid
		INNER JOIN words t ON t.wordid = ss.wordid
	WHERE w.wordid < t.wordid
		AND w.lemma = @casedWord
END

--BREAK--Command for SQL runner.

CREATE PROCEDURE GetWeightedSynonymCount @WordWeighing float, @SynonymWeighting float, @Threshold float
AS
SELECT *, @Threshold AS fltThreshold, fltWordSimilarity * @WordWeighing + fltSynonymSimilarity * @SynonymWeighting AS fltWeighting
FROM CrapDump..MatchGuess m
WHERE (fltWordSimilarity * @WordWeighing + fltSynonymSimilarity * @SynonymWeighting) > @Threshold