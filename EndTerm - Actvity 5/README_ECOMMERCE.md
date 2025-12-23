# Flutter E-Commerce Application with Firebase and MySQL

A complete mobile e-commerce application built with Flutter, featuring Firebase Authentication and MySQL database through a PHP REST API backend.

## Features

### 1. **User Authentication**
- Register and login using Firebase Authentication
- Secure password management with Firebase
- Email verification support
- Forgot password functionality with email reset links
- User session management with SharedPreferences

### 2. **User Roles**
- **Buyer Role**: Can browse products, add to cart, place orders
- **Seller Role**: Can manage products, view incoming orders, update order status
- **Admin Role**: Can manage system (extensible)

### 3. **Product Management (Seller Features)**
- Add new products with name, description, price, image URL, and stock quantity
- Edit existing products
- Delete products
- Upload product images to Firebase Storage or external URLs
- View all their products in real-time

### 4. **Product Browsing (Buyer Features)**
- Browse all available products from all sellers
- Search products by name or description
- View product details with full information
- Product availability and stock status

### 5. **Order Management**
- **Buyers**: Place orders, track order status
- **Sellers**: View incoming orders, update order status
- Order statuses: Pending, Shipped, Completed, Cancelled
- Real-time order updates

### 6. **Enhanced Forms**
- Dropdown menu for user role selection during registration
- Date picker for date of birth
- Time picker for preferred contact time
- Form validation with helpful error messages

## Technology Stack

### Frontend
- **Framework**: Flutter (Android & iOS)
- **State Management**: Provider (extensible)
- **Local Storage**: SharedPreferences
- **Networking**: HTTP for REST API calls
- **Authentication**: Firebase Authentication

### Backend
- **Server**: PHP with MySQL
- **Database**: MySQL
- **API**: REST API with JSON
- **Server Stack**: XAMPP (Apache + MySQL + PHP)

### Cloud Services
- **Authentication**: Firebase Auth
- **Image Storage**: Firebase Storage (optional)

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── screens/
│   ├── login_screen.dart             # Login with forgot password link
│   ├── register_screen.dart          # Register with role, date, time pickers
│   ├── forgot_password_screen.dart   # Password reset via email
│   ├── home_screen.dart              # Dashboard for buyers and sellers
│   ├── browse_products_screen.dart   # Product browsing with search
│   ├── product_detail_screen.dart    # Single product details and add to cart
│   ├── product_management_screen.dart # Seller product CRUD operations
│   ├── add_product_screen.dart       # Add new product
│   ├── edit_product_screen.dart      # Edit existing product
│   ├── seller_orders_screen.dart     # Seller view of incoming orders
│   └── note_form_screen.dart         # Notes management (bonus feature)
├── models/
│   ├── note_model.dart               # Note data model
│   ├── product_model.dart            # Product data model
│   └── order_model.dart              # Order and OrderItem data models
├── services/
│   ├── api_service.dart              # All API endpoints
│   └── auth_service.dart             # Firebase auth service
└── pubspec.yaml                      # Dependencies

backend/
├── config/
│   └── database.php                  # MySQL database connection
├── api/
│   ├── auth/
│   │   ├── register.php              # User registration
│   │   ├── login.php                 # User login (deprecated, use Firebase)
│   │   └── get_user.php              # Get user by Firebase UID
│   ├── products/
│   │   ├── create.php                # Add product
│   │   ├── read.php                  # Get products
│   │   ├── update.php                # Update product
│   │   └── delete.php                # Delete product
│   └── orders/
│       ├── create.php                # Create order from cart
│       ├── read.php                  # Get orders (by seller or buyer)
│       └── update_status.php         # Update order status
└── db/
    └── schema.sql                    # Database schema and tables
```

## Database Schema

### Users Table
```sql
CREATE TABLE users (
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

### Roles Table
```sql
CREATE TABLE roles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE
);
-- Insert: user, seller, admin
```

### Products Table
```sql
CREATE TABLE products (
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

### Orders Table
```sql
CREATE TABLE orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  buyer_id INT NOT NULL,
  total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  status ENUM('pending','shipped','completed','cancelled') DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (buyer_id) REFERENCES users(id)
);
```

### Order Items Table
```sql
CREATE TABLE order_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);
```

### Cart Table (Optional)
```sql
CREATE TABLE carts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE cart_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  cart_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  FOREIGN KEY (cart_id) REFERENCES carts(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);
```

## API Endpoints

### Authentication
- `POST /backend/api/auth/register.php` - Register user with Firebase UID and profile
- `POST /backend/api/auth/login.php` - Traditional login (deprecated, use Firebase)
- `POST /backend/api/auth/get_user.php` - Get user profile by Firebase UID

### Products
- `POST /backend/api/products/create.php` - Create product (sellers only)
- `GET /backend/api/products/read.php?product_id=X` - Get single product
- `GET /backend/api/products/read.php?seller_id=X` - Get seller's products
- `GET /backend/api/products/read.php` - Get all products
- `PUT /backend/api/products/update.php` - Update product (sellers only)
- `DELETE /backend/api/products/delete.php` - Delete product (sellers only)

### Orders
- `POST /backend/api/orders/create.php` - Create order from cart items
- `GET /backend/api/orders/read.php?buyer_id=X` - Get buyer's orders
- `GET /backend/api/orders/read.php?seller_id=X` - Get seller's orders
- `PUT /backend/api/orders/update_status.php` - Update order status (sellers only)

## Installation & Setup

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- PHP 7.4 or higher
- MySQL 5.7 or higher
- XAMPP or similar local server
- Firebase project with Authentication enabled

### Backend Setup

1. **Start XAMPP**
   ```bash
   # Windows
   xampp-control.exe
   # Start Apache and MySQL
   ```

2. **Create Database**
   ```bash
   mysql -u root -p
   CREATE DATABASE crud_app_db;
   USE crud_app_db;
   source backend/db/schema.sql;
   ```

3. **Configure Database Connection**
   Edit `backend/config/database.php`:
   ```php
   private $host = "localhost";
   private $db_name = "crud_app_db";
   private $username = "root";        // Your MySQL username
   private $password = "";            // Your MySQL password
   ```

4. **Verify Backend**
   Visit `http://localhost/backend/api/auth/get_user.php` in browser - should work without errors

