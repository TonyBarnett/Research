CREATE TABLE Region (
	strRegion varchar(64) NOT NULL,
	
	CONSTRAINT Region_PK PRIMARY KEY (strRegion)
)

CREATE TABLE ModelYear (
	intYear int NOT NULL PRIMARY KEY
)

--CREATE TABLE dataSource(
--	strSource   varchar(32)  NOT NULL,

--	CONSTRAINT dataSource_PK PRIMARY KEY (strSource)
--)

--CREATE TABLE dataType(
--	strDataSourceId varchar(32) NOT NULL,
--	strDataType     varchar(32) NOT NULL,
	
--	CONSTRAINT dataType_PK            PRIMARY KEY (strDataSourceId, strDataType),
--	CONSTRAINT dataType_FK_dataSource FOREIGN KEY (strDataSourceId) REFERENCES dataSource (strSource)
--)

--CREATE TABLE sorCategory ( -- The surrogate key is so that you can store values without storing types.
--	intCategoryId  int          NOT NULL IDENTITY(1, 1),
--	strSourceId    varchar(32)  NOT NULL,
--	strTypeId      varchar(32)  NOT NULL,
--	strId          varchar(32)  NOT NULL,
--	strDescription varchar(256)     NULL,
	
--	CONSTRAINT sorCategory_PK              PRIMARY KEY (intcategoryId),
--	CONSTRAINT sorCategory_UQ_SourceTypeId UNIQUE      (strSourceId, strTypeId, strId),
--	CONSTRAINT sorCategory_FK_dataType     FOREIGN KEY (strSourceId, strTypeId)   REFERENCES dataType   (strDataSourceId, strDataType)
--)

--CREATE TABLE sorValue (
--	intYear       int   NOT NULL,
--	intIndustryId int   NOT NULL,
--	intProductId  int   NOT NULL,
--	fltValue      float     NULL,
	
--	CONSTRAINT sorValue_PK                      PRIMARY KEY (intYear, intIndustryId, intProductId),
--	CONSTRAINT sorValue_FK_ModelYear            FOREIGN KEY (intYear)       REFERENCES ModelYear (intYear),
--	CONSTRAINT sorValue_FK_sorCategory_Product  FOREIGN KEY (intProductId)  REFERENCES sorCategory (intCategoryId),
--	CONSTRAINT sorValue_FK_sorCategory_Industry FOREIGN KEY (intIndustryId) REFERENCES sorCategory (intCategoryId)
--)

--CREATE TABLE sorEmissions (
--	intYear          int    NOT NULL,
--	intSorCategoryId int    NOT NULL,
--	fltEmissions     float      NULL,
	
--	CONSTRAINT sorEmissions_PK PRIMARY KEY (intYear, intsorCategoryId)
--)

--CREATE TABLE sorFinalDemand (
--	intYear          int   NOT NULL,
--	intSorCategoryId int   NOT NULL,
--	fltValue         float     NULL,
	
--	CONSTRAINT sorFinalDemand_PK             PRIMARY KEY (intYear, intSorCategoryId),
--	CONSTRAINT sorFinalDemand_FK_sorCategort FOREIGN KEY (intSorCategoryId) REFERENCES sorCategory (intCategoryId)
--)

--CREATE TABLE sorImports (
--	intYear          int   NOT NULL,
--	intSorCategoryId int   NOT NULL,
--	fltValue         float NOT NULL,
	
--	CONSTRAINT sorImports_PK             PRIMARY KEY (intYear, intSorCategoryId)
--	CONSTRAINT sorImports_FK_sorCategory FOREIGN KEY (intSorCategoryId) REFERENCES sorCategory (intCategoryId)
--)

--CREATE TABLE sorExports (
--	intYear          int   NOT NULL,
--	intSorCategoryId int   NOT NULL,
--	fltValue         float     NULL,	
	
--	CONSTRAINT sorExports_PK             PRIMARY KEY (intYear, intSorCategoryId),
--	CONSTRAINT sorExports_FK_sorCategory FOREIGN KEY (intSorCategoryId) REFERENCES sorCategory (intCategoryId)
--)

----CREATE TABLE sorCategory_cValueLink (
----)

--CREATE TABLE CategoryMap (
--	intFromCategoryId int   NOT NULL,
--	intToCategoryId   int   NOT NULL,
--	fltWeight         float     NULL,
	
--	CONSTRAINT CategoryMap_PK                 PRIMARY KEY (intfromCategoryId, intToCategoryId),
--	CONSTRAINT CategoryMap_FK_sorCategoryFrom FOREIGN KEY (intFromCategoryId) REFERENCES sorCategory (intCategoryId),
--	CONSTRAINT CategoryMap_FK_sorCategoryTo   FOREIGN KEY (intToCategoryId)   REFERENCES sorCategory (intCategoryId)
--)

