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
    weight FLOAT DEFAULT NULL,
    FOREIGN KEY (place_id) REFERENCES storage_places(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

CREATE OR REPLACE VIEW current_shelf_status AS
SELECT
    s1.place_id,
    s1.shelf,
    s1.product_id,
    s1.ts,
    s1.weight  -- Додане нове поле
FROM
    shelf_product s1
INNER JOIN (
    SELECT
        place_id,
        shelf,
        MAX(ts) as latest_ts
    FROM
        shelf_product
    GROUP BY
        place_id, shelf
) s2 ON s1.place_id = s2.place_id
    AND s1.shelf = s2.shelf
    AND s1.ts = s2.latest_ts
ORDER BY
    s1.place_id, s1.shelf;

user: cold_storage
password: cold_storage

