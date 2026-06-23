CREATE DATABASE ecommerce_project;
USE ecommerce_project;

-- Customers
CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(100),
  city VARCHAR(50),
  signup_date DATE
);

-- Products
CREATE TABLE products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100),
  category VARCHAR(50),
  price DECIMAL(10,2)
);

-- Orders
CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  status VARCHAR(20),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Items
CREATE TABLE order_items (
  item_id INT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  discount DECIMAL(4,2),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);



-- Insert customers
INSERT INTO customers VALUES
(1, 'Arjun Mehta', 'Mumbai', '2022-03-15'),
(2, 'Priya Nair', 'Bengaluru', '2022-06-01'),
(3, 'Rahul Das', 'Delhi', '2023-01-10'),
(4, 'Sneha Pillai', 'Kochi', '2023-04-22'),
(5, 'Vikram Rao', 'Hyderabad', '2021-11-05'),
(6, 'Ananya Singh', 'Chennai', '2022-09-18'),
(7, 'Karan Joshi', 'Pune', '2023-07-30'),
(8, 'Divya Menon', 'Bengaluru', '2021-08-14');

-- Insert products
INSERT INTO products VALUES
(1, 'Wireless Headphones', 'Electronics', 2999.00),
(2, 'Running Shoes', 'Footwear', 1499.00),
(3, 'Yoga Mat', 'Fitness', 699.00),
(4, 'Laptop Stand', 'Accessories', 1299.00),
(5, 'Water Bottle', 'Fitness', 399.00),
(6, 'Mechanical Keyboard', 'Electronics', 3499.00),
(7, 'Backpack', 'Accessories', 1999.00),
(8, 'Sunglasses', 'Fashion', 899.00);

-- Insert orders
INSERT INTO orders VALUES
(101, 1, '2023-01-15', 'Delivered'),
(102, 2, '2023-02-20', 'Delivered'),
(103, 3, '2023-03-05', 'Cancelled'),
(104, 1, '2023-04-10', 'Delivered'),
(105, 4, '2023-05-18', 'Delivered'),
(106, 5, '2023-06-22', 'Returned'),
(107, 2, '2023-07-01', 'Delivered'),
(108, 6, '2023-08-14', 'Delivered'),
(109, 7, '2023-09-03', 'Delivered'),
(110, 3, '2023-10-11', 'Delivered'),
(111, 8, '2023-11-25', 'Delivered'),
(112, 1, '2023-12-05', 'Delivered'),
(113, 4, '2024-01-08', 'Delivered'),
(114, 5, '2024-02-14', 'Cancelled'),
(115, 6, '2024-03-20', 'Delivered');

-- Insert order_items
INSERT INTO order_items VALUES
(1,  101, 1, 1, 0.00),
(2,  101, 4, 2, 0.10),
(3,  102, 2, 1, 0.00),
(4,  102, 5, 3, 0.05),
(5,  103, 6, 1, 0.00),
(6,  104, 3, 2, 0.00),
(7,  104, 7, 1, 0.15),
(8,  105, 1, 1, 0.10),
(9,  106, 8, 2, 0.00),
(10, 107, 6, 1, 0.00),
(11, 107, 4, 1, 0.10),
(12, 108, 2, 2, 0.05),
(13, 109, 5, 4, 0.00),
(14, 109, 3, 1, 0.00),
(15, 110, 7, 1, 0.00),
(16, 111, 1, 1, 0.20),
(17, 112, 6, 1, 0.00),
(18, 113, 2, 1, 0.10),
(19, 114, 8, 3, 0.00),
(20, 115, 4, 2, 0.05);