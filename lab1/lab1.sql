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

/*
+ ------- + --------- + ----------- + ------------ + -------------- + -------------- +
| id      | name      | salary      | manager      | birthyear      | startyear      |
+ ------- + --------- + ----------- + ------------ + -------------- + -------------- +
| 10      | Ross, Stanley | 15908       | 199          | 1927           | 1945           |
| 11      | Ross, Stuart | 12067       |              | 1931           | 1932           |
| 13      | Edwards, Peter | 9000        | 199          | 1928           | 1958           |
| 26      | Thompson, Bob | 13000       | 199          | 1930           | 1970           |
| 32      | Smythe, Carol | 9050        | 199          | 1929           | 1967           |
| 33      | Hayes, Evelyn | 10100       | 199          | 1931           | 1963           |
| 35      | Evans, Michael | 5000        | 32           | 1952           | 1974           |
| 37      | Raveen, Lemont | 11985       | 26           | 1950           | 1974           |
| 55      | James, Mary | 12000       | 199          | 1920           | 1969           |
| 98      | Williams, Judy | 9000        | 199          | 1935           | 1969           |
| 129     | Thomas, Tom | 10000       | 199          | 1941           | 1962           |
| 157     | Jones, Tim | 12000       | 199          | 1940           | 1960           |
| 199     | Bullock, J.D. | 27000       |              | 1920           | 1920           |
| 215     | Collins, Joanne | 7000        | 10           | 1950           | 1971           |
| 430     | Brunet, Paul C. | 17674       | 129          | 1938           | 1959           |
| 843     | Schmidt, Herman | 11204       | 26           | 1936           | 1956           |
| 994     | Iwano, Masahiro | 15641       | 129          | 1944           | 1970           |
| 1110    | Smith, Paul | 6000        | 33           | 1952           | 1973           |
| 1330    | Onstad, Richard | 8779        | 13           | 1952           | 1971           |
| 1523    | Zugnoni, Arthur A. | 19868       | 129          | 1928           | 1949           |
| 1639    | Choy, Wanda | 11160       | 55           | 1947           | 1970           |
| 2398    | Wallace, Maggie J. | 7880        | 26           | 1940           | 1959           |
| 4901    | Bailey, Chas M. | 8377        | 32           | 1956           | 1975           |
| 5119    | Bono, Sonny | 13621       | 55           | 1939           | 1963           |
| 5219    | Schwarz, Jason B. | 13374       | 33           | 1944           | 1959           |
| NULL    | NULL      | NULL        | NULL         | NULL           | NULL           |
+ ------- + --------- + ----------- + ------------ + -------------- + -------------- +
26 rows
*/

/* Task 2 */
SELECT * FROM jbdept ORDER BY name ASC;

/*
+ ------- + --------- + ---------- + ---------- + ------------ +
| id      | name      | store      | floor      | manager      |
+ ------- + --------- + ---------- + ---------- + ------------ +
| 1       | Bargain   | 5          | 0          | 37           |
| 35      | Book      | 5          | 1          | 55           |
| 10      | Candy     | 5          | 1          | 13           |
| 73      | Children's | 5          | 1          | 10           |
| 43      | Children's | 8          | 2          | 32           |
| 19      | Furniture | 7          | 4          | 26           |
| 99      | Giftwrap  | 5          | 1          | 98           |
| 14      | Jewelry   | 8          | 1          | 33           |
| 47      | Junior Miss | 7          | 2          | 129          |
| 65      | Junior's  | 7          | 3          | 37           |
| 26      | Linens    | 7          | 3          | 157          |
| 20      | Major Appliances | 7          | 4          | 26           |
| 58      | Men's     | 7          | 2          | 129          |
| 60      | Sportswear | 5          | 1          | 10           |
| 34      | Stationary | 5          | 1          | 33           |
| 49      | Toys      | 8          | 2          | 35           |
| 63      | Women's   | 7          | 3          | 32           |
| 70      | Women's   | 5          | 1          | 10           |
| 28      | Women's   | 8          | 2          | 32           |
| NULL    | NULL      | NULL       | NULL       | NULL         |
+ ------- + --------- + ---------- + ---------- + ------------ +
20 rows
*/

