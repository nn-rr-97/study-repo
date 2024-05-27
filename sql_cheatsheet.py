# case sensitive
# keywords and commands are case-insensitive
# data and operators can be case-sensitive
f'SELECT * FROM users WHERE username LIKE 'alice';' # case-sensitive or not depends on the collation of the database
f'SELECT * FROM users WHERE BINARY username LIKE 'alice';' # case-sensitive

# limit - limit the number of rows returned by a query
f'SELECT * FROM table_name LIMIT 5;' # returns the first 5 rows from the table

# offset - skip a specified number of rows before returning the result set
f'SELECT * FROM table_name LIMIT 5 OFFSET 5;' # returns rows 6 to 10

# Handling NUll

#IFNULL(expression, replacement)- return an alternative value if an expression is NULL
f'''SELECT ProductName, UnitPrice * (UnitsInStock + IFNULL(UnitsOnOrder, 0))
FROM Products;'''

#NVL(expression, replacement) - Replaces a NULL value with a specified replacement value (support in Oracle)
f'SELECT NVL(column_name, 'default_value') FROM table_name;' # Replaces NULL values in a column with a specified value.

#COALESCE(expression1, expression2, ..., expressionN) - returns the first non-NULL expression among its arguments
f'SELECT COALESCE(column1, column2, 'default_value') FROM table_name;' # Returns the first non-NULL expression from a list of expressions.


#NULLIF(expression1, expression2) - Returns NULL if expression1 equals expression2; otherwise, it returns expression1
f'SELECT NULLIF(column1, column2) FROM table_name;' #If column1 equals column2, the result is NULL. Otherwise, it returns the value of column1.


# primary key
# unique identifier for each table row

# foreign key
#  a key used to link two tables together, it is a field in a table that refers to the PRIMARY KEY in another table    

# build relationship between tables
# The primary purpose of establishing relationships (such as foreign key relationships) is to maintain data integrity.
# When you create a relationship, it enforces rules that ensure consistency between related records in the tables.


# Filters
# the WHERE clause filters individual tuples before they are grouped via GROUP BY
#the HAVING clause filters whole groups after they have been formed with GROUP BY

# orders
f'''SELECT product_category, SUM(sales_amount) AS total_sales
FROM sales
WHERE sales_date > '2024-01-01'
GROUP BY product_category
HAVING SUM(sales_amount) > 10000
ORDER BY total_sales DESC
LIMIT 10;'''


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

# conditional data aggregation

# filter - straifhtforward condition
f'SUM(amount) FILTER (WHERE condition)' # sum of amount where condition is met

f'''SELECT
    product_id,
    SUM(amount) AS total_sales_amount,
    SUM(amount) FILTER (WHERE sale_date > '2024-01-01') AS sales_amount_after_january
FROM
    sales
GROUP BY
    product_id;
'''


# CASE - to create a new column based on a condition, more complex conditional logic

f'''SELECT
    product_id,
    SUM(amount) AS total_sales_amount,
    SUM(CASE WHEN sale_date > '2024-01-01' THEN amount ELSE 0 END) AS sales_amount_after_january
FROM
    sales
GROUP BY
    product_id;
'''


# CASE - multiple conditions
f'''SUM(CASE WHEN condition1 THEN value1
         WHEN condition2 THEN value2
         ELSE 0 END)
'''

# CASE - with aggregate functions
f'''SELECT uosCode, uosName, COUNT(*) AS numStudents,
       CASE WHEN COUNT(*) > 100 THEN 'Large' ELSE 'Small' END AS classSize
  FROM Enrolment
 GROUP BY uosCode, uosName;'''


# select into - create a new table from an existing table
# copies only the German customers into a new table
f'''SELECT * INTO CustomersGermany
FROM Customers
WHERE Country = 'Germany';'''


# insert into - add new rows to a table
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
# use it when you want to return all rows from both tables
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

# UNION - combine the result set of two or more SELECT statements
# UNION - removes duplicate rows
f'SELECT column_name(s)
FROM table1
UNION
SELECT column_name(s)
FROM table2;'

# UNION ALL - does not remove duplicate rows
f'SELECT column_name(s)
FROM table1
UNION ALL
SELECT column_name(s)
FROM table2;'

# EXISTS - to check for the existence of rows in a subquery, returns TRUE if the subquery returns one or more rows
f'''SELECT SupplierName
FROM Suppliers
WHERE EXISTS (SELECT ProductName FROM Products WHERE Products.SupplierID = Suppliers.supplierID AND Price < 20); # returns TRUE and lists the suppliers with a product price less than 20
'''

