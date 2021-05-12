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
		WITH Date_CTE 
		AS 
		(SELECT [Date] = @StartDate 
			UNION ALL 
		 SELECT [Date] = DATEADD(day, 1, [Date])
			FROM Date_CTE
			WHERE [Date] < @EndDate
		)
		SELECT [Date]
		FROM Date_CTE
		--OPTION (MAXRECURSION 0)
	END
GO

EXEC uspTask5 @StartDate = CAST('2014-04-01' AS date)
			  ,@EndDate=CAST('2014-05-02' AS DATE)
GO