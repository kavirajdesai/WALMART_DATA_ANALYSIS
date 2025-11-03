use walmart_db;

select * from walmart;

select payment_method, count(*)
from walmart
group by payment_method;


select count(DISTINCT Branch) 
from walmart;

select max(quantity) from walmart;

/*QUESTION 1 Find different payment method and number of transactions, number of quantity sold*/
select payment_method, count(*) as no_payment_transaction,sum(quantity) as no_quantity_sold from walmart
group by payment_method;

/*QUESTION 2: Identify the highest-rated category in each branch, displaying the branch, category, avgerage rating*/
select * from
	(
    select Branch, category, avg(rating) as avg_rating, rank() over(partition by branch order by avg(rating) desc) as rank_
	from walmart
	group by Branch, category
	) as rank_table
Where rank_ = 1;


/*QUESTION3 : Identify the busiest day  for each branch on the number of transaction*/
select Branch, date from walmart;

select table1.branch, table1.day_name, table1.no_transactions from
	(
	select 
    branch, 
    dayname(str_to_date(date, '%d/%m/%Y')) as day_name,
    COUNT(*) as no_transactions,
    RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as rank_
	from walmart
	group by branch, day_name
	) as table1
where rank_=1;

/*QUESTION-4 Calculate the total quantity of items sold per payment method. List Payment method and total quantity*/

select payment_method, sum(quantity) as sold_quantity from walmart
group by payment_method
order by sold_quantity DESC;

/*QUESTION 5: Determine the average, minimum and maximum rating of products for each city.
List the city, average rating, min rating, and max rating*/

 select City, category,avg(rating) as avg_rating, min(rating) as min_rating, max(rating) as max_rating 
 from walmart
 group by City, category;
 
 /*QUESTION 6 Calculate the total profit for each categoryby considering total_profit as
  (unit price * quantity * profit_margin). List category and total_profit, ordered from highest to lowest profit.*/
  
  select category, sum(total) as total_revenue, sum(total * profit_margin) as total_profit from walmart
  group by category
  order by total_profit desc;
  
  /*QUESTION 7 Determine the most common payment method for each Branch. Display Branch and the preffered_payment_method*/
  select * 
  from
	 (
	  select branch, payment_method, count(*) as total_transaction, rank()Over(partition by branch order by count(*)desc) as rank_
	  from walmart 
	  group by branch, payment_method
      ) as table1
where rank_=1;

/*QUESTION 8: Categorize the sales into 3 groups MORNING, AFTERNOON, EVENING. Find out which of the shif and number of invoices*/

select 
	branch,
	case 
		when hour(time) < 12 THEN 'Morning'
        when hour(time) BETWEEN 12 and 17 THEN 'Afternoon'
        else 'Evening'
	end shift_time,
    count(*)
from walmart
group by 1,2
order by 1,3 desc;

