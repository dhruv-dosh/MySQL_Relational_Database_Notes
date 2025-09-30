-- ============================================================
-- File: mysql_script_with_notes.sql
-- Description: Fully comprehensive MySQL script covering DDL, DML, TCL, DCL,
--              and advanced features like Joins, Subqueries, Stored Objects,
--              and Constraints.
-- Author: (Dhruv Doshi)
-- ============================================================

-- ============================================================
-- 1. DATABASE MANAGEMENT (DDL - Data Definition Language)
-- ============================================================

-- Show existing databases
SHOW DATABASES;

-- Create a new database
CREATE DATABASE IF NOT EXISTS dhruv_expanded;

-- Use database
USE dhruv_expanded;

-- Create Table with Advanced Constraints (Foreign Keys, NOT NULL, etc.)
-- Definition: Creates a new table ('departments') and a table ('employees') with an important **FOREIGN KEY** relationship.
-- Purpose: Defines schema and ensures data integrity.
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    salary INT,
    dept_id INT,
    -- 1. Foreign key actions: ON DELETE CASCADE / SET NULL, ON UPDATE
    -- Definition: A **FOREIGN KEY** links this table (child) to another table (parent - departments).
    -- ON DELETE CASCADE: If a row in the parent (departments) is deleted, all dependent rows here are automatically deleted.
    -- ON UPDATE CASCADE: If the PK in the parent is updated, the FK here is automatically updated.
    CONSTRAINT fk_dept
    FOREIGN KEY (dept_id)
    REFERENCES departments(dept_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Creating a second table for demonstration of Full-Text Search
CREATE TABLE articles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    body TEXT,
    -- 7. Full-text indexes and searches
    -- Purpose: Creates an index optimized for rapid text searching using the MATCH() AGAINST() syntax.
    FULLTEXT INDEX idx_fulltext_body (body)
);


-- Utility Commands
SHOW TABLES;
DESCRIBE employees;


-- ============================================================
-- 2. DATA MANIPULATION (DML - Data Manipulation Language)
-- ============================================================

-- Insert data for demonstration
INSERT INTO departments (dept_id, dept_name) VALUES
(10, 'Sales'), (20, 'IT'), (30, 'HR');

INSERT INTO employees (name, salary, dept_id) VALUES
('Alice', 60000, 10), ('Bob', 75000, 20),
('Charlie', 60000, 10), ('Diana', 90000, 20),
('Eve', 75000, 30), ('Frank', 120000, 20);

INSERT INTO articles (title, body) VALUES
('MySQL Basics', 'Learn about SELECT, INSERT, UPDATE, and DELETE commands.'),
('Advanced SQL', 'Correlated subqueries and the powerful EXPLAIN plan.'),
('Triggers and Procedures', 'How to use triggers for auditing and stored procedures for complex logic.');

-- 3. Multiple column ORDER BY; sorting ASC / DESC
-- Definition: Sorts the result set first by 'salary' (descending) and then, for ties, by 'name' (ascending - default).
-- Purpose: Provides precise control over the order of results, especially for pagination or reporting.
SELECT name, salary, dept_id
FROM employees
ORDER BY salary DESC, name ASC;

-- 4. More aggregate functions: SUM, MIN, etc.
-- Purpose: Calculates total payroll, minimum salary, and counts the number of employees.
SELECT
    COUNT(*) AS total_employees,
    SUM(salary) AS total_payroll,  -- Calculates the total sum of salaries
    MIN(salary) AS lowest_salary,  -- Finds the minimum salary
    MAX(salary) AS highest_salary, -- Finds the maximum salary (already shown)
    AVG(salary) AS average_salary
FROM employees;

-- 2. Pattern matching: REGEXP (Regular Expressions)
-- Definition: **REGEXP** (or RLIKE) provides powerful, advanced pattern matching using standard regular expression syntax.
-- Purpose: Finds articles whose body text contains words starting with 't' or 'p'.
SELECT title, body
FROM articles
WHERE body REGEXP '^(t|p)'; -- Matches body starting with 't' or 'p'

-- Example using subqueries
-- Basic Subquery: finds employees whose salary is greater than the average
SELECT name, salary FROM employees WHERE salary > (SELECT AVG(salary) FROM employees);

-- 5. Correlated subqueries; nested subqueries in SELECT, WHERE, FROM
-- Definition: A **Correlated Subquery** is executed once for *every* row processed by the outer query.
-- Purpose: Finds all employees whose salary is higher than the average salary *for their specific department*.
SELECT name, salary, dept_id
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE dept_id = e.dept_id -- The correlation: links the inner query to the outer row (e)
);

