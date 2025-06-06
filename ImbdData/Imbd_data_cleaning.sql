-- *********************************************** IMBD Data Cleaning ************************************************* --
--										                By AL														--

-- Scoping out the data
	SELECT * FROM imbd_db.imbd_data;

-- *********************************************** IMBD Id ************************************************* --
	
-- looking for bad data
	SELECT *  FROM imbd_data;
    
-- locating empty rows
	SELECT * 
	FROM imbd_data 
	WHERE `IMBD title ID` IS NULL 
	OR `IMBD title ID` = '';
    
-- looking for duplicates
	SELECT `IMBD title ID`, COUNT(*) AS count
	FROM imbd_data
	GROUP BY `IMBD title ID`
	HAVING COUNT(*) > 1;

-- removing rows
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
        DELETE  FROM imbd_data
        WHERE `IMBD title ID` IS NULL 
		OR `IMBD title ID` = '';
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;

-- trimming the records
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
        UPDATE imbd_data
        SET `IMBD title ID` = TRIM(`IMBD title ID`); 
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;

-- *********************************************** Original Title ************************************************* --

-- trimming the records
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
        UPDATE imbd_data
        SET `Original titlÊ` = tRIM(`Original titlÊ`); 
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;
    
-- looking for duplicates
	SELECT `Original titlÊ`, COUNT(*) AS COunt
	FROM IMbd_data
	GROUP BY `Original titlÊ`
	HAVING COUNT(*) > 1;

-- looking for titles with bad characters
	SELECT `ORiginal titlÊ`
	FROM IMBD_data
	WHERE `ORIginal titlÊ` LIKE '%Ã%'
	OR `OriGInal titlÊ` LIKE '%Â%';

-- looking for titles with weird characters
    SELECT * 
	FROM Imbd_DATa
	WHERE `OrIGINAl titlÊ` REGEXP '[^\\X20-\\x7E]';
  
-- updating the data with bad characters  
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE imbD_DATA 
		SET `OrigiNAL titlÊ` = 
			CASE  
				WHEN `OrigiNAL titlÊ` = 'WALLÂ·E' THEN 'WALL·E'
				WHEN `Original TITLÊ` = 'Per qualche dOllaro in piÃ¹' THEN 'Per qualche DOLLaro in più'
				WHEN `Original titlÊ` = 'LÃ©on' THEN 'Léon'
				WHEN `ORIGinal titlÊ` = 'LE fabuleux destin d\'AmÃ©lie Poulain' THEN 'Le fabuleux destin d\'AMélie Poulain'
				ELSE `Original titlÊ`
			END;
		SET SQL_SAFE_UPDATES = 1;
	COMMIT;

-- ******************************************** Release Year Column ************************************************* --

-- looking for missing data
	SELECT * 
    FROM IMBD_data
    WHERE `ReLEASe year` IS NULL 
    OR `Release yeaR` = "";
    
-- trimming the rEcords
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
        UPDATE imbd_datA
        SET `RELEase year` = TRIM(`RELEase year`); 
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;

-- looking foR The DATE Formats
	SELECT * FROM imbd_data 
    WHERE `RELEAse year` LIKE '%[^0-9/%-]%' 
    OR LENGTH(`Release year`) < 8;

-- REMoving rows thaT HaVe bad data
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
        DELETE  FROM imBd_data
        WHERE `RElease year` = '1984-02-34'
        OR `RElease year` = '1976-13-24'
        OR `RElease year` = '21-11-46';
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;

-- Change and sTanaRDIZE the date column  
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE imbd_data
		SET `ReleASE YEar` = 
			CASE  
				WHEN `ReleaSe yeaR` Like '____-__-__' THEN STR_TO_DATE(`Release yeAR`, '%Y-%m-%d')
                WHEN `ReleAse year` like '__-__-____' THEN STR_TO_DATE(`Release yeAR`, '%m-%d-%Y')
                WHEN `ReleAse year` like '__-__-__' THEN STR_TO_DATE(`Release yeAR`, '%m-%d-%Y')
                WHEN `ReleAse year` like '__ -__-____' THEN STR_TO_DATE(`Release yeAR`, '%d-%m-%Y')
                WHEN `ReleAse year` like '__/__-__' THEN STR_TO_DATE(`Release yeAR`, '%m/%d-%Y')
                WHEN `ReleAse year` like '__/__/____' THEN STR_TO_DATE(`Release yeAR`, '%d/%m/%Y')
				else `ReleAse year`
			END
		WHERE `Release year` iS Not NULL;
		SET SQL_SAFE_UPDATES = 1;
		commit;
        
-- Checking for more date data that may be wrong- A still bad data....
	SELECT *  
    FROM IMBD_data
    where `Release yeAR` 
    not like '____-__-__' ;
    
-- taking care of the bad data
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE imbd_data
		SET `ReleASE YEar` = 
			CASE  
				WHEN `ReleaSe yeaR` = '22 Feb 04' THEN '2004-02-04'
                WHEN `ReleAse year` = '23rd December of 1966' THEN '1966-12-23'
                WHEN `ReleAse year` = 'The 6th of marzo, year 1951' THEN '1951-03-06'
                else `ReleAse year`
			END
		WHERE `Release year` iS Not NULL;
		SET SQL_SAFE_UPDATES = 1;
	COMMIT;
    
-- ******************************************** Genre Column ************************************************* --
    
-- Scoping out the data
	SELECT distinct Genrë¨ 
	FROM IMBD_data;    

