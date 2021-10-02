drop schema if exists operations cascade;

create schema operations;

CREATE TABLE operations.users
(
    id         SERIAL UNIQUE PRIMARY KEY,
    created    TIMESTAMPTZ DEFAULT NOW(),
    updated    TIMESTAMPTZ DEFAULT NOW(),
    retool_id  TEXT NOT NULL UNIQUE,
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