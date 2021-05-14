USE [Learning]
GO

--SELECT * FROM EMPLOYEE16 AS e1
--WHERE (e1.[DEPARTMENT],e1.[SALARY]) IN 
-- (SELECT e2.[DEPARTMENT],e2.[SALARY]
--  FROM EMPLOYEE16 AS e2
--  WHERE e2.[FULL_NAME] <> e1.[FULL_NAME])



select e1.* 
  from EMPLOYEE16 e1 inner join (
    select count([FULL_NAME]) as CNT, [DEPARTMENT], [SALARY] 
    from EMPLOYEE16 group by [DEPARTMENT], [SALARY]) t1 
  on e1.[DEPARTMENT]=t1.[DEPARTMENT] and e1.[SALARY]=t1.[SALARY] 
  where t1.CNT>1

select [FULL_NAME], [DEPARTMENT], [SALARY]
from EMPLOYEE16 where [FULL_NAME] in 
(select [FULL_NAME] from EMPLOYEE16
group by  [FULL_NAME]
having COUNT(*) > 1)