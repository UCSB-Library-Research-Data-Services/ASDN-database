CREATE TABLE Species (
    Code TEXT PRIMARY KEY,
    Common_name TEXT UNIQUE NOT NULL,
    Scientific_name TEXT,
    Relevance TEXT
);

-- N.B. Scientific_name has NULL values, and is not unique (see data
-- to understand why)
