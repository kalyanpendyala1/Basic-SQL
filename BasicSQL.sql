--TABLE ALIASES

--just type the alias name after the table name and use the same alias name to select columns
select t1.name, t3.total, t2.account_id
from accounts t1
join web_events t2
on t1.id = t2.account_id

join orders t3
on t3.account_id = t1.id
limit 5

------------------------------------------------
--You can use AS to give alias name
select t1.name, t3.total, t2.account_id
from accounts  AS t1
join web_events AS t2
on t1.id = t2.account_id

join orders AS t3
on t3.account_id = t1.id
limit 5

----------------------------------------------
--give alias name for the columns too
select t1.name AS alias1, t3.total AS alias2, t2.account_id As alias3
from accounts  AS t1
join web_events AS t2
on t1.id = t2.account_id

join orders AS t3
on t3.account_id = t1.id
limit 5

-----------------------------------------------

--joining 4 tables
select R.name, S.name, A.name
from sales_reps S
join region R
on S.region_id = R.id 
 
join accounts A
on S.id = A.sales_rep_id
order by A.name
limit 10;

select R.name region, A.name account , (O.total_amt_usd/(O.total+0.01)) as unitprice, W.channel
from region R
join sales_reps S
on S.region_id  = R.id

join accounts A
on A.sales_rep_id = S.id 

join orders O 
on O.account_id = A.id 

join web_events W 
on W.account_id = A.id 
limit 10;

----------------------------------------------------------


select R.name Region, S.name Sales_Representative, A.name Account_name
from region R
join sales_reps S
on S.region_id = R.id 
join accounts A
on A.sales_rep_id = S.id 
order by Account_name
limit 5;

------------------

select R.name Region, S.name Sales_Representative, A.name Account_name
from region R
join sales_reps S
on S.region_id = R.id 
join accounts A
on A.sales_rep_id = S.id 
where (S.name LIKE 'K%') and (R.id = 2)
order by Account_name
limit 5;

----------------------

select R.name Region, S.name Sales_Representative, A.name Account_name
from region R
join sales_reps S
on S.region_id = R.id 
join accounts A
on A.sales_rep_id = S.id 
where (S.name LIKE '% S%') and (R.id = 2)
order by Account_name
limit 5;

------------------------

select R.name RegionName, A.name AccountName, (total_amt_usd/total+0.01) UnitPrice
from region R
join sales_reps S
on S.region_id = R.id 

join accounts A 
on A.sales_rep_id = S.id 

join orders O 
on O.account_id = A.id 

where O.standard_qty > 100
limit 10;
--------------------------------

select R.name RegionName, A.name AccountName, (total_amt_usd/total+0.01) UnitPrice
from region R
join sales_reps S
on S.region_id = R.id 

join accounts A 
on A.sales_rep_id = S.id 

join orders O 
on O.account_id = A.id 

where (O.standard_qty > 100) AND (poster_qty > 50)
ORDER BY UnitPrice
limit 10;

-----------------------------------


select R.name RegionName, A.name AccountName, (total_amt_usd/total+0.01) UnitPrice
from region R
join sales_reps S
on S.region_id = R.id 

join accounts A 
on A.sales_rep_id = S.id 

join orders O 
on O.account_id = A.id 

where (O.standard_qty > 100) AND (poster_qty > 50)
ORDER BY UnitPrice DESC
limit 10;

-------------------------------------

SELECT DISTINCT W.channel, A.name
FROM web_events W

join accounts A
on W.account_id = A.id 
ORDER BY A.name 
LIMIT 10;

-------------------------------------

select W.occurred_at, A.name, O.total_amt_usd
FROM web_events W 
join accounts A 
on W.account_id = A.id 

join orders O
on O.account_id = A.id 
where W.occurred_at between '2015-01-01' AND '2015-12-31'
LIMIT 10;

----------------------------------------
--SQL Aggregations

select count() from web_events
LIMIT 5


