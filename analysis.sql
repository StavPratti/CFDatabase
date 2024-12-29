/* Queries */

/* Sales amount by gender */
select gender, sum(salesAmount) 
   from Customers, Sales 
 where Customers.customerKey=Sales.customerKey
 group by gender

/* Sales amount by country */
select country, sum(salesAmount) 
   from territories, Sales 
 where Territories.salesTerritoryKey=Sales.salesTerritoryKey
 group by country

/* sales amount by category */
select category, sum(salesAmount) 
   from products, Sales 
 where products.productKey=Sales.productKey
 group by category

/* sales amount by  year */
select s_year, sum(salesAmount) 
   from calendar, Sales 
 where dateKey=orderDate
 group by s_year
 order by s_year

/* sales amount by   country and year */
select country, s_year, sum(salesAmount) 
   from Territories, calendar, Sales 
 where dateKey=orderDate and
       Territories.salesTerritoryKey=Sales.salesTerritoryKey
 group by country, s_year
 order by s_year

/* big sales  by   year */
create view v1 as  
   select s_year, salesOrderNum, sum(salesAmount) as totalAmount
       from calendar, Sales
	   where dateKey=orderDate
	   group by s_year, salesOrderNum
	   having sum(salesAmount) > 2500
	   
select s_year, count(*) from v1 group by s_year

/*sales by year, country and category */
select s_year, country, category, sum(salesAmount) 
   from Calendar, Territories, Products, Sales 
     where dateKey=orderDate and 
	       Territories.salesTerritoryKey=Sales.salesTerritoryKey and 
		   products.productKey=Sales.productKey
		   group by rollup (s_year, country, category)

/*sales cube by year, country and category */
select s_year, country, category, sum(salesAmount) 
   from Calendar, Territories, Products, Sales 
     where dateKey=orderDate and 
	       Territories.salesTerritoryKey=Sales.salesTerritoryKey and 
		   products.productKey=Sales.productKey
		   group by cube (s_year, country, category)	 
		   order by s_year desc, country desc, category desc

/* hierarchy */
select s_year, s_quarter, s_Month,  sum(salesAmount) 
   from calendar, Sales 
 where datekey=orderDate
 group by rollup (s_year, s_quarter, s_month)


