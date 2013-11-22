INSERT INTO AHeaders(strSic2007)
SELECT DISTINCT strFrom
FROM RawData..IOModel_A

INSERT INTO A(strSic2007From, strSic2007To, fltSpend)
SELECT strFrom, strTo, intValue
FROM RawData..IOModel_A

INSERT INTO B(strSic2007, strDescription, fltCO2)
SELECT SIC2007, Description, CO2e
FROM RawData..IOModel_B
WHERE Sic2007 IS NOT NULL

INSERT INTO ABMap (strA, strB)
SELECT A, B
FROM RawData..IOModel_ABMapping
WHERE A IS NOT NULL AND B IS NOT NULL