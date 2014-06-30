CREATE VIEW samplesets AS 
SELECT synsetid,
	dbo.STRING_JOIN(DISTINCT samples.sample) AS sampleset 
FROM samples GROUP BY synsetid
--BREAK--Command for SQL runner.
CREATE VIEW sensesXsynsets AS 
SELECT se.wordid,
       se.casedwordid,
       se.synsetid,
       se.senseid,
       se.sensenum,
       se.lexid,
       se.tagcount,
       se.sensekey,
       s.synsetid AS ssynsetid,
       s.pos,
       s.lexdomainid
FROM senses se 
	INNER JOIN synsets s ON s.synsetid = se.synsetid
--BREAK--Command for SQL runner.
CREATE VIEW wordsXsenses AS 
SELECT  w.wordid,
        w.lemma,
        se.wordid AS sewordid,
        se.casedwordid,
        se.synsetid,
        se.senseid,
        se.sensenum,
        se.lexid,
        se.tagcount,
        se.sensekey
FROM words w 
	INNER JOIN senses se ON se.wordid = w.wordid
--BREAK--Command for SQL runner.
CREATE VIEW wordsXsensesXsynsets AS 
SELECT  w.wordid,
        w.lemma,
        se.wordid AS sewordid,
        se.casedwordid,
        se.synsetid,
        se.senseid,
        se.sensenum,
        se.lexid,
        se.tagcount,
        se.sensekey,
        s.synsetid AS ssynsetid,
        s.pos,
        s.lexdomainid
FROM dbo.words w 
	INNER JOIN dbo.senses se ON se.wordid = w.wordid
	INNER JOIN dbo.synsets s ON s.synsetid = se.synsetid
--BREAK--Command for SQL runner.
CREATE VIEW adjectiveswithpositions AS 
SELECT  se.wordid AS sewordid,
        se.casedwordid,
        se.synsetid AS sesynsetid,
        se.senseid,
        se.sensenum,
        se.lexid,
        se.tagcount,
        se.sensekey,
        a.synsetid,
        a.wordid,
        a.position,
        w.wordid AS wwordid,
        w.lemma,
        s.synsetid AS ssynsetid,
        s.pos,
        s.lexdomainid
FROM dbo.senses se 
	INNER JOIN dbo.adjpositions a ON a.wordid = se.wordid AND a.synsetid = se.synsetid
	LEFT JOIN dbo.words w ON w.wordid = se.wordid
	LEFT JOIN dbo.synsets s ON s.synsetid = se.synsetid
--BREAK--Command for SQL runner.
CREATE VIEW dict AS 
SELECT  w.wordid AS wwordid,
        w.lemma,
        se.wordid AS sewordid,
        se.casedwordid AS secasedwordid,
        se.synsetid AS sesynsetid,
        se.senseid,
        se.sensenum,
        se.lexid,
        se.tagcount,
        se.sensekey,
        c.casedwordid,
        c.wordid,
        c.cased,
        s.synsetid AS ssynsetid,
        s.pos,
        s.lexdomainid,
        ss.synsetid,
        ss.sampleset 
FROM dbo.words w 
	LEFT JOIN dbo.senses se ON se.wordid = w.wordid
	LEFT JOIN dbo.casedwords c ON c.wordid = se.wordid AND c.casedwordid = se.casedwordid 
	LEFT JOIN dbo.synsets s ON s.synsetid = se.synsetid 
	LEFT JOIN dbo.samplesets ss ON ss.synsetid = s.synsetid
--BREAK--Command for SQL runner.
CREATE VIEW morphology AS 
SELECT  w.wordid AS wwordid,
        w.lemma,
        mm.wordid,
        mm.pos,
        mm.morphid,
        m.morphid AS mmorphid,
        m.morph
FROM dbo.words w 
	INNER JOIN dbo.morphmaps mm ON mm.wordid = w.wordid
 	INNER JOIN dbo.morphs m ON m.morphid = mm.morphid 
--BREAK--Command for SQL runner.
CREATE VIEW sensesXlexlinksXsenses AS 
SELECT linkid,
	s.synsetid AS ssynsetid,
	s.wordid AS swordid,
	s.senseid AS ssenseid,
	s.casedwordid AS scasedwordid,
	s.sensenum AS ssensenum,
	s.lexid AS slexid,
	s.tagcount AS stagcount,
	s.sensekey AS ssensekey,
	s.pos AS spos,
	s.lexdomainid AS slexdomainid,
	d.synsetid AS dsynsetid,
	d.wordid AS dwordid,
	d.senseid AS dsenseid,
	d.casedwordid AS dcasedwordid,
	d.sensenum AS dsensenum,
	d.lexid AS dlexid,
	d.tagcount AS dtagcount,
	d.sensekey AS dsensekey,
	d.pos AS dpos,
	d.lexdomainid AS dlexdomainid
FROM sensesXsynsets s
	INNER JOIN lexlinks AS l ON s.synsetid = l.synset1id AND s.wordid = l.word1id 
	INNER JOIN sensesXsynsets d ON l.synset2id = d.synsetid AND l.word2id = d.wordid
--BREAK--Command for SQL runner.
CREATE VIEW sensesXsemlinksXsenses AS 
SELECT linkid,
	s.synsetid AS ssynsetid,
	s.wordid AS swordid,
	s.senseid AS ssenseid,
	s.casedwordid AS scasedwordid,
	s.sensenum AS ssensenum,
	s.lexid AS slexid,
	s.tagcount AS stagcount,
	s.sensekey AS ssensekey,
	s.pos AS spos,
	s.lexdomainid AS slexdomainid,
	d.synsetid AS dsynsetid,
	d.wordid AS dwordid,
	d.senseid AS dsenseid,
	d.casedwordid AS dcasedwordid,
	d.sensenum AS dsensenum,
	d.lexid AS dlexid,
	d.tagcount AS dtagcount,
	d.sensekey AS dsensekey,
	d.pos AS dpos,
	d.lexdomainid AS dlexdomainid
FROM sensesXsynsets s 
	INNER JOIN semlinks AS l ON s.synsetid = l.synset1id 
	INNER JOIN sensesXsynsets d ON l.synset2id = d.synsetid
--BREAK--Command for SQL runner.
CREATE VIEW sXsemlinksXsynsets AS 
SELECT linkid,
	s.synsetid AS ssynsetid,
	d.synsetid AS dsynsetid
FROM synsets s 
	INNER JOIN semlinks AS l ON s.synsetid = l.synset1id 
	INNER JOIN synsets d ON l.synset2id = d.synsetid
--BREAK--Command for SQL runner.
CREATE VIEW verbswithframes AS 
SELECT  se.wordid AS sewordid,
        se.casedwordid,
        se.synsetid AS sesynsetid,
        se.senseid,
        se.sensenum,
        se.lexid,
        se.tagcount,
        se.sensekey,
        vm.synsetid,
        vm.wordid,
        vm.frameid,
        v.frameid AS vframeid,
        v.frame,
        w.wordid AS wwordid,
        w.lemma,
        s.synsetid AS ssynsetid,
        s.pos,
        s.lexdomainid
FROM dbo.senses se 
	INNER JOIN dbo.vframemaps vm ON vm.wordid = se.wordid  AND vm.synsetid = se.synsetid 
	INNER JOIN dbo.vframes v ON v.frameid = vm.frameid 
	LEFT JOIN dbo.words w ON w.wordid = se.wordid 
	LEFT JOIN dbo.synsets s ON s.synsetid = se.synsetid
