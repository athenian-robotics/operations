drop schema if exists operations cascade;

create schema operations;

CREATE TABLE operations.users
(
    id         INT UNIQUE PRIMARY KEY,
    created    TIMESTAMPTZ DEFAULT NOW(),
    updated    TIMESTAMPTZ DEFAULT NOW(),
    email      TEXT NOT NULL UNIQUE,
    first_name TEXT NOT NULL,
    last_name  TEXT NOT NULL,
    graduation INT  NOT NULL
);

CREATE TABLE operations.userhours
(
    id       SERIAL UNIQUE PRIMARY KEY,
    created  TIMESTAMPTZ DEFAULT NOW(),
    updated  TIMESTAMPTZ DEFAULT NOW(),
    user_ref INT REFERENCES operations.users ON DELETE CASCADE,
    season   INT   NOT NULL,
    date     DATE  NOT NULL,
    hours    FLOAT NOT NULL,
    comments TEXT        DEFAULT '',

    CONSTRAINT user_date_unique unique (user_ref, date)
);

CREATE VIEW operations.user_goals AS
SELECT id,
       CASE
           WHEN (graduation = 2022) THEN 220
           WHEN (graduation = 2023) THEN 200
           WHEN (graduation = 2024) THEN 180
           WHEN (graduation = 2025) THEN 160
           ELSE 100
           END AS goal
FROM operations.users;