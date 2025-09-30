-- ============================================================
-- File: mysql_script_with_notes.sql
-- Description: MySQL commands with comments/notes;
-- Author: (Dhruv Doshi)
-- ============================================================

-- Database Management Commands

-- Create a new database
-- Definition: Creates a new database instance named 'new_db'.
-- Purpose: The essential first step to organize tables and data. 'IF NOT EXISTS' prevents an error if the database already exists.
CREATE DATABASE IF NOT EXISTS new_db;

-- Drop a database
-- Definition: Permanently deletes the database named 'new_db' and all data/tables within it.
-- Purpose: Used for cleanup or schema removal. Use with extreme caution.
DROP DATABASE IF EXISTS new_db;

-- Use database
-- Definition: Changes the current default database to 'dhruv' for subsequent operations.
-- Purpose: You must specify which database you want to work within.
USE dhruv;

-- Create Table (Foundational Command)
-- Definition: Creates a new table named 'doshi' with defined columns, data types, and constraints.
-- Purpose: Defines the structure and schema of the data that will be stored.
CREATE TABLE doshi (
    id INT PRIMARY KEY AUTO_INCREMENT, -- PRIMARY KEY: uniquely identifies each row; AUTO_INCREMENT: assigns sequential number on insert
    name VARCHAR(100) NOT NULL,       -- NOT NULL: ensures a value must be provided for the name
    email VARCHAR(100) UNIQUE,        -- UNIQUE: ensures every email is different
    gender ENUM('male', 'female', 'other')
);

-- Show Tables (Utility Command)
-- Purpose: Lists all tables that exist in the currently selected database ('dhruv').
SHOW TABLES;

-- Describe Table (Utility Command)
-- Purpose: Shows the detailed column structure (data types, constraints, keys) of the 'doshi' table.
DESCRIBE doshi;


-- Fetch all columns from table doshi
-- Purpose: Retrieves all columns and all rows from the table 'doshi'.
-- The '*' is a wildcard meaning "all columns".
SELECT * FROM doshi;

-- Select specific columns
SELECT name, email FROM doshi;

-- Rename table
-- Purpose: Changes the name of the existing table 'Doshi' to 'Table1'.
RENAME TABLE Doshi TO Table1;

-- Alter table operations

-- Add a new column salary, integer, not null
ALTER TABLE Table1 ADD salary INT NOT NULL;

-- Drop column salary
ALTER TABLE Table1 DROP COLUMN salary;

-- Modify column salary: set default value
ALTER TABLE Table1 MODIFY COLUMN salary INT DEFAULT 1000000;

-- Move column email to after 'id'
ALTER TABLE Table1 MODIFY COLUMN email VARCHAR(100) AFTER id;

-- Move column email to be the first column
ALTER TABLE Table1 MODIFY COLUMN email VARCHAR(100) FIRST;

-- Add a constraint: age must be > 18
-- Definition: A **CHECK constraint** is a rule that specifies which values are permitted in a column.
ALTER TABLE Table1 ADD age INT CHECK (age > 18);

-- Data Queries (Including missing INSERT command)

-- Insert Data (Foundational Command)
-- Definition: Adds a new row of data into the specified columns of the table.
-- Purpose: The fundamental way to populate a table with records.
INSERT INTO Table1 (name, email, gender, salary, age) VALUES ('Alice', 'alice@example.com', 'female', 1500000, 25);
INSERT INTO Table1 (name, email, gender, salary, age) VALUES ('Bob', 'bob@example.com', 'male', 2200000, 30);


SELECT * FROM Table1;

SELECT name, gender FROM Table1 WHERE gender = "female";

SELECT name, gender FROM Table1 WHERE id IS NOT NULL;

SELECT name, gender FROM Table1 WHERE id IS NULL;

-- Definition: The **BETWEEN** operator selects values within a given inclusive range.
SELECT name, salary FROM Table1 WHERE salary BETWEEN 1500000 AND 2500000;

-- Definition: The **IN** operator allows you to specify multiple values in a WHERE clause.
SELECT id, name, gender FROM Table1 WHERE id IN ("1","25","28");

-- Definition: The **AND** operator combines two conditions.
SELECT id, name FROM Table1 WHERE gender = "female" AND salary > 1000000;

-- Ordering, limiting, offset

-- Purpose: Finds the person with the *second-highest* salary (sorts DESC, skips 1, takes 1).
SELECT id, name FROM Table1 ORDER BY salary DESC LIMIT 1 OFFSET 1;

-- Updating data

SET SQL_SAFE_UPDATES = 0;
UPDATE Table1 SET salary = 3000000 WHERE id > 35;
SET SQL_SAFE_UPDATES = 1;

UPDATE Table1 SET salary = 20000000 WHERE id = 1;

UPDATE Table1 SET salary = salary + 10000 WHERE id > 30;

UPDATE Table1 SET age = 20 WHERE id = 1;

-- Deleting data

-- Definition: **DELETE FROM** removes entire rows from a table.
DELETE FROM Table1 WHERE id > 45;

