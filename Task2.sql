USE Learning
GO

/*
	Declare nvarchar(300) variable and assign some value.
	That value should consists of substring which are separated by slash (e.g. ‘a1/a2/a3/a4/a5/a6/a7’).
	SQL script should retrieve a value between 4th and 5th slashes.
	Example 1. If your string value is ‘This/is/my/very/nice/test/string’ then result should be string ‘nice’.
	Example 2. If your string value is ‘Leonardo/Donatello/Rafael/Michelangelo/Botticelli/Vasari/Dante’ then result should be ‘Botticelli’.

*/
DROP PROCEDURE IF EXISTS uspTask2
GO

CREATE PROCEDURE uspTask2 @String NVARCHAR(300), @Separator NVARCHAR(2), @NecessaryValue INT, @Result NVARCHAR(50) OUTPUT
AS
    BEGIN
		--Table that contain splited words 
		DECLARE @TblSplitWord TABLE 
				(ID INT IDENTITY(1,1)
				 ,Word NVARCHAR(50))
		
		--populate data into table
		INSERT INTO @TblSplitWord 
		SELECT value FROM STRING_SPLIT(@String, @Separator)

		--select necessary value
		SELECT @Result = (SELECT Word FROM @TblSplitWord 
							WHERE ID = @NecessaryValue)
	END
GO

DECLARE @Result NVARCHAR(50) 

EXEC uspTask2 @String = 'This/is/my/very/nice/test/string'
			  ,@Separator = '/'
			  ,@NecessaryValue = 5
			  ,@Result = @Result OUTPUT

SELECT @Result
