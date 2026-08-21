DROP TABLE Predators;

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
    PRIMARY KEY (Year, Site, Date, Start_time, Species),
    FOREIGN KEY (Site) REFERENCES Site (Code),
    FOREIGN KEY (Observer) REFERENCES Personnel (Abbreviation)
);

COPY Predators FROM "../01_data/data-processed/lemmings_fixed.csv" (header TRUE, nullstr "NA");