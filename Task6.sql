USE Learning
GO

/*
	Create a table-value function which will have one parameter (date in ‘DD/MM/YYYY’).
	When running – it should produce all dates for the month where parameter date belongs.
*/
DROP FUNCTION IF EXISTS [tvf_Task6]
GO

CREATE FUNCTION [dbo].[tvf_Task6] (@InputDate DATE)
RETURNS TABLE
AS
RETURN 
(
	--Using recursive CTE for generate 
	WITH MonthDays_CTE(DayNum)
	AS
	(
		SELECT DATEFROMPARTS(YEAR(@InputDate), MONTH(@InputDate), 1) AS DayNum
		UNION ALL
		SELECT DATEADD(DAY, 1, DayNum) FROM MonthDays_CTE
		  WHERE DayNum < EOMONTH(DATEFROMPARTS(YEAR(@InputDate), MONTH(@InputDate), 1))
	)
	SELECT 
	CONVERT(VARCHAR, DayNum, 3) AS DayNum
	FROM MonthDays_CTE
)
GO

DECLARE @InputDate DATE = CONVERT(DATE,'23/08/2020', 103)

SELECT * FROM [tvf_Task6](@InputDate)
GO

