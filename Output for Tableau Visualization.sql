-- 1

SELECT SUM(new_cases) AS TotalCases, SUM(CAST(new_deaths AS INT)) AS TotalDeaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM PortofolioDatabase..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2


-- 2
SELECT Location, SUM(CAST(new_deaths AS INT)) AS TotalDeathCount
FROM PortofolioDatabase..CovidDeaths
WHERE continent IS NULL
AND location NOT IN ('World','European Union','International')
GROUP BY location
ORDER BY TotalDeathCount DESC


-- 3
SELECT location, population, MAX(total_cases) AS HighestInfectionRate, MAX((total_cases/population))*100 AS PopulationInfectedRate
FROM PortofolioDatabase..CovidDeaths
GROUP BY location, population
ORDER BY PopulationInfectedRate DESC


-- 4
SELECT location, population, date, MAX(total_cases) AS HighestInfectionRate, MAX((total_cases/population))*100 AS PopulationInfectedRate
FROM PortofolioDatabase..CovidDeaths
GROUP BY location, population, date
ORDER BY PopulationInfectedRate DESC


