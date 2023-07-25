DROP DATABASE IF EXISTS rail;
CREATE DATABASE rail;
USE rail;

CREATE TABLE users (
	id INT AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(60) CHARACTER SET ascii COLLATE ascii_bin NOT NULL
);

CREATE TABLE locations (
	id INT AUTO_INCREMENT PRIMARY KEY,
	location_name VARCHAR(255) NOT NULL
);

CREATE TABLE routes (
	id INT AUTO_INCREMENT PRIMARY KEY,
	departure_id INT NOT NULL,
	arrival_id INT NOT NULL,
	departure_datetime DATETIME NOT NULL,
	arrival_datetime DATETIME NOT NULL,
	price DECIMAL(4, 2) NOT NULL,
	FOREIGN KEY(departure_id) REFERENCES locations(id),
	FOREIGN KEY(arrival_id) REFERENCES locations(id),
	CONSTRAINT locations_not_eq CHECK(departure_id != arrival_id)
);

CREATE TABLE user_routes (
	user_id INT NOT NULL,
	route_id INT NOT NULL,
	PRIMARY KEY(user_id, route_id),
	FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
	FOREIGN KEY (route_id) REFERENCES routes(id)
);

CREATE VIEW view_all_routes AS
SELECT
  routes.id AS `Route No.`,
  users.id AS `User No.`,
  departure.location_name AS Departure,
  arrival.location_name AS Arrival,
  CONCAT(first_name, ' ', last_name) AS Name,
  departure_datetime AS 'Departure Time',
  arrival_datetime AS 'Arrival Time',
  price AS Price
FROM routes
LEFT JOIN user_routes
  ON routes.id = user_routes.route_id
LEFT JOIN users
  ON users.id = user_routes.user_id
LEFT JOIN locations AS departure
  ON routes.departure_id = departure.id
LEFT JOIN locations AS arrival
  ON routes.arrival_id = arrival.id;
