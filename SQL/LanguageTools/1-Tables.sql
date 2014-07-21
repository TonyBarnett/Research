IF EXISTS (SELECT NULL FROM sys.tables WHERE name = 'linkTypeExample' ) BEGIN DROP TABLE lexlinks END
IF EXISTS (SELECT NULL FROM sys.tables WHERE name = 'lexlinks' ) BEGIN DROP TABLE lexlinks END
IF EXISTS (SELECT NULL FROM sys.tables WHERE name = 'semlinks' ) BEGIN DROP TABLE semlinks END
IF EXISTS (SELECT NULL FROM sys.tables WHERE name = 'senses') BEGIN DROP TABLE senses END
IF EXISTS (SELECT NULL FROM sys.tables WHERE name = 'adjpositions') BEGIN DROP TABLE adjpositions END
IF EXISTS (SELECT NULL FROM sys.tables WHERE name = 'vframesentencemaps' ) BEGIN DROP TABLE vframesentencemaps END
IF EXISTS (SELECT NULL FROM sys.tables WHERE name = 'vframemaps' ) BEGIN DROP TABLE vframemaps END
IF EXISTS (SELECT NULL FROM sys.tables WHERE name = 'samples' ) BEGIN DROP TABLE samples END
IF EXISTS (SELECT NULL FROM sys.tables WHERE name = 'morphmaps' ) BEGIN DROP TABLE morphmaps END
IF EXISTS (SELECT NULL FROM sys.tables WHERE name = 'synsets' ) BEGIN DROP TABLE synsets END
IF EXISTS (SELECT NULL FROM sys.tables WHERE name = 'casedwords' ) BEGIN DROP TABLE casedwords END
IF EXISTS (SELECT NULL FROM sys.tables WHERE name = 'adjpositiontypes' ) BEGIN DROP TABLE adjpositiontypes END
IF EXISTS (SELECT NULL FROM sys.tables WHERE name = 'vframesentences' ) BEGIN DROP TABLE vframesentences END
IF EXISTS (SELECT NULL FROM sys.tables WHERE name = 'vframes' ) BEGIN DROP TABLE vframes END
IF EXISTS (SELECT NULL FROM sys.tables WHERE name = 'morphs' ) BEGIN DROP TABLE morphs END
IF EXISTS (SELECT NULL FROM sys.tables WHERE name = 'lexdomains' ) BEGIN DROP TABLE lexdomains END
IF EXISTS (SELECT NULL FROM sys.tables WHERE name = 'postypes' ) BEGIN DROP TABLE postypes END
IF EXISTS (SELECT NULL FROM sys.tables WHERE name = 'linktypes' ) BEGIN DROP TABLE linktypes END
IF EXISTS (SELECT NULL FROM sys.tables WHERE name = 'words' ) BEGIN DROP TABLE words END

CREATE TABLE words (
  wordid int NOT NULL DEFAULT 0,
  lemma  varchar(80)  NOT NULL UNIQUE,
  
  CONSTRAINT words_PK PRIMARY KEY (wordid)
)

CREATE TABLE linktypes (
  linkid   int         NOT NULL DEFAULT 0,
  link     varchar(50)     NULL,
  recurses int         NOT NULL DEFAULT 0,
  
  CONSTRAINT linktypes_PK PRIMARY KEY (linkid)
)
CREATE TABLE postypes (
  pos char(1) NOT NULL,
  posname varchar(20) NOT NULL,
  
  CONSTRAINT postypes_PK PRIMARY KEY (pos)
)

CREATE TABLE lexdomains (
  lexdomainid int NOT NULL DEFAULT 0,
  lexdomainname varchar(32) NULL,
  lexdomain varchar(32) NULL,
  pos char(1)          NULL,
  
  CONSTRAINT lexdomains_PK PRIMARY KEY (lexdomainid)
)

CREATE TABLE morphs (
  morphid int NOT NULL DEFAULT 0,
  morph varchar(70) NOT NULL UNIQUE,
  
  CONSTRAINT morphs_PK PRIMARY KEY (morphid)
)

CREATE TABLE vframes (
  frameid int NOT NULL DEFAULT 0,
  frame varchar(50) DEFAULT NULL,
  
  CONSTRAINT vframes_PK PRIMARY KEY (frameid)
)

