UPDATE clasValue SET strParent = CASE 
		WHEN v.intLevel > 2 THEN SUBSTRING(v.strValue,0 , LEN(v.strValue))
		ELSE NULL 
	END
FROM clasValue v
WHERE strSystemId LIKE 'SIC%'

UPDATE clasValue SET strParent = CASE
		WHEN v.intLevel = 4 THEN SUBSTRING(v.strValue,0 , LEN(v.strValue) - 1) 
		WHEN v.intLevel > 1 THEN SUBSTRING(v.strValue,0 , LEN(v.strValue))
		ELSE NULL 
	END
FROM clasValue v
WHERE strSystemId LIKE 'SITC%'

UPDATE clasValue SET strParent =
	CASE 
		WHEN v.intLevel > 1 AND strValue LIKE '%(_)' 
			THEN SUBSTRING(strValue, 0, LEN(v.strValue) - 3)
		WHEN v.intLevel > 1 AND strValue LIKE '%.__' 
			THEN SUBSTRING(strValue, 0, LEN(v.strValue) - 2)
		WHEN v.intLevel > 1 THEN SUBSTRING(strValue, 0, LEN(v.strValue) - 1)
		ELSE NULL
	END
FROM clasValue v
WHERE strSystemId = 'UNFCCC'

UPDATE clasValue SET strParent = 'A' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '01'
UPDATE clasValue SET strParent = 'A' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '02'
UPDATE clasValue SET strParent = 'B' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '05'
UPDATE clasValue SET strParent = 'C' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '10'
UPDATE clasValue SET strParent = 'C' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '11'
UPDATE clasValue SET strParent = 'C' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '12'
UPDATE clasValue SET strParent = 'C' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '13'
UPDATE clasValue SET strParent = 'C' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '14'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '15'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '16'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '17'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '18'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '19'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '20'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '21'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '22'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '23'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '24'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '25'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '26'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '27'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '28'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '29'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '30'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '31'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '32'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '33'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '34'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '35'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '36'
UPDATE clasValue SET strParent = 'D' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '37'
UPDATE clasValue SET strParent = 'E' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '40'
UPDATE clasValue SET strParent = 'E' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '41'
UPDATE clasValue SET strParent = 'F' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '45'
UPDATE clasValue SET strParent = 'G' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '50'
UPDATE clasValue SET strParent = 'G' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '51'
UPDATE clasValue SET strParent = 'G' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '52'
UPDATE clasValue SET strParent = 'H' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '55'
UPDATE clasValue SET strParent = 'I' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '60'
UPDATE clasValue SET strParent = 'I' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '61'
UPDATE clasValue SET strParent = 'I' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '62'
UPDATE clasValue SET strParent = 'I' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '63'
UPDATE clasValue SET strParent = 'I' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '64'
UPDATE clasValue SET strParent = 'J' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '65'
UPDATE clasValue SET strParent = 'J' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '66'
UPDATE clasValue SET strParent = 'J' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '67'
UPDATE clasValue SET strParent = 'K' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '70'
UPDATE clasValue SET strParent = 'K' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '71'
UPDATE clasValue SET strParent = 'K' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '72'
UPDATE clasValue SET strParent = 'K' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '73'
UPDATE clasValue SET strParent = 'K' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '74'
UPDATE clasValue SET strParent = 'L' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '75'
UPDATE clasValue SET strParent = 'M' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '80'
UPDATE clasValue SET strParent = 'N' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '85'
UPDATE clasValue SET strParent = 'N' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '90'
UPDATE clasValue SET strParent = 'O' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '91'
UPDATE clasValue SET strParent = 'O' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '92'
UPDATE clasValue SET strParent = 'O' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '93'
UPDATE clasValue SET strParent = 'P' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '95'
UPDATE clasValue SET strParent = 'P' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '96'
UPDATE clasValue SET strParent = 'P' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '97'
UPDATE clasValue SET strParent = 'Q' WHERE (strSystemId = 'SIC3' OR strSystemId = 'SIC31') AND strValue = '99'

