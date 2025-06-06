-- *************************************** Data Cleaning Human Resource Data ******************************************* --
--													  By AL							   --

-- Selecting the imported hr records to clean
	USE hrdb; SELECT * FROM hrdb.hr_data;

-- Verifying Data Types of table
	DESCRIBE hr_data;
    
-- *********************************************** Name Column ****************************************************

-- Changing data types for the name columns
	ALTER TABLE  hr_data
    MODIFY Name VARCHAR(255);
    
-- Removing any trailing spaces that may be in the name column
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE hr_data
		SET Name = TRIM(Name);
		SET SQL_SAFE_UPDATES = 1;
	COMMIT;
    
-- Proper Case the names of persons in the the data table
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE hr_data
		SET Name = CONCAT(UCASE(SUBSTRING(Name, 1, 1)), LOWER(SUBSTRING(Name, 2)));
		SET SQL_SAFE_UPDATES = 1;
	COMMIT;

-- Viewing the hr_table 
	USE hrdb; SELECT * FROM hrdb.hr_data;
    
-- **************************************** Age column *************************************************

-- Scoping the data for bad or missing data
	SELECT COUNT(*) AS nan_counnt
    FROM hr_data 
	WHERE Age = 'nan';

-- Age column appears to have text that needs to be converted
	SELECT *
    FROM hr_data 
	WHERE LENGTH(Age) > 2;
    
-- It looks like thirty was typed in instead of 30, text needs to be replaced
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE hr_data
		SET Age = 30
		WHERE Age = TRIM('thirty') OR Age = TRIM('THIRTY');
		SET SQL_SAFE_UPDATES = 1;
	COMMIT;
    
-- Change the age values from nan to 0 for further analysis
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE hr_data
		SET Age = 0
		WHERE Age = 'nan' OR Age = 'NAN';
		SET SQL_SAFE_UPDATES = 1;
	COMMIT;

-- Changing data types for numerical columns
	ALTER TABLE  hr_data
    MODIFY Age INT;

-- assign average age of employees that are showing 0, so it does not drastically distort the data, 159 records
	SELECT *
	FROM hr_data
	WHERE Age = 0;

-- Updating avgerge age
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE hr_data
		SET Age = (SELECT avg_age FROM (SELECT AVG(Age) AS avg_age FROM hr_data WHERE Age > 0) AS temp)
		WHERE Age IS NULL OR Age = 0;
		SET SQL_SAFE_UPDATES = 1;
    COMMIT;

-- Viewing the hr_table 
	USE hrdb; SELECT * FROM hrdb.hr_data;

-- *************************************** Salary Column ***************************************************

-- scoping the values of the salary column
	SELECT Salary
	FROM hr_data
	WHERE Salary = 0 OR Salary = LOWER('nan') OR Salary = "";  	

-- Checking the unique values of dirty data 
	SELECT DISTINCT (Salary)
	FROM hr_data
	WHERE Salary NOT REGEXP '^[0-9]+$';
    
-- Update the dirty values in the Salary column
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE hr_data
		SET Salary = CASE 
			WHEN Salary = 'SIXTY THOUSAND' THEN 60000
			WHEN Salary = 0 THEN  (SELECT avg_sal FROM (SELECT AVG(Salary) AS avg_sal FROM hr_data WHERE Salary > 0) AS temp)
			ELSE Salary
			END;
		SET SQL_SAFE_UPDATES = 1;
	COMMIT;
    
-- Changing data type for salary columns
	ALTER TABLE  hr_data
    MODIFY Salary INT;
    
-- Viewing the hr_table 
	USE hrdb; SELECT * FROM hrdb.hr_data;

-- ********************************************* Gender Column ****************************************************

-- Scope out values for gender column
	SELECT DISTINCT(gender)
    FROM hr_data;

-- count = 0
    SELECT COUNT(gender)
    FROM hr_data
    WHERE gender IS NULL;
    
