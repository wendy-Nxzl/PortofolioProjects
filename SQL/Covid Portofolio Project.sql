-- ++ Global Covid-19 Deaths ++

SELECT * 
FROM PortofolioDatabase..CovidDeaths
--WHERE continent is not null
ORDER BY 3,4

-- SELECT data that will be used

SELECT Location, Date, total_cases, new_cases, total_deaths, population
FROM PortofolioDatabase..CovidDeaths
ORDER BY 1,2

-- Total Cases vs Total Deaths

SELECT Location, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortofolioDatabase..CovidDeaths
WHERE Location LIKE '%states%'
ORDER BY 1,2

-- Total Cases vs Population

SELECT Location, Date, total_cases, population, (total_cases/population)*100 AS PopulationInfected
FROM PortofolioDatabase..CovidDeaths
ORDER BY 1,2

SELECT Location, population, MAX(total_cases) AS HighestInfectionRate, MAX((total_cases/population))*100 AS PopulationInfectedRate
FROM PortofolioDatabase..CovidDeaths
GROUP BY Location, population
ORDER BY PopulationInfectedRate DESC

-- Country with Highest Death Count/Population
SELECT Location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM PortofolioDatabase..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC

SELECT Location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortofolioDatabase..CovidDeaths
WHERE continent IS NULL
GROUP BY Location
ORDER BY TotalDeathCount desc

-- Continent with Highest Death Count per Population

SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM PortofolioDatabase..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount desc

-- Global Count
SELECT SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS INT)) AS TotalDeaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM PortofolioDatabase..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- ++ Global Covid-19 Vaccination ++

SELECT dt.continent, dt.Location, dt.Date, dt.population, vc.new_vaccinations
, SUM(CONVERT(INT, vc.new_vaccinations)) OVER 
(PARTITION BY dt.Location ORDER BY dt.Location, dt.Date) AS PeopleVaccinated
FROM PortofolioDatabase..CovidDeaths dt
JOIN PortofolioDatabase..CovidVaccinations vc
	ON dt.Location = vc.Location
	AND dt.Date = vc.Date
WHERE dt.continent IS NOT NULL
ORDER BY 2,3

-- CTE
With PopvsVac (Continent, Location, Date, population, new_vaccinations, PeopleVaccinated)
AS
(
SELECT dt.continent, dt.Location, dt.Date, dt.population, vc.new_vaccinations
, SUM(CONVERT(INT, vc.new_vaccinations)) OVER 
(Partition by dt.Location ORDER BY dt.Location, dt.Date) AS PeopleVaccinated
FROM PortofolioDatabase..CovidDeaths dt
JOIN PortofolioDatabase..CovidVaccinations vc
	ON dt.Location = vc.Location
	AND dt.Date = vc.Date
WHERE dt.continent IS NOT NULL
)
SELECT *, (PeopleVaccinated/population)*100
FROM PopvsVac


-- > Temporary Table <

DROP TABLE IF EXISTS #PercentagePopulationVaccinated

CREATE TABLE #PercentagePopulationVaccinated
(
continent NVARCHAR(255),
Location NVARCHAR(255),
Date DateTIME,
population NUMERIC,
new_vaccinations NUMERIC,
PeopleVaccinated NUMERIC
)

INSERT INTO #PercentagePopulationVaccinated
SELECT dt.continent, dt.Location, dt.Date, dt.population, vc.new_vaccinations
, SUM(CONVERT(INT, vc.new_vaccinations)) OVER 
(PARTITION BY dt.Location ORDER BY dt.Location, dt.Date) AS PeopleVaccinated
FROM PortofolioDatabase..CovidDeaths dt
JOIN PortofolioDatabase..CovidVaccinations vc
	ON dt.Location = vc.Location
	AND dt.Date = vc.Date
WHERE dt.continent IS NOT NULL

SELECT *, (PeopleVaccinated/population)*100
FROM #PercentagePopulationVaccinated


-- Create View to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dt.continent, dt.Location, dt.Date, dt.population, vc.new_vaccinations
, SUM(CONVERT(INT, vc.new_vaccinations)) OVER 
(Partition by dt.Location ORDER BY dt.Location, dt.Date) AS PeopleVaccinated
FROM PortofolioDatabase..CovidDeaths dt
JOIN PortofolioDatabase..CovidVaccinations vc
	ON dt.Location = vc.Location
	AND dt.Date = vc.Date
WHERE dt.continent IS NOT NULL
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated