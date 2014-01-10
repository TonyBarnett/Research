CREATE TABLE Year (
	intYear int NOT NULL PRIMARY KEY
)

CREATE TABLE Industry (
	strId          varchar(16)  NOT NULL,
	strDescription varchar(256)     NULL,
	
	CONSTRAINT Industry_PK PRIMARY KEY (strId)
)

CREATE TABLE Product (
	strId          varchar(16)  NOT NULL,
	strDescription varchar(256)     NULL,
	
	CONSTRAINT Product_PK PRIMARY KEY (strId)
)

CREATE TABLE Intensities ( -- Condensed category system
	intYear         int          NOT NULL,
	intId           int          NOT NULL,
	strDescription  varchar(256)     NULL,
	fltAllGHGKGCO2e float            NULL,
	fltCO2KGCO2e    float            NULL,
	fltCH4KGCO2e    float            NULL,
	fltN2OKGCO2e    float            NULL,
	fltHFCKGCO2e    float            NULL,
	fltPFCKGCO2e    float            NULL,
	fltSF6KGCO2e    float            NULL,

	CONSTRAINT Intensities_PK PRIMARY KEY (intYear, intId)
)

CREATE TABLE CategoryProduct (
	intId          int          NOT NULL,
	strDescription varchar(256) NOT NULL,
	
	CONSTRAINT CategoryProduct_PK PRIMARY KEY (intId)
)

CREATE TABLE CategoryIndustry (
	intId          int          NOT NULL,
	strDescription varchar(256) NOT NULL,
	
	CONSTRAINT CategoryIndustry_PK PRIMARY KEY (intId)
)

-- Mapping/ Link tables.
CREATE TABLE CategoryProductCategory (
	strProductId         varchar(16) NOT NULL,
	intProductCategoryId int         NOT NULL,
	
	CONSTRAINT CategoryProductCategory_PK                 PRIMARY KEY (strProductId, intProductCategoryId),
	CONSTRAINT CategoryProductCategory_FK_Product         FOREIGN KEY (strProductId)         REFERENCES Product         (strId),
	CONSTRAINT CategoryProductCategory_FK_ProductCategory FOREIGN KEY (intProductCategoryId) REFERENCES CategoryProduct (intId)
)

CREATE TABLE CategoryIndustryCategory (
	strIndustryId         varchar(16) NOT NULL,
	intIndustryCategoryId int         NOT NULL,
	
	CONSTRAINT CategoryIndustryCategory_PK                 PRIMARY KEY (strIndustryId, intIndustryCategoryId),
	CONSTRAINT CategoryIndustryCategory_FK_Industry         FOREIGN KEY (strIndustryId)         REFERENCES Industry         (strId),
	CONSTRAINT CategoryIndustryCategory_FK_IndustryCategory FOREIGN KEY (intIndustryCategoryId) REFERENCES CategoryIndustry (intId)
)

CREATE TABLE ProductProducedByIndustry (
	intYear       int         NOT NULL,
	strProductId  varchar(16) NOT NULL,
	strIndustryId varchar(16) NOT NULL,
	fltValue      float           NULL,
	
	CONSTRAINT ProductProducedByIndustry_PK          PRIMARY KEY (intYear, strProductId, strIndustryId),
	CONSTRAINT ProductProducedByIndustry_FK_Year     FOREIGN KEY (intYear)       REFERENCES Year     (intYear),
	CONSTRAINT ProductProducedByIndustry_FK_Product  FOREIGN KEY (strProductId)  REFERENCES Product  (strId),
	CONSTRAINT ProductProducedByIndustry_FK_Industry FOREIGN KEY (strIndustryId) REFERENCES Industry (strId)
)

CREATE TABLE IndustryConsumingProduct (
	intYear       int         NOT NULL,
	strIndustryId varchar(16) NOT NULL,
	strProductId  varchar(16) NOT NULL,
	fltValue      float           NULL,
	
	CONSTRAINT IndustryConsumingProduct_PK          PRIMARY KEY (intYear, strProductId, strIndustryId),
	CONSTRAINT IndustryConsumingProduct_FK_Year     FOREIGN KEY (intYear)       REFERENCES Year     (intYear),
	CONSTRAINT IndustryConsumingProduct_FK_Industry FOREIGN KEY (strIndustryId) REFERENCES Industry (strId),
	CONSTRAINT IndustryConsumingProduct_FK_Product  FOREIGN KEY (strProductId)  REFERENCES Product  (strId)
)

CREATE TABLE IndustryOutput (
	intYear       int         NOT NULL,
	strIndustryId varchar(16) NOT NULL,
	fltOutput     float           NULL,
	
	CONSTRAINT IndustryOutput_PK          PRIMARY KEY (intYear, strIndustryId),
	CONSTRAINT IndustryOutput_FK_Year     FOREIGN KEY (intYear)       REFERENCES Year     (intYear),
	CONSTRAINT IndustryOutput_FK_Industry FOREIGN KEY (strIndustryId) REFERENCES Industry (strId)
)

CREATE TABLE EmissionsByIndustry (
	intYear         int         NOT NULL,
	strIndustryId   varchar(16) NOT NULL,
	fltAllGHGKGCO2e float           NULL,
	fltCO2KGCO2e    float           NULL,
	fltCH4KGCO2e    float           NULL,
	fltN2OKGCO2e    float           NULL,
	fltHFCKGCO2e    float           NULL,
	fltPFCKGCO2e    float           NULL,
	fltSF6KGCO2e    float           NULL,
	
	CONSTRAINT EmissionsByIndustry_PK          PRIMARY KEY (intYear, strIndustryId),
	CONSTRAINT EmissionsByIndustry_FK_Year     FOREIGN KEY (intYear)       REFERENCES Year     (intYear),
	CONSTRAINT EmissionsByIndustry_FK_Industry FOREIGN KEY (strIndustryId) REFERENCES Industry (strId),
)