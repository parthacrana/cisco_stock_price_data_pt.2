USE cisco; # use cisco stock database 

SELECT * FROM stock_data # show everything from stock_data 

SELECT # avg close price per year
    YEAR(datetime) AS year,
    AVG(close) AS avg_close
FROM stock_data
GROUP BY YEAR(datetime)
ORDER BY year;

SELECT AVG(close) AS avg_close_price # showing avg close price alias 
FROM stock_data;

SELECT # years where avg closing price exceeded $30
    YEAR(datetime) AS year,
    AVG(close) AS avg_close
FROM stock_data
GROUP BY YEAR(datetime)
HAVING AVG(close) > 30;

SELECT # running total of close prices 
    datetime,
    close,
    SUM(close) OVER (
        ORDER BY datetime
    ) AS running_total
FROM stock_data;

SELECT # moving avg over 20 days
    datetime,
    close,
    AVG(close) OVER (
        ORDER BY datetime
        ROWS BETWEEN 19 PRECEDING AND CURRENT ROW
    ) AS MA20
FROM stock_data;

SELECT # top 10 highest closing days 
    datetime,
    close,
    RANK() OVER (
        ORDER BY close DESC
    ) AS ranking
FROM stock_data
LIMIT 10;

SELECT # dense rank 
    datetime,
    close,
    DENSE_RANK() OVER (
        ORDER BY close DESC
    ) AS dense_rank
FROM stock_data;

SELECT # row number 
    ROW_NUMBER() OVER (
        ORDER BY datetime
    ) AS row_num,
    datetime,
    close
FROM stock_data;

SELECT # comparing each day's close with previous day's close price 
    datetime,
    close,
    LAG(close,1) OVER (
        ORDER BY datetime
    ) AS previous_close
FROM stock_data;

SELECT # daily price difference 
    datetime,
    close,
    close -
    LAG(close,1) OVER (
        ORDER BY datetime
    ) AS daily_difference
FROM stock_data;

SELECT # comparing today's price with tomorrow's price 
    datetime,
    close,
    LEAD(close,1) OVER (
        ORDER BY datetime
    ) AS next_day_close
FROM stock_data;

WITH avg_price AS ( # cte - common table expressions 
    SELECT AVG(close) AS avg_close
    FROM stock_data
)
SELECT *
FROM stock_data, avg_price
WHERE close > avg_close;

WITH yearly_avg AS ( # multiple cte
    SELECT
        YEAR(datetime) AS yr,
        AVG(close) AS avg_close
    FROM stock_data
    GROUP BY YEAR(datetime)
),
yearly_max AS (
    SELECT
        YEAR(datetime) AS yr,
        MAX(close) AS max_close
    FROM stock_data
    GROUP BY YEAR(datetime)
)
SELECT *
FROM yearly_avg
JOIN yearly_max
ON yearly_avg.yr = yearly_max.yr;

SELECT * # subquery 
FROM stock_data s
WHERE close >
(
    SELECT AVG(close)
    FROM stock_data
);

SELECT * # correlated subquery 
FROM stock_data s1
WHERE close >
(
    SELECT AVG(close)
    FROM stock_data s2
    WHERE YEAR(s2.datetime)=YEAR(s1.datetime)
);

SELECT # percent rank
    datetime,
    close,
    PERCENT_RANK() OVER (
        ORDER BY close
    ) AS percentile_rank
FROM stock_data;

SELECT # volatility analysis 
    datetime,
    high,
    low,
    (high - low) AS daily_range
FROM stock_data;

SELECT # most volatile days 
    datetime,
    high-low AS volatility
FROM stock_data
ORDER BY volatility DESC
LIMIT 20;





