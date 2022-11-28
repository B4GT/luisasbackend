CREATE DATABASE productshop;

USE productshop;

CREATE TABLE roles
(
	role_id INT PRIMARY KEY AUTO_INCREMENT,
	role_name VARCHAR(50) NOT NULL,
	role_state BOOL DEFAULT 2
);

CREATE TABLE person
(
	pe_id INT PRIMARY KEY AUTO_INCREMENT,
	pe_firstName VARCHAR(50) NULL,
	lastName VARCHAR(50) NULL,
	phone VARCHAR(11) NULL,
	address VARCHAR(90) NULL,
	reference VARCHAR(90) NULL,
	image VARCHAR(250) NULL
);

CREATE TABLE users
(
	id INT PRIMARY KEY AUTO_INCREMENT,
	users VARCHAR(50) NOT NULL,
	us_email VARCHAR(100) NOT NULL,
	passwordd VARCHAR(100) NOT NULL,
	token VARCHAR(256) NULL,
	us_statuss BOOL NULL DEFAULT 1,
	verified_email BOOL NULL,
	persona_id INT NOT NULL,
	fk_role_id INT NOT NULL DEFAULT 1,
	created DATETIME DEFAULT NOW(),
	UNIQUE KEY (us_email),
	FOREIGN KEY (fk_role_id) REFERENCES roles(role_id),
	FOREIGN KEY (persona_id) REFERENCES person(pe_id)
);

CREATE TABLE Address
(  
    ad_id INT PRIMARY KEY AUTO_INCREMENT,
    ad_tag VARCHAR(50) NOT NULL,
    ad_reference VARCHAR(50) NOT NULL,
    ad_street VARCHAR(50) NOT NULL,
    fk_us_id INT,
	ad_latitude VARCHAR(50),
	ad_longitude VARCHAR(50),
    FOREIGN KEY (fk_us_id) REFERENCES users (id)
); 

CREATE TABLE Home_carousel
(
	uidCarousel INT PRIMARY KEY AUTO_INCREMENT,
	image VARCHAR(256) NULL,
	category VARCHAR(100) NULL
);

CREATE TABLE Category
(
	uidCategory INT PRIMARY KEY AUTO_INCREMENT,
	category VARCHAR(80),
	picture VARCHAR(100),
	status BOOL DEFAULT 1
);

CREATE TABLE Products
(
	uidProduct INT PRIMARY KEY AUTO_INCREMENT,
	nameProduct VARCHAR(90) NULL,
	description VARCHAR(256) NULL,
	codeProduct VARCHAR(100) NULL,
	stock INT NULL,
	price DOUBLE(18,2) NULL,
	status VARCHAR(80) DEFAULT 'active',
	picture VARCHAR(256) NULL,
	category_id INT,
	pr_created DATETIME DEFAULT NOW(),
	FOREIGN KEY (category_id) REFERENCES Category(uidCategory)
);

CREATE TABLE favorite
(
	uidFavorite INT PRIMARY KEY AUTO_INCREMENT,
	product_id INT,
	user_id INT,
	FOREIGN KEY(product_id) REFERENCES Products(uidProduct),
	FOREIGN KEY(user_id) REFERENCES users(persona_id)
);

CREATE TABLE orderBuy
(
	uidOrderBuy INT PRIMARY KEY AUTO_INCREMENT,
	user_id INT,
	fk_address_id INT,
	latitude VARCHAR(50),
	longitude VARCHAR(50),
	receipt VARCHAR(100),
	created_at DATETIME DEFAULT NOW(),
	amount DOUBLE(11,2),
	fk_os_id INT,
	fk_delivery_id INT,
	FOREIGN KEY(user_id) REFERENCES users(persona_id),
	FOREIGN KEY(fk_address_id) REFERENCES Address(ad_id),
	FOREIGN KEY(fk_os_id) REFERENCES order_status(os_id),
	FOREIGN KEY (fk_delivery_id) REFERENCES person(pe_id)
);

CREATE TABLE order_status(  
    os_id INT PRIMARY KEY AUTO_INCREMENT,
    os_name VARCHAR(20) NOT NULL
);