select SUM(standard_qty) AS standard_qty, SUM(gloss_qty) AS gloss_qty, SUM(poster_qty) AS poster_qty from orders

select SUM(standard_amt_usd) AS standard_amt_usd, SUM(poster_amt_usd) AS poster_amt_usd from orders

select SUM(standard_amt_usd)/SUM(standard_qty) from orders
limit 2

select MIN(occurred_at) Earliest_order from orders


select MAX(occurred_at) from web_events;

--same thing but performed without using aggregate functions
SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

select AVG(standard_amt_usd) avg_std,
	    AVG(poster_amt_usd) avg_poster,
		AVG(gloss_amt_usd) avg_gloss,
		 from orders 



select A.name, W.occurred_at
from accounts A
join web_events W
on W.account_id = A.id 
order by occurred_at
limit 5;
------------------------

select A.name, O.total_amt_usd
from accounts A
join orders O 
on O.account_id = A.id 
GROUP BY A.name
limit 5;
-------------------

SELECT W.occurred_at, W.channel, A.name
from web_events W
join accounts A 
on W.account_id = A.id 
ORDER BY W.occurred_at DESC
limit 5;

--------------------------
select channel, count(channel) as times_used
from web_events
GROUP by channel
order by times_used;

-----------------------------

select A.primary_poc, W.occurred_at
from web_events W
join accounts A 
on W.account_id = A.id 
order by W.occurred_at
limit 5;

-----------------------------

select A.name, MIN(O.total)
from accounts A 
join orders O 
on O.account_id = A.id 
group by A.name 
order by O.total 
limit 2;
-------------------------

select R.name, Count(S.id) Number_of_reps
from sales_reps S 
join region R 
on S.region_id = R.id 
group by R.name
order by Number_of_reps


----------------------------

select A.name, AVG(standard_qty), AVG(poster_qty), AVG(gloss_qty) 
from orders O 
join accounts A 
on A.id = O.account_id
group by A.name
order by A.name
limit 5;
----------------------------------
select A.name, AVG(standard_amt_usd), AVG(poster_amt_usd), AVG(gloss_amt_usd) 
from orders O 
join accounts A 
on A.id = O.account_id
group by A.name
order by A.name
limit 5;
-----------------------------------

select S.name, W.channel, count(W.channel) as freq
from web_events W 
join accounts A 
on W.account_id = A.id 
join sales_reps S 
on A.sales_rep_id = S.id 
group by S.name, W.channel
order by freq
limit 5;
-----------------------------------

select DISTINCT name
from region;

select DISTINCT id, name
from sales_reps;

-------------------------------------
--Having Clause Quiz answers

------------------------------------
select S.id, S.name, COUNT(*) num_accounts
from accounts A 
join sales_reps S 
on S.id = A.sales_rep_id
GROUP BY 1,2 
having COUNT(*)>5
ORDER BY num_accounts;

--------------------------------------
select A.name, COUNT(*) as num 
FROM accounts A
JOIN orders O 
on A.id = O.account_id
group by A.name
having Count(*) > 20
order by num
limit 100;


select A.name, count(*) as num
from accounts A 
join orders O 
on A.id =O.account_id 
group by A.name
order by num DESC
limit 1;


select A.name, SUM(O.total_amt_usd) total 
from accounts A 
join orders O 
on A.id = O.account_id
having SUM(O.total_amt_usd) > 30000
order by total DESC
limit 2;


select A.name, SUM(O.total_amt_usd) total 
from accounts A 
join orders O 
on A.id = O.account_id
GROUP BY A.name
order by total DESC
limit 1;

select A.name, SUM(O.total_amt_usd) total 
from accounts A 
join orders O 
on A.id = O.account_id
GROUP BY A.name
order by total 
limit 1;


select A.name, W.channel, count(*)
from accounts A 
join web_events W
on A.id = W.account_id 
group by A.name, W.channel
having count(W.channel)>6 AND w.channel = 'facebook' 
limit 5;


select * from orders
limit 2;

