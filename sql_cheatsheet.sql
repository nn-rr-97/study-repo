-- SQL character index starts from 1

-- data types in SQL
char - fixed length string, max length 255
varchar - variable length string, max length 65535
text - variable length string, max length 65535
int - integer, 4 bytes, -2147483648 to 2147483647
bigint - integer, 8 bytes, -9223372036854775808 to 9223372036854775807
float - floating-point number, 4 bytes, 1.175494351E-38 to 3.402823466E+38
double - double-precision floating-point number, 8 bytes, 2.2250738585072014E-308 to 1.7976931348623157E+308
date: 2024-05-27
time: 10:15:30
datetime: 2024-05-27 10:15:30
timestamp: 2024-05-27 10:15:30
boolean: true or false
binary: binary data, max length 65535
varbinary: variable length binary data, max length 65535

-- case sensitivity
-- keywords and commands are case-insensitive
-- data and operators can be case-sensitive
SELECT * FROM users WHERE username LIKE 'alice'; -- case-sensitive or not depends on the collation of the database
SELECT * FROM users WHERE BINARY username LIKE 'alice'; -- case-sensitive

-- use of customised alias
-- Best practice is to avoid using custom aliases in WHERE, GROUP BY, and HAVING clauses of the same query level.
-- Although MySQL allows aliases in GROUP BY and HAVING clauses

-- limit - limit the number of rows returned by a query
SELECT * FROM table_name LIMIT 5; -- returns the first 5 rows from the table

-- offset - skip a specified number of rows before returning the result set
SELECT * FROM table_name LIMIT 5 OFFSET 5; -- returns rows 6 to 10

-- Handling NUll

IFNULL(expression, replacement) -- return an alternative value if an expression is NULL
SELECT ProductName, UnitPrice * (UnitsInStock + IFNULL(UnitsOnOrder, 0))
FROM Products;

-- NVL(expression, replacement) - Replaces a NULL value with a specified replacement value (support in Oracle)
SELECT NVL(column_name, 'default_value') FROM table_name; -- Replaces NULL values in a column with a specified value.

-- COALESCE(expression1, expression2, ..., expressionN) - returns the first non-NULL expression among its arguments
SELECT COALESCE(column1, column2, 'default_value') FROM table_name; -- return the value of column1 if it's not null, otherwise column2, and if both are null, it returns 'default_value'.

-- COALESCE can also be used to replace NULL values with a specified value.
SELECT COALESCE(column_name, 'default_value') FROM table_name; -- Replaces NULL values in a column with a specified value.

-- NULLIF(expression1, expression2) - Returns NULL if expression1 equals expression2; otherwise, it returns expression1
SELECT NULLIF(column1, column2) FROM table_name; -- If column1 equals column2, the result is NULL. Otherwise, it returns the value of column1.

-- NULLIF(col1, 0) - returns NULL if col1 is 0, otherwise returns col1

-- primary key
-- unique identifier for each table row

-- foreign key
--  a key used to link two tables together, it is a field in a table that refers to the PRIMARY KEY in another table    

-- build relationship between tables
-- The primary purpose of establishing relationships (such as foreign key relationships) is to maintain data integrity.
-- When you create a relationship, it enforces rules that ensure consistency between related records in the tables.


-- Filters
-- the WHERE clause filters individual tuples before they are grouped via GROUP BY
-- the HAVING clause filters whole groups after they have been formed with GROUP BY

-- orders
SELECT distinct product_category, SUM(sales_amount) AS total_sales
FROM sales
join products
on sales.product_id = products.product_id
WHERE sales_date > '2024-01-01'
GROUP BY product_category
HAVING SUM(sales_amount) > 10000
ORDER BY total_sales DESC
LIMIT 10
OFFSET 5;

-- the order of the clauses in a SQL query start with FROM, JOIN, WHERE, GROUP BY, HAVING, SELECT, DISTINCT, ORDER BY, and LIMIT/OFFSET

-- SELECT with subquery, it allows the current column of the main query to be compared with the result of the subquery
SELECT (select t2.name from table2 t2 where t2.id = t1.id), t1.name from table1 t1;

-- different where clause conditions
-- =, <>, !=, >, <, >=, <=, BETWEEN , LIKE, IN, IS NULL, IS NOT NULL, AND, OR, NOT
where between 1 and 10
where like 'a%' -- starts with a
where like '%a' -- ends with a
where like '%or%' -- contains or
where in ('a', 'b', 'c')
where is null
where is not null
where and
where or
where not

-- aggregated function and group by
-- when group by not needed - counting the number of rows in a table
SELECT COUNT(*) FROM table_name;
-- when group by needed - counting the number of rows in a table for each category
SELECT category, COUNT(*) FROM table_name GROUP BY category;
-- when group by needed - counting the number of rows in a table for each category and order by the count in descending order
SELECT category, COUNT(*) FROM table_name GROUP BY category ORDER BY COUNT(*) DESC;

-- aggregation function can be used in having clause
SELECT category, COUNT(*) FROM table_name GROUP BY category HAVING COUNT(*) > 10;

-- aggregation function can be used in having clause with self group by
select category from table group by category having count(*) > (select count(*) from table group by category order by count(*) desc limit 1); -- get the category with the most rows

-- using group by when no aggregation function is used
-- group by is used to group rows that have the same values in a specified column or columns into summary rows
SELECT category FROM table_name GROUP BY category; -- get the unique values in the category column

-- remove zero in integer numbers
-- trim() function can be used to remove leading and trailing zeros from a number
SELECT TRIM(TRAILING '0' FROM column_name) FROM table_name; -- this removes trailing zeros from the column values, trailing means zeros at the end
SELECT TRIM(LEADING '0' FROM column_name) FROM table_name; -- this removes leading zeros from the column values, leading means zeros at the start
select trim('0' from column_name) from table_name; -- this removes all leading and trailing zeros from the column values

-- REMOVE zeros using replace
SELECT REPLACE(column_name, '0', '') FROM table_name; -- this removes '0' from the column values

-- not equal
<> or !=

or NOT


-- Pattern Matching
-- LIKE - case-sensitive by default
-- % as placeholders representing any sequence of zero or more characters.
SELECT uosCode, uosName
  FROM UnitOfStudy
 WHERE uosName LIKE '%Database%';

-- Similar to
SELECT uosCode, uosName
  FROM UnitOfStudy
 WHERE uosName SIMILAR TO '(Advanced|Data)%'; -- start with Advanced or Data

SELECT uosCode, uosName
  FROM UnitOfStudy
 WHERE uosCode SIMILAR TO 'COMP[[:digit:]]{4}'; -- start with COMP followed by 4 digits

-- Regular Expression
-- ~ operator, ~ is used to match a regular expression pattern, similar to LIKE but for more complex pattern matching
SELECT uosCode, uosName
  FROM UnitOfStudy
 WHERE uosName ~ '^[A-D].*'; -- start with A to D


-- IN - to match multiple values, allowing the specification of multiple values for a condition
SELECT uosCode, uosName
  FROM UnitOfStudy
 WHERE uosCode IN ('COMP5111', 'COMP5318', 'COMP5319');

