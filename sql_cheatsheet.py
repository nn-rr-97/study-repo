# handling NULL??

# primary key
# specific choice of a minimal set of attributes (columns) that uniquely specify a tuple (row) in a relation (table).

# foreign key
# foreign key is a field in a table that is primary key in another table        

# build relationship between tables
# The primary purpose of establishing relationships (such as foreign key relationships) is to maintain data integrity.
# When you create a relationship, it enforces rules that ensure consistency between related records in the tables.


# Filters
# the WHERE clause filters individual tuples before they are grouped via GROUP BY
#the HAVING clause filters whole groups after they have been formed with GROUP BY

f'  SELECT <result_list>
    FROM <relation(s)>
   WHERE <per_tuple_condition>
GROUP BY <list_of_attributes>
  HAVING <per_group_condition>'

# not equal
<> or !=

or NOT


# Pattern Matching
# LIKE - case-sensitive by default
# % as placeholders representing any sequence of zero or more characters.
f'SELECT uosCode, uosName
  FROM UnitOfStudy
 WHERE uosName LIKE '%Database%';'

# Similar to
f'SELECT uosCode, uosName
  FROM UnitOfStudy
 WHERE uosName SIMILAR TO '(Advanced|Data)%';' # start with Advanced or Data

f'SELECT uosCode, uosName
  FROM UnitOfStudy
 WHERE uosCode SIMILAR TO 'COMP[[:digit:]]{4}';' # start with COMP followed by 4 digits

# Regular Expression
# ~ operator
f'SELECT uosCode, uosName
  FROM UnitOfStudy
 WHERE uosName ~ '^[A-D].*';' # start with A to D


# IN - to match multiple values, allowing the specification of multiple values for a condition
f'SELECT uosCode, uosName
  FROM UnitOfStudy
 WHERE uosCode IN ('COMP5111', 'COMP5318', 'COMP5319');'

# Handling cases
# UPPER() function to convert to uppercase
# LOWER() function to convert to lowercase
f'SELECT uosCode, uosName
  FROM UnitOfStudy
 WHERE UPPER(uosName) LIKE '%DATABASE%';'

# _ as placeholder to match exact characters, e.g. 3 single characters below
f'SELECT uosCode, uosName
  FROM UnitOfStudy
 WHERE uosCode LIKE 'INFO1___';'


# GROUP BY
# USE group by when need to aggregate data across multiple rows that share a common value
# Aggregate functions like SUM(), AVG(), COUNT(), MIN(), MAX() often require GROUP BY to specify the grouping columns.
# all columns in the SELECT statement that are not used within an aggregate function must be included in the GROUP BY clause.

# CASE - to create a new column based on a condition
f'SELECT uosCode, uosName,
       CASE
         WHEN uosCreditPoints > 6 THEN 'Advanced'
         ELSE 'Basic'
       END AS uosLevel
  FROM UnitOfStudy;'

# CASE - multiple conditions
f'SELECT uosCode, uosName,
       CASE
         WHEN uosCreditPoints > 6 THEN 'Advanced'
         WHEN uosCreditPoints > 3 THEN 'Intermediate'
         ELSE 'Basic'
       END AS uosLevel
  FROM UnitOfStudy;'

# CASE - with aggregate functions
f'SELECT uosCode, uosName,
       COUNT(*) AS numStudents,
       CASE
         WHEN COUNT(*) > 100 THEN 'Large'
         ELSE 'Small'
       END AS classSize
  FROM Enrolment
 GROUP BY uosCode, uosName;'



# INSERT - with specific values
f'INSERT INTO table_name (column1, column2, column3, ...)
VALUES (value1, value2, value3, ...);
'
#INSERT - with multiple specific values
f'INSERT INTO table_name (column1, column2, ...)
VALUES (value1, value2, ...), (value1, value2, ...), ...;
'

# INSERT - with values from another table
f'INSERT INTO table_name
SELECT column1, column2, column3, ...
FROM another_table_name
WHERE condition;'

# INSERT - with no duplicates
f"INSERT INTO table_B (column1, column2, ...)
SELECT column1, column2, ...
FROM table_A
WHERE table_A.unique_key NOT IN (SELECT unique_key FROM table_B);"


f"INSERT INTO table_B (column1, column2, ...)
SELECT column1, column2, ...
FROM table_A
WHERE NOT EXISTS (SELECT 1 FROM table_B WHERE table_B.unique_key = table_A.unique_key);"