select DAY(occurred_at)
from orders
limit 2;
select DAYOFMONTH(occurred_at)
from orders
limit 2;
select DAYNAME(occurred_at)
from orders
limit 2;
select DAYOFWEEK(occurred_at)
from orders
limit 2;



SELECT year(W.occurred_at), SUM(O.total_amt_usd) as total 
from orders O 
join accounts A 
on A.id = O.account_id

join web_events W 
on A.id = W.account_id
group by year(W.occurred_at)
order by Year(W.occurred_at);
--------------------------------------

SELECT month(W.occurred_at), SUM(O.total_amt_usd) as total 
from orders O 
join accounts A 
on A.id = O.account_id

join web_events W 
on A.id = W.account_id
group by month(W.occurred_at)
order by total DESC;
--------------------------------------
SELECT year(W.occurred_at), SUM(O.total_amt_usd) as total 
from orders O 
join accounts A 
on A.id = O.account_id

join web_events W 
on A.id = W.account_id
group by year(W.occurred_at)
order by total DESC

select * from accounts
limit 2;

------CASE Statements------

select name, CASE WHEN name LIKE 'W%' THEN 'Dont Trust' ELSE 'Good' END AS new_col
from accounts
limit 10;

select A.name, O.total_amt_usd, CASE WHEN O.total_amt_usd >3000 THEN 'Large' ELSE 'Small' END as level
from accounts A 
join orders O 
on A.id = O.account_id
having level = 'large'
limit 5;

select CASE when total >= 2000 then 'Atleast 2000'
			when total between 1000 and 2000 then 'between 1000 and 2000'
			when total < 1000 then 'less than 1000'
			Else 'Nill' END AS total_sales
from orders;

--------SubQuries----
Select channel, avg(event_count) aver from

(select DAte(occurred_at) AS day,
		channel,
		Count(*) as event_count
	From web_events 
Group By 1,2) sub 

	group by 1
	order by 2 DESC

-------------------------------

	select  channel, avg(events) avg_events
	from
		(select date(occurred_at) occ, channel, count(*) as events
		from web_events
		group by 1,2) sub

	group by  channel 
	order by avg_events DESC
	
-------------------------------



select AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_poster 
from orders
where occurred_at between 

(select date_format(MIN(occurred_at), '%Y-%m-01') as min_date
from orders) 

and Date_add((select date_format(MIN(occurred_at), '%Y-%m-01') as min_date
from orders), Interval 31 DAY)



SELECT t3.rep_name, t3.region_name, t3.total_amt
FROM(SELECT region_name, MAX(total_amt) total_amt
     FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY 1, 2) t1
     GROUP BY 1) t2
JOIN (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
     FROM sales_reps s
     JOIN accounts a
     ON a.sales_rep_id = s.id
     JOIN orders o
     ON o.account_id = a.id
     JOIN region r
     ON r.id = s.region_id
     GROUP BY 1,2
     ORDER BY 3 DESC) t3
ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt;



--Common Table Expressions


with t1 as
(
select R.name as Region_Name, S.name as Rep_Name, SUM(O.total_amt_usd) as total 
from region R 

join sales_reps S 
on R.id = S.region_id

join accounts A 
on S.id = A.sales_rep_id

join orders O 
on A.id = O.account_id

Group by 1,2
Order by total DESC
)



with t2 as
(
select Region_Name,  Max(total) 
from t1
Group by 1
)

select t1.Rep_Name, t1.region_name, t1.total
from t1
join t2
on t1.Region_Name = t2.Region_Name AND t1.total = t2.total;


WITH t1 AS (
  SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
   FROM sales_reps s
   JOIN accounts a
   ON a.sales_rep_id = s.id
   JOIN orders o
   ON o.account_id = a.id
   JOIN region r
   ON r.id = s.region_id
   GROUP BY 1,2
   ORDER BY 3 DESC) 

   SELECT region_name, rep_name, MAX(total_amt) total_amt
   FROM t1
   GROUP BY 1
