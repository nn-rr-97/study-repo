# primary key
# specific choice of a minimal set of attributes (columns) that uniquely specify a tuple (row) in a relation (table).

# foreign key
# foreign key is a field in a table that is primary key in another table        

# build relationship between tables
# The primary purpose of establishing relationships (such as foreign key relationships) is to maintain data integrity.
# When you create a relationship, it enforces rules that ensure consistency between related records in the tables.


# INSERT
INSERT INTO table_name (column1, column2, column3, ...)
VALUES (value1, value2, value3, ...);

INSERT INTO table_name
SELECT column1, column2, column3, ...
FROM another_table_name
WHERE condition;