-- Handling cases
-- UPPER() function to convert to uppercase
-- LOWER() function to convert to lowercase
SELECT uosCode, uosName
  FROM UnitOfStudy
 WHERE UPPER(uosName) LIKE '%DATABASE%';

-- _ as placeholder to match exact characters, e.g. 3 single characters below
SELECT uosCode, uosName
  FROM UnitOfStudy
 WHERE uosCode LIKE 'INFO1___';


-- GROUP BY
-- USE group by when need to aggregate data across multiple rows that share a common value
-- Aggregate functions like SUM(), AVG(), COUNT(), MIN(), MAX() often require GROUP BY to specify the grouping columns.
-- all columns in the SELECT statement that are not used within an aggregate function must be included in the GROUP BY clause.

-- conditional data aggregation

-- filter - straightforward condition, not widely used, CASE WHEN is more preferrable
SUM(amount) FILTER (WHERE condition) -- sum of amount where condition is met

SELECT
    product_id,
    SUM(amount) AS total_sales_amount,
    SUM(amount) FILTER (WHERE sale_date > '2024-01-01') AS sales_amount_after_january
FROM
    sales
GROUP BY
    product_id;


-- CASE - to create a new column based on a condition, more complex conditional logic

SELECT
    product_id,
    SUM(amount) AS total_sales_amount,
    SUM(CASE WHEN sale_date > '2024-01-01' THEN amount ELSE 0 END) AS sales_amount_after_january
FROM
    sales
GROUP BY
    product_id;


-- CASE - multiple conditions
SUM(CASE WHEN condition1 THEN value1
         WHEN condition2 THEN value2
         ELSE 0 END)

-- CASE - with aggregate functions
SELECT uosCode, uosName, COUNT(*) AS numStudents,
       CASE WHEN COUNT(*) > 100 THEN 'Large' ELSE 'Small' END AS classSize
  FROM Enrolment
 GROUP BY uosCode, uosName;


-- Multiple CASE WHEN with OR
SELECT
    employee_id,
    first_name,
    last_name,
    CASE
        WHEN first_name LIKE 'A%' OR last_name LIKE 'A%' THEN 'Starts with A'
        WHEN first_name LIKE 'B%' OR last_name LIKE 'B%' THEN 'Starts with B'
        ELSE 'Other'
    END AS name_category
FROM
    employees;

-- CASE WHEN can work in JOIN
SELECT CASE WHEN EXISTS (SELECT 1 FROM table2 WHERE table2.column = table1.column) THEN 'Yes' ELSE 'No' END AS column_exists
FROM table1;

-- if
-- IF(condition, value_if_true, value_if_false)
SELECT product_name, unit_price,
       IF(unit_price > 100, 'Expensive', 'Affordable') AS price_category

-- if vs case when: IF is used to return a value based on a condition, while CASE WHEN is used to return a value based on multiple conditions.

-- iif() - returns one value if a condition is true and another value if the condition is false
SELECT IIF(sales > 1000, 'High', 'Low') AS sales_category -- return 'High' if sales is greater than 1000, otherwise return 'Low'

-- iif vs if: IIF() is a shorthand for the CASE statement, it is more concise and easier to read than the CASE statement

-- select into - create a new table from an existing table
-- copies only the German customers into a new table
SELECT * INTO CustomersGermany
FROM Customers
WHERE Country = 'Germany';

-- INSERT - with specific values
INSERT INTO table_name (column1, column2, column3, ...)
VALUES (value1, value2, value3, ...);

-- INSERT - with multiple specific values
INSERT INTO table_name (column1, column2, ...)
VALUES (value1, value2, ...), (value1, value2, ...), ...;

-- INSERT - with values from another table
INSERT INTO table_name
SELECT column1, column2, column3, ...
FROM another_table_name
WHERE condition;

-- INSERT - with no duplicates
INSERT INTO table_B (column1, column2, ...)
SELECT column1, column2, ...
FROM table_A
WHERE table_A.unique_key NOT IN (SELECT unique_key FROM table_B);


INSERT INTO table_B (column1, column2, ...)
SELECT column1, column2, ...
FROM table_A
WHERE NOT EXISTS (SELECT 1 FROM table_B WHERE table_B.unique_key = table_A.unique_key); -- return 1 if the subquery returns one or more rows, otherwise return 0

-- select 1 in sql, doesn't return any data, just checks if there is at least one row that meets the condition
SELECT 1 FROM table WHERE condition LIMIT 1


-- update
UPDATE Customers
SET ContactName = 'Alfred Schmidt', City = 'Frankfurt'
WHERE CustomerID = 1;


-- delete
DELETE FROM table_name
WHERE condition;

 ----------------JOIN----------------
-- INNER JOIN - returns rows when there is at least one match in both tables (From..Join,,)
SELECT column_name(s)
FROM table1
INNER JOIN table2
ON table1.column_name = table2.column_name;

-- INNER JOIN - with multiple conditions
SELECT column_name(s)
FROM table1
INNER JOIN table2
ON table1.column_name1 = table2.column_name1
AND table1.column_name2 = table2.column_name2;

-- INNER JOIN - with multiple tables
SELECT column_name(s)
FROM table1
INNER JOIN table2
ON table1.column_name = table2.column_name
INNER JOIN table3
ON table1.column_name = table3.column_name;

-- INNER JOIN - with WHERE clause
SELECT column_name(s)
FROM table1
INNER JOIN table2
ON table1.column_name = table2.column_name
WHERE condition;

-- INNER JOIN - with GROUP BY
SELECT column_name(s)
FROM table1
INNER JOIN table2
ON table1.column_name = table2.column_name
GROUP BY column_name;

-- INNER JOIN - with ORDER BY
SELECT column_name(s)
FROM table1
INNER JOIN table2
ON table1.column_name = table2.column_name
ORDER BY column_name;

-- INNER JOIN - with LIMIT
SELECT column_name(s)
FROM table1
INNER JOIN table2
ON table1.column_name = table2.column_name
LIMIT 5;

-- LEFT JOIN (or LEFT OUTER JOIN) - returns all rows from the left table, and the matched rows from the right table
SELECT column_name(s)
FROM table1
LEFT JOIN table2
ON table1.column_name = table2.column_name;

-- RIGHT JOIN (or RIGHT OUTER JOIN) - returns all rows from the right table, and the matched rows from the left table
SELECT column_name(s)
FROM table1
RIGHT JOIN table2
ON table1.column_name = table2.column_name;

-- FULL JOIN (or FULL OUTER JOIN) - returns rows when there is a match in one of the tables
-- use it when you want to return all rows from both tables
SELECT column_name(s)
FROM table1
FULL JOIN table2
ON table1.column_name = table2.column_name;

-- SELF JOIN - join a table to itself
SELECT column_name(s)
FROM table1 T1, table1 T2
WHERE condition;

-- cross join - cartesian product of two or more tables, match each row of one table to every other row of another table
-- when using with WHERE clause, it acts as INNER JOIN
SELECT * FROM table1
CROSS JOIN table2;

-- anti join - returns rows from the first table that do not have a match in the second table
SELECT column_name(s)
FROM table1
LEFT JOIN table2
ON table1.column_name = table2.column_name
WHERE table2.column_name IS NULL;

