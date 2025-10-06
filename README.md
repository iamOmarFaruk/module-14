# Task Manager (MySQL)

Simple database to manage users and their tasks.

## Database and Tables
- Database: `task_manager`
- Tables:
  - `users(id, name, email, created_at)`
  - `tasks(id, user_id, title, description, status, created_at)`
- Relationship: One user can have many tasks (`tasks.user_id` -> `users.id`, ON DELETE CASCADE).

## Load Sample Data
- Import `task_manager.sql` in phpMyAdmin or run it in MySQL client.

Quick check after import:
```sql
SELECT COUNT(*) AS users_count FROM users;      -- expect 4
SELECT COUNT(*) AS tasks_count FROM tasks;      -- expect 8
SELECT id, name, email FROM users ORDER BY id;  -- see users
SELECT id, user_id, title, status FROM tasks ORDER BY id; -- see tasks
```

## SQL Operations for Testing

Here are the SQL queries to test the database. They are designed to be safe to run, so your mentor can test them multiple times without changing the original data.

### 1. Select all tasks
Shows every task in the `tasks` table.
```sql
SELECT * FROM tasks ORDER BY id;
```

### 2. Update a task’s status
This example updates a task's status to 'completed' and then rolls back the change, so the original data is not modified.
```sql
-- Check status before update
SELECT id, title, status FROM tasks WHERE id = 2; -- status is 'in_progress'

START TRANSACTION;
UPDATE tasks SET status = 'completed' WHERE id = 2;
-- Check status after update
SELECT id, title, status FROM tasks WHERE id = 2; -- status is now 'completed'
ROLLBACK;

-- Check status after rollback to see it's back to original
SELECT id, title, status FROM tasks WHERE id = 2; -- status is 'in_progress' again
```

### 3. Delete a task
This example deletes a task and then rolls back the change.
```sql
-- Verify task with id=8 exists
SELECT id, title FROM tasks WHERE id = 8;

START TRANSACTION;
DELETE FROM tasks WHERE id = 8;
-- Verify task with id=8 is gone
SELECT * FROM tasks WHERE id = 8; -- returns empty set
ROLLBACK;

-- Verify task with id=8 is back
SELECT id, title FROM tasks WHERE id = 8;
```

### 4. Show tasks with Sorting and Limit/Pagination
This shows how to get pages of data, for example, 5 tasks per page.
```sql
-- Page 1: Get the first 5 tasks, ordered by creation date
SELECT id, title, created_at FROM tasks ORDER BY created_at DESC LIMIT 5 OFFSET 0;

-- Page 2: Get the next 5 tasks
SELECT id, title, created_at FROM tasks ORDER BY created_at DESC LIMIT 5 OFFSET 5;
```

### 5. Use Aggregator Functions
These queries show how to use functions like `COUNT()` and `MAX()`.

**Count how many tasks each user has:**
```sql
SELECT
    u.name,
    COUNT(t.id) AS number_of_tasks
FROM users u
LEFT JOIN tasks t ON u.id = t.user_id
GROUP BY u.id
ORDER BY number_of_tasks DESC;
```

**Find the most recently created task for each user:**
```sql
SELECT
    u.name,
    MAX(t.created_at) AS last_task_date
FROM users u
JOIN tasks t ON u.id = t.user_id
GROUP BY u.id
ORDER BY last_task_date DESC;
```

### 6. Perform Joins
These queries show how to combine data from `users` and `tasks` tables.

**INNER JOIN:** Shows only users who have tasks.
```sql
SELECT u.name, t.title, t.status
FROM users u
INNER JOIN tasks t ON u.id = t.user_id;
```

**LEFT JOIN:** Shows all users, and their tasks if they have any. User 'Mahmudullah Riyad' will appear with NULL task details because he has no tasks.
```sql
SELECT u.name, t.title, t.status
FROM users u
LEFT JOIN tasks t ON u.id = t.user_id;
```

**RIGHT JOIN:** Shows all tasks, and the user they belong to. In this data, every task has a user, so the result is the same as INNER JOIN.
```sql
SELECT u.name, t.title, t.status
FROM users u
RIGHT JOIN tasks t ON u.id = t.user_id;
```
