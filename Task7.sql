USE Learning
GO

/*
	Should calculate how many leap years are 
	from your birth date till today.
*/

DROP FUNCTION IF EXISTS ufn_IsLeapYear
GO

CREATE FUNCTION ufn_IsLeapYear (@Yearr int)
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	IF (@Yearr % 4 = 0 and @Yearr % 100 != 0) or (@Yearr % 400 = 0)
		SET @Result = 1
	ELSE 
		SET @Result = 0
	
	RETURN @Result	
END
GO

DROP PROCEDURE IF EXISTS uspTask7
GO

CREATE PROCEDURE uspTask7 @Birthday DATE, @CountLeapYear INT OUTPUT
AS
	BEGIN
		--return list of years start from birthday
		WITH CTE_Years 
		AS
		(
			SELECT YEAR(@Birthday) AS Yearr
			UNION ALL
			SELECT Yearr + 1 AS Yearr FROM CTE_Years WHERE Yearr < YEAR(GETDATE())
		)
		--populate data in temp table
		SELECT * INTO #Years FROM CTE_Years

		--return count of rows with value 1
		SELECT @CountLeapYear = (SELECT COUNT(*) 
									--check if these are leap years
									FROM (SELECT dbo.ufn_IsLeapYear(Yearr) AS RESULT 
											 FROM #Years
											 WHERE dbo.ufn_IsLeapYear(Yearr) = 1) AS R)
	END
GO

DECLARE  @CountLeapYear INT

EXEC uspTask7 @Birthday = '2004-11-11', @CountLeapYear = @CountLeapYear OUTPUT

SELECT @CountLeapYear AS CountLeapYear
GO
