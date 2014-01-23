CREATE TABLE GuessType (
	strType varchar(32) NOT NULL,
	
	CONSTRAINT GuessType_PK PRIMARY KEY (strType)
)

CREATE TABLE Product (
	strProductId   varchar(16)   NOT NULL,
	strDescription varchar(256)      NULL,
	
	CONSTRAINT Product_PK PRIMARY KEY (strProductId)
)

CREATE TABLE Industry (
	strIndustryId  varchar(16)   NOT NULL,
	strDescription varchar(256)      NULL,
	
	CONSTRAINT Industry_PK PRIMARY KEY (strIndustryId)
)

CREATE TABLE sourceData (
	intYear       int          NOT NULL,
	strGuessType  varchar(32)  NOT NULL,
	strProductId  varchar(16)  NOT NULL,
	strIndustryId varchar(16)  NOT NULL,
	fltValue      float            NULL,
	
	CONSTRAINT sourceData_PK           PRIMARY KEY (intYear, strGuessType, strProductId, strIndustryId),
	CONSTRAINT sourceData_FK_GuessType FOREIGN KEY (strGuessType)  REFERENCES GuessType (strType),
	CONSTRAINT sourceData_FK_Product   FOREIGN KEY (strProductId)  REFERENCES Product (strProductId),
	CONSTRAINT sourceData_FK_Industry  FOREIGN KEY (strIndustryId) REFERENCES Industry (strIndustryId)
)

-- R and S are pre and post multipliers for RAS, the name is a literal equation to apply to your original A matrix
CREATE TABLE R (
	intYear      int         NOT NULL,
	strGuessType varchar(32) NOT NULL,
	strProductId varchar(16) NOT NULL,
	fltValue     float           NULL,
	
	CONSTRAINT R_PK           PRIMARY KEY (intYear, strGuessType, strProductId),
	CONSTRAINT R_FK_GuessType FOREIGN KEY (strGuessType) REFERENCES GuessType (strType),
	CONSTRAINT R_FK_Product   FOREIGN KEY (strProductId) REFERENCES Product (strProductId)
)

CREATE TABLE S (
	intYear       int         NOT NULL,
	strGuessType  varchar(32) NOT NULL,
	strIndustryId varchar(16) NOT NULL,
	fltValue      float           NULL,
	
	CONSTRAINT S_PK           PRIMARY KEY (intYear, strGuessType, strIndustryId),
	CONSTRAINT S_FK_GuessType FOREIGN KEY (strGuessType)  REFERENCES GuessType (strType),
	CONSTRAINT S_FK_Industry  FOREIGN KEY (strIndustryId) REFERENCES Industry (strIndustryId)
)

INSERT INTO GuessType VALUES ('Column Total')
INSERT INTO GuessType VALUES ('Row Total')
INSERT INTO GuessType VALUES ('Column Proportion')
INSERT INTO GuessType VALUES ('Row Proportion')

