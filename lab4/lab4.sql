SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS city CASCADE;
DROP TABLE IF EXISTS route CASCADE;
DROP TABLE IF EXISTS year CASCADE;
DROP TABLE IF EXISTS weekday CASCADE;
DROP TABLE IF EXISTS weekly_schedule CASCADE;
DROP TABLE IF EXISTS flight CASCADE;
DROP TABLE IF EXISTS reservation CASCADE;
DROP TABLE IF EXISTS booking CASCADE;
DROP TABLE IF EXISTS passenger CASCADE;
DROP TABLE IF EXISTS contact CASCADE;
DROP TABLE IF EXISTS card CASCADE;
DROP TABLE IF EXISTS reserved_passenger CASCADE;
SET FOREIGN_KEY_CHECKS=1;

DROP PROCEDURE IF EXISTS addYear;
DROP PROCEDURE IF EXISTS addDay;
DROP PROCEDURE IF EXISTS addDestination;
DROP PROCEDURE IF EXISTS addRoute;
DROP PROCEDURE IF EXISTS addFlight;

SELECT 'Creating tables' AS 'Message';

CREATE TABLE city
	(airport_code VARCHAR(3),
	 airport_name VARCHAR(30),
     country VARCHAR(30),
     city_name VARCHAR(30),
     CONSTRAINT pk_city PRIMARY KEY(airport_code)) ENGINE=InnoDB;
     
CREATE TABLE route
	(route_id INT AUTO_INCREMENT,
     route_price DOUBLE,
     airport_code_dept VARCHAR(3),
     airport_code_arr VARCHAR(3),
     year INT,
     CONSTRAINT pk_route PRIMARY KEY(route_id, year)) ENGINE=InnoDB;
     
CREATE TABLE year
	(year INT,
     year_factor double,
     CONSTRAINT pk_year PRIMARY KEY(year)) ENGINE=InnoDB;
     
CREATE TABLE weekday
	(id INT AUTO_INCREMENT NOT NULL,
     weekday_factor DOUBLE,
     year int,
     name VARCHAR(10),
     CONSTRAINT pk_weekday PRIMARY KEY(id, year)) ENGINE=InnoDB;
     
CREATE TABLE weekly_schedule
	(schedule_id INT AUTO_INCREMENT,
     weekday_id INT,
     route INT,
     time_of_dept TIME,
     CONSTRAINT pk_weekly_schedule PRIMARY KEY(schedule_id)) ENGINE=InnoDB;
     
CREATE TABLE flight
	(flight_num INT AUTO_INCREMENT,
     week_num INT,
     weekly_flight INT,
     CONSTRAINT pk_flight PRIMARY KEY(flight_num)) ENGINE=InnoDB;
     
CREATE TABLE reservation
	(reservation_num INT AUTO_INCREMENT,
	 num_of_seats INT,
     flight_num INT,
     contact INT,
     CONSTRAINT pk_reservation PRIMARY KEY(reservation_num)) ENGINE=InnoDB;
     
CREATE TABLE booking
	(booking_id INT,
     price DOUBLE,
     card_num BIGINT,
     CONSTRAINT pk_booking PRIMARY KEY(booking_id)) ENGINE=InnoDB;
     
CREATE TABLE passenger
	(passport_num INT,
     first_name VARCHAR(99),
     last_name VARCHAR(99),
     CONSTRAINT pk_passenger PRIMARY KEY(passport_num)) ENGINE=InnoDB;
     
CREATE TABLE contact
	(passport_num INT,
     phone_num BIGINT,
     email VARCHAR(99),
     CONSTRAINT pk_contact PRIMARY KEY(passport_num)) ENGINE=InnoDB;
     
CREATE TABLE card
	(card_num BIGINT,
     holder_first_name VARCHAR(99),
     holder_last_name VARCHAR(99),
     CONSTRAINT pk_card PRIMARY KEY(card_num)) ENGINE=InnoDB;
     
CREATE TABLE reserved_passenger
	(reservation_num INT,
     passport_num INT,
     ticket_num INT,
     CONSTRAINT pk_reserved_passenger PRIMARY KEY(reservation_num, passport_num)) ENGINE=InnoDB;
     
SELECT 'Creating foreign keys' AS 'Message';

ALTER TABLE route ADD CONSTRAINT fk_route_dept FOREIGN KEY (airport_code_dept) REFERENCES city(airport_code);
ALTER TABLE route ADD CONSTRAINT fk_route_arr FOREIGN KEY (airport_code_arr) REFERENCES city(airport_code);
ALTER TABLE route ADD CONSTRAINT fk_route_year FOREIGN KEY (year) REFERENCES year(year);

ALTER TABLE weekday ADD CONSTRAINT fk_weekday_year FOREIGN KEY (year) REFERENCES year(year);

ALTER TABLE weekly_schedule ADD CONSTRAINT fk_weekly_schedule_weekday FOREIGN KEY (weekday_id) REFERENCES weekday(id);
ALTER TABLE weekly_schedule ADD CONSTRAINT fk_weekly_schedule_route FOREIGN KEY (route) REFERENCES route(route_id);

