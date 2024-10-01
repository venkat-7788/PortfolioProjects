-- EXPLORATORY DATA ANALYSIS

SELECT * 
FROM US_Project.us_household_income;

SELECT *
FROM US_Project.us_household_income_statistics;

-- TOP 10 LARGE STATES BY AREA IN US

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM US_Project.us_household_income
GROUP BY State_Name
ORDER BY 2 Desc
LIMIT 10
;

-- TOP 10 LARGE STATES BY WATER AREA IN US

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM US_Project.us_household_income
GROUP BY State_Name
ORDER BY 3 Desc
LIMIT 10
;




SELECT * 
FROM US_Project.us_household_income u
INNER JOIN US_Project.us_household_income_statistics us 
	ON u.id = us.id
WHERE Mean <> 0
;


-- LOWEST AVG INCOME STATES

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1) 
FROM US_Project.us_household_income u
INNER JOIN US_Project.us_household_income_statistics us 
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2
LIMIT 5
;


-- HIGHEST AVG INCOME STATES

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1) 
FROM US_Project.us_household_income u
INNER JOIN US_Project.us_household_income_statistics us 
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 10
;

-- INCOME AVG BY TYPE

SELECT Type,COUNT(Type),ROUND(AVG(Mean),1), ROUND(AVG(Median),1) 
FROM US_Project.us_household_income u
INNER JOIN US_Project.us_household_income_statistics us 
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY Type
HAVING COUNT(Type) > 100
ORDER BY 3 DESC
;

SELECT *
FROM US_Project.us_household_income
WHERE Type = 'Community'
;

-- HIGHEST AVERAGE INCOME BY CITY LEVEL

SELECT u.State_Name, City, ROUND(AVG(Mean),1), ROUND(AVG(Median),1) 
FROM US_Project.us_household_income u
INNER JOIN US_Project.us_household_income_statistics us 
	ON u.id = us.id
GROUP BY u.State_Name, City
ORDER BY 3 DESC
;