# NOT EXISTS - to check for the non-existence of rows in a subquery, returns TRUE if the subquery returns no rows

# ANY - to compare a value to any value in a list or returned by a subquery
# finds ANY records in the OrderDetails table has Quantity equal to 10
f'''SELECT ProductName
FROM Products
WHERE ProductID = ANY
  (SELECT ProductID
  FROM OrderDetails
  WHERE Quantity = 10);'''

# ALL - to compare a value to every value in a list or returned by a subquery
# lists the ProductName if ALL the records in the OrderDetails table has Quantity equal to 10, otherwise return false
f'''SELECT ProductName
FROM Products
WHERE ProductID = ALL
  (SELECT ProductID
  FROM OrderDetails
  WHERE Quantity = 10);'''

# Window Functions

# ROW_NUMBER() - assigns a unique sequential integer to each row within a partition of a result set
f'SELECT product_category, sales_amount,
       ROW_NUMBER() OVER (PARTITION BY product_category ORDER BY sales_amount DESC) AS rank
  FROM sales;'

# # RANK() - assigns a unique integer to each distinct row within the partition of a result set, skipping the next integer if there is a tie
f'SELECT product_category, sales_amount,
       RANK() OVER (PARTITION BY product_category ORDER BY sales_amount DESC) AS rank
  FROM sales;'

# DENSE_RANK() - assigns a unique integer to each distinct row within the partition of a result set, without gaps
f'SELECT product_category, sales_amount,
       DENSE_RANK() OVER (PARTITION BY product_category ORDER BY sales_amount DESC) AS rank
  FROM sales;'

# NTILE() - divides an ordered set of rows into a specified number of approximately equal groups
f'SELECT product_category, sales_amount,
       NTILE(4) OVER (PARTITION BY product_category ORDER BY sales_amount DESC) AS quartile
  FROM sales;'

# LAG(amount,1) - accesses data from a previous row in the same result set without the use of a self-join
f'SELECT product_category, sales_amount,
       LAG(sales_amount, 1) OVER (PARTITION BY product_category ORDER BY sales_amount) AS prev_sales_amount
  FROM sales;'

# LEAD() - accesses data from a subsequent row in the same result set without the use of a self-join
f'SELECT product_category, sales_amount,
       LEAD(sales_amount, 1) OVER (PARTITION BY product_category ORDER BY sales_amount) AS next_sales_amount
  FROM sales;'

# FIRST_VALUE() - returns the first value in an ordered set of values
f'SELECT product_category, sales_amount,
       FIRST_VALUE(sales_amount) OVER (PARTITION BY product_category ORDER BY sales_amount) AS first_sales_amount
  FROM sales;'

# LAST_VALUE() - returns the last value in an ordered set of values
f'SELECT product_category, sales_amount,
       LAST_VALUE(sales_amount) OVER (PARTITION BY product_category ORDER BY sales_amount) AS last_sales_amount
  FROM sales;'

# PERCENT_RANK() - calculates the relative rank of a value in a group of values, e.g. 0.33 means the value is greater than 33% of the values in the group
f'SELECT product_category, sales_amount,
       PERCENT_RANK() OVER (PARTITION BY product_category ORDER BY sales_amount) AS percent_rank
  FROM sales;'

# CUME_DIST() - calculates the cumulative distribution of a value in a group of values, It represents the proportion of rows with values less than or equal to the current row's value
f'SELECT product_category, sales_amount,
       CUME_DIST() OVER (PARTITION BY product_category ORDER BY sales_amount) AS cume_dist
  FROM sales;'

# PERCENTILE_CONT() - calculates the value that corresponds to a specified percentile in a group of values
f'SELECT product_category, sales_amount,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sales_amount) OVER (PARTITION BY product_category) AS median_sales_amount
  FROM sales;'

# PERCENTILE_DISC() - calculates the value that corresponds to a specified percentile in a group of values
f'SELECT product_category, sales_amount,
       PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY sales_amount) OVER (PARTITION BY product_category) AS median_sales_amount
  FROM sales;'

# aggregate functions with window functions - get running aggregates
f'SELECT product_category, sales_amount,
       SUM(sales_amount) OVER (PARTITION BY product_category ORDER BY sales_date) AS running_total
  FROM sales;' # running total of sales_amount within each product_category

# avg - moving average of a specified number of previous rows.
# count - cumulative count of rows up to the current row.
# max - maximum value of a specified number of previous rows.
# min - minimum value of a specified number of previous rows.


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
# year, month, day, hour, minute, second, week, quarter
f'SELECT product_name, EXTRACT(YEAR FROM sales_date) AS sales_year

