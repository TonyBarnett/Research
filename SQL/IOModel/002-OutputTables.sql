CREATE SCHEMA i;

CREATE TABLE i.intensities (
	intYear         int        NOT NULL,
	strCensa123     varchar(3) NOT NULL,
	fltSingleRegion float          NULL,
	fltTwoRegion    float          NULL,

	CONSTRAINT intensities_pk       PRIMARY KEY (intYear, strCensa123),
	CONSTRAINT intensities_FK_year  FOREIGN KEY (intYear)     REFERENCES ModelYear(intYear),
	CONSTRAINT intensities_FK_Censa FOREIGN KEY (strCensa123) REFERENCES Censa123(strValue),
);