-- or
SELECT column_name(s)
FROM table1
WHERE column_name NOT IN
(SELECT column_name
FROM table2);

-- or use NOT EXISTS
SELECT column_name(s)
FROM table1
WHERE NOT EXISTS
(SELECT column_name
FROM table2
WHERE table1.column_name = table2.column_name);


-- Create view
CREATE VIEW view_name AS
SELECT column1, column2, ...
FROM table_name
WHERE condition;

-- view can be used like a table
SELECT * FROM view_name;
-- drop view
DROP VIEW view_name;
-- update view
CREATE OR REPLACE VIEW view_name AS
SELECT column1, column2, ...
FROM table_name
WHERE condition;
-- view with JOIN
CREATE VIEW view_name AS
SELECT column1, column2, ...
FROM table1
JOIN table2
ON table1.column_name = table2.column_name;
-- view with GROUP BY
CREATE VIEW view_name AS
SELECT column1, COUNT(column2) AS count_column2
FROM table_name
GROUP BY column1;
-- view with ORDER BY
CREATE VIEW view_name AS
SELECT column1, column2
FROM table_name
ORDER BY column1;
-- view with LIMIT
CREATE VIEW view_name AS
SELECT column1, column2
FROM table_name
LIMIT 5;
-- view with OFFSET
CREATE VIEW view_name AS
SELECT column1, column2
FROM table_name
OFFSET 5;
-- view with FETCH, fetch is used to limit the number of rows returned by a query, similar to LIMIT
CREATE VIEW view_name AS
SELECT column1, column2
FROM table_name
FETCH FIRST 5 ROWS ONLY; -- fetch first 5 rows
-- view with FETCH
CREATE VIEW view_name AS
SELECT column1, column2
FROM table_name
FETCH NEXT 5 ROWS ONLY; -- fetch next 5 rows, next 5 rows mean the rows after the first 5 rows


-- UNION - combine the result set of two or more SELECT statements
-- UNION - removes duplicate rows
SELECT column_name(s)
FROM table1
UNION
SELECT column_name(s)
FROM table2;

-- UNION ALL - does not remove duplicate rows
SELECT column_name(s)
FROM table1
UNION ALL
SELECT column_name(s)
FROM table2;

-- union all can be used in CTE
WITH cte_name AS (
  SELECT column_name(s)
  FROM table1
  UNION ALL
  SELECT column_name(s)
  FROM table2
)

-- UNION ALL is faster than UNION as it does not remove duplicates
-- UNION ALL is used when you want to include all rows from multiple SELECT statements
-- UNION is used when you want to remove duplicate rows from the result set

-- compare UNION ALL with just two SELECT statements 
-- Separate SELECT Statements are useful when you need to retrieve and display results from multiple tables independently.
-- UNION ALL is useful when you want to combine results from multiple tables into a single result set, including all duplicates.

-- EXIST and NOT EXIST, used in WHERE clause to check for the existence of rows in a subquery
-- They don't return any data. They act as a test or condition within the WHERE clause, and provide a TRUE/FALSE evaluation for each row in the outer query

-- How they work: For each row in the outer query, the subquery (inside EXISTS or NOT EXISTS) is executed. EXISTS evaluates to TRUE if the subquery returns any rows, 
-- FALSE otherwise; NOT EXISTS evaluates to TRUE if the subquery returns no rows, FALSE otherwise. The outer query Uses this TRUE/FALSE information to decide which 
-- rows to include in the final result set, and returns rows from the table(s) specified in its FROM clause, not from the subquery.

-- EXISTS, below outer query will return the supplier name based on EXISTS condition. If EXISTS is True for a supplier, it will return the supplier name
-- find suppliers who have products priced less than $20
SELECT SupplierName
FROM Suppliers
WHERE EXISTS (SELECT ProductName FROM Products WHERE Products.SupplierID = Suppliers.supplierID AND Price < 20);


-- NOT EXISTS, below outer query will return the supplier name based on NOT EXISTS condition. If NOT EXISTS is True for a supplier, it will return the supplier name
-- find suppliers who do not have any products priced over $100,000
SELECT SupplierName
from Suppliers
WHERE NOT EXISTS (SELECT ProductName FROM Products WHERE Products.SupplierID = Suppliers.supplierID AND Price > 100000);

-- EXISTS vs IN: EXISTS is used to check for the existence of rows in a subquery, while IN is used to compare a value to a list of values returned by a subquery.
-- exists is faster than in as it returns true as soon as it finds a match, while in returns all the matchese before returning true

-- ANY - to compare a value to any value in a list or returned by a subquery
-- finds ANY records in the OrderDetails table has Quantity equal to 10
SELECT ProductName
FROM Products
WHERE ProductID = ANY
  (SELECT ProductID
  FROM OrderDetails
  WHERE Quantity = 10);

-- ALL - to compare a value to every value in a list or returned by a subquery
-- lists the ProductName if ALL the records in the OrderDetails table has Quantity equal to 10, otherwise return false
SELECT ProductName
FROM Products
WHERE ProductID = ALL
  (SELECT ProductID
  FROM OrderDetails
  WHERE Quantity = 10);

-- Window Functions

-- patition by - divide the data into groups within partitions, rather than across the entire dataset
-- ORDER BY - sort the data within each partition

-- window function - operate on a set of rows related to the current row
-- OVER() - defines the window frame within a partition of a result set

-- no need to be included in the GROUP BY clause as it operates on the result set after the GROUP BY clause has been applied

-- in a cte or subquery, window functions can be used to calculate running totals, moving averages, and other aggregations, but can't be used with GROUP BY or HAVING or where clause
-- this means if I get rank_Num in a cte, I can't directly use where rank_Num = 1 in cte, I need to use it in the outer query. Because window functions are applied after the GROUP BY clause.

-- ROW_NUMBER() - assigns a unique sequential integer to each row within a partition of a result set
-- use this if we want to find top N rows in each group
SELECT product_category, sales_amount,
       ROW_NUMBER() OVER (PARTITION BY product_category ORDER BY sales_amount DESC) AS rank
  FROM sales;

-- RANK() - assigns a unique integer to each distinct row within the partition of a result set, skipping the next integer if there is a tie
-- use this if we want to find top N distinct rows in each group, if there are ties, the next rank will be skipped
SELECT product_category, sales_amount,
       RANK() OVER (PARTITION BY product_category ORDER BY sales_amount DESC) AS rank
  FROM sales;

-- DENSE_RANK() - assigns a unique integer to each distinct row within the partition of a result set, without gaps
-- use this if we want to find top N distinct rows in each group, if there are ties, the next rank will not be skipped
SELECT product_category, sales_amount,
       DENSE_RANK() OVER (PARTITION BY product_category ORDER BY sales_amount DESC) AS rank
  FROM sales;

-- NTILE() - divides an ordered set of rows into a specified number of approximately equal groups
SELECT product_category, sales_amount,
       NTILE(4) OVER (PARTITION BY product_category ORDER BY sales_amount DESC) AS quartile -- divide the rows into 4 groups
  FROM sales;

-- LAG(amount,1) - accesses data from a previous row in the same result set without the use of a self-join
-- below query returns the previous sales_amount for each product_category
SELECT product_category, sales_amount,
       LAG(sales_amount, 1) OVER (PARTITION BY product_category ORDER BY sales_amount) AS prev_sales_amount
  FROM sales;

