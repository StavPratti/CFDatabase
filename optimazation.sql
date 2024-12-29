-- Update statistics for a table 
update statistics HumanResources.Employee

-- Update statistics for all tables 
exec sp_updatestats 


-- A typical execution plan (Estimated and Actual Execution Plans)

SELECT person.person.BusinessEntityID, LoginID, JobTitle, FirstName, LastName  
   FROM Person.Person, HumanResources.Employee
WHERE person.person.BusinessEntityID=HumanResources.Employee.BusinessEntityID


-- CIS

SELECT * FROM production.product

-- TS 

create schema myschema; 

CREATE TABLE myschema.person
(fname varchar(30),
 lname varchar(30)
 );

SELECT * FROM myschema.person

-- CSFields.

SELECT * FROM sales.customer


-- IS

SELECT * FROM production.product WHERE  production.product.productid between 300 and 500 


-- Filter 

SELECT * FROM Person.person WHERE Persontype='EM'


SELECT firstname, lastname  FROM Person.person WHERE Persontype='EM'


SELECT firstname, lastname  FROM Person.person  WHERE Lastname='Smith'


SELECT *  FROM Person.person  WHERE Lastname='Smith'


SELECT firstname, lastname  FROM Person.person  WHERE FirstName='Adam'

-- How to compare 

--Batch1

CHECKPOINT
DBCC DROPCLEANBUFFERS

SET STATISTICS IO ON

SELECT * FROM Person.person WHERE Persontype='EM'
SELECT * FROM Person.person  WHERE Lastname='Smith'

SET STATISTICS IO OFF


--Batch 2

SET STATISTICS IO ON
CHECKPOINT
DBCC DROPCLEANBUFFERS

SELECT firstname, lastname  FROM Person.person  WHERE Lastname='Smith'

SELECT firstname, lastname  FROM Person.person  WHERE FirstName='Adam'

SET STATISTICS IO OFF


-- SORT  

SELECT * from Person.person order by personType asc

SELECT firstname, lastname  FROM Person.person  order by FirstName

SELECT firstname, lastname  FROM Person.person  order by LastName, firstname


--JOIN (Sort Merge Join, Hash Join, Nested Loop Join)

SELECT Lastname, firstname, EmailAddress
 from  person.person,Person.EmailAddress 
 where  person.person.BusinessEntityid=person.Emailaddress.BusinessEntityid and 
 Lastname='Smith'

 
SELECT Lastname, firstname, EmailAddress
 from person.person inner join Person.Emailaddress 
 on person.person.businessentityid=person.emailaddress.businessentityid 

 dbcc dropcleanbuffers
 set statistics io on 
SELECT person.person.BusinessEntityID, LoginID, JobTitle, FirstName, LastName  
   FROM Person.Person INNER JOIN HumanResources.Employee
ON person.person.BusinessEntityID=HumanResources.Employee.BusinessEntityID
set statistics io off 


--SP


select addressline1, addressline2, city, stateprovinceid, postalcode 
 from person.address
where stateprovinceid=55

select addressline1, addressline2, city, stateprovinceid, postalcode 
 from person.address
where stateprovinceid=59

select addressline1, addressline2, city, stateprovinceid, postalcode 
 from person.address
where stateprovinceid=9

-- case 1
dbcc dropcleanbuffers
drop procedure p1;
create procedure p1
@sid int 
as 
begin 
select addressline1, addressline2, city, stateprovinceid, postalcode 
 from person.address
where stateprovinceid=@sid
end


execute p1 @sid=9
execute p1 @sid=55

-- case 2
drop procedure p1
create procedure p1
@sid int 
with recompile
as 
begin 
  
select addressline1, addressline2, city, stateprovinceid, postalcode 
 from person.address
where stateprovinceid=@sid
end

execute p1 @sid=9
execute p1 @sid=55

--case 3
drop procedure p1
create procedure p1
@sid int 

as 
begin 
select addressline1, addressline2, city, stateprovinceid, postalcode 
 from person.address
where stateprovinceid=@sid
option (optimize for (@sid=55))
end
execute p1 @sid=9
execute p1 @sid=55


----- Same results different plans !!!!
--bank database

  select lastname,firstname 
       from customer,depositor 
    where  customer.cid=depositor.cid 
    
	INTERSECT   
  
  select lastname,firstname 
       from customer,borrower 
    where  customer.cid=borrower.cid 

  select  distinct lastname,firstname 
       from customer,depositor 
    where  customer.cid=depositor.cid and
                customer.cid IN (select cid from borrower) 

   select lastname,firstname 
       from customer 
    where  exists (select * from depositor where customer.cid=depositor.cid) and 
	   exists	(select * from borrower where customer.cid=borrower.cid) 



