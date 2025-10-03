🍣 SQL CaseStudy – Japanese Food Truck
📌 Project Overview

This project analyzes sales, menu, and membership data from a Japanese food truck. The objective is to gain business insights about customer spending behavior, menu performance, and membership loyalty program effectiveness.

🛠 Tools & Skills Used

-- MYSQL

-- Joins, Subqueries, CTEs

-- Aggregation & Grouping

-- Window Functions (RANK, DENSE_RANK, ROW_NUMBER)

-- Data Modeling & Query Optimization

📂 Dataset Information

The project dataset contains three key tables:

-- Sales → Records of customer transactions (customer, date, item purchased).

-- Menu → Menu items with name and price.

-- Members → Membership join date for each customer.

🔑 Business Questions & Results

1️⃣ What is the total amount each customer spent?

Customer A → $76

Customer B → $74

Customer C → $36

2️⃣ How many days has each customer visited the food truck?

Customer A → 4 visits

Customer B → 6 visits

Customer C → 2 visits

3️⃣ What was the first item purchased by each customer?

Customer A → Curry

Customer B → Curry

Customer C → Ramen

4️⃣ What is the most purchased item on the menu and how many times was it purchased?

Ramen → 8 times (most popular item)

5️⃣ Which item was purchased first by each customer after becoming a member?

Customer A → Curry

Customer B → Sushi

6️⃣ Which item was purchased most often by each customer after becoming a member?

Customer A → Ramen

Customer B → Sushi

Customer C → (Not a member)

7️⃣ Which menu item generated the most revenue?

Ramen → $48 revenue

8️⃣ If customers earn 10 points per $1 spent, how many points does each customer have?

Customer A → 760 points

Customer B → 740 points

Customer C → 360 points

9️⃣ In the first week after becoming a member, which customer earned the most points?

Customer A → 510 points

📈 Key Insights

-- Ramen is the most popular and profitable menu item.

-- Customer B is the most frequent visitor (6 visits).

-- Membership encourages spending, as members continued to order frequently after joining.

-- A points-based loyalty program increases engagement and provides a retention strategy.

🚀 How to Run the Project

Clone this repository:

git clone https://github.com/yourusername/japanese-food-truck-sql.git
cd japanese-food-truck-sql


Import the SQL scripts into your SQL environment.

Run the queries provided in japanese_food_truck_solutions.sql.

📌 Future Improvements

-- Build a Power BI dashboard to visualize menu sales and customer loyalty.

-- Expand dataset with seasonality and daily sales patterns.

-- Use SQL + Python to forecast future sales trends.