-- Truncate Table (Important Missing Command)
-- Definition: Removes *all* rows from a table quickly and efficiently, often resetting any AUTO_INCREMENT counters.
-- Purpose: Used to completely empty a table while keeping its structure. It is non-transactional (cannot be ROLLBACKed).
TRUNCATE TABLE Table1;


-- Aggregations

-- Definition: **Aggregate functions** perform a calculation on a set of rows and return a single summary value.
SELECT COUNT(*), AVG(salary) AS avg_salary, MAX(salary) AS max_sal FROM Table1;

-- Transactions

-- Definition: **Transactions** ensure a sequence of operations is treated as a single unit (Atomic).
SET autocommit = 0;

DELETE FROM Table1 WHERE id = 1;
ROLLBACK; -- undo deletion for id = 1

DELETE FROM Table1 WHERE id = 2;
COMMIT; -- make deletion of id=2 permanent

SET autocommit = 1;

SELECT * FROM Table1;

-- Probably invalid table, but selecting to show error / test
SELECT * FROM Table2;

DELETE FROM Table1 WHERE id = 37;

-- Joins

-- Definition: **JOINs** combine rows from two or more tables based on a related column.

-- Definition: **INNER JOIN** returns only matching rows.
SELECT Table1.id, Table1.name,
Table2.address
FROM Table1
INNER JOIN Table2
  ON Table1.id = Table2.user_id;

-- Definition: **LEFT JOIN** returns all rows from the left table and matched rows from the right.
SELECT Table1.id, Table1.name, Table2.address FROM Table1
LEFT JOIN Table2 ON Table1.id = Table2.user_id;

-- Definition: **RIGHT JOIN** returns all rows from the right table and matched rows from the left.
SELECT Table1.id, Table1.name, Table2.address FROM Table1
RIGHT JOIN Table2 ON Table1.id = Table2.user_id;

-- Set operations: UNION and UNION ALL

-- Definition: **UNION** combines results and removes duplicates.
SELECT id FROM Table1
UNION
SELECT user_id FROM Table2;

-- Definition: **UNION ALL** combines results and keeps duplicates (faster).
SELECT id FROM Table1
UNION ALL
SELECT user_id FROM Table2;

-- Self-join example (aliasing)

-- Definition: A **Self-Join** joins a table to itself to find relationships within the same table.
SELECT a.id, a.name, b.name AS referred_name
FROM Table1 a
INNER JOIN Table1 b ON a.ref_id = b.id;

SELECT * FROM Table1;

-- Views

-- Definition: A **View** is a virtual table based on a query result.
CREATE VIEW firstview AS
SELECT id FROM Table1;

SELECT * FROM firstview WHERE id > 25;

-- Indexes

-- Definition: An **Index** speeds up data retrieval.
SHOW INDEXES FROM Table2;

CREATE INDEX inde_11 ON Table2(address);

DROP INDEX inde_11 ON Table2;

-- Subquery example

-- Definition: A **Subquery** is a query nested inside another query.
-- Purpose: Selects people whose salary is greater than the average salary of the whole table.
SELECT id FROM Table1 WHERE salary > (SELECT AVG(salary) FROM Table1);

-- Grouping and HAVING

-- Definition: **GROUP BY** groups rows into summary rows, typically with aggregate functions.
SELECT gender, COUNT(*) FROM Table1 GROUP BY gender;

-- Definition: **HAVING** filters the groups created by GROUP BY (WHERE filters individual rows).
SELECT gender, COUNT(*) FROM Table1 WHERE id > 2 GROUP BY gender HAVING AVG(salary) > 4000000;

SELECT gender, COUNT(*) FROM Table1 GROUP BY gender HAVING AVG(salary) > 4000000;

-- Stored procedure

-- Definition: A **Stored Procedure** is a precompiled set of SQL statements stored in the database.
DELIMITER $$
CREATE PROCEDURE proce(IN inid INT)
BEGIN
SELECT * FROM Table1 WHERE id = inid;
END $$
DELIMITER ;

CALL proce(1);

DROP PROCEDURE proce;

-- Trigger example: after insert

-- Definition: A **Trigger** is code that automatically executes in response to certain events (INSERT, UPDATE, DELETE).
DELIMITER $$
CREATE TRIGGER trig
AFTER INSERT ON Table1
FOR EACH ROW
BEGIN
-- **NEW.id** refers to the value of the 'id' column in the row that was just inserted.
INSERT INTO Table2(user_id, address) VALUES (NEW.id, "bkasbdsk");
END $$
DELIMITER ;

-- Insert to test trigger
INSERT INTO Table1(name, gender, salary, age, ref_id)
VALUES ("samir", "male", 40000, 21, 32);

ALTER TABLE Table2
MODIFY COLUMN address VARCHAR(100) DEFAULT 'kbdsf';

SELECT * FROM Table2;

-- ============================================================
-- Notes / Topics you might want to add in future (not yet covered)
-- ============================================================
