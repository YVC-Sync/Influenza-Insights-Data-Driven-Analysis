-- ========================
-- Add ID column and set as Primary Key in Flu Shot Survey
-- ========================
ALTER TABLE "Flu Shot Survey"
ADD COLUMN id SERIAL PRIMARY KEY;

-- ========================
-- -- Add ID column and set as Primary Key in Data Coding Reference
-- ========================
ALTER TABLE "Data Coding Reference" 
ADD COLUMN id SERIAL PRIMARY KEY;

-- ========================
-- Creating the First Relationship
-- linking flu_shot_survey to data_coding_reference using age_group_code.
-- ========================
ALTER TABLE "Flu Shot Survey"
ADD CONSTRAINT fk_flu_age_group
FOREIGN KEY (age_group_code) 
REFERENCES "Data Coding Reference"(Code);

-- ========================
-- Verify the Foreign Key Relationship
-- Confirm that "Flu Shot Survey" is correctly linked to "Data Coding Reference".
-- ========================
SELECT conname, conrelid::regclass AS table_name, confrelid::regclass AS foreign_table
FROM pg_constraint
WHERE conrelid::regclass = '"Flu Shot Survey"'::regclass;

-- ========================
-- Creating the Next Relationship
-- Linking Influenza Deaths to Data Coding Reference, using the Age Groups Code column.
-- ========================
ALTER TABLE "Influenza Deaths"
ADD CONSTRAINT fk_deaths_age_group
FOREIGN KEY (age_group_code) 
REFERENCES "Data Coding Reference"(Code);

-- ========================
-- Verify the Foreign Key Relationship
-- Confirm that "Influenza Deaths" is correctly linked to "Data Coding Reference".
-- ========================
SELECT conname, conrelid::regclass AS table_name, confrelid::regclass AS foreign_table
FROM pg_constraint
WHERE conrelid::regclass = '"Influenza Deaths"'::regclass;

-- ========================
-- Creating the Next Relationship
-- Linking Influenza Deaths to US Census Data using the state code column.
-- ========================
ALTER TABLE "Influenza Deaths"
ADD CONSTRAINT fk_influenza_deaths_census
FOREIGN KEY (us_census_id)
REFERENCES "US Census Data" (us_census_id);

-- ========================
-- Linking Flu Shot Survey → Influenza Deaths
-- Linking Flu Shot Survey → Influenza Deaths using id
-- ========================
SELECT f.id, f.year AS flu_survey_year, d.year AS influenza_death_year
FROM "Flu Shot Survey" f
LEFT JOIN "Influenza Deaths" d ON f.id = d.id
LIMIT 100;

-- ========================
-- Linking Flu Shot Survey → US Census Data
-- Linking Flu Shot Survey → US Census Data using state
-- ========================
SELECT DISTINCT LOWER(f."STATE") AS flu_survey_state, c.state AS census_state, c.state_code
FROM "Flu Shot Survey" f
LEFT JOIN "US Census Data" c ON LOWER(f."STATE") = c.state
LIMIT 100;

-- ========================
-- Linking All Three Tables Together
-- ========================
SELECT f.id, f.year AS flu_survey_year, d.year AS influenza_death_year,
       LOWER(f."STATE") AS flu_survey_state, c.state AS census_state, c.state_code
FROM "Flu Shot Survey" f
LEFT JOIN "Influenza Deaths" d ON f.id = d.id
LEFT JOIN "US Census Data" c ON LOWER(f."STATE") = c.state
LIMIT 100;































