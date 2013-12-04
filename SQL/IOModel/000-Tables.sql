CREATE TABLE AHeaders(
	strSic2007 varchar(64) NOT NULL,
	
	CONSTRAINT AHeaders_PK PRIMARY KEY CLUSTERED (strSic2007)
)

CREATE TABLE A(
	strSic2007From varchar(64)  NOT NULL,
	strSic2007To   varchar(64)  NOT NULL,
	monTotal       money        NOT NULL,
	
	CONSTRAINT A_PK               PRIMARY KEY (strSic2007From, strSic2007To),
	CONSTRAINT A_FK_AHeaders_From FOREIGN KEY (strSic2007From) REFERENCES AHeaders (strSic2007),
	CONSTRAINT A_FK_AHeaders_To   FOREIGN KEY (strSic2007To)   REFERENCES AHeaders (strSic2007) 
)

CREATE TABLE B(
	strSic2007     varchar(64)  NOT NULL,
	fltCO2         float        NOT NULL,
	
	CONSTRAINT B_PK PRIMARY KEY CLUSTERED (strSic2007)
)


CREATE TABLE F(
	strSic2007     varchar(64)  NOT NULL,
	monTotal       money        NOT NULL,
	
	CONSTRAINT F_PK          PRIMARY KEY (strSic2007),
	CONSTRAINT F_AHeaders_FK FOREIGN KEY (strSic2007) REFERENCES AHeaders(strSic2007)
)

CREATE TABLE Category(
	intId int NOT NULL PRIMARY KEY,
)

CREATE TABLE ABMap(
	strA           varchar(64)  NOT NULL,
	strB           varchar(64)  NOT NULL,
	intCategoryId  int          NOT NULL,
	strDescription varchar(256) NOT NULL,
	
	CONSTRAINT ABMap_PK          PRIMARY KEY (strA, StrB),
	CONSTRAINT ABMap_FK_AHeaders FOREIGN KEY (strA)          REFERENCES AHeaders(strSic2007) ON DELETE CASCADE,
	CONSTRAINT ABMap_FK_B        FOREIGN KEY (strB)          REFERENCES B(strSic2007)        ON DELETE CASCADE,
	CONSTRAINT ABMap_FK_Category FOREIGN KEY (intCategoryId) REFERENCES Category (intId)     ON DELETE CASCADE
)

CREATE TABLE Intensity(
	intCategoryId   int NOT NULL,
	fltIntensitiy float NOT NULL,
	
	CONSTRAINT Intensity_PK       PRIMARY KEY (intCategoryId),
	CONSTRAINT Intensity_FK_ABMap FOREIGN KEY (intCategoryId) REFERENCES Category (intId) ON DELETE CASCADE
)

CREATE TABLE SicDescription(
	strSource      char(1)      NOT NULL,
	strSic2007     varchar(64)  NOT NULL,
	strDescription varchar(256) NOT NULL,
	
	CONSTRAINT SicDescription_PK PRIMARY KEY (strSource, strSic2007)
)

CREATE TABLE IOModel_Censa76(
	intIOModelId  int NOT NULL,
	intCensa76Id  int NOT NULL,
	intConfidence int NOT NULL,
	
	CONSTRAINT IOModel_Censa76_PK          PRIMARY KEY (intIOModelId, intCensa76Id),
	CONSTRAINT IOModel_Censa76_FK_Category FOREIGN KEY (intIOModelId) REFERENCES Category (intId)
)

CREATE TABLE IOModel_Censa123(
	intIOModelId  int NOT NULL,
	intCensa123Id  int NOT NULL,
	intConfidence int NOT NULL,
	
	CONSTRAINT IOModel_Censa123_PK          PRIMARY KEY (intIOModelId, intCensa123Id),
	CONSTRAINT IOModel_Censa123_FK_Category FOREIGN KEY (intIOModelId) REFERENCES Category (intId)
)