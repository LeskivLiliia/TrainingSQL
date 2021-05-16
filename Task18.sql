USE Learning
GO

/*
	Write a query to find the time interval with the most concurrent calls


	The Query should return:
	IntervalStart               IntervalEnd                 ItervalCount
	1900-04-10 14:31:00.123     1900-04-10 16:40:10.920     651
	1900-04-10 19:20:32.230     1900-04-10 22:19:47.423     651
	1900-04-10 22:37:19.707     1900-04-11 01:00:01.213     651
*/

SELECT TOP 1 WITH TIES C1.StartTime AS IntervalStart, MIN(C2.EndTime) AS IntervalEnd, COUNT(*) AS ItervalCount
	FROM Calls C1, Calls C2
	WHERE 1=1
			AND C2.StartTime <= C1.StartTime AND C2.EndTime>=C1.StartTime
	GROUP BY C1.ID, C1.StartTime
	ORDER BY ItervalCount DESC
GO