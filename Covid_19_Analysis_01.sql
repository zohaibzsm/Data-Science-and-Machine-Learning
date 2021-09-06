
Select *
From [Covid_19 Analysis].dbo.['CovidDeaths]
Where CONTINENT IS NOT NULL
Order by 3,4

Select *
From [Covid_19 Analysis]..[CovidVaccinations]
Where continent is not null
Order by 3,4

--Selecting Data to be used further

Select LOCATION, DATE, TOTAL_CASES, TOTAL_DEATHS
From [Covid_19 Analysis]..['CovidDeaths]

--Total Cases vs Total Deaths (liklihood of dying if you suffer From it)

Select LOCATION, DATE, TOTAL_CASES, TOTAL_DEATHS, (TOTAL_DEATHS/TOTAL_CASES)*100 AS DeathPercentage
From [Covid_19 Analysis]..['CovidDeaths]
Where continent is not null
Order by 1,2

--Death Percentage in Pakistan (excluding days when no deaths occured)

Select LOCATION, DATE, TOTAL_CASES, TOTAL_DEATHS, (TOTAL_DEATHS/TOTAL_CASES)*100 AS DeathPercentage
From [Covid_19 Analysis]..['CovidDeaths]
Where LOCATION = 'Pakistan'
And TOTAL_DEATHS is not null
And continent is not null
Order by 1,2

--Total Cases vs Total Population (What % of Population got covid)

Select LOCATION, DATE, TOTAL_CASES, POPULATION, (TOTAL_CASES/POPULATION)*100 AS PopulationPercentage
From [Covid_19 Analysis]..['CovidDeaths]
Order by 1,2

--Analyzing countries with Highest Infection Rate compared to the Population

Select LOCATION, POPULATION, MAX(TOTAL_CASES) as HighestInfectionCount, (MAX(TOTAL_CASES)/POPULATION)*100 AS PopulationPercentageInfected
From [Covid_19 Analysis]..['CovidDeaths]
Group by LOCATION, POPULATION
Order by PopulationPercentageInfected DESC

--Analyzing countries with Highest Death Count compared to the Population

Select LOCATION, MAX(CAST(TOTAL_DEATHS AS INT)) AS TOTALDEATHCOUNT
From [Covid_19 Analysis]..['CovidDeaths]
Where continent is not null
Group by LOCATION
Order by TOTALDEATHCOUNT Desc

--Breaking things down by Conitnent
--Continents with the Highest Death Count per Population

Select continent, MAX(CAST(TOTAL_DEATHS AS INT)) AS TOTALDEATHCOUNT
From [Covid_19 Analysis]..['CovidDeaths]
Where continent is not null
Group by continent
Order by TOTALDEATHCOUNT Desc

--Analyzing globally 

--New Cases and Deaths on a specific day
--New  Deaths Percentage

Select Date, SUM(NEW_CASES) as NEWCASES, SUM(CAST(NEW_DEATHS AS INT)) as NEWDEATHS,
		(SUM(CAST(NEW_DEATHS AS INT))/SUM(NEW_CASES))*100 as NewDeathPecentage
From [Covid_19 Analysis]..['CovidDeaths]
Where continent is not null
Group by Date
Order by 1,2

--Total NewCases, NewDeaths, NewDeathsPercentage collectively

Select SUM(NEW_CASES) as NEWCASES, SUM(CAST(NEW_DEATHS AS INT)) as NEWDEATHS,
		(SUM(CAST(NEW_DEATHS AS INT))/SUM(NEW_CASES))*100 as NewDeathPecentage
From [Covid_19 Analysis]..['CovidDeaths]
Where continent is not null
Order by 1,2

--Joining Vaccinations table

Select *
From [Covid_19 Analysis]..['CovidDeaths] death
Join [Covid_19 Analysis]..CovidVaccinations Vacc
On death.location = vacc.location
And death.date = vacc.date

--Total Population vs Vaccinations

Select death.continent, death.location, death.date, death.population, Vacc.new_vaccinations,
		(Vacc.new_vaccinations/death.population)*100 as VaccinationPercentage
From [Covid_19 Analysis]..['CovidDeaths] death
Join [Covid_19 Analysis]..CovidVaccinations Vacc
On death.location = vacc.location
And death.date = vacc.date
Where death.continent is not null
Order by VaccinationPercentage Desc

--Rolling Count the new vacciantions(per day)

Select death.continent, death.location, death.date, death.population, Vacc.new_vaccinations,
		Sum(Convert(int, Vacc.new_vaccinations)) Over (Partition by death.location 
				Order by death.location, death.date) as RollingPeopleVaccinated
From [Covid_19 Analysis]..['CovidDeaths] death
Join [Covid_19 Analysis]..CovidVaccinations Vacc
On death.location = vacc.location
And death.date = vacc.date
Where death.continent is not null
Order by 2,3

--using CTE

With PopvsVac(cont, loc, date, pop, new_vacc, RollingPeopleVaccinated)
as
(
Select death.continent, death.location, death.date, death.population, Vacc.new_vaccinations,
		Sum(Convert(int, Vacc.new_vaccinations)) Over (Partition by death.location 
				Order by death.location, death.date) as RollingPeopleVaccinated
		--,(RollingPeopleVaccinated/death.population)*100 as PercentageRollingPeopleVaccinated
From [Covid_19 Analysis]..['CovidDeaths] death
Join [Covid_19 Analysis]..CovidVaccinations Vacc
On death.location = vacc.location
And death.date = vacc.date
Where death.continent is not null
--Order by 2,3
)

Select *, (RollingPeopleVaccinated/pop)*100 as PercentageRollingPeopleVaccinated
From PopvsVac

--Temp Table

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Cont nvarchar(255),
Loc nvarchar(255),
Date datetime,
Pop numeric,
New_Vacc numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select death.continent, death.location, death.date, death.population, Vacc.new_vaccinations,
		Sum(Convert(int, Vacc.new_vaccinations)) Over (Partition by death.location 
				Order by death.location, death.date) as RollingPeopleVaccinated
		--,(RollingPeopleVaccinated/death.population)*100 as PercentageRollingPeopleVaccinated
From [Covid_19 Analysis]..['CovidDeaths] death
Join [Covid_19 Analysis]..CovidVaccinations Vacc
On death.location = vacc.location
And death.date = vacc.date
Where death.continent is not null

Select *, (RollingPeopleVaccinated/pop)*100 as PercentageRollingPeopleVaccinated
From #PercentPopulationVaccinated

--Creating views

Create view	PercentPopulationVaccinated as
Select death.continent, death.location, death.date, death.population, Vacc.new_vaccinations,
		Sum(Convert(int, Vacc.new_vaccinations)) Over (Partition by death.location 
				Order by death.location, death.date) as RollingPeopleVaccinated
		--,(RollingPeopleVaccinated/death.population)*100 as PercentageRollingPeopleVaccinated
From [Covid_19 Analysis]..['CovidDeaths] death
Join [Covid_19 Analysis]..CovidVaccinations Vacc
On death.location = vacc.location
And death.date = vacc.date
Where death.continent is not null
--Order by 2,3

Select *
From PercentPopulationVaccinated
