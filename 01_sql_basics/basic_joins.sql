/*
1378. Replace Employee ID With The Unique Identifier
    Write a solution to show the unique ID of each user, If a user does not have a unique ID replace just show null.
    Return the result table in any order.
*/

-- Use LEFT JOIN to show all the rows from the left table.
-- If there is no matching row from the right table,
-- columns from the right table are returned as NULL.
-- JOIN is the same as INNER JOIN.

SELECT u.unique_id, e.name
FROM Employees e
LEFT JOIN EmployeeUNI u
ON e.id = u.id;


/*
1068. Product Sales Analysis I
    Write a solution to report the product_name, year, and price for each sale_id in the Sales table.
    Return the resulting table in any order.
*/

SELECT p.product_name, s.year, s.price
FROM Sales s
JOIN Product p
On s.product_id = p.product_id;


/*
1581. Customer Who Visited but Did Not Make Any Transactions
    Write a solution to find the IDs of the users who visited without making any transactions and the number of times they made these types of visits.
    Return the result table sorted in any order.
*/
-- Use LEFT JOIN to keep all visits. If a visit has no matching transaction, the transaction columns become NULL
-- GROUP BY customer_id to count the number of visits witout transactions for each customer

SELECT v.customer_id, COUNT(v.customer_id) as count_no_trans
FROM Visits v
LEFT JOIN Transactions t
ON v.visit_id = t.visit_id
WHERE t.transaction_id IS NULL
GROUP BY v.customer_id;


/*
197. Rising Temperature
    Write a solution to find all dates' id with higher temperatures compared to its previous dates (yesterday).
    Return the result table in any order.
*/
-- CROSS JOIN creates all possible row combinations between two tables.
-- Here, it is used as a self join on the Weather tables.
-- In PostgreSQL, date differences can be calculated by subtracting dates.
-- Compare today's temperatuer to yesterday's temperature.

SELECT today.id
FROM Weather yesterday
CROSS JOIN Weather today
WHERE today.recordDate - yesterday.recordDate = 1
AND today.temperature > yesterday.temperature;


/*
1661. Average Time of Process per Machine
    There is a factory website that has several machines each running the same number of processes.
    Write a solution to find the average time each machine takes to complete a process.
    The time to complete a process is the 'end' timestamp minus the 'start' timestamp.
    The average time is calculated by the total time to complete every process on the machine
    divided by the number of processes that were run.
    The resulting table should have the machine_id along with the average time as processing_time,
    which should be rounded to 3 decimal places.
    Return the result table in any order.
*/

-- STEP 1:
-- We self join because the start and end timestamps are stored in separate rows.
-- By putting them into the same row, we can calculate the processing time using subtraction.

-- SELECT machine_id, process_id, a.timestamp as start_time, b.timestamp as end_time
-- FROM Activity a
-- JOIN Activity b
-- ON (a.machine_id, a.process_id) = (b.machine_id, b.process_id)
-- WHERE a.activity_type = 'start'
-- AND b.activity_type = 'end';

-- STEP 2:
-- Group the rows by machine_id and calculate the average processing time:
--  Subtract the start time from the end time to get the processing time for each process.
--  Calculate the average processing time for each machine. AVG() does this automatically, so there is no need to calculate the total or count the rows manually.
--  Round the result to 3 decimal places.

-- SELECT
--     machine_id,
--     ROUND(AVG(end_time - start_time), 3)
--     as processing_time
-- FROM table_from_step_one
-- GROUP BY machine_id;

-- STEP 3: Combine the two steps above.
-- In PostgreSQL, ROUND(value, decimal_places) requires a numeric value.
-- Cast the result of AVG() to numeric before applying ROUND().

SELECT
    a.machine_id,
    ROUND(CAST(AVG(b.timestamp - a.timestamp) AS numeric), 3) as processing_time
FROM Activity a
JOIN Activity b
ON (a.machine_id, a.process_id) = (b.machine_id, b.process_id)
WHERE a.activity_type = 'start'
AND b.activity_type = 'end'
GROUP BY a.machine_id;


/*
577. Employee Bonus
    Write a solution to report the name and bonus amount of each employee who satisfies either of the following:
    The employee has a bonus less than 1000.
    The employee did not get any bonus.
    Return the result table in any order.
*/

SELECT e.name, b.bonus
FROM Employee e
LEFT JOIN Bonus b
ON e.empId = b.empId
WHERE b.bonus < 1000
OR b.bonus IS NULL;


/*
1280. Students and Examinations
    Write a solution to find the number of times each student attended each exam.
    Return the result table ordered by student_id and subject_name.
*/

-- Use CROSS JOIN to generate all student-subject combinations.
-- Use LEFT JOIN to match examination records.
-- Count a column from the right table (Examinations) because COUNT() ignores NULL values.
-- This allows student-subject pairs with no exams to return 0.

SELECT
    s.student_id,
    s.student_name,
    sub.subject_name,
    COUNT(e.subject_name) as attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN Examinations e
ON s.student_id = e.student_id
AND sub.subject_name = e.subject_name
GROUP BY s.student_id, s.student_name, sub.subject_name
ORDER BY s.student_id, sub.subject_name;

/*
570. Managers with at Least 5 Direct Reports
    Write a solution to find managers with at least five direct reports.
    Return the result table in any order.
*/

SELECT name
FROM Employee
WHERE id in (
    SELECT managerId
    FROM Employee
    GROUP BY managerId
    HAVING COUNT(managerId) >= 5
);


/*
1934. Confirmation Rate
    The confirmation rate of a user is the number of 'confirmed' messages
    divided by the total number of requested confirmation messages.
    The confirmation rate of a user that did not request any confirmation messages is 0.
    Round the confirmation rate to two decimal places.
    Write a solution to find the confirmation rate of each user.
    Return the result table in any order.
*/

-- Specify the decimal by explicitly writing 1.00 for confirmed messages.
-- ROUND(x, 2) rounds to two decimal places but doesn't necessarily display trailing zeros.
-- Use AVG() to simplify the calculation instead of dividing by COUNT() explicitly.

SELECT
    s.user_id,
    ROUND(
        AVG(
            CASE
                WHEN c.action = 'confirmed' THEN 1.00
                ELSE 0
            END
        )
    , 2) as confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c
ON s.user_id = c.user_id
GROUP BY s.user_id;
