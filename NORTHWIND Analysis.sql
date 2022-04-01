--we want to determine the total amount spent on each order 
select 
OrderID, 
ProductID, 
UnitPrice, 
Quantity, 
UnitPrice*Quantity as TotalPrice
from [Order Details]
order by OrderID, TotalPrice desc



--In Northwind company, inventory of all products are re-stocked once they are reduced to certain numbers.
--we want to determine which product needs to be re-stocked.
Select 
ProductID, 
ProductName, 
UnitsInStock, 
ReorderLevel
From Products
Where UnitsInStock <= ReorderLevel
Order by ProductID


--Some of the countries Northwind company ships to have very high freight charges. We'd like to investigate some more 
--shipping options for our customers, to be able to offer them lower freight charges. Therefore, we want to return the three
--ship countries with the highest average freight overall.
Select Top 10 
ShipCountry, 
AverageFreight = Avg(freight)
From Orders
Group By ShipCountry
Order By AverageFreight desc;


----------------- ADVERT, MARKETING AND SALES CAMPAIGN ANALYSIS----------------------

--We want to check for customers who have not made any orders at all. This would enable us to send them targetted advert
Select CustomerID
From Customers
Where
CustomerID not in (select CustomerID from Orders)



--Northwind wants to send all of its high-value customers special VIP gifts. We're defining high-value customers as 
--those who've made at least 1 order with a total value (not including the discount) equal to $10,000 or more. 
--We only want to consider orders made in the year 2016 and beyod.
Select
Customers.CustomerID,
Customers.CompanyName,
Orders.OrderID,
TotalOrderAmount = SUM(Quantity * UnitPrice)
From Customers
Join Orders
on Orders.CustomerID = Customers.CustomerID
Join [Order Details]
on Orders.OrderID = [Order Details].OrderID
Where
OrderDate >= 2016-01-01
Group by
Customers.CustomerID,
Customers.CompanyName,
Orders.Orderid
Having Sum(Quantity * UnitPrice) > 10000
Order by TotalOrderAmount desc



--we would like to do a sales campaign for existing customers.
--He'd like to categorize customers into groups, based on how much they ordered in 2016. Then, depending
--on which group the customer is in, he will target the customer with different sales materials.
;with Orders2016 as (
Select
Customers.CustomerID
,Customers.CompanyName
,TotalOrderAmount = SUM(Quantity * UnitPrice)
From Customers
Join Orders
on Orders.CustomerID = Customers.CustomerID
Join [Order Details]
on Orders.OrderID = [Order Details].OrderID
Where
OrderDate >= 2016-01-01
Group by
Customers.CustomerID, Customers.CompanyName
)
Select
CustomerID,
CompanyName,
TotalOrderAmount,
CustomerGroup =
Case
when TotalOrderAmount between 0 and 1000 then 'Low'
when TotalOrderAmount between 1001 and 5000 then 'Medium'
when TotalOrderAmount between 5001 and 10000 then 'High'
when TotalOrderAmount > 10000 then 'Very High'
End
from Orders2016
Order by CustomerID