-- ************************************** Patient Data Cleaning *********************************************--
--         										By AL 														 --

-- Looking in the data
	use patient_db;
	SELECT * from healthcare_data;

-- ****************************************** Name Colunmn ************************************************--
	select Name from healthcare_data;
	
 -- checking for missing data   
    select count(Name) as patient_count
    from healthcare_data
    where Name is null;

-- triming and cleaning data
	start TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE healthcare_data
        set healthcare_data.Name = trim(Name);
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;

-- changing column name so its not using a keyword
	start transaction;
		alter table healthcare_data
        RENAME column `Name` to  patient_name;
	commit;
    
-- Proper Case the first name of persons in the the data table
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE healthcare_data
		SET patient_name = CONCAT(UCASE(SUBSTRING(patient_name, 1, 1)), LOWER(SUBSTRING(patient_name, 2)));
		SET SQL_SAFE_UPDATES = 1;
	COMMIT;

-- Proper Case the last name of persons in the the data table
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE healthcare_data
        set patient_name = CONCAT(SUBSTRING_INDEX(patient_name, ' ', 1), ' ', UPPER(LEFT(SUBSTRING_INDEX(patient_name, ' ', -1), 1)), 
        RIGHT(SUBSTRING_INDEX(patient_name, ' ', -1), LENGTH(SUBSTRING_INDEX(patient_name, ' ', -1)) - 1));
		SET SQL_SAFE_UPDATES = 1;
	COMMIT;
    
-- ****************************************** Age Colunmn ************************************************--
-- probing the data	
    select Age from healthcare_data;
	
 -- checking for missing data , A-148 missing entries  
    select count(Age) as null_count
    from healthcare_data
    where Age is null OR Age = lcase("NAN");

 -- checking for missing data , A-168 missing entries  
	SELECT * 
    FROM healthcare_data 
    WHERE Age not REGEXP '^[0-9]+$';

-- addressing the text in the number column
	start TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE healthcare_data
        set healthcare_data.Age = 40
        where healthcare_data.Age = 'forty';
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;

-- addressing the nan values in the age column, going to assign the average age of males and females
	SELECT Gender, ROUND(AVG(Age), 0) AS average_age 
	FROM healthcare_data  
	GROUP BY Gender;
    
-- Create a temporary table to store average ages per gender
	CREATE TEMPORARY TABLE temp_avg_age AS
	SELECT Gender, ROUND(AVG(Age), 0) AS avg_age
	FROM healthcare_data
	WHERE Age IS NOT NULL
	GROUP BY Gender;

-- Update healthcare_data using the temporary table
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE healthcare_data h
		JOIN temp_avg_age t ON h.Gender = t.Gender
		SET h.Age = t.avg_age
		WHERE h.Age = 'nan' AND h.Gender IN ('Male', 'Female');
		SET SQL_SAFE_UPDATES = 1;
	COMMIT;

-- triming and cleaning data
	start TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE healthcare_data
        set healthcare_data.Age = trim(Age);
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;

-- ****************************************** Gender Colunmn ************************************************--

-- triming and cleaning data
	start TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE healthcare_data
        set healthcare_data.Gender = trim(Gender);
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;

-- scope the data
	select DISTINCT Gender from healthcare_data;    

-- looking for nulls
	select * from healthcare_data
	WHERE Gender IS NULL;    

-- ****************************************** Weight Colunmn ************************************************--

-- triming and cleaning data
	start TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE healthcare_data
        SET healthcare_data.Weight = TRIM(Weight);
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;

 -- checking for missing data , A - 0 missing entries  
	SELECT * 
    FROM healthcare_data 
    WHERE Weight not REGEXP '^[0-9]+$';

-- looking for nulls - A- none
	SELECT * FROM healthcare_data
	WHERE Weight IS NULL OR Weight = 'nan';   
    
-- ****************************************** Issue Colunmn ************************************************--    
    
-- scoping the data out
	SELECT DISTINCT issue
	from healthcare_data;
    
-- triming and cleaning data
	start TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE healthcare_data
        set healthcare_data.issue = trim(issue);
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;
    
-- Change the column name    
	start transaction;
		alter table healthcare_data
        RENAME column issue to Issue;
	commit;

-- ****************************************** Medds Colunmn ************************************************-- 

-- scoping the data out
	SELECT DISTINCT Medds
	from healthcare_data;
    
-- triming and cleaning data
	start TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE healthcare_data
        set healthcare_data.Medds = trim(Medds);
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;
    
-- Proper Case the Medicine column name of the data table
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE healthcare_data
		SET Medds = CONCAT(UCASE(SUBSTRING(Medds, 1, 1)), LOWER(SUBSTRING(Medds, 2)));
		SET SQL_SAFE_UPDATES = 1;
	COMMIT;
    
-- Change the column name    
	start transaction;
		alter table healthcare_data
        RENAME column Medds to Medication;
	commit;

-- ****************************************** Visit Date Colunmn ************************************************-- 

-- Scoping out the data
	select DISTINCT `Visit Date`
	from healthcare_data;

	select * from healthcare_data
	where not date('Visit Date');
    
	select * from healthcare_data
	where 'Visit Date' is null;
    
