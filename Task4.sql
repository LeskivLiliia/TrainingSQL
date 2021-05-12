USE Learning
GO

/*
	Declare a table (ARTISTS) with the following columns:
		ARTIST_ID (not unique in this table)
		FULL_NAME
		PICTURE
	
	For example, this table contains the following data:
	1 Leonardo da Vinci Mona Lisa
	1 Leonardo da Vinci Last Supper
	1 Leonardo da Vinci Vitruvian Man
	2 Sandro Botticelli The birth of Venus
	2 Sandro Botticelli La Primavera
	
	SQL script should return the following:
	1 Leonardo da Vinci Mona Lisa, Last Supper, Vitruvian Man
	2 Sandro Botticelli The birth of Venus, La Primavera

*/
DROP PROCEDURE IF EXISTS uspTask4
GO

CREATE PROCEDURE uspTask4 
AS
BEGIN
	DECLARE @ARTISTS TABLE
		(ARTIST_ID  INT
		 ,FULL_NAME NVARCHAR(100)
		 ,PICTURE NVARCHAR(100))

	INSERT INTO @ARTISTS VALUES (1, 'Leonardo da Vinci', 'Mona Lisa')
	INSERT INTO @ARTISTS VALUES (1, 'Leonardo da Vinci', 'Last Supper')
	INSERT INTO @ARTISTS VALUES (1, 'Leonardo da Vinci', 'Vitruvian Man')
	INSERT INTO @ARTISTS VALUES (2, 'Sandro Botticelli', 'The birth of Venus')
	INSERT INTO @ARTISTS VALUES (2, 'Sandro Botticelli', 'La Primavera')

	SELECT ARTIST_ID, FULL_NAME
		   ,STUFF((SELECT ', ' + PICTURE 
				FROM @ARTISTS AS A_Internal 
				--Choose accordant picture for painter 
				WHERE A_Internal.ARTIST_ID = A_External.ARTIST_ID
				FOR XML PATH('')), 1, 1, '') AS PICTURE
	FROM @ARTISTS AS A_External
	GROUP BY ARTIST_ID,FULL_NAME
END
GO

EXEC uspTask4
GO