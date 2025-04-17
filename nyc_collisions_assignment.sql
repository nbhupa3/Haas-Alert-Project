CREATE TABLE nyc_collisions (
    crash_date varchar,
	crash_time varchar,
	borough varchar,
	zip_code varchar,
	latitude double precision,
	longitude double precision,
	location varchar,
	on_street_name varchar,
	cross_street_name varchar,
	off_street_name varchar,
	number_of_persons_injured double precision,
	number_of_persons_killed double precision,
	number_of_pedestrians_injured integer,
	number_of_pedestrians_killed integer,
	number_of_cyclist_injured integer,
	number_of_cyclist_killed integer,
	number_of_motorist_injured integer,
	number_of_motorist_killed integer,
	contributing_factor_vehicle_1 varchar,
	contributing_factor_vehicle_2 varchar,
	collision_id integer,
	vehicle_type_code_1 varchar,
	vehicle_type_code_2 varchar
)



/*Where collisions occur and how many there were in each city of new york. There are plenty of null values, 
collisions in new york but have not determined which city*/
SELECT 
	borough,
	COUNT(*) AS collision_count
FROM nyc_collisions 
GROUP BY borough
ORDER BY collision_count DESC;

/* Which vehicles are involved in the most collisions */
SELECT vehicle_type, COUNT(*) AS collision_count
FROM(
	SELECT vehicle_type_code_1 AS vehicle_type FROM nyc_collisions
	UNION ALL 
	SELECT vehicle_type_code_2 FROM nyc_collisions
) AS all_vehicles
WHERE vehicle_type IS NOT NULL AND vehicle_type <> ''
GROUP BY vehicle_type
ORDER BY collision_count DESC
LIMIT 10; 

/*Describe the kind of collisions that occur*/
/*Which combination of vehicles are involved*/
SELECT 
    vehicle_type_code_1 || ' & ' || vehicle_type_code_2 AS vehicle_pair,
    COUNT(*) AS collision_count
FROM nyc_collisions
WHERE vehicle_type_code_1 IS NOT NULL
  AND vehicle_type_code_2 IS NOT NULL
  AND vehicle_type_code_1 <> ''
  AND vehicle_type_code_2 <> ''
GROUP BY vehicle_pair
ORDER BY collision_count DESC
LIMIT 10;

/* What causes collisions */
SELECT contributing_factor, COUNT(*) AS factor_count
FROM (
    SELECT contributing_factor_vehicle_1 AS contributing_factor FROM nyc_collisions
    UNION ALL
    SELECT contributing_factor_vehicle_2 FROM nyc_collisions
) AS all_factors
WHERE contributing_factor IS NOT NULL 
  AND contributing_factor <> 'Unspecified' 
  AND contributing_factor <> ''
GROUP BY contributing_factor
ORDER BY factor_count DESC
LIMIT 10;

/* Summarize the casuality profile of collisions */
SELECT
    SUM(number_of_persons_injured) AS "Total persons injured",
    SUM(number_of_persons_killed)  AS "Total persons killed",
    SUM(number_of_pedestrians_injured) AS "Total pedestrians injured",
    SUM(number_of_pedestrians_killed)  AS "Total pedestrians killed",
    SUM(number_of_cyclist_injured) AS "Total cyclists injured",
    SUM(number_of_cyclist_killed)  AS "Total cyclists killed",
    SUM(number_of_motorist_injured) AS "Total motorists injured",
    SUM(number_of_motorist_killed)  AS "Total motorists killed"
FROM nyc_collisions;

