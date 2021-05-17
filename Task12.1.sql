USE Learning
GO

/*
	Leonardo da Vinci	2020-08-21	50.00
	Leonardo da Vinci	2020-08-22	40.00
	Leonardo da Vinci	2020-08-23	60.00
	Leonardo da Vinci	2020-08-24	70.00
	Leonardo da Vinci	2020-08-25	NULL
	Leonardo da Vinci	2020-08-26	NULL

	Sandro Botticelli	2020-08-21	30.00
	Sandro Botticelli	2020-08-22	25.00
	Sandro Botticelli	2020-08-23	40.00
	Sandro Botticelli	2020-08-24	NULL
	Sandro Botticelli	2020-08-25	NULL
	Sandro Botticelli	2020-08-26	NULL

*/

DROP TABLE IF EXISTS ##Dates

CREATE TABLE ##Dates
(Dates date)

DECLARE @StartDate DATE = CAST('2020-08-21' AS date)
	   ,@EndDate   DATE = CAST('2020-08-26' AS date);

WITH Date_CTE
AS
(
	SELECT [Date] = @startDate 
    UNION ALL 
    SELECT [Date] = DATEADD(day, 1, [Date])
    FROM Date_CTE
    WHERE [Date] < @EndDate
)

INSERT INTO ##Dates
SELECT [Date] FROM Date_CTE OPTION (MAXRECURSION 0) 
GO


SELECT D.FULL_NAME, D.Dates, DS.SALARY FROM DAYS_SALARIES AS DS
RIGHT JOIN 
(
	SELECT DISTINCT FULL_NAME, ##Dates.Dates 
	FROM DAYS_SALARIES
	CROSS JOIN ##Dates
) AS D
ON DS.DATE = D.Dates AND DS.FULL_NAME = D.FULL_NAME