INSERT INTO Product VALUES ('CPA_A01', 'Products of agriculture, hunting and related services')
INSERT INTO Product VALUES ('CPA_A02', 'Products of forestry, logging and related services')
INSERT INTO Product VALUES ('CPA_A03', 'Fish and other fishing products; aquaculture products; support services to fishing')
INSERT INTO Product VALUES ('CPA_B', 'Mining and quarrying')
INSERT INTO Product VALUES ('CPA_C10-C12', 'Food products, beverages and tobacco products')
INSERT INTO Product VALUES ('CPA_C13-C15', 'Textiles, wearing apparel and leather products')
INSERT INTO Product VALUES ('CPA_C16', 'Wood and of products of wood and cork, except furniture; articles of straw and plaiting materials')
INSERT INTO Product VALUES ('CPA_C17', 'Paper and paper products')
INSERT INTO Product VALUES ('CPA_C18', 'Printing and recording services')
INSERT INTO Product VALUES ('CPA_C19', 'Coke and refined petroleum products ')
INSERT INTO Product VALUES ('CPA_C20', 'Chemicals and chemical products')
INSERT INTO Product VALUES ('CPA_C21', 'Basic pharmaceutical products and pharmaceutical preparations')
INSERT INTO Product VALUES ('CPA_C22', 'Rubber and plastics products')
INSERT INTO Product VALUES ('CPA_C23', 'Other non-metallic mineral products')
INSERT INTO Product VALUES ('CPA_C24', 'Basic metals')
INSERT INTO Product VALUES ('CPA_C25', 'Fabricated metal products, except machinery and equipment')
INSERT INTO Product VALUES ('CPA_C26', 'Computer, electronic and optical products')
INSERT INTO Product VALUES ('CPA_C27', 'Electrical equipment')
INSERT INTO Product VALUES ('CPA_C28', 'Machinery and equipment n.e.c.')
INSERT INTO Product VALUES ('CPA_C29', 'Motor vehicles, trailers and semi-trailers')
INSERT INTO Product VALUES ('CPA_C30', 'Other transport equipment')
INSERT INTO Product VALUES ('CPA_C31_C32', 'Furniture; other manufactured goods')
INSERT INTO Product VALUES ('CPA_C33', 'Repair and installation services of machinery and equipment')
INSERT INTO Product VALUES ('CPA_D35', 'Electricity, gas, steam and air-conditioning')
INSERT INTO Product VALUES ('CPA_E36', 'Natural water; water treatment and supply services')
INSERT INTO Product VALUES ('CPA_E37-E39', 'Sewerage; waste collection, treatment and disposal activities; materials recovery; remediation activities and other waste management services ')
INSERT INTO Product VALUES ('CPA_F', 'Constructions and construction works')
INSERT INTO Product VALUES ('CPA_G45', 'Wholesale and retail trade and repair services of motor vehicles and motorcycles')
INSERT INTO Product VALUES ('CPA_G46', 'Wholesale trade services, except of motor vehicles and motorcycles')
INSERT INTO Product VALUES ('CPA_G47', 'Retail trade services, except of motor vehicles and motorcycles')
INSERT INTO Product VALUES ('CPA_H49', 'Land transport services and transport services via pipelines')
INSERT INTO Product VALUES ('CPA_H50', 'Water transport services')
INSERT INTO Product VALUES ('CPA_H51', 'Air transport services')
INSERT INTO Product VALUES ('CPA_H52', 'Warehousing and support services for transportation')
INSERT INTO Product VALUES ('CPA_H53', 'Postal and courier services')
INSERT INTO Product VALUES ('CPA_I', 'Accommodation and food services')
INSERT INTO Product VALUES ('CPA_J58', 'Publishing services')
INSERT INTO Product VALUES ('CPA_J59_J60', 'Motion picture, video and television programme production services, sound recording and music publishing; programming and broadcasting services')
INSERT INTO Product VALUES ('CPA_J61', 'Telecommunications services')
INSERT INTO Product VALUES ('CPA_J62_J63', 'Computer programming, consultancy and related services; information services')
INSERT INTO Product VALUES ('CPA_K64', 'Financial services, except insurance and pension funding')
INSERT INTO Product VALUES ('CPA_K65', 'Insurance, reinsurance and pension funding services, except compulsory social security')
INSERT INTO Product VALUES ('CPA_K66', 'Services auxiliary to financial services and insurance services')
INSERT INTO Product VALUES ('CPA_L68B', 'Real estate services (excluding imputed rent)')
INSERT INTO Product VALUES ('CPA_L68A', 'Imputed rents of owner-occupied dwellings')
INSERT INTO Product VALUES ('CPA_M69_M70', 'Legal and accounting services; services of head offices; management consulting services')
INSERT INTO Product VALUES ('CPA_M71', 'Architectural and engineering services; technical testing and analysis services')
INSERT INTO Product VALUES ('CPA_M72', 'Scientific research and development services')
INSERT INTO Product VALUES ('CPA_M73', 'Advertising and market research services')
INSERT INTO Product VALUES ('CPA_M74_M75', 'Other professional, scientific and technical services; veterinary services')
INSERT INTO Product VALUES ('CPA_N77', 'Rental and leasing services')
INSERT INTO Product VALUES ('CPA_N78', 'Employment services')
INSERT INTO Product VALUES ('CPA_N79', 'Travel agency, tour operator and other reservation services and related services')
INSERT INTO Product VALUES ('CPA_N80-N82', 'Security and investigation services; services to buildings and landscape; office administrative, office support and other business support services')
INSERT INTO Product VALUES ('CPA_O84', 'Public administration and defence services; compulsory social security services')
INSERT INTO Product VALUES ('CPA_P85', 'Education services')
INSERT INTO Product VALUES ('CPA_Q86', 'Human health services')
INSERT INTO Product VALUES ('CPA_Q87_Q88', 'Social work services')
INSERT INTO Product VALUES ('CPA_R90-R92', 'Creative, arts and entertainment services; library, archive, museum and other cultural services; gambling and betting services')
INSERT INTO Product VALUES ('CPA_R93', 'Sporting services and amusement and recreation services')
INSERT INTO Product VALUES ('CPA_S94', 'Services furnished by membership organisations')
INSERT INTO Product VALUES ('CPA_S95', 'Repair services of computers and personal and household goods')
INSERT INTO Product VALUES ('CPA_S96', 'Other personal services')
INSERT INTO Product VALUES ('CPA_T', 'Services of households as employers; undifferentiated goods and services produced by households for own use ')


