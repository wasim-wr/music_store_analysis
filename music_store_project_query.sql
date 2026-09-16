-- SQL PROJECT- MUSIC STORE DATA ANALYSIS
-- Question Set 1 - Easy
-- 1. Who is the senior most employee based on job title?

select 
	first_name,
	last_name,
	levels
from employee
order by levels desc
limit 1

-- 2. Which countries have the most Invoices?
select 
	billing_country,
	count(invoice_id) as most_inv
from invoice
group by billing_country
order by most_inv desc


-- 3. What are top 3 values of total invoice?
select * from 
invoice
order by total desc
limit 3

-- 4. Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals
select 
	billing_city, sum(total) as highest_sum
from  invoice
group by billing_city
order by highest_sum desc
limit 1

-- 5. Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money
select
	c.customer_id, c.first_name, c.last_name,
			inv.billing_city,
		sum(inv.total)as higest_sum
from customer c
left join invoice inv 
on c.customer_id = inv.customer_id 
group by c.customer_id, inv.billing_city
order by higest_sum desc
limit 1
-- Question Set 2 – Moderate
-- 1. Write query to return the email, first name, last name, & Genre of all Rock Music listeners.
-- Return your list ordered alphabetically by email starting with A
select distinct c.first_name, c.last_name, c.email 
from customer c
join invoice inv on c.customer_id = inv.customer_id
join invoice_line inv_line on inv.invoice_id = inv_line.invoice_id
where track_id IN(
select track_id from track t
join genre g on t.genre_id = g.genre_id
where g.name = 'Rock' and c.email like '%a')
order by c.email 

-- 2. Let's invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the Artist name and total track count of the top 10 rock bands

select a.artist_id ,a.name, count(a.artist_id) as num_of_songs
from artist a
join album al on a.artist_id = al.artist_id
join track t on al.album_id = t.album_id
join genre g on t.genre_id = g.genre_id
where g.name = 'Rock'
group by a.artist_id
order by num_of_songs desc
limit 10


-- 3. Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first
select name, milliseconds as time_length_of_songs
from track
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc



-- Question Set 3 – Advance
-- 1. Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent
select a.artist_id ,a.name, count(a.artist_id) as num_of_songs
from artist a
join album al on a.artist_id = al.artist_id
join track t on al.album_id = t.album_id
join genre g on t.genre_id = g.genre_id
where g.name = 'Rock'
group by a.artist_id
order by num_of_songs desc
limit 10

-- 3. Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first
select name, milliseconds as time_length_of_songs
from track
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc

-- Question Set 3 - Advance
-- 1. Find how much amount spent by each customer on artists? Write a query to return customer name,
--  artist name and total spent
with best_selling_artist as (
	select artist.artist_id as artist_id, artist.name as artist_name, sum(invoice_line.unit_price * invoice_line.quantity) as total_spent
	from invoice_line 
	join track  on track.track_id = invoice_line.track_id
	join album on album.album_id = track.album_id
	join artist  on artist.artist_id = album.artist_id
	group by 1
	order by 3 desc
	limit 1
)
select c.customer_id, c.first_name, c.last_name, bsa.artist_name, sum(il.unit_price * il.quantity) as total_spent
from invoice inv
join customer c  on c.customer_id = inv.customer_id
join invoice_line il on il.invoice_id = inv.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by 1, 2, 3, 4
order by 5 desc

-- 2. We want to find out the most popular music Genre for each country.
-- We determine the most popular genre as the genre with the highest amount of purchases.
-- Write a query that returns each country along with the top Genre. 
-- For countries where the maximum number of purchases is shared return all Genres

with popular_genre as(
select 
	count(invoice_line.quantity) as purchase, 
	customer.country, 
	genre.name, 
	genre.genre_id
	,row_number() over(partition by customer.country order by count(invoice_line.quantity) desc ) as row_num
from invoice_line
join invoice on invoice.invoice_id = invoice_line.invoice_id
join customer on customer.customer_id = invoice.customer_id
join track on track.track_id = invoice_line.track_id
join genre on genre.genre_id = track.genre_id
group by 2, 3, 4
order by  2 asc, 1 desc
)
select * 
from popular_genre
where row_num <= 1

-- 3. Write a query that determines the customer that has spent the most on music for each country.
-- Write a query that returns the country along with the top customer and how much they spent. 
-- For countries where the top amount spent is shared, provide all customers who spent this amount

select 
customer.customer_id, 
customer.first_name, 
customer.last_name, 
customer.country,
sum(invoice_line.unit_price * invoice_line.quantity) as amount_spent
from invoice_line
join invoice on invoice.invoice_id = invoice_line.invoice_id
join customer on customer.customer_id = invoice.customer_id
group by 1, 2, 3, 4
order by 5 desc

















