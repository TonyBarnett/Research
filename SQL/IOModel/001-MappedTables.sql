CREATE SCHEMA mapped

CREATE TABLE dbo.Censa123 (
	strValue       varchar(3)  NOT NULL,
	strDescription varchar(64)     NULL,
	
	CONSTRAINT Censa123_PK PRIMARY KEY (strValue)
)

CREATE TABLE mapped.TotalEmissions (
	intYear          int         NOT NULL,
	strRegion        varchar(64) NOT NULL,
	strValue         varchar(3)  NOT NULL,
	fltTotalEmissions float      NOT NULL,
	
	CONSTRAINT TotalEmissions_PK           PRIMARY KEY (intYear, strRegion, strValue),
	CONSTRAINT TotalEmissions_FK_ModelYear FOREIGN KEY (intYear)   REFERENCES ModelYear (intYear),
	CONSTRAINT TotalEmissions_FK_Region    FOREIGN KEY (strRegion) REFERENCES Region (strRegion),
	CONSTRAINT TotalEmissions_FK_Censa123  FOREIGN KEY (strValue)  REFERENCES Censa123 (strValue)
)

CREATE TABLE mapped.Consumption (
	intYear	       int         NOT NULL,
	strRegion      varchar(64) NOT NULL,
	strSourceValue varchar(3)  NOT NULL,
	strTargetValue varchar(3)  NOT NULL,
	fltConsumption float       NOT NULL,
	
	CONSTRAINT Consumption_PK                  PRIMARY KEY (intYear, strRegion, strSourceValue, strTargetValue),
	CONSTRAINT Consumption_FK_ModelYear        FOREIGN KEY (intYear)        REFERENCES ModelYear (intYear),
	CONSTRAINT Consumption_FK_Region           FOREIGN KEY (strRegion)      REFERENCES Region (strRegion),
	CONSTRAINT Consumption_FK_source_Censa123  FOREIGN KEY (strSourcevalue) REFERENCES Censa123 (strValue),
	CONSTRAINT Consumption_FK_Target_Censa123  FOREIGN KEY (strTargetValue) REFERENCES Censa123 (strValue)
)

CREATE TABLE mapped.Production (
	intYear       int         NOT NULL,
	strRegion     varchar(64) NOT NULL,
	strSourceValue varchar(3)  NOT NULL,
	strTargetValue varchar(3)  NOT NULL,
	fltProduction float       NOT NULL,
	
	CONSTRAINT Production_PK                  PRIMARY KEY (intYear, strRegion, strSourceValue, strTargetValue),
	CONSTRAINT Production_FK_ModelYear        FOREIGN KEY (intYear)        REFERENCES ModelYear (intYear),
	CONSTRAINT Production_FK_Region           FOREIGN KEY (strRegion)      REFERENCES Region (strRegion),
	CONSTRAINT Production_FK_source_Censa123  FOREIGN KEY (strSourcevalue) REFERENCES Censa123 (strValue),
	CONSTRAINT Production_FK_Target_Censa123  FOREIGN KEY (strTargetValue) REFERENCES Censa123 (strValue)
)

CREATE TABLE mapped.Export (
	intYear         int         NOT NULL,
	strSourceRegion varchar(64) NOT NULL,
	strTargetRegion varchar(64) NOT NULL,
	strSourceValue  varchar(3)  NOT NULL,
	strTargetValue  varchar(3)  NOT NULL,
	fltExport       float       NOT NULL,
	
	CONSTRAINT Export_PK                 PRIMARY KEY (intYear, strSourceRegion, strTargetRegion, strSourceValue, strTargetValue),
	CONSTRAINT Export_FK_ModelYear       FOREIGN KEY (intYear)         REFERENCES ModelYear (intYear),
	CONSTRAINT Export_FK_SourceRegion    FOREIGN KEY (strSourceRegion) REFERENCES Region (strRegion),
	CONSTRAINT Export_FK_TargetRegion    FOREIGN KEY (strTargetRegion) REFERENCES Region (strRegion),
	CONSTRAINT Export_FK_Source_Censa123 FOREIGN KEY (strSourceValue)  REFERENCES Censa123 (strValue),
	CONSTRAINT Export_FK_Target_Censa123 FOREIGN KEY (strtargetValue)  REFERENCES Censa123 (strValue)
)