-- LEAD() - accesses data from a subsequent row in the same result set without the use of a self-join
-- below query returns the next sales_amount for each product_category
SELECT product_category, sales_amount,
       LEAD(sales_amount, 1) OVER (PARTITION BY product_category ORDER BY sales_amount) AS next_sales_amount
  FROM sales;

-- FIRST_VALUE() - returns the first value in an ordered set of values, equal to the value of the first row in the partition use row_number() = 1
SELECT product_category, sales_amount,
       FIRST_VALUE(sales_amount) OVER (PARTITION BY product_category ORDER BY sales_amount) AS first_sales_amount
  FROM sales;

-- LAST_VALUE() - returns the last value in an ordered set of values
SELECT product_category, sales_amount,
       LAST_VALUE(sales_amount) OVER (PARTITION BY product_category ORDER BY sales_amount) AS last_sales_amount
  FROM sales;

-- PERCENT_RANK() - calculates the relative rank of a value in a group of values, e.g. 0.33 means the value is greater than 33% of the values in the group
SELECT product_category, sales_amount,
       PERCENT_RANK() OVER (PARTITION BY product_category ORDER BY sales_amount) AS percent_rank
  FROM sales;

-- CUME_DIST() - calculates the cumulative distribution of a value in a group of values, It represents the proportion of rows with values less than or equal to the current row's value
SELECT product_category, sales_amount,
       CUME_DIST() OVER (PARTITION BY product_category ORDER BY sales_amount) AS cume_dist
  FROM sales;

-- PERCENTILE_CONT() - calculates the value that corresponds to a specified percentile in a group of values
-- below query calculates the median sales_amount for each product_category
SELECT product_category, sales_amount,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sales_amount) OVER (PARTITION BY product_category) AS median_sales_amount
  FROM sales;

-- PERCENTILE_DISC() - calculates the value that corresponds to a specified percentile in a group of values, percentile means the value that divides the data into two parts
-- below query calculates the median sales_amount for each product_category
SELECT product_category, sales_amount,
       PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY sales_amount) OVER (PARTITION BY product_category) AS median_sales_amount
  FROM sales;
-- PERCENTILE_CONT() vs PERCENTILE_DISC(), PERCENTILE_CONT() returns a value that falls between the values in the dataset, while PERCENTILE_DISC() returns a value from the dataset


-- aggregate functions with window functions - get running aggregates
SELECT product_category, sales_amount,
       SUM(sales_amount) OVER (PARTITION BY product_category ORDER BY sales_date) AS running_total
  FROM sales; -- running total of sales_amount within each product_category

-- avg - moving average of a specified number of previous rows.
-- calculating a percentage can be done using sum(case when condition then 1 else 0 end) / count(*) or avg(case when condition then 1 else 0 end)

-- count - cumulative count of rows up to the current row.
-- max - maximum value of a specified number of previous rows.
-- min - minimum value of a specified number of previous rows.


