--https://dontpad.com/fs17--
CREATE DATABASE IF NOT EXISTS digital_Store;

USE digital_Store;

CREATE TABLE IF NOT EXISTS banners(
    banner_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    banner_image VARCHAR(100) NULL,
    banner_image_bg VARCHAR(100) NULL,
    banner_title VARCHAR(50) NOT NULL,
    banner_title_sup VARCHAR(50) NOT NULL,
    banner_discription VARCHAR(255) NOT NULL,
    banner_cta_text VARCHAR(20) NOT NULL,
    banner_status INTEGER DEFAULT 1
);

CREATE TABLE IF NOT EXISTS brands(
    brand_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(20) NOT NULL,
    brand_status INTEGER DEFAULT 1 
);

INSERT INTO brands (brand_name) VALUES 
('Nike'),
('Adidas'),
('Olimpikus'),
('Puma'),
('Mizuno'),
('Penalty'),
('Okley'),
('Umbro'),
('New balance'),
('Lacoste'),
('Balenciaga');

CREATE TABLE IF NOT EXISTS categories(
    category_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    category_name VARCHAR(20) NOT NULL,
    category_status INTEGER DEFAULT 1
);

INSERT INTO categories (category_name, category_status)
VALUES
('Tênis', 1),
('Camisetas', 1),
('Calças', 1),
('Bonés', 1),
('Headphones', 1),
('Bolsas', 0);

CREATE TABLE IF NOT EXISTS users(
    user_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    user_name VARCHAR(20) NOT NULL,
    user_status INTEGER DEFAULT 1,
    user_email VARCHAR(255) NOT NULL,
    user_fone INTEGER NOT NULL,
    user_data_nasc DATE NOT NULL
);

INSERT INTO users (user_name, user_status, user_email, user_fone, user_data_nasc)
VALUES
('Breno', 1, 'breno@gmail.com', '85988888888', '2004-09-02'),
('José', 1, 'jose@gmail.com', '85988888877', '2000-09-02'),
('Maria', 1, 'maria@gmail.com', '85988888866', '1993-09-02'),
('João', 1, 'joao@gmail.com', '85988888855', '1984-09-02'),
('Antônio', 1, 'antonio@gmail.com', '85988888844', '1999-09-02'),
('Rodrigo', 0, 'rodrigo@gmail.com', '85988888833', '2006-09-02'),
('Eduardo', 0, 'edu@gmail.com', '85988888822', '1888-09-02');

ALTER TABLE users ADD (
    user_fone INTEGER NOT NULL,
    user_data_nasc DATE NOT NULL
);

ALTER TABLE users MODIFY COLUMN user_fone BIGINT NOT NULL;

CREATE TABLE IF NOT EXISTS reviews(
    review_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    review_rate INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    review_text VARCHAR(255) NULL,
    review_status INTEGER DEFAULT 1,
    FOREIGN KEY (user_id) REFERENCES users (user_id)
);

CREATE TABLE IF NOT EXISTS genders(
	gender_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	gender_name VARCHAR(50) NOT NULL,
	gender_status INTEGER DEFAULT 1
);

CREATE TABLE IF NOT EXISTS products(
    product_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    product_image BLOB(100) NULL,
    product_discount INTEGER NOT NULL,
    product_price FLOAT NOT NULL,
    product_sizes VARCHAR(50) NULL,
    product_name VARCHAR(20) NOT NULL,
    product_discription VARCHAR(255) NULL,
    product_category VARCHAR(10) NOT NULL,
    product_colors VARCHAR(10) NOT NULL,
    product_status INTEGER DEFAULT 1,
    product_condition INTEGER DEFAULT 1
);

ALTER TABLE products DROP product_discription;
ALTER TABLE products ADD product_description VARCHAR(255) NULL;
--teste--

INSERT INTO products (product_price, product_name, product_description, category_id, brand_id, product_discount, product_category, product_colors)
SELECT 
    ROUND(RAND() * (100 - 10) + 10, 2) as product_price,
    CASE 
        WHEN RAND() < 0.5 THEN 'Tênis'
        ELSE 'Camisa'
    END as product_name,
    SUBSTRING('Lorem ipsum dolor sit amet, consectetur adipiscing elit.', 1, FLOOR(RAND() * 50) + 1) as product_description,
    FLOOR(RAND() * 5) + 1 as category_id,
    FLOOR(RAND() * 10) + 1 as brand_id,
    0.00 as product_discount,
    'Categoria' as product_category, -- Substitua 'Categoria' pelo valor desejado
    'Cores' as product_colors -- Substitua 'Cores' pelo valor desejado
FROM 
    information_schema.tables
LIMIT 100;

SELECT product_id, product_name, product_price, category_id, brand_id FROM products;
SELECT product_id, product_name, product_price, category_id, brand_id FROM products ORDER BY product_price ASC;

SELECT product_id, product_name, product_price, category_id, brand_id FROM products WHERE product_name= 'camisa';

SELECT product_id, product_name, product_price, category_id, brand_id FROM products WHERE product_price > 15 AND product_price < 30 ORDER BY product_price;

SELECT COUNT(*) FROM products WHERE product_price < 30;

SELECT product_id, product_name, product_image, product_description, product_sizes, product_colors, product_price, products.category_id, category_name, products.brand_id, brand_name
FROM products 
INNER JOIN categories ON products.category_id = categories.category_id 
INNER JOIN brands ON products.brand_id = brands.brand_id
WHERE product_id = 30;

UPDATE products SET product_name = 'camisa 1' WHERE product_id = 4;
--ajustes--

ALTER TABLE products ADD(
    brand_id INTEGER FOREIGN KEY (brand_id) REFERENCES brands(brand_id),
    category_id INTEGER FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE IF NOT EXISTS products_images (
	product_image_id INTEGER AUTO_INCREMENT PRIMARY KEY,
	product_image_url VARCHAR(100) NOT NULL,
	product_id INTEGER NOT NULL,
	FOREIGN KEY(product_id) REFERENCES products (product_id)
);

INSERT INTO products_images (product_image_url, product_id)
VALUES
('https://imgnike-a.akamaihd.net/768x768/027796NX.jpg', 30),
('https://imgnike-a.akamaihd.net/768x768/027796NXA1.jpg', 30),
('https://imgnike-a.akamaihd.net/768x768/027796NXA2.jpg', 30),
('https://imgnike-a.akamaihd.net/768x768/027796NXA3.jpg', 31);

CREATE TABLE IF NOT EXISTS collections(
    collection_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    collection_image_bg BLOB(100) NULL,
    collection_discount INTEGER NOT NULL,
    collection_title VARCHAR(10) NOT NULL,
    collection_cta_txt VARCHAR(250) NOT NULL,
    collection_status INTEGER DEFAULT 1
);

CREATE TABLE IF NOT EXISTS orders(
    order_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    total_order INTEGER NOT NULL,
    total_order_discount INTEGER NOT NULL,
    order_ship VARCHAR(10) NOT NULL,
    order_status INTEGER DEFAULT 1,
    user_id INTEGER,
    FOREIGN KEY(user_id) REFERENCES users (user_id)
);

CREATE TABLE IF NOT EXISTS carts(
    cart_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    cart_products VARCHAR(100) NOT NULL
);