-- 7. Full-text indexes and searches
-- Definition: The **MATCH() AGAINST()** clause performs a high-speed search against a FULLTEXT index.
-- Purpose: Finds articles that are most relevant to the term "procedures".
SELECT title, MATCH(body) AGAINST('procedures') AS score
FROM articles
WHERE MATCH(body) AGAINST('procedures');


-- ============================================================
-- 3. UTILITIES AND ADVANCED OPTIMIZATION
-- ============================================================

-- 6. EXPLAIN plan to analyze query performance
-- Definition: **EXPLAIN** provides information about how MySQL executes a query (e.g., table access order, index usage, row scanning).
-- Purpose: Essential for performance tuning; tells you *why* a query might be slow.
EXPLAIN
SELECT name, salary FROM employees WHERE salary > (SELECT AVG(salary) FROM employees);

-- 10. Temporary tables
-- Definition: A **TEMPORARY TABLE** is a special table that only exists for the duration of the current session and is automatically deleted when the session ends.
-- Purpose: Used for complex intermediate calculations, joining temporary results, or simplifying long queries.
CREATE TEMPORARY TABLE high_earners AS
SELECT name, salary FROM employees WHERE salary > 80000;

SELECT * FROM high_earners; -- Use the temporary table

-- DROP TABLE high_earners; -- Optional: it will be dropped automatically on session end


-- ============================================================
-- 4. STORED OBJECTS AND TRIGGERS
-- ============================================================

-- 8. Stored functions (in addition to procedures)
-- Definition: A **Stored Function** is similar to a procedure but **must return a single scalar value** (cannot use SELECT statements to return result sets).
-- Purpose: Creates a reusable function to calculate a 10% bonus for any given salary input.
DELIMITER $$
CREATE FUNCTION calculate_bonus(emp_salary INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC -- Indicates the function always returns the same result for the same input
BEGIN
    RETURN emp_salary * 0.10;
END $$
DELIMITER ;

-- Calling the stored function
SELECT name, salary, calculate_bonus(salary) AS bonus_amount FROM employees;

DROP FUNCTION calculate_bonus;


-- 9. Triggers: BEFORE vs AFTER, DELETE / UPDATE triggers; OLD vs NEW

-- Creating an Audit Log Table for the Trigger
CREATE TABLE salary_audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    old_salary INT,
    new_salary INT,
    change_date DATETIME
);

-- BEFORE UPDATE Trigger
-- Definition: An **BEFORE UPDATE** trigger executes *before* the UPDATE statement modifies the row.
-- Purpose: Audits the salary change by logging the old and new values. **OLD** refers to the row *before* the change; **NEW** refers to the row *after* the change.
DELIMITER $$
CREATE TRIGGER before_salary_update
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    -- Only log if the salary actually changed
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO salary_audit (employee_id, old_salary, new_salary, change_date)
        VALUES (OLD.emp_id, OLD.salary, NEW.salary, NOW());
    END IF;
END $$
DELIMITER ;

-- Test the trigger (this will create an entry in salary_audit)
UPDATE employees SET salary = 130000 WHERE name = 'Frank';

SELECT * FROM salary_audit;


-- ============================================================
-- 5. TRANSACTION CONTROL AND ISOLATION
-- ============================================================

-- Transaction Management (TCL - Transaction Control Language)
SET autocommit = 0;
-- Start a multi-statement transaction block (explicitly begins the transaction)
START TRANSACTION;

UPDATE employees SET salary = salary + 5000 WHERE dept_id = 10;
SELECT name, salary FROM employees WHERE dept_id = 10; -- View the uncommitted changes

-- If an error or mistake is found:
ROLLBACK;
SELECT name, salary FROM employees WHERE dept_id = 10; -- Changes are undone

-- 11. Transaction isolation levels (READ COMMITTED, REPEATABLE READ, etc.)
-- Definition: **Isolation Levels** define how changes made by one transaction are visible to other concurrent transactions.
-- Purpose: Controls concurrency and ensures data consistency (e.g., preventing "dirty reads" or "non-repeatable reads").
-- Setting the isolation level for the current session:
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- Setting the isolation level globally (requires sufficient privileges):
-- SET GLOBAL TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Check the current session isolation level
SELECT @@transaction_isolation;

COMMIT; -- End of any pending transaction

-- End of file