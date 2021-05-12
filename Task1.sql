USE Learning
GO

/*
	Declare nvarchar(20) variable and assign some value with length <= 20.
	SQL script should add leading zeros to that string up to 20 symbols.
	Example 1. If your string value is ‘666777’ then result should be ‘00000000000000666777’.
	Example 2. If your string value is ‘123’ then result should be ‘00000000000000000123’.
	Important note: using CASE/IF statements is not allowed.

*/
 
DECLARE @String NVARCHAR(20)
DECLARE @Lenght INT 
DECLARE @AdditionalValue NVARCHAR(10)

SET @String = '123'
SET @Lenght = 20
SET @AdditionalValue = '0'
 
--Using REPLICATE that repeats a value specified number of times
SET @String = (SELECT CONCAT(REPLICATE(@AdditionalValue, @Lenght - LEN(@String)),@String))
SELECT @String AS Result

