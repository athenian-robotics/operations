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
    role TEXT NOT NULL
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
           WHEN (role = '2022') THEN 220
           WHEN (role = '2023') THEN 200
           WHEN (role = '2024') THEN 180
           WHEN (role = '2025 ') THEN 160
           WHEN (role = 'Admin') THEN 100
           ELSE 100
           END AS goal,
       CASE
           WHEN (role = '2022') THEN 'Senior'
           WHEN (role = '2023') THEN 'Junior'
           WHEN (role = '2024') THEN 'Sophomore'
           WHEN (role = '2025') THEN 'Freshman'
           WHEN (role = 'Admin') THEN 'Mentor/Faculty'
           ELSE 'Unknown'
           END AS status_desc,
       CASE
           WHEN (role = '2022') THEN 40
           WHEN (role = '2023') THEN 30
           WHEN (role = '2024') THEN 20
           WHEN (role = '2025 ') THEN 10
           WHEN (role = 'Admin') THEN 50
           ELSE 60
           END AS report_order
FROM operations.users;

CREATE VIEW operations.team_totals AS
SELECT first_name, last_name, (first_name ||' ' || last_name) as full_name, report_order, status_desc, sum(hours) as hours_total, goal
FROM operations.users,
     operations.userhours,
     operations.user_goals
WHERE userhours.user_ref = users.id
  AND user_goals.id = users.id
  AND season = 2022
GROUP BY users.id, goal, status_desc, report_order
