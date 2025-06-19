# Building a Simple E-Commerce Database for a Kenyan Phone Shop with MySQL

In this blog, we'll explore the design of a MySQL database for a simple e-commerce phone shop in Kenya, focusing on selling popular phone brands like Samsung, Tecno, and Infinix. The database includes four main tables: `products`, `clients`, `orders`, and `reviews`. We'll break down each table, explain their relationships, and provide sample queries to interact with the data.

## Database Overview

The database, named `phoneshop`, is designed to manage a phone retail business. It tracks:
- **Products**: Phones available for sale, including brand, model, storage, price, and stock.
- **Clients**: Customer information, such as name, email, phone, and address.
- **Orders**: Purchase records, linking clients to their total order amount and status.
- **Reviews**: Customer feedback on products, including ratings and comments.

The schema uses primary and foreign keys to ensure data integrity and enforce relationships between tables. Let’s dive into each table.

## Table Breakdown

### 1. Products Table
The `products` table stores information about phones in the shop’s inventory.

```sql
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(100) NOT NULL,
    storage VARCHAR(20) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    description TEXT
);
```

- **Columns**:
  - `product_id`: Unique identifier for each phone (auto-incremented).
  - `brand`: Phone brand (e.g., Samsung, Tecno).
  - `model`: Specific phone model (e.g., Galaxy A14).
  - `storage`: Storage capacity (e.g., 64GB).
  - `price`: Phone price in Kenyan Shillings (KES), with two decimal places.
  - `stock`: Number of units available.
  - `description`: Optional text describing the phone’s features.
- **Constraints**:
  - `PRIMARY KEY` on `product_id` ensures uniqueness.
  - `NOT NULL` ensures required fields are filled.
- **Sample Data**:
  ```sql
  INSERT INTO products (brand, model, storage, price, stock, description) VALUES
  ('Samsung', 'Galaxy A14', '64GB', 15999.00, 50, '4G smartphone with 50MP camera');
  ```

### 2. Clients Table
The `clients` table stores customer information.

```sql
CREATE TABLE clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) NOT NULL,
    address VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

- **Columns**:
  - `client_id`: Unique identifier for each client.
  - `first_name`, `last_name`: Client’s name.
  - `email`: Unique email address for communication.
  - `phone`: Phone number in Kenyan format (e.g., +254712345678).
  - `address`: Delivery address (e.g., Nairobi, Westlands).
  - `created_at`: Timestamp of when the client was added.
- **Constraints**:
  - `UNIQUE` on `email` prevents duplicate accounts.
  - `NOT NULL` ensures all critical fields are provided.
- **Sample Data**:
  ```sql
  INSERT INTO clients (first_name, last_name, email, phone, address) VALUES
  ('John', 'Mutua', 'john.mutua@gmail.com', '+254712345678', 'Nairobi, Westlands');
  ```

### 3. Orders Table
The `orders` table tracks customer purchases.

```sql
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    FOREIGN KEY (client_id) REFERENCES clients(client_id)
);
```

- **Columns**:
  - `order_id`: Unique identifier for each order.
  - `client_id`: Links to the client who placed the order.
  - `order_date`: Timestamp of when the order was placed.
  - `total_amount`: Total cost of the order in KES.
  - `status`: Order status, restricted to predefined values.
- **Constraints**:
  - `FOREIGN KEY` ensures `client_id` references a valid client.
- **Sample Data**:
  ```sql
  INSERT INTO orders (client_id, total_amount, status) VALUES
  (1, 15999.00, 'delivered');
  ```

### 4. Reviews Table
The `reviews` table stores customer feedback on products.

```sql
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
```

- **Columns**:
  - `review_id`: Unique identifier for each review.
  - `product_id`: Links to the reviewed product.
  - `client_id`: Links to the client who wrote the review.
  - `rating`: Rating from 1 to 5 stars.
  - `comment`: Optional text feedback.
  - `review_date`: Timestamp of the review.
- **Constraints**:
  - `CHECK` ensures ratings are between 1 and 5.
  - `FOREIGN KEY` links to valid products and clients.
- **Sample Data**:
  ```sql
  INSERT INTO reviews (product_id, client_id, rating, comment) VALUES
  (1, 1, 4, 'Good phone for the price, camera is decent.');
  ```

## Relationships
- **Clients ↔ Orders**: One client can place many orders (one-to-many). The `client_id` in `orders` references `clients`.
- **Products ↔ Reviews**: One product can have many reviews (one-to-many). The `product_id` in `reviews` references `products`.
- **Clients ↔ Reviews**: One client can write many reviews (one-to-many). The `client_id` in `reviews` references `clients`.
- **Orders ↔ Products**: Not directly linked in this schema for simplicity. In a real-world scenario, an additional table (e.g., `order_details`) would link orders to specific products.

## Why This Design?
- **Simplicity**: The schema is minimal yet functional for a small phone shop.
- **Scalability**: Auto-incrementing IDs and foreign keys make it easy to expand.
- **Kenyan Context**: Prices are in KES, phone numbers use +254 format, and popular brands like Tecno and Infinix are included.
- **Data Integrity**: Constraints like `NOT NULL`, `UNIQUE`, and `FOREIGN KEY` prevent invalid data.

## Sample Queries
Here are some practical MySQL queries to interact with the database.

### 1. List All Products with Stock > 0
```sql
SELECT brand, model, storage, price, stock
FROM products
WHERE stock > 0
ORDER BY price ASC;
```

**Purpose**: Helps the shop display available phones on their website.

### 2. Find Clients Who Placed Orders
```sql
SELECT c.first_name, c.last_name, c.email, o.order_id, o.total_amount, o.status
FROM clients c
JOIN orders o ON c.client_id = o.client_id
WHERE o.order_date >= '2025-01-01';
```

**Purpose**: Retrieves recent orders with client details for follow-up.

### 3. Get Average Rating for Each Product
```sql
SELECT p.brand, p.model, AVG(r.rating) AS average_rating, COUNT(r.review_id) AS review_count
FROM products p
LEFT JOIN reviews r ON p.product_id = r.product_id
GROUP BY p.product_id
HAVING review_count > 0;
```

**Purpose**: Shows product ratings to help customers make informed decisions.

### 4. Update Stock After a Sale
```sql
UPDATE products
SET stock = stock - 1
WHERE product_id = 1 AND stock > 0;
```

**Purpose**: Reduces stock when a phone is sold.

### 5. Delete Cancelled Orders
```sql
DELETE FROM orders
WHERE status = 'cancelled' AND order_date < '2025-06-01';
```

**Purpose**: Cleans up old cancelled orders to keep the database tidy.

## Conclusion
This MySQL database schema provides a solid foundation for a Kenyan phone shop’s e-commerce platform. It’s simple, enforces data integrity, and supports key operations like inventory management, order tracking, and customer feedback. By using the sample queries, the shop can efficiently manage its data. To extend the database, you could add tables for order details, promotions, or payment records, depending on business needs.

Happy coding, and let’s keep Kenya’s phone market buzzing!