SELECT * 
FROM wal.walmart_store_sales 
LIMIT 10;

-- Check null values
SELECT COUNT(*)
FROM wal.walmart_store_sales
WHERE weekly_sales IS NULL;

-- Max weekly sales
SELECT MAX (weekly_sales) AS max_weekly_sales, 
			date
FROM wal.walmart_store_sales
GROUP BY date
ORDER BY max_weekly_sales DESC
LIMIT 5;

-- Which year has the highest sales?
WITH yearly_sales AS (
  SELECT EXTRACT(YEAR FROM date) AS sales_year, 
		SUM(weekly_sales) AS total_sales
  FROM wal.walmart_store_sales
  GROUP BY sales_year
)
SELECT sales_year, total_sales
FROM yearly_sales
ORDER BY total_sales DESC;

--Which month had highest sales in 2011?
WITH monthly_sales AS (
  SELECT EXTRACT(MONTH FROM date) AS sales_month, 
		SUM(weekly_sales) AS total_sales
  FROM wal.walmart_store_sales
  WHERE EXTRACT(YEAR FROM date) = 2011
  GROUP BY sales_month
)
SELECT sales_month, total_sales
FROM monthly_sales
ORDER BY total_sales DESC;

--Which store had the most sales?
WITH total_sales AS (
  SELECT store_id, SUM(weekly_sales) AS total_sales
  FROM wal.walmart_store_sales
  GROUP BY store_id
)
SELECT store_id, total_sales
FROM total_sales
ORDER BY total_sales DESC
LIMIT 3;

-- VIEW creation: store_growth_rate

 SELECT subquery.store_id,
    (subquery.sales_2012 - subquery.sales_2010) / subquery.sales_2010 AS growth_rate
   FROM ( SELECT walmart_store_sales.store_id,
            sum(
                CASE
                    WHEN EXTRACT(year FROM walmart_store_sales.date) = 2010::numeric THEN walmart_store_sales.weekly_sales
                    ELSE 0::numeric
                END) AS sales_2010,
            sum(
                CASE
                    WHEN EXTRACT(year FROM walmart_store_sales.date) = 2012::numeric THEN walmart_store_sales.weekly_sales
                    ELSE 0::numeric
                END) AS sales_2012
           FROM wal.walmart_store_sales
          GROUP BY walmart_store_sales.store_id) subquery;

-- Which store had the highest growth rate from 2010 to 2012?
SELECT store_id, ROUND(growth_rate * 100, 2) AS growth_rate_percentage
FROM wal.store_growth_rate
ORDER BY growth_rate_percentage DESC
LIMIT 5;

-- Which store had the lowest growth rate from 2010 to 2012?
SELECT store_id, ROUND(growth_rate * 100, 2) AS growth_rate_percentage
FROM wal.store_growth_rate
ORDER BY growth_rate_percentage ASC
LIMIT 5;

--Total sales during holiday and non-holiday weeks
SELECT
  CASE
    WHEN holiday_flag THEN 'Holiday Week'
    ELSE 'Non-Holiday Week'
  END AS week_type,
  SUM(weekly_sales) AS total_sales
FROM wal.walmart_store_sales
GROUP BY week_type;

--Which holidays had the most sales?
SELECT date, holiday_flag, MAX(weekly_sales) AS highest_sales
FROM wal.walmart_store_sales
WHERE holiday_flag = true
GROUP BY date, holiday_flag
ORDER BY highest_sales DESC;
--
