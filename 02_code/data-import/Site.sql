CREATE TABLE Site (
    Code TEXT PRIMARY KEY,
    Site_name TEXT UNIQUE NOT NULL,
    Location TEXT NOT NULL,
    Latitude REAL NOT NULL CHECK (Latitude BETWEEN -90 AND 90),
    Longitude REAL NOT NULL CHECK (Longitude BETWEEN -180 AND 180),
    Total_Study_Plot_Area REAL NOT NULL CHECK (Total_Study_Plot_Area > 0),
    UNIQUE (Latitude, Longitude)
);