--CREATE TABLE dataSourcecValueLink (
--	strDataSourceId varchar(32) NOT NULL,
--	strClasSystemId varchar(32) NOT NULL,
--	strClasValueId  varchar(32) NOT NULL,
	
--	CONSTRAINT dataSourcecValueLink_PK            PRIMARY KEY (strDataSourceId, strClasSystemId, strClasValueId),
--	CONSTRAINT dataSourcecValueLink_FK_cValueLink FOREIGN KEY (strClasSystemId, strClasValueId) REFERENCES cValueLink (strClasSystemId,strClasValueId),
--	CONSTRAINT dataSourcecValueLink_FK_dataSource FOREIGN KEY (strDataSourceId)                 REFERENCES dataSource (strSource)
--)

--INSERT INTO cSystemLink 
--SELECT strName 
--FROM ClassificationSystems..clasSystem

--INSERT INTO cValueLink 
--SELECT strSystemId, strValue
--FROM ClassificationSystems..clasValue

INSERT INTO ModelYear VALUES (2000)
INSERT INTO ModelYear VALUES (2001)
INSERT INTO ModelYear VALUES (2002)
INSERT INTO ModelYear VALUES (2003)
INSERT INTO ModelYear VALUES (2004)
INSERT INTO ModelYear VALUES (2005)
INSERT INTO ModelYear VALUES (2006)
INSERT INTO ModelYear VALUES (2007)
INSERT INTO ModelYear VALUES (2008)
INSERT INTO ModelYear VALUES (2009)
INSERT INTO ModelYear VALUES (2010)

INSERT INTO Region VALUES ('UK')
INSERT INTO Region VALUES ('EU')

--INSERT INTO dataSource VALUES ('UK Consumption')
--INSERT INTO dataSource VALUES ('UK Supply')
--INSERT INTO dataSource VALUES ('UK Emissions')
--INSERT INTO dataSource VALUES ('UK Imports')
--INSERT INTO dataSource VALUES ('UK Exports To EU')

--INSERT INTO dataSource VALUES ('EU Supply')
--INSERT INTO dataSource VALUES ('EU Consumption')
--INSERT INTO dataSource VALUES ('EU Emissions')
--INSERT INTO dataSource VALUES ('EU Exports To UK')


--INSERT INTO dataType VALUES('UK Consumption', 'Product')
--INSERT INTO dataType VALUES('UK Consumption', 'Industry')
--INSERT INTO dataType VALUES('UK Supply', 'Product')
--INSERT INTO dataType VALUES('UK Supply', 'Industry')
--INSERT INTO dataType VALUES('UK Emissions', 'Product')
--INSERT INTO dataType VALUES('UK Imports','Product')
--INSERT INTO dataType VALUES('UK Exports To EU','Product')

--INSERT INTO dataType VALUES('EU Consumption', 'Product')
--INSERT INTO dataType VALUES('EU Consumption', 'Industry')
--INSERT INTO dataType VALUES('EU Supply', 'Product')
--INSERT INTO dataType VALUES('EU Supply', 'Industry')
--INSERT INTO dataType VALUES('EU Emissions', 'Product')
--INSERT INTO dataType VALUES('EU Exports To UK','Product')

--CREATE TABLE Intensities ( -- Condensed sorCategory system
--	intYear         int          NOT NULL,
--	intId           int          NOT NULL,
--	strDescription  varchar(256)     NULL,
--	fltAllGHGKGCO2e float            NULL,
--	fltCO2KGCO2e    float            NULL,
--	fltCH4KGCO2e    float            NULL,
--	fltN2OKGCO2e    float            NULL,
--	fltHFCKGCO2e    float            NULL,
--	fltPFCKGCO2e    float            NULL,
--	fltSF6KGCO2e    float            NULL,

--	CONSTRAINT Intensities_PK PRIMARY KEY (intYear, intId)
--)

--CREATE TABLE CategoryProduct (
--	intId          int          NOT NULL,
--	strDescription varchar(256) NOT NULL,
	
--	CONSTRAINT CategoryProduct_PK PRIMARY KEY (intId)
--)

--CREATE TABLE CategorysorCategory (
--	intId          int          NOT NULL,
--	strDescription varchar(256) NOT NULL,
	
--	CONSTRAINT CategorysorCategory_PK PRIMARY KEY (intId)
--)