# DATE_PART() - extracts parts of a date or time value
# year, month, day, hour, minute, second, week, quarter
f'SELECT product_name, DATE_PART('year', sales_date) AS sales_year

# TO_CHAR() - converts a date or time value to a string
f'SELECT product_name, TO_CHAR(sales_date, 'YYYY-MM-DD') AS formatted_sales_date

# TO_DATE() - converts a string to a date or time value
f'SELECT product_name, TO_DATE('2024-01-01', 'YYYY-MM-DD') AS formatted_date

# INTERVAL - represents a period of time
f'SELECT DATE_ADD('2024-05-27', INTERVAL 1 MONTH) AS new_date;' # get 2024-06-27
f'SELECT DATE_SUB('2024-05-27 10:00:00', INTERVAL 2 HOUR) AS new_datetime;' # get 2024-05-27 08:00:00

# CURRENT_DATE - returns the current date
f'SELECT product_name, CURRENT_DATE AS current_date'

# CURRENT_TIME - returns the current time
f'SELECT product_name, CURRENT_TIME AS current_time'

# CURRENT_TIMESTAMP - returns the current date and time
f'SELECT product_name, CURRENT_TIMESTAMP AS current_timestamp'

# NOW() - returns the current date and time
f'SELECT product_name, NOW() AS current_date_time'

# DATE_ADD() - adds a specified time interval to a date or time value
f'SELECT product_name, DATE_ADD(sales_date, INTERVAL 1 DAY) AS next_day'
f'SELECT DATEADD(month, 1, '2024-05-27') AS new_date;' # get 2024-06-27
f'SELECT DATEADD(hour, -2, '2024-05-27 10:00:00') AS new_datetime;' # get 2024-05-27 08:00:00


# DATE_DIFF() - calculates the difference between two date or time values
f'SELECT product_name, DATE_DIFF('2024-01-01', sales_date) AS days_since_sale'

# DATE_TRUNC() - truncates a date or time value to a specified level of precision
f'SELECT product_name, DATE_TRUNC('month', sales_date) AS first_day_of_month'

f'''SELECT DATE_TRUNC('month', '2024-05-27 10:15:30'::timestamp) AS truncated_date;''' # get 2024-05-01 00:00:00, truncate the timestamp '2024-05-27 10:15:30' to the start of the month

# DATE_FORMAT() - formats a date or time value
f'SELECT product_name, DATE_FORMAT(sales_date, 'YYYY-MM-DD') AS formatted_sales_date'
f'SELECT DATE_FORMAT('2024-05-27 10:15:30', '%Y-%m-%d %H:%i:%s') AS formatted_date;' # get 2024-05-27 10:15:30

# STR_TO_DATE() - converts a string to a date or time value using a specified format
f'SELECT product_name, STR_TO_DATE('2024-01-01', 'YYYY-MM-DD') AS formatted_date'

# TIMESTAMPDIFF() - calculates the difference between two date or time values
f'SELECT product_name, TIMESTAMPDIFF(DAY, '2024-01-01', sales_date) AS days_since_sale'


# TIMESTAMPADD() - adds a specified time interval to a date or time value
f'SELECT product_name, TIMESTAMPADD(DAY, 1, sales_date) AS next_day'

# TIMESTAMPDIFF() - calculates the difference between two date or time values
f'SELECT product_name, TIMESTAMPDIFF(DAY, '2024-01-01', sales_date) AS days_since_sale'


# -----------------Subquery-----------------
# Subquery - query within another query
# Subquery - can be used with SELECT, INSERT, UPDATE, DELETE statements
# Can't use IS as  IS operator is used for comparing a value with NULL/ NOT NULL

# create new table for outer query
f'SELECT employee_id, total_sales
FROM (
    SELECT employee_id, SUM(sale_amount) AS total_sales
    FROM sales
    GROUP BY employee_id
) AS SalesSubquery
WHERE total_sales > 10000;'

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
f'''WITH RECURSIVE EmployeeHierarchy AS (
    -- Anchor member: select the root of the hierarchy
    SELECT employee_id, name, manager_id, 1 AS level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive member: select employees reporting to the ones already selected
    SELECT e.employee_id, e.name, e.manager_id, eh.level + 1 # level + 1 for each recursive call, which is to find group of employees reporting to the ones already selected/same manager
    FROM employees e
    INNER JOIN EmployeeHierarchy eh ON e.manager_id = eh.employee_id
)
SELECT *
FROM EmployeeHierarchy;'''