/* Task 3 */
SELECT * FROM jbparts WHERE qoh = 0;

/*
+ ------- + --------- + ---------- + ----------- + -------- +
| id      | name      | color      | weight      | qoh      |
+ ------- + --------- + ---------- + ----------- + -------- +
| 11      | card reader | gray       | 327         | 0        |
| 12      | card punch | gray       | 427         | 0        |
| 13      | paper tape reader | black      | 107         | 0        |
| 14      | paper tape punch | black      | 147         | 0        |
| NULL    | NULL      | NULL       | NULL        | NULL     |
+ ------- + --------- + ---------- + ----------- + -------- +
5 rows

*/
/* Task 4 */
SELECT * FROM jbemployee WHERE salary >= 9000 AND salary <= 10000;

/*
+ ------- + --------- + ----------- + ------------ + -------------- + -------------- +
| id      | name      | salary      | manager      | birthyear      | startyear      |
+ ------- + --------- + ----------- + ------------ + -------------- + -------------- +
| 13      | Edwards, Peter | 9000        | 199          | 1928           | 1958           |
| 32      | Smythe, Carol | 9050        | 199          | 1929           | 1967           |
| 98      | Williams, Judy | 9000        | 199          | 1935           | 1969           |
| 129     | Thomas, Tom | 10000       | 199          | 1941           | 1962           |
| NULL    | NULL      | NULL        | NULL         | NULL           | NULL           |
+ ------- + --------- + ----------- + ------------ + -------------- + -------------- +
5 rows
*/

/* Task 5 */
SELECT name, startyear-birthyear FROM jbemployee;

/*
+ --------- + ------------------------ +
| name      | startyear-birthyear      |
+ --------- + ------------------------ +
| Ross, Stanley | 18                       |
| Ross, Stuart | 1                        |
| Edwards, Peter | 30                       |
| Thompson, Bob | 40                       |
| Smythe, Carol | 38                       |
| Hayes, Evelyn | 32                       |
| Evans, Michael | 22                       |
| Raveen, Lemont | 24                       |
| James, Mary | 49                       |
| Williams, Judy | 34                       |
| Thomas, Tom | 21                       |
| Jones, Tim | 20                       |
| Bullock, J.D. | 0                        |
| Collins, Joanne | 21                       |
| Brunet, Paul C. | 21                       |
| Schmidt, Herman | 20                       |
| Iwano, Masahiro | 26                       |
| Smith, Paul | 21                       |
| Onstad, Richard | 19                       |
| Zugnoni, Arthur A. | 21                       |
| Choy, Wanda | 23                       |
| Wallace, Maggie J. | 19                       |
| Bailey, Chas M. | 19                       |
| Bono, Sonny | 24                       |
| Schwarz, Jason B. | 15                       |
+ --------- + ------------------------ +
25 rows
*/

/* Task 6 */
SELECT * FROM jbemployee WHERE name LIKE "%son,%";

/*
+ ------- + --------- + ----------- + ------------ + -------------- + -------------- +
| id      | name      | salary      | manager      | birthyear      | startyear      |
+ ------- + --------- + ----------- + ------------ + -------------- + -------------- +
| 26      | Thompson, Bob | 13000       | 199          | 1930           | 1970           |
| NULL    | NULL      | NULL        | NULL         | NULL           | NULL           |
+ ------- + --------- + ----------- + ------------ + -------------- + -------------- +
2 rows
*/

/* Task 7 */
SELECT * FROM jbitem WHERE supplier = (SELECT id from jbsupplier WHERE name = 'Fisher-Price');

/*
+ ------- + --------- + --------- + ---------- + -------- + ------------- +
| id      | name      | dept      | price      | qoh      | supplier      |
+ ------- + --------- + --------- + ---------- + -------- + ------------- +
| 43      | Maze      | 49        | 325        | 200      | 89            |
| 107     | The 'Feel' Book | 35        | 225        | 225      | 89            |
| 119     | Squeeze Ball | 49        | 250        | 400      | 89            |
| NULL    | NULL      | NULL      | NULL       | NULL     | NULL          |
+ ------- + --------- + --------- + ---------- + -------- + ------------- +
4 rows
*/

