SELECT lastname, firstname 
	FROM customers, depositors
WHERE customers.cid = depositors.cid
INTERSECT
SELECT lastname, firstname 
	FROM customers, borrowers
WHERE customers.cid = borrowers.cid

-----------------------------------

SELECT DISTINCT lastname, firstname 
	FROM customers, borrowers, depositors
WHERE customers.cid = borrowers.cid AND customers.cid = depositors.cid 

-----------------------------------

SELECT lastname, firstname 
	FROM customers, depositors
WHERE customers.cid = depositors.cid
UNION
SELECT lastname, firstname 
	FROM customers, borrowers
WHERE customers.cid = borrowers.cid

-----------------------------------

SELECT DISTINCT lastname, firstname 
	FROM customers, borrowers, depositors
WHERE customers.cid = borrowers.cid OR customers.cid = depositors.cid 

-----------------------------------

SELECT lastname, firstname 
	FROM customers, depositors
WHERE customers.cid = depositors.cid
EXCEPT
SELECT lastname, firstname 
	FROM customers, borrowers
WHERE customers.cid = borrowers.cid

-----------------------------------

SELECT DISTINCT lastname, firstname 
	FROM customers, depositors
WHERE customers.cid = depositors.cid AND customers.cid NOT IN (select cid from borrowers)

--COMPARISON

--1st way
--fastest
SELECT lastname, firstname 
	FROM customers
WHERE exists (SELECT * FROM depositors WHERE customers.cid=depositors.cid) AND
	  exists (SELECT * FROM borrowers WHERE customers.cid=borrowers.cid)	


--2nd way
--medium
SELECT DISTINCT lastname, firstname 
	FROM customers, depositors
WHERE customers.cid = depositors.cid AND customers.cid IN (select cid from borrowers)


--3rd way
--slowest
SELECT lastname, firstname 
	FROM customers, depositors
WHERE customers.cid = depositors.cid
INTERSECT
SELECT lastname, firstname 
	FROM customers, borrowers
WHERE customers.cid = borrowers.cid


