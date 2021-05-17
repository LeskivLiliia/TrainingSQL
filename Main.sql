USE Learning
GO

----------------------------------------------------------
--TASK 8
----------------------------------------------------------
--find previos day for [DATE] column
WITH CTE
AS
(
	SELECT FULL_NAME, DAY_TYPE, [DATE]
			,CONVERT(varchar, [DATE],112) - ROW_NUMBER() 
			OVER (PARTITION BY FULL_NAME, DAY_TYPE ORDER BY [DATE]) AS PreviosDateForGroup
		FROM [DATA]
			   
)
--find start and end days for working and sickness days
,CTE1
AS(
	SELECT FULL_NAME, DAY_TYPE
			,CONVERT(DATE, MIN([DATE]), 23) AS SICKNESS_START 
			,CONVERT(DATE, Max([DATE]), 23) AS SICKNESS_END
		FROM CTE
		GROUP BY FULL_NAME, DAY_TYPE, PreviosDateForGroup
		ORDER BY 1,3 OFFSET 0 ROWS
)
--Select previous DAY_TYPE and SICKNESS_END
--for find employees which sick from Friday to Monday
, CTE2
AS
(
	SELECT FULL_NAME, DAY_TYPE,LEAD(DAY_TYPE,1) OVER (ORDER BY FULL_NAME,SICKNESS_START) AS LEAD_DAY_TYPE,
	SICKNESS_START, 
	SICKNESS_END,
	LEAD(SICKNESS_END,1) OVER (ORDER BY FULL_NAME,SICKNESS_START) AS LEAD_SICKNESS_END
	FROM CTE1
	ORDER BY 1 OFFSET 0 ROWS
)
--Union rows, where DAY_TYPE='Sickness' and LEAD_DAY_TYPE =!'Sickness'
--With rows, where DAY_TYPE = LEAD_DAY_TYPE 
SELECT FULL_NAME, SICKNESS_START, SICKNESS_END FROM CTE2 WHERE DAY_TYPE='Sickness' AND LEAD_DAY_TYPE <> 'Sickness'
UNION ALL
SELECT FULL_NAME, SICKNESS_START, LEAD_SICKNESS_END FROM CTE2 WHERE DAY_TYPE = LEAD_DAY_TYPE 
ORDER BY 1,2
GO

----------------------------------------------------------
--TASK 9
----------------------------------------------------------
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
GO

----------------------------------------------------------
--TASK 10
----------------------------------------------------------
SELECT * FROM SALARY
	WHERE SALARY IN (SELECT MAX(SALARY) FROM SALARY GROUP BY DEPARTMENT)
	GROUP BY DEPARTMENT, FULL_NAME, SALARY
GO

----------------------------------------------------------
--TASK 11
----------------------------------------------------------
IF EXISTS 
	(
		SELECT SE.FULL_NAME
		FROM SALARY_1 AS SE
		WHERE SE.SALARY > ANY(SELECT SUM(SALARY) FROM SALARY_1 GROUP BY DEPARTMENT)
	)
	SELECT 'YES'
ELSE 
	SELECT 'NO'
GO

----------------------------------------------------------
--TASK 12
----------------------------------------------------------
SELECT FULL_NAME
	  ,[DATE]
	  ,LAG(SALARY,1) OVER(PARTITION BY FULL_NAME ORDER BY [DATE]) AS PREVIOUS_DAY
	  ,SALARY AS CURRENT_DAY  
	  ,LEAD(SALARY,1) OVER(PARTITION BY FULL_NAME ORDER BY [DATE]) AS NEXT_DAY
FROM DAYS_SALARIES 
GO

----------------------------------------------------------
--TASK 13
----------------------------------------------------------
--Return JSON
SELECT FULL_NAME, 
	--Select all department and salary for one name
	(SELECT DEPARTMENT, SALARY FROM SALARY13 Internal
		WHERE Main.FULL_NAME=Internal.FULL_NAME
		FOR JSON PATH) AS departments
	FROM SALARY13 Main
	--Search names which occur more than 1 time
	WHERE FULL_NAME IN (SELECT FULL_NAME FROM SALARY13
							GROUP BY FULL_NAME
							HAVING COUNT(DEPARTMENT) > 1)
	GROUP BY FULL_NAME
	FOR JSON PATH
GO

----------------------------------------------------------
--TASK 14
----------------------------------------------------------
--Using rigth function that return only Last name
SELECT COUNT(*) AS COUNT_OF
	FROM Employee14
	WHERE RIGHT(FULL_NAME, LEN(FULL_NAME)-CHARINDEX(' ', FULL_NAME)) LIKE 'A%'
GO

--Using reverse and left functions that return: 'A skaM', 'P yirdnA'
--SELECT COUNT(*) AS COUNT_OF
--	FROM Employee14
--	WHERE REVERSE(LEFT(FULL_NAME, CHARINDEX(' ', FULL_NAME)+1)) LIKE 'A%'

