USE [Learning]
GO

SELECT FULL_NAME
	  ,[DATE]
	  ,LAG(SALARY,1) OVER(PARTITION BY FULL_NAME ORDER BY [DATE]) AS PREVIOUS_DAY
	  ,SALARY AS CURRENT_DAY  
	  ,LEAD(SALARY,1) OVER(PARTITION BY FULL_NAME ORDER BY [DATE]) AS NEXT_DAY
FROM DAYS_SALARIES 
