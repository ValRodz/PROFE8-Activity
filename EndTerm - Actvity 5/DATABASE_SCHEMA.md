# Database Schema Documentation

## Overview

This e-commerce application uses a relational database with 7 tables to manage users, products, orders, and shopping carts.

---

## Table Definitions

### 1. roles
**Purpose:** Define user roles in the system

```sql
CREATE TABLE IF NOT EXISTS roles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE
);

INSERT IGNORE INTO roles (name) VALUES ('user'), ('seller'), ('admin');
```

| Column | Type | Description |
|--------|------|-------------|
| id | INT | Primary key, auto-increment |
| name | VARCHAR(50) | Role name (user, seller, admin) |

**Indexes:** PRIMARY KEY (id), UNIQUE (name)

---

### 2. users
**Purpose:** Store user account information

```sql
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  firebase_uid VARCHAR(255) DEFAULT NULL,
  username VARCHAR(100) UNIQUE,
  email VARCHAR(150) UNIQUE,
  password VARCHAR(255) DEFAULT NULL,
  full_name VARCHAR(200) DEFAULT NULL,
  role_id INT DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (role_id) REFERENCES roles(id)
);
```

| Column | Type | Constraints | Description |
|--------|------|-----------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT | User ID |
| firebase_uid | VARCHAR(255) | UNIQUE | Firebase Authentication UID |
| username | VARCHAR(100) | UNIQUE | Login username |
| email | VARCHAR(150) | UNIQUE | User email address |
| password | VARCHAR(255) | NULLABLE | Hashed password (for legacy login) |
| full_name | VARCHAR(200) | NULLABLE | User's full name |
| role_id | INT | FOREIGN KEY → roles.id | User role (1=buyer, 2=seller, 3=admin) |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Account creation date |

**Relationships:**
- Foreign Key: role_id → roles(id)

**Sample Data:**
```sql
-- Buyer user
INSERT INTO users (firebase_uid, username, email, password, full_name, role_id)
VALUES ('abc123', 'john_buyer', 'john@example.com', MD5('test123'), 'John Buyer', 1);

-- Seller user
INSERT INTO users (firebase_uid, username, email, password, full_name, role_id)
VALUES ('def456', 'jane_seller', 'jane@example.com', MD5('test123'), 'Jane Seller', 2);
```

---

### 3. products
**Purpose:** Store product information created by sellers

```sql
CREATE TABLE IF NOT EXISTS products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  seller_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  image_url TEXT,
  stock INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (seller_id) REFERENCES users(id)
);
```

| Column | Type | Constraints | Description |
|--------|------|-----------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT | Product ID |
| seller_id | INT | FOREIGN KEY → users.id | Seller's user ID |
| name | VARCHAR(255) | NOT NULL | Product name |
| description | TEXT | NULLABLE | Product description |
| price | DECIMAL(10,2) | NOT NULL, DEFAULT 0.00 | Product price |
| image_url | TEXT | NULLABLE | URL to product image (Firebase Storage) |
| stock | INT | NOT NULL, DEFAULT 0 | Available quantity |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation date |
| updated_at | TIMESTAMP | AUTO ON UPDATE | Last modification date |

**Relationships:**
- Foreign Key: seller_id → users(id)

**Indexes:**
```sql
CREATE INDEX idx_seller_id ON products(seller_id);
```

**Sample Data:**
```sql
-- Product from seller Jane
INSERT INTO products (seller_id, name, description, price, stock)
VALUES (2, 'Fresh Apples', 'Red crisp apples from local farm', 4.99, 100);

-- Another product
INSERT INTO products (seller_id, name, description, price, stock)
VALUES (2, 'Organic Bananas', 'Yellow ripened bananas, organic', 2.99, 75);
```

---

### 4. orders
**Purpose:** Store customer orders

```sql
CREATE TABLE IF NOT EXISTS orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  buyer_id INT NOT NULL,
  total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  status ENUM('pending','shipped','completed','cancelled') DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (buyer_id) REFERENCES users(id)
);
```

| Column | Type | Constraints | Description |
|--------|------|-----------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT | Order ID |
| buyer_id | INT | FOREIGN KEY → users.id | Buyer's user ID |
| total | DECIMAL(10,2) | NOT NULL, DEFAULT 0.00 | Order total amount |
| status | ENUM | DEFAULT 'pending' | Order status (pending, shipped, completed, cancelled) |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Order creation date |
| updated_at | TIMESTAMP | AUTO ON UPDATE | Last status update |

**Relationships:**
- Foreign Key: buyer_id → users(id)

**Indexes:**
```sql
CREATE INDEX idx_buyer_id ON orders(buyer_id);
```

