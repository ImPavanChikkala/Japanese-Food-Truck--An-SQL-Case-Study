show databases;
use casestudy;

CREATE TABLE sales (
    Customer_id varchar(2),
    Orderdate date,
    Product_id int
);
insert into sales(customer_id,orderdate,product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
  
  select * from sales;
  
  create table menu (
	    product_id int,
        product_name varchar(30),
        price int
        );
insert into menu(product_id,product_name,price)
values
   (1,'Sushi',10),
   (2,'Curry',15),
   (3,'Ramen',12);
    
    
create table members(
  customer_id varchar(1),
  join_date date
  );
insert into members(customer_id,join_date)
values
 ('A','2021-01-07'),
 ('B','2021-01-09');
    
    
select * from sales;
select * from menu;
select * from members;

show tables;


/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?

SELECT S.CUSTOMER_ID,SUM(M.PRICE) AS TOTAL_AMOUNT FROM MENU M
JOIN SALES S USING(PRODUCT_ID)
GROUP BY S.CUSTOMER_ID;


-- 2. How many days has each customer visited the restaurant?

SELECT DISTINCT(CUSTOMER_ID),
COUNT(Orderdate) OVER(partition by CUSTOMER_ID) AS CUSTOMER_VISITED
FROM SALES;


-- 3. What was the first item from the menu purchased by each customer?

SELECT customer_id, product_name
FROM (
    SELECT 
        s.customer_id,
        m.product_name,
        ROW_NUMBER() OVER (
            PARTITION BY s.customer_id
            ORDER BY s.orderdate  -- or the purchase timestamp column
        ) AS rn
    FROM sales s
    JOIN menu m 
      ON s.product_id = m.product_id
) t
WHERE rn = 1;


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
select M.PRODUCT_NAME,COUNT(S.PRODUCT_ID) AS total_purchases
FROM SALES S 
JOIN MENU M USING(PRODUCT_ID)
GROUP BY m.product_name
ORDER BY total_purchases DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?

SELECT CUSTOMER_ID,PRODUCT_NAME AS MOST_POPULAR
FROM (SELECT S.CUSTOMER_ID,COUNT(*) AS PURCHASES_COUNT,
	 M.PRODUCT_NAME,
     ROW_NUMBER()OVER(PARTITION BY CUSTOMER_ID 
					ORDER BY COUNT(*) DESC) AS RN
     FROM SALES S
      JOIN MENU M USING(PRODUCT_ID)
        GROUP BY s.customer_id, m.product_name
) t
WHERE RN=1;

-- 6. Which item was purchased first by the customer after they became a member?

select CUSTOMER_ID,PRODUCT_NAME
FROM(SELECT S.CUSTOMER_ID,M.PRODUCT_NAME,
	ROW_NUMBER()OVER(PARTITION BY CUSTOMER_ID) AS RN
    FROM SALES S
JOIN MENU M USING(PRODUCT_ID)
JOIN MEMBERS ME USING(CUSTOMER_ID)
WHERE ME.JOIN_DATE>S.ORDERDATE)T
WHERE RN=1;

-- 7. Which item was purchased just before the customer became a member?

select CUSTOMER_ID,PRODUCT_NAME
FROM(SELECT S.CUSTOMER_ID,M.PRODUCT_NAME,
	ROW_NUMBER()OVER(PARTITION BY CUSTOMER_ID
					 ORDER BY s.orderdate DESC) AS RN
    FROM SALES S
JOIN MENU M USING(PRODUCT_ID)
JOIN MEMBERS ME USING(CUSTOMER_ID)
WHERE S.ORDERDATE<ME.JOIN_DATE)T
WHERE RN=1;

-- 8. What is the total items and amount spent for each member before they became a member?

SELECT S.CUSTOMER_ID, 
	   COUNT(S.PRODUCT_ID) AS TOTAL_ITMES,
       SUM(M.PRICE) AS TOTAL_AMOUNT
FROM SALES S 
JOIN MENU M USING(PRODUCT_ID)
JOIN MEMBERS ME USING(CUSTOMER_ID)
WHERE S.ORDERDATE<ME.JOIN_DATE
GROUP BY S.CUSTOMER_ID
ORDER BY S.CUSTOMER_ID ;

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT S.CUSTOMER_ID,
	   SUM(
       CASE 
           WHEN M.PRODUCT_NAME='SUSHI' THEN M.PRICE*20
           ELSE M.PRICE*10
           END) as TOTAL_POINTS
FROM SALES S
JOIN MENU M USING(PRODUCT_ID)
GROUP BY S.CUSTOMER_ID
ORDER BY S.CUSTOMER_ID;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

SELECT 
    s.customer_id,
    SUM(
        CASE 
            -- Case 1: within 7 days from join date (double points on all items)
            WHEN s.orderDate BETWEEN me.join_date AND DATE_ADD(me.join_date, INTERVAL 6 DAY)
                THEN m.price * 20
            -- Case 2: after promo week but item = sushi (still 2x points)
            WHEN m.product_name = 'sushi'
                THEN m.price * 20
            -- Case 3: normal rule (everything else)
            ELSE m.price * 10
        END
    ) AS total_points
FROM sales s
JOIN menu m 
  ON s.product_id = m.product_id
JOIN members me 
  ON s.customer_id = me.customer_id
WHERE s.orderdate <= '2021-01-31'   -- end of January filter
  AND s.customer_id IN ('A', 'B')    -- only A and B
GROUP BY s.customer_id
ORDER BY s.customer_id;