-- ROWS BETWEEN - specify a window frame within a partition of a result set
-- below sum the sales for the current month and the previous month
SELECT month, sales,
  SUM(sales) OVER (ORDER BY month ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS moving_sum
FROM sales;

-- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW - from the first row to the current row
SELECT month, sales, 
       SUM(sales) OVER (ORDER BY month ROWS UNBOUNDED PRECEDING) AS cumulative_sales
FROM sales;

-- n preceding - the n-th row before the current row
SELECT month, sales, 
       SUM(sales) OVER (ORDER BY month ROWS 2 PRECEDING) AS moving_sum
FROM sales;

-- current row - the current row
SELECT month, sales, 
       SUM(sales) OVER (ORDER BY month ROWS BETWEEN CURRENT ROW AND CURRENT ROW) AS current_row_sales
FROM sales;

-- unbouded following - from the current row to the last row
SELECT month, sales, 
       SUM(sales) OVER (ORDER BY month ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS moving_sum_following
FROM sales;

-- n following - the n-th row after the current row
SELECT month, sales, 
       SUM(sales) OVER (ORDER BY month ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS moving_sum_following
FROM sales;

-- range between - specify a window frame within a partition of a result set based on the values of the rows
-- below sum the sales for the current month and the previous month
SELECT month, sales,
  SUM(sales) OVER (ORDER BY month RANGE BETWEEN INTERVAL 1 MONTH PRECEDING AND INTERVAL 1 MONTH FOLLOWING) AS moving_sum

-- round
SELECT product_name, ROUND(price, 2) AS rounded_price
FROM products;

-- cast - convert one data type to another
SELECT product_name, CAST(price AS INT) AS price_int
SELECT product_name, CAST(price AS DECIMAL(10,2)) AS price_decimal -- decimal with 10 digits and 2 decimal places, DECIMAL(precision, scale)

-- handle dates
-- DATE - format: 'YYYY-MM-DD'
-- TIME - format: 'HH:MM:SS'
-- TIMESTAMP - format: 'YYYY-MM-DD HH:MM:SS'

-- EXTRACT() - extracts parts of a date or time value
-- year, month, day, hour, minute, second, week, quarter
SELECT product_name, EXTRACT(YEAR FROM sales_date) AS sales_year

-- DATE_PART() - extracts parts of a date or time value
-- year, month, day, hour, minute, second, week, quarter
SELECT product_name, DATE_PART('year', sales_date) AS sales_year -- extract the year from the sales_date, same as EXTRACT(YEAR FROM sales_date)

-- TO_CHAR() - converts a date or time value to a string
SELECT product_name, TO_CHAR(sales_date, 'YYYY-MM-DD') AS formatted_sales_date

-- TO_DATE() - converts a string to a date or time value
SELECT product_name, TO_DATE('2024-01-01', 'YYYY-MM-DD') AS formatted_date

-- INTERVAL - represents a period of time
SELECT DATE_ADD('2024-05-27', INTERVAL 1 MONTH) AS new_date; -- get 2024-06-27
SELECT DATE_SUB('2024-05-27 10:00:00', INTERVAL 2 HOUR) AS new_datetime; -- get 2024-05-27 08:00:00

-- directly add interval to date
SELECT product_name, sales_date + INTERVAL 1 DAY AS next_day
-- or only find the most recent 12 months
select product from sales where sales_date > current_date - interval '12 months';
-- or only find the most recent 20 days
select product from sales where sales_date > current_date - interval '20 days';

-- CURRENT_DATE - returns the current date
SELECT product_name, CURRENT_DATE AS current_date
-- current_date is equivalent to now()::date, only returns the current date
-- add or subtract interval to current_date to get the date in the future or past
SELECT product_name, CURRENT_DATE + INTERVAL '1 month' AS next_month

-- CURRENT_TIME - returns the current time
SELECT product_name, CURRENT_TIME AS current_time
-- current_time is equivalent to now()::time, only returns the current time
-- add or subtract interval to current_time to get the time in the future or past
SELECT product_name, CURRENT_TIME + INTERVAL '1 hour' AS next_hour

-- CURRENT_TIMESTAMP - returns the current date and time
SELECT product_name, CURRENT_TIMESTAMP AS current_timestamp
-- current_timestamp is equivalent to now(), both return the current date and time. 
-- add or subtract interval to current_timestamp to get the date and time in the future or past
SELECT product_name, CURRENT_TIMESTAMP + INTERVAL '1 day' AS next_day

-- NOW() - returns the current date and time
SELECT product_name, NOW() AS current_date_time
-- current_date_time is equivalent to current_timestamp, both return the current date and time.
-- add or subtract interval to current_date_time to get the date and time in the future or past
SELECT product_name, NOW() + INTERVAL '1 hour' AS next_hour
SELECT product_name, NOW() - INTERVAL '1 day' AS previous_day

-- DATE_ADD() - adds a specified time interval to a date or time value
SELECT product_name, DATE_ADD(sales_date, INTERVAL 1 DAY) AS next_day
SELECT DATEADD(month, 1, '2024-05-27') AS new_date; -- get 2024-06-27
SELECT DATEADD(hour, -2, '2024-05-27 10:00:00') AS new_datetime; -- get 2024-05-27 08:00:00
-- DATEADD() Equivalent to DATE_ADD() in MySQL, equivalent to INTERVAL in PostgreSQL

-- DATE_DIFF() - calculates the difference between two date or time values
SELECT product_name, DATE_DIFF('2024-01-01', sales_date) AS days_since_sale

-- DATE_TRUNC() - truncates a date or time value to a specified level of precision
-- below code gets the first day of the month for each sale
SELECT product_name, DATE_TRUNC('month', sales_date) AS first_day_of_month

SELECT DATE_TRUNC('month', '2024-05-27 10:15:30'::timestamp) AS truncated_date; -- get 2024-05-01 00:00:00, truncate the timestamp '2024-05-27 10:15:30' to the start of the month

-- DATE_FORMAT() - formats a date or time value
SELECT product_name, DATE_FORMAT(sales_date, 'YYYY-MM-DD') AS formatted_sales_date
SELECT DATE_FORMAT('2024-05-27 10:15:30', '%Y-%m-%d %H:%i:%s') AS formatted_date; -- get 2024-05-27 10:15:30

-- STR_TO_DATE() - converts a string to a date or time value using a specified format
SELECT product_name, STR_TO_DATE('2024-01-01', 'YYYY-MM-DD') AS formatted_date

-- TIMESTAMPDIFF() - calculates the difference between two date or time values
SELECT product_name, TIMESTAMPDIFF(DAY, '2024-01-01', sales_date) AS days_since_sale

-- TIMESTAMPADD() - adds a specified time interval to a date or time value
SELECT product_name, TIMESTAMPADD(DAY, 1, sales_date) AS next_day

-- darefromparts - create a date from year, month, and day
SELECT DATEFROMPARTS(2024, 5, 27) AS new_date; -- get 2024-05-27

-- datename - get the name of the month, day, or weekday from a date
SELECT DATENAME(month, '2024-05-27') AS month_name; -- get May

-- datepart - get the part of a date, such as the year, month, day, or weekday, similar to EXTRACT() and DATE_PART()
SELECT DATEPART(year, '2024-05-27') AS year; -- get 2024

-- DAY() - extracts the day of the month from a date or time value
SELECT product_name, DAY(sales_date) AS day_of_month

-- MONTH() - extracts the month from a date or time value
SELECT product_name, MONTH(sales_date) AS month -- same as EXTRACT(MONTH FROM sales_date)

-- YEAR() - extracts the year from a date or time value
SELECT product_name, YEAR(sales_date) AS year

-- GETDATE() - returns the current date and time
SELECT product_name, GETDATE() AS current_date_time

-- GETUTCDATE() - returns the current UTC date and time
SELECT product_name, GETUTCDATE() AS current_utc_date_time

-- SYSDATETIME() - returns the current date and time
SELECT product_name, SYSDATETIME() AS current_date_time

-----------------Subquery-----------------
-- Subquery - query within another query
-- Subquery - can be used with SELECT, INSERT, UPDATE, DELETE statements
-- Can't use IS as  IS operator is used for comparing a value with NULL/ NOT NULL
-- use subquery when results can't be directly obtained from the main query

-- create new table for outer query
SELECT employee_id, total_sales
FROM (
    SELECT employee_id, SUM(sale_amount) AS total_sales
    FROM sales
    GROUP BY employee_id
) AS SalesSubquery
WHERE total_sales > 10000;

-- single value subquery
SELECT column_name(s)
FROM table_name
WHERE column_name = (SELECT column_name FROM table_name WHERE condition);

-- multiple value subquery
SELECT column_name(s) 
FROM table_name 
WHERE column_name IN (SELECT column_name(s) FROM table_name WHERE condition);

-- subquery within select, independent subquery from the main query
SELECT column_name, (SELECT column_name FROM table_name WHERE condition) AS subquery_column

-- subquery directly used in join
SELECT column_name(s)
FROM table1
JOIN (SELECT column_name(s) FROM table2 WHERE condition) AS subquery_table
ON table1.column_name = subquery_table.column_name;


-- common table expression (CTE) - temporary result set that can be referenced within a SELECT, INSERT, UPDATE, or DELETE statement
WITH cte_name AS (
  SELECT column_name(s)
  FROM table_name
  WHERE condition
)
SELECT column_name(s)
FROM cte_name;

-- multiple CTEs
WITH cte1 AS (
  SELECT column_name(s)
  FROM table_name
  WHERE condition
),
cte2 AS (
  SELECT column_name(s)
  FROM cte1
  WHERE condition
)
SELECT column_name(s)
FROM cte2;

-- recursive CTE
WITH RECURSIVE cte_name AS (
  SELECT column_name(s)
  FROM table_name
  WHERE condition
UNION ALL
  SELECT column_name(s)
  FROM cte_name
  WHERE condition
)
SELECT column_name(s)
FROM cte_name;

-- string manipulation
-- CONCAT() - concatenate two or more strings
SELECT CONCAT(first_name, ' ', last_name) AS full_name -- combine first_name and last_name into a single column

-- || - concatenate two or more strings
SELECT first_name || ' ' || last_name AS full_name -- combine first_name and last_name into a single column

-- CONCAT_WS(), used to concatenate multiple strings with a separator
SELECT CONCAT_WS(' ', first_name, last_name) AS full_name -- combine first_name and last_name into a single column separated by a space

-- CONCAT with + - concatenate two or more strings
SELECT first_name + ' ' + last_name AS full_name -- combine first_name and last_name into a single column

-- group_concat, used to concatenate multiple values into a single string
SELECT product_category, GROUP_CONCAT(product_name) AS products -- put all product names into one row
FROM products

SELECT product_category, GROUP_CONCAT(product_name ORDER BY product_name DESC SEPARATOR ', ') AS products -- order by product name in descending order and separate by comma, put all into one row

-- concat vs group_concat: CONCAT() is used to concatenate two or more strings into a single string, while GROUP_CONCAT() is used to concatenate multiple values into a single string

-- substring(), used to extract a substring from a string
SELECT SUBSTRING(product_name, 1, 3) AS short_name -- get the first 3 characters of the product name, SUBSTRING(product_name, 1, 3) means start from the first character and get 3 characters

-- USE substring to get the last 3 characters of the product name
SELECT SUBSTRING(product_name, LENGTH(product_name) - 2, 3) AS short_name -- get the last 3 characters of the product name

-- or negative index
SELECT SUBSTRING(product_name, -3) AS short_name -- get the last 3 characters of the product name

-- find character in the middle of a variable length string
SELECT SUBSTRING(product_name, LENGTH(product_name) / 2, 1) AS middle_character -- get the middle character of the product name

-- mid(), used to get a specified number of characters from a string starting at a specified position, MID(string, start, length), similar to SUBSTRING()
SELECT MID(product_name, 4, 3) AS short_name -- get 3 characters starting from the 4th character of the product name

-- ucase(), used to convert a string to uppercase
-- ucase() and lcase() are equivalent to upper() and lower() and more efficient

-- left(), used to get a specified number of characters from the left of a string
SELECT LEFT(product_name, 3) AS short_name -- get the first 3 characters of the product name

-- right(), used to get a specified number of characters from the right of a string
SELECT RIGHT(product_name, 3) AS short_name -- get the last 3 characters of the product name

-- replace(), used to replace a substring with another substring
SELECT REPLACE(product_name, 'old_string', 'new_string') AS updated_name -- replace 'old_string' with 'new_string' in the product name

-- trim(), used to remove leading and trailing spaces from a string
SELECT TRIM(product_name) AS trimmed_name -- remove leading and trailing spaces from the product name

-- ltrim(), used to remove leading spaces from a string
SELECT LTRIM(product_name) AS trimmed_name -- remove leading spaces from the product name

-- rtrim(), used to remove trailing spaces from a string
SELECT RTRIM(product_name) AS trimmed_name -- remove trailing spaces from the product name

-- trim() is equivalent to ltrim() and rtrim() combined, but more efficient

-- upper(), used to convert a string to uppercase
SELECT UPPER(product_name) AS upper_name -- convert the product name to uppercase

-- lower(), used to convert a string to lowercase
SELECT LOWER(product_name) AS lower_name -- convert the product name to lowercase

-- length(), used to get the length of a string
SELECT LENGTH(product_name) AS name_length -- get the length of the product name

-- locate(), used to find the position of a substring in a string
-- LOCATE('substring', 'string') - find the position of 'substring' in 'string'
SELECT LOCATE('substring', product_name) AS position -- find the position of 'substring' in the product name
-- LOCATE('substring', 'string', start_position) - find the position of 'substring' in 'string' starting from the specified position
SELECT LOCATE('substring', product_name, 5) AS position -- find the position of 'substring' in the product name starting from the 5th character

-- ASCII(), used to get the ASCII value of a character
SELECT ASCII('A') AS ascii_value -- get the ASCII value of 'A'

-- CHAR(), used to get the character from an ASCII value
SELECT CHAR(65) AS character -- get the character with ASCII value 65

-- CHARINDEX(), used to find the position of a substring in a string
SELECT CHARINDEX('substring', product_name) AS position -- find the position of 'substring' in the product name

-- datalength(), used to get the length of a string in bytes
SELECT DATALENGTH(product_name) AS name_length -- get the length of the product name in bytes

-- difference(), used to compare the difference between two strings
SELECT DIFFERENCE('string1', 'string2') AS difference -- compare the difference between 'string1' and 'string2'

-- format(), used to format a number with a specific format
SELECT FORMAT(123456.789, 'C', 'en-US') AS formatted_number -- format the number 123456.789 as currency in US English

-- len(), used to get the length of a string
SELECT LEN(product_name) AS name_length -- get the length of the product name

-- nchar(), used to get the Unicode character with the specified integer code
SELECT NCHAR(65) AS character -- get the Unicode character with ASCII value 65

-- patindex(), used to find the position of a pattern in a string
SELECT PATINDEX('%substring%', product_name) AS position -- find the position of 'substring' in the product name

-- quote_name(), used to quote an identifier
SELECT QUOTENAME('column_name') AS quoted_name -- quote the column name

-- replicate(), used to repeat a string a specified number of times
SELECT REPLICATE('string', 3) AS repeated_string -- repeat 'string' 3 times

-- reverse(), used to reverse a string
SELECT REVERSE(product_name) AS reversed_name -- reverse the product name

-- soundex(), used to get the soundex value of a string, soundex value is a phonetic algorithm that represents the sound of a word
SELECT SOUNDEX(product_name) AS soundex_value -- get the soundex value of the product name

-- space(), used to insert a specified number of spaces into a string
SELECT SPACE(3) AS spaces -- insert 3 spaces

-- stuff(), used to replace a specified number of characters in a string with another string
SELECT STUFF(product_name, 3, 5, 'new_string') AS updated_name -- replace 5 characters starting from the 3rd character with 'new_string' in the product name

-- translate(), used to replace multiple characters in a string with other characters
SELECT TRANSLATE(product_name, 'abc', '123') AS translated_name -- replace 'a' with '1', 'b' with '2', and 'c' with '3' in the product name

-- unicode(), used to get the Unicode value of the first character in a string
SELECT UNICODE(product_name) AS unicode_value -- get the Unicode value of the first character in the product name


-- create customised category
select 'Low Price' as category, product_name, price from products where price < 100 -- this will create a new column category with value 'Low Price' and the product name and price

-- pivot - rotate rows into columns
-- firstly write a subquery to select the columns to pivot
-- then get value for each column
SELECT product, [Jan], [Feb], [Mar]
FROM ( 
    SELECT month, product, sales
    FROM sales
) AS SourceTable
PIVOT (
    SUM(sales)
    FOR month IN ([Jan], [Feb], [Mar])
) AS PivotTable;


-- foreign key constraint: a field in a table that refers to the PRIMARY KEY in another table, used to link two tables together
-- foreign key constraint ensures the referential integrity of the data between the two tables

-- below table has a foreign key constraint that references the primary key in the Persons table
CREATE TABLE Orders (
    OrderID int NOT NULL,
    OrderNumber int NOT NULL,
    PersonID int,
    PRIMARY KEY (OrderID), -- primary key
    CONSTRAINT FK_PersonOrder FOREIGN KEY (PersonID) 
    REFERENCES Persons(PersonID) -- foreign key, references the primary key in the Persons table
);

-- foreign key constraint with cascade delete 
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    product_id INT,
    FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE CASCADE -- remove the order when the product is deleted
);

-- foreign key constraint with cascade update
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    product_id INT,
    FOREIGN KEY (product_id) REFERENCES products (product_id) ON UPDATE CASCADE -- update the product_id in the order when the product_id in the products table is updated
);

-- foreign key constraint with is null
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    product_id INT,
    FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE SET NULL -- set the product_id in the order to NULL when the product is deleted
);