CREATE TABLE vframesentences (
  sentenceid int NOT NULL DEFAULT 0,
  sentence varchar(256) NULL,
  
  CONSTRAINT vframesentences_PK PRIMARY KEY (sentenceid)
)

CREATE TABLE adjpositiontypes (
  position varchar(8) NOT NULL,
  positionname varchar(24) NOT NULL,
  
  CONSTRAINT adjpositiontypes_PK PRIMARY KEY (position)
)

CREATE TABLE casedwords (
  casedwordid int NOT NULL DEFAULT 0,
  wordid      int NOT NULL DEFAULT 0,
  cased       varchar(80)  NOT NULL UNIQUE,
  
  CONSTRAINT casedwords_PK PRIMARY KEY (casedwordid),
  CONSTRAINT  fk_casedwords_wordid FOREIGN KEY (wordid) REFERENCES words (wordid)
)

CREATE TABLE synsets (
  synsetid    int NOT NULL DEFAULT 0,
  pos         char(1)      NOT NULL,
  lexdomainid int          NOT NULL DEFAULT 0,
  definition  varchar(512)     NULL,
  
  CONSTRAINT synsets_PK PRIMARY KEY (synsetid),
  CONSTRAINT fk_synsets_lexdomainid FOREIGN KEY (lexdomainid) REFERENCES lexdomains (lexdomainid)
)

CREATE TABLE morphmaps (
  wordid    int NOT NULL DEFAULT 0,
  pos char(1) NOT NULL DEFAULT 'n',
  morphid int NOT NULL DEFAULT 0,

  CONSTRAINT morphmaps_PK PRIMARY KEY (morphid,pos,wordid),
  CONSTRAINT fk_morphmaps_morphid FOREIGN KEY (morphid) REFERENCES morphs (morphid),
  CONSTRAINT fk_morphmaps_wordid FOREIGN KEY (wordid) REFERENCES words (wordid)
)

CREATE TABLE samples (
  synsetid    int NOT NULL DEFAULT 0,
  sampleid int NOT NULL DEFAULT 0,
  sample varchar(512) NOT NULL,
  
  CONSTRAINT samples_PK PRIMARY KEY (synsetid,sampleid),
  CONSTRAINT fk_samples_synsetid FOREIGN KEY (synsetid) REFERENCES synsets (synsetid)
)

CREATE TABLE vframemaps (
  synsetid    int NOT NULL DEFAULT 0,
  wordid    int NOT NULL DEFAULT 0,
  frameid int NOT NULL DEFAULT 0,
  
  CONSTRAINT vframemaps_PK PRIMARY KEY (synsetid,wordid,frameid),
  CONSTRAINT fk_vframemaps_frameid FOREIGN KEY (frameid) REFERENCES vframes (frameid),
  CONSTRAINT fk_vframemaps_synsetid FOREIGN KEY (synsetid) REFERENCES synsets (synsetid),
  CONSTRAINT fk_vframemaps_wordid FOREIGN KEY (wordid) REFERENCES words (wordid)
)


CREATE TABLE vframesentencemaps (
  synsetid    int NOT NULL DEFAULT 0,
  wordid    int NOT NULL DEFAULT 0,
  sentenceid int NOT NULL DEFAULT 0,
  
  CONSTRAINT vframesentencemaps_PK PRIMARY KEY (synsetid,wordid,sentenceid),
  CONSTRAINT  fk_vframesentencemaps_sentenceid FOREIGN KEY (sentenceid) REFERENCES vframesentences (sentenceid),
  CONSTRAINT  fk_vframesentencemaps_synsetid FOREIGN KEY (synsetid) REFERENCES synsets (synsetid),
  CONSTRAINT  fk_vframesentencemaps_wordid FOREIGN KEY (wordid) REFERENCES words (wordid),

)

CREATE TABLE adjpositions (
  synsetid    int NOT NULL DEFAULT 0,
  wordid    int NOT NULL DEFAULT 0,
  position varchar(8) NOT NULL,
  
  CONSTRAINT adjpositions_PK PRIMARY KEY (synsetid,wordid),
  CONSTRAINT fk_adjpositions_synsetid FOREIGN KEY (synsetid) REFERENCES synsets (synsetid),
  CONSTRAINT fk_adjpositions_wordid FOREIGN KEY (wordid) REFERENCES words (wordid)

)

