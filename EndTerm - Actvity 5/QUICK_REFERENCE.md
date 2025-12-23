# Quick Reference Guide

## 🎯 Getting Started (5 minutes)

### 1. Start Your Services
```bash
# Open XAMPP Control Panel
xampp-control.exe

# Start Apache and MySQL
```

### 2. Create Database
```bash
mysql -u root -p
CREATE DATABASE crud_app_db;
USE crud_app_db;
source backend/db/schema.sql;
```

### 3. Run Flutter App
```bash
flutter pub get
flutter run
```

---

## 👥 User Roles Explained

| Feature | Buyer | Seller |
|---------|-------|--------|
| Browse Products | ✅ | ✅ |
| Add to Cart | ✅ | ❌ |
| View Orders | ✅ | ✅ |
| Add Products | ❌ | ✅ |
| Edit Products | ❌ | ✅ |
| Delete Products | ❌ | ✅ |
| Update Order Status | ❌ | ✅ |

---

## 📁 Important Files

### Flutter App
- `lib/main.dart` - Start here
- `lib/screens/login_screen.dart` - Login logic
- `lib/services/api_service.dart` - All API calls
- `pubspec.yaml` - Dependencies

### Backend API
- `backend/config/database.php` - DB connection
- `backend/api/products/read.php` - Get products
- `backend/api/orders/read.php` - Get orders
- `backend/db/schema.sql` - Database setup

### Documentation
- `README_ECOMMERCE.md` - Full documentation
- `SETUP_GUIDE.md` - Step-by-step setup
- `API_DOCUMENTATION.md` - API reference

---

## 🔑 Test Credentials

Create these in the app:

**Buyer Account:**
- Username: `john_buyer`
- Email: `john@example.com`
- Role: Buyer
- Password: `Test@123`

**Seller Account:**
- Username: `jane_seller`
- Email: `jane@example.com`
- Role: Seller
- Password: `Test@123`

---

## 🛠️ Common Tasks

### Add a Product (as Seller)
1. Login as seller
2. Home → "Manage Products"
3. Click + button
4. Fill form → "Add Product"

### Browse Products (as Buyer)
1. Login as buyer
2. Home → "Browse Products"
3. Search or scroll
4. Click product for details
5. Select quantity → "Add to Cart"

### View Orders (as Seller)
1. Login as seller
2. Home → "Incoming Orders"
3. Click order to expand
4. Change status

### Reset Password
1. Click "Forgot Password?" on login
2. Enter email
3. Check email for reset link
4. Follow link to reset password

---

## 🐛 Troubleshooting Quick Fixes

| Problem | Solution |
|---------|----------|
| "Cannot connect to backend" | Start Apache in XAMPP |
| "Database error" | Start MySQL, run schema.sql |
| "Products not showing" | Verify seller added products |
| "Images not loading" | Check image URL is valid |
| "Firebase error" | Verify google-services.json exists |
| "Login fails" | Check username/password are correct |

---

## 📡 API Quick Reference

```bash
# Get all products
curl http://localhost/backend/api/products/read.php

# Get seller's products
curl http://localhost/backend/api/products/read.php?seller_id=1

# Get buyer's orders
curl http://localhost/backend/api/orders/read.php?buyer_id=1

# Get seller's orders
curl http://localhost/backend/api/orders/read.php?seller_id=1
```

---

## 🎨 UI Navigation

### Buyer Dashboard
```
Home
├── Browse Products (search, filter)
│   └── Product Details (add to cart)
└── Quick Actions
    ├── Browse Products
    └── My Cart

Bottom Nav:
[Home] [Browse] [Menu]
```

### Seller Dashboard
```
Home
├── Manage Products (CRUD)
│   ├── Add Product
│   ├── Edit Product
│   └── Delete Product
└── Quick Actions
    ├── Manage Products
    └── Incoming Orders

Bottom Nav:
[Home] [Products] [Orders]
```

---

## 📊 Database Quick Reference

