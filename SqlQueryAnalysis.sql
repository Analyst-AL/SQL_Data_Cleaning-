select customers.customer_id,customers.first_name,orders.order_id
from customers
left outer join orders
on customers.customer_id = orders.customer_id
order by customers.customer_id
;

select customers.customer_id,customers.first_name,orders.order_id
from orders
right outer join customers
on customers.customer_id = orders.customer_id
order by customers.customer_id
;

select products.product_id,products.name,order_items.quantity
from products
left outer join order_items
on products.product_id = order_Items.product_id
order by products.product_id
;

select orders.order_date,orders.order_id,customers.first_name,shippers.name,orders.status
from customers
left outer join orders
on customers.customer_id = orders.customer_id
left join shippers
on orders.shipper_id = shippers.shipper_id
where order_date  is not null
order by customers.customer_id
;

select o.order_id,c.first_name 
from orders o
natural join customers c
;

select c.first_name, p.name
from customers c
cross join products p
order by first_name
;

select * 
from shippers
cross join products
order by shippers.name
;

select * 
from shippers,products
;

select order_id,order_date,'active' as status
from orders
where order_date >= '2019-01-01'
union all 
select order_id,order_date,'archived' as status
from orders
where order_date <= '2019-01-01'
;

select customer_id,first_name,points,'bronze' as type
from customers
WHERE points between 0 and 1999 
union all
select customer_id,first_name,points,'silver' as type
from customers
WHERE points between 2000 and 2999 
union all
select customer_id,first_name,points,'gold' as type 
from customers
WHERE points >= 3000 
ORDER BY first_name
;

SELECT  client_id,name,
	(select sum(invoice_total)
    from invoices
    where client_id = c.client_id) as total_sales,
    (select avg(invoice_total) from invoices) as average,
    (select total_sales - average) as difference
from clients c;
