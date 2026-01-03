CREATE DATABASE inventory_management;
USE inventory_management;


-- ADMIN TABLE
CREATE TABLE admin (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    admin_name VARCHAR(50) NOT NULL
);


-- USERS TABLE
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role ENUM('ADMIN', 'USER') NOT NULL
);


-- CATEGORIES TABLE
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);


-- ITEMS TABLE
CREATE TABLE items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    size ENUM('SMALL', 'MEDIUM', 'LARGE') NOT NULL,
    category_id INT NOT NULL,
    description VARCHAR(255),
    admin_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (admin_id) REFERENCES admin(admin_id)
);


-- ORDERS TABLE
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    approved_by INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (approved_by) REFERENCES admin(admin_id)
);



-- ORDER_ITEMS TABLE
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);



-- SAMPLE DATA
INSERT INTO admin (admin_name) VALUES
('Main Admin');

INSERT INTO users (name, email, role) VALUES
('Admin User', 'admin@company.com', 'ADMIN'),
('Regular User', 'user@company.com', 'USER');

INSERT INTO categories (category_name) VALUES
('Electronics'),
('Office Supplies');

INSERT INTO items (name, price, size, category_id, description, admin_id) VALUES
('Laptop', 1500.00, 'LARGE', 1, 'Company laptop', 1),
('Mouse', 25.00, 'SMALL', 1, 'Wireless mouse', 1),
('Notebook', 5.00, 'MEDIUM', 2, 'Office notebook', 1);

INSERT INTO orders (user_id) VALUES
(2);

INSERT INTO order_items (order_id, item_id, quantity) VALUES
(1, 1, 1),
(1, 2, 2);


-- SELECT QUERIES

-- Orders with users
SELECT o.order_id, u.name AS user_name, o.status
FROM orders o
JOIN users u ON o.user_id = u.user_id;

-- Items with categories
SELECT i.name AS item_name, c.category_name
FROM items i
JOIN categories c ON i.category_id = c.category_id;

-- Orders with items
SELECT 
    o.order_id,
    u.name AS customer,
    i.name AS item,
    oi.quantity
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN items i ON oi.item_id = i.item_id;

-- Update order approval
UPDATE orders
SET status = 'APPROVED', approved_by = 1
WHERE order_id = 1;

-- Delete order
DELETE FROM order_items WHERE order_id = 1;
DELETE FROM orders WHERE order_id = 1;
