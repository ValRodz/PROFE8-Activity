# API Documentation

## Base URL
```
http://localhost/backend/api
```

## Authentication Endpoints

### 1. Register User
**Endpoint:** `POST /auth/register.php`

**Request Body:**
```json
{
  "firebase_uid": "string (required for Firebase flow)",
  "username": "string (required)",
  "email": "string (required)",
  "password": "string (optional, if not using Firebase)",
  "full_name": "string (optional)",
  "role_id": "integer (1=buyer, 2=seller, default=1)"
}
```

**Response (Success):**
```json
{
  "success": true,
  "message": "User registered",
  "user_id": 1
}
```

**Response (Error):**
```json
{
  "success": false,
  "message": "Error description"
}
```

**Status Codes:**
- 201: User created
- 409: User already exists
- 400: Missing required fields
- 500: Server error

---

### 2. Get User by Firebase UID
**Endpoint:** `POST /auth/get_user.php`

**Request Body:**
```json
{
  "firebase_uid": "string (required)"
}
```

**Response (Success):**
```json
{
  "success": true,
  "user": {
    "id": 1,
    "firebase_uid": "abc123",
    "username": "john_doe",
    "email": "john@example.com",
    "full_name": "John Doe",
    "role_id": 1,
    "created_at": "2024-01-01 10:00:00"
  }
}
```

---

### 3. Login (Deprecated - Use Firebase)
**Endpoint:** `POST /auth/login.php`

**Note:** Use Firebase Authentication instead for new implementations.

---

## Product Endpoints

### 4. Create Product
**Endpoint:** `POST /products/create.php`

**Request Body:**
```json
{
  "seller_id": "integer (required)",
  "name": "string (required)",
  "description": "string (optional)",
  "price": "decimal (required, > 0)",
  "image_url": "string (optional)",
  "stock": "integer (required, >= 0)"
}
```

**Response (Success):**
```json
{
  "success": true,
  "product_id": 123
}
```

**Response (Error):**
```json
{
  "success": false,
  "message": "Missing required fields"
}
```

**Status Codes:**
- 201: Product created
- 400: Invalid input
- 500: Server error

---

### 5. Get Products

#### Get All Products
**Endpoint:** `GET /products/read.php`

**Response (Success):**
```json
{
  "success": true,
  "products": [
    {
      "id": 1,
      "seller_id": 1,
      "name": "Product Name",
      "description": "Product description",
      "price": "99.99",
      "image_url": "https://...",
      "stock": 50,
      "created_at": "2024-01-01 10:00:00",
      "updated_at": "2024-01-02 10:00:00"
    }
  ]
}
```

---

#### Get Single Product
**Endpoint:** `GET /products/read.php?product_id=123`

**Query Parameters:**
- `product_id` (integer): Product ID

**Response (Success):**
```json
{
  "success": true,
  "product": {
    "id": 123,
    "seller_id": 1,
    "name": "Product Name",
    "description": "Product description",
    "price": "99.99",
    "image_url": "https://...",
    "stock": 50,
    "created_at": "2024-01-01 10:00:00",
    "updated_at": "2024-01-02 10:00:00"
  }
}
```

---

#### Get Seller's Products
**Endpoint:** `GET /products/read.php?seller_id=1`

**Query Parameters:**
- `seller_id` (integer): Seller user ID

**Response (Success):**
```json
{
  "success": true,
  "products": [
    {
      "id": 1,
      "seller_id": 1,
      "name": "Product 1",
      "price": "99.99",
      "stock": 50,
      ...
    },
    {
      "id": 2,
      "seller_id": 1,
      "name": "Product 2",
      "price": "199.99",
      "stock": 25,
      ...
    }
  ]
}
```

---

### 6. Update Product
**Endpoint:** `PUT /products/update.php`

**Request Body:**
```json
{
  "id": "integer (required)",
  "name": "string (optional)",
  "description": "string (optional)",
  "price": "decimal (optional)",
  "image_url": "string (optional)",
  "stock": "integer (optional)"
}
```

**Response (Success):**
```json
{
  "success": true
}
```

**Response (Error):**
```json
{
  "success": false,
  "message": "Update failed"
}
```

**Status Codes:**
- 200: Product updated
- 400: Missing product ID
- 500: Server error

---

### 7. Delete Product
**Endpoint:** `DELETE /products/delete.php`

**Request Body:**
```json
{
  "id": "integer (required)"
}
```

**Response (Success):**
```json
{
  "success": true
}
```

**Response (Error):**
```json
{
  "success": false,
  "message": "Delete failed"
}
```

**Status Codes:**
- 200: Product deleted
- 400: Missing product ID
- 500: Server error

---

## Order Endpoints

### 8. Create Order
**Endpoint:** `POST /orders/create.php`

**Request Body:**
```json
{
  "buyer_id": "integer (required)",
  "items": [
    {
      "product_id": "integer (required)",
      "quantity": "integer (required)",
      "price": "decimal (required)"
    }
  ]
}
```

