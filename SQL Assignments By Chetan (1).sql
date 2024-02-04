use classicmodels;
-- DAY 3(1)
SELECT 
    customernumber, customername, state, creditlimit
FROM
    customers
WHERE
    creditlimit BETWEEN 50000 AND 100000
        AND state IS NOT NULL
ORDER BY creditlimit DESC;
-- DAY 3(2)
SELECT DISTINCT
    productline
FROM
    products
WHERE
    productLine LIKE '%cars';
-- Day 4(1)
SELECT 
    ordernumber, status, COALESCE(comments, '--')
FROM
    orders
WHERE
    status = 'Shipped';
-- Day 4(2)
SELECT 
    employeeNumber,
    firstname,
    jobtitle,
    CASE
        WHEN jobtitle = 'president' THEN 'P'
        WHEN jobtitle = 'Sales Manager (APAC)' THEN 'SM'
        WHEN jobtitle = 'Sale Manager (EMEA)' THEN 'SM'
        WHEN jobtitle = 'Sales Manager (NA)' THEN 'SM'
        WHEN jobtitle = 'Sales Rep' THEN 'SR'
        WHEN jobtitle LIKE '%VP%' THEN 'VP'
        ELSE Jobtitle
    END AS JobTitle_abbr
FROM
    employees
ORDER BY jobtitle;
-- Day 5(1)
SELECT DISTINCT
    (YEAR(paymentdate)) AS Year, MIN(amount)
FROM
    payments
GROUP BY year
ORDER BY year;
-- Day 5(2)
SELECT 
    YEAR(orderdate) AS year,
    CONCAT('Q', QUARTER(orderdate)) AS Quarter,
    COUNT(DISTINCT (customernumber)),
    COUNT(DISTINCT (ordernumber))
FROM
    orders
GROUP BY year , quarter;
-- Day 5(3)
SELECT 
    month, CONCAT(ROUND((famount / 1000), 0), 'K') AS famount
FROM
    (SELECT 
        month, SUM(amount) AS famount
    FROM
        payments
    GROUP BY month) AS wee
WHERE
    famount BETWEEN 500000 AND 1000000
ORDER BY famount DESC;
-- Day 6(1)
CREATE TABLE journeytable (
    Bus_id INTEGER NOT NULL,
    Bus_Name VARCHAR(20) NOT NULL,
    source_station VARCHAR(20) NOT NULL,
    Destination VARCHAR(20) NOT NULL,
    email VARCHAR(50) UNIQUE
);
-- Day 6(2)
CREATE TABLE vendortable (
    Vendor_id INTEGER PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    email VARCHAR(50) UNIQUE,
    country VARCHAR(20) DEFAULT '#N/a'
);
-- Day 6(3)
CREATE TABLE movies (
    movie_id INTEGER PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    release_year VARCHAR(20) DEFAULT '--',
    cast VARCHAR(20) NOT NULL,
    gender VARCHAR(20) CHECK (gender = 'Male' OR gender = 'female'),
    no_of_shows INTEGER CHECK (no_of_shows > 0)
);

