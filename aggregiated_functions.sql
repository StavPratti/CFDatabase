--AGGREGIATED FUNCTIONS

SELECT * 
	FROM ACCOUNTS

SELECT AVG(BALANCE) AS average FROM accounts

SELECT SUM(BALANCE) AS total_sum FROM accounts

SELECT MAX(BALANCE) AS maximum FROM accounts

SELECT MIN(BALANCE) AS minimum FROM accounts

SELECT COUNT(BALANCE) AS total_count FROM accounts

SELECT * 
	FROM accounts 
ORDER BY bcode

SELECT accounts.bcode, city, SUM(balance)
	FROM accounts INNER JOIN branches ON accounts.bcode = branches.bcode
GROUP BY accounts.bcode

--when there's an aggregiated fun
--along with another column of the table
--we mandatory use GROUP BY when we want an aggregiated column in the query
--GROUP BY contains distinct values
--we group with ALL the columns we asked to be appeared in select
--otherwise it cannot be applied
--HAVING is used after the creation of a group 
--before groups' creation, we can use WHERE

SELECT bcode, SUM(balance)
	FROM accounts 
GROUP BY bcode

SELECT bcode, SUM(balance) AS total_sum
	FROM accounts
	WHERE bcode > 500
GROUP BY bcode
HAVING SUM(balance) < 20000

SELECT *
	FROM accounts

SELECT *
	FROM branches

SELECT bname, city, SUM(balance) AS total
	FROM branches INNER JOIN accounts ON branches.bcode = accounts.bcode
GROUP BY bname, city

SELECT accounts.bcode, city, SUM(balance) AS total
	FROM branches INNER JOIN accounts ON branches.bcode = accounts.bcode
GROUP BY accounts.bcode, city

SELECT bname, city, SUM(balance) AS total
	FROM branches INNER JOIN accounts ON branches.bcode = accounts.bcode
	WHERE city = '     '
GROUP BY bname, city
HAVING SUM(balance) > 50000

SELECT c.cid, lastname, firstname, city, SUM(amount) AS loans
	FROM customers AS C INNER JOIN borrowers B on c.cid = b.cid
	INNER JOIN loans L on b.lnum = l.lnum
	WHERE city = '           '
	GROUP BY c.cid, firstname, lastname, city
	HAVING SUM(amount) > 10000

--comparisons in the same table

SELECT *
	FROM branches
WHERE assets > all (select assets from branches where city = '           ')

SELECT *
	FROM branches
WHERE assets > some (select assets from branches where city = '           ')

--or
--table's copy
SELECT DISTINCT t.*
	FROM branches AS T, branches AS S
WHERE t.assets > s.assets AND
s.city = '           '

CREATE TABLE temp
(bcode int,
 bname VARCHAR(30),
 city VARCHAR(30),
 assetes NUMERIC(18,0)
 );

 INSERT INTO temp 
	SELECT *
	FROM branches
	WHERE city = '     '

SELECT * FROM temp

INSERT INTO temp
	SELECT * FROM temp

DROP TABLE temp