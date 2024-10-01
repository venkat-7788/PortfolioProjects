-- DATA CLEANING

SELECT * 
FROM US_Project.us_household_income;

SELECT *
FROM US_Project.us_household_income_statistics;



SELECT Count(id) 
FROM US_Project.us_household_income;

SELECT Count(id)
FROM US_Project.us_household_income_statistics;

-- REMOVING DUPLICATES

SELECT row_id
FROM
(
SELECT row_id, id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
FROM US_Project.us_household_income
) duplicates
WHERE row_num > 1
;

DELETE FROM US_Project.us_household_income
WHERE row_id IN
(
SELECT row_id
FROM
(
SELECT row_id, id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
FROM US_Project.us_household_income
) duplicates
WHERE row_num > 1
)
;

SELECT id, COUNT(id)
FROM US_Project.us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1
;

-- STATE NAME TO PROPER CASE


SELECT DISTINCT State_Name 
FROM US_Project.us_household_income;

UPDATE US_Project.us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia'
;

UPDATE US_Project.us_household_income
SET State_Name = CONCAT(UCASE(SUBSTRING(State_Name, 1, 1)), LOWER(SUBSTRING(State_Name, 2)))
;

-- WORKING WITH NULL VALUES

SELECT * 
FROM US_Project.us_household_income
WHERE County = 'Autauga County'
ORDER BY 1 
;

UPDATE US_Project.us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont'
;

SELECT Type, COUNT(Type) 
FROM US_Project.us_household_income
GROUP BY Type
;

UPDATE US_Project.us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;

-- EXPLORATORY DATA ANALYSIS

SELECT * 
FROM US_Project.us_household_income;

SELECT *
FROM US_Project.us_household_income_statistics;





