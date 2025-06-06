-- ************************************ HR Data Question & Answer *************************************--
--											    BY AL													--

-- Q1 What is the average salary for employees in different roles (Manager, Director, Clerk, etc.)?
	USE hrdb;
	SELECT Position, ROUND(AVG(salary)) AS Average_Salary,MIN(salary) AS Min_Salary, MAX(salary) AS Max_Salary 
    FROM hr_data
	GROUP BY Position
    ORDER BY Average_Salary ASC;
    
-- Q2 How does the salary distribution vary by gender and other categories?
	USE hrdb;
	SELECT Department,Gender, ROUND(AVG(salary)) AS Avg_Salary, MIN(salary) AS Min_Salary, MAX(salary) AS Max_Salary
	FROM hr_data
	GROUP BY Department,Gender
	ORDER BY Department,Gender DESC;
    
-- Q3 Which role has the highest number of employees and whats the average salary by gender?
	USE hrdb;
    SELECT Position,  COUNT(Position) AS Position_Count, Gender, ROUND(AVG(salary)) AS Avg_Salary
	FROM hr_data
	GROUP BY Position,Gender
	ORDER BY Position, Position_Count DESC;
    
-- Q4 How many employees earn more than $60,000 annually, whats the breakdown by gender?
	USE hrdb;
    SELECT COUNT(Name) AS Employee_Count , ROUND(AVG(salary)) AS Avg_Salary, Gender
		FROM hr_data
		WHERE Salary > 60000
		GROUP BY Gender
    UNION ALL
		SELECT COUNT(Name) AS Employee_Count , ROUND(AVG(salary)) AS Avg_Salary, Gender
		FROM hr_data
		WHERE Salary < 60000
		GROUP BY Gender
	ORDER BY Gender ASC;

-- Q5 What is the proportion of employees in each role based on gender?
	USE hrdb;
	SELECT Position, Gender, COUNT(*) AS Employee_Count, ROUND(COUNT(*) * 100.0 / 
		(SELECT COUNT(*) FROM hr_data), 2) AS Percentage
	FROM hr_data
	GROUP BY Position, Gender
	ORDER BY Position, Gender;
    
-- Q6 Are there salary discrepancies for employees in the same role but different genders or departments?
	USE hrdb;
	SELECT Department, Position,COUNT(*) AS Employee_Count,Gender,ROUND(AVG(salary), 2)
		AS Average_Salary,MIN(salary) AS Min_Salary, MAX(salary) AS Max_Salary
	FROM hr_data
	GROUP BY Position, Gender, Department
	ORDER BY Department,Position, Average_Salary;

-- Q7 What is the count of employees grouped by their assigned Performamce Score(A, B, C, etc.) and what is the average salary?
	USE hrdb;
	SELECT `Performance Score`, COUNT(*) AS Employee_Count, Gender, ROUND(AVG(Salary)) AS Averege_Salary
	FROM hr_data
	GROUP BY `Performance Score`, Gender
	ORDER BY `Performance Score` ASC;

