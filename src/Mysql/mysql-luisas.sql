CREATE DATABASE luisasdatabase;

USE luisasdatabase;

CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(45) NOT NULL,
    user_email VARCHAR(45) NOT NULL,
    user_password VARCHAR(45) NOT NULL,
    fk_pers_id INT NOT NULL,
    fk_role_id INT NOT NULL,
    user_status BOOLEAN NOT NULL,
    user_verify BOOLEAN NOT NULL,
    user_created_at DATETIME DEFAULT NOW(),
    UNIQUE KEY (user_email),
    FOREIGN KEY (fk_pers_id) REFERENCES Person(pers_id),
    FOREIGN KEY (fk_role_id) REFERENCES Role(role_id)
);

CREATE TABLE Person (
    pers_id INT PRIMARY KEY AUTO_INCREMENT,
    pers_name VARCHAR(45) NOT NULL,
    pers_lastname VARCHAR(45) NOT NULL,
    pers_phone INT NOT NULL,
    fk_gend_id INT NOT NULL,
    FOREIGN KEY (fk_gend_id) REFERENCES Gender(gend_id)
);

CREATE TABLE Gender (
    gend_id INT PRIMARY KEY AUTO_INCREMENT,
    gend_name VARCHAR(45) NOT NULL
);

CREATE TABLE Address (
    adre_id INT PRIMARY KEY AUTO_INCREMENT,
    adre_street VARCHAR(45) NOT NULL,
    adre_reference VARCHAR(45) NOT NULL,
    fk_pers_id INT NOT NULL,
    FOREIGN KEY (fk_pers_id) REFERENCES Person(pers_id)
);

CREATE TABLE Role (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(45) NOT NULL,
);

CREATE TABLE Pqrs_User (
    pqrs_id INT PRIMARY KEY AUTO_INCREMENT,
    pqrs_description VARCHAR(45) NOT NULL,
    fk_pt_id INT NOT NULL,
    fk_user_id INT NOT NULL,
    pqrs_created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (fk_user_id) REFERENCES Users(user_id),
    FOREIGN KEY (fk_pt_id) REFERENCES PqrsType(pt_id)
);

CREATE TABLE PqrsType (
    pt_id INT PRIMARY KEY AUTO_INCREMENT,
    pt_name VARCHAR(45) NOT NULL,
);

CREATE TABLE Category (
    cate_id INT PRIMARY KEY AUTO_INCREMENT,
    cate_name VARCHAR(45) NOT NULL
);

CREATE TABLE Products (
    prod_id INT PRIMARY KEY AUTO_INCREMENT,
    prod_name VARCHAR(45) NOT NULL,
    prod_description VARCHAR(45) NOT NULL,
    prod_status BOOLEAN NOT NULL,
    prod_price DOUBLE NOT NULL,
    fk_cate_id INT NOT NULL,
    prod_created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (fk_cate_id) REFERENCES Category(cate_id)
);

CREATE TABLE ImagesProducts (
    ip_id INT PRIMARY KEY AUTO_INCREMENT,
    ip_url VARCHAR(100) NOT NULL,
    fk_prod_id INT NOT NULL,
    FOREIGN KEY (fk_prod_id) REFERENCES Products(prod_id)
);

CREATE TABLE Options (
    op_id INT PRIMARY KEY AUTO_INCREMENT,
    op_enable_cake boolean NOT NULL,
    fk_prod_id int NOT NULL,
    op_enable_label boolean NOT NULL,
    op_enable_portion boolean NOT NULL,
    op_enable_filling boolean NOT NULL,
    FOREIGN KEY (fk_prod_id) REFERENCES Products(prod_id)
);

CREATE TABLE Filling (
    fi_id INT PRIMARY KEY AUTO_INCREMENT,
    fi_name VARCHAR(45) NOT NULL
);

CREATE TABLE Product_Filling (
    pf_id INT PRIMARY KEY AUTO_INCREMENT,
    fk_prod_id INT NOT NULL,
    fk_fi_id INT NOT NULL,
    FOREIGN KEY (fk_prod_id) REFERENCES Products(prod_id),
    FOREIGN KEY (fk_fi_id) REFERENCES Filling(fi_id)
);

CREATE TABLE Product_Discount (
    pd_id INT PRIMARY KEY AUTO_INCREMENT,
    fk_prod_id INT NOT NULL,
    pd_value DOUBLE NOT NULL,
    pd_valid_from date NOT NULL,
    pd_valid_until date NOT NULL,
    pd_created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (fk_prod_id) REFERENCES Products(prod_id)
);

CREATE TABLE Category_Discount (
    cd_id INT PRIMARY KEY AUTO_INCREMENT,
    fk_cate_id INT NOT NULL,
    cd_values DOUBLE NOT NULL,
    cd_valid_from date NOT NULL,
    cd_valid_until date NOT NULL,
    cd_created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (fk_cate_id) REFERENCES Category(cate_id)
);

