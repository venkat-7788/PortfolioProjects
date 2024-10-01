SELECT * 
FROM World_Life_Expectancy.worldlifexpectancy;

-- DATA CLEANING
-- REMOVING DUPLICATE COUNTRY AND YEAR

SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM World_Life_Expectancy.worldlifexpectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1;


SELECT *
FROM
(SELECT Row_ID, CONCAT(Country, Year),
ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
FROM World_Life_Expectancy.worldlifexpectancy) as Row_Table
WHERE Row_Num > 1;

DELETE FROM  worldlifexpectancy
WHERE Row_ID in 
(
SELECT Row_ID
FROM
(
SELECT Row_ID, CONCAT(Country, Year),
ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) as Row_Num
FROM World_Life_Expectancy.worldlifexpectancy) as Row_Table
WHERE Row_Num > 1
);

-- WORKING WITH NULL VALUES

SELECT * 
FROM World_Life_Expectancy.worldlifexpectancy
WHERE Status is NULL;

SELECT DISTINCT(Status)
FROM World_Life_Expectancy.worldlifexpectancy
WHERE Status <> '';

SELECT DISTINCT(Country)
FROM World_Life_Expectancy.worldlifexpectancy
WHERE Status = 'Developing'
;

-- UPDATE STATUS = Developing

UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2
ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

SELECT * 
FROM World_Life_Expectancy.worldlifexpectancy
WHERE Status = '';

-- UPDATE STATUS = Developed

UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2
ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

-- UPDATE NULL Life Expectancy VALUES USING AVERAGE OF PREVIOUS YEAR AND FOLLOWING YEAR

SELECT * 
FROM World_Life_Expectancy.worldlifexpectancy
WHERE Lifeexpectancy = '';

SELECT t1.Country, t1.Year, t1.Lifeexpectancy, 
t2.Country, t2.Year, t2.Lifeexpectancy, 
t3.Country, t3.Year, t3.Lifeexpectancy,
ROUND((t2.Lifeexpectancy + t3.Lifeexpectancy)/2)
FROM worldlifexpectancy t1
JOIN worldlifexpectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year-1
JOIN worldlifexpectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year+1
    WHERE t1.Lifeexpectancy = ''
;

UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year-1
JOIN worldlifexpectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year+1
SET t1.Lifeexpectancy = ROUND((t2.Lifeexpectancy + t3.Lifeexpectancy)/2)
WHERE t1.Lifeexpectancy = ''
;

SELECT * 
FROM World_Life_Expectancy.worldlifexpectancy
WHERE Lifeexpectancy = '';

SELECT * 
FROM World_Life_Expectancy.worldlifexpectancy;


-- EXPLORATORY DATA ANALYSIS

-- MINIMUM AND MAXIMUM LIFE EXPECTANCY BY COUNTRY

SELECT Country, MIN(Lifeexpectancy),MAX(Lifeexpectancy)
FROM World_Life_Expectancy.worldlifexpectancy
GROUP BY Country
HAVING MIN(Lifeexpectancy) <> 0
AND MAX(Lifeexpectancy) <> 0
ORDER BY Country DESC
;

-- COUNTRIES WITH INCREASED LIFE EXPECTANCY

SELECT Country, MIN(Lifeexpectancy),MAX(Lifeexpectancy),
ROUND(MAX(Lifeexpectancy) - MIN(Lifeexpectancy),1) AS Life_Increase_15_Years
FROM World_Life_Expectancy.worldlifexpectancy
GROUP BY Country
HAVING MIN(Lifeexpectancy) <> 0
AND MAX(Lifeexpectancy) <> 0
ORDER BY Life_Increase_15_Years DESC
;


-- AVERAGE LIFE EXPECTANCY BY YEAR

SELECT Year, ROUND(AVG(Lifeexpectancy),1) as Avg_Life_Expectancy
FROM World_Life_Expectancy.worldlifexpectancy
WHERE Lifeexpectancy <> 0
GROUP BY Year
ORDER BY Year
;

-- CORRELATION BETWEEN GDP AND LIFE EXPECTANCY

SELECT Country, ROUND(AVG(Lifeexpectancy),1) as Life_Expec, ROUND(AVG(GDP),2) as GDP
FROM World_Life_Expectancy.worldlifexpectancy
GROUP BY Country
HAVING Life_Expec > 0
AND GDP > 0
ORDER BY GDP DESC
;

SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG(CASE WHEN GDP >= 1500 THEN Lifeexpectancy ELSE NULL END) High_GDP_Life_Expec,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
AVG(CASE WHEN GDP <= 1500 THEN Lifeexpectancy ELSE NULL END) Low_GDP_Life_Expec
FROM World_Life_Expectancy.worldlifexpectancy;

-- CORRELATION BETWEEN STATUS AND LIFE EXPECTANCY

SELECT Status, COUNT(DISTINCT Country), ROUND(AVG(Lifeexpectancy),1)
FROM World_Life_Expectancy.worldlifexpectancy
GROUP BY Status
;


-- CORRELATION BETWEEN BMI AND LIFE EXPECTANCY BY COUNTRY

SELECT Country, ROUND(AVG(Lifeexpectancy),1) as Life_Expec, ROUND(AVG(BMI),1) as BMI
FROM World_Life_Expectancy.worldlifexpectancy
GROUP BY Country
HAVING Life_Expec > 0
AND BMI > 0
ORDER BY BMI ASC
;


-- CORRELATION BETWEEN AdultMortality AND LIFE EXPECTANCY BY COUNTRY USING ROLLING TOTAL


SELECT Country, Year,
Lifeexpectancy,
AdultMortality,
SUM(AdultMortality) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM World_Life_Expectancy.worldlifexpectancy;




