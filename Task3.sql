USE Learning
GO

/*
	Declare nvarchar(300) variable an assign some value.
	SQL script should find a word which has the biggest amount of occurrences in that string.
	Example. If your string value  is 
		‘Leonardo Da Vinci is the biggest biggest genius in world history’ 
	then result should be ‘biggest’.

*/
DROP PROCEDURE IF EXISTS uspTask3
GO

CREATE PROCEDURE uspTask3 @String NVARCHAR(300), @Result NVARCHAR(50) OUTPUT
AS
    BEGIN
		--Table that contain splited words 
		DECLARE @TblFrequency TABLE 
						(Word NVARCHAR(100)
						 ,CountOfWord INT)
		--Populate splited words and their count into table
		INSERT INTO @TblFrequency
		SELECT value, COUNT(value) AS CountOfWord
				FROM STRING_SPLIT(@String, ' ')
				GROUP BY value
		--Select words which have max count
		SELECT @Result = (SELECT Word FROM @TblFrequency
							WHERE CountOfWord = (SELECT MAX(CountOfWord) FROM @TblFrequency))

	END
GO

DECLARE @Result NVARCHAR(50) 

EXEC uspTask3 @String = 'Leonardo Da Vinci is the biggest biggest genius in world history'
			  ,@Result = @Result OUTPUT

SELECT @Result
