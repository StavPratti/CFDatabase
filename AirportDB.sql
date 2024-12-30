-- 1
SELECT * 
FROM flights
WHERE depDate = '2018-05-01' AND toCity = 'Toronto';

--2
SELECT * 
FROM flights
WHERE distance BETWEEN 900 AND 1500
ORDER BY distance

--3
SELECT toCity, COUNT(fno) AS flight_count
FROM flights
WHERE depDate BETWEEN '2018-05-01' AND '2018-05-30'
GROUP BY toCity

--4
SELECT toCity, COUNT(fno) AS flight_count
FROM flights
GROUP BY toCity
HAVING COUNT(fno) >= 3

--5
SELECT e.firstname, e.lastname
FROM employees e
JOIN certified c ON e.empid = c.empid
WHERE c.aid >= 3
ORDER BY e.lastname

--6
SELECT SUM(salary) AS total_salaries
FROM employees;

--7
SELECT SUM(e.salary) AS total_pilot_salaries
FROM employees e
WHERE empid IN (SELECT empid FROM certified)

--8
SELECT SUM(e.salary) AS total_non_pilot_salaries
FROM employees e
WHERE e.empid NOT IN (SELECT empid FROM certified);

--9
SELECT *
FROM aircrafts a
WHERE a.crange >= (SELECT distance 
                    FROM flights 
                    WHERE fromCity = 'Athens' AND toCity = 'Melbourne')

--10
SELECT e.firstname, e.lastname
FROM employees e
JOIN certified c ON e.empid = c.empid
JOIN aircrafts a ON c.aid = a.aid
WHERE a.aname LIKE 'Boeing%'

--11
SELECT e.firstname, e.lastname
FROM employees e
JOIN certified c ON e.empid = c.empid
JOIN aircrafts a ON c.aid = a.aid
WHERE a.crange > 3000 
  AND e.empid NOT IN (
    SELECT e2.empid
    FROM employees e2
    JOIN certified c2 ON e2.empid = c2.empid
    JOIN aircrafts a2 ON c2.aid = a2.aid
    WHERE a2.aname LIKE 'Boeing%'
  )

--12
SELECT firstname, lastname, salary
FROM employees
WHERE salary = (SELECT MAX(salary) FROM employees)

--13
SELECT firstname, lastname, salary
FROM employees
WHERE salary = (
  SELECT MAX(salary)
  FROM employees
  WHERE salary < (SELECT MAX(salary) FROM employees)
)

--14
SELECT a.aname
FROM aircrafts a
JOIN certified c ON a.aid = c.aid
JOIN employees e ON c.empid = e.empid
WHERE e.salary >= 6000

--15
SELECT e.firstname, e.lastname, MAX(a.crange) AS max_crange
FROM employees e
JOIN certified c ON e.empid = c.empid
JOIN aircrafts a ON c.aid = a.aid
WHERE c.aid >= 3
GROUP BY e.firstname, e.lastname

--16
SELECT e.firstname, e.lastname
FROM employees e
WHERE e.salary < (
  SELECT MIN(price)
  FROM flights
  WHERE toCity = 'Melbourne'
)

--17
SELECT e.firstname, e.lastname, e.salary
FROM employees e
WHERE e.empid NOT IN (SELECT empid FROM certified)
  AND e.salary > (SELECT AVG(salary) FROM employees JOIN certified c ON e.empid = c.empid)

--V1
CREATE VIEW pilots AS
SELECT * 
FROM employees 
WHERE empid IN (SELECT empid FROM certified)

--V2
CREATE VIEW others AS
SELECT * 
FROM employees 
WHERE empid NOT IN (SELECT empid FROM certified)

--7
SELECT SUM(salary) AS total_pilot_salaries
FROM pilots

--8
SELECT SUM(salary) AS total_non_pilot_salaries
FROM others

--17
SELECT firstname, lastname, salary
FROM others
WHERE salary > (SELECT AVG(salary) FROM pilots)

--V3
CREATE VIEW aircraft_flights AS
SELECT a.aname AS aircraft_name, f.fno, f.fromCity, f.toCity
FROM aircrafts a
JOIN flights f ON a.crange >= f.distance

--query
SELECT aircraft_name, COUNT(fno) AS flight_count
FROM aircraft_flights
GROUP BY aircraft_name