-- foreign key constraint with no action
create table orders (
    order_id INT PRIMARY KEY,
    product_id INT,
    FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE NO ACTION -- do nothing when the product is deleted
);

-- row increment apart from using row_number()
@row_number:=@row_number+1 AS row_number -- increment row number by 1
-- need to initialize the variable before using it
SET @row_number:=0;

-- below is an example of using row increment that assigns a row number to each name where the occupation is 'Doctor'
SELECT @rownum1 := @rownum1 + 1 AS num1, name AS n1 
FROM occupations, (SELECT @rownum1 := 0) r 
WHERE occupation = 'Doctor' 
ORDER BY name AS t1

-- the above code is equivalent to the following code
SELECT ROW_NUMBER() OVER (ORDER BY name) AS num1, name AS n1
FROM occupations
WHERE occupation = 'Doctor'
ORDER BY name;

-- math functions in SQL
-- +, -, *, / - addition, subtraction, multiplication, division
SELECT 10 + 5 AS sum -- get 15
SELECT 10 - 5 AS difference -- get 5
SELECT 10 * 5 AS product -- get 50
SELECT 10 / 5 AS quotient -- get 2

-- percentage calculation using integer division
-- it's good practice to multiply one of the numbers by 1.0 to get a decimal result
SELECT 1.0 * 10 / 5 AS percentage -- get 2.0