f"INSERT INTO table_B (column1, column2, ...)
SELECT DISTINCT column1, column2, ...
FROM table_A
WHERE NOT EXISTS (SELECT 1 FROM table_B WHERE table_B.unique_key = table_A.unique_key);
"

# update
f"UPDATE Customers
SET ContactName = 'Alfred Schmidt', City = 'Frankfurt'
WHERE CustomerID = 1;"


# delete
f'DELETE FROM table_name
WHERE condition;'

# ----------------JOIN----------------
# INNER JOIN - returns rows when there is at least one match in both tables (From..Join,,)
f'SELECT column_name(s)
FROM table1
INNER JOIN table2
ON table1.column_name = table2.column_name;'
# INNER JOIN - with multiple conditions
f'SELECT column_name(s)
FROM table1
INNER JOIN table2
ON table1.column_name1 = table2.column_name1
AND table1.column_name2 = table2.column_name2;'
# INNER JOIN - with multiple tables
f'SELECT column_name(s)
FROM table1
INNER JOIN table2
ON table1.column_name = table2.column_name
INNER JOIN table3
ON table1.column_name = table3.column_name;'
# INNER JOIN - with WHERE clause
f'SELECT column_name(s)
FROM table1
INNER JOIN table2
ON table1.column_name = table2.column_name
WHERE condition;'
# INNER JOIN - with GROUP BY
f'SELECT column_name(s)
FROM table1
INNER JOIN table2
ON table1.column_name = table2.column_name
GROUP BY column_name;'
# INNER JOIN - with ORDER BY
f'SELECT column_name(s)
FROM table1
INNER JOIN table2
ON table1.column_name = table2.column_name
ORDER BY column_name;'
# INNER JOIN - with LIMIT
f'SELECT column_name(s)
FROM table1
INNER JOIN table2
ON table1.column_name = table2.column_name
LIMIT 5;'

# LEFT JOIN (or LEFT OUTER JOIN) - returns all rows from the left table, and the matched rows from the right table
f'SELECT column_name(s)
FROM table1
LEFT JOIN table2
ON table1.column_name = table2.column_name;'

# RIGHT JOIN (or RIGHT OUTER JOIN) - returns all rows from the right table, and the matched rows from the left table
f'SELECT column_name(s)
FROM table1
RIGHT JOIN table2
ON table1.column_name = table2.column_name;'
# FULL JOIN (or FULL OUTER JOIN) - returns rows when there is a match in one of the tables
f'SELECT column_name(s)
FROM table1
FULL JOIN table2
ON table1.column_name = table2.column_name;'
# SELF JOIN - join a table to itself
f'SELECT column_name(s)
FROM table1 T1, table1 T2
WHERE condition;'


# cross join - cartesian product of two or more tables, match each row of one table to every other row of another table
# when using with WHERE clause, it acts as INNER JOIN
f'SELECT * FROM table1
CROSS JOIN table2;'


# Create view
f'CREATE VIEW view_name AS
SELECT column1, column2, ...
FROM table_name
WHERE condition;'
# view can be used like a table
f'SELECT * FROM view_name;'
# drop view
f'DROP VIEW view_name;'
# update view
f'CREATE OR REPLACE VIEW view_name AS
SELECT column1, column2, ...
FROM table_name
WHERE condition;'
# view with JOIN
f'CREATE VIEW view_name AS
SELECT column1, column2, ...
FROM table1
JOIN table2
ON table1.column_name = table2.column_name;'
# view with GROUP BY
f'CREATE VIEW view_name AS
SELECT column1, COUNT(column2) AS count_column2
FROM table_name
GROUP BY column1;'
# view with ORDER BY
f'CREATE VIEW view_name AS
SELECT column1, column2
FROM table_name
ORDER BY column1;'
# view with LIMIT
f'CREATE VIEW view_name AS
SELECT column1, column2
FROM table_name
LIMIT 5;'
# view with OFFSET
f'CREATE VIEW view_name AS
SELECT column1, column2
FROM table_name
OFFSET 5;'
# view with FETCH
f'CREATE VIEW view_name AS
SELECT column1, column2
FROM table_name
FETCH FIRST 5 ROWS ONLY;'
# view with FETCH
f'CREATE VIEW view_name AS
SELECT column1, column2
FROM table_name
FETCH NEXT 5 ROWS ONLY;'


