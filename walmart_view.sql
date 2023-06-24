-- View: wal.store_growth_rate

-- DROP VIEW wal.store_growth_rate;

CREATE OR REPLACE VIEW wal.store_growth_rate
 AS
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

ALTER TABLE wal.store_growth_rate
    OWNER TO postgres;

