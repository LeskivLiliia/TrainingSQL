USE Learning
GO

/*
	Write a query to find the number of working employees, theirs min,
	average and max salary by department.
	Additionally, the query has to return max and min salary among 
	employees hired this year by department.

*/




DROP PROCEDURE IF EXISTS uspTask15
GO

CREATE PROCEDURE uspTask15
AS
	BEGIN
		DROP TABLE IF EXISTS EMPLOYEE;
		--create table
		CREATE TABLE EMPLOYEE (
			 FULL_NAME VARCHAR(50),
			 IS_ACTIVE BIT,
			 DEPARTMENT VARCHAR(50),
			 SALARY SMALLMONEY,
			 HIRE_DATE DATE);

		--populate value
		INSERT INTO EMPLOYEE(FULL_NAME, IS_ACTIVE, DEPARTMENT, SALARY, HIRE_DATE)
			VALUES ('Aaron Smith', 1, 'IT', '600', '2020-02-09')
				   ,('Hugh Avery', 1, 'IT', '800', '2020-08-05')
				   ,('Marisha Barnes', 1, 'Healthcare', '650', '2019-07-15')
				   ,('Nate Winters', 1, 'Healthcare', '500', '2020-07-29')
				   ,('Grant Adamczik', 1, 'Retail', '300', '2019-12-18')
				   ,('Sandy Brown', 0, 'IT', '950', '2020-03-11')
				   ,('Mary Right', 1, 'Retail', '400', '2019-02-18');

		--select value subquery, which have left join
		SELECT E.DEPARTMENT 
			   ,EmpNumber 
			   ,MinSalary  
			   ,AvgSalary 
			   ,MaxSalary 
			   ,MinSalaryThisYear
			   ,MaxSalaryThisYear
		FROM
			(SELECT DEPARTMENT
					,COUNT(1) AS EmpNumber 
					,MIN(SALARY) AS MinSalary  
					,AVG(SALARY) AS AvgSalary 
					,MAX(SALARY) AS MaxSalary 
				FROM EMPLOYEE	
				WHERE IS_ACTIVE = 1
				GROUP BY DEPARTMENT) E
		LEFT JOIN 
			 --additional query to check max and min salary among employees hired this year .
			(SELECT DEPARTMENT
					,MIN(SALARY) AS MinSalaryThisYear 
					,MAX(SALARY) AS   MaxSalaryThisYear
				FROM EMPLOYEE 
				WHERE YEAR(HIRE_DATE) = YEAR(GETDATE())-1
				GROUP BY DEPARTMENT) T1 
		ON E.DEPARTMENT = T1.DEPARTMENT
	END
GO

EXEC uspTask15 
GO