# orders
f'SELECT product_category, SUM(sales_amount) AS total_sales
FROM sales
WHERE sales_date > '2024-01-01'
GROUP BY product_category
HAVING SUM(sales_amount) > 10000
ORDER BY total_sales DESC
LIMIT 10;'

# Ranking
# ROW_NUMBER() - assigns a unique sequential integer to each row within a partition of a result set
# RANK() - assigns a unique integer to each distinct row within the partition of a result set
# DENSE_RANK() - assigns a unique integer to each distinct row within the partition of a result set, without gaps
# NTILE() - divides an ordered set of rows into a specified number of approximately equal groups
# LAG() - accesses data from a previous row in the same result set without the use of a self-join

# ROW_NUMBER()
f'SELECT product_category, sales_amount,
       ROW_NUMBER() OVER (PARTITION BY product_category ORDER BY sales_amount DESC) AS rank
  FROM sales;'
# RANK()
f'SELECT product_category, sales_amount,
       RANK() OVER (PARTITION BY product_category ORDER BY sales_amount DESC) AS rank
  FROM sales;'
# DENSE_RANK()
f'SELECT product_category, sales_amount,
       DENSE_RANK() OVER (PARTITION BY product_category ORDER BY sales_amount DESC) AS rank
  FROM sales;'
# NTILE()
f'SELECT product_category, sales_amount,
       NTILE(4) OVER (PARTITION BY product_category ORDER BY sales_amount DESC) AS quartile
  FROM sales;'
# LAG()
f'SELECT product_category, sales_amount,
       LAG(sales_amount, 1) OVER (PARTITION BY product_category ORDER BY sales_amount) AS prev_sales_amount
  FROM sales;'
# LEAD()
f'SELECT product_category, sales_amount,
       LEAD(sales_amount, 1) OVER (PARTITION BY product_category ORDER BY sales_amount) AS next_sales_amount
  FROM sales;'
# FIRST_VALUE()
f'SELECT product_category, sales_amount,
       FIRST_VALUE(sales_amount) OVER (PARTITION BY product_category ORDER BY sales_amount) AS first_sales_amount
  FROM sales;'
# LAST_VALUE()
f'SELECT product_category, sales_amount,
       LAST_VALUE(sales_amount) OVER (PARTITION BY product_category ORDER BY sales_amount) AS last_sales_amount
  FROM sales;'
# PERCENT_RANK()
f'SELECT product_category, sales_amount,
       PERCENT_RANK() OVER (PARTITION BY product_category ORDER BY sales_amount) AS percent_rank
  FROM sales;'
# CUME_DIST()
f'SELECT product_category, sales_amount,
       CUME_DIST() OVER (PARTITION BY product_category ORDER BY sales_amount) AS cume_dist
  FROM sales;'
# PERCENTILE_CONT()
f'SELECT product_category, sales_amount,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sales_amount) OVER (PARTITION BY product_category) AS median_sales_amount
  FROM sales;'
# PERCENTILE_DISC()
f'SELECT product_category, sales_amount,
       PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY sales_amount) OVER (PARTITION BY product_category) AS median_sales_amount
  FROM sales;'

# round
f'SELECT product_name, ROUND(price, 2) AS rounded_price
FROM products;'

# cast - convert one data type to another
f'SELECT product_name, CAST(price AS INT) AS price_int'
f'SELECT product_name, CAST(price AS DECIMAL(10,2)) AS price_decimal' # decimal with 10 digits and 2 decimal places, DECIMAL(precision, scale)


# handle dates
# DATE - format: 'YYYY-MM-DD'
# TIME - format: 'HH:MM:SS'
# TIMESTAMP - format: 'YYYY-MM-DD HH:MM:SS'
# EXTRACT() - extracts parts of a date or time value
# DATE_PART() - extracts parts of a date or time value
# TO_CHAR() - converts a date or time value to a string
# TO_DATE() - converts a string to a date or time value
# INTERVAL - represents a period of time
# CURRENT_DATE - returns the current date
# CURRENT_TIME - returns the current time
# CURRENT_TIMESTAMP - returns the current date and time
# NOW() - returns the current date and time
# DATE_ADD() - adds a specified time interval to a date or time value
# DATE_SUB() - subtracts a specified time interval from a date or time value
# DATE_DIFF() - calculates the difference between two date or time values
# DATE_TRUNC() - truncates a date or time value to a specified level of precision
# DATE_PART() - extracts parts of a date or time value
# DATE_FORMAT() - formats a date or time value
# STR_TO_DATE() - converts a string to a date or time value
# TIMESTAMPDIFF() - calculates the difference between two date or time values
# TIMESTAMPADD() - adds a specified time interval to a date or time value
# TIMESTAMPDIFF() - calculates the difference between two date or time values
# TIMESTAMPADD() - adds a specified time interval to a date or time value