ALTER TABLE flight ADD CONSTRAINT fk_flight_weekly FOREIGN KEY (weekly_flight) REFERENCES weekly_schedule(schedule_id);

ALTER TABLE reservation ADD CONSTRAINT fk_reservation_flight FOREIGN KEY (flight_num) REFERENCES flight(flight_num);
ALTER TABLE reservation ADD CONSTRAINT fk_reservation_contact FOREIGN KEY (contact) REFERENCES contact(passport_num);

ALTER TABLE booking ADD CONSTRAINT fk_booking_id FOREIGN KEY (booking_id) REFERENCES reservation(reservation_num);
ALTER TABLE booking ADD CONSTRAINT fk_booking_card FOREIGN KEY (card_num) REFERENCES card(card_num);

ALTER TABLE contact ADD CONSTRAINT fk_contact_passport FOREIGN KEY (passport_num) REFERENCES passenger(passport_num);

ALTER TABLE reserved_passenger ADD CONSTRAINT fk_reserved_passenger_reservation_num FOREIGN KEY (reservation_num) REFERENCES reservation(reservation_num);
ALTER TABLE reserved_passenger ADD CONSTRAINT fk_reserved_passenger_passport_num FOREIGN KEY (passport_num) REFERENCES passenger(passport_num);

SELECT 'Creating procedures' AS 'Message';

delimiter //
CREATE PROCEDURE addYear(IN year INT , IN year_factor DOUBLE)
BEGIN
INSERT INTO year VALUES (year, year_factor);
END;
//

CREATE PROCEDURE addDay(IN year INT , IN name VARCHAR(10), IN weekday_factor DOUBLE)
BEGIN
	INSERT INTO weekday (year , name, weekday_factor) VALUES (year, name, weekday_factor);
END;
//

CREATE PROCEDURE addDestination(IN airport_code VARCHAR(3), IN airport_name VARCHAR(30), IN country VARCHAR(30), IN city_name VARCHAR(30))
BEGIN
	INSERT INTO city VALUES (airport_code, airport_name, country, city_name);
END;
//

CREATE PROCEDURE addRoute(IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(3), IN year INT, IN route_price DOUBLE)
BEGIN
	INSERT INTO route (route_price, airport_code_dept, airport_code_arr, year) VALUES (route_price, departure_airport_code, arrival_airport_code, year);
END;
//

CREATE PROCEDURE addFlight(IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(3), IN flight_year INT, IN day_id INT, IN departure_time TIME)
BEGIN
	DECLARE route VARCHAR(3);
    DECLARE week INT default 1;
    SELECT route_id FROM route WHERE airport_code_dept = departure_airport_code AND airport_code_arr = arrival_airport_code AND year=flight_year INTO route;
	INSERT INTO weekly_schedule (weekday_id, route, time_of_dept) VALUES (day_id, route, departure_time);
    
    REPEAT 
		INSERT INTO flight (week_num, weekly_flight) VALUES (week, day_id);
        SET week = week + 1;
	UNTIL week = 53
    END REPEAT;
END;

/* TEST SCRIPT TASK 3 */
/*
SELECT "Testing questions for flight addition procedures, i.e. question 3" as "Message";
SELECT "Expected output for all queries are 'Query OK, 1 row affected (0.00 sec)' (where the time might differ)" as "Message";
*/
/*Fill the database with data */

/*Fill the database with data */
SELECT "Trying to add 2 years" AS "Message";
CALL addYear(2010, 2.3);
CALL addYear(2011, 2.5);
SELECT "Trying to add 4 days" AS "Message";
CALL addDay(2010,"Monday",1);
CALL addDay(2010,"Tuesday",1.5);
CALL addDay(2011,"Saturday",2);
CALL addDay(2011,"Sunday",2.5);
SELECT "Trying to add 2 destinations" AS "Message";
CALL addDestination("MIT","Minas Tirith Airport","Mordor","Minas Tirith");
CALL addDestination("HOB","Hobbiton Airport","The Shire", "Hobbiton");

SELECT "Trying to add 4 routes" AS "Message";
CALL addRoute("MIT","HOB",2010,2000);
CALL addRoute("HOB","MIT",2010,1600);
CALL addRoute("MIT","HOB",2011,2100);
CALL addRoute("HOB","MIT",2011,1500);

SELECT "Trying to add 4 weeklyschedule flights" AS "Message";
CALL addFlight("MIT","HOB", 2010, 1, "09:00:00");
CALL addFlight("HOB","MIT", 2010, 2, "10:00:00");
CALL addFlight("MIT","HOB", 2011, 3, "11:00:00");
CALL addFlight("HOB","MIT", 2011, 4, "12:00:00");


/*
SELECT "You are now supposed to have 208 flights in your database. If so, and with reasonable data, it is probably correct and this is further tested for question 7" as "Message";
*/

CREATE PROCEDURE calculateFreeSeats(IN flightnumber int)
BEGIN
	DECLARE free_seats INT;
	SELECT sum(num_of_seats) FROM reservation WHERE flight_num=flightnumber AS reserved_seats;
    SET free_seats = 40 - reserved_seats;
    /* 40 passengers /*
    /* kanske måste kolla på något med att ticker_num = NULL för att ej blanda ihop reservationer och bokningar */
END;