CREATE TABLE orderDetails
(
	uidOrderDetails INT PRIMARY KEY AUTO_INCREMENT,
	orderBuy_id INT,
	product_id INT,
	quantity INT,
	price DOUBLE(11,2),
	FOREIGN KEY(orderBuy_id) REFERENCES orderBuy(uidOrderBuy),
	FOREIGN KEY(product_id) REFERENCES Products(uidProduct)
)





/*------------------------------------------------------------*/
/*-----------------  Storage PROCEDURE ----------------------*/
/*----------------------------------------------------------*/

DELIMITER //
CREATE PROCEDURE SP_GET_USER_BY_ID(IN UID INT )
BEGIN
	SELECT pe.uid, pe.firstName, pe.lastName, pe.phone, pe.address, pe.reference, pe.image, us.users, us.email 
	FROM person pe
	INNER JOIN users us ON pe.uid = us.persona_id
	WHERE pe.uid = UID;
END//


DELIMITER //
CREATE PROCEDURE SP_LIST_POPULAR_PRODUCTS_HOME(IN UID INT)
BEGIN
	SELECT orderdetails.product_id, p.nameProduct, p.description, p.codeProduct ,p.picture, p.stock, p.price, c.uidCategory, c.category,
	SUM(orderdetails.quantity) AS TotalVentas, (SELECT COUNT(fa.uidFavorite) FROM favorite fa WHERE fa.user_id = UID AND fa.product_id = p.uidProduct ) AS is_favorite
	FROM orderdetails 
		INNER JOIN products p ON orderdetails.product_id = p.uidProduct
		INNER JOIN Category AS c ON p.category_id = c.uidCategory
	GROUP BY orderdetails.product_id
	ORDER BY SUM(orderdetails.quantity) DESC LIMIT 4;
END//	


DELIMITER //
CREATE PROCEDURE SP_LIST_NEW_PRODUCTS(IN UID INT)
BEGIN
    SELECT p.uidProduct, p.nameProduct, p.description, p.codeProduct, p.stock, p.price, p.status, p.picture, p.category_id, c.category, p.pr_created,
        (SELECT COUNT(fa.uidFavorite) FROM favorite fa WHERE fa.user_id = UID AND fa.product_id = uidProduct ) AS is_favorite
        FROM products p
        INNER JOIN Category AS c ON category_id = c.uidCategory
        ORDER BY (pr_created) DESC LIMIT 4;
END


DELIMITER //
CREATE PROCEDURE SP_SEARCH_PRODUCT(IN UID INT ,IN nameProduct VARCHAR(100))
BEGIN
SELECT p.uidProduct, p.nameProduct, p.description, p.codeProduct, p.price, p.stock, p.status, p.picture, c.category, c.uidCategory,
(SELECT COUNT(fa.uidFavorite) FROM favorite fa WHERE fa.user_id = UID AND fa.product_id = p.uidProduct ) AS is_favorite
FROM products p
	INNER JOIN category c ON p.category_id = c.uidCategory
	WHERE p.nameProduct LIKE CONCAT('%', nameProduct , '%');
END


DELIMITER //
CREATE PROCEDURE SP_SEARCH_PRODUCT_FOR_PRICE(IN UID INT ,IN minPrice INT, IN maxPrice INT)
BEGIN
SELECT p.uidProduct, p.nameProduct, p.description, p.codeProduct, p.price, p.stock, p.status, p.picture, c.category, c.uidCategory,
(SELECT COUNT(fa.uidFavorite) FROM favorite fa WHERE fa.user_id = UID AND fa.product_id = p.uidProduct ) AS is_favorite
FROM products p
	INNER JOIN category c ON p.category_id = c.uidCategory
	WHERE p.price BETWEEN minPrice AND maxPrice
	ORDER BY p.price ASC;
END


-- Add new users
DELIMITER //
CREATE PROCEDURE SP_REGISTER_USER (IN usu VARCHAR(50), IN email VARCHAR(100), IN passwordd VARCHAR(100) )
BEGIN
	INSERT INTO person ( firstName ) VALUE ( usu );
	INSERT INTO users ( users, email, passwordd , persona_id ) VALUE (usu, email, passwordd, LAST_INSERT_ID());
END//


DELIMITER //
CREATE PROCEDURE SP_UPDATE_INFORMATION( IN uid INT, IN nam VARCHAR(90), IN lastt VARCHAR(90), IN phone VARCHAR(11), IN address VARCHAR(90), IN reference VARCHAR(90))
BEGIN
	UPDATE person
		SET firstName = nam, 
			 lastName = lastt,
			 phone = phone, 
			 address = address, 
			 reference = reference
	WHERE person.uid = uid;
