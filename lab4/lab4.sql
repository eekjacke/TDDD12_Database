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
DROP FUNCTION IF EXISTS calculateFreeSeats;
DROP FUNCTION IF EXISTS calculatePrice;
DROP PROCEDURE IF EXISTS addReservation;
DROP PROCEDURE IF EXISTS addPassenger;
DROP PROCEDURE IF EXISTS addContact;
DROP PROCEDURE IF EXISTS addPayment;

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
     holder_first_name VARCHAR(30),
     holder_last_name VARCHAR(30),
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
//

CREATE FUNCTION calculateFreeSeats(flightnumber INT) RETURNS INT
BEGIN
	DECLARE free_seats INT;
    DECLARE booked_seats INT;

    SELECT sum(num_of_seats) FROM reservation WHERE reservation_num IN
		(SELECT booking_id FROM booking) AND flight_num=flightnumber INTO booked_seats;
    
    SET free_seats = 40 - booked_seats;
    RETURN free_seats;
    /* 40 passengers */
    /* kanske måste kolla på något med att ticker_num = NULL för att ej blanda ihop reservationer och bokningar */
END;
//

CREATE FUNCTION calculatePrice(flightnumber INT) RETURNS DOUBLE
BEGIN
	DECLARE routeprice DOUBLE;
    DECLARE weekdayfactor DOUBLE;
    DECLARE freeseats INT;
    DECLARE bookedseats INT;
    DECLARE profitfactor DOUBLE;
    DECLARE total_price DOUBLE;
    
	SELECT route_price FROM route WHERE route_id IN
		(SELECT route FROM weekly_schedule WHERE schedule_id IN 
			(SELECT weekly_flight FROM flight WHERE flight_num = flightnumber)) INTO routeprice;
            
	SELECT weekday_factor FROM weekday WHERE id IN
		(SELECT weekday_id FROM weekly_schedule WHERE schedule_id IN
			(SELECT weekly_flight FROM flight WHERE flight_num = flightnumber)) INTO weekdayfactor;
            
    SELECT year_factor FROM year WHERE year IN    
		(SELECT year FROM weekday WHERE id IN
			(SELECT weekday_id FROM weekly_schedule WHERE schedule_id IN
				(SELECT weekly_flight FROM flight WHERE flight_num = flightnumber))) INTO profitfactor;
                
	SELECT calculateFreeSeats(flightnumber) INTO freeseats;
    SET bookedseats = 40 - freeseats;
    
    SET total_price = routeprice*weekdayfactor*((bookedseats+1)/40)*profitfactor;
    RETURN total_price;
END;
//

CREATE PROCEDURE addReservation(IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(3), IN year INT, IN week INT, IN day VARCHAR(10), IN time TIME, IN number_of_passengers INT, OUT output_reservation_nr INT)
BEGIN
	DECLARE flight_number INT;
    DECLARE free_seats INT;
    SELECT flight_num FROM flight WHERE weekly_flight IN 
		(SELECT schedule_id FROM weekly_schedule WHERE route IN
			(SELECT route_id FROM route WHERE airport_code_dept = departure_airport_code AND airport_code_arr = arrival_airport_code))
            
		AND weekly_flight IN (SELECT schedule_id FROM weekly_schedule WHERE weekday_id IN
			(SELECT id FROM weekday WHERE name = day AND weekday.year=year))
            
		AND weekly_flight IN (SELECT schedule_id FROM weekly_schedule where time_of_dept = time)
        
        AND flight.week_num = week
        
        INTO flight_number;
        
    IF flight_number = NULL
    THEN SELECT 'Flight doesnt exist' AS 'Message';
    ELSEIF calculateFreeSeats(flight_number) < number_of_passengers 
	THEN SELECT 'No free seats left' AS 'Message';
    ELSE INSERT INTO reservation (num_of_seats, flight_num) values (number_of_passengers, flight_number);
    END IF;
    
	SELECT last_insert_id() INTO output_reservation_nr;
END;
//

CREATE PROCEDURE addPassenger(IN reservation_number INT, IN passport_number INT, IN first_name VARCHAR(30), IN last_name VARCHAR(30))
BEGIN
	IF NOT EXISTS (SELECT * FROM passenger WHERE passenger.passport_num = passport_number)
    THEN INSERT INTO passenger(passport_num, first_name, last_name) VALUES (passport_number, first_name, last_name);
    END IF;
    INSERT INTO reserved_passenger (reservation_num, passport_num) VALUES (reservation_number, passport_number);
END;
//

