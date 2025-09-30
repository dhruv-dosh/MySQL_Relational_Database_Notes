# Comprehensive MySQL Learning Script

This repository contains a single, heavily commented SQL script (`mysql_script_with_notes.sql`) designed as an educational reference and sandbox for learning MySQL from fundamental commands (DDL, DML) up through advanced concepts (Joins, Subqueries, Stored Procedures, Triggers, and Transaction Management).

It is structured to be run sequentially in a MySQL client (like MySQL Workbench, DBeaver, or the Command Line Client).

---

## 🚀 Key Features and Topics Covered

The script is logically divided into major sections, providing definitions and "why" notes for every command used.

### 1. Database Management (DDL)
* **Creation & Structure:** `CREATE DATABASE`, `USE`, `CREATE TABLE`, `DROP TABLE`.
* **Schema Modification:** `ALTER TABLE` operations (`ADD COLUMN`, `DROP COLUMN`, `MODIFY COLUMN`).
* **Data Integrity:** Defining columns with `NOT NULL`, `UNIQUE`, `PRIMARY KEY`, `AUTO_INCREMENT`.
* **Advanced Constraints:** Implementation of `FOREIGN KEY` constraints with crucial referential actions:
    * `ON DELETE CASCADE`
    * `ON UPDATE CASCADE`

### 2. Data Manipulation (DML)
* **CRUD Operations:** `INSERT`, `SELECT`, `UPDATE`, `DELETE`.
* **Bulk Deletion:** Using `TRUNCATE TABLE` for fast removal of all records.
* **Filtering:** `WHERE` clause with `AND`, `OR`, `BETWEEN`, `IN`, `IS NULL`.
* **Pattern Matching:** Basic `LIKE` matching (`%`, `_`) and **Advanced `REGEXP`** (Regular Expressions).
* **Ordering & Limiting:** `ORDER BY` (multi-column sort, `ASC`/`DESC`), `LIMIT`, and `OFFSET` for pagination.

### 3. Aggregation & Grouping
* **Aggregate Functions:** `COUNT`, `AVG`, `SUM`, `MIN`, `MAX`.
* **Data Grouping:** `GROUP BY` to summarize data.
* **Group Filtering:** Using the `HAVING` clause to filter grouped results.

### 4. Relationships (Joins & Subqueries)
* **Standard Joins:** `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`.
* **Set Operations:** `UNION` and `UNION ALL`.
* **Subqueries:** Basic subqueries used in the `WHERE` clause.
* **Advanced Subqueries:** **Correlated Subqueries** to compare a row against its peer group (e.g., salary vs. department average).

### 5. Advanced Database Objects
* **Views:** `CREATE VIEW` to create virtual tables for simplified querying.
* **Indexes:** `CREATE INDEX`, `DROP INDEX`, and the utility `EXPLAIN` command for performance analysis.
* **Full-Text Search:** Creating and querying data using `FULLTEXT INDEX` and `MATCH() AGAINST()`.
* **Stored Procedures:** `CREATE PROCEDURE` and `CALL` to execute stored blocks of complex SQL logic.
* **Stored Functions:** `CREATE FUNCTION` to create reusable logic that returns a single value.

### 6. Administration & Control
* **Triggers:** Implementation of a **`BEFORE UPDATE`** trigger, demonstrating the use of **`OLD`** and **`NEW`** values for auditing/logging.
* **Temporary Tables:** `CREATE TEMPORARY TABLE` for temporary storage and complex calculation steps.
* **Transaction Control (TCL):** Using `START TRANSACTION`, `COMMIT`, and `ROLLBACK` for data safety.
* **Concurrency:** Setting and understanding **Transaction Isolation Levels** (`SET SESSION TRANSACTION ISOLATION LEVEL...`).
* **User Management (DCL):** Examples of `CREATE USER`, `GRANT`, and `REVOKE` permissions.
* **Monitoring:** `SHOW PROCESSLIST` to view active connections and queries.

---

## ⚙️ How to Use

1.  **Clone the Repository:**
    ```bash
    git clone [your-repo-link]
    cd [repo-name]
    ```
2.  **Connect to MySQL:**
    Open your preferred MySQL client and connect to a server instance (preferably a local development or sandbox server).
3.  **Execute the Script:**
    Load and execute the commands in the `mysql_script_with_notes.sql` file. It's recommended to run them step-by-step or section-by-section to observe the output and read the embedded notes for learning.

**Note:** The script creates and drops databases/tables named `dhruv_expanded`, `departments`, `employees`, etc. Ensure you are running this in a non-production environment.

 *Created and maintained by [dhruv-doshi](https://github.com/dhruv-dosh)*
