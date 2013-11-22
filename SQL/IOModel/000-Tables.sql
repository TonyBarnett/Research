CREATE TABLE AHeaders(
	strSic2007 varchar(64) NOT NULL,
	
	CONSTRAINT AHeaders_PK PRIMARY KEY CLUSTERED (strSic2007)
)

CREATE TABLE A(
	strSic2007From varchar(64)  NOT NULL,
	strSic2007To   varchar(64)  NOT NULL,
	fltSpend       float        NOT NULL,
	
	CONSTRAINT A_PK               PRIMARY KEY (strSic2007From, strSic2007To),
	CONSTRAINT A_FK_AHeaders_From FOREIGN KEY (strSic2007From) REFERENCES AHeaders (strSic2007),
	CONSTRAINT A_FK_AHeaders_To   FOREIGN KEY (strSic2007To) REFERENCES AHeaders (strSic2007)
)

CREATE TABLE dbo.B(
	strSic2007     varchar(64)  NOT NULL,
	strDescription varchar(256) NOT NULL,
	fltCO2         float        NOT NULL,
	
	CONSTRAINT B_PK PRIMARY KEY CLUSTERED (strSic2007)
)

CREATE TABLE dbo.ABMap(
	intId int        NOT NULL IDENTITY(1,1),
	strA varchar(64) NOT NULL,
	strB varchar(64) NOT NULL,
	
	CONSTRAINT ABMap_PK          PRIMARY KEY (intId),
	CONSTRAINT ABMap_A_B_Uq      UNIQUE (strA, StrB),
	CONSTRAINT ABMap_FK_AHeaders FOREIGN KEY (strA) REFERENCES AHeaders(strSic2007),
	CONSTRAINT ABMap_FK_B        FOREIGN KEY (strB) REFERENCES B(strSic2007)
)