**Status Workflow:**
```
pending → shipped → completed
            ↓
          cancelled
```

**Sample Data:**
```sql
-- John's order
INSERT INTO orders (buyer_id, total, status)
VALUES (1, 19.96, 'pending');

-- Another order (shipped)
INSERT INTO orders (buyer_id, total, status)
VALUES (1, 14.97, 'shipped');
```

---

### 5. order_items
**Purpose:** Store individual items in orders (junction table)

```sql
CREATE TABLE IF NOT EXISTS order_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);
```

| Column | Type | Constraints | Description |
|--------|------|-----------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT | Item ID |
| order_id | INT | FOREIGN KEY → orders.id | Related order |
| product_id | INT | FOREIGN KEY → products.id | Related product |
| quantity | INT | NOT NULL, DEFAULT 1 | Quantity ordered |
| price | DECIMAL(10,2) | NOT NULL, DEFAULT 0.00 | Price at time of order |

**Relationships:**
- Foreign Key: order_id → orders(id)
- Foreign Key: product_id → products(id)

**Indexes:**
```sql
CREATE INDEX idx_order_id ON order_items(order_id);
CREATE INDEX idx_product_id ON order_items(product_id);
```

**Sample Data:**
```sql
-- Order 1 contains 2 products
INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (1, 1, 2, 4.99);  -- 2x Apples at $4.99 each

INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (1, 2, 2, 2.99);  -- 2x Bananas at $2.99 each
```

---

### 6. carts
**Purpose:** Store shopping carts for users (optional, for future implementation)

```sql
CREATE TABLE IF NOT EXISTS carts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
```

| Column | Type | Constraints | Description |
|--------|------|-----------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT | Cart ID |
| user_id | INT | FOREIGN KEY → users.id | User's cart |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Cart creation date |

**Note:** Currently, cart is implemented client-side in Flutter with SharedPreferences.

---

### 7. cart_items
**Purpose:** Store items in shopping carts (optional)

```sql
CREATE TABLE IF NOT EXISTS cart_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  cart_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  FOREIGN KEY (cart_id) REFERENCES carts(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);
```

| Column | Type | Constraints | Description |
|--------|------|-----------|-------------|
| id | INT | PRIMARY KEY, AUTO_INCREMENT | Item ID |
| cart_id | INT | FOREIGN KEY → carts.id | Related cart |
| product_id | INT | FOREIGN KEY → products.id | Related product |
| quantity | INT | NOT NULL, DEFAULT 1 | Quantity in cart |

---

## Entity Relationship Diagram

```
┌──────────────┐
│    roles     │
│──────────────│
│ id (PK)      │
│ name         │
└──────────────┘
       △
       │
       │ (1:N)
       │
┌──────────────────────┐
│      users           │
│──────────────────────│
│ id (PK)              │
│ firebase_uid (UQ)    │
│ username (UQ)        │
│ email (UQ)           │
│ password             │
│ full_name            │
│ role_id (FK)         │
│ created_at           │
└──────────────────────┘
       │                 │
       │ (1:N)           │ (1:N)
       │                 │
       ▼                 ▼
┌──────────────────────┐ ┌──────────────────┐
│    products          │ │     orders       │
│──────────────────────│ │──────────────────│
│ id (PK)              │ │ id (PK)          │
│ seller_id (FK)       │ │ buyer_id (FK)    │
│ name                 │ │ total            │
│ description          │ │ status           │
│ price                │ │ created_at       │
│ image_url            │ │ updated_at       │
│ stock                │ └──────────────────┘
│ created_at           │         │
│ updated_at           │         │ (1:N)
└──────────────────────┘         │
       │                         ▼
       │                  ┌──────────────────┐
       │ (1:N)            │  order_items     │
       │ ┌────────────────│──────────────────│
       │ │                │ id (PK)          │
       ▼ ▼                │ order_id (FK)    │
┌──────────────────────┐  │ product_id (FK)  │
│   cart_items (opt)   │  │ quantity         │
│──────────────────────│  │ price            │
│ id (PK)              │  └──────────────────┘
│ cart_id (FK)         │
│ product_id (FK)      │
│ quantity             │
└──────────────────────┘
```

---

## Queries Reference

### Get All Products
```sql
SELECT * FROM products ORDER BY created_at DESC;
```

### Get Seller's Products
```sql
SELECT * FROM products WHERE seller_id = ? ORDER BY created_at DESC;
```

### Get Single Product
```sql
SELECT * FROM products WHERE id = ?;
```

### Get Buyer's Orders
```sql
SELECT * FROM orders WHERE buyer_id = ? ORDER BY created_at DESC;
```

