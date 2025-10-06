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

## Perfect SQL Operations (safe demo)

These queries use real rows from the file and show result checks. Use transactions so your sample data stays same. If you want to keep changes, COMMIT instead of ROLLBACK.

1) Select all tasks
```sql
SELECT * FROM tasks ORDER BY id;
```

2) Update a task’s status (safe demo)
```sql
START TRANSACTION;
UPDATE tasks SET status = 'completed' WHERE id = 2;       -- id 2 exists
SELECT id, title, status FROM tasks WHERE id = 2;          -- verify
ROLLBACK;  -- or COMMIT if you want to save
```

3) Delete a task (safe demo with temporary row)
```sql
START TRANSACTION;
INSERT INTO tasks (user_id, title, description, status)
VALUES (1, 'TEMP Demo Task', 'for delete demo', 'pending');
SELECT LAST_INSERT_ID() AS new_task_id;                    -- note the id
-- suppose new_task_id = X
DELETE FROM tasks WHERE id = LAST_INSERT_ID();             -- delete that row
SELECT * FROM tasks WHERE id = LAST_INSERT_ID();           -- should return 0 rows
ROLLBACK;  -- or COMMIT if you want to save
```

4) Sorting and Pagination
```sql
-- newest first by created_at
SELECT id, user_id, title, status, created_at
FROM tasks
ORDER BY created_at DESC
LIMIT 5 OFFSET 0;   -- page 1

SELECT id, user_id, title, status, created_at
FROM tasks
ORDER BY created_at DESC
LIMIT 5 OFFSET 5;   -- page 2

-- deterministic by id (alternative)
SELECT id, user_id, title, status FROM tasks ORDER BY id DESC LIMIT 3;
```

5) Aggregates (how many tasks each user has)
```sql
SELECT u.id, u.name, COUNT(t.id) AS task_count
FROM users u
LEFT JOIN tasks t ON t.user_id = u.id
GROUP BY u.id, u.name
ORDER BY task_count DESC, u.id;

-- extra: status-wise count per user
SELECT u.id, u.name, t.status, COUNT(*) AS cnt
FROM users u
LEFT JOIN tasks t ON t.user_id = u.id
GROUP BY u.id, u.name, t.status
ORDER BY u.id, t.status;
```

6) Joins
```sql
-- Inner Join: only users who have tasks
SELECT u.id AS user_id, u.name, t.id AS task_id, t.title, t.status
FROM users u
INNER JOIN tasks t ON t.user_id = u.id
ORDER BY u.id, t.id;

-- Left Join: all users (user 4 has 0 task but still shows)
SELECT u.id AS user_id, u.name, t.id AS task_id, t.title, t.status
FROM users u
LEFT JOIN tasks t ON t.user_id = u.id
ORDER BY u.id, t.id;

-- Right Join: all tasks (same rows as inner join because FK ensures user exists)
SELECT u.id AS user_id, u.name, t.id AS task_id, t.title, t.status
FROM users u
RIGHT JOIN tasks t ON t.user_id = u.id
ORDER BY u.id, t.id;
```

## Short Notes (Bangladeshi tone)
- Easy bhai. Import SQL, then run queries.
- `users` is main, `tasks` connects by `user_id`.
- For demo without breaking data, use `START TRANSACTION` and `ROLLBACK`.
- For page-wise list, use `LIMIT` + `OFFSET`.
- To count tasks, `COUNT()` with `GROUP BY`.
- Inner = matched, Left = all users, Right = all tasks.

All done. Import `.sql`, copy-paste queries, see real output.