# EXTRACT()
f'SELECT product_name, EXTRACT(YEAR FROM sales_date) AS sales_year

# DATE_PART()
f'SELECT product_name, DATE_PART('year', sales_date) AS sales_year

# TO_CHAR()
f'SELECT product_name, TO_CHAR(sales_date, 'YYYY-MM-DD') AS formatted_sales_date

# TO_DATE()
f'SELECT product_name, TO_DATE('2024-01-01', 'YYYY-MM-DD') AS formatted_date

# INTERVAL
f'SELECT product_name, sales_date + INTERVAL '1' DAY AS next_day'

# CURRENT_DATE
f'SELECT product_name, CURRENT_DATE AS current_date'

# CURRENT_TIME
f'SELECT product_name, CURRENT_TIME AS current_time'

# CURRENT_TIMESTAMP
f'SELECT product_name, CURRENT_TIMESTAMP AS current_timestamp'

# NOW()
f'SELECT product_name, NOW() AS current_date_time'

# DATE_ADD()
f'SELECT product_name, DATE_ADD(sales_date, INTERVAL 1 DAY) AS next_day'

# DATE_SUB()
f'SELECT product_name, DATE_SUB(sales_date, INTERVAL 1 DAY) AS previous_day'

# DATE_DIFF()
f'SELECT product_name, DATE_DIFF('2024-01-01', sales_date) AS days_since_sale'

# DATE_TRUNC()
f'SELECT product_name, DATE_TRUNC('month', sales_date) AS first_day_of_month'

# DATE_PART()
f'SELECT product_name, DATE_PART('year', sales_date) AS sales_year'

# DATE_FORMAT()
f'SELECT product_name, DATE_FORMAT(sales_date, 'YYYY-MM-DD') AS formatted_sales_date'

# STR_TO_DATE()
f'SELECT product_name, STR_TO_DATE('2024-01-01', 'YYYY-MM-DD') AS formatted_date'

# TIMESTAMPDIFF()
f'SELECT product_name, TIMESTAMPDIFF(DAY, '2024-01-01', sales_date) AS days_since_sale'

# TIMESTAMPADD()
f'SELECT product_name, TIMESTAMPADD(DAY, 1, sales_date) AS next_day'

# TIMESTAMPDIFF()
f'SELECT product_name, TIMESTAMPDIFF(DAY, '2024-01-01', sales_date) AS days_since_sale'

# TIMESTAMPADD()
f'SELECT product_name, TIMESTAMPADD(DAY, 1, sales_date) AS next_day'

# -----------------Subquery-----------------
# Subquery - query within another query
# Subquery - can be used with SELECT, INSERT, UPDATE, DELETE statements
# Can't use IS as  IS operator is used for comparing a value with NULL/ NOT NULL

# single value subquery
f'SELECT column_name(s)
FROM table_name
WHERE column_name = (SELECT column_name FROM table_name WHERE condition);'

# multiple value subquery
f'SELECT column_name(s) 
FROM table_name 
WHERE column_name IN (SELECT column_name(s) FROM table_name WHERE condition);'

# common table expression (CTE) - temporary result set that can be referenced within a SELECT, INSERT, UPDATE, or DELETE statement
f'WITH cte_name AS ('
f'  SELECT column_name(s)'
f'  FROM table_name'
f'  WHERE condition'
f')'
f'SELECT column_name(s)'
f'FROM cte_name;'
# multiple CTEs
f'WITH cte1 AS ('
f'  SELECT column_name(s)'
f'  FROM table_name'
f'  WHERE condition'
f'),'
f'cte2 AS ('
f'  SELECT column_name(s)'
f'  FROM cte1'
f'  WHERE condition'
f')'
f'SELECT column_name(s)'
f'FROM cte2;'
# recursive CTE
f'WITH RECURSIVE cte_name AS ('
f'  SELECT column_name(s)'
f'  FROM table_name'
f'  WHERE condition'
f'UNION ALL'
f'  SELECT column_name(s)'
f'  FROM cte_name'
f'  WHERE condition'
f')'
f'SELECT column_name(s)'
f'FROM cte_name;'
#