-- triming and cleaning data
	start TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE healthcare_data
        set healthcare_data.`Visit Date` = trim(`Visit Date`);
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;    
    
	SELECT STR_TO_DATE('5/26/2025', '%m/%d/%Y');    
    
-- Change and stanardize the date column    
	START TRANSACTION;
	SET SQL_SAFE_UPDATES = 0;
	UPDATE healthcare_data
		SET `Visit Date` = 
			CASE  
				WHEN `Visit Date` LIKE '% %, %' THEN STR_TO_DATE(`Visit Date`, '%M %d, %Y')
				WHEN `Visit Date` LIKE '%/%/%' THEN STR_TO_DATE(`Visit Date`, '%m/%d/%Y')
				WHEN `Visit Date` LIKE '%-%-%' THEN STR_TO_DATE(`Visit Date`, '%d-%b-%y')
				WHEN `Visit Date` LIKE '%.%.%' THEN STR_TO_DATE(`Visit Date`, '%Y.%m.%d')
				ELSE NULL
			END
		WHERE `Visit Date` IS NOT NULL;
	SET SQL_SAFE_UPDATES = 1;
	COMMIT;
       
-- ****************************************** Blood Prssure Colunmn ************************************************-- 

-- triming and cleaning data
	start TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE healthcare_data
        set healthcare_data.`Blood Pressure` = trim(`Blood Pressure`);
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;    
    
-- scoping for invalid data
	select *
	from healthcare_data
	where `Blood Pressure` is null Or `Blood Pressure` ="NaN";
    
-- Adressing the nan values
	start transaction;
		SET SQL_SAFE_UPDATES = 0;
		update healthcare_data
		set `Blood Pressure` = 'Unknown'
		where `Blood Pressure` = lower("Nan");
		SET SQL_SAFE_UPDATES = 1;
	commit;
    
-- ****************************************** Cholesterol Colunmn ************************************************-- 

-- triming and cleaning data
	start TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE healthcare_data
        set healthcare_data.Cholesterol = trim(Cholesterol);
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;        

-- scoping for invalid data
	select *
	from healthcare_data
	where Cholesterol is null Or Cholesterol =trim("NaN");
    
 -- checking for missing data , A - 0 missing entries  
	SELECT * 
    FROM healthcare_data 
    WHERE Cholesterol not REGEXP '^[0-9]+$';
    
-- ****************************************** Email Colunmn ************************************************--     

-- triming and cleaning data
	start TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE healthcare_data
        set healthcare_data.Email = trim(Email);
        SET SQL_SAFE_UPDATES = 1;
	COMMIT;   
    
-- formatting the email names, they have a space so they need to be removed to make the email valid
	start TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE healthcare_data
		SET Email = REPLACE(Email, ' ', '')
		WHERE Email LIKE '%@hospital.org';
		SET SQL_SAFE_UPDATES = 1;
	commit;

-- scoping for invalid data
	select *
	from healthcare_data
	where Email is null Or Email =trim("NaN");

-- adressing the nan values
	start TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE healthcare_data
        set healthcare_data.Email = null
        where healthcare_data.Email = lower('Nan') or healthcare_data.Email = lower('name@hospital.org') or healthcare_data.Email = "" ;
        SET SQL_SAFE_UPDATES = 1;
	commit;   

-- ****************************************** Phone Colunmn ************************************************--  

-- scoping out the data , A- missing data and nan values, partial data
	select `Phone Number` 
	from healthcare_data;

-- address the data that is not complete
	START TRANSACTION;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE healthcare_data
		SET `Phone Number` = 
			CASE  
				WHEN LOWER(`Phone Number`) IN ('nan', 'NaN') THEN NULL
				WHEN LENGTH(`Phone Number`) < 6 THEN NULL
				ELSE `Phone Number`
			END
		WHERE `Phone Number` IS not NULL;
		SET SQL_SAFE_UPDATES = 1;
	COMMIT;
    
 -- phone numbers have  different formats, gonna generalize
	start transaction;
		SET SQL_SAFE_UPDATES = 0;
		UPDATE healthcare_data
		SET `Phone Number` = REGEXP_REPLACE(`Phone Number`, '[^0-9]', '');
        SET SQL_SAFE_UPDATES = 1;
	commit;
 
-- ****************************************** Unknown Colunmn ************************************************--  

-- there is a couple columns that need to be dropped, there is no data
	start transaction;
		alter table healthcare_data
        DROP column MyUnknownColumn;
	commit;
    
    start transaction;
		alter table healthcare_data
        DROP column `MyUnknownColumn_[0]`;
	commit;
    
-- gonna change the namme of the patient column
	start transaction;
		alter table healthcare_data
		rename column patient_name  to `Patient Name`;
	commit;

-- ****************************************** Final Results ************************************************--  
	select * from healthcare_data;

	select `Patient Name`,Gender,Age,Weight,`Visit Date`,Issue,Medication,`Blood Pressure`,Cholesterol,`Phone Number`,Email from healthcare_data;