/* Task 8 */
SELECT * 
FROM jbitem, jbsupplier 
WHERE jbitem.supplier = jbsupplier.id
AND jbsupplier.name = 'Fisher-Price';

/*
+ ------- + --------- + --------- + ---------- + -------- + ------------- + ------- + --------- + --------- +
| id      | name      | dept      | price      | qoh      | supplier      | id      | name      | city      |
+ ------- + --------- + --------- + ---------- + -------- + ------------- + ------- + --------- + --------- +
| 43      | Maze      | 49        | 325        | 200      | 89            | 89      | Fisher-Price | 21        |
| 107     | The 'Feel' Book | 35        | 225        | 225      | 89            | 89      | Fisher-Price | 21        |
| 119     | Squeeze Ball | 49        | 250        | 400      | 89            | 89      | Fisher-Price | 21        |
+ ------- + --------- + --------- + ---------- + -------- + ------------- + ------- + --------- + --------- +
3 rows
*/

/* Task 9 */
SELECT * from jbcity WHERE id IN (SELECT city FROM jbsupplier);  

/*
+ ------- + --------- + ---------- +
| id      | name      | state      |
+ ------- + --------- + ---------- +
| 10      | Amherst   | Mass       |
| 21      | Boston    | Mass       |
| 100     | New York  | NY         |
| 106     | White Plains | Neb        |
| 118     | Hickville | Okla       |
| 303     | Atlanta   | Ga         |
| 537     | Madison   | Wisc       |
| 609     | Paxton    | Ill        |
| 752     | Dallas    | Tex        |
| 802     | Denver    | Colo       |
| 841     | Salt Lake City | Utah       |
| 900     | Los Angeles | Calif      |
| 921     | San Diego | Calif      |
| 941     | San Francisco | Calif      |
| 981     | Seattle   | Wash       |
| NULL    | NULL      | NULL       |
+ ------- + --------- + ---------- +
16 rows
*/

/* Task 10 */
SELECT name, color FROM jbparts WHERE weight > (SELECT weight FROM jbparts WHERE id=11);

/*
+ --------- + ---------- +
| name      | color      |
+ --------- + ---------- +
| disk drive | black      |
| tape drive | black      |
| line printer | yellow     |
| card punch | gray       |
+ --------- + ---------- +
4 rows
*/

/* Task 11 */

SELECT part1.name, part1.color 
FROM jbparts part1, jbparts part2
WHERE part1.weight > part2.weight
AND part2.id = 11;

/*
+ --------- + ---------- +
| name      | color      |
+ --------- + ---------- +
| disk drive | black      |
| tape drive | black      |
| line printer | yellow     |
| card punch | gray       |
+ --------- + ---------- +
4 rows
*/

/* Task 12 */
SELECT AVG(weight) FROM jbparts WHERE color = 'black';

/*
+ ---------------- +
| AVG(weight)      |
+ ---------------- +
| 347.2500         |
+ ---------------- +
1 rows
*/

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

/*
+ --------- + ----------------- +
| Name      | Total Weight      |
+ --------- + ----------------- +
| Fisher-Price | 1135000           |
| DEC       | 3120              |
+ --------- + ----------------- +
2 rows
*/

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

/*
+ ------- + --------- + --------- + ---------- + -------- + ------------- +
| id      | name      | dept      | price      | qoh      | supplier      |
+ ------- + --------- + --------- + ---------- + -------- + ------------- +
| 11      | Wash Cloth | 1         | 75         | 575      | 213           |
| 19      | Bellbottoms | 43        | 450        | 600      | 33            |
| 21      | ABC Blocks | 1         | 198        | 405      | 125           |
| 23      | 1 lb Box  | 10        | 215        | 100      | 42            |
| 25      | 2 lb Box, Mix | 10        | 450        | 75       | 42            |
| 43      | Maze      | 49        | 325        | 200      | 89            |
| 106     | Clock Book | 49        | 198        | 150      | 125           |
| 107     | The 'Feel' Book | 35        | 225        | 225      | 89            |
| 118     | Towels, Bath | 26        | 250        | 1000     | 213           |
| 119     | Squeeze Ball | 49        | 250        | 400      | 89            |
| 120     | Twin Sheet | 26        | 800        | 750      | 213           |
| 165     | Jean      | 65        | 825        | 500      | 33            |
| 258     | Shirt     | 58        | 650        | 1200     | 33            |
| NULL    | NULL      | NULL      | NULL       | NULL     | NULL          |
+ ------- + --------- + --------- + ---------- + -------- + ------------- +
14 rows
*/

