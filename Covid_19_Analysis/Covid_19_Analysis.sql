
Select *
From Covid_Deaths$;

-- [Total cases vs Total deaths] per day (likelihood of dying if you are infected with covid)
Select location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100, 2) as Death_Percentage
From Covid_Deaths$
Where continent is not null
Order by Death_Percentage desc;

-- [Total cases vs Total deaths] per country (likelihood of dying if you are infected with covid)
Select location, Max(total_cases) as Total_Cases , Max(CAST(total_deaths AS INT)) as Total_Deaths, ROUND((Max(CAST(total_deaths AS INT))/Max(total_cases))*100, 2) as Death_Percentage
From Covid_Deaths$
Where total_cases is not null
And total_deaths is not null
And continent is not null
Group by location
Order by Death_Percentage desc;

-- Only checking for Asia
-- [Total cases vs Total deaths] per country (likelihood of dying if you are infected with covid)
Select location, Max(total_cases) as Total_Cases , Max(CAST(total_deaths AS INT)) as Total_Deaths, ROUND((Max(CAST(total_deaths AS INT))/Max(total_cases))*100, 2) as Death_Percentage
From Covid_Deaths$
Where continent = 'Asia'
And total_cases is not null
And total_deaths is not null
And continent is not null
Group by location
Order by Death_Percentage desc;

-- All Continents
Select Distinct(continent)
From Covid_Deaths$
Where continent is not null;

-- Total countries in Asia
Select Distinct(location)
From Covid_Deaths$
Where continent is not null
And continent = 'Asia'
Order by location;


-- [Total cases vs Population] per day (showing what % of population got covid)
Select location, date, total_cases, population, ROUND((total_cases/population)*100, 2) as Population_Percentage
From Covid_Deaths$
Where continent is not null
Order by Population_Percentage desc;

-- [Total cases vs Population] per country (showing what % of population got covid)
Select location, population, Max(total_cases) as Total_Cases, ROUND(Max(total_cases)/population*100, 2) as Population_Percentage
From Covid_Deaths$
Where continent is not null
And total_cases is not null
And population is not null
Group by location, population
Order by Population_Percentage desc;

-- Top 5 Countries affected badly
Select TOP 5 location, Max(total_cases) as Total_Cases, population, ROUND(Max(total_cases)/population*100, 2) as Population_Percentage
From Covid_Deaths$
Group by location, population
Order by Population_Percentage desc;

-- Top 5 Countries with highest death rate
Select Top 5 location, Max(CAST(total_deaths AS INT)) as Total_Death, population
From Covid_Deaths$
Where continent is not null
And total_deaths is not null
And population is not null
Group by location, population
Order by Total_Death desc;

-- New cases vs deaths
Select date, Sum(new_cases) as total_new_cases, Sum(Cast(new_deaths as int)) as total_new_deaths, Sum((Cast(new_deaths as int)))/Sum(new_cases)*100 as New_Cases_Percentage
From Covid_Deaths$
Where continent is not null
And new_cases is not null
And new_deaths is not null
Group by date
Order by 1;

Select *
From Covid_Vacc$;

-- joining
Select *
From Covid_Deaths$ cd
Join Covid_Vacc$ cv
On cd.location = cv.location
And cd.date = cv.date;

-- Total population vs Vaccinations
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, Sum(CONVERT(int, cv.new_vaccinations)) Over (Partition by cd.location 
								Order by cd.location, cd.date) as RollingPeopleVaccinated
From Covid_Deaths$ as cd
Join Covid_Vacc$ as cv
	On cd.location = cv.location
	And cd.date = cv.date
Where cd.continent is not null
And cv.new_vaccinations is not null
Order by 2,3;

-- Percentage of people vaccinated per country
-- Using CTE
With PopvsVac(Continent, Location, Date, Population, 
				New_vaccinations, RollingPeopleVaccinated)
as(
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, Sum(CONVERT(int, cv.new_vaccinations)) Over (Partition by cd.location 
								Order by cd.location, cd.date) as RollingPeopleVaccinated
From Covid_Deaths$ as cd
Join Covid_Vacc$ as cv
	On cd.location = cv.location
	And cd.date = cv.date
Where cd.continent is not null
And cv.new_vaccinations is not null
--Order by 2,3;
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac

--Temp Table
Drop Table if exists #PercentPeopleVaccinated
Create Table #PercentPeopleVaccinated
(
Continent nvarchar(255), 
Location nvarchar(255), 
Date datetime, 
Population numeric, 
New_vaccinations numeric, 
RollingPeopleVaccinated numeric
)
Insert into #PercentPeopleVaccinated
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, Sum(CONVERT(int, cv.new_vaccinations)) Over (Partition by cd.location 
								Order by cd.location, cd.date) as RollingPeopleVaccinated
From Covid_Deaths$ as cd
Join Covid_Vacc$ as cv
	On cd.location = cv.location
	And cd.date = cv.date
Where cd.continent is not null
And cv.new_vaccinations is not null
--Order by 2,3;
Select *, (RollingPeopleVaccinated/population)*100 as PercentageRollingPeopleVaccinated
From #PercentPeopleVaccinated

-- Creating view to store data

Create View PercentPeopleVaccinated as
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
, Sum(CONVERT(int, cv.new_vaccinations)) Over (Partition by cd.location 
								Order by cd.location, cd.date) as RollingPeopleVaccinated
From Covid_Deaths$ as cd
Join Covid_Vacc$ as cv
	On cd.location = cv.location
	And cd.date = cv.date
Where cd.continent is not null
And cv.new_vaccinations is not null
--Order by 2,3;

Select *
From PercentPeopleVaccinated