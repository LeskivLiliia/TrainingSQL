USE Learning
GO

/*
	Declare nvarchar(20) variable and assign some value with length <= 20.
	SQL script should add leading zeros to that string up to 20 symbols.
	Example 1. If your string value is ‘666777’ then result should be ‘00000000000000666777’.
	Example 2. If your string value is ‘123’ then result should be ‘00000000000000000123’.
	Important note: using CASE/IF statements is not allowed.
*/
DROP PROCEDURE IF EXISTS uspTask1
GO

CREATE PROCEDURE uspTask1 @String NVARCHAR(20), @Lenght INT, @AdditionalValue NVARCHAR(10), @Result NVARCHAR(20) OUTPUT
AS
    BEGIN
		--Using REPLICATE that repeats a value specified number of times
		SELECT @Result = CONCAT(REPLICATE(@AdditionalValue, @Lenght - LEN(@String)),@String)
	END
GO

DECLARE @Result NVARCHAR(20) 
EXEC uspTask1 @String = '123'
			  ,@Lenght = 20
			  ,@AdditionalValue = '0'
			  ,@Result = @Result OUTPUT

SELECT @Result