### Get Order Details
```sql
SELECT oi.*, p.name, p.price as current_price
FROM order_items oi
JOIN products p ON p.id = oi.product_id
WHERE oi.order_id = ?;
```

### Get Seller's Orders
```sql
SELECT DISTINCT o.*
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
JOIN products p ON p.id = oi.product_id
WHERE p.seller_id = ?
ORDER BY o.created_at DESC;
```

### Get Product Stock Count
```sql
SELECT SUM(stock) as total_stock FROM products WHERE seller_id = ?;
```

### Get Total Sales by Seller
```sql
SELECT p.seller_id, COUNT(oi.id) as total_items, SUM(oi.price * oi.quantity) as total_revenue
FROM order_items oi
JOIN products p ON p.id = oi.product_id
GROUP BY p.seller_id;
```

### Get Order History with Products
```sql
SELECT o.id, o.buyer_id, o.total, o.status, o.created_at,
       GROUP_CONCAT(p.name SEPARATOR ', ') as products
FROM orders o
LEFT JOIN order_items oi ON oi.order_id = o.id
LEFT JOIN products p ON p.id = oi.product_id
WHERE o.buyer_id = ?
GROUP BY o.id
ORDER BY o.created_at DESC;
```

---

## Data Types Used

| Type | Size | Usage |
|------|------|-------|
| INT | 4 bytes | IDs, quantities, counts |
| VARCHAR(n) | Up to n | Text with max length |
| TEXT | 64KB | Long text (descriptions) |
| DECIMAL(10,2) | Variable | Prices, totals |
| TIMESTAMP | 4 bytes | Dates and times |
| ENUM | 1-2 bytes | Fixed options (status) |

---

## Constraints

### Primary Keys
- Ensure unique identification
- Auto-increment for convenience
- Used for foreign key relationships

### Foreign Keys
- Maintain referential integrity
- Prevent orphaned records
- Enable cascade operations

### Unique Constraints
- username (single per user)
- email (single per user)
- firebase_uid (single per user)

### Not Null Constraints
- seller_id, buyer_id
- name (products)
- price, stock (products)

### Enum Constraints
- order status: pending, shipped, completed, cancelled

---

## Indexing Strategy

```sql
-- Primary indexes (automatic)
-- id columns on all tables

-- Foreign key indexes (automatic)
-- Improve JOIN performance

-- Additional recommended indexes
CREATE INDEX idx_seller_id ON products(seller_id);
CREATE INDEX idx_buyer_id ON orders(buyer_id);
CREATE INDEX idx_product_id ON order_items(product_id);
CREATE INDEX idx_order_id ON order_items(order_id);
CREATE INDEX idx_firebase_uid ON users(firebase_uid);
CREATE INDEX idx_username ON users(username);
```

---

## Normalization

Database follows **Third Normal Form (3NF):**

1. **1NF:** All values are atomic (no repeating groups)
2. **2NF:** All non-key attributes depend on entire primary key
3. **3NF:** No transitive dependencies between non-key attributes

---

## Data Integrity

### Referential Integrity
- Foreign keys enforce valid relationships
- Prevents creating orders for non-existent users
- Prevents creating order items for deleted products

### Example Transaction (Create Order):
```php
$db->begin_transaction();
try {
    // 1. Create order
    INSERT INTO orders (buyer_id, total) VALUES (?, ?);
    $order_id = $db->insert_id;
    
    // 2. Add order items
    foreach ($items as $item) {
        INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?);
        
        // 3. Reduce product stock
        UPDATE products SET stock = stock - ? WHERE id = ?;
    }
    
    $db->commit();
} catch (Exception $e) {
    $db->rollback();
    // Handle error
}
```

---

## Scaling Considerations

For larger applications, consider:

1. **Partitioning:**
   - Partition orders by date
   - Partition products by seller
   
2. **Archiving:**
   - Archive old orders
   - Keep recent data in main table

3. **Replication:**
   - Read replicas for queries
   - Write to master

4. **Denormalization:**
   - Cache total in products table
   - Store seller name in products

5. **Additional Tables:**
   - reviews
   - categories
   - wishlist
   - inventory_logs
   - payment_transactions

---

## Backup and Recovery

### Backup Database
```bash
mysqldump -u root crud_app_db > backup.sql
```

### Restore Database
```bash
mysql -u root crud_app_db < backup.sql
```

### Scheduled Backups (Cron Job)
```bash
0 2 * * * mysqldump -u root crud_app_db > /backups/db_$(date +\%Y\%m\%d).sql
```

---

**Last Updated:** December 2024
**Version:** 1.0
