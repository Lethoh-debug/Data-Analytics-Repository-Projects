create database InventoryDB;
use InventoryDB;

/* Creating an items relation */

create table items(
item_id int primary key,
item_name varchar(30),
category varchar(30),
price decimal(10,2),
stock_quantity int
);

/* Populating items relation */

insert into items values
(001, 'Desk', 'Furniture', 300.00, 20),
(002, 'Chair', 'Furniture', 150.00, 50),
(003, 'Notebook', 'Stationery', 10.00, 100),
(004, 'Pen', 'Stationery', 2.00, 200),
(005, 'Monitor', 'Electronics', 250.00, 30);

/* Creating customers relation */

create table customers (
customer_id int primary key,
first_name varchar(30),
last_name varchar(30),
email varchar(60),
phone varchar(15)
);

/* Populating customers relation */

insert into customers values
(101, 'Mandla', 'Xaba', 'mandla.xaba@gmail.com ', '081-456-7890'),
(102, 'Mlondi', 'Nzama', 'mlondi.nzama@gmail.com', '073-567-8901'),
(103, 'Noluthando', 'Ncube', 'nolu.ncube@gmail.com', '068-678-9012');

/* Creating an orders relation */

create table orders (
order_id int primary key,
customer_id int foreign key references customers(customer_id),
order_date date,
Total_Amount decimal(10,2)
);

/* Populating orders relation */

insert into orders values
(001, 101, '2024-07-01', 600.00),
(002, 102, '2024-07-02', 300.00),
(003, 103, '2024-07-03', 150.00);

/* Creating the order_items relation */

create table order_items (
order_item_id int primary key,
order_id int foreign key references orders(order_id),
item_id int foreign key references items(item_id),
quantity int,
line_total decimal(10,2)
);

/* Populating order_items relation */

insert into order_items values
(001, 001, 001, 2, 600.00),
(002, 001, 003, 5, 50.00),
(003, 002, 002, 2, 300.00),
(004, 003, 004, 10, 20.00);

/* 10. Write a query to display all orders showing OrderID, CustomerID, OrderDate, and TotalAmount */

select order_id,customer_id,order_date,Total_amount
from orders;

/* 11. Using a sub-query, write a SQL query that increases the price of all Items in the Furniture category by 10% */

select item_id,item_name,category,price * 0.90 + price  as price_increased,stock_quantity from items where item_id in (
		select item_id from items where category = 'Furniture');

/* 12. Write a query to display the total quantity sold and total revenue for each item */

select item_name, stock_quantity as Total_quantity_sold, (price * stock_quantity) as Total_revenue
from items;

/* 13. Create a stored procedure to keep a SQL query to find the best-selling item by total sales amount. Show the ItemName and TotalSalesAmount */

create procedure best_selling_item 
as
	select Top 1 item_name, (price * stock_quantity) as TotalSalesAmount
	from items
go

exec best_selling_item;

/* Create a stored procedure to keep a SQL query that displays the total amount spent by each customer */

create procedure total_amount_by_customer 
as
	select first_name, Total_amount
	from customers join orders on orders.customer_id = customers.customer_id
go 

exec total_amount_by_customer;

/* Create a view that uses the JOIN statement to display the customer who has placed the highest total orders. The view should show the CustomerID, FirstName, LastName, and TotalAmount */

create view high_total_orders as

select Top 1 customers.customer_id,customers.first_name,customers.last_name,orders.Total_amount
from customers 
join orders on orders.customer_id = customers.customer_id
join order_items on order_items.order_id = orders.order_id
join items on items.item_id = order_items.item_id
where stock_quantity in (select max(stock_quantity) from items);

select * from high_total_orders;

select * from items;
select * from customers;
select * from orders;
select * from order_items;

