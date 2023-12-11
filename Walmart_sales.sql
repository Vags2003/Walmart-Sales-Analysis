-- language: SQL

-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;

-- Create table
CREATE TABLE sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);



--------------------------------- FEATURE ENGINEERING------------------------------------------------

-- time_of_the_day--

select 
      time,(
            case
            when `time` between "00:00:00" and "12:00:00" then "Morning"
            when `time` between "12:01:00" and "16:00:00" then "Afternoon"
            else "Evening"
            end) as time_of_day
from sales;

ALTER table sales add column time_ofday varchar(20);

update sales 
set time_ofday = (
			case
            when `time` between "00:00:00" and "12:00:00" then "Morning"
            when `time` between "12:01:00" and "16:00:00" then "Afternoon"
            else "Evening"
            end);
--            
-- day_name--

select 
      date, dayname(date)
from sales;

ALTER table sales add column day_name varchar(20);

update sales
set day_name = dayname(date);

--
-- month_name--
select
      date,monthname(date)
from sales;

ALTER table sales add column month_name varchar(20);

update sales
set month_name = monthname(date);



----------------------------------------------- Exploratory Data Analysis --------------------------------------------------------------
-- Generic Questions --
-- 1.How many unique cities does the data have? --

Select distinct(city)
from sales;
--

-- 2.In which city is each branch? --

select distinct(city), branch
from sales;
--

-- Sales Questions --
-- 1.Number of sales made in each time of the day per weekday --

select 
       time_ofday ,
       count(*) as total_sales
from sales 
        where day_name = "      "
group by time_ofday
order by total_sales;
--

-- 2.Which of the customer types brings the most revenue? --
select
       customer_type,
       sum(total) as total_revenue
from sales
group by customer_type
order by total_revenue desc;
--

-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)? --

select 
	city,
    sum(tax_pct) as VAT
from sales
group by city
order by VAT DESC;

--
-- 4. Which customer type pays the most in VAT? --
select
      customer_type,
      sum(tax_pct) as VAT
from sales
group by customer_type
order by VAT DESC;
--

-- Product Questions --
-- 1. How many unique product lines does the data have? --

select
      count(distinct(product_line))
from sales;
--

-- 2. What is the most common payment method? --
select
      distinct(payment),
      count(payment) as common_used_method
from sales
group by payment
order by common_used_method desc;
--

-- 3. What is the most selling product line? --
select
      product_line,
      count(product_line) as sales_productline
from sales
group by product_line
order by sales_productline desc;
--

-- 4.What is the total revenue by month? --
select 
      month_name,
      sum(total) as monthly_revenue
from sales
group by month_name
order by month_name;
--

-- 5.What month had the largest COGS?--
select
      month_name,
      sum(cogs) as cogs
from sales
group by month_name
order by cogs desc;
--
-- 6.What product line had the largest revenue? --
select 
     product_line, 
     sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;
--

-- 7. What is the city with the largest revenue?--
select 
     city, 
     sum(total) as total_revenue
from sales
group by city
order by total_revenue desc;
--

-- 8. What product line had the largest VAT? --
select 
     product_line,
     avg(tax_pct) as VAT
from sales
group by product_line
order by VAT desc;
--

-- 9.Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales-- 
select
     product_line,
     (case
     when total > avg(total) then "Good"
     else "Bad"
     end) as Review_ofsales
from sales
group by product_line;
--

-- 10. Which branch sold more products than average product sold? --
select
      branch,
      sum(quantity) as quant
from sales
group by branch
HAVING sum(quantity) > (select avg(quantity) from sales);
-- 

-- 11. What is the most common product line by gender? --
select 
      gender,
      product_line,
      count(gender) as gndr
from sales
group by gender,product_line
order by gndr desc;
--

-- 12. What is the average rating of each product line? --
select
      product_line,
      avg(rating) as ratings
from sales
group by product_line
order by ratings;
--

-- Customer Questions --
--
-- 1. How many unique customer types does the data have? --
select 
      distinct(customer_type)
from sales;
--
-- 2. How many unique payment methods does the data have? --
select 
      distinct(payment)
from sales;
--
-- 3. What is the most common customer type? --
select 
     customer_type,
     count(*) as count_of_customers
from sales
group by customer_type;
--
-- 4. Which customer type buys the most? --
select 
     customer_type,
     count(*) as count_of_customers
from sales
group by customer_type;
--
-- 5. What is the gender of most of the customers? --
select
      gender,
      count(*) as gndr
from sales
group by gender;
--
-- 6. What is the gender distribution per branch? --
select
      gender,
      count(*) as gndr
from sales
where branch = "A"
group by gender;
--
-- 7. Which time of the day do customers give most ratings? --
select
     time_ofday,
     avg(rating) as rat     
from sales
group by time_ofday
order by rat;
--
-- 8. Which time of the day do customers give most ratings per branch? --
select
     time_ofday,
     avg(rating) as rat     
from sales
where branch = " "
group by time_ofday
order by rat;
--
-- 9. Which day of the week has the best avg ratings? --
select
      day_name,
      avg(rating) as ratings
from sales
group by day_name
order by ratings;
--
-- 10. Which day of the week has the best average ratings per branch? -- 
select
      day_name,
      avg(rating) as ratings
from sales
where branch = "A"
group by day_name
order by ratings;
--