CREATE TABLE CategoryGift (
    cg_id INT PRIMARY KEY AUTO_INCREMENT,
    cg_name VARCHAR(45) NOT NULL
);

CREATE TABLE ProductGift (
    pg_id INT PRIMARY KEY AUTO_INCREMENT,
    pg_price DOUBLE NOT NULL,
    pg_name VARCHAR(45) NOT NULL,
    pg_description VARCHAR(45) NOT NULL,
    fk_cg_id INT NOT NULL,
    FOREIGN KEY (fk_cg_id) REFERENCES CategoryGift(cg_id)
);

CREATE TABLE FavoriteProducts (
    fp_id INT PRIMARY KEY AUTO_INCREMENT,
    fk_user_id INT NOT NULL,
    fk_prod_id INT NOT NULL,
    FOREIGN KEY (fk_user_id) REFERENCES Users(user_id),
    FOREIGN KEY (fk_prod_id) REFERENCES Products(prod_id)
);

CREATE TABLE Cart (
    cart_id INT PRIMARY KEY AUTO_INCREMENT,
    cart_amount DOUBLE NOT NULL,
    cart_created_at DATETIME DEFAULT NOW(),
);

CREATE TABLE Cart_Products (
    cp_id INT PRIMARY KEY AUTO_INCREMENT,
    fk_cart_id INT NOT NULL,
    fk_pg_id INT NOT NULL,
    fk_prod_id INT NOT NULL,
    prod_cake VARCHAR(45) NOT NULL,
    prod_label VARCHAR(45) NOT NULL,
    prod_portion INT NOT NULL,
    FOREIGN KEY (fk_cart_id) REFERENCES Cart(cart_id),
    FOREIGN KEY (fk_prod_id) REFERENCES Products(prod_id),
    FOREIGN KEY (fk_pg_id) REFERENCES ProductGift(pg_id)
);

CREATE TABLE OrderStatus (
    os_id INT PRIMARY KEY AUTO_INCREMENT,
    os_name VARCHAR(45) NOT NULL,
);

CREATE TABLE OderImage (
    oi_id INT PRIMARY KEY AUTO_INCREMENT,
    oi_image VARCHAR(100) NOT NULL
);

CREATE TABLE Order (
    orde_id INT PRIMARY KEY AUTO_INCREMENT,
    fk_user_id INT NOT NULL,
    fk_cp_id INT NOT NULL,
    orde_shipping_address VARCHAR(45) NOT NULL,
    orde_dedication VARCHAR(45) NOT NULL,
    orde_total DOUBLE NOT NULL,
    orde_total_discount DOUBLE NOT NULL,
    fk_os_id INT NOT NULL,
    orde_created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (fk_cp_id) REFERENCES Cart_Products(cp_id),
    FOREIGN KEY (fk_user_id) REFERENCES Users(user_id),
    FOREIGN KEY (fk_os_id) REFERENCES OrderStatus(os_id)
);

CREATE TABLE OrderDetails (
    od_id INT PRIMARY KEY AUTO_INCREMENT,
    od_description VARCHAR(45) NOT NULL,
    fk_orde_id INT NOT NULL,
    fk_oi_id INT NOT NULL,
    FOREIGN KEY (fk_oi_id) REFERENCES OderImage(oi_id),
    FOREIGN KEY (fk_orde_id) REFERENCES Order(orde_id)
);

CREATE TABLE PaymentType (
    pt_id INT PRIMARY KEY AUTO_INCREMENT,
    pt_name VARCHAR(45) NOT NULL
);

CREATE TABLE Payment_Oder (
    po_id INT PRIMARY KEY AUTO_INCREMENT,
    fk_orde_id INT NOT NULL,
    fk_pt_id INT NOT NULL,
    po_created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (fk_orde_id) REFERENCES Order(orde_id),
    FOREIGN KEY (fk_pt_id) REFERENCES PaymentType(pt_id)
);

CREATE TABLE PaymentMercadoPago (
    pmp_id INT PRIMARY KEY AUTO_INCREMENT,
    fk_po_id INT NOT NULL,
    pmp_value DOUBLE NOT NULL,
    pmp_currency VARCHAR(20) NOT NULL,
    FOREIGN KEY (fk_po_id) REFERENCES Payment_Oder(po_id)
);

CREATE TABLE PaymentPaypal (
    pp_id INT PRIMARY KEY AUTO_INCREMENT,
    fk_po_id INT NOT NULL,
    pp_value DOUBLE NOT NULL,
    pp_currency VARCHAR(20) NOT NULL,
    FOREIGN KEY (fk_po_id) REFERENCES Payment_Oder(po_id)
);

CREATE TABLE PaymentYape (
    py_id INT PRIMARY KEY AUTO_INCREMENT,
    fk_po_id INT NOT NULL,
    py_value DOUBLE NOT NULL,
    FOREIGN KEY (fk_po_id) REFERENCES Payment_Oder(po_id)
);
