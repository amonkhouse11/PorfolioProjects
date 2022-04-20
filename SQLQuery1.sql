--SELECT *
--FROM ProjectPortfolio..COVIDVaccinations
--ORDER BY 3,4;


SELECT *
FROM ProjectPortfolio..COVIDDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM ProjectPortfolio..COVIDDeaths
ORDER BY 1,2;

--Looking at total cases vs. total deaths
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM ProjectPortfolio..COVIDDeaths
WHERE location like '%states%'
ORDER BY 1,2;

--Looking at Total cases vs. population
SELECT Location, date, population total_cases,(total_cases/population) * 100 AS CasesbyPopulation
FROM ProjectPortfolio..COVIDDeaths
--WHERE location like '%states%'
ORDER BY 1,2;

--Looking at countries with highest infection rate compared to population
SELECT Location, Population, MAX(total_cases) AS HighestInfectionRate, MAX((total_cases/population)) *100 AS InfectionRate
FROM ProjectPortfolio..COVIDDeaths
WHERE continent IS NOT NULL
GROUP BY LOCATION, Population
ORDER BY Infectionrate DESC;

--Looking at countries with higest death rate compared to population
SELECT Location, MAX(CAST(total_deaths AS BIGINT)) AS TotalDeaths
FROM ProjectPortfolio..COVIDDeaths
WHERE continent IS NOT NULL
GROUP BY LOCATION
ORDER BY TotalDeaths DESC;

--------
--Looking at continent with the highest death count
SELECT continent, MAX(CAST(total_deaths AS BIGINT)) AS TotalDeaths
FROM ProjectPortfolio..COVIDDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeaths DESC;

--Global Numbers per day
SELECT date, SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS INT)) AS TotalDeaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS PercentDead
FROM ProjectPortfolio..COVIDDeaths
WHERE continent is NOT NULL
GROUP BY date
ORDER BY 1,2;

--Global numbers total
SELECT SUM(new_cases) AS TotalCases, SUM(CAST(INT, new_deaths)) AS TotalDeaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS PercentDead
FROM ProjectPortfolio..COVIDDeaths
WHERE continent is NOT NULL
ORDER BY 1,2;

--Looking at Total Population vs. Vaccinations
SELECT Dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS bigint)) OVER (Partition BY dea.Location ORDER BY dea.Location, dea.date) AS RollingPeopleVaccinated
FROM ProjectPortfolio..COVIDDeaths AS Dea
JOIN ProjectPortfolio..COVIDVaccinations AS Vac
	ON Dea.location= Vac.location
	AND dea.date=Vac.date
WHERE dea.continent IS NOT NULL
ORDER by 2,3;

-- Use CTE
WITH PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
AS 
(
SELECT Dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS bigint)) OVER (Partition BY dea.Location ORDER BY dea.Location, dea.date) AS RollingPeopleVaccinated
FROM ProjectPortfolio..COVIDDeaths AS Dea
JOIN ProjectPortfolio..COVIDVaccinations AS Vac
	ON Dea.location= Vac.location
	AND dea.date=Vac.date
WHERE dea.continent IS NOT NULL
--ORDER by 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100 AS RollingPercentage
FROM PopvsVac;

-- Temp Table
DROP TABLE IF EXISTS #PercentPopulationVaccinated

CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date Datetime,
Population NUMERIC,
new_vaccinations numeric,
RollingPeopleVaccncated NUMERIC
)

INSERT INTO #PercentPopulationVaccinated
SELECT Dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS bigint)) OVER (Partition BY dea.Location ORDER BY dea.Location, dea.date) AS RollingPeopleVaccinated
FROM ProjectPortfolio..COVIDDeaths AS Dea
JOIN ProjectPortfolio..COVIDVaccinations AS Vac
	ON Dea.location= Vac.location
	AND dea.date=Vac.date
WHERE dea.continent IS NOT NULL

SELECT *, (RollingPeopleVaccncated/Population)* 100 AS RollingPercentage
FROM #PercentPopulationVaccinated;

---Creating view to store data for later visualizations
CREATE VIEW PercentPopulationVaccinated AS
SELECT Dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS bigint)) OVER (Partition BY dea.Location ORDER BY dea.Location, dea.date) AS RollingPeopleVaccinated
FROM ProjectPortfolio..COVIDDeaths AS Dea
JOIN ProjectPortfolio..COVIDVaccinations AS Vac
	ON Dea.location= Vac.location
	AND dea.date=Vac.date
WHERE dea.continent IS NOT NULL
;

select *
FROM percentpopulationvaccinated;