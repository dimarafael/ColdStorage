CREATE TABLE storage_places (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) DEFAULT NULL,
    shelves INT
);

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    code INT NOT NULL,
    stage1Hours INT NOT NULL,
    stage2Hours INT NOT NULL,
    stage3Hours INT NOT NULL
);

CREATE TABLE shelf_product (
    id INT AUTO_INCREMENT PRIMARY KEY,
    place_id INT NOT NULL,
    shelf INT NOT NULL,
    product_id INT DEFAULT NULL,
    ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (place_id) REFERENCES storage_places(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

user: cold_storage
password: cold_storage

