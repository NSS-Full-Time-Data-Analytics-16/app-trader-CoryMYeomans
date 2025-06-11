

-- Apple 
SELECT *
FROM app_store_apps;

-- Google
SELECT *
FROM play_store_apps;



-- Apple Profitablilty 

WITH cost_and_lengevity AS (
	SELECT name, price, 
			CASE WHEN price > 2.5 THEN (price * 10000) 
			ELSE (25000) END AS purchase_price,
			ROUND(rating/0.25, 2) * 0.25 AS rounded_rating, 
			((ROUND(rating/0.25, 2) * 6) + 12) AS longevity_months
	FROM app_store_apps
)
SELECT name, longevity_months, purchase_price,
		(5000 * longevity_months) AS rev_earned,
		(1000 * longevity_months) AS ads_cost,
		((5000 * longevity_months) - (1000 * longevity_months)- purchase_price) AS potential_profit		
FROM app_store_apps AS a
JOIN cost_and_lengevity AS cl USING (name)
WHERE name IN ('Star Walk - Find Stars And Planets in Sky Above',
'Zombieville USA',
'Phrase Party!',
'USAA Mobile',
'Roadside America',
'This American Life',
'Summer Games 3D',
'Zombieville USA 2',
'USA TODAY')
ORDER BY potential_profit DESC;



-- Google Profitability 

WITH cost_and_lengevity AS (
	SELECT name, price, 
			CASE WHEN ((REPLACE(price, '$', ''))::numeric) > 2.5 THEN (((REPLACE(price, '$', ''))::numeric) * 10000) 
			ELSE (25000) END AS purchase_price,
			ROUND(rating/0.25, 2) * 0.25 AS rounded_rating, 
			((ROUND(rating/0.25, 2) * 6) + 12) AS longevity_months
	FROM play_store_apps
)
SELECT name, longevity_months, purchase_price,
		(5000 * longevity_months) AS rev_earned,
		(1000 * longevity_months) AS ads_cost,
		((5000 * longevity_months) - (1000 * longevity_months)- purchase_price) AS potential_profit		
FROM play_store_apps AS a
JOIN cost_and_lengevity AS cl USING (name)
WHERE name IN ('American Muscle Car Race',
'USA Singles Meet, Match and Date Free - Date',
'American Girls Mobile Numbers',
'House party - live chat',
'Sarajevo Film Festival - Official',
'Summer Madness',
'SUMMER SONIC app',
'Lineage 2: Revolution')
ORDER BY potential_profit DESC NULLS LAST;




-- Intersecting them

WITH cost_and_lengevity AS (
	SELECT name, price, 
			CASE WHEN price > 2.5 THEN (price * 10000) 
			ELSE (25000) END AS purchase_price,
			ROUND(rating/0.25, 2) * 0.25 AS rounded_rating, 
			((ROUND(rating/0.25, 2) * 6) + 12) AS longevity_months
	FROM app_store_apps
)
SELECT name, longevity_months, purchase_price,
		(5000 * longevity_months) AS rev_earned,
		(1000 * longevity_months) AS ads_cost,
		((5000 * longevity_months) - (1000 * longevity_months)- purchase_price) AS potential_profit		
FROM app_store_apps AS a
JOIN cost_and_lengevity AS cl USING (name)
ORDER BY potential_profit DESC)
INTERSECT
(WITH cost_and_lengevity AS (
	SELECT name, price, 
			CASE WHEN ((REPLACE(price, '$', ''))::numeric) > 2.5 THEN (((REPLACE(price, '$', ''))::numeric) * 10000) 
			ELSE (25000) END AS purchase_price,
			ROUND(rating/0.25, 2) * 0.25 AS rounded_rating, 
			((ROUND(rating/0.25, 2) * 6) + 12) AS longevity_months
	FROM play_store_apps
)
SELECT name, longevity_months, purchase_price,
		(5000 * longevity_months) AS rev_earned,
		(1000 * longevity_months) AS ads_cost,
		((5000 * longevity_months) - (1000 * longevity_months)- purchase_price) AS potential_profit		
FROM play_store_apps AS a
JOIN cost_and_lengevity AS cl USING (name)
ORDER BY potential_profit DESC NULLS LAST);




-- Attempt at Joining data

WITH apple_profit AS (
	SELECT name, price, review_count,
			CASE WHEN price > 2.5 THEN (price * 10000) 
			ELSE (25000) END AS purchase_price,
			ROUND(rating/0.25, 2) * 0.25 AS rounded_rating, 
			((ROUND(rating/0.25, 2) * 6) + 12) AS longevity_months
	FROM app_store_apps AS a
)
SELECT p.name, p.price, p.review_count, 
		CASE WHEN ((REPLACE(p.price, '$', ''))::numeric) > 2.5 THEN (((REPLACE(p.price, '$', ''))::numeric) * 10000) 
		ELSE (25000) END AS purchase_price,
		ROUND(rating/0.25, 2) * 0.25 AS rounded_rating, 
		((ROUND(rating/0.25, 2) * 6) + 12) AS longevity_months,
		a.name, a.price, a.review_count, a.purchase_price, a.rounded_rating, a.longevity_months,
		CASE WHEN purchase_price > a.purchase_price THEN purchase_price 
		ELSE a.purchase_price END AS official_purchase_price, 
		CASE WHEN longevity_months > a.longevity_months THEN longevity_months 
		ELSE a.longevity_months END AS official_longevity_months