### Flutter Setup

1. **Get Dependencies**
   ```bash
   flutter pub get
   ```

2. **Configure Firebase**
   - Download `google-services.json` from Firebase Console
   - Place in `android/app/` directory
   - Update iOS configuration in Firebase Console

3. **Update API Base URL** (if using production server)
   Edit `lib/services/api_service.dart`:
   ```dart
   static const String baseUrl = 'http://your-server-url/backend/api';
   ```

4. **Run Application**
   ```bash
   flutter run
   ```

## User Flows

### Buyer Flow
1. **Register/Login** → Firebase Authentication
2. **Browse Products** → Search and filter
3. **View Product Details** → Full information and stock status
4. **Add to Cart** → Quantity selection
5. **Checkout** → Create order in MySQL
6. **Track Order** → View order status

### Seller Flow
1. **Register/Login** → Firebase Authentication (select "Seller" role)
2. **Add Products** → Name, price, description, image, stock
3. **Edit Products** → Update pricing or inventory
4. **Delete Products** → Remove from catalog
5. **View Orders** → See incoming orders
6. **Update Order Status** → Pending → Shipped → Completed

## API Request/Response Examples

### Register User
**Request:**
```json
POST /backend/api/auth/register.php
{
  "firebase_uid": "abc123",
  "username": "john_seller",
  "email": "john@example.com",
  "full_name": "John Doe",
  "role_id": 2
}
```

**Response:**
```json
{
  "success": true,
  "message": "User registered",
  "user_id": 1
}
```

### Create Product
**Request:**
```json
POST /backend/api/products/create.php
{
  "seller_id": 1,
  "name": "Apple iPhone 14",
  "description": "Latest iPhone model",
  "price": 999.99,
  "image_url": "https://...",
  "stock": 50
}
```

**Response:**
```json
{
  "success": true,
  "product_id": 123
}
```

### Get All Products
**Request:**
```
GET /backend/api/products/read.php
```

**Response:**
```json
{
  "success": true,
  "products": [
    {
      "id": 1,
      "seller_id": 1,
      "name": "Product Name",
      "description": "Description",
      "price": "99.99",
      "image_url": "url",
      "stock": 50,
      "created_at": "2024-01-01 10:00:00"
    }
  ]
}
```

## Features Implemented

✅ User registration and login with Firebase Authentication
✅ Forgot password functionality
✅ Dropdown role selection (Buyer/Seller)
✅ Date picker for date of birth
✅ Time picker for contact time
✅ Product CRUD operations for sellers
✅ Product browsing and search for buyers
✅ Order creation and management
✅ Order status tracking and updates
✅ Role-based UI (different screens for buyers and sellers)
✅ Image URL support for products (Firebase Storage compatible)
✅ Stock management and availability status
✅ Responsive UI with Material Design 3
✅ Error handling and validation
✅ Session management with SharedPreferences
✅ REST API integration

## Future Enhancements

- [ ] Image upload directly to Firebase Storage
- [ ] Shopping cart persistence in database
- [ ] Payment integration (Stripe, PayPal)
- [ ] Product ratings and reviews
- [ ] Seller ratings and reviews
- [ ] Order tracking with location
- [ ] Notifications (Firebase Cloud Messaging)
- [ ] Product categories and filters
- [ ] Wishlist functionality
- [ ] Analytics dashboard for sellers
- [ ] Admin panel for system management
- [ ] Dark mode support
- [ ] Multi-language support
- [ ] Unit and integration tests

## Troubleshooting

### API Connection Issues
- Ensure XAMPP is running (Apache + MySQL)
- Check if firewall allows requests to localhost
- Verify backend URL in `api_service.dart`
- Check browser console for CORS errors

### Firebase Authentication Issues
- Verify Firebase project is properly configured
- Check `google-services.json` is in correct location
- Ensure Firebase credentials are valid
- Review Firebase Console for authentication settings

### Database Issues
- Verify database and tables were created correctly
- Check MySQL user credentials in `database.php`
- Ensure tables have proper foreign key relationships
- Monitor MySQL for syntax errors

### Product Image Issues
- Use valid image URLs (HTTPS recommended)
- Firebase Storage URLs work best
- Ensure image file exists at URL
- Check network permissions in Android manifest

## Support & Contact

For issues or questions:
1. Check existing documentation
2. Review API response errors
3. Check browser/Flutter console logs
4. Verify all prerequisites are installed

## License

This project is provided as-is for educational purposes.

---

**Version**: 1.0.0
**Last Updated**: December 2024
