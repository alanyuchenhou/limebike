-- Basic facts gathering
-- - Rank bikes by how heavily they are used for June 2017, by user count
SELECT
  bike_id,
  COUNT(DISTINCT user_id) AS user_count
FROM
  trips
WHERE
  created_at >= '2017-06-01 00:00:00'
  AND created_at < '2017-07-01 00:00:00'
GROUP BY
  bike_id
ORDER BY
  user_count;

-- - Rank bikes by how heavily they are used for June 2017, by trip count
SELECT
  bike_id,
  COUNT(DISTINCT id) AS trip_count
FROM
  trips
WHERE
  created_at >= '2017-06-01 00:00:00'
  AND created_at < '2017-07-01 00:00:00'
GROUP BY
  bike_id
ORDER BY
  trip_count;

-- - Calculate per region aggregated usage stats on a specific promotion named 'TestPromo'.
-- - How many users, how many trips for each region.
-- - And how many percentage of the usage are in the first day of the promotion.
SELECT
  user_count,
  trip_count,
  user_count_of_first_day_of_the_promotion / user_count,
  trip_count_of_first_day_of_the_promotion / trip_count
FROM
  (
    SELECT
      promotion_trips.region_id,
      COUNT(DISTINCT promotion_trips.user_id) AS user_count,
      COUNT(DISTINCT promotion_trips.id) AS trip_count,
      COUNT(DISTINCT (
      CASE
        WHEN
          promotion_trips.is_first_day_of_the_promotion = TRUE
        THEN
          promotion_trips.user_id
      END
) ) AS user_count_of_first_day_of_the_promotion, COUNT(DISTINCT (
      CASE
        WHEN
          promotion_trips.is_first_day_of_the_promotion = TRUE
        THEN
          promotion_trips.id
      END
) ) AS trip_count_of_first_day_of_the_promotion
    FROM
      (
        SELECT
          trips.region_id,
          trips.user_id,
          trips.id,
          CASE
            WHEN
              DATE(trips.created_at) = DATE(promotions.started_at)
            THEN
              TRUE
            ELSE
              FALSE
          END
          AS is_first_day_of_the_promotion
        FROM
          trips
          JOIN
            coupons
            ON trips.coupon_id = coupons.id
          JOIN
            promotions
            ON coupons.promotion_id = promotions.id
        WHERE
          promotions.promotion_name = 'TestPromo'
      )
      AS promotion_trips
    GROUP BY
      promotion_trips.region_id
  )
  AS usage_stats;

-- Data transformation
-- - Generate a table to store for each user, what is his/her last used bike, and what is his/her last used coupon
SELECT
  last_bikes.user_id,
  last_bikes.bike_id,
  last_coupons.coupon_id
FROM
  (
    SELECT
      trips.user_id,
      trips.bike_id
    FROM
      trips
      JOIN
        (
          SELECT
            user_id,
            MAX(created_at) AS created_at
          FROM
            trips
          GROUP BY
            user_id
        )
        AS last_trips USING (user_id, created_at)
  )
  AS last_bikes
  JOIN
    (
      SELECT
        trips.user_id,
        trips.coupon_id
      FROM
        trips
        JOIN
          (
            SELECT
              user_id,
              MAX(created_at) AS created_at
            FROM
              trips
            WHERE
              coupon_id IS NOT NULL
            GROUP BY
              user_id
          )
          AS last_trips_with_coupons USING (user_id, created_at)
      WHERE
        coupon_id IS NOT NULL
    )
    AS last_coupons USING (user_id);

-- - From trips and users, generate a user daily spent table that has following columns: date,
-- - user_id, begin_balance, spent_amount_cents, num_trips. spent_amount_cents is the
-- - sum of cost_amount_cents for all the trips for the user that day. You can assume all the
-- - users start with 0 balance that it goes up for each trip, we will bill the user later.
SELECT
  created_at AS DATE,
  user_id,
  0 AS begin_balance,
  SUM(cost_amount_cents) AS spent_amount_cents,
  COUNT(id) AS num_trips
FROM
  trips
GROUP BY
  created_at,
  user_id;

-- Integrated problem solving
-- - Generate a per region revenue report for each region for June 2017. Please write SQL
-- - query to answer how much is gross revenue (sum of all trips completed in that month by
-- - cost_amount_cents), net revenue (gross - refund), number of active users, number of
-- - trips, number of active bikes.
SELECT
  regions.name,
  SUM(trips.cost_amount_cents) AS gross_revenue_cents,
  SUM(trips.cost_amount_cents) - SUM(trips.refunded_amount_cents) AS net_revenue_cents,
  COUNT(DISTINCT trips.user_id) AS number_of_active_users,
  COUNT(trips.id) AS number_of_trips,
  COUNT(DISTINCT trips.bike_id) AS number_of_active_bikes
FROM
  trips
  JOIN
    regions
    ON trips.region_id = regions.id
WHERE
  trips.created_at >= '2017-06-01 00:00:00'
  AND trips.created_at < '2017-07-01 00:00:00'
GROUP BY
  trips.region_id;

-- - Score effectiveness of promotions. Please define a few metrics that you think is
-- - important to determine the effectiveness of promotions, and explain what exactly do they
-- - mean and why they are important. And then write query to generate the metrics per promotion.
-- - definition: I define the effectiveness of a promotion is defined as the number of coupons the prmotion produces
-- - it is important it measures, to some extent, how many new sales this promotion contributes to
SELECT
  promotion_id,
  COUNT(id) AS effectiveness_score
FROM
  coupons
GROUP BY
  promotion_id

-- - Cohort analysis on users churn rate. Please define a cohort, and write queries to
-- - generate the data to show how active this cohort is over a given period of time
-- - I can define a cohort by aggregated user attributes,
-- - such as login counts, total money spent, total time spent, total distance traveled.
-- - However, these hand engineered features will take lot of time to define and optimize.
-- - A better approach is to apply deep learning and use entity embedding technique to do user embedding
-- - and they apply unsupervised machine learning techniques such as clustering to achieve user segmentation.
-- - I can't do these things using SQL.
-- - But I can do them using Python and its machine learning packages including Tensorflow, pandas, sklearn.
-- - To find out more, check out this movie embedding visualization I did for one of my project:
-- - https://github.com/alanyuchenhou/elephant/issues/38#issuecomment-350517247
-- - If you can see the potential contribution I can make to LimeBike, let's move forward and discuss more!
