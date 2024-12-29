CREATE TRIGGER trigger_customers
ON customers
AFTER INSERT, UPDATE, DELETE
AS 
PRINT ('You made one DML opertation')

DELETE FROM customers WHERE cid = 1111

SELECT * FROM accounts

------------------------------

CREATE TABLE audit_account
( accno VARCHAR(10),
  bcode int,
  usr_name VARCHAR(30),
  utime DATETIME NULL,
  balance_old NUMERIC(18,0),
  balance_new NUMERIC(18,0)
  );

  -----------------------------

  CREATE TRIGGER modify_balance
  ON accounts AFTER UPDATE
  AS
  IF UPDATE (balance)
  BEGIN
	DECLARE @balance_old NUMERIC(18,0)
	DECLARE @balance_new NUMERIC(18,0)
	DECLARE @accno VARCHAR(10)
	DECLARE @bcode INT

	SET @balance_old = (SELECT balance FROM deleted)
	SET @balance_old = (SELECT balance FROM inserted)
	SET @accno = (SELECT accno FROM deleted)
	SET @bcode = (SELECT balance FROM deleted)

	INSERT audit_account
		VALUES (@accno, @bcode, USER_NAME(), GETDATE(), @balance_old, @balance_new)

 END	