UPDATE clasValue SET strParent = 'A' WHERE strSystemId = 'SIC4' AND strValue = '01'
UPDATE clasValue SET strParent = 'A' WHERE strSystemId = 'SIC4' AND strValue = '02'
UPDATE clasValue SET strParent = 'A' WHERE strSystemId = 'SIC4' AND strValue = '03'
UPDATE clasValue SET strParent = 'B' WHERE strSystemId = 'SIC4' AND strValue = '05'
UPDATE clasValue SET strParent = 'B' WHERE strSystemId = 'SIC4' AND strValue = '06'
UPDATE clasValue SET strParent = 'B' WHERE strSystemId = 'SIC4' AND strValue = '07'
UPDATE clasValue SET strParent = 'B' WHERE strSystemId = 'SIC4' AND strValue = '08'
UPDATE clasValue SET strParent = 'B' WHERE strSystemId = 'SIC4' AND strValue = '09'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '10'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '11'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '12'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '13'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '14'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '15'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '16'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '17'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '18'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '19'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '20'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '21'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '22'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '23'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '24'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '25'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '26'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '27'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '28'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '29'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '30'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '31'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '32'
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'SIC4' AND strValue = '33'
UPDATE clasValue SET strParent = 'D' WHERE strSystemId = 'SIC4' AND strValue = '35'
UPDATE clasValue SET strParent = 'E' WHERE strSystemId = 'SIC4' AND strValue = '36'
UPDATE clasValue SET strParent = 'E' WHERE strSystemId = 'SIC4' AND strValue = '37'
UPDATE clasValue SET strParent = 'E' WHERE strSystemId = 'SIC4' AND strValue = '38'
UPDATE clasValue SET strParent = 'E' WHERE strSystemId = 'SIC4' AND strValue = '39'
UPDATE clasValue SET strParent = 'F' WHERE strSystemId = 'SIC4' AND strValue = '41'
UPDATE clasValue SET strParent = 'F' WHERE strSystemId = 'SIC4' AND strValue = '42'
UPDATE clasValue SET strParent = 'F' WHERE strSystemId = 'SIC4' AND strValue = '43'
UPDATE clasValue SET strParent = 'G' WHERE strSystemId = 'SIC4' AND strValue = '45'
UPDATE clasValue SET strParent = 'G' WHERE strSystemId = 'SIC4' AND strValue = '46'
UPDATE clasValue SET strParent = 'G' WHERE strSystemId = 'SIC4' AND strValue = '47'
UPDATE clasValue SET strParent = 'H' WHERE strSystemId = 'SIC4' AND strValue = '49'
UPDATE clasValue SET strParent = 'H' WHERE strSystemId = 'SIC4' AND strValue = '50'
UPDATE clasValue SET strParent = 'H' WHERE strSystemId = 'SIC4' AND strValue = '51'
UPDATE clasValue SET strParent = 'H' WHERE strSystemId = 'SIC4' AND strValue = '52'
UPDATE clasValue SET strParent = 'H' WHERE strSystemId = 'SIC4' AND strValue = '53'
UPDATE clasValue SET strParent = 'I' WHERE strSystemId = 'SIC4' AND strValue = '55'
UPDATE clasValue SET strParent = 'I' WHERE strSystemId = 'SIC4' AND strValue = '56'
UPDATE clasValue SET strParent = 'J' WHERE strSystemId = 'SIC4' AND strValue = '58'
UPDATE clasValue SET strParent = 'J' WHERE strSystemId = 'SIC4' AND strValue = '59'
UPDATE clasValue SET strParent = 'J' WHERE strSystemId = 'SIC4' AND strValue = '60'
UPDATE clasValue SET strParent = 'J' WHERE strSystemId = 'SIC4' AND strValue = '61'
UPDATE clasValue SET strParent = 'J' WHERE strSystemId = 'SIC4' AND strValue = '62'
UPDATE clasValue SET strParent = 'J' WHERE strSystemId = 'SIC4' AND strValue = '63'
UPDATE clasValue SET strParent = 'K' WHERE strSystemId = 'SIC4' AND strValue = '64'
UPDATE clasValue SET strParent = 'K' WHERE strSystemId = 'SIC4' AND strValue = '65'
UPDATE clasValue SET strParent = 'K' WHERE strSystemId = 'SIC4' AND strValue = '66'
UPDATE clasValue SET strParent = 'L' WHERE strSystemId = 'SIC4' AND strValue = '68'
UPDATE clasValue SET strParent = 'M' WHERE strSystemId = 'SIC4' AND strValue = '69'
UPDATE clasValue SET strParent = 'M' WHERE strSystemId = 'SIC4' AND strValue = '70'
UPDATE clasValue SET strParent = 'M' WHERE strSystemId = 'SIC4' AND strValue = '71'
UPDATE clasValue SET strParent = 'M' WHERE strSystemId = 'SIC4' AND strValue = '72'
UPDATE clasValue SET strParent = 'M' WHERE strSystemId = 'SIC4' AND strValue = '73'
UPDATE clasValue SET strParent = 'M' WHERE strSystemId = 'SIC4' AND strValue = '74'
UPDATE clasValue SET strParent = 'M' WHERE strSystemId = 'SIC4' AND strValue = '75'
UPDATE clasValue SET strParent = 'N' WHERE strSystemId = 'SIC4' AND strValue = '77'
UPDATE clasValue SET strParent = 'N' WHERE strSystemId = 'SIC4' AND strValue = '78'
UPDATE clasValue SET strParent = 'N' WHERE strSystemId = 'SIC4' AND strValue = '79'
UPDATE clasValue SET strParent = 'N' WHERE strSystemId = 'SIC4' AND strValue = '80'
UPDATE clasValue SET strParent = 'N' WHERE strSystemId = 'SIC4' AND strValue = '81'
UPDATE clasValue SET strParent = 'N' WHERE strSystemId = 'SIC4' AND strValue = '82'
UPDATE clasValue SET strParent = 'O' WHERE strSystemId = 'SIC4' AND strValue = '84'
UPDATE clasValue SET strParent = 'P' WHERE strSystemId = 'SIC4' AND strValue = '85'
UPDATE clasValue SET strParent = 'Q' WHERE strSystemId = 'SIC4' AND strValue = '86'
UPDATE clasValue SET strParent = 'Q' WHERE strSystemId = 'SIC4' AND strValue = '87'
UPDATE clasValue SET strParent = 'Q' WHERE strSystemId = 'SIC4' AND strValue = '88'
UPDATE clasValue SET strParent = 'R' WHERE strSystemId = 'SIC4' AND strValue = '90'
UPDATE clasValue SET strParent = 'R' WHERE strSystemId = 'SIC4' AND strValue = '91'
UPDATE clasValue SET strParent = 'R' WHERE strSystemId = 'SIC4' AND strValue = '92'
UPDATE clasValue SET strParent = 'R' WHERE strSystemId = 'SIC4' AND strValue = '93'
UPDATE clasValue SET strParent = 'S' WHERE strSystemId = 'SIC4' AND strValue = '94'
UPDATE clasValue SET strParent = 'S' WHERE strSystemId = 'SIC4' AND strValue = '95'
UPDATE clasValue SET strParent = 'S' WHERE strSystemId = 'SIC4' AND strValue = '96'
UPDATE clasValue SET strParent = 'T' WHERE strSystemId = 'SIC4' AND strValue = '97'
UPDATE clasValue SET strParent = 'T' WHERE strSystemId = 'SIC4' AND strValue = '98'
UPDATE clasValue SET strParent = 'U' WHERE strSystemId = 'SIC4' AND strValue = '99'

