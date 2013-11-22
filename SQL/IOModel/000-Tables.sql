CREATE TABLE A(
	strSic2007From varchar(64)  NOT NULL,
	strSic2007To   varchar(64)  NOT NULL,
	strDescription varchar(256)     NULL,
	fltSpend       float        NOT NULL,
	
	CONSTRAINT A_PK PRIMARY KEY CLUSTERED (strSic2007From, strSic2007To)
)

CREATE TABLE dbo.B(
	strSic2007     varchar(64)  NOT NULL,
	strDescription varchar(256) NOT NULL,
	fltCO2         float        NOT NULL,
	
	CONSTRAINT B_PK PRIMARY KEY CLUSTERED (strSic2007)
)

CREATE TABLE dbo.ABMap(
	strA varchar(64) NOT NULL,
	strB varchar(64) NOT NULL,
	
	CONSTRAINT ABMap_PK PRIMARY KEY CLUSTERED (strA, strB),
	CONSTRAINT ABMap_FK_A FOREIGN KEY (strA) REFERENCES A(strSic2007From),
	CONSTRAINT ABMap_FK_B FOREIGN KEY (strB) REFERENCES B(strSic2007)
)
