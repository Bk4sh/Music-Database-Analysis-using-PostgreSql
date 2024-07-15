-- Who is the senior most employee based on job title?
select
	title, last_name, first_name, levels
from employees
order by levels desc
limit 1;


-- Which countries have the most Invoices?
select
	billing_country, count(invoice_id) as total_invoices
from invoices
group by billing_country
order by count(invoice_id) desc
limit 1;


-- What are top 3 values of total invoice?
select 
	* 
from invoices 
order by total desc 
limit 3;


-- Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice totals.
-- Return both the city name & sum of all invoice totals
select
	billing_city, sum(total) as total_revenue
from invoices
group by billing_city
order by sum(total) desc
limit 1;


-- Who is the best customer? The customer who has spent the most money will be declared the best customer. 
-- Write a query that returns the person who has spent the most money.
select
	c.customer_id, c.first_name, c.last_name, sum(total) as total_spent
from invoices i
join customers c on i.customer_id = c.customer_id
group by c.customer_id, c.first_name, c.last_name
order by sum(total) desc
limit 1;


-- Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A.
with RockTracks as (
    select
        tracks.track_id, tracks.genre_id, genres.name
    from tracks
    join genres on tracks.genre_id = genres.genre_id
    where genres.name ilike 'rock'
)
select
    distinct customers.first_name, customers.last_name, customers.email, RockTracks.name
from customers 
join invoices on customers.customer_id = invoices.customer_id
join invoice_lines on invoices.invoice_id = invoice_lines.invoice_id
join RockTracks on invoice_lines.track_id = RockTracks.track_id
order by email;


-- Let's invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the Artist name and total track count of the top 10 rock bands.
select
	artists.name, count(tracks.track_id) as total_tracks
from artists
join albums on artists.artist_id = albums.artist_id
join tracks on albums.album_id = tracks.album_id
join genres on tracks.genre_id = genres.genre_id
where genres.name ilike 'rock'
group by artists.name
order by count(tracks.track_id) desc
limit 10;


-- Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.
select
	name, milliseconds
from tracks
where milliseconds > (select avg(milliseconds) from tracks)
order by milliseconds desc;


-- Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent.
select
	invoices.customer_id, customers.first_name, customers.last_name,
	artists.name as artists, sum(invoice_lines.unit_price * invoice_lines.quantity) as total_spent
from tracks
join invoice_lines on tracks.track_id = invoice_lines.track_id
join albums on tracks.album_id = albums.album_id
join artists on albums.artist_id = artists.artist_id
join invoices on invoice_lines.invoice_id = invoices.invoice_id
join customers on invoices.customer_id = customers.customer_id
group by invoices.customer_id, customers.first_name, customers.last_name, artists.artist_id, artists.name
order by invoices.customer_id, sum(invoice_lines.unit_price * invoice_lines.quantity) desc;


-- We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
-- with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
-- the maximum number of purchases is shared return all Genres.
with CountryGenrePurchasesRank as (
	select
		customers.country, genres.name, count(invoice_lines.invoice_line_id) as total_purchases,
		dense_rank() over(partition by customers.country order by count(invoice_lines.invoice_line_id) desc) as ranking
	from invoice_lines
	join invoices on invoice_lines.invoice_id = invoices.invoice_id
	join customers on invoices.customer_id = customers.customer_id
	join tracks on invoice_lines.track_id = tracks.track_id
	join genres on tracks.genre_id = genres.genre_id
	group by 1, 2
)
select
	country, name as genre, total_purchases
from CountryGenrePurchasesRank where ranking = 1;


-- Write a query that determines the customer that has spent the most on music for each country. 
-- Write a query that returns the country along with the top customer and how much they spent. 
-- For countries where the top amount spent is shared, provide all customers who spent this amount.
WITH CustomerTotalSpent AS (
	SELECT
		customer_id, SUM(total) AS total_spent
	FROM invoices
	GROUP BY customer_id
),
TopSpendingCustomersByCountry AS (
	SELECT
		customers.customer_id, customers.first_name, customers.last_name,
		customers.country, CustomerTotalSpent.total_spent,
		DENSE_RANK() OVER(PARTITION BY country ORDER BY total_spent DESC) AS ranking
	FROM CustomerTotalSpent
	JOIN customers ON CustomerTotalSpent.customer_id = customers.customer_id
)
SELECT
	country, first_name, last_name, total_spent
FROM TopSpendingCustomersByCountry
WHERE ranking = 1;