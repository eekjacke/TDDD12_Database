/******************************************************************************************
 Question 10, concurrency
 This is the second of two scripts that tests that the BryanAir database can handle concurrency.
 This script sets up a valid reservation and tries to pay for it in such a way that at most 
 one such booking should be possible (or the plane will run out of seats). This script should 
 be run in both terminals, in parallel. 
**********************************************************************************************/
SELECT "Testing script for Question 10, Adds a booking, should be run in both terminals" as "Message";
SELECT "Adding a reservations and passengers" as "Message";

CALL addReservation("MIT","HOB",2010,1,"Monday","09:00:00",21,@a); 
CALL addPassenger(@a,00000001,"Saru","man");
CALL addPassenger(@a,00000002,"Orch","1");
CALL addPassenger(@a,00000003,"Orch","2");
CALL addPassenger(@a,00000004,"Orch","3");
CALL addPassenger(@a,00000005,"Orch","4");
CALL addPassenger(@a,00000006,"Orch","5");
CALL addPassenger(@a,00000007,"Orch","6");
CALL addPassenger(@a,00000008,"Orch","7");
CALL addPassenger(@a,00000009,"Orch","8");
CALL addPassenger(@a,00000010,"Orch","9");
CALL addPassenger(@a,00000011,"Orch","10");
CALL addPassenger(@a,00000012,"Orch","11");
CALL addPassenger(@a,00000013,"Orch","12");
CALL addPassenger(@a,00000014,"Orch","13");
CALL addPassenger(@a,00000015,"Orch","14");
CALL addPassenger(@a,00000016,"Orch","15");
CALL addPassenger(@a,00000017,"Orch","16");
CALL addPassenger(@a,00000018,"Orch","17");
CALL addPassenger(@a,00000019,"Orch","18");
CALL addPassenger(@a,00000020,"Orch","19");
CALL addPassenger(@a,00000021,"Orch","20");
CALL addContact(@a,00000001,"saruman@magic.mail",080667989); 

SELECT SLEEP(5);
SELECT "Making payment, supposed to work for one session and be denied for the other" as "Message";

LOCK TABLES reservation WRITE, flight READ,  booking WRITE, weekly_schedule READ, route READ, weekday READ, year READ,  card WRITE, reserved_passenger WRITE;
CALL addPayment (@a, "Sau","ron",7878787878);
UNLOCK TABLES;
SELECT "Nr of free seats on the flight (should be 19 if no overbooking occured, otherwise -2): " as "Message", (SELECT nr_of_free_seats from allFlights where departure_week = 1) as "nr_of_free_seats";