```sql
-- View all products
SELECT * FROM products;

-- View all orders
SELECT * FROM orders;

-- View user orders
SELECT * FROM orders WHERE buyer_id = 1;

-- View seller products
SELECT * FROM products WHERE seller_id = 1;

-- Check user role
SELECT username, role_id FROM users;

-- Product count by seller
SELECT seller_id, COUNT(*) FROM products GROUP BY seller_id;
```

---

## 🔧 Configuration Files

### API Base URL
**File:** `lib/services/api_service.dart` (Line ~7)
```dart
static const String baseUrl = 'http://localhost/backend/api';
```

### Database Connection
**File:** `backend/config/database.php` (Lines 8-10)
```php
private $host = "localhost";
private $db_name = "crud_app_db";
private $username = "root";
private $password = "";
```

---

## 💡 Tips & Tricks

1. **Test without Flutter**
   - Use Postman or curl to test API endpoints
   - Verify backend works independently

2. **Database Backup**
   ```bash
   mysqldump -u root crud_app_db > backup.sql
   mysql -u root crud_app_db < backup.sql
   ```

3. **View App Logs**
   ```bash
   flutter logs
   ```

4. **Reload Changes**
   - 'r' for hot reload
   - 'R' for hot restart
   - Press 'q' to quit

5. **Debug Mode**
   - Use breakpoints in VS Code
   - Check console output
   - Use print() statements

---

## 📱 Device Testing

### Android
```bash
flutter run -d android
```

### iOS
```bash
flutter run -d ios
```

### Web (future)
```bash
flutter run -d chrome
```

---

## 🚀 Performance Tips

- Clear app cache: `flutter clean`
- Rebuild dependencies: `flutter pub get`
- Check for issues: `flutter doctor`
- Profile performance: `flutter run --profile`

---

## 📚 Learning Resources

- **Flutter Docs:** flutter.dev
- **Firebase Docs:** firebase.google.com
- **MySQL Docs:** dev.mysql.com
- **PHP Docs:** php.net
- **Material Design:** material.io

---

## 🎯 Next Steps After Setup

1. ✅ Test all 4 user flows
2. ✅ Try CRUD operations
3. ✅ Test API with Postman
4. ✅ Review database schema
5. ✅ Customize branding
6. ✅ Add new features
7. ✅ Deploy to production

---

## 📞 Quick Help

| Question | Answer |
|----------|--------|
| Where's the login screen? | `lib/screens/login_screen.dart` |
| How to add products? | Use Product Management screen |
| Where's the database? | MySQL, tables created by schema.sql |
| How to reset password? | Click "Forgot Password?" on login |
| What's the API base URL? | `http://localhost/backend/api` |
| Who are admins? | Not implemented yet (extensible) |
| Can I upload images? | Yes, use Firebase Storage URLs |
| Is it production ready? | Needs HTTPS, auth tokens, then yes |

---

## ⚠️ Common Mistakes to Avoid

❌ Don't forget to start MySQL before running app
❌ Don't modify schema.sql after initial import
❌ Don't use localhost on physical device (use IP/ngrok)
❌ Don't hardcode API URLs in code (use constants)
❌ Don't forget google-services.json
❌ Don't ignore error messages
❌ Don't skip input validation
❌ Don't commit sensitive data to git

---

## ✨ Features at a Glance

| Feature | Status | Location |
|---------|--------|----------|
| Firebase Auth | ✅ | `auth_service.dart` |
| Product CRUD | ✅ | `product_*_screens.dart` |
| Order Management | ✅ | `seller_orders_screen.dart` |
| Shopping Cart | ✅ | `product_detail_screen.dart` |
| User Roles | ✅ | `home_screen.dart` |
| Date Picker | ✅ | `register_screen.dart` |
| Time Picker | ✅ | `register_screen.dart` |
| Forgot Password | ✅ | `forgot_password_screen.dart` |
| Search Products | ✅ | `browse_products_screen.dart` |
| Stock Management | ✅ | `products` table |

---

**Save this file for quick reference!**

Last Updated: December 2024
