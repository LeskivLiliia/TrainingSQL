USE [Learning]
GO
/*
	Should return  number of employees which last name starts with A
*/
DROP PROCEDURE IF EXISTS uspTask14
GO

CREATE PROCEDURE uspTask14
AS
	BEGIN
		DROP TABLE IF EXISTS Employee;
 
		--create table
		CREATE TABLE Employee(FULL_NAME varchar(20))

		--populate value
		INSERT INTO Employee(FULL_NAME) VALUES ('Maks Andrusyk')
		INSERT INTO Employee(FULL_NAME) VALUES ('Andriy Pattinson')
		INSERT INTO Employee(FULL_NAME) VALUES ('Tom Kruz')
		INSERT INTO Employee(FULL_NAME) VALUES ('Tom Hardy')
		INSERT INTO Employee(FULL_NAME) VALUES ('Rowan Atkinson')

		--Using rigth function that return only Last name
		SELECT COUNT(*) AS COUNT_OF
			FROM Employee
			WHERE RIGHT(FULL_NAME, LEN(FULL_NAME)-CHARINDEX(' ', FULL_NAME)) LIKE 'A%'
		
		--Using reverse and left functions that return: 'A skaM', 'P yirdnA'
		--SELECT COUNT(*) AS COUNT_OF
		--	FROM Employee
		--	WHERE REVERSE(LEFT(FULL_NAME, CHARINDEX(' ', FULL_NAME)+1)) LIKE 'A%'

		--if full name consist of two names should use this version
		--return last name
		--SELECT COUNT(*) AS COUNT_OF
		--	FROM Employee
		--	WHERE LTRIM(REVERSE(LEFT(REVERSE(FULL_NAME), CHARINDEX(' ', REVERSE(FULL_NAME))))) LIKE 'A%'

	END
GO

EXEC uspTask14 
GO