END//


-- Update Street Address - user
DELIMITER //
CREATE PROCEDURE SP_UPDATE_STREET(IN uid INT, IN ADDRESS VARCHAR(90), IN REFERENCESS VARCHAR(90) )
BEGIN
	UPDATE person
		SET address = ADDRESS, 
			 reference = REFERENCESS
	WHERE person.uid = uid;
END//


-- LIST PRODUCTS HOME
DELIMITER //
CREATE PROCEDURE SP_LIST_PRODUCTS_HOME(IN UID INT)
BEGIN
	SELECT uidProduct, nameProduct, description, codeProduct, stock, price, p.status, p.picture, c.category,
	(SELECT COUNT(fa.uidFavorite) FROM favorite fa WHERE fa.user_id = UID AND fa.product_id = p.uidProduct ) AS is_favorite
	FROM Products AS p
	INNER JOIN Category AS c ON p.category_id = c.uidCategory
	ORDER BY uidProduct DESC LIMIT 10;
END//


--- LIST FAVORITE OF PRODUCTS
DELIMITER //
CREATE PROCEDURE SP_LIST_FAVORITE_PRODUCTS( IN UID INT )
BEGIN
	SELECT uidProduct, nameProduct, description, codeProduct, stock, price, p.status, p.picture, c.category,
	(SELECT COUNT(fa.uidFavorite) FROM favorite fa WHERE fa.user_id = UID AND fa.product_id = p.uidProduct ) AS is_favorite
	FROM Products AS p
	INNER JOIN Category AS c ON p.category_id = c.uidCategory
	INNER JOIN favorite AS f ON p.uidProduct = f.product_id
	INNER JOIN users AS u ON f.user_id = u.id
	WHERE u.id = UID;
END//

--- LIST PRODUCTS FOR CATEGORIES
DELIMITER //
CREATE PROCEDURE SP_LIST_PRODUCTS_FOR_CATEGORY(IN UIDCATEGORY INT, IN UIDUSER INT)
BEGIN
	SELECT uidProduct, nameProduct, description, codeProduct, stock, price, p.status, p.picture, c.category,
	(SELECT COUNT(fa.uidFavorite) FROM favorite fa WHERE fa.user_id = UIDUSER AND fa.product_id = p.uidProduct ) AS is_favorite
	FROM Products AS p
	INNER JOIN Category AS c ON p.category_id = c.uidCategory
	LEFT JOIN favorite AS f ON p.uidProduct = f.product_id
	LEFT JOIN users AS u ON f.user_id = u.id
	WHERE c.uidCategory = UIDCATEGORY;
END//

DELIMITER //
CREATE PROCEDURE SP_LIST_ORDERS_FOR_STATUS(IN UIDSTATUS INT, IN UIDUSER INT)
BEGIN
	SELECT uidOrderBuy, user_id, receipt, created_at, amount, os.os_id, os.os_name FROM orderBuy
	INNER JOIN order_status AS os ON os.os_id = fk_os_id
	WHERE user_id = UIDUSER AND fk_os_id = UIDSTATUS;
END

-- GET PRODUCTS FOR ID USER
DELIMITER //
CREATE PROCEDURE SP_ORDER_DETAILS( IN ID INT )
BEGIN
	SELECT o.uidOrderDetails, o.product_id, p.nameProduct, p.picture, o.quantity, o.price  FROM orderdetails o
	INNER JOIN products p ON o.product_id = p.uidProduct
	WHERE o.orderBuy_id = ID;
END//

DELIMITER //
CREATE PROCEDURE SP_GET_ALL_ORDERS()
BEGIN
	SELECT ob.uidOrderBuy, ob.user_id, ob.fk_address_id, ob.latitude, ob.longitude, ob.receipt, ob.amount, ob.fk_delivery_id, ob.fk_os_id, p.picture, ob.created_at FROM OrderBuy ob 
    INNER JOIN (SELECT orderBuy_id, MIN(product_id) AS P FROM orderdetails GROUP BY orderBuy_id) od ON ob.uidOrderBuy = od.orderBuy_id
    INNER JOIN Products p ON od.P = p.uidProduct ORDER BY ob.created_at ASC;
END//









