USE Learning
GO

/*
	Create a table SALARY with the following columns:
		FULL_NAME
		DEPARTMENT
		SALARY
	SQL script should return a person from each department with the biggest salary.
*/
DROP TABLE IF EXISTS SALARY;
 GO
 
CREATE TABLE SALARY (
    FULL_NAME VARCHAR(20),
    DEPARTMENT VARCHAR(10),
    SALARY SMALLMONEY
);
 GO

INSERT INTO SALARY (FULL_NAME, DEPARTMENT, SALARY) VALUES
    ('Leonardo Da Vinci', 'Retail', 1200),
    ('Sando Botticelli', 'Healthcare', 1300),
    ('Giorgio Vasari', 'Retail', 900),
    ('Rafaelo Santi', 'Retail', 1000),
    ('Michelangelo', 'Healthcare', 1800);
GO

DROP PROCEDURE IF EXISTS uspTask10
GO

CREATE PROCEDURE uspTask10
AS
	BEGIN
		SELECT * FROM SALARY
			WHERE SALARY IN (SELECT MAX(SALARY) FROM SALARY GROUP BY DEPARTMENT)
			GROUP BY DEPARTMENT, FULL_NAME, SALARY
	END
GO

EXEC uspTask10 
GO
