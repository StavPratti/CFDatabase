--procedures
CREATE PROCEDURE Get_customer_name
@customer_id INT,
@customer_name VARCHAR(100) OUT
AS 
	BEGIN
		SELECT @customer_name = firstname + '' + lastname FROM customers WHERE cid = @customer_id
	END

DECLARE @cname VARCHAR(100)
EXEC Get_customer_name
@customer_id=2, @customer_name=@cname OUTPUT
SELECT @cname

---------------------------------

CREATE PROCEDURE Insert_customers
@cid INT, @firstname VARCHAR(30), @lastname VARCHAR(30), @city VARCHAR(30)
AS
	DECLARE @count INT
	SELECT  @count = 0
	SELECT @count = COUNT(*) 
		FROM customers
	WHERE firstname = @firstname AND lastname = @lastname
	IF (@count = 0)
	BEGIN 
		INSERT INTO customers VALUES (@cid, @firstname, @lastname, @city)
		PRINT 'Customer Record Inserted'
		END
		ELSE 
		BEGIN
			PRINT 'Customer Record already exists'
		END

EXECUTE Insert_customers
@cid = 1111, @firstname = 'Μάκης', @lastname = 'Σωτηρίου', @city = 'Αθήνα'

SELECT * FROM customers WHERE cid = 1111

EXECUTE Insert_customers
@cid = 1112, @firstname = 'Μάκης', @lastname = 'Σωτηρίου', @city = 'Αθήνα'


--cursors
DECLARE @fname VARCHAR(50), @lname   VARCHAR(50), @accno   VARCHAR(10), 
@balance NUMERIC(18,0); 
DECLARE cursor_customer CURSOR
 FOR SELECT firstname, lastname, accounts.accno, balance
	FROM customers, depositors,accounts
	WHERE customers.cid=depositors.cid and depositors.accno=accounts.accno
 ORDER BY firstname;
 OPEN cursor_customer;
 FETCH NEXT FROM cursor_customer INTO @fname, @lname, @accno,@balance;
 WHILE @@FETCH_STATUS = 0
	 BEGIN
		PRINT @lname+' ' + @fname+ ' '+ @accno +' ' +CAST(@balance AS varchar);
		FETCH NEXT FROM cursor_customer INTO @fname, @lname, @accno,@balance;
	 END;
 CLOSE cursor_customer;
 DEALLOCATE cursor_customer;


--complicated procedure
CREATE PROCEDURE Rate_Customers AS 
DECLARE @customer varchar (30) 
DECLARE @TotalDeposits numeric 
DECLARE @minCid int 
 
SELECT @minCid=min(cid) FROM customers 
 
WHILE @minCid is NOT NULL 
BEGIN 
   SET @customer= (SELECT lastname FROM customers WHERE customers.cid=@minCID)  
   SET @TotalDeposits= (SELECT SUM (accounts.balance)  
                         FROM customers, depositors, accounts 
                          WHERE customers.cid=@minCid AND 
                               customers.cid=depositors.cid AND 
                               depositors.accno=accounts.accno)  
IF (@TotalDeposits is NOT NULL)  
BEGIN 
--Υλοποίηση με χρήση case 
 SELECT CASE 
    WHEN @TotalDeposits<15000 THEN @customer+': '+CAST(@TotalDeposits AS   
       VARCHAR(12)) + ' - 3 (Low)' 
    WHEN @TotalDeposits<50000 THEN @customer+': '+CAST(@TotalDeposits AS  
       VARCHAR(12)) + ' – 2 (Medium)' 
    ELSE @customer+': '+CAST(@TotalDeposits AS VARCHAR(12)) + ' – 1 (High)' 
  END 
END 
SELECT @minCid = min(cid)FROM customers WHERE @minCid < cid 
END

EXEC Rate_Customers