**Example:**
```json
{
  "buyer_id": 1,
  "items": [
    {
      "product_id": 123,
      "quantity": 2,
      "price": 99.99
    },
    {
      "product_id": 124,
      "quantity": 1,
      "price": 49.99
    }
  ]
}
```

**Response (Success):**
```json
{
  "success": true,
  "order_id": 456
}
```

**Response (Error):**
```json
{
  "success": false,
  "message": "Order failed",
  "error": "Error details"
}
```

**Status Codes:**
- 201: Order created
- 400: Invalid input
- 500: Server error

---

### 9. Get Orders

#### Get Buyer's Orders
**Endpoint:** `GET /orders/read.php?buyer_id=1`

**Query Parameters:**
- `buyer_id` (integer): Buyer user ID

**Response (Success):**
```json
{
  "success": true,
  "orders": [
    {
      "id": 456,
      "buyer_id": 1,
      "total": "199.97",
      "status": "pending",
      "created_at": "2024-01-01 10:00:00",
      "updated_at": "2024-01-01 10:00:00"
    }
  ]
}
```

---

#### Get Seller's Orders
**Endpoint:** `GET /orders/read.php?seller_id=1`

**Query Parameters:**
- `seller_id` (integer): Seller user ID

**Response (Success):**
```json
{
  "success": true,
  "orders": [
    {
      "id": 456,
      "buyer_id": 2,
      "total": "199.97",
      "status": "pending",
      "created_at": "2024-01-01 10:00:00",
      "updated_at": "2024-01-01 10:00:00"
    }
  ]
}
```

---

#### Get All Orders
**Endpoint:** `GET /orders/read.php`

**Response (Success):**
```json
{
  "success": true,
  "orders": [
    {
      "id": 1,
      "buyer_id": 1,
      "total": "99.99",
      "status": "completed",
      "created_at": "2024-01-01 10:00:00",
      "updated_at": "2024-01-01 10:00:00"
    }
  ]
}
```

---

### 10. Update Order Status
**Endpoint:** `PUT /orders/update_status.php`

**Request Body:**
```json
{
  "order_id": "integer (required)",
  "status": "string (required)"
}
```

**Valid Status Values:**
- `pending` - Order received
- `shipped` - Order sent to buyer
- `completed` - Order delivered
- `cancelled` - Order cancelled

**Example:**
```json
{
  "order_id": 456,
  "status": "shipped"
}
```

**Response (Success):**
```json
{
  "success": true
}
```

**Response (Error):**
```json
{
  "success": false,
  "message": "Invalid status"
}
```

**Status Codes:**
- 200: Status updated
- 400: Missing fields or invalid status
- 500: Server error

---

## Error Responses

All endpoints return errors in this format:

```json
{
  "success": false,
  "message": "Error description"
}
```

### Common Error Messages

| Error | Cause | Solution |
|-------|-------|----------|
| "Missing required fields" | Request missing required parameters | Check request body against endpoint docs |
| "User already exists" | Username or email registered | Use unique username and email |
| "Database connection error" | MySQL not running | Start MySQL in XAMPP |
| "Failed to create product" | Database error | Check product data validity |
| "Invalid status" | Status not in allowed list | Use: pending, shipped, completed, cancelled |

---

## Pagination (Future Enhancement)

```
GET /products/read.php?page=1&limit=10
GET /orders/read.php?seller_id=1&page=1&limit=20
```

---

## Rate Limiting

Currently no rate limiting. For production:
- Implement request throttling
- Use API keys for authentication
- Monitor suspicious patterns

---

## CORS Headers

All endpoints return:
```
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: Content-Type, Authorization
```

---

## Authentication Headers (Future)

For production, consider adding:
```
Authorization: Bearer <JWT_TOKEN>
```

---

## Code Examples

### JavaScript/Fetch

```javascript
// Get all products
fetch('http://localhost/backend/api/products/read.php')
  .then(response => response.json())
  .then(data => console.log(data));

// Create product
fetch('http://localhost/backend/api/products/create.php', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    seller_id: 1,
    name: 'New Product',
    price: 99.99,
    stock: 10
  })
})
.then(response => response.json())
.then(data => console.log(data));
```

### Dart/HTTP

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

// Get all products
final response = await http.get(
  Uri.parse('http://localhost/backend/api/products/read.php')
);
final products = jsonDecode(response.body);

// Create product
final response = await http.post(
  Uri.parse('http://localhost/backend/api/products/create.php'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'seller_id': 1,
    'name': 'New Product',
    'price': 99.99,
    'stock': 10
  })
);
```

### cURL

```bash
# Get all products
curl http://localhost/backend/api/products/read.php

# Create product
curl -X POST http://localhost/backend/api/products/create.php \
  -H "Content-Type: application/json" \
  -d '{
    "seller_id": 1,
    "name": "New Product",
    "price": 99.99,
    "stock": 10
  }'

# Update order status
curl -X PUT http://localhost/backend/api/orders/update_status.php \
  -H "Content-Type: application/json" \
  -d '{
    "order_id": 456,
    "status": "shipped"
  }'
```

---

**Last Updated**: December 2024
**API Version**: 1.0
