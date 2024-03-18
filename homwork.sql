-- question 1

CREATE MATERIALIZED VIEW trip_time_between_zones AS
        SELECT
            tzpu.zone as pickup_zone,
            tzdo.zone as dropoff_zone,
            COUNT(*) AS trip_count,
            AVG(tpep_dropoff_datetime - tpep_pickup_datetime) AS avg_trip_time,
            MIN(tpep_dropoff_datetime - tpep_pickup_datetime) AS min_trip_time,
            MAX(tpep_dropoff_datetime - tpep_pickup_datetime) AS max_trip_time
        FROM trip_data td
        JOIN taxi_zone tzpu
            ON td.pulocationid = tzpu.location_id
        JOIN taxi_zone tzdo
            ON td.dolocationid = tzdo.location_id
        GROUP BY tzpu.zone, tzdo.zone;

SELECT
        pickup_zone,
        dropoff_zone
    FROM trip_time_between_zones
    ORDER BY avg_trip_time DESC
    LIMIT 1;

-- BONUS

CREATE MATERIALIZED VIEW anomalies_in_trip_time AS
        SELECT *
        FROM trip_time_between_zones
        WHERE max_trip_time >= 10 * avg_trip_time;


-- question 2
SELECT
        trip_count
    FROM trip_time_between_zones
    ORDER BY avg_trip_time DESC
    LIMIT 1;


-- question 3
SELECT
        zone as pickup_zone,
        COUNT(*) AS pickup_count
    FROM trip_data td
    JOIN taxi_zone tz
        ON td.pulocationid = tz.location_id
    WHERE tpep_pickup_datetime >= ((SELECT MAX(tpep_pickup_datetime) FROM trip_data) - INTERVAL '17' HOUR)
    GROUP BY pickup_zone
    ORDER BY pickup_count DESC
    LIMIT 3;