CREATE PROCEDURE addContact(IN reservation_number INT, IN passport_number INT, IN email VARCHAR(30), IN phone BIGINT)
BEGIN
	IF NOT EXISTS (SELECT* FROM reserved_passenger WHERE reservation_num=reservation_number AND passport_num = passport_number)
    THEN SELECT 'The person is not added as a passenger to the reservation' AS 'Message';
    ELSE INSERT INTO contact (passport_num, phone_num, email) VALUES (passport_number, phone, email);
    END IF;
END;
//

CREATE PROCEDURE addPayment(IN reservation_number INT , IN cardholder_firstname VARCHAR(30), IN cardholder_lastname VARCHAR(30), IN credit_card_number BIGINT)
BEGIN
	DECLARE flight_number INT;
    SELECT flight_num FROM reservation WHERE reservation_num = reservation_number INTO flight_number;
    
	IF (SELECT contact FROM reservation WHERE reservation_num = reservation_number) = NULL
    THEN SELECT 'There is no contact for this reservation' AS 'Message';
    ELSEIF calculateFreeSeats(flight_number) < number_of_passengers 
	THEN SELECT 'No free seats left' AS 'Message';
    ELSE INSERT INTO card (card_num, holder_first_name, holder_last_name) VALUES (credit_card_number, cardholder_firstname, cardholder_lastname);
		 INSERT INTO booking (booking_id, price, card_num) VALUES (reservation_number, calculatePrice(flight_number), credit_card_number);
		 INSERT INTO reserved_passenger(ticket_num) VALUES (rand());
    END IF;
END;
//

/******************************************************************************************
 Question 7, Correct representation in the view.
 This is a test script that tests that the interface of the BryanAir back-end works
 correctly. More specifically it tests that flights and reservations are added correctly and
 that the number of seats and price is calculated correctly. This is done by checking against a 
 previous (correct) response to the query from an external database. 
**********************************************************************************************/

SELECT "Checking that bookings and flights are added correctly by checking the view" as "Message";
/*Fill the database with flights */
SELECT "Step1, fill the database with flights" AS "Message";
CALL addYear(2010, 2.3);
CALL addYear(2011, 2.5);
CALL addDay(2010,"Monday",1);
CALL addDay(2010,"Tuesday",1.5);
CALL addDay(2011,"Saturday",2);
CALL addDay(2011,"Sunday",2.5);
CALL addDestination("MIT","Minas Tirith","Mordor");
CALL addDestination("HOB","Hobbiton","The Shire");
CALL addRoute("MIT","HOB",2010,2000);
CALL addRoute("HOB","MIT",2010,1600);
CALL addRoute("MIT","HOB",2011,2100);
CALL addRoute("HOB","MIT",2011,1500);
CALL addFlight("MIT","HOB", 2010, "Monday", "09:00:00");
CALL addFlight("HOB","MIT", 2010, "Tuesday", "10:00:00");
CALL addFlight("MIT","HOB", 2011, "Sunday", "11:00:00");
CALL addFlight("HOB","MIT", 2011, "Sunday", "12:00:00");

SELECT "Step2, add a bunch of bookings to the flights" AS "Message";
CALL addReservation("MIT","HOB",2010,1,"Monday","09:00:00",3,@a); 
CALL addPassenger(@a,00000001,"Frodo Baggins"); 
CALL addContact(@a,00000001,"frodo@magic.mail",080667989); 
CALL addPassenger(@a,00000002,"Sam Gamgee"); 
CALL addPassenger(@a,00000003,"Merry Pippins");
CALL addPayment (@a, "Gandalf", 6767); 
CALL addReservation("MIT","HOB",2010,1,"Monday","09:00:00",3,@b); 
CALL addPassenger(@b,00000011,"Nazgul1"); 
CALL addContact(@b,00000011,"Nazgul@darkness.mail",666); 
CALL addPassenger(@b,00000012,"Nazgul2"); 
CALL addPassenger(@b,00000013,"Nazgul3");
CALL addPayment (@b, "Saruman", 6868); 

SELECT "Step3, check that the results are correct. If so the next query should return the empty set. If any line is returned then this is either missing, incorrect or additional to what the database should contain" AS "Message";
SELECT departure_city_name, destination_city_name, departure_time, departure_day,departure_week, departure_year, nr_of_free_seats, current_price_per_seat
FROM (
SELECT departure_city_name, destination_city_name, departure_time, departure_day,departure_week, departure_year, nr_of_free_seats, current_price_per_seat FROM allFlights
UNION ALL
SELECT departure_city_name, destination_city_name, departure_time, departure_day,departure_week, departure_year, nr_of_free_seats, current_price_per_seat FROM TDDD37.Question7CorrectResult
) res
GROUP BY departure_city_name, destination_city_name, departure_time, departure_day,departure_week, departure_year, nr_of_free_seats, current_price_per_seat
HAVING count(*) = 1;



