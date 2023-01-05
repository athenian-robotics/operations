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
    role       TEXT NOT NULL
);

CREATE TABLE operations.user_hours
(
    id         SERIAL UNIQUE PRIMARY KEY,
    created    TIMESTAMPTZ DEFAULT NOW(),
    updated    TIMESTAMPTZ DEFAULT NOW(),
    user_ref   INT REFERENCES operations.users ON DELETE CASCADE,
    season     INT   NOT NULL,
    date       DATE  NOT NULL,
    start_time TIME  NOT NULL,
    end_time   TIME  NOT NULL,
    hours      FLOAT NOT NULL,
    comments   TEXT        DEFAULT ''

--     CONSTRAINT user_date_unique unique (user_ref, date)
);

CREATE VIEW operations.user_goals AS
SELECT id,
       CASE
           WHEN (role = 'Leadership') THEN 200
           WHEN (role = '2023') THEN 120
           WHEN (role = '2024') THEN 120
           WHEN (role = '2025') THEN 80
           WHEN (role = '2026') THEN 40
           WHEN (role = 'Admin') THEN 100
           ELSE 100
           END AS goal,
       CASE
           WHEN (role = 'Leadership') THEN 'Leadership'
           WHEN (role = '2023') THEN 'Senior'
           WHEN (role = '2024') THEN 'Junior'
           WHEN (role = '2025') THEN 'Sophomore'
           WHEN (role = '2026') THEN 'Freshman'
           WHEN (role = 'Admin') THEN 'Mentor/Faculty'
           ELSE 'Unknown'
           END AS status_desc,
       CASE
           WHEN (role = 'Leadership') THEN 45
           WHEN (role = '2023') THEN 40
           WHEN (role = '2024') THEN 30
           WHEN (role = '2025') THEN 20
           WHEN (role = '2026') THEN 10
           WHEN (role = 'Admin') THEN 50
           ELSE 60
           END AS report_order
FROM operations.users;

CREATE VIEW operations.user_ranges AS
SELECT first_name,
       last_name,
       (first_name || ' ' || last_name)                                                  as full_name,
       email,
       date,
       start_time,
       end_time,
       hours,
       comments,
       tsrange(to_char(date, '[YYYY-MM-DD') || ' ' || to_char(start_time, 'HH24:MI:SS') ||
               to_char(date, ', YYYY-MM-DD') || ' ' || to_char(end_time, 'HH24:MI:SS]')) as hours_range
from operations.users,
     operations.user_hours
WHERE user_hours.user_ref = users.id;


CREATE VIEW operations.user_totals AS
SELECT user_ref,
       season,
       date,
       sum(hours) as hours
FROM operations.user_hours
GROUP BY user_ref, season, date;


CREATE VIEW operations.team_totals AS
SELECT first_name,
       last_name,
       (first_name || ' ' || last_name) as full_name,
       report_order,
       status_desc,
       sum(hours)                       as hours,
       goal
FROM operations.users,
     operations.user_hours,
     operations.user_goals
WHERE user_hours.user_ref = users.id
  AND user_goals.id = users.id
  AND season = 2023
GROUP BY users.id, goal, status_desc, report_order;

