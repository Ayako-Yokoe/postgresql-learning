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
