"""
  Table: Products

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| new_price     | int     |
| change_date   | date    |
+---------------+---------+
(product_id, change_date) is the primary key (combination of columns with unique values) of this table.
Each row of this table indicates that the price of some product was changed to a new price at some date.
 

Write a solution to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Products table:
+------------+-----------+-------------+
| product_id | new_price | change_date |
+------------+-----------+-------------+
| 1          | 20        | 2019-08-14  |
| 2          | 50        | 2019-08-14  |
| 1          | 30        | 2019-08-15  |
| 1          | 35        | 2019-08-16  |
| 2          | 65        | 2019-08-17  |
| 3          | 20        | 2019-08-18  |
+------------+-----------+-------------+
Output: 
+------------+-------+
| product_id | price |
+------------+-------+
| 2          | 50    |
| 1          | 35    |
| 3          | 10    |
+------------+-------+
  """

# Write your MySQL query statement below
select product_id, new_price as price
from Products
where (product_id, change_date) in (
    select product_id, max(change_date) as last_change
    from Products
    where change_date <="2019-08-16"
    group by product_id
)
union
select distinct product_id , 10 as price from Products
where product_id not in (
    select product_id from Products
    where change_date <="2019-08-16"
)

## Alternatively
# Write your MySQL query statement below
select
    t.product_id,
    if(t.relevant_date<='2019-08-16', p.new_price, 10) as price
from
    (select
        product_id,
        if(min(change_date)<='2019-08-16', max(if(change_date <= '2019-08-16', change_date, null)), min(change_date)) as relevant_date
    from Products group by product_id) as t
    left join Products p
    on t.product_id=p.product_id and t.relevant_date=p.change_date