---- Mapping/ Link tables.
--CREATE TABLE CategoryProductsorCategory (
--	strProductId         varchar(16) NOT NULL,
--	intProductCategoryId int         NOT NULL,
	
--	CONSTRAINT CategoryProductCategory_PK                 PRIMARY KEY (strProductId, intProductCategoryId),
--	CONSTRAINT CategoryProductCategory_FK_Product         FOREIGN KEY (strProductId)         REFERENCES Product         (strId),
--	CONSTRAINT CategoryProductCategory_FK_ProductCategory FOREIGN KEY (intProductCategoryId) REFERENCES CategoryProduct (intId)
--)

--CREATE TABLE CategoryCategoryCategory (
--	strCategoryId         varchar(16) NOT NULL,
--	intCategoryCategoryId int         NOT NULL,
	
--	CONSTRAINT CategoryCategoryCategory_PK                  PRIMARY KEY (strCategoryId, intCategoryCategoryId),
--	CONSTRAINT CategoryCategoryCategory_FK_Category         FOREIGN KEY (strCategoryId)         REFERENCES Category         (strId),
--	CONSTRAINT CategoryCategoryCategory_FK_CategoryCategory FOREIGN KEY (intCategoryCategoryId) REFERENCES CategoryCategory (intId)
--)

--CREATE TABLE ProductProducedByCategory (
--	intYear       int         NOT NULL,
--	strProductId  varchar(16) NOT NULL,
--	strCategoryId varchar(16) NOT NULL,
--	fltValue      float           NULL,
	
--	CONSTRAINT ProductProducedByCategory_PK          PRIMARY KEY (intYear, strProductId, strCategoryId),
--	CONSTRAINT ProductProducedByCategory_FK_Year     FOREIGN KEY (intYear)       REFERENCES ModelYear (intYear),
--	CONSTRAINT ProductProducedByCategory_FK_Product  FOREIGN KEY (strProductId)  REFERENCES Product   (strId),
--	CONSTRAINT ProductProducedByCategory_FK_Category FOREIGN KEY (strCategoryId) REFERENCES Category  (strId)
--)

--CREATE TABLE CategoryConsumingProduct (
--	intYear       int         NOT NULL,
--	strCategoryId varchar(16) NOT NULL,
--	strProductId  varchar(16) NOT NULL,
--	fltValue      float           NULL,
	
--	CONSTRAINT CategoryConsumingProduct_PK          PRIMARY KEY (intYear, strProductId, strCategoryId),
--	CONSTRAINT CategoryConsumingProduct_FK_Year     FOREIGN KEY (intYear)       REFERENCES ModelYear (intYear),
--	CONSTRAINT CategoryConsumingProduct_FK_Category FOREIGN KEY (strCategoryId) REFERENCES Category  (strId),
--	CONSTRAINT CategoryConsumingProduct_FK_Product  FOREIGN KEY (strProductId)  REFERENCES Product   (strId)
--)

--CREATE TABLE CategoryOutput (
--	intYear       int         NOT NULL,
--	strCategoryId varchar(16) NOT NULL,
--	fltOutput     float           NULL,
	
--	CONSTRAINT CategoryOutput_PK          PRIMARY KEY (intYear, strCategoryId),
--	CONSTRAINT CategoryOutput_FK_Year     FOREIGN KEY (intYear)       REFERENCES ModelYear (intYear),
--	CONSTRAINT CategoryOutput_FK_Category FOREIGN KEY (strCategoryId) REFERENCES Category  (strId)
--)

--CREATE TABLE EmissionsByCategory (
--	intYear         int         NOT NULL,
--	strCategoryId   varchar(16) NOT NULL,
--	fltAllGHGKGCO2e float           NULL,
--	fltCO2KGCO2e    float           NULL,
--	fltCH4KGCO2e    float           NULL,
--	fltN2OKGCO2e    float           NULL,
--	fltHFCKGCO2e    float           NULL,
--	fltPFCKGCO2e    float           NULL,
--	fltSF6KGCO2e    float           NULL,
	
--	CONSTRAINT EmissionsByCategory_PK          PRIMARY KEY (intYear, strCategoryId),
--	CONSTRAINT EmissionsByCategory_FK_Year     FOREIGN KEY (intYear)       REFERENCES ModelYear (intYear),
--	CONSTRAINT EmissionsByCategory_FK_Category FOREIGN KEY (strCategoryId) REFERENCES Category  (strId),
--)