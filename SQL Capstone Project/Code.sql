/* 1st Queroies
How many campaigns and sources does CoolTShirts use?
Which source is used for each campaign?*/

SELECT COUNT(DISTINCT utm_campaign) AS 'Campaign Count'
FROM page_visits;

SELECT COUNT(DISTINCT utm_source) AS 'Source Count'
FROM page_visits;

SELECT DISTINCT utm_campaign AS 'Campaigns', utm_source AS 'Sources'
FROM page_visits;

-- What pages are on the CoolTShirts website?

SELECT DISTINCT page_name AS 'Page Names'
FROM page_visits;

-- How many first touches is each campaign responsible for?
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
		pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source AS 'Source',
			 ft_attr.utm_campaign AS 'Campaign',
       COUNT(*) AS 'Total touches'
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

-- How many last touches is each campaign responsibile for?
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
		pv.utm_campaign
FROM last_touch AS 'lt'
JOIN page_visits AS 'pv'
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source AS 'Source',
			 lt_attr.utm_campaign AS 'Campaign',
       COUNT(*) AS 'Total touches'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

-- How many visitors make a purchase?
SELECT COUNT(DISTINCT user_id) AS 'Purchase count'
FROM page_visits
WHERE page_name = '4 - purchase';

-- How many last touches on the purchase page is each campaign responsible for?
WITH last_touch AS (
    SELECT user_id,
       MAX(timestamp) AS 'last_touch_at'
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch AS lt
  JOIN page_visits AS pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source,
       lt_attr.utm_campaign,
       page_name,
       COUNT(*)
FROM lt_attr
WHERE page_name = '4 - purchase'
GROUP BY 2, 3
ORDER BY 4 DESC;

-- How many last touches on the purchase page is each campaign responsible for? (continued)
SELECT page_name, MIN(timestamp), COUNT(*)
FROM page_visits
GROUP BY page_name;

-- What is the typical user journey?
SELECT page_name, MIN(timestamp), COUNT(*)
FROM page_visits
GROUP BY page_name;

-- Optimize the cmapaign budget pt. 1
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
		pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source AS 'Source',
			 ft_attr.utm_campaign AS 'Campaign',
       COUNT(*) AS 'Total touches'
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

-- Optimize the campaign budget pt. 2
WITH last_touch AS (
    SELECT user_id,
       MAX(timestamp) AS 'last_touch_at'
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch AS lt
  JOIN page_visits AS pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source,
       lt_attr.utm_campaign,
       page_name,
       COUNT(*)
FROM lt_attr
WHERE page_name = '4 - purchase'
GROUP BY 2, 3
ORDER BY 4 DESC;
