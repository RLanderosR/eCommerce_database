DROP DATABASE IF EXISTS ecommerce_site;
CREATE DATABASE IF NOT EXISTS ecommerce_site;
USE ecommerce_site;

CREATE TABLE IF NOT EXISTS customers
(
	customer_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    gender ENUM('M','F','O') NOT NULL,
    email_address VARCHAR(255) NOT NULL CHECK (email_address LIKE '%@%'),
    customer_since TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    address1 VARCHAR(255) NOT NULL,
    address2 VARCHAR(255),
    postal_code CHAR(5) NOT NULL,
    city VARCHAR(45) NOT NULL,
    state CHAR(2) NOT NULL,
    country VARCHAR(45) NOT NULL,
PRIMARY KEY (customer_id),
UNIQUE KEY `email_address` (email_address)
) AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS category
(
	category_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    category_name VARCHAR(45) NOT NULL,
PRIMARY KEY (category_id),
UNIQUE KEY `category_name` (category_name)
) AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS suppliers
(
	supplier_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    company_name VARCHAR(45) NOT NULL,
    company_contact VARCHAR(45) NOT NULL,
    company_email VARCHAR(255) NOT NULL CHECK (company_email LIKE '%@%'),
    company_phone_code CHAR(4) NOT NULL CHECK (company_phone_code LIKE '+%'),
    company_phone CHAR(10) NOT NULL,
    address1 VARCHAR(255) NOT NULL,
    address2 VARCHAR(255),
    postal_code CHAR(5) NOT NULL,
    city VARCHAR(45) NOT NULL,
    state CHAR(2) NOT NULL,
    country VARCHAR(45) NOT NULL,
PRIMARY KEY (supplier_id)
) AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS products
(
    product_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    unit_price NUMERIC(10,2) UNSIGNED NOT NULL,
    unit_stock INT UNSIGNED NOT NULL DEFAULT 0,
    discontinued_flag ENUM('Y','N'),
    category_id INT UNSIGNED NOT NULL,
    supplier_id INT UNSIGNED NOT NULL,
PRIMARY KEY (product_id),
CONSTRAINT `products_to_category_id` FOREIGN KEY (category_id) REFERENCES `category` (`category_id`) ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT `products_to_supplier_id` FOREIGN KEY (supplier_id) REFERENCES `suppliers` (`supplier_id`) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS orders
(
	order_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    customer_id INT UNSIGNED,
    order_status ENUM('Pending', 'Shipped','Part_Shipped','Delivered','Part_Delivered','Returned','Cancelled') NOT NULL,
    order_value NUMERIC(10,2) UNSIGNED NOT NULL,
PRIMARY KEY (order_id),
CONSTRAINT `orders_to_customer_id` FOREIGN KEY (customer_id) REFERENCES `customers` (`customer_id`) ON UPDATE CASCADE ON DELETE CASCADE
) AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS order_details
(
	order_id INT UNSIGNED NOT NULL,
    product_id INT UNSIGNED NOT NULL,
    unit_price NUMERIC(10,2) UNSIGNED NOT NULL,
    discount NUMERIC(10,2) UNSIGNED,
    quantity INT UNSIGNED NOT NULL,
    item_status ENUM('Pending', 'Shipped','Delivered','Returned','Cancelled') NOT NULL,
CONSTRAINT `details_to_order_id` FOREIGN KEY (order_id) REFERENCES `orders` (`order_id`) ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT `details_to_product_id` FOREIGN KEY (product_id) REFERENCES `products` (`product_id`) ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS payments
(
	order_id INT UNSIGNED NOT NULL,
    payment_type ENUM('Credit Card','Debit Card','Check','Bank Account','Bitcoin') NOT NULL,
    payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    payment_status ENUM('Successful','Pending','Rejected') NOT NULL,
CONSTRAINT `payments_to_order_id` FOREIGN KEY (order_id) REFERENCES `orders` (`order_id`) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO customers (
	first_name, last_name, gender, email_address,
	address1, address2, postal_code, city, state, country
)
VALUES
	('Rodrigo','Landeros','M','mail1@gmail.com','1 Education St',DEFAULT,'02141','Cambridge','MA','United States'),
	('M Raafi','Jahangir','M','mail2@gmail.com','2 Education St','12','02142','North End','MA','United States'),
	('Marcello','Mazzanti','M','mail@outook.com','3 Education St',DEFAULT,'02143','Houston','TX','United States'),
	('Max','Lemke','M','mail@icloud.com','4 Education St','344','02144','New York','NY','United States'),
	('Mike','Timberlake','M','mail@aol.com','5 Education St','2','02145','San Francisco','CA','United States'),
	('Pom','Pom','F','mail@yahoo.com','6 Education St','1','02146','Cuppertino','CA','United States'),
	('Sara','Willard','F','mail@gov.com','7 Education St',DEFAULT,'02147','Austin','TX','United States'),
	('Katherina','Bursy','F','mail@hult.edu','8 Education St',DEFAULT,'02148','Miami','FL','United States'),
	('Siri','Siri','O','mail@apple.com','9 Education St','33','02149','Brooklyn','NY','United States'),
	('Alexa','Alexa','O','mail@amazon.com','10 Education St',DEFAULT,'02150','Aliston','MA','United States');
    
INSERT INTO category (category_name)
VALUES
	('Clothing, Shoes'),
    ('Home'),
    ('Sports'),
    ('Books'),
    ('Automotive'),
    ('Pet Supplies'),
    ('Electronics'),
    ('Computers'),
    ('Office'),
    ('Food & Grocery');
    
INSERT INTO suppliers (
	company_name, company_contact, company_email, company_phone_code, company_phone,
	address1, address2, postal_code, city, state, country
)
VALUES
	('a','aa','mail1@gmail.com','+1','0000000001','1 Education St',DEFAULT,'02141','Cambridge','MA','United States'),
	('b','bb','mail2@gmail.com','+1','0000000002','2 Education St','12','02142','North End','MA','United States'),
	('c','cc','mail@outook.com','+1','0000000003','3 Education St',DEFAULT,'02143','Houston','TX','United States'),
	('d','dd','mail@icloud.com','+1','0000000004','4 Education St','344','02144','New York','NY','United States'),
	('e','ee','mail@aol.com','+1','0000000005','5 Education St','2','02145','San Francisco','CA','United States'),
	('f','ff','mail@yahoo.com','+1','0000000006','6 Education St','1','02146','Cuppertino','CA','United States'),
	('g','gg','mail@gov.com','+1','0000000007','7 Education St',DEFAULT,'02147','Austin','TX','United States'),
	('h','hh','mail@hult.edu','+1','0000000008','8 Education St',DEFAULT,'02148','Miami','FL','United States'),
	('i','ii','mail@apple.com','+1','0000000009','9 Education St','33','02149','Brooklyn','NY','United States'),
	('j','jj','mail@amazon.com','+1','0000000010','10 Education St',DEFAULT,'02150','Aliston','MA','United States');

INSERT INTO products (
	product_name, unit_price, unit_stock, discontinued_flag, category_id, supplier_id
)
VALUES
	("Face Mask | Adult 2-Pack | Anti-Microbial, Reusable, Cloth, Adjustable, Breathable | The Revival Mask by coRevival (Black)",'19.99','8','N','1','1'),
	("think! High Protein Bars 20g Protein, No Artificial Sweeteners, Brownie Crunch, 10 Count",'15.84','16','N','10','10'),
	("RION Cycling Bibs Shorts Men's Bike Padded Tights Bicycle Pants",'38.99','2','N','3','6'),
	("illy Intenso Ground Espresso Coffee, Dark Roast, Intense, Robust and Full Flavored With Notes of Deep Cocoa, 100% Arabica Coffee, No Preservatives, 8.8 Ounce (Pack of 2)",'19.6','12','N','10','10'),
	("Chef Craft Can Opener with Tapper",'3.97','18','N','2','3'),
	("UGREEN USB-C to USB-C Cable, USB Type C 100W Power Delivery PD Charging Cord for Apple MacBook Pro, Huawei Matebook, iPad Pro 2020, Chromebook, Pixel 3 XL, Samsung Note 10 S20 S10, Nintendo Switch 3FT",'8.99','11','N','7','7'),
	("USB C to HDMI Cable, CHOETECH Type-C to HDMI Adapter 6FT 60W PD Powering Cable Thunderbolt 3(4K@60Hz) Compatible with MacBook Pro2020/iPad Pro/MacBook Air,iMac 2017,Samsung Galaxy S10/S9/S9+/Note9/S8",'19.99','16','N','7','7'),
	("Orionstar Laptop Stand Portable Aluminum Laptop Riser Compatible with Apple Mac MacBook Air Pro 10 to 15.6 Inch Notebook Computer, Detachable Ergonomic Elevator Holder, Space Grey",'25.99','8','N','9','7'),
	("USB C Charger RAVPower 61W PD 3.0 Wall Charger Fast Charging Type C Foldable Adapter with dual Ports Portable Charger for laptop MacBook Pro tablets iPad Pro iPhone 12 Mini Pro Max Galaxy S20 Nintendo",'25.99','18','N','7','7'),
	("Gaggia Carezza De LUXE Espresso Machine, Silver",'332.41','18','N','2','4'),
	("UNNI ASTM D6400 100% Compostable Trash Bags, 2.6 Gallon, 9.84 Liter, 100 Count, Extra Thick 0.71 Mils, Food Scrap Small Kitchen Trash Bags, US BPI and Europe OK Compost Home Certified, San Francisco",'11.95','2','N','2','5'),
	("Superior Glass Meal Prep Containers - 6-pack (35oz) Newly Innovated Hinged BPA-free Locking lids - 100% Leak Proof Glass Food Storage Containers, Great on-the-go, Freezer to Oven Safe Lunch Containers",'29.99','20','N','2','5'),
	("Milemont Memory Foam Pillow, Bamboo Charcoal Memory Foam, Cervical Pillow for Neck Pain, Orthopedic Contour Pillow Support for Back, Stomach, Side Sleepers, Pillow for Sleeping, CertiPUR-US, Standard",'32.99','13','N','2','5'),
	("Instant Pot Duo Nova Pressure Cooker 7 in 1, 3 Qt, Best for Beginners",'79.99','13','N','2','4'),
	("Finish Line Fiber Grip Carbon Fiber Bicycle Assembly Gel",'7','5','N','3','6'),
	("Microsoft  Surface Pro 6 (Intel Core i5, 8GB RAM, 256GB)",'868.89','6','N','8','9'),
	("Bell Z20 MIPS Adult Road Bike Helmet",'229.95','18','N','3','6'),
	("Dell PR03X E/Port II USB 3.0 Advanced Port Replicator",'89.89','2','N','7','8'),
	("Saucony Men's Multi-Pack Bolt Performance Comfort Fit No-Show Socks",'14','2','N','1','2'),
	("Logitech Keyboard Folio for iPad mini - Mystic Blue",'79.99','9','Y','7','8');
    
INSERT INTO orders (
	order_date, customer_id, order_status, order_value
)
VALUES
	('2021-01-11',2,'Pending',39.2),
	('2021-01-12',4,'Shipped',56),
	('2021-01-13',6,'Part_Shipped',668.79),
	('2021-01-14',2,'Delivered',59.97),
	('2021-01-15',1,'Part_Delivered',1048.83),
	('2021-01-16',9,'Returned',60.99),
	('2021-01-17',3,'Cancelled',17.98),
	('2021-01-18',1,'Shipped',35),
	('2021-01-19',4,'Delivered',31.68),
	('2021-01-20',8,'Delivered',98),
	('2021-01-21',4,'Delivered',79.2),
	('2021-01-22',7,'Shipped',1496.19),
	('2021-01-23',8,'Delivered',319.96),
	('2021-01-24',7,'Delivered',129.95),
	('2021-01-25',3,'Delivered',1448.62);

INSERT INTO order_details (
	order_id,product_id,unit_price,discount,quantity,item_status
)
VALUES
	(1,4,19.6,DEFAULT,2,'Pending'),
	(2,19,14,DEFAULT,4,'Shipped'),
	(3,10,332.41,DEFAULT,2,'Pending'),
	(3,5,3.97,DEFAULT,1,'Shipped'),
	(4,7,19.99,DEFAULT,3,'Delivered'),
	(5,19,14,DEFAULT,1,'Shipped'),
	(5,17,229.95,DEFAULT,4,'Pending'),
	(5,1,19.99,0.98,4,'Shipped'),
	(5,3,38.99,DEFAULT,1,'Delivered'),
	(6,19,14,DEFAULT,2,'Returned'),
	(6,13,32.99,DEFAULT,1,'Returned'),
	(7,6,8.99,DEFAULT,2,'Cancelled'),
	(8,15,7,DEFAULT,5,'Shipped'),
	(9,2,15.84,DEFAULT,2,'Delivered'),
	(10,4,19.6,DEFAULT,5,'Delivered'),
	(11,2,15.84,DEFAULT,5,'Delivered'),
	(12,13,32.99,DEFAULT,1,'Delivered'),
	(12,1,19.99,0.98,4,'Delivered'),
	(12,10,332.41,DEFAULT,3,'Delivered'),
	(12,17,229.95,DEFAULT,1,'Delivered'),
	(12,14,79.99,DEFAULT,2,'Shipped'),
	(13,14,79.99,DEFAULT,4,'Delivered'),
	(14,8,25.99,DEFAULT,5,'Delivered'),
	(15,3,38.99,DEFAULT,1,'Delivered'),
	(15,14,79.99,DEFAULT,1,'Delivered'),
	(15,10,332.41,DEFAULT,4,'Delivered');
    
INSERT INTO payments (
	order_id, payment_type, payment_date, payment_status
)
VALUES
    (1,'Credit Card','2021-01-25 15:35:49','Pending'),
	(2,'Debit Card',DEFAULT,'Successful'),
	(3,'Credit Card',DEFAULT,'Successful'),
	(4,'Credit Card',DEFAULT,'Successful'),
	(5,'Credit Card',DEFAULT,'Successful'),
	(6,'Check',DEFAULT,'Successful'),
	(7,'Bitcoin','2021-01-22 07:11:45','Rejected'),
	(8,'Credit Card',DEFAULT,'Successful'),
	(9,'Debit Card',DEFAULT,'Successful'),
	(10,'Debit Card',DEFAULT,'Successful'),
	(11,'Bank Account',DEFAULT,'Successful'),
	(12,'Credit Card',DEFAULT,'Successful'),
	(13,'Credit Card',DEFAULT,'Successful'),
	(14,'Credit Card',DEFAULT,'Successful'),
	(15,'Credit Card',DEFAULT,'Successful');
    