-- Day 6(4) (b)
CREATE TABLE suppliers (
    supplier_id INTEGER PRIMARY KEY,
    supplier_name VARCHAR(20),
    location VARCHAR(200)
);
-- Day 6(4) (a)
CREATE TABLE product (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(20) NOT NULL UNIQUE,
    description VARCHAR(20),
    supplier_id INTEGER,
    FOREIGN KEY (supplier_id)
        REFERENCES suppliers (supplier_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
 
-- Day 6(4) (c)
CREATE TABLE stock (
    id INTEGER PRIMARY KEY,
    product_id INTEGER,
    balance_stock INTEGER,
    FOREIGN KEY (product_id)
        REFERENCES product (product_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
-- Day 7(1)
SELECT 
    employeenumber,
    CONCAT(firstname, lastname) AS salesperson,
    COUNT(employeenumber) AS uniquecustomers
FROM
    customers
        JOIN
    employees ON salesRepEmployeeNumber = employeeNumber
GROUP BY employeeNumber
ORDER BY uniquecustomers DESC;

-- Day 7(2)
SELECT 
    c.customernumber,
    c.customername,
    od.productcode,
    p.productname,
    od.quantityordered AS OrderedQty,
    p.quantityinstock AS TotalInventory,
    (p.quantityinstock - od.quantityordered) AS LeftQty
FROM
    customers AS c
        JOIN
    orders AS o ON c.customernumber = o.customernumber
        JOIN
    orderdetails AS od ON o.ordernumber = od.ordernumber
        JOIN
    products AS p ON od.productcode = p.productcode
ORDER BY c.customernumber;
-- Day 7(4)
CREATE TABLE Laptop (
    Laptop_name VARCHAR(20)
);
insert into laptop values("Dell"),("HP");
CREATE TABLE Colours (
    Colour_name VARCHAR(20)
);
insert into colours values("White"),("Silver"),("Black");
SELECT 
    *
FROM
    laptop
        CROSS JOIN
    colours
ORDER BY laptop_name;
 -- Day 7 (4)
CREATE TABLE project (
    employeeid INTEGER,
    fullname VARCHAR(20),
    gender VARCHAR(20),
    managerid INTEGER
);
insert into  project values(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);
SELECT 
    pp.fullname AS managername, p.fullname AS employeename
FROM
    project AS pp
        JOIN
    project AS p ON pp.employeeid = p.managerid;
    -- Day 8
CREATE TABLE facility (
    Facility_id INTEGER,
    name VARCHAR(20),
    state VARCHAR(20),
    country VARCHAR(20)
);
alter table facility add constraint pkey primary key(facility_id);
alter table facility modify column facility_id integer auto_increment;
alter table facility add column city varchar(20) after name;
alter table facility modify column city varchar(20) not null;    

-- Day 9
CREATE TABLE university (
    id INTEGER,
    name VARCHAR(200)
);
INSERT INTO University
VALUES (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");

SELECT 
    REPLACE(REPLACE(REPLACE(name, '  ', '  | '),
            ' |  ',
            ''),
        '  | ',
        ' ') AS Name
FROM
    university;

     
-- Day 12 (1)
select year ,months,c,concat(round(((c-yoy)/yoy)*100,0),"%") as yoychange from( select *,lag(c,1) over (partition by year order by no ) as yoy from( select year,monthname(orderdate) as months ,month(orderdate) as no,count(distinct(customernumber))as c from orders group  by year,months,no )as we) as weeee;


-- Day 13(1)
SELECT 
    customernumber, customername
FROM
    customers
WHERE
    customernumber NOT IN (SELECT 
            customernumber
        FROM
            orders);

-- Day 13 (2)
SELECT 
    c.customernumber,
    c.customername,
    COUNT(o.ordernumber) AS total
FROM
    customers AS c
        JOIN
    orders AS o ON c.customernumber = o.customernumber
GROUP BY customernumber;

-- Day 13 (3)
 select ordernumber,quantityordered from (select * ,dense_rank() over ( partition by ordernumber order  by quantityordered desc) as rnk from orderdetails) as we where rnk =2;
 
 -- Day 13 (4)
SELECT 
    MAX(ss) AS Maximum, MIN(ss) AS Minimum
FROM
    (SELECT 
        ordernumber, COUNT(productcode) AS ss
    FROM
        orderdetails
    GROUP BY ordernumber) AS wee;
            
-- Day 13 (5)
SELECT 
    productline, COUNT(productname) AS Total
FROM
    (SELECT 
        *
    FROM
        products) AS we
WHERE
    MSRP > (SELECT 
            AVG(msrp)
        FROM
            products)
GROUP BY productline
ORDER BY total DESC;

-- Day 14 
CREATE TABLE EMP_EH (
    empid INTEGER PRIMARY KEY,
    empname VARCHAR(30),
    emailaddress VARCHAR(100)
); 

-- Day 15
CREATE TABLE emp_bit (
    name VARCHAR(20),
    occupation VARCHAR(20),
    working_date DATE,
    working_hours INTEGER
);
  INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  
  
  