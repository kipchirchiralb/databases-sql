-- Creating the database
CREATE DATABASE phoneshop;
USE phoneshop;

-- Creating the products table
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(100) NOT NULL,
    storage VARCHAR(20) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    description TEXT
);

-- Creating the clients table
CREATE TABLE clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) NOT NULL,
    address VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Creating the orders table
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    FOREIGN KEY (client_id) REFERENCES clients(client_id)
);

-- Creating the reviews table
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    client_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (client_id) REFERENCES clients(client_id)
);

-- Inserting sample data into products
INSERT INTO products (brand, model, storage, price, stock, description) VALUES
('Samsung', 'Galaxy A14', '64GB', 15999.00, 50, '4G smartphone with 50MP camera'),
('Tecno', 'Spark 10 Pro', '128GB', 17999.00, 30, '6.8" display, 5000mAh battery'),
('Xiaomi', 'Redmi Note 12', '128GB', 21999.00, 25, 'AMOLED display, 48MP camera'),
('Infinix', 'Hot 30', '64GB', 13999.00, 40, '90Hz display, dual SIM'),
('Nokia', 'C32', '64GB', 12999.00, 20, '6.5" HD+ display, 5000mAh battery');

-- Inserting sample data into clients
INSERT INTO clients (first_name, last_name, email, phone, address) VALUES
('John', 'Mutua', 'john.mutua@gmail.com', '+254712345678', 'Nairobi, Westlands'),
('Esther', 'Wanjiku', 'esther.wanjiku@yahoo.com', '+254723456789', 'Mombasa, Nyali'),
('Peter', 'Kamau', 'peter.kamau@outlook.com', '+254734567890', 'Kisumu, Milimani');

-- Inserting sample data into orders
INSERT INTO orders (client_id, total_amount, status) VALUES
(1, 15999.00, 'delivered'),
(2, 35998.00, 'shipped'),
(3, 21999.00, 'processing');

-- Inserting sample data into reviews
INSERT INTO reviews (product_id, client_id, rating, comment) VALUES
(1, 1, 4, 'Good phone for the price, camera is decent.'),
(2, 2, 5, 'Love the battery life on this Tecno!'),
(3, 3, 3, 'Nice display but performance could be better.');