# primary key
# specific choice of a minimal set of attributes (columns) that uniquely specify a tuple (row) in a relation (table).

# foreign key
# foreign key is a field in a table that is primary key in another table        

# build relationship between tables
# The primary purpose of establishing relationships (such as foreign key relationships) is to maintain data integrity.
# When you create a relationship, it enforces rules that ensure consistency between related records in the tables.


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



# cross join - cartesian product of two or more tables, match each row of one table to every other row of another table
# when using with WHERE clause, it acts as INNER JOIN
f'SELECT * FROM table1
CROSS JOIN table2;'



