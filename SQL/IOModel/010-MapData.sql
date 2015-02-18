CREATE PROCEDURE sor.map
AS 
BEGIN

	BEGIN TRANSACTION
		TRUNCATE TABLE mapped.Consumption
		TRUNCATE TABLE mapped.Production
		--TRUNCATE TABLE mapped.Export
		TRUNCATE TABLE mapped.TotalEmissions
		
		RAISERROR('Consumption', 0, 0)
		
		INSERT INTO mapped.Consumption (intYear, strRegion, strSourceValue, strTargetValue, fltConsumption)
		SELECT c.intYear, c.strRegion, s.strSystem2Value, t.strSystem2Value, SUM(c.fltConsumption * s.fltWeight * t.fltWeight)
		FROM sor.Consumption c
			INNER JOIN ClassificationSystems..clasMap s ON s.strSystem1Id = c.strSystem AND s.strSystem1Value = c.strSourceValue
			INNER JOIN ClassificationSystems..clasMap t ON t.strSystem1Id = c.strSystem AND t.strSystem1Value = c.strTargetValue
		GROUP BY c.intYear, c.strRegion, s.strSystem2Value, t.strSystem2Value
		
		
		RAISERROR('Supply', 0, 0)
		
		INSERT INTO mapped.Production (intYear, strRegion, strSourceValue, strTargetValue, fltProduction)
		SELECT p.intYear, p.strRegion, s.strSystem2Value, t.strSystem2Value, SUM(p.fltProduction * s.fltWeight * t.fltWeight)
		FROM sor.Production p
			INNER JOIN ClassificationSystems..clasMap s ON s.strSystem1Id = p.strSystem AND s.strSystem1Value = p.strSourceValue
			INNER JOIN ClassificationSystems..clasMap t ON t.strSystem1Id = p.strSystem AND t.strSystem1Value = p.strTargetValue
		GROUP BY p.intYear, p.strRegion, s.strSystem2Value, t.strSystem2Value
		
		
		--RAISERROR('Exports', 0, 0)
		
		--INSERT INTO mapped.Export (intYear, strSourceRegion, strTargetRegion, strSourceValue, strTargetValue, fltExport)
		--SELECT e.intYear, e.strSourceRegion, e.strTargetRegion, s.strSystem2Value, t.strSystem2Value, SUM(e.fltExport * s.fltWeight * t.fltWeight)
		--FROM sor.Export e
		--	INNER JOIN ClassificationSystems..clasMap s ON s.strSystem1Id = e.strSystem AND s.strSystem1Value = e.strSourceValue
		--	INNER JOIN ClassificationSystems..clasMap t ON t.strSystem1Id = e.strSystem AND t.strSystem1Value = e.strTargetValue
		--GROUP BY e.intYear, e.strSourceRegion, e.strTargetRegion, s.strSystem2Value, t.strSystem2Value
		
		
		RAISERROR('Emissions', 0, 0)
		INSERT INTO mapped.TotalEmissions (intYear, strRegion, strValue, fltTotalEmissions)
		SELECT e.intYear, e.strRegion, m.strSystem2Value, SUM(e.fltEmission * m.fltWeight)
		FROM sor.Emission e
			INNER JOIN ClassificationSystems..clasMap m ON m.strSystem1Id = e.strSystem AND m.strSystem1Value = e.strValue
		GROUP BY e.intYear, e.strRegion, m.strSystem2Value
	COMMIT
END