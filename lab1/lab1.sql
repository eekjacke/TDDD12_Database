/*
 LAB 1, Jacob Eek (jacee719) Gustav Yngemo (gusda320) 
*/

/* All non code should be within SQL-comments like this */ 


/*
Drop all user created tables that have been created when solving the lab
*/

DROP TABLE IF EXISTS task14 CASCADE;
DROP VIEW IF EXISTS task15 CASCADE;
DROP VIEW IF EXISTS task17 CASCADE;
DROP VIEW IF EXISTS v1 CASCADE;
DROP VIEW IF EXISTS v2 CASCADE;
DROP VIEW IF EXISTS jbsale_supply CASCADE;

/* Have the source scripts in the file so it is easy to recreate!*/

/* SOURCE OUTCOMMENTED SINCE IT DOESN'T WORK IN MYSQL WORKBENCH */
/* SOURCE company_schema.sql; /*
/* SOURCE company_data.sql; /*


/* Task 1 */
SELECT * FROM jbemployee;

/* Task 2 */
SELECT * FROM jbdept ORDER BY name ASC;

/* Task 3 */
SELECT * FROM jbparts WHERE qoh = 0;

/* Task 4 */
SELECT * FROM jbemployee WHERE salary >= 9000 AND salary <= 10000;

/* Task 5 */
SELECT name, startyear-birthyear FROM jbemployee;

/* Task 6 */
SELECT * FROM jbemployee WHERE name LIKE "%son,%";

/* Task 7 */
SELECT * FROM jbitem WHERE supplier = (SELECT id from jbsupplier WHERE name = 'Fisher-Price');

/* Task 8 */
SELECT * 
FROM jbitem, jbsupplier 
WHERE jbitem.supplier = jbsupplier.id
AND jbsupplier.name = 'Fisher-Price';

/* Task 9 */
SELECT * from jbcity WHERE id IN (SELECT city FROM jbsupplier);  

/* Task 10 */
SELECT name, color FROM jbparts WHERE weight > (SELECT weight FROM jbparts WHERE id=11);

/* Task 11 */

SELECT part1.name, part1.color 
FROM jbparts part1, jbparts part2
WHERE part1.weight > part2.weight
AND part2.id = 11;

/* Task 12 */
SELECT AVG(weight) FROM jbparts WHERE color = 'black';

/* Task 13 */

SELECT t1.name as 'Name', t2.tweight as 'Total Weight'
FROM
(SELECT jbsupplier.name , jbsupplier.id
FROM jbsupplier
WHERE city IN (SELECT id from jbcity WHERE state = 'Mass')) as t1
INNER JOIN
(SELECT jbsupply.supplier  , SUM(jbsupply.quan*jbparts.weight) as tweight
FROM jbsupply 
Inner JOIN jbparts ON jbsupply.part = jbparts.id
GROUP BY supplier)
as t2
ON t1.id = t2.supplier;

/* Task 14 */
CREATE TABLE task14
(
	id	INT NOT NULL,
    name VARCHAR(99) NOT NULL,
    dept INT NOT NULL,
    price INT NOT NULL,
	qoh INT NOT NULL,
    supplier INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (supplier) REFERENCES jbsupplier(id),
    FOREIGN KEY (dept) REFERENCES jbdept(id)
);

INSERT INTO task14
SELECT * 
FROM jbitem
WHERE price < (SELECT AVG(price) from jbitem);

SELECT * from task14;

/* Task 15 */
CREATE OR REPLACE VIEW task15
AS SELECT *
FROM jbitem
WHERE price < (SELECT AVG(price) from jbitem);

SELECT * 
FROM task15;

/* Task 16 */
/* WRITE DIFFERENCE BETWEEN TABLE AND VIEW HERE */

/* Task 17 */
CREATE OR REPLACE VIEW task17(debit, total)
AS SELECT jbsale.debit, SUM(jbitem.price*jbsale.quantity)
FROM jbitem, jbsale
WHERE jbsale.item = jbitem.id
GROUP BY jbsale.debit;

SELECT * FROM task17;

/* Task 18 */

SELECT debit, SUM(jbitem.price*quantity) as total
FROM jbsale
INNER JOIN jbitem
ON jbitem.id = jbsale.item
GROUP BY debit;

/* Task 19a */

/* Firstly: Have to delete rows in jbsale referencing jbitem */

DELETE FROM jbsale
WHERE item IN
			(SELECT id 
             FROM jbitem
             WHERE supplier IN
							(SELECT id 
							FROM jbsupplier
                            WHERE city IN
										(SELECT id 
                                        FROM jbcity
                                        WHERE name = 'Los Angeles')));
			
/* Secondly: Have to delete rows in jbitem referencing jbsupplier */

DELETE FROM jbitem
WHERE supplier IN
				(SELECT id 
                FROM jbsupplier
                WHERE city IN
							(SELECT id
                            FROM jbcity
                            WHERE name = 'Los Angeles'));
                            
/* Lastly: Delete rows in jbsupplier located in Los Angeles */

DELETE FROM jbsupplier
WHERE city IN
			(SELECT id
            FROM jbcity
            WHERE name = 'Los Angeles');

SELECT *
FROM jbsupplier;

/* Task 19b */

/* Since we have other tables referencing jbsupplier, we have to delete the rows in those tables prior to deleting the rows in jbsupplier.alter
We have a hierarchy of jbsupplier <- jbitem <- jbsale: So firstly we have to delete all rows from jbsale containing items which have been 
supplied by a supplier based in Los Angeles
After that we have to delete all rows from jbitem containing items which have been supplied by a supplier in Los Angeles.
Finally we can delete all rows in jbsupplier containing suppliers based in Los Angeles, since we have no rows from other tables referencing these rows.

/* Task 20 */

CREATE OR REPLACE VIEW v1(supplier, item) AS
SELECT jbsupplier.name, jbitem.name
FROM jbsupplier, jbitem
WHERE jbsupplier.id = jbitem.supplier;

CREATE OR REPLACE VIEW v2(item, quantity) AS
SELECT jbitem.name, IFNULL(jbsale.quantity,0)
FROM jbitem
LEFT JOIN jbsale
ON jbitem.id = jbsale.item;

CREATE OR REPLACE VIEW jbsale_supply(supplier, quantity) AS
SELECT v1.supplier, SUM(v2.quantity)
FROM v1
LEFT JOIN v2
ON v1.item = v2.item
GROUP BY v1.supplier;

SELECT * FROM jbsale_supply_mod;



