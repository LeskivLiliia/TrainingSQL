USE Learning
GO

/*
	Create a stored procedure which will have two parameters 
	(start and end dates in ‘DD/MM/YYYY’ format). 
	When executing – it should produce all dates between start and end dates.
	For example:
	exec dates_range ‘12/09/2020’, ‘17/09/2020’
	should produce:
	12/09/2020
	13/09/2020
	14/09/2020
	15/09/2020
	16/09/2020
	17/09/2020
*/

DROP PROCEDURE IF EXISTS uspTask5
GO

CREATE PROCEDURE uspTask5 @StartDate DATE, @EndDate DATE
AS
	BEGIN
		WITH DateRange(CurrDate) AS
		(
			SELECT @StartDate AS Date
			UNION ALL
			SELECT DATEADD(DAY,1,CurrDate)
			FROM DateRange
			WHERE CurrDate < @EndDate
		)
		SELECT CONVERT(VARCHAR, CurrDate, 103)
			FROM DateRange
			OPTION (MAXRECURSION 0)
	END
GO

DECLARE @StartDate DATE = CONVERT(DATE, '12/09/2020', 103)
	   ,@EndDate DATE = CONVERT(DATE, '17/09/2020', 103)

EXEC uspTask5 @StartDate, @EndDate