UPDATE clasValue
SET strParent = CASE 
		WHEN LEN(strValue) = 4 THEN SUBSTRING(strValue, 0, LEN(strValue) - 1)
		WHEN LEN(strValue) > 2 THEN SUBSTRING(strValue, 0, LEN(strValue))
	END
FROM clasValue
WHERE strSystemId = 'Nace2'
	AND strParent IS NULL

UPDATE clasValue SET strParent = 'A' WHERE strSystemId = 'Nace2' AND strValue IN ('01', '02', '03')
UPDATE clasValue SET strParent = 'B' WHERE strSystemId = 'Nace2' AND strValue  IN ('05', '06', '07', '08', '09')
UPDATE clasValue SET strParent = 'C' WHERE strSystemId = 'Nace2' AND strValue  IN ('10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33')
UPDATE clasValue SET strParent = 'D' WHERE strSystemId = 'Nace2' AND strValue  IN ('35')
UPDATE clasValue SET strParent = 'E' WHERE strSystemId = 'Nace2' AND strValue  IN ('36', '37', '38', '39')
UPDATE clasValue SET strParent = 'F' WHERE strSystemId = 'Nace2' AND strValue  IN ('41', '42', '43')
UPDATE clasValue SET strParent = 'G' WHERE strSystemId = 'Nace2' AND strValue  IN ('45', '46', '47')
UPDATE clasValue SET strParent = 'H' WHERE strSystemId = 'Nace2' AND strValue  IN ('49', '50', '51', '52', '53')
UPDATE clasValue SET strParent = 'I' WHERE strSystemId = 'Nace2' AND strValue  IN ('55', '56')
UPDATE clasValue SET strParent = 'J' WHERE strSystemId = 'Nace2' AND strValue  IN ('58', '59', '60', '61', '62', '63')
UPDATE clasValue SET strParent = 'K' WHERE strSystemId = 'Nace2' AND strValue  IN ('64', '65', '66')
UPDATE clasValue SET strParent = 'L' WHERE strSystemId = 'Nace2' AND strValue  IN ('68')
UPDATE clasValue SET strParent = 'M' WHERE strSystemId = 'Nace2' AND strValue  IN ('69', '70', '71', '72', '73', '74', '75')
UPDATE clasValue SET strParent = 'N' WHERE strSystemId = 'Nace2' AND strValue  IN ('77', '78', '79', '80', '81', '82')
UPDATE clasValue SET strParent = 'O' WHERE strSystemId = 'Nace2' AND strValue  IN ('84')
UPDATE clasValue SET strParent = 'P' WHERE strSystemId = 'Nace2' AND strValue  IN ('85')
UPDATE clasValue SET strParent = 'Q' WHERE strSystemId = 'Nace2' AND strValue  IN ('86', '87', '88')
UPDATE clasValue SET strParent = 'R' WHERE strSystemId = 'Nace2' AND strValue  IN ('90', '91', '92', '93')
UPDATE clasValue SET strParent = 'S' WHERE strSystemId = 'Nace2' AND strValue  IN ('94', '95', '96')
UPDATE clasValue SET strParent = 'T' WHERE strSystemId = 'Nace2' AND strValue  IN ('97', '98')
UPDATE clasValue SET strParent = 'U' WHERE strSystemId = 'Nace2' AND strValue  IN ('99')