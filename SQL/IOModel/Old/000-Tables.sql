CREATE TABLE SicDescription(
	strSic2007     varchar(64)  NOT NULL,
	strDescription varchar(256) NOT NULL,
	strSource      char(1)      NOT NULL,
	
	CONSTRAINT SicDescription_PK PRIMARY KEY (strSic2007)
)

CREATE TABLE Modelyear(
	intYear int NOT NULL,
	
	CONSTRAINT Year_PK PRIMARY KEY (intYear)
)

CREATE TABLE A(
    intYear       int           NOT NULL,
	strSic2007From varchar(64)  NOT NULL,
	strSic2007To   varchar(64)  NOT NULL,
	monTotal       money        NOT NULL,
	
	CONSTRAINT A_PK                     PRIMARY KEY (intYear,strSic2007From, strSic2007To),
	CONSTRAINT A_FK_Year                FOREIGN KEY (intYear)        REFERENCES ModelYear (intYear),
	CONSTRAINT A_FK_SicDescription_From FOREIGN KEY (strSic2007From) REFERENCES SicDescription (strSic2007),
	CONSTRAINT A_FK_SicDescription_To   FOREIGN KEY (strSic2007To)   REFERENCES SicDescription (strSic2007),
)

CREATE TABLE B(
    intYear        int          NOT NULL,
	strSic2007     varchar(64)  NOT NULL,
	fltCO2         float        NOT NULL,
	
	CONSTRAINT B_PK                PRIMARY KEY CLUSTERED (intYear, strSic2007),
	CONSTRAINT B_FK_Year           FOREIGN KEY           (intYear)    REFERENCES ModelYear (intYear),
	CONSTRAINT B_FK_SicDescription FOREIGN KEY           (strSic2007) REFERENCES SicDescription(strSic2007)
)

CREATE TABLE F(
    intYear        int          NOT NULL,
	strSic2007     varchar(64)  NOT NULL,
	monTotal       money        NOT NULL,
	
	CONSTRAINT F_PK                PRIMARY KEY (intYear,strSic2007),
	CONSTRAINT F_FK_Year           FOREIGN KEY (intYear)    REFERENCES ModelYear (intYear),
	CONSTRAINT F_FK_SicDescription FOREIGN KEY (strSic2007) REFERENCES SicDescription (strSic2007)
)

CREATE TABLE Category(
	intId          int          NOT NULL,
	strDescription varchar(256) NOT NULL,
	
	CONSTRAINT Category_PK PRIMARY KEY (intId)
)

CREATE TABLE ABMap(
	strA          varchar(64) NOT NULL,
	strB          varchar(64) NOT NULL,
	intCategoryId int         NOT NULL,
	
	CONSTRAINT ABMap_PK                  PRIMARY KEY (strA, StrB),
	CONSTRAINT ABMap_FK_SicDescription_A FOREIGN KEY (strA)          REFERENCES SicDescription(strSic2007),
	CONSTRAINT ABMap_FK_SicDescription_B FOREIGN KEY (strB)          REFERENCES SicDescription(strSic2007),
	CONSTRAINT ABMap_FK_Category         FOREIGN KEY (intCategoryId) REFERENCES Category (intId) ON DELETE CASCADE
)

CREATE TABLE Intensity(
    intYear         int NOT NULL,
	intCategoryId   int NOT NULL,
	fltIntensity float NOT NULL,
	
	CONSTRAINT Intensity_PK       PRIMARY KEY (intYear, intCategoryId),
	CONSTRAINT Intensity_FK_Year  FOREIGN KEY (intYear)       REFERENCES ModelYear (intYear),
	CONSTRAINT Intensity_FK_ABMap FOREIGN KEY (intCategoryId) REFERENCES Category (intId) ON DELETE CASCADE
)

CREATE TABLE IOModel_Censa76(
	intIOModelId  int NOT NULL,
	intCensa76Id  int NOT NULL,
	
	CONSTRAINT IOModel_Censa76_PK          PRIMARY KEY (intIOModelId, intCensa76Id),
	CONSTRAINT IOModel_Censa76_FK_Category FOREIGN KEY (intIOModelId) REFERENCES Category (intId)
)

CREATE TABLE IOModel_Censa123(
	intIOModelId   int NOT NULL,
	intCensa123Id  int NOT NULL,
	
	CONSTRAINT IOModel_Censa123_PK          PRIMARY KEY (intIOModelId, intCensa123Id),
	CONSTRAINT IOModel_Censa123_FK_Category FOREIGN KEY (intIOModelId) REFERENCES Category (intId)
)

CREATE TABLE IOModel_Censa76Temp(
	intIOModelId  int NOT NULL,
	intCensa76Id  int NOT NULL,
	intConfidence int NOT NULL,
	
	CONSTRAINT IOModel_Censa76Temp_PK          PRIMARY KEY (intIOModelId, intCensa76Id),
	CONSTRAINT IOModel_Censa76Temp_FK_Category FOREIGN KEY (intIOModelId) REFERENCES Category (intId)
)

CREATE TABLE IOModel_Censa123Temp(
	intIOModelId  int NOT NULL,
	intCensa123Id  int NOT NULL,
	intConfidence int NOT NULL,
	
	CONSTRAINT IOModel_Censa123Temp_PK          PRIMARY KEY (intIOModelId, intCensa123Id),
	CONSTRAINT IOModel_Censa123Temp_FK_Category FOREIGN KEY (intIOModelId) REFERENCES Category (intId)
)