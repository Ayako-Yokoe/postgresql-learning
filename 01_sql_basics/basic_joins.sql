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

