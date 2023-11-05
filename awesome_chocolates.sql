-- Select everything from sales table

select * from sales;

-- Show just a few columns from sales table

select SaleDate, Amount, Customers from sales;
select Amount, Customers, GeoID from sales;

-- Adding a calculated column with SQL

Select SaleDate, Amount, Boxes, Amount / boxes  from sales;

-- Naming a field with AS in SQL

Select SaleDate, Amount, Boxes, Amount / boxes as 'Amount per box'  from sales;

-- Using WHERE Clause in SQL

select * from sales
where amount > 10000;

-- Showing sales data where amount is greater than 10,000 by descending order
select * from sales
where amount > 10000
order by amount desc;

-- Showing sales data where geography is g1 by product ID &
-- descending order of amounts

select * from sales
where geoid='g1'
order by PID, Amount desc;

-- Working with dates in SQL

Select * from sales
where amount > 10000 and SaleDate >= '2022-01-01';

-- Using year() function to select all data in a specific year

select SaleDate, Amount from sales
where amount > 10000 and year(SaleDate) = 2022
order by amount desc;

-- BETWEEN condition in SQL with < & > operators

select * from sales
where boxes >0 and boxes <=50;

-- Using the between operator in SQL

select * from sales
where boxes between 0 and 50;

-- Using weekday() function in SQL

select SaleDate, Amount, Boxes, weekday(SaleDate) as 'Day of week'
from sales
where weekday(SaleDate) = 4;

-- Working with People table

select * from people;

-- OR operator in SQL

select * from people
where team = 'Delish' or team = 'Jucies';

-- IN operator in SQL

select * from people
where team in ('Delish','Jucies');

-- LIKE operator in SQL

select * from people
where salesperson like 'B%';

select * from people
where salesperson like '%B%';

select * from sales;

-- Using CASE to create branching logic in SQL

select 	SaleDate, Amount,
		case 	when amount < 1000 then 'Under 1k'
				when amount < 5000 then 'Under 5k'
                when amount < 10000 then 'Under 10k'
			else '10k or more'
		end as 'Amount category'
from sales;

-- GROUP BY in SQL

select team, count(*) from people
group by team


--Answering intermediate versus hard questions

--INTERMEDIATE PROBLEMS

--1. Print details of shipments (sales) where amounts are > 2,000 and boxes are <100?
--2. How many shipments (sales) each of the sales persons had in the month of January 2022?
--3. Which product sells more boxes? Milk Bars or Eclairs?
--4. Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?


--HARD PROBLEMS

--1. What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?
--2. Which salespersons did not make any shipments in the first 7 days of January 2022?
--3. How many times we shipped more than 1,000 boxes in each month?
--4. Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ on all the months?
--5. India or Australia? Who buys more chocolate boxes on a monthly basis?


--1. Print details of shipments (sales) where amounts are > 2,000 and boxes are <100?
select * from sales where amount > 2000 and boxes < 100;
 

--2. How many shipments (sales) each of the sales persons had in the month of January 2022?

select p.SPID, Salesperson, sum(Customers) as 'total_customers', sum(Boxes) as 'total_boxes'
from people p
join sales s on p.SPID = s.SPID
where SaleDate between '2022-01-01' and '2022-01-31'
group by p.SPID, Salesperson
order by total_boxes desc;

select p.Salesperson, count(*) as 'Shipment Count'
from sales s
join people p on s.spid = p.spid
where SaleDate between '2022-1-1' and '2022-1-31'
group by p.Salesperson;

--3. Which product sells more boxes? Milk Bars or Eclairs?
select Product, sum(Boxes) as sum_of_boxes
from products p 
join sales s on s.PID = p.PID 
where Product = 'Eclairs' or Product = 'Milk Bars'
group by Product
order by sum_of_boxes desc;

--4. Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?
select p.Product, sum(Boxes) as sum_of_boxes
from products p 
join sales s on s.PID = p.PID 
where p.Product in ('Eclairs', 'Milk Bars')  and 
SaleDate between '2022-02-01' and '2022-02-07'
group by p.Product
order by sum_of_boxes desc;


--HARD PROBLEMS (SOLUTION)
--1. What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?
 select distinct p.Salesperson
 from people p
 join sales s on p.SPID = s.SPID
 where SaleDate between '2022-01-01' and '2022-01-07'
;

--2. Which salespersons did not make any shipments in the first 7 days of January 2022?
select p.salesperson
from people p
where p.spid not in
(select distinct s.spid from sales s where s.SaleDate between '2022-01-01' and '2022-01-07');

--3. How many times we shipped more than 1,000 boxes in each month?
select month(SaleDate) as month, year(SaleDate) as year, count(*) as COUNT
from sales
where  Boxes > 1000
group by month, year
order by month, year;

--4. Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ on all the months?

select month(SaleDate) as month, year(SaleDate) as year, Product, Region, sum(Boxes) as total_boxes
from products p
join sales s on p.PID = s.PID
join geo g on g.GeoID = s.GeoID
where Product in ('After Nines')
and Region in ('New Zealand')
group by month, year, Product, Region
having total_boxes >1 
;

