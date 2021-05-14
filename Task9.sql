USE Learning
GO

/*
	SQL-script should return sickness periods(start and end dates).
	So, using table above – expected result will be:
	FULL_NAME           SICKNESS_START SICKNESS_END
	Taras Koval             2020-08-18           2020-08-19
	Taras Koval             2020-08-21           2020-08-24
	Alex Shevchenko   2020-08-17           2020-08-19
	Alex Shevchenko   2020-08-21           2020-08-21
	Important Note: if person is on sickness on Friday and next Monday
					it is two sickness periods Friday - Friday and Monday - Monday.

*/
IF OBJECT_ID('dbo.[DATA]', 'U') is not null DROP TABLE [DATA]
 
CREATE TABLE [DATA]
(
    FULL_NAME VARCHAR (100),
    [DATE] DATE,
    DAY_TYPE VARCHAR (50)
)
 
INSERT INTO [DATA]
VALUES
('Taras Koval', '2020-08-17', 'Worked'),
('Taras Koval', '2020-08-18', 'Sickness'),
('Taras Koval', '2020-08-19', 'Sickness'),
('Taras Koval', '2020-08-20', 'Worked'),
('Taras Koval', '2020-08-21', 'Sickness'),
('Taras Koval', '2020-08-24', 'Sickness'),
('Alex Shevchenko', '2020-08-17', 'Sickness'),
('Alex Shevchenko', '2020-08-18', 'Sickness'),
('Alex Shevchenko', '2020-08-19', 'Sickness'),
('Alex Shevchenko', '2020-08-20', 'Worked'),
('Alex Shevchenko', '2020-08-21', 'Sickness')
 
GO

DROP PROCEDURE IF EXISTS uspTask9
GO

CREATE PROCEDURE uspTask9 
AS
	BEGIN		
		WITH CTE
		AS
		(
			SELECT FULL_NAME, DAY_TYPE, [DATE]
				  ,CONVERT(varchar, [DATE],112) - ROW_NUMBER() 
				   OVER (PARTITION BY FULL_NAME, DAY_TYPE ORDER BY [DATE]) AS PreviosDateForGroup
			   FROM [DATA]
			   WHERE DAY_TYPE = 'Sickness'
		)

		SELECT FULL_NAME
			   ,CONVERT(DATE, MIN([DATE]), 23) AS SICKNESS_START 
			   ,CONVERT(DATE, Max([DATE]), 23) AS SICKNESS_END
			FROM CTE
			GROUP BY FULL_NAME, DAY_TYPE, PreviosDateForGroup
			ORDER BY 1
	END
GO

EXEC uspTask9 
GO