/* Task 15 */
CREATE OR REPLACE VIEW task15
AS SELECT *
FROM jbitem
WHERE price < (SELECT AVG(price) from jbitem);

SELECT * 
FROM task15;

/*
+ ------- + --------- + --------- + ---------- + -------- + ------------- +
| id      | name      | dept      | price      | qoh      | supplier      |
+ ------- + --------- + --------- + ---------- + -------- + ------------- +
| 11      | Wash Cloth | 1         | 75         | 575      | 213           |
| 19      | Bellbottoms | 43        | 450        | 600      | 33            |
| 21      | ABC Blocks | 1         | 198        | 405      | 125           |
| 23      | 1 lb Box  | 10        | 215        | 100      | 42            |
| 25      | 2 lb Box, Mix | 10        | 450        | 75       | 42            |
| 43      | Maze      | 49        | 325        | 200      | 89            |
| 106     | Clock Book | 49        | 198        | 150      | 125           |
| 107     | The 'Feel' Book | 35        | 225        | 225      | 89            |
| 118     | Towels, Bath | 26        | 250        | 1000     | 213           |
| 119     | Squeeze Ball | 49        | 250        | 400      | 89            |
| 120     | Twin Sheet | 26        | 800        | 750      | 213           |
| 165     | Jean      | 65        | 825        | 500      | 33            |
| 258     | Shirt     | 58        | 650        | 1200     | 33            |
| NULL    | NULL      | NULL      | NULL       | NULL     | NULL          |
+ ------- + --------- + --------- + ---------- + -------- + ------------- +
14 rows
*/

/* Task 16 */
/* WRITE DIFFERENCE BETWEEN TABLE AND VIEW HERE */

/* Task 17 */
CREATE OR REPLACE VIEW task17(debit, total)
AS SELECT jbsale.debit, SUM(jbitem.price*jbsale.quantity)
FROM jbitem, jbsale
WHERE jbsale.item = jbitem.id
GROUP BY jbsale.debit;

SELECT * FROM task17;

/*
+ ---------- + ---------- +
| debit      | total      |
+ ---------- + ---------- +
| 100581     | 2050       |
| 100586     | 13446      |
| 100592     | 650        |
| 100593     | 430        |
| 100594     | 3295       |
+ ---------- + ---------- +
5 rows
*/

/* Task 18 */

SELECT debit, SUM(jbitem.price*quantity) as total
FROM jbsale
INNER JOIN jbitem
ON jbitem.id = jbsale.item
GROUP BY debit;

/*
+ ---------- + ---------- +
| debit      | total      |
+ ---------- + ---------- +
| 100581     | 2050       |
| 100586     | 13446      |
| 100592     | 650        |
| 100593     | 430        |
| 100594     | 3295       |
+ ---------- + ---------- +
5 rows
*/

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

/*
+ ------- + --------- + --------- +
| id      | name      | city      |
+ ------- + --------- + --------- +
| 5       | Amdahl    | 921       |
| 15      | White Stag | 106       |
| 20      | Wormley   | 118       |
| 33      | Levi-Strauss | 941       |
| 42      | Whitman's | 802       |
| 62      | Data General | 303       |
| 67      | Edger     | 841       |
| 89      | Fisher-Price | 21        |
| 122     | White Paper | 981       |
| 125     | Playskool | 752       |
| 213     | Cannon    | 303       |
| 241     | IBM       | 100       |
| 440     | Spooley   | 609       |
| 475     | DEC       | 10        |
| 999     | A E Neumann | 537       |
| NULL    | NULL      | NULL      |
+ ------- + --------- + --------- +
16 rows
*/

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

/*
+ ------------- + ------------- +
| supplier      | quantity      |
+ ------------- + ------------- +
| Cannon        | 6             |
| Fisher-Price  | 0             |
| Levi-Strauss  | 1             |
| Playskool     | 2             |
| White Stag    | 4             |
| Whitman's     | 2             |
+ ------------- + ------------- +
6 rows
*/