-- or use cast
SELECT CAST(10 AS DECIMAL) / 5 AS percentage -- get 2.0


-- % - modulo operator, returns the remainder of a division operation
SELECT 10 % 3 AS remainder -- get 1

-- find length of a string
SELECT LENGTH('Hello, World!') AS string_length -- get 13

-- ABS() - returns the absolute value of a number
SELECT ABS(-10) AS absolute_value -- get 10

-- CEIL() - returns the smallest integer greater than or equal to a number
SELECT CEIL(10.5) AS ceiling_value -- get 11

-- FLOOR() - returns the largest integer less than or equal to a number
SELECT FLOOR(10.5) AS floor_value -- get 10

-- ROUND() - rounds a number to a specified number of decimal places
SELECT ROUND(10.5) AS rounded_value -- get 11

-- ceiling() - returns the smallest integer greater than or equal to a number
SELECT CEILING(10.5) AS ceiling_value -- get 11

-- SQRT() - returns the square root of a number
SELECT SQRT(16) AS square_root -- get 4

-- POWER() - returns the value of a number raised to the power of another number
SELECT POWER(2, 3) AS power_value -- get 8

-- MOD() - returns the remainder of a division operation
SELECT MOD(10, 3) AS remainder -- get 1

-- RAND() - returns a random number
SELECT RAND() AS random_number -- get a random number between 0 and 1

-- TRUNCATE() - truncates a number to a specified number of decimal places
SELECT TRUNCATE(10.5678, 2) AS truncated_value -- get 10.56

-- PI() - returns the value of pi
SELECT PI() AS pi_value -- get 3.141592653589793

-- E() - returns the value of e
SELECT E() AS e_value -- get 2.718281828459045

-- LOG() - returns the natural logarithm of a number
SELECT LOG(10) AS natural_logarithm -- get 2.302585092994046

-- LOG10() - returns the base-10 logarithm of a number
SELECT LOG10(100) AS base_10_logarithm -- get 2

-- EXP() - returns e raised to the power of a number
SELECT EXP(1) AS exponential_value -- get 2.718281828459045

-- GREATEST() - returns the greatest value in a list of values
SELECT GREATEST(10, 20, 30) AS greatest_value -- get 30

-- LEAST() - returns the smallest value in a list of values
SELECT LEAST(10, 20, 30) AS smallest_value -- get 10

-- SIGN() - returns the sign of a number
SELECT SIGN(-10) AS sign_value -- get -1

-- SIN() - returns the sine of an angle
SELECT SIN(0) AS sine_value -- get 0

-- COS() - returns the cosine of an angle
SELECT COS(0) AS cosine_value -- get 1

-- TAN() - returns the tangent of an angle
SELECT TAN(0) AS tangent_value -- get 0

-- ASIN() - returns the arcsine of a number
SELECT ASIN(0) AS arcsine_value -- get 0

-- ACOS() - returns the arccosine of a number
SELECT ACOS(1) AS arccosine_value -- get 0

-- ATAN() - returns the arctangent of a number
SELECT ATAN(0) AS arctangent_value -- get 0

-- ATAN2() - returns the arctangent of the quotient of two numbers
SELECT ATAN2(0, 1) AS arctangent_value -- get 0

-- DEGREES() - converts radians to degrees
SELECT DEGREES(0) AS degrees_value -- get 0

-- RADIANS() - converts degrees to radians
SELECT RADIANS(0) AS radians_value -- get 0

-- isnumeric() - checks if a value is numeric
SELECT ISNUMERIC('123') AS is_numeric -- get 1

-- regular espression
-- RLIKE - checks if a string matches a regular expression, RLIKE is case-insensitive
SELECT product_name
FROM products
WHERE product_name RLIKE '^A.*'; -- get product names that start with 'A'

-- REGEXP - checks if a string matches a regular expression. Same as RLIKE and case-insensitive, more widely used
SELECT product_name
FROM products
WHERE product_name REGEXP '^A.*'; -- get product names that start with 'A'

-- binary string comparison, case-sensitive
SELECT product_name
FROM products
WHERE product_name = BINARY 'apple'; -- get product names that are exactly 'apple'

-- '.*' - matches any sequence of characters

-- ^ - matches the start of a string
SELECT product_name FROM products WHERE product_name RLIKE '^A.*'; -- get product names that start with 'A'

-- . - matches any character
SELECT product_name FROM products WHERE product_name RLIKE 'A.'; -- get product names that have 'A' followed by any character

-- * - matches zero or more occurrences of the preceding character
SELECT product_name FROM products WHERE product_name RLIKE 'A.*'; -- get product names that have 'A' followed by zero or more characters
-- * is a greedy quantifier, it matches as many characters as possible
SELECT product_name FROM products WHERE product_name RLIKE '[A-Z]*'; -- get product names that have zero or more uppercase letters

-- + - matches one or more occurrences of the preceding character
SELECT product_name FROM products WHERE product_name RLIKE 'A+'; -- get product names that have 'A' followed by one or more characters

-- ? - matches zero or one occurrence of the preceding character
SELECT product_name FROM products WHERE product_name RLIKE 'A?'; -- get product names that have 'A' followed by zero or one character

-- {n} - matches exactly n occurrences of the preceding character
SELECT product_name FROM products WHERE product_name RLIKE 'A{2}'; -- get product names that have 'A' followed by exactly 2 characters

-- {n,} - matches n or more occurrences of the preceding character
SELECT product_name FROM products WHERE product_name RLIKE 'A{2,}'; -- get product names that have 'A' followed by 2 or more characters

-- {n,m} - matches between n and m occurrences of the preceding character
SELECT product_name FROM products WHERE product_name RLIKE 'A{2,4}'; -- get product names that have 'A' followed by between 2 and 4 characters

-- \ - escapes a special character
SELECT product_name FROM products WHERE product_name RLIKE 'A\.'; -- get product names that have 'A.'

-- \\ - used to escape a backslash
-- \\. - matches a period, example: '.' (period)
-- \\@ - matches an at sign, example: '@' (at sign)

-- \d - matches any digit, example: [0-9]
SELECT product_name FROM products WHERE product_name RLIKE '\d'; -- get product names that have any digit

-- \D - matches any non-digit, non-digit means any character that is not a digit
SELECT product_name FROM products WHERE product_name RLIKE '\D'; -- get product names that have any non-digit

