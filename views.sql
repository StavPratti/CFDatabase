CREATE VIEW LoanPerCustomer AS
SELECT lastname, firstname, SUM(amount) AS total
	FROM customers c JOIN borrowers b ON c.cid = b.cid
	JOIN loans l ON l.lnum = b.lnum
	GROUP BY lastname, firstname
	

SELECT * FROM LoanPerCustomer
	--WHERE total> 10000

CREATE VIEW TotalLoansAndDepositsPerBranch AS
	SELECT bname, SUM(loans.amount) AS total_loans,
	SUM(accounts.balance) AS total_deposits
	FROM branches LEFT JOIN loans on branches.bcode = loans.bcode 
	LEFT JOIN accounts on branches.bcode = accounts.bcode
	GROUP BY bname

SELECT * FROM TotalLoansAndDepositsPerBranch
	WHERE total_loans > total_deposits

CREATE VIEW	V1 AS 
SELECT bname, city, assets 
	FROM branches

--DONT update views, update just the table
--its not for this use
--update happens in tables as well when updating a view
SELECT * FROM V1

UPDATE V1
	SET assets = 222222 WHERE bname = 'Σταδίου'

SELECT * FROM branches