FROM play_store_apps AS p
JOIN apple_profit AS a ON p.name = a.name;


-- The GIGA FUNCTION


WITH apple_profit AS (
	SELECT name, price, review_count,
			CASE WHEN price > 2.5 THEN (price * 10000) 
			ELSE (25000) END AS purchase_price,
			ROUND(rating/0.25, 2) * 0.25 AS rounded_rating, 
			((ROUND(rating/0.25, 2) * 6) + 12) AS longevity_months
	FROM app_store_apps AS a), 
	combined_profits AS (
		SELECT p.name AS google_name, p.price AS google_price, p.review_count AS google_review_count, 
			CASE WHEN ((REPLACE(p.price, '$', ''))::numeric) > 2.5 THEN (((REPLACE(p.price, '$', ''))::numeric) * 10000) 
			ELSE (25000) END AS purchase_price,
			ROUND(rating/0.25, 2) * 0.25 AS rounded_rating, 
			((ROUND(rating/0.25, 2) * 6) + 12) AS longevity_months,
			a.name, a.price, a.review_count, a.purchase_price, a.rounded_rating, a.longevity_months,
			CASE WHEN purchase_price > a.purchase_price THEN purchase_price 
			ELSE a.purchase_price END AS official_purchase_price, 
			CASE WHEN longevity_months > a.longevity_months THEN longevity_months 
			ELSE a.longevity_months END AS official_longevity_months
	FROM play_store_apps AS p
	JOIN apple_profit AS a ON p.name = a.name
)
SELECT DISTINCT ao.name, ao.review_count AS apple_review_count, cp.review_count AS google_review_count, 
		(10000 * cp.official_longevity_months) AS total_rev,
		(1000 * cp.official_longevity_months) AS total_ad_cost,
		cp.official_purchase_price AS calc_purchase_price,
		((10000 * cp.official_longevity_months) - (1000 * cp.official_longevity_months) - cp.official_purchase_price) AS total_profit,
		((ao.review_count::numeric) + (cp.review_count::numeric)) AS sum_of_reviews
FROM app_store_apps AS ao
JOIN combined_profits AS cp ON ao.name = cp.google_name
ORDER BY total_profit DESC, sum_of_reviews DESC
LIMIT 10;


---

SELECT COUNT(primary_genre) AS genre_count, primary_genre
FROM app_store_apps
WHERE rating = '4.5' AND review_count::numeric > (SELECT AVG(review_count::numeric)
												  FROM app_store_apps)
GROUP BY primary_genre
ORDER BY genre_count DESC

SELECT COUNT(*) AS genre_count,
		         CASE WHEN genres = 'Action' THEN 'Games'
		 	          WHEN genres = 'Arcade' THEN 'Games'
					  WHEN genres = 'Racing' THEN 'Games'
					  WHEN genres LIKE '%Action & Adventure%' THEN 'Games'
					  WHEN genres = 'Games' THEN 'Games'
			          WHEN genres LIKE '%' THEN genres
			          END AS genre_2
FROM play_store_apps
WHERE rating >= '4.5' AND review_count > (SELECT AVG(review_count)
										 FROM play_store_apps)
GROUP BY genre_2
ORDER BY genre_count DESC;
				



WITH apple_profit AS (
	SELECT name, price, review_count,
			CASE WHEN price > 2.5 THEN (price * 10000) 
			ELSE (25000) END AS purchase_price,
			ROUND(rating/0.25, 2) * 0.25 AS rounded_rating, 
			((ROUND(rating/0.25, 2) * 6) + 12) AS longevity_months
	FROM app_store_apps AS a), 
	combined_profits AS (
		SELECT p.name AS google_name, p.price AS google_price, p.review_count AS google_review_count, a.price AS apple_price,
			CASE WHEN ((REPLACE(p.price, '$', ''))::numeric) > 2.5 THEN (((REPLACE(p.price, '$', ''))::numeric) * 10000) 
			ELSE (25000) END AS purchase_price,
			ROUND(rating/0.25, 2) * 0.25 AS rounded_rating, 
			((ROUND(rating/0.25, 2) * 6) + 12) AS longevity_months,
			a.name, a.price, a.review_count, a.purchase_price, a.rounded_rating, a.longevity_months,
			CASE WHEN purchase_price > a.purchase_price THEN purchase_price 
			ELSE a.purchase_price END AS official_purchase_price, 
			CASE WHEN longevity_months > a.longevity_months THEN longevity_months 
			ELSE a.longevity_months END AS official_longevity_months
	FROM play_store_apps AS p
	JOIN apple_profit AS a ON p.name = a.name
)
SELECT DISTINCT ao.name, GREATEST(((REPLACE(cp.google_price, '$', ''))::numeric), cp.apple_price) AS app_price, 
		(10000 * cp.official_longevity_months) AS total_rev,
		(1000 * cp.official_longevity_months) AS total_ad_cost,
		cp.official_purchase_price AS calc_purchase_price,
		((10000 * cp.official_longevity_months) - (1000 * cp.official_longevity_months) - cp.official_purchase_price) AS total_profit,
		((ao.review_count::numeric) + (cp.review_count::numeric)) AS sum_of_reviews