-- \w - matches any word character, word character means any letter, digit, or underscore
SELECT product_name FROM products WHERE product_name RLIKE '\w'; -- get product names that have any word character

-- \W - matches any non-word character. non-word character means any character that is not a letter, digit, or underscore, such as whitespace or punctuation
SELECT product_name FROM products WHERE product_name RLIKE '\W'; -- get product names that have any non-word character

-- \s - matches any whitespace character
SELECT product_name FROM products WHERE product_name RLIKE '\s'; -- get product names that have any whitespace character

-- \S - matches any non-whitespace character
SELECT product_name FROM products WHERE product_name RLIKE '\S'; -- get product names that have any non-whitespace character

-- $ - matches the end of a string
SELECT product_name FROM products WHERE product_name RLIKE '.*A$'; -- get product names that end with 'A'

-- [abc] - matches any character within the brackets, letters in brackets are treated as individual characters and case-sensitive
SELECT product_name FROM products WHERE product_name RLIKE 'A[bc]'; -- get product names that have 'A' followed by 'b' or 'c'

-- [a-z] - matches any character in the range from 'a' to 'z'
SELECT product_name FROM products WHERE product_name RLIKE 'A[a-z]'; -- get product names that have 'A' followed by a lowercase letter

-- [^abc] - matches any character not within the brackets
SELECT product_name FROM products WHERE product_name RLIKE 'A[^bc]'; -- get product names that have 'A' followed by a character that is not 'b' or 'c'

-- [^a-z] - matches any character not in the range from 'a' to 'z'
SELECT product_name FROM products WHERE product_name RLIKE 'A[^a-z]'; -- get product names that have 'A' followed by a character that is not a lowercase letter

-- | - matches either the expression before or after the operator
SELECT product_name FROM products WHERE product_name RLIKE 'A|B'; -- get product names that have 'A' or 'B'

-- () - groups expressions together
SELECT product_name FROM products WHERE product_name RLIKE '(A|B)'; -- get product names that have 'A' or 'B'

-- REGEXP_LIKE() - checks if a string matches a regular expression
SELECT product_name
FROM products
WHERE REGEXP_LIKE(product_name, '^A.*'); -- get product names that start with 'A'

-- REGEXP_REPLACE() - replaces a substring that matches a regular expression with another substring
SELECT REGEXP_REPLACE(product_name, 'old_string', 'new_string') AS updated_name -- replace 'old_string' with 'new_string' in the product name
-- e.g. remove all non-word characters from the product name
SELECT REGEXP_REPLACE(product_name, '\W', '') AS updated_name -- remove all non-word characters from the product name

-- REGEXP_INSTR() - returns the position of the first occurrence of a regular expression in a string
SELECT REGEXP_INSTR(product_name, 'substring') AS position -- find the position of 'substring' in the product name

-- e.g. find the position of the first digit in the product name
SELECT REGEXP_INSTR(product_name, '\d') AS position -- find the position of the first digit in the product name

-- REGEXP_SUBSTR() - returns a substring that matches a regular expression
SELECT REGEXP_SUBSTR(product_name, 'substring') AS matched_substring -- find the substring that matches 'substring' in the product name
-- e.g. find the first digit in the product name
SELECT REGEXP_SUBSTR(product_name, '\d') AS matched_substring -- find the first digit in the product name


-- handling different data structures in SQL

-- JSON - JavaScript Object Notation, used to store and exchange data
-- JSON data type - stores JSON data in a column, introduced in MySQL 5.7 and PostgreSQL 9.2
-- read json data
SELECT column_name->'$.key' AS column_name
FROM table_name;

-- read json data in postgresql
SELECT column_name->'key' AS column_name

-- write json data
SELECT JSON_OBJECT('key1', 'value1', 'key2', 'value2') AS column_name;

-- unpack json data
SELECT column_name->'key' AS column_name -- this will create a new column column_name with the value of the key in the JSON data
FROM table_name;

-- unpack json data to rows
SELECT column_name->'key' AS column_name

-- array - a collection of elements, each element can be of a different data type
-- ARRAY - used to store an array in a column, introduced in PostgreSQL 9.3
-- read array data
SELECT column_name[index] AS column_name
FROM table_name;

-- flattern arrays in SQL
-- UNNEST() - used to flatten an array into rows
SELECT UNNEST(array_column) AS column_name
FROM table_name;

-- FLATTEN() - used to flatten an array into rows
SELECT FLATTEN(array_column) AS column_name
FROM table_name;

-- UNPACK() - used to flatten an array into rows
SELECT UNPACK(array_column) AS column_name
FROM table_name;

-- ARRAY_AGG() - used to aggregate values into an array
SELECT column_name, ARRAY_AGG(array_column) AS column_name
FROM table_name

-- XML - Extensible Markup Language, used to store and exchange data
-- XML data type - stores XML data in a column, introduced in SQL Server 2005
-- read xml data
SELECT column_name.value('(/key)[1]', 'data_type') AS column_name
FROM table_name;

-- write xml data
SELECT CAST('<key>value</key>' AS XML) AS column_name;

-- unpack xml data
SELECT column_name.value('(/key)[1]', 'data_type') AS column_name

-- XMLTABLE() - used to flatten XML data into rows
SELECT column_name
FROM XMLTABLE('/key' PASSING column_name COLUMNS column_name data_type) AS table_name;

-- XMLQUERY() - used to flatten XML data into rows
SELECT column_name
FROM XMLQUERY('/key' PASSING column_name RETURNING CONTENT) AS table_name;

-- XMLNAMESPACES() - used to define namespaces in XML data
SELECT column_name
FROM XMLNAMESPACES('namespace' AS alias) SELECT column_name;

-- XMLFOREST() - used to create an XML element from a list of values
SELECT XMLFOREST(column_name AS 'key') AS column_name;

-- XMLCONCAT() - used to concatenate XML elements
SELECT XMLCONCAT(column_name) AS column_name;

-- index - used to improve the performance of queries by reducing the time it takes to retrieve data
-- CREATE INDEX - used to create an index on a table
-- create INDEX I for column ID in table T
CREATE INDEX I ON T (ID);

-- UNIQUE INDEX - used to ensure that all values in a column are unique
CREATE UNIQUE INDEX index_name

-- INDEXES - used to create multiple indexes on a table
CREATE INDEX index_name1, index_name2

-- below code shows how to query table using index. assuming column ID is indexed with index I
-- this will be faster than a normal
SELECT * FROM T WHERE ID = 1; -- we don't need to specify the index name, the database will automatically use the index. We just need to specify the column name and the value to search for.

-- DROP INDEX - used to drop an index from a table
DROP INDEX index_name;

-- convert() - converts a value to a specified data type
SELECT CONVERT(int, 20.45) AS column_name

-- current_user - returns the current user
SELECT current_user AS user_name

-- session_user - returns the current user
SELECT session_user AS user_name

-- user - returns the current user
SELECT user AS user_name

-- sessionproperty() - returns the value of a session property
SELECT sessionproperty('property_name') AS property_value

-- system_user - returns the current user
SELECT system_user AS user_name

-- user_name() - returns the current user
SELECT user_name() AS user_name

