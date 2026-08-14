DROP TABLE Snow_cover;

CREATE TABLE Snow_cover (
    Site VARCHAR NOT NULL,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1990 AND 2018),
    Date DATE NOT NULL,
    Plot VARCHAR NOT NULL,
    Location VARCHAR NOT NULL,
    Snow_cover REAL CHECK (Snow_cover BETWEEN 0 AND 130),
    Water_cover REAL CHECK (Water_cover BETWEEN 0 AND 130),
    Land_cover REAL CHECK (Land_cover BETWEEN 0 AND 130),
    Total_cover REAL CHECK (Total_cover BETWEEN 0 AND 130),
    Observer VARCHAR,
    Notes VARCHAR,
    PRIMARY KEY (Site, Plot, Location, Date),
    FOREIGN KEY (Site) REFERENCES Site (Code)
);

COPY Snow_cover FROM "../ASDN_csv/snow_survey_fixed.csv" (header TRUE, nullstr "NA");

SELECT * FROM Snow_cover LIMIT 10;

--- Ask 1: What is the average snow cover at each site?
SELECT Site, AVG(Snow_cover) FROM Snow_cover
  GROUP BY Site;

-- Ask2: Top 5 most snowy sites
SELECT Site, AVG(Snow_cover) AS Avg_snowcover FROM Snow_cover
  GROUP BY Site
  ORDER BY Avg_snowcover DESC
  LIMIT 5;

-- ASK 3: save this as a VIEW
CREATE VIEW Site_avg_snowcover AS (
  SELECT Site, AVG(Snow_cover) AS Avg_snowcover FROM Snow_cover
  GROUP BY Site
  ORDER BY Avg_snowcover DESC
  LIMIT 5
);

SELECT * FROM Site_avg_snowcover;

CREATE TEMP TABLE  Site_avg_snowcover_table AS (
  SELECT Site, AVG(Snow_cover) AS Avg_snowcover FROM Snow_cover
  GROUP BY Site
  ORDER BY Avg_snowcover DESC
  LIMIT 5
);

SELECT * FROM Site_avg_snowcover_table;

-- DANGER ZONE AKA updating data
-- We found that 0s at PLot = `brw0` with snow_cover == 0 are actually no data (NULL)
-- Let's try firs on a backup
CREATE TEMP TABLE Snow_cover_backup AS (SELECT * FROM Snow_cover);
UPDATE Snow_cover_backup SET Snow_cover = NULL WHERE Plot = 'brw0' AND Snow_cover = 0;
-- Update real data
UPDATE Snow_cover SET Snow_cover = NULL WHERE Plot = 'brw0' AND Snow_cover = 0;

SELECT * FROM Site_avg_snowcover_table;
SELECT * FROM Site_avg_snowcover;