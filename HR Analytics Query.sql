-->KPI SECTION
--KPI Overall Employees
SELECT SUM(employee_count) AS 'Employee Count'
FROM hrdata$

--KPI Attrition
SELECT SUM(employee_count) AS Attrition
FROM hrdata$
WHERE attrition = 'Yes'

--KPI Attrition Rate
SELECT
	ROUND(((
		SELECT SUM(employee_count)	
		FROM hrdata$
		WHERE attrition = 'Yes'
	)/
	SUM(employee_count))*100,2) AS 'Attrition Rate'
FROM hrdata$

--KPI Active Employee
SELECT 
	SUM(employee_count) -
	(
		SELECT SUM(employee_count)	
		FROM hrdata$
		WHERE attrition = 'Yes'
	) AS 'Active Employee'
FROM hrdata$

--KPI Average Age
SELECT ROUND(AVG(age),0) AS 'Average Age'
FROM hrdata$


-->DEPARTMENT WISE ATTRITION
SELECT department, COUNT(attrition) AS attrition,
	ROUND(CONVERT(float, COUNT(attrition))/(SELECT COUNT(attrition) FROM hrdata$ WHERE attrition='Yes')*100, 2) AS 'attrition rate'
FROM hrdata$
WHERE attrition='Yes'
GROUP BY department

SELECT department, COUNT(attrition) AS attrition,
	ROUND(CAST(COUNT(attrition) as numeric)/(SELECT COUNT(attrition) FROM hrdata$ WHERE attrition='Yes')*100, 2) AS 'attrition rate'
FROM hrdata$
WHERE attrition='Yes'
GROUP BY department

-->ATTRITION BY GENTER
SELECT gender, COUNT(attrition) AS attrition
FROM hrdata$
WHERE attrition = 'Yes'
GROUP BY gender

-->EMPLOYEES WISE AGE BRACKETS BY GENDER
SELECT age_band, gender, COUNT(emp_no) AS Employees
FROM hrdata$
GROUP BY age_band, gender
ORDER BY age_band

-->JOB ROLE WISE SATISFACTION RATINGS
SELECT *
FROM 
	(
	SELECT 
		job_role,
		job_satisfaction
	FROM hrdata$
	) as rating
	PIVOT
	(
		COUNT(job_satisfaction) 
		for job_satisfaction in ([1],[2],[3],[4])
	) as pivot_data

	CREATE TABLE #temp_satisfaction_ratings
	(
		Job_Role NVARCHAR(255),
		one float,
		two float,
		three float,
		four float
	)

	INSERT INTO #temp_satisfaction_ratings
	SELECT *
FROM 
	(
	SELECT 
		job_role,
		job_role as 'role', 
		job_satisfaction
	FROM hrdata$
	) as rating
	PIVOT
	(
		COUNT(role) 
		for job_satisfaction in ([1],[2],[3],[4])
	) as pivot_data

	SELECT *
	FROM #temp_satisfaction_ratings

-->EDUCATION FIELD WISE ATTRITION
SELECT education_field, COUNT(attrition) AS Attrition
FROM hrdata$
WHERE attrition = 'Yes'
GROUP BY education_field
ORDER BY COUNT(attrition) DESC

-->ATTRITION BY GENDER FOR DIFFERENT AGE BRACKETS
SELECT age_band, gender, COUNT(attrition) AS attrition
FROM hrdata$
WHERE attrition = 'yes'
GROUP BY age_band, gender
ORDER BY age_band, gender

--Calculation of Totals
SELECT age_band, COUNT(attrition) AS attrition
FROM hrdata$
WHERE attrition = 'yes'
GROUP BY age_band

-->EMPLOYEES WISE AGE BRACKETS
SELECT age,COUNT(emp_no) AS employee
FROM hrdata$
GROUP BY age 
ORDER BY age 
