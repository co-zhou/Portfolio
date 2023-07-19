DROP DATABASE IF EXISTS rail;
CREATE DATABASE rail;
USE rail;

CREATE TABLE users (
	id INT AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL
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
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (route_id) REFERENCES routes(id)
);


CREATE VIEW view_all_users AS
SELECT
	users.id AS No,
  CONCAT(first_name, ' ', last_name) AS Name,
  IFNULL(departure.location_name, 'N/A') AS Departure,
  IFNULL(arrival.location_name, 'N/A') AS Arrival,
  IFNULL(departure_datetime, 'N/A') AS 'Departure Time',
  IFNULL(arrival_datetime, 'N/A') AS 'Arrival Time',
  IFNULL(price, 0.00) AS Price
FROM users
LEFT JOIN user_routes
  ON users.id = user_routes.user_id
LEFT JOIN routes
  ON routes.id = user_routes.route_id
LEFT JOIN locations AS departure
  ON routes.departure_id = departure.id
LEFT JOIN locations AS arrival
  ON routes.arrival_id = arrival.id;

CREATE VIEW view_all_routes AS
SELECT
  routes.id AS No,
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
