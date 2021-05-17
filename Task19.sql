USE Learning
GO

/*
There is a table 'Employee' with next columns:
   'Name' VARCHAR(32)
   'Balance' Money
Assume next scenario: 10 rows were inserted into the table on day1. 
And let's say 12 records were inserted on day2 where 10 of 12 have the same Names as were inserted on day1 
BUT with different values in the column Balance.
Write a SQL script to remove all 10 redundant (duplicated) rows inserted on day2.
Note: Assume there was no DB Server maintenance starting from the day2.
*/
DROP TABLE IF EXISTS Employee19
CREATE TABLE Employee19
(
	Name VARCHAR(32),
    Balance Money
)
GO

INSERT INTO Employee19
SELECT TOP 10 full_name, salary FROM [employee17]
GO

INSERT INTO Employee19
SELECT TOP 12 full_name, salary*1.5 FROM [employee17]
GO

SELECT Name, Balance
   FROM Employee19
   GROUP BY Name, Balance
   ORDER BY Name
GO

-----------VERSION 1-----------
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


-----------VERSION 2-----------
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


-----------select necessary employees-----------
WITH CTE
AS (SELECT [Name], [Balance],
           ROW_NUMBER() OVER(PARTITION BY [Name]
           ORDER BY [Name]) AS ID
    FROM [Employee19])
,
CTE1
AS(
	SELECT [Name], MAX(ID) AS MAXID
	FROM CTE
	GROUP BY Name
)

SELECT C1.Name, C2.Balance
	FROM CTE1 AS C1
	INNER JOIN CTE AS C2
	ON C1.MAXID=C2.ID AND C1.Name=C2.Name
GO
