USE Learning
GO

/*
	Returns all products which are present 
	in all shops simultaneously
*/

DROP PROCEDURE IF EXISTS uspTask20
GO

CREATE PROCEDURE uspTask20
AS
	BEGIN
		DROP TABLE IF EXISTS #ProductRemainder;
		
		--Create table
		CREATE TABLE #ProductRemainder (
			 ID INT IDENTITY (1,1) PRIMARY KEY
			,Shop VARCHAR(30) NOT NULL
			,Product VARCHAR(30) NOT NULL
			,iCount INT NOT NULL
		)
		
		--Populate data
		INSERT INTO #ProductRemainder (Shop, Product, iCount) VALUES ('s1', 'Coca-Cola 1l.', 10)
		INSERT INTO #ProductRemainder (Shop, Product, iCount) VALUES ('s2', 'Coca-Cola 1l.', 14)
		INSERT INTO #ProductRemainder (Shop, Product, iCount) VALUES ('s3', 'Coca-Cola 1l.', 154)
		INSERT INTO #ProductRemainder (Shop, Product, iCount) VALUES('s1', 'Water 2l.', 10)
		INSERT INTO #ProductRemainder (Shop, Product, iCount) VALUES ('s3', 'Water 2l.', 40)
		INSERT INTO #ProductRemainder (Shop, Product, iCount) VALUES ('s1', 'Beer 0.5l.', 17)
		INSERT INTO #ProductRemainder (Shop, Product, iCount) VALUES ('s2', 'Beer 0.5l.', 1040)
		INSERT INTO #ProductRemainder (Shop, Product, iCount) VALUES ('s3', 'Beer 0.5l.', 1400)
		

		SELECT Product  FROM #ProductRemainder
			GROUP BY Product
			--Count of products must be equal count of shops
			HAVING COUNT(Product) = (SELECT COUNT(DISTINCT Shop) FROM #ProductRemainder)
	END
GO

EXEC uspTask20
GO