--P1
CREATE PROCEDURE categorize_flight_prices
AS
BEGIN
    DECLARE @fno VARCHAR(20);
    DECLARE @price DECIMAL(10, 2);
    DECLARE @category NVARCHAR(20);
    DECLARE flight_cursor CURSOR FOR
    SELECT fno, price
    FROM flights

    OPEN flight_cursor

    FETCH NEXT FROM flight_cursor INTO @fno, @price

    WHILE @@FETCH_STATUS = 0

    BEGIN
        IF @price <= 500
        BEGIN
            SET @category = N'     '
        END
        ELSE IF @price BETWEEN 501 AND 1500
        BEGIN
            SET @category = N'        '
        END
        ELSE
        BEGIN
            SET @category = N'      '
        END;

        PRINT '              : ' + @fno + ',          : ' + @category

        FETCH NEXT FROM flight_cursor INTO @fno, @price
    END;

    CLOSE flight_cursor;
    DEALLOCATE flight_cursor
END;

EXEC categorize_flight_prices

--P2
CREATE PROCEDURE certify_pilot
  @pilot_firstname NVARCHAR(50),
  @pilot_lastname NVARCHAR(50),
  @pilot_id INT,
  @aircraft_name NVARCHAR(50),
  @aircraft_id INT
AS
BEGIN
  DECLARE @pilot_exists INT
  DECLARE @aircraft_exists INT

  SELECT @pilot_exists = COUNT(*)
  FROM employees
  WHERE empid = @pilot_id AND firstname = @pilot_firstname AND lastname = @pilot_lastname

  SELECT @aircraft_exists = COUNT(*)
  FROM aircrafts
  WHERE aid = @aircraft_id AND aname = @aircraft_name

  IF @pilot_exists = 0
  BEGIN
    INSERT INTO employees (empid, firstname, lastname, salary)
    VALUES (@pilot_id, @pilot_firstname, @pilot_lastname, 0)
  END;

  IF @aircraft_exists = 0
  BEGIN
    INSERT INTO aircrafts (aid, aname, crange)
    VALUES (@aircraft_id, @aircraft_name, 0)
  END;

IF NOT EXISTS (
  SELECT 1 
  FROM certified 
  WHERE empid = @pilot_id AND aid = @aircraft_id
)
BEGIN
  INSERT INTO certified (empid, aid)
  VALUES (@pilot_id, @aircraft_id);
  PRINT N'                                               '
END
ELSE
BEGIN
  PRINT N'                                                 '
  END
END

EXEC certify_pilot
@pilot_firstname ='       ', @pilot_lastname = '           ', @pilot_id = 6758, @aircraft_name = 'Tokyo565', @aircraft_id =5434

--T1
CREATE TRIGGER increase_salary_after_certification
ON certified AFTER INSERT
AS
BEGIN
  DECLARE @empid INT;
  DECLARE @certifications_count INT;
  DECLARE @pilot_salary DECIMAL(10, 2);

  DECLARE certification_cursor CURSOR FOR
  SELECT empid FROM INSERTED;

  OPEN certification_cursor;

  FETCH NEXT FROM certification_cursor INTO @empid

  WHILE @@FETCH_STATUS = 0
  BEGIN
    SELECT @certifications_count = COUNT(*)
    FROM certified
    WHERE empid = @empid

    IF @certifications_count >= 3
    BEGIN
      SELECT @pilot_salary = salary
      FROM employees
      WHERE empid = @empid;

      UPDATE employees
      SET salary = @pilot_salary * 1.10
      WHERE empid = @empid;
    END;

    FETCH NEXT FROM certification_cursor INTO @empid
  END

  CLOSE certification_cursor
  DEALLOCATE certification_cursor
END

--T2
CREATE TABLE flight_history (
    fno VARCHAR(20),          
    username NVARCHAR(128), 
    update_time DATETIME,  
    old_price NUMERIC(18, 0),
    new_price NUMERIC(18, 0) 
)

--DROP TABLE flight_history

CREATE TRIGGER log_flight_price_update
ON flights AFTER UPDATE 
AS
IF UPDATE (price)
BEGIN
    DECLARE @fno VARCHAR(20)
	DECLARE @old_price NUMERIC(18,0)
	DECLARE @new_price NUMERIC(18,0)

	SET @fno = (SELECT fno FROM deleted)
	SET @old_price = (SELECT price FROM deleted)
	SET @new_price = (SELECT price FROM inserted)
	
    INSERT flight_history
		VALUES (@fno, USER_NAME(), GETDATE(), @old_price, @new_price)
END

--DROP TRIGGER log_flight_price_update

UPDATE flights
SET price = 1200
WHERE fno = 'A301'





















