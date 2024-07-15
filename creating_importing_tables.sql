CREATE TABLE albums (
    album_id INT PRIMARY KEY,
    title VARCHAR(255),
    artist_id INT
);
select * from albums
order by album_id;


CREATE TABLE artists (
    artist_id INT PRIMARY KEY,
    name VARCHAR(255)
);
select * from artists
order by artist_id;


CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    company VARCHAR(100),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    phone VARCHAR(20),
    fax VARCHAR(20),
    email VARCHAR(255),
    support_rep_id INT
);
select * from customers;


CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    last_name VARCHAR(50),
    first_name VARCHAR(50),
    title VARCHAR(100),
    reports_to INT,
    levels varchar(20),
    birthdate DATE,
    hire_date DATE,
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    phone VARCHAR(20),
    fax VARCHAR(20),
    email VARCHAR(255)
);
select * from employees;


CREATE TABLE genres (
    genre_id INT PRIMARY KEY,
    name VARCHAR(100)
);
select * from genres;


CREATE TABLE invoices (
    invoice_id INT PRIMARY KEY,
    customer_id INT,
    invoice_date DATE,
    billing_address VARCHAR(255),
    billing_city VARCHAR(100),
    billing_state VARCHAR(100),
    billing_country VARCHAR(100),
    billing_postal_code VARCHAR(20),
    total FLOAT
);
select * from invoices;


CREATE TABLE invoice_lines (
    invoice_line_id INT PRIMARY KEY,
    invoice_id INT,
    track_id INT,
    unit_price FLOAT,
    quantity INT
);
select * from invoice_lines;


CREATE TABLE media_types (
    media_type_id INT PRIMARY KEY,
    name VARCHAR(100)
);
select * from media_types;


CREATE TABLE playlists (
    playlist_id INT PRIMARY KEY,
    name VARCHAR(100)
);
select * from playlists;


CREATE TABLE playlist_track (
    playlist_id INT,
    track_id INT,
    PRIMARY KEY (playlist_id, track_id),
    FOREIGN KEY (playlist_id) REFERENCES playlists(playlist_id),
    FOREIGN KEY (track_id) REFERENCES tracks(track_id)
);
select * from playlist_track;


CREATE TABLE tracks (
    track_id INT PRIMARY KEY,
    name VARCHAR(255),
    album_id INT,
    media_type_id INT,
    genre_id INT,
    composer VARCHAR(255),
    milliseconds INT,
    bytes INT,
    unit_price FLOAT,
    FOREIGN KEY (album_id) REFERENCES albums(album_id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(media_type_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);
select * from tracks;