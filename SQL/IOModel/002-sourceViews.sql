CREATE VIEW sor.vwGetAllUsedClasValues
AS

SELECT 'consumption' AS strIndicator, strSystem, strSourceValue
FROM sor.Consumption
GROUP BY strSystem, strSourceValue

UNION

SELECT 'production', strSystem, strSourceValue 
FROM sor.Production
GROUP BY strSystem, strSourceValue

UNION

SELECT 'emisisons', strSystem, strValue 
FROM sor.Emission
GROUP BY strSystem, strValue
