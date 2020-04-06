/*
Lab 1 report <Student_names and liu_id>
*/

/* All non code should be within SQL-comments like this */ 


/*
Drop all user created tables that have been created when solving the lab
*/

DROP TABLE IF EXISTS custom_table CASCADE;


/* Have the source scripts in the file so it is easy to recreate!*/

SOURCE company_schema.sql;
SOURCE company_data.sql;

/* LAB 1, Jacob Eek (jacee719) Gustav Yngemo (gusda320) */

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

# PERHAPS COULD CREATE TWO VIEWS INSTEAD, AND LATER INNER JOIN THEM.
/* Task 14 */
CREATE TABLE tmp
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

INSERT INTO tmp 
SELECT * 
FROM jbitem
WHERE price < (SELECT AVG(price) from jbitem);

SELECT * from tmp;

/* Task 15 */
CREATE OR REPLACE VIEW task15
AS SELECT *
FROM jbitem
WHERE price < (SELECT AVG(price) from jbitem);

SELECT * 
FROM task15;
/* Task 16 */
# WRITE DIFFERENCE BETWEEN TABLE AND VIEW HERE
/* Task 17 */
CREATE OR REPLACE VIEW task17(debit, total)
AS SELECT jbsale.debit, SUM(jbitem.price*jbsale.quantity)
FROM jbitem, jbsale
WHERE jbsale.item = jbitem.id
GROUP BY jbsale.debit;

SELECT * FROM task17;
/* Task 18 */

/* Task 19 */
# GENERAL PROBLEM WITH SOLUTION: ERROR CODE 1175. IS IT OKAY TO DISABLE SAFE UPDATE MODE?
# ALSO, WHY IS ERROR CODE 1175 SHOWING UP FOR THE FIRST QUERY? item IS A PRIMARY KEY OF jbsale???

# Firstly: Have to delete rows in jbsale referencing jbitem

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
			
# Secondly: Have to delete rows in jbitem referencing jbsupplier

DELETE FROM jbitem
WHERE supplier IN
				(SELECT id 
                FROM jbsupplier
                WHERE city IN
							(SELECT id
                            FROM jbcity
                            WHERE name = 'Los Angeles'));
                            
# Lastly: Delete rows in jbsupplier located in Los Angeles

DELETE FROM jbsupplier
WHERE city IN
			(SELECT id
            FROM jbcity
            WHERE name = 'Los Angeles');

/* Task 20 */