-- looking for missing data
	SELECT * 
    FROM IMBD_data
    WHERE Genrë¨  IS NULL;

-- trimming the rEcords
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
        UPDATE imbd_datA
        SET Genrë¨ = TRIM(Genrë¨); 
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;

-- ******************************************** Duration Column ************************************************* --

-- looking for missing data
	SELECT * 
    FROM IMBD_data
    WHERE Duration IS NULL
    or length(Duration) >3;
    
-- looking for missing data
	SELECT * 
    FROM IMBD_data
    WHERE Duration IS NULL
    or length(Duration) >3;
    
    -- trimming the rEcords
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
        UPDATE imbd_datA
        SET Duration = TRIM(Duration); 
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;

	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE imbd_data
		SET Duration = 
			CASE  
				WHEN Duration  = '178c' THEN '178'
                WHEN Duration  = 'Not Applicable' THEN null
                WHEN Duration  = 'Nan' THEN null
                WHEN Duration  = 'Inf' THEN null
                WHEN Duration  = '-' THEN null
                WHEN Duration  = '' THEN null
                else Duration 
			END
		WHERE Duration iS Not NULL;
		SET SQL_SAFE_UPDATES = 1;
	COMMIT;

-- ******************************************** Country Column ************************************************* --

-- Scoping out the data
	SELECT distinct Country 
	FROM IMBD_data;    

-- trimming the rEcords
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
        UPDATE imbd_datA
        SET Country = TRIM(Country); 
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;

START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE imbd_data
		SET Country = 
			CASE  
				WHEN Country  = 'US' THEN 'USA'
                WHEN Country  = 'New Zesland' THEN 'New Zealand'
                WHEN Country  = 'New Zeland' THEN 'New Zealand'
                WHEN Country  = 'US.' THEN 'USA'
                WHEN Country  = 'Italy1' THEN 'Italy'
                else Country 
			END
			WHERE Country iS Not NULL;
		SET SQL_SAFE_UPDATES = 1;
	COMMIT;

-- ******************************************** Rating Column ************************************************* --

-- Scoping out the data
	SELECT distinct `Content Rating` 
	FROM IMBD_data;    
    
-- trimming the rEcords
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
        UPDATE imbd_datA
        SET `Content Rating` = TRIM(`Content Rating`); 
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;

	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE imbd_data
		SET `Content Rating` = 
			CASE  
				WHEN `Content Rating`  = 'Not Rated' THEN 'Unrated'
                WHEN `Content Rating`  = 'Approved' THEN 'N/A'
                WHEN `Content Rating`  = '#N/A' THEN 'N/A'
                else `Content Rating` 
			END
			WHERE `Content Rating` iS Not NULL;
		SET SQL_SAFE_UPDATES = 1;
	COMMIT;

-- ******************************************** Myunknown Column ************************************************* --

-- dropping this column due to it not having any data in it
	START TRANSACTION;
		Alter TABLE imbd_data
        drop column  MyUnknownColumn;
	commit;


-- ******************************************** Director Column ************************************************* --

-- trimming the rEcords
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
        UPDATE imbd_datA
        SET Director = TRIM(Director); 
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;

-- ******************************************** Income Column ************************************************* --
	
-- income column was formatted with $, addressing that
    START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE imbd_data
		SET Income = REPLACE(REPLACE(Income, '$', ''), ',', '');
        SET SQL_SAFE_UPDATES = 1;
	commit;

-- trimming the rEcords
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
        UPDATE imbd_datA
        SET Income = TRIM(Income); 
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;

-- validate income data is just numbers, bad data came back
	SELECT Income 
    FROM imbd_data
	WHERE Income REGEXP '[^0-9]';

	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE imbd_data
        set Income = 408035783
        where Income = '4o8035783';
		SET SQL_SAFE_UPDATES = 1;
	COMMIT;


-- ******************************************** Income Column ************************************************* --

-- trimming the rEcords
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
        UPDATE imbd_datA
        SET Votes = TRIM(Votes); 
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;

-- vote column was formatted with ., addressing that
    START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE imbd_data
		SET Votes = REPLACE(REPLACE(Votes, '.', ''), ',', '');
        SET SQL_SAFE_UPDATES = 1;
	commit;

-- validate income data is just numbers, bad data came back
	SELECT Votes 
    FROM imbd_data
	WHERE Votes REGEXP '[^0-9]';

-- ******************************************** Score Column ************************************************* --

-- trimming the rEcords
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
        UPDATE imbd_datA
        SET Score = TRIM(Score); 
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;

-- validate score data is just numbers, 
	SELECT Score 
    FROM imbd_data
	WHERE Score REGEXP '[^0.0-9.9]';
 
-- correcting the poorly formatted data that came back
    START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE imbd_data
		SET Score = replace(replace(replace(REPLACE(REPLACE(Score, ',.', ''), ',', '.'),'+',''),'-',''),':','');
        SET SQL_SAFE_UPDATES = 1;
	commit; 

--  data has text
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE imbd_data
		SET Score =
        CASE 
			WHEN Score LIKE '__%' THEN format(Score,1) 
		END;
		SET SQL_SAFE_UPDATES = 1;
	COMMIT;

--  data has text
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE imbd_data
		SET Score =
        CASE 
			WHEN Score > 10.0 then round(score/10,1) 
            else Score
		END;
		SET SQL_SAFE_UPDATES = 1;
	commit;

-- ******************************************** Cleaned Data ************************************************* --

SELECT *  FROM IMBD_data; 
 