INSERT INTO Industry VALUES ('A01', 'Crop and animal production, hunting and related service activities')
INSERT INTO Industry VALUES ('A02', 'Forestry and logging')
INSERT INTO Industry VALUES ('A03', 'Fishing and aquaculture')
INSERT INTO Industry VALUES ('B', 'Mining and quarrying')
INSERT INTO Industry VALUES ('C10-C12', 'Manufacture of food products, beverages and tobacco products')
INSERT INTO Industry VALUES ('C13-C15', 'Manufacture of textiles, wearing apparel and leather products')
INSERT INTO Industry VALUES ('C16', 'Manufacture of wood and of products of wood and cork, except furniture; manufacture of articles of straw and plaiting materials')
INSERT INTO Industry VALUES ('C17', 'Manufacture of paper and paper products')
INSERT INTO Industry VALUES ('C18', 'Printing and reproduction of recorded media')
INSERT INTO Industry VALUES ('C19', 'Manufacture of coke and refined petroleum products ')
INSERT INTO Industry VALUES ('C20', 'Manufacture of chemicals and chemical products ')
INSERT INTO Industry VALUES ('C21', 'Manufacture of basic pharmaceutical products and pharmaceutical preparations')
INSERT INTO Industry VALUES ('C22', 'Manufacture of rubber and plastic products')
INSERT INTO Industry VALUES ('C23', 'Manufacture of other non-metallic mineral products')
INSERT INTO Industry VALUES ('C24', 'Manufacture of basic metals')
INSERT INTO Industry VALUES ('C25', 'Manufacture of fabricated metal products, except machinery and equipment')
INSERT INTO Industry VALUES ('C26', 'Manufacture of computer, electronic and optical products')
INSERT INTO Industry VALUES ('C27', 'Manufacture of electrical equipment')
INSERT INTO Industry VALUES ('C28', 'Manufacture of machinery and equipment n.e.c.')
INSERT INTO Industry VALUES ('C29', 'Manufacture of motor vehicles, trailers and semi-trailers')
INSERT INTO Industry VALUES ('C30', 'Manufacture of other transport equipment')
INSERT INTO Industry VALUES ('C31_C32', 'Manufacture of furniture; other manufacturing')
INSERT INTO Industry VALUES ('C33', 'Repair and installation of machinery and equipment')
INSERT INTO Industry VALUES ('D35', 'Electricity, gas, steam and air conditioning supply')
INSERT INTO Industry VALUES ('E36', 'Water collection, treatment and supply')
INSERT INTO Industry VALUES ('E37-E39', 'Sewerage; waste collection, treatment and disposal activities; materials recovery; remediation activities and other waste management services ')
INSERT INTO Industry VALUES ('F', 'Construction')
INSERT INTO Industry VALUES ('G45', 'Wholesale and retail trade and repair of motor vehicles and motorcycles')
INSERT INTO Industry VALUES ('G46', 'Wholesale trade, except of motor vehicles and motorcycles')
INSERT INTO Industry VALUES ('G47', 'Retail trade, except of motor vehicles and motorcycles')
INSERT INTO Industry VALUES ('H49', 'Land transport and transport via pipelines')
INSERT INTO Industry VALUES ('H50', 'Water transport')
INSERT INTO Industry VALUES ('H51', 'Air transport')
INSERT INTO Industry VALUES ('H52', 'Warehousing and support activities for transportation')
INSERT INTO Industry VALUES ('H53', 'Postal and courier activities')
INSERT INTO Industry VALUES ('I', 'Accommodation and food service activities')
INSERT INTO Industry VALUES ('J58', 'Publishing activities')
INSERT INTO Industry VALUES ('J59_J60', 'Motion picture, video and television programme production, sound recording and music publishing activities; programming and broadcasting activities')
INSERT INTO Industry VALUES ('J61', 'Telecommunications')
INSERT INTO Industry VALUES ('J62_J63', 'Computer programming, consultancy and related activities; information service activities')
INSERT INTO Industry VALUES ('K64', 'Financial service activities, except insurance and pension funding')
INSERT INTO Industry VALUES ('K65', 'Insurance, reinsurance and pension funding, except compulsory social security')
INSERT INTO Industry VALUES ('K66', 'Activities auxiliary to financial services and insurance activities')
INSERT INTO Industry VALUES ('L68B', 'Real estate activities (excluding imputed rent)')
INSERT INTO Industry VALUES ('L68A', 'Imputed rents of owner-occupied dwellings')
INSERT INTO Industry VALUES ('M69_M70', 'Legal and accounting activities; activities of head offices; management consultancy activities')
INSERT INTO Industry VALUES ('M71', 'Architectural and engineering activities; technical testing and analysis')
INSERT INTO Industry VALUES ('M72', 'Scientific research and development')
INSERT INTO Industry VALUES ('M73', 'Advertising and market research')
INSERT INTO Industry VALUES ('M74_M75', 'Other professional, scientific and technical activities; veterinary activities')
INSERT INTO Industry VALUES ('N77', 'Rental and leasing activities')
INSERT INTO Industry VALUES ('N78', 'Employment activities')
INSERT INTO Industry VALUES ('N79', 'Travel agency, tour operator reservation service and related activities')
INSERT INTO Industry VALUES ('N80-N82', 'Security and investigation activities; services to buildings and landscape activities; office administrative, office support and other business support activities')
INSERT INTO Industry VALUES ('O84', 'Public administration and defence; compulsory social security')
INSERT INTO Industry VALUES ('P85', 'Education')
INSERT INTO Industry VALUES ('Q86', 'Human health activities')
INSERT INTO Industry VALUES ('Q87_Q88', 'Social work activities')
INSERT INTO Industry VALUES ('R90-R92', 'Creative, arts and entertainment activities; libraries, archives, museums and other cultural activities; gambling and betting activities')
INSERT INTO Industry VALUES ('R93', 'Sports activities and amusement and recreation activities')
INSERT INTO Industry VALUES ('S94', 'Activities of membership organisations')
INSERT INTO Industry VALUES ('S95', 'Repair of computers and personal and household goods')
INSERT INTO Industry VALUES ('S96', 'Other personal service activities')
INSERT INTO Industry VALUES ('T', 'Activities of households as employers; undifferentiated goods- and services-producing activities of households for own use')