-- Trim Gender Column 
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE hr_data
		SET Gender = TRIM(Gender);
		SET SQL_SAFE_UPDATES = 1;
    COMMIT;

-- Viewing the hr_table 
	USE hrdb; SELECT * FROM hrdb.hr_data;
    
-- ********************************************* Department Column ****************************************************

-- Scope out values for department column
	SELECT DISTINCT(Department)
    FROM hr_data;

-- count = 0
    SELECT COUNT(Department)
    FROM hr_data
    WHERE Department IS NULL;
    
-- Trim Department Column 
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE hr_data
		SET Department = TRIM(Department);
		SET SQL_SAFE_UPDATES = 1;
    COMMIT;

-- Viewing the hr_table 
	USE hrdb; SELECT * FROM hrdb.hr_data;

-- ********************************************* Position Column ****************************************************

-- Scope out values for position column
	SELECT DISTINCT(Position)
    FROM hr_data;

-- count = 0
    SELECT COUNT(Position)
    FROM hr_data
    WHERE Department IS NULL;
    
-- Trim Position Column 
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE hr_data
		SET Department = TRIM(Position);
		SET SQL_SAFE_UPDATES = 1;
    COMMIT;

-- Viewing the hr_table 
	USE hrdb; SELECT * FROM hrdb.hr_data;

-- ********************************************* Joining Date Column ****************************************************

-- Trim Date Column 
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE hr_data
		SET `Joining Date` = TRIM(`Joining Date`);
		SET SQL_SAFE_UPDATES = 1;
    COMMIT;

-- Scope out values for Joining Date column
	SELECT DISTINCT(`Joining Date`)
    FROM hr_data;

-- count = 0
    SELECT COUNT(`Joining Date`)
    FROM hr_data
    WHERE `Joining Date` IS NULL;
    
-- Change and stanardize the date column
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE hr_data
		SET `Joining Date` = STR_TO_DATE(`Joining Date`, 
			CASE 
				WHEN `Joining Date` LIKE 'April 5, 2018' THEN '%M %d, %Y'
                WHEN `Joining Date` LIKE '2020/02/20' THEN '%Y/%m/%d'
				WHEN `Joining Date` LIKE '01/15/2020' THEN '%m/%d/%Y'
                WHEN `Joining Date` LIKE '03-25-2019' THEN '%m-%d-%Y'
				WHEN `Joining Date` LIKE '2019.12.01' THEN '%Y.%m.%d'
				ELSE NULL
			END);
		SET SQL_SAFE_UPDATES = 1;
	COMMIT;
    
-- change type from text to date
	START TRANSACTION;
		ALTER TABLE hr_data 
		MODIFY COLUMN `Joining Date` DATE;
    COMMIT;

-- Viewing the hr_table 
	USE hrdb; SELECT * FROM hrdb.hr_data;

-- ********************************************* Performance Score Column ****************************************************

-- Scope out values for Performance Score column
	SELECT DISTINCT(`Performance Score`)
    FROM hr_data;

-- count = 0
    SELECT COUNT(`Performance Score`)
    FROM hr_data
    WHERE `Performance Score` IS NULL;
    
-- Viewing the hr_table 
	USE hrdb; SELECT * FROM hrdb.hr_data;

-- ********************************************* Email Column ********************************************************

-- removing nan values
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE hr_data
		SET Email = ""
        WHERE Email = 'nan';
		SET SQL_SAFE_UPDATES = 1;
    COMMIT;
    
    -- Viewing the hr_table 
	USE hrdb; SELECT * FROM hrdb.hr_data;
    
-- ********************************************* Phone Number Column ****************************************************
    
-- removing nan values
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE hr_data
		SET `Phone Number` = ""
        WHERE `Phone Number` = 'nan';
		SET SQL_SAFE_UPDATES = 1;
    COMMIT;
    
    -- Viewing the hr_table 
	USE hrdb; SELECT * FROM hrdb.hr_data;    
    
    
    