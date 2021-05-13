USE Learning
GO

/*
	Should return a JSON with persons who are working in 
	more than one department altogether with theirs salary.
*/

DROP PROCEDURE IF EXISTS uspTask13
GO

CREATE PROCEDURE uspTask13
AS
	BEGIN
		DROP TABLE IF EXISTS SALARY;
		--Create table
		CREATE TABLE SALARY (FULL_NAME VARCHAR(50)
							 ,DEPARTMENT VARCHAR(50)
							 ,SALARY SMALLMONEY);

		--Populate value
		INSERT INTO SALARY(FULL_NAME, DEPARTMENT, SALARY) VALUES ('Leonardo Da Vinci', 'Retail', '400.00')
		INSERT INTO SALARY(FULL_NAME, DEPARTMENT, SALARY) VALUES ('Sando Botticelli', 'Healthcare  ', '500.00')
		INSERT INTO SALARY(FULL_NAME, DEPARTMENT, SALARY) VALUES ('Giorgio', 'Vasari Retail', '400.00')
		INSERT INTO SALARY(FULL_NAME, DEPARTMENT, SALARY) VALUES ('Leonardo Da Vinci', 'Healthcare', '600.00')
		INSERT INTO SALARY(FULL_NAME, DEPARTMENT, SALARY) VALUES('Rafaelo Santi', 'Retail', '450.00')
		INSERT INTO SALARY(FULL_NAME, DEPARTMENT, SALARY) VALUES ('Michelangelo', 'Healthcare', '480.00')
		INSERT INTO SALARY(FULL_NAME, DEPARTMENT, SALARY) VALUES('Leonardo Da Vinci', 'IT', '800.00')
		INSERT INTO SALARY(FULL_NAME, DEPARTMENT, SALARY) VALUES('Rafaelo Santi', 'IT', '1450.00');

		--Return JSON
		SELECT FULL_NAME, 
			--Select all department and salary for one name
			(SELECT DEPARTMENT, SALARY FROM SALARY Internal
				WHERE Main.FULL_NAME=Internal.FULL_NAME
				FOR JSON PATH) AS departments
			FROM SALARY Main
			--Search names which occur more than 1 time
			WHERE FULL_NAME IN (SELECT FULL_NAME FROM SALARY
									GROUP BY FULL_NAME
									HAVING COUNT(DEPARTMENT) > 1)
			GROUP BY FULL_NAME
			FOR JSON PATH 
	END
GO

EXEC uspTask13 
GO