FROM app_store_apps AS ao
JOIN combined_profits AS cp ON ao.name = cp.google_name
WHERE primary_genre = 'Games' AND content_rating = '4+'
ORDER BY total_profit DESC, app_price DESC, sum_of_reviews DESC
LIMIT 10;



WITH apple_profit AS (
    SELECT name, price, review_count,
           CASE WHEN price > 2.5 THEN (price * 10000)
                ELSE 25000 END AS purchase_price,
           ROUND(rating / 0.25, 2) * 0.25 AS rounded_rating,
           ((ROUND(rating / 0.25, 2) * 6) + 12) AS longevity_months
    FROM app_store_apps
),
combined_profits AS (
    SELECT p.name AS google_name, p.price AS google_price, p.review_count AS google_review_count,
           CASE WHEN ((REPLACE(p.price, '$', ''))::numeric) > 2.5 THEN (((REPLACE(p.price, '$', ''))::numeric) * 10000)
                ELSE 25000 END AS purchase_price,
           ROUND(p.rating / 0.25, 2) * 0.25 AS rounded_rating,
           ((ROUND(p.rating / 0.25, 2) * 6) + 12) AS longevity_months,
           a.name, a.price, a.review_count, a.purchase_price, a.rounded_rating, a.longevity_months,
           CASE WHEN ((REPLACE(p.price, '$', ''))::numeric) * 10000 > a.purchase_price THEN ((REPLACE(p.price, '$', ''))::numeric) * 10000
                ELSE a.purchase_price END AS official_purchase_price,
           CASE WHEN ((ROUND(p.rating / 0.25, 2) * 6) + 12) > a.longevity_months THEN ((ROUND(p.rating / 0.25, 2) * 6) + 12)
                ELSE a.longevity_months END AS official_longevity_months
    FROM play_store_apps AS p
    JOIN apple_profit AS a ON p.name = a.name
),
july4_apps AS (
    SELECT name
    FROM app_store_apps
    WHERE name ILIKE ANY (ARRAY[
        '%4th%', '%july%', '%independence%', '%independence day%',
        '%freedom%', '%fireworks%', '%liberty%', '%america%', '%american%', '%usa%',
        '%patriot%', '%patriotic%', '%stars%', '%stripes%', '%flag%',
        '%firework%', '%celebration%', '%party%', '%red white blue%', '%eagle%',
        '%uncle sam%', '%bbq%', '%red%', '%grill%', '%cookout%', '%summer%',
        '%constitution%', '%founding%', '%revolution%', '%star spangled%',
        '%military%', '%parade%', '%festival%'
    ])
    UNION
    SELECT name
    FROM play_store_apps
    WHERE name ILIKE ANY (ARRAY[
        '%4th%', '%july%', '%independence%', '%independence day%',
        '%freedom%', '%fireworks%', '%liberty%', '%america%', '%american%', '%usa%',
        '%patriot%', '%patriotic%', '%stars%', '%stripes%', '%flag%',
        '%firework%', '%celebration%', '%party%', '%red white blue%', '%eagle%',
        '%uncle sam%', '%bbq%', '%red%', '%grill%', '%cookout%', '%summer%',
        '%constitution%', '%founding%', '%revolution%', '%star spangled%',
        '%military%', '%parade%', '%festival%'
    ])
)
SELECT DISTINCT ao.name,
       ao.review_count AS apple_review_count,
       cp.review_count AS google_review_count,
       (10000 * cp.official_longevity_months) AS total_rev,
       (1000 * cp.official_longevity_months) AS total_ad_cost,
       cp.official_purchase_price AS calc_purchase_price,
       ((10000 * cp.official_longevity_months) - (1000 * cp.official_longevity_months) - cp.official_purchase_price) AS total_profit,
       ((ao.review_count::numeric) + (cp.review_count::numeric)) AS sum_of_reviews
FROM app_store_apps AS ao
JOIN combined_profits AS cp ON ao.name = cp.google_name
WHERE ao.name IN (SELECT name FROM july4_apps)
ORDER BY total_profit DESC, sum_of_reviews DESC;
---LIMIT 4;