--If full name consist of two names should use this version
--return last name
--SELECT COUNT(*) AS COUNT_OF
--	FROM Employee14
--	WHERE LTRIM(REVERSE(LEFT(REVERSE(FULL_NAME), CHARINDEX(' ', REVERSE(FULL_NAME))))) LIKE 'A%'

----------------------------------------------------------
--TASK 15
----------------------------------------------------------
--select value subquery, which have left join
SELECT E.DEPARTMENT, EmpNumber 
		,MinSalary, AvgSalary, MaxSalary 
		,MinSalaryThisYear, MaxSalaryThisYear
FROM
	(SELECT DEPARTMENT, COUNT(1) AS EmpNumber 
			,MIN(SALARY) AS MinSalary, AVG(SALARY) AS AvgSalary 
			,MAX(SALARY) AS MaxSalary 
		FROM EMPLOYEE15	
		WHERE IS_ACTIVE = 1
		GROUP BY DEPARTMENT) E
LEFT JOIN 
		--additional query to check max and min salary among employees hired this year .
	(SELECT DEPARTMENT
			,MIN(SALARY) AS MinSalaryThisYear 
			,MAX(SALARY) AS   MaxSalaryThisYear
		FROM EMPLOYEE15 
		WHERE YEAR(HIRE_DATE) = YEAR(GETDATE())-1
		GROUP BY DEPARTMENT) T1 
ON E.DEPARTMENT = T1.DEPARTMENT
GO

----------------------------------------------------------
--TASK 16
----------------------------------------------------------
SELECT E.[FULL_NAME], E.[DEPARTMENT], E.[SALARY]
FROM EMPLOYEE16 AS E
JOIN	
	--count rows with the same salary within the same department
	(SELECT COUNT([SALARY]) AS CountRow
			,[DEPARTMENT]
			,[SALARY]
		FROM EMPLOYEE16
		GROUP BY [DEPARTMENT], [SALARY]) AS E1
ON E.DEPARTMENT=E1.DEPARTMENT AND E.SALARY=E1.SALARY
WHERE E1.CountRow>1
GO

----------------------------------------------------------
--TASK 17
----------------------------------------------------------
WITH EmpNtile
AS
(
	SELECT full_name, department, salary  
	  ,NTILE(4) OVER(PARTITION BY department ORDER BY salary DESC) AS NtileSalDep
	FROM employee17
)
SELECT full_name
	  ,department
	  ,salary
	FROM EmpNtile
	WHERE NtileSalDep = 4
	ORDER BY department, salary
GO

----------------------------------------------------------
--TASK 18
----------------------------------------------------------
SELECT TOP 1 WITH TIES C1.StartTime AS IntervalStart, MIN(C2.EndTime) AS IntervalEnd, COUNT(*) AS ItervalCount
	FROM Calls C1, Calls C2
	WHERE 1=1
			AND C2.StartTime <= C1.StartTime AND C2.EndTime>=C1.StartTime
	GROUP BY C1.ID, C1.StartTime
	ORDER BY ItervalCount DESC
GO

----------------------------------------------------------
--TASK 19
----------------------------------------------------------
DROP TABLE IF EXISTS Employee19
GO

CREATE TABLE Employee19
(
	Name VARCHAR(32),
    Balance Money
)
GO

INSERT INTO Employee19
	SELECT TOP 10 full_name, salary 
	FROM [employee17]
GO

INSERT INTO Employee19
	SELECT TOP 12 full_name, salary*1.5 
	FROM [employee17]
GO

SELECT Name, Balance
   FROM Employee19
   GROUP BY Name, Balance
   ORDER BY Name
GO
------------------VERSION 1------------------
--Create ID column at table [Employee19]
WITH CTE_EmpID
AS (SELECT ROW_NUMBER() OVER(ORDER BY [Name], [Balance]) AS ID
		  ,[Name]
		  ,[Balance]
    FROM [Employee19])

--delete rows, where name occurs more then 1 time
DELETE E FROM CTE_EmpID E
    INNER JOIN
    (
        SELECT ID, [Name], [Balance], RANK() OVER(PARTITION BY [Name] ORDER BY ID) CountRow
        FROM CTE_EmpID
    ) T 
	ON E.ID = T.ID
    WHERE CountRow > 1;
GO

----------------VERSION 2------------------
--Create ID column at table [Employee19]
WITH CTE_EmpID
AS 
(
	SELECT ROW_NUMBER() OVER(ORDER BY [Name], [Balance]) AS ID
			  ,[Name]
			  ,[Balance]
		FROM [Employee19]
)
--Add duplicate count column
,CTE_NumerateDuplicate
AS
(
	SELECT ID, [Name], [Balance], ROW_NUMBER() OVER(PARTITION BY [Name] ORDER BY ID) DuplicateCount
        FROM CTE_EmpID
)
DELETE FROM CTE_NumerateDuplicate
	WHERE DuplicateCount > 1
GO
----------------------------------------------------------
--TASK 20
----------------------------------------------------------
SELECT Product  
	FROM ProductRemainder
	GROUP BY Product
	--Count of products must be equal count of shops
	HAVING COUNT(Product) = (SELECT COUNT(DISTINCT Shop) FROM ProductRemainder)
GO