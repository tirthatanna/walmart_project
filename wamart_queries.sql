SELECT * 
FROM wal.walmart_store_sales 
LIMIT 10;

-- Check nulll values
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

-- Which year has the maximum sales?
WITH yearly_sales AS (
  SELECT EXTRACT(YEAR FROM date) AS sales_year, 
		SUM(weekly_sales) AS total_sales
  FROM wal.walmart_store_sales
  GROUP BY sales_year
)
SELECT sales_year, total_sales
FROM yearly_sales
ORDER BY total_sales DESC;

--Which month has maximum sales in 2011?
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

--Which store has the most sales?
WITH total_sales AS (
  SELECT store_id, SUM(weekly_sales) AS total_sales
  FROM wal.walmart_store_sales
  GROUP BY store_id
)
SELECT store_id, total_sales
FROM total_sales
ORDER BY total_sales DESC
LIMIT 3;

-- Which store has the highest growth rate from 2010 to 2012?
SELECT store_id, growth_rate
FROM wal.store_growth_rate
ORDER BY growth_rate DESC
LIMIT 5;

--Stores with the lowest sales growth
SELECT store_id, growth_rate
FROM wal.store_growth_rate
ORDER BY growth_rate ASC
LIMIT 5;

--Total sales during holiday and non-holiday week
SELECT
  CASE
    WHEN holiday_flag THEN 'Holiday Week'
    ELSE 'Non-Holiday Week'
  END AS week_type,
  SUM(weekly_sales) AS total_sales
FROM wal.walmart_store_sales
GROUP BY week_type;

--which holidays have the most sales?
SELECT date, holiday_flag, MAX(weekly_sales) AS highest_sales
FROM wal.walmart_store_sales
WHERE holiday_flag = true
GROUP BY date, holiday_flag
ORDER BY highest_sales DESC;
--