.nullvalue -NULL-

CREATE TABLE Species (
    Code VARCHAR PRIMARY KEY,
    Common_name VARCHAR UNIQUE NOT NULL,
    Scientific_name VARCHAR, -- can't make NOT NULL, missing data in some rows
    Relevance VARCHAR
);
COPY Species FROM '../01_data/data-processed/species.csv' (header TRUE);


CREATE TABLE Site (
    Code VARCHAR PRIMARY KEY,
    Site_name VARCHAR UNIQUE NOT NULL,
    Location VARCHAR NOT NULL,
    Latitude FLOAT NOT NULL CHECK (Latitude BETWEEN -90 AND 90),
    Longitude FLOAT NOT NULL CHECK (Longitude BETWEEN -180 AND 180),
    Area FLOAT NOT NULL CHECK (Area > 0),
    UNIQUE (Latitude, Longitude)
);
COPY Site FROM '../01_data/data-processed/sites.csv' (header TRUE);


CREATE TABLE Personnel (
    Abbreviation VARCHAR PRIMARY KEY,
    Name VARCHAR NOT NULL
);
COPY Personnel FROM '../01_data/data-processed/observers_all.csv' (header TRUE);


CREATE TABLE Camp_assignment (
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1950 AND 2015),
    Site VARCHAR NOT NULL,
    Start DATE,
    "End" DATE,
    Observer VARCHAR NOT NULL,
    FOREIGN KEY (Site) REFERENCES Site (Code),
    FOREIGN KEY (Observer) REFERENCES Personnel (Abbreviation),
    CHECK (Start <= "End"),
    CHECK (Start BETWEEN (Year||'-01-01')::DATE AND (Year||'-12-31')::DATE),
    CHECK ("End" BETWEEN (Year||'-01-01')::DATE AND (Year||'-12-31')::DATE)
);
COPY Camp_assignment FROM '../01_data/data-processed/camp_assignments.csv' (header TRUE);


CREATE TABLE Bird_nests (
    Book_page VARCHAR,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1950 AND 2015),
    Site VARCHAR NOT NULL,
    Nest_ID VARCHAR PRIMARY KEY,
    Species VARCHAR NOT NULL,
    Observer VARCHAR,
    Date_found DATE NOT NULL
        CHECK (
            Date_found BETWEEN (Year||'-01-01')::DATE
            AND (Year||'-12-31')::DATE
        ),
    how_found VARCHAR CHECK (how_found IN ('searcher', 'rope', 'bander', 'single', 'incidental', 'rapid', 'systematic search', 'transect', 'other')),
    Clutch_max INTEGER CHECK (Clutch_max BETWEEN 0 AND 20),
    floatAge FLOAT CHECK (floatAge BETWEEN 0 AND 30),
    ageMethod VARCHAR CHECK (ageMethod IN ('float', 'lay', 'hatch', 'mean date')),
    FOREIGN KEY (Site) REFERENCES Site (Code),
    FOREIGN KEY (Species) REFERENCES Species (Code),
    FOREIGN KEY (Observer) REFERENCES Personnel (Abbreviation)
);
COPY Bird_nests FROM '../01_data/data-processed/bird_nests_abbrev.csv' (header TRUE, NULL "NA");

CREATE TABLE Bird_eggs (
    Book_page VARCHAR,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1950 AND 2015),
    Site VARCHAR NOT NULL,
    Nest_ID VARCHAR NOT NULL,
    Egg_num INTEGER NOT NULL CHECK (Egg_num BETWEEN 1 AND 20),
    Length FLOAT NOT NULL CHECK (Length > 0 AND Length < 100),
    Width FLOAT NOT NULL CHECK (Width > 0 AND Width < 100),
    PRIMARY KEY (Nest_ID, Egg_num),
    FOREIGN KEY (Site) REFERENCES Site (Code),
    FOREIGN KEY (Nest_ID) REFERENCES Bird_nests (Nest_ID)
);
COPY Bird_eggs FROM '../01_data/data-processed/bird_eggs_observers_matched.csv' (header TRUE);


CREATE TABLE Predators (
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1950 AND 2015),
    Site VARCHAR NOT NULL,
    Date DATE NOT NULL,
    Jdate INTEGER NOT NULL CHECK (Jdate BETWEEN 1 AND 366),
    Start_time TIME NOT NULL,
    End_time TIME,
    Hours FLOAT,
    Count_type VARCHAR CHECK (Count_type IN ('est', 'exact')),
    Species VARCHAR NOT NULL,
    Count INTEGER,
    Num_observers INTEGER,
    Nests_or_dens INTEGER,
    Team_count VARCHAR CHECK (Team_count IN ('y', 'n')),
    Observer VARCHAR,
    PRIMARY KEY (Year, Site, Date, Start_time, End_time, Species),
    FOREIGN KEY (Site) REFERENCES Site (Code),
    FOREIGN KEY (Observer) REFERENCES Personnel (Abbreviation)
);

COPY Predators FROM "../01_data/data-processed/lemmings_fixed.csv" (header TRUE, nullstr "NA");
