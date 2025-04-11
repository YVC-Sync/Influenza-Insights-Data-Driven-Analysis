-- ========================
-- Confirm Database & Table Setup
-- Ensure the influenza_project database and mortality_rates table are set up correctly.
-- ========================
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';

-- ========================
-- Table Structure
-- To further analyze influenza mortality trends, I created the mortality_rates table with the following
-- ========================
CREATE TABLE mortality_rates (
    year INT,
    country VARCHAR(50),
    deaths INT,
    population BIGINT,
    mortality_rate FLOAT
);

-- ========================
-- Relationships Between Tables
-- primary and foreign key relationships between the tables
-- ========================
SELECT conname, conrelid::regclass AS table_name, confrelid::regclass AS foreign_table
FROM pg_constraint
WHERE conrelid::regclass IN (
    '"Flu Shot Survey"'::regclass,
    '"Influenza Deaths"'::regclass
);

-- ========================
-- Data Insertion
-- help analyze mortality trends and uncover prevention insights
-- ========================
INSERT INTO mortality_rates (year, country, deaths, population, mortality_rate)
VALUES
(2020, 'USA', 25000, 331000000, (25000.0 / 331000000) * 100000),
(2020, 'Canada', 3000, 38000000, (3000.0 / 38000000) * 100000),
(2020, 'UK', 7000, 67000000, (7000.0 / 67000000) * 100000),
(2021, 'USA', 18000, 332000000, (18000.0 / 332000000) * 100000),
(2021, 'Canada', 2000, 38200000, (2000.0 / 38200000) * 100000),
(2021, 'UK', 5000, 67200000, (5000.0 / 67200000) * 100000);

SELECT * FROM mortality_rates;

-- ========================
-- SQL Queries & Analysis
-- Total Influenza Deaths Per Year
-- ========================
SELECT year, SUM(deaths) AS total_deaths
FROM mortality_rates
GROUP BY year
ORDER BY year;

-- ========================
-- Country with the Highest Mortality Rate
-- find out which country had the highest influenza mortality rate
-- ========================
SELECT country, MAX(mortality_rate) AS highest_mortality_rate
FROM mortality_rates
GROUP BY country
ORDER BY highest_mortality_rate DESC
LIMIT 1;

-- ========================
-- Patterns That Could Help with Prevention.
-- identify patterns that might help with influenza prevention
-- ========================
SELECT m.year, m.country, m.deaths, m.population, m.mortality_rate, f.census_region, f."FLU4_AGE" AS vaccination_rate
FROM mortality_rates m
LEFT JOIN "Flu Shot Survey" f
ON m.year = f.year
ORDER BY m.year, m.country;

-- ========================
-- Do Flu Shots Really Help Reduce Mortality Rates?
-- analyze vaccination rates
-- ========================
SELECT m.year, m.country, m.deaths, m.population, m.mortality_rate, f.census_region, f."FLU4_AGE" AS vaccination_rate
FROM mortality_rates m
LEFT JOIN "Flu Shot Survey" f
ON m.year = f.year
WHERE f.year IS NOT NULL
ORDER BY m.year, m.country;

-- ========================
-- Trends Across Regions
-- analyze vaccination rates
-- ========================
SELECT m.year, m.country, m.deaths, m.population, m.mortality_rate, f.census_region
FROM mortality_rates m
LEFT JOIN "Flu Shot Survey" f
ON m.year = f.year
WHERE f.year IS NOT NULL
ORDER BY m.year, m.country;













