--CREATE SCHEMA sor

CREATE TABLE sor.Emission(
	intYear     int         NOT NULL,
	strRegion   varchar(64) NOT NULL,
	strSystem   varchar(64) NOT NULL,
	strValue    varchar(64) NOT NULL,
	fltEmission float       NOT NULL DEFAULT(0),
	
	CONSTRAINT Emission_PK           PRIMARY KEY (intYear, strSystem, strValue),
	CONSTRAINT Emission_FK_ModelYear FOREIGN KEY (intYear)   REFERENCES ModelYear(intYear),
	CONSTRAINT Emission_FK_Region    FOREIGN KEY (strRegion) REFERENCES Region (strRegion)
)

CREATE TABLE sor.Production (
	intYear        int         NOT NULL,
	strRegion      varchar(64) NOT NULL,
	strSystem      varchar(64) NOT NULL,
	strSourceValue varchar(64) NOT NULL,
	strTargetValue varchar(64) NOT NULL,
	fltProduction  float       NOT NULL,
	
	CONSTRAINT Production_PK           PRIMARY KEY (intYear, strRegion, strSystem, strSourceValue, strTargetValue),
	CONSTRAINT Production_FK_ModelYear FOREIGN KEY (intYear)   REFERENCES ModelYear(intYear),
	CONSTRAINT Production_FK_Region    FOREIGN KEY (strRegion) REFERENCES Region (strRegion)
)

CREATE TABLE sor.Consumption (
	intYear        int         NOT NULL,
	strRegion      varchar(64) NOT NULL,
	strSystem      varchar(64) NOT NULL,
	strSourceValue varchar(64) NOT NULL,
	strTargetValue varchar(64) NOT NULL,
	fltConsumption float       NOT NULL,
	
	CONSTRAINT Consumption_PK           PRIMARY KEY (intYear, strRegion, strSystem, strSourceValue, strTargetValue),
	CONSTRAINT Consumption_FK_ModelYear FOREIGN KEY (intYear)   REFERENCES ModelYear(intYear),
	CONSTRAINT Consumption_FK_Region    FOREIGN KEY (strRegion) REFERENCES Region (strRegion)
)

CREATE TABLE sor.Export (
	intYear         int         NOT NULL,
	strSourceRegion varchar(64) NOT NULL,
	strTargetRegion varchar(64) NOT NULL,
	strSystem       varchar(64) NOT NULL,
	strSourceValue  varchar(64) NOT NULL,
	strTargetValue  varchar(64) NOT NULL,
	fltExport       float       NOT NULL,
	
	CONSTRAINT Export_PK               PRIMARY KEY (intYear, strSystem, strSourceRegion, strTargetRegion, strSourceValue, strTargetValue),
	CONSTRAINT Export_FK_ModelYear     FOREIGN KEY (intYear)         REFERENCES ModelYear(intYear),
	CONSTRAINT Export_FK_Region_source FOREIGN KEY (strSourceRegion) REFERENCES Region (strRegion),
	CONSTRAINT Export_FK_Region_target FOREIGN KEY (strTargetRegion) REFERENCES Region (strRegion)
)

---- Populate ----

INSERT INTO sor.Emission (intYear, strRegion, strSystem, strValue, fltEmission)
SELECT *
FROM RawData..

sor.Production 

sor.Consumption

sor.Export (