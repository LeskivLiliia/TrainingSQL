USE Learning
GO

/*
Write a query to find all employee's salary 
when the employee earn less than 75% of employees
from same department


full_name                      department        salary 
Mohammad Nunez                 audit             200,00
Lubna Mcphee                   marketing         200,00
Abbigail Mcculloch             production        400,00
Huma Howard                    production        430,00

*/


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
