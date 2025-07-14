# Introduction to SQL with MySQL

This documentation provides a comprehensive introduction to SQL using MySQL, a popular relational database management system (RDBMS). It covers creating databases and tables, inserting, updating, and deleting data, managing relationships, and querying databases. Examples are based on the `eldoret_skating_club` database.

## 1. Overview of MySQL and RDBMS

MySQL is an open-source RDBMS that organizes data into tables with rows and columns. It uses SQL (Structured Query Language) to manage and manipulate data. An RDBMS enforces data integrity through constraints like primary keys, foreign keys, and unique keys, ensuring structured and reliable data storage.

The `eldoret_skating_club` database manages a skating club's operations, including members, activities, resources, and payments, demonstrating a relational structure with interconnected tables.

## 2. Creating a Database and Tables

### 2.1 Creating a Database
To create a database in MySQL, use the `CREATE DATABASE` statement. The `IF NOT EXISTS` clause prevents errors if the database already exists.

```sql
CREATE DATABASE IF NOT EXISTS eldoret_skating_club;
USE eldoret_skating_club;
```

- `CREATE DATABASE`: Creates a new database named `eldoret_skating_club`.
- `USE`: Sets the active database for subsequent operations.

### 2.2 Creating Tables
Tables store data in a structured format. The `CREATE TABLE` statement defines columns, data types, and constraints.

Example: Creating the `members` table:

```sql
CREATE TABLE IF NOT EXISTS members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    join_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    membership_status ENUM('active', 'expired') DEFAULT 'active',
    UNIQUE KEY uk_email (email)
);
```

- `member_id`: An auto-incrementing integer serving as the primary key.
- `VARCHAR(n)`: Variable-length string with a maximum length of `n`.
- `NOT NULL`: Ensures the column cannot be empty.
- `AUTO_INCREMENT`: Automatically generates unique IDs.
- `PRIMARY KEY`: Uniquely identifies each row.
- `ENUM`: Restricts values to a predefined list (`active`, `expired`).
- `UNIQUE KEY`: Ensures `email` values are unique.

Similarly, the `activities`, `resources`, and `payments` tables are created with foreign keys to establish relationships with the `members` table.

Example: Creating the `activities` table:

```sql
CREATE TABLE activities (
    activity_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    activity_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    activity_type VARCHAR(50) NOT NULL,
    notes TEXT,
    FOREIGN KEY fk_activities_member (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);
```

- `FOREIGN KEY`: Links `member_id` to the `members` table.
- `ON DELETE CASCADE`: Deletes related records in `activities` if the referenced `member_id` is deleted.

## 3. Inserting Data

The `INSERT INTO` statement adds data to tables.

Example: Inserting a member into the `members` table:

```sql
INSERT INTO members (first_name, last_name, email, phone, join_date, membership_status)
VALUES ('John', 'Kamau', 'john.kamau@example.com', '+254712345678', '2025-01-01', 'active');
```

- Specify columns and corresponding values.
- `join_date` and `membership_status` can use defaults if omitted.

Example: Inserting multiple records into `activities`:

```sql
INSERT INTO activities (member_id, activity_date, activity_type, notes)
VALUES
(1, '2025-06-01 10:00:00', 'training', 'Morning training session'),
(2, '2025-06-02 15:00:00', 'group skate', 'Group skate at the park');
```

## 4. Updating Data

The `UPDATE` statement modifies existing data. Use `WHERE` to target specific rows.

Example: Update a member's membership status:

```sql
UPDATE members
SET membership_status = 'expired'
WHERE member_id = 1;
```

- `SET`: Specifies the column and new value.
- `WHERE`: Ensures only the specified row is updated.

Example: Update a resource's return date and status:

```sql
UPDATE resources
SET return_date = '2025-06-15 10:00:00', status = 'returned'
WHERE resource_id = 1;
```

## 5. Deleting Data

The `DELETE` statement removes records. Use `WHERE` to avoid deleting all data.

Example: Delete a member:

```sql
DELETE FROM members
WHERE member_id = 3;
```

- Due to `ON DELETE CASCADE`, related records in `activities`, `resources`, and `payments` are also deleted.

Example: Delete all expired memberships:

```sql
DELETE FROM members
WHERE membership_status = 'expired';
```

## 6. Relationships

Relationships in an RDBMS link tables using keys:

- **Primary Key**: Uniquely identifies rows (e.g., `member_id` in `members`).
- **Foreign Key**: References a primary key in another table (e.g., `member_id` in `activities` references `members.member_id`).
- **ON DELETE CASCADE**: Ensures referential integrity by deleting dependent records.

In the `eldoret_skating_club` database:
- `activities`, `resources`, and `payments` have foreign keys linking to `members`.
- This enforces a one-to-many relationship: one member can have multiple activities, resources, or payments.

## 7. Querying Databases

Queries retrieve data using the `SELECT` statement. Common clauses include `WHERE`, `JOIN`, `GROUP BY`, and `ORDER BY`.

### 7.1 Basic Queries
Retrieve all members:

```sql
SELECT * FROM members;
```

Filter active members:

```sql
SELECT first_name, last_name, email
FROM members
WHERE membership_status = 'active';
```

### 7.2 Joins
Joins combine data from multiple tables.

Example: List members and their activities:

```sql
SELECT m.first_name, m.last_name, a.activity_type, a.activity_date
FROM members m
JOIN activities a ON m.member_id = a.member_id;
```

- `JOIN`: Links tables based on the `member_id` foreign key.
- Table aliases (`m`, `a`) simplify the query.

### 7.3 Aggregation
Use functions like `COUNT`, `SUM`, or `AVG` with `GROUP BY`.

Example: Count activities per member:

```sql
SELECT m.first_name, m.last_name, COUNT(a.activity_id) as activity_count
FROM members m
JOIN activities a ON m.member_id = a.member_id
GROUP BY m.member_id, m.first_name, m.last_name;
```

### 7.4 Sorting
Sort results with `ORDER BY`.

Example: List members by join date (newest first):

```sql
SELECT first_name, last_name, join_date
FROM members
ORDER BY join_date DESC;
```

### 7.5 Complex Queries
List members with unpaid payments and issued resources:

```sql
SELECT m.first_name, m.last_name, p.amount, r.resource_type
FROM members m
JOIN payments p ON m.member_id = p.member_id
JOIN resources r ON m.member_id = r.member_id
WHERE p.status = 'pending' AND r.status = 'issued';
```

## 8. Best Practices

- **Use Constraints**: Enforce data integrity with primary keys, foreign keys, and unique constraints.
- **Normalize Data**: Avoid redundancy by structuring tables efficiently (e.g., separating `members` and `activities`).
- **Index Frequently Queried Columns**: Improve performance with indexes (e.g., on `email` or `member_id`).
- **Backup Regularly**: Protect data with backups before major operations.
- **Use Transactions**: Ensure data consistency for multiple operations (e.g., `START TRANSACTION`, `COMMIT`, `ROLLBACK`).

## 9. Example Database Schema

The `eldoret_skating_club` database includes:
- **members**: Stores member details (e.g., name, email, status).
- **activities**: Tracks member activities (e.g., training, events).
- **resources**: Manages equipment distribution (e.g., skates, helmets).
- **payments**: Records membership payments.

This structure supports efficient querying and management of club operations.