SELECT *
FROM ProjectPortfolio..States; 

--Exploring the data
SELECT State, MIN(Cases) as Minimum, MAX(Cases) as Maximum
FROM ProjectPortfolio..States
GROUP BY State
ORDER BY Maximum DESC;

-- State with highest cases
SELECT State, SUM(Cases) AS total_cases
FROM ProjectPortfolio..States
GROUP BY State
ORDER BY total_cases DESC;

--State with highest deaths
SELECT State, SUM(deaths) AS total_deaths
FROM ProjectPortfolio..States
GROUP BY State
ORDER BY total_deaths DESC;

--Total cases per state 2022
SELECT State, SUM(cases) AS total_cases
FROM ProjectPortfolio..States2022
GROUP BY State
ORDER BY total_cases DESC;

--Total Deaths per state 2022
SELECT State, SUM(deaths) AS total_deaths
FROM ProjectPortfolio..States2022
GROUP BY State
ORDER BY total_deaths DESC;

SELECT *
FROM ProjectPortfolio..FLCounty;

--Total Cases per county in FL
SELECT county, MAX(cases) AS Max_cases
FROM ProjectPortfolio..FLCounty
GROUP BY county
ORDER BY Max_cases DESC;