CREATE TABLE senses (
  wordid      int NOT NULL DEFAULT 0,
  casedwordid varchar(128)     NULL,
  synsetid    int NOT NULL DEFAULT 0,
  senseid     int     NULL UNIQUE,
  sensenum    int          NOT NULL DEFAULT 0,
  lexid       int          NOT NULL DEFAULT 0,
  tagcount    int     NULL,
  sensekey    varchar(100)     NULL UNIQUE,
  
  CONSTRAINT senses_PK PRIMARY KEY (wordid,synsetid),
  CONSTRAINT fk_senses_synsetid FOREIGN KEY (synsetid) REFERENCES synsets (synsetid),
  CONSTRAINT fk_senses_wordid FOREIGN KEY (wordid) REFERENCES words (wordid)

)

CREATE TABLE semlinks (
  synset1id int NOT NULL DEFAULT 0,
  synset2id int NOT NULL DEFAULT 0,
  linkid    int          NOT NULL DEFAULT 0,
  
  CONSTRAINT semlinks_PK PRIMARY KEY (synset1id, synset2id, linkid),
  CONSTRAINT fk_semlinks_linkid FOREIGN KEY (linkid) REFERENCES linktypes (linkid),
  CONSTRAINT fk_semlinks_synset1id FOREIGN KEY (synset1id) REFERENCES synsets (synsetid),
  CONSTRAINT fk_semlinks_synset2id FOREIGN KEY (synset2id) REFERENCES synsets (synsetid)

)

CREATE TABLE lexlinks (
  synset1id int NOT NULL DEFAULT 0,
  word1id   int NOT NULL DEFAULT 0,
  synset2id int NOT NULL DEFAULT 0,
  word2id   int NOT NULL DEFAULT 0,
  linkid    int          NOT NULL DEFAULT 0,
  
  CONSTRAINT lexlinks_PK PRIMARY KEY (word1id,synset1id,word2id,synset2id,linkid),
  CONSTRAINT fk_lexlinks_linkid FOREIGN KEY (linkid) REFERENCES linktypes (linkid),
  CONSTRAINT fk_lexlinks_synset1id FOREIGN KEY (synset1id) REFERENCES synsets (synsetid),
  CONSTRAINT fk_lexlinks_synset2id FOREIGN KEY (synset2id) REFERENCES synsets (synsetid),
  CONSTRAINT fk_lexlinks_word1id FOREIGN KEY (word1id) REFERENCES words (wordid),
  CONSTRAINT fk_lexlinks_word2id FOREIGN KEY (word2id) REFERENCES words (wordid),

)

CREATE TABLE linkTypeExample (
	linkId  int          NOT NULL,
	example varchar(256)     NULL,
	bolUseful bit        NOT NULL DEFAULT(0),
	
	CONSTRAINT linkTypeExample_PK PRIMARY KEY (linkId),
	CONSTRAINT linkTypeExample_FK FOREIGN KEY (linkId) REFERENCES linktypes (linkid)
)

INSERT INTO linkTypeExample VALUES (1, 'e.g. sherry and drink.', 1)
INSERT INTO linkTypeExample VALUES (2, 'e.g. drink and sherry.', 1)
INSERT INTO linkTypeExample VALUES (3, 'e.g. Coca Cola and drink.', 1)
INSERT INTO linkTypeExample VALUES (4, 'e.g. drink and Coca Cola.', 1)
INSERT INTO linkTypeExample VALUES (11, 'e.g. blade and scalpel.', 1)
INSERT INTO linkTypeExample VALUES (12, 'e.g. scalpel and blade.', 1)
INSERT INTO linkTypeExample VALUES (13, 'e.g. Mars and Solar System.', 0)
INSERT INTO linkTypeExample VALUES (14, 'e.g. Solar System and Mars.', 0)
INSERT INTO linkTypeExample VALUES (15, 'e.g. book and paper.', 0)
INSERT INTO linkTypeExample VALUES (16, 'e.g. paper and book.', 0)
INSERT INTO linkTypeExample VALUES (21, 'e.g. fire and spark.', 0)
INSERT INTO linkTypeExample VALUES (23, 'e.g. spark and fire.', 0)
INSERT INTO linkTypeExample VALUES (30, 'e.g. black and white.', 0)
INSERT INTO linkTypeExample VALUES (60, 'e.g. height and high.', 0)
