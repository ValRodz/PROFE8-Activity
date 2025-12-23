# Flutter E-Commerce App - Complete Setup Guide

## Quick Start Guide

### Step 1: Backend Database Setup (5 minutes)

#### For Windows XAMPP Users:

1. **Start XAMPP Services**
   - Open `xampp-control.exe`
   - Click "Start" for Apache module
   - Click "Start" for MySQL module
   - Wait for both to show "Running"

2. **Access MySQL Console**
   ```bash
   # Open Command Prompt
   cd C:\xampp\mysql\bin
   mysql -u root -p
   # Press Enter (no password by default)
   ```

3. **Create Database**
   ```sql
   CREATE DATABASE crud_app_db;
   USE crud_app_db;
   ```

4. **Import Schema**
   ```bash
   # In MySQL console, from project root:
   source backend/db/schema.sql;
   ```

5. **Verify Tables**
   ```sql
   SHOW TABLES;
   -- Should display: carts, cart_items, order_items, orders, products, roles, users
   ```

### Step 2: Flutter Setup (10 minutes)

1. **Get Dependencies**
   ```bash
   cd c:\Users\valod\xampp\htdocs
   flutter pub get
   ```

2. **Configure Firebase**
   - Visit [Firebase Console](https://console.firebase.google.com)
   - Create new project or select existing
   - Go to Project Settings → Service Accounts
   - Generate new private key
   - Download `google-services.json`
   - Place in `android/app/` directory

3. **Enable Firebase Services**
   - In Firebase Console:
     - Go to Authentication
     - Enable Email/Password sign-in method
     - Go to Storage (optional, for images)

4. **Update API Configuration** (if needed)
   - Edit `lib/services/api_service.dart`
   - Verify: `static const String baseUrl = 'http://localhost/backend/api';`

5. **Run Application**
   ```bash
   flutter run
   ```

### Step 3: Test the Application (15 minutes)

#### Register a New User (Buyer)
1. Click "Register" on login screen
2. Fill in form:
   - Full Name: John Buyer
   - Username: john_buyer
   - Email: john@example.com
   - Date of Birth: Select any date
   - Preferred Contact Time: Select any time
   - Role: Select "Buyer"
   - Password: Test@123
3. Click "Register"
4. You should see "Registration successful"

#### Register Another User (Seller)
1. Repeat steps above with:
   - Full Name: Jane Seller
   - Username: jane_seller
   - Email: jane@example.com
   - Role: Select "Seller"
   - Password: Test@123

#### Test Product Management (as Seller)
1. Login with seller account (jane_seller)
2. You'll see "Seller" dashboard
3. Click "Manage Products" or bottom navigation
4. Click "+" button to add product
5. Fill in:
   - Product Name: Fresh Apples
   - Description: Red crisp apples from local farm
   - Price: 4.99
   - Stock: 100
   - Image URL: (leave empty for now, or paste any image URL)
6. Click "Add Product"
7. Should see "Product added successfully"

#### Test Product Browsing (as Buyer)
1. Logout (click profile menu → Logout)
2. Login with buyer account (john_buyer)
3. You'll see "Buyer" dashboard
4. Click "Browse Products" or bottom navigation
5. Should see Jane's product
6. Click on product to view details
7. Can adjust quantity and add to cart

#### Test Order Management (as Seller)
1. Logout, login as seller
2. Click "Incoming Orders" in bottom navigation
3. (Will show orders once buyers place them)
4. Can update order status from pending → shipped → completed

---

## Detailed Setup Instructions

### Database Configuration

The database includes these tables:

**users**
- id, firebase_uid, username, email, password, full_name, role_id, created_at

**roles**
- id, name (user, seller, admin)

**products**
- id, seller_id, name, description, price, image_url, stock, created_at, updated_at

**orders**
- id, buyer_id, total, status, created_at, updated_at

**order_items**
- id, order_id, product_id, quantity, price

**carts** (optional, for future implementation)
- id, user_id, created_at

**cart_items** (optional)
- id, cart_id, product_id, quantity

### Authentication Flow

**Registration:**
```
User fills form → Firebase creates account → Backend saves profile to MySQL
```

**Login:**
```
Firebase authenticates → SharedPreferences stores user_id and role
```

**Forgot Password:**
```
User enters email → Firebase sends reset link to email → User resets via email link
```

### API Testing with Postman

#### Test Get All Products
- Method: GET
- URL: `http://localhost/backend/api/products/read.php`
- Expected Response: JSON with products array

#### Test Get User by Firebase UID
- Method: POST
- URL: `http://localhost/backend/api/auth/get_user.php`
- Body (raw JSON):
```json
{
  "firebase_uid": "abc123"
}
```

#### Test Create Product
- Method: POST
- URL: `http://localhost/backend/api/products/create.php`
- Body (raw JSON):
```json
{
  "seller_id": 1,
  "name": "Test Product",
  "description": "Test description",
  "price": 19.99,
  "image_url": "https://example.com/image.jpg",
  "stock": 10
}
```

---

## Common Issues & Solutions

### Issue: "Failed to connect to backend"
**Solution:**
1. Verify Apache is running in XAMPP Control Panel
2. Check if MySQL is running
3. Test URL in browser: `http://localhost/backend/api/products/read.php`
4. Should see JSON response without errors

### Issue: "Database connection error"
**Solution:**
1. Verify MySQL is running
2. Check credentials in `backend/config/database.php`
3. Ensure database name is `crud_app_db`
4. Run schema import again

### Issue: "Firebase authentication failing"
**Solution:**
1. Verify `google-services.json` is in `android/app/`
2. Check Firebase Console for enabled Authentication methods
3. Verify email is not already registered
4. Check Flutter console for specific error

### Issue: "Products not showing"
**Solution:**
1. Verify seller has created products (check database)
2. Ensure buyer is logged in with correct role
3. Check API response in Flutter console
4. Verify product seller_id matches seller user

### Issue: "Images not loading"
**Solution:**
1. Use HTTPS image URLs (HTTP may be blocked)
2. Test image URL in browser first
3. Check image exists and is publicly accessible
4. Verify Firebase Storage permissions (if using)

---

## Advanced Configuration

### Using HTTPS (Production)

1. **Update API Base URL**
   ```dart
   // In lib/services/api_service.dart
   static const String baseUrl = 'https://your-domain.com/backend/api';
   ```

2. **SSL Certificate**
   - Obtain SSL certificate for your domain
   - Configure in web server (Apache)

### Using ngrok for Mobile Testing

1. **Install ngrok**
   ```bash
   # Download from https://ngrok.com
   ```

2. **Start ngrok Tunnel**
   ```bash
   ngrok http 80
   ```

3. **Update Flutter Config**
   ```dart
   // In lib/services/api_service.dart
   static const String baseUrl = 'https://xxxx-xx-xxx-xx-xx.ngrok.io/backend/api';
   ```

### Firebase Storage Setup (for image uploads)

1. **Enable Firebase Storage**
   - Go to Firebase Console
   - Select Storage
   - Click "Get Started"
   - Use default security rules for testing

2. **Update Flutter Code**
   - Add `firebase_storage` to pubspec.yaml
   - Implement upload function in image picker

---

## Performance Optimization

### Database Indexes
```sql
-- Add indexes for faster queries
CREATE INDEX idx_seller_id ON products(seller_id);
CREATE INDEX idx_buyer_id ON orders(buyer_id);
CREATE INDEX idx_product_id ON products(id);
CREATE INDEX idx_firebase_uid ON users(firebase_uid);
```

### API Optimization
- Add pagination to product/order queries
- Implement caching for product lists
- Use database connection pooling

### Flutter Optimization
- Lazy load product images
- Implement pagination in list views
- Use const constructors
- Profile with DevTools

---

## Testing Checklist

- [ ] Database tables created and populated
- [ ] Backend API endpoints accessible
- [ ] Firebase Authentication working
- [ ] User can register (buyer role)
- [ ] User can register (seller role)
- [ ] User can login
- [ ] Forgot password email sends
- [ ] Seller can add product
- [ ] Seller can edit product
- [ ] Seller can delete product
- [ ] Buyer can see products
- [ ] Buyer can search products
- [ ] Buyer can view product details
- [ ] Buyer can select quantity
- [ ] Seller can view orders
- [ ] Seller can update order status
- [ ] UI is responsive on different screen sizes
- [ ] Error messages display correctly
- [ ] Session persists after app close
- [ ] Logout clears session

---

## File Locations

**Backend Files:**
- `/backend/config/database.php` - Database connection
- `/backend/api/auth/register.php` - Registration
- `/backend/api/products/*.php` - Product endpoints
- `/backend/api/orders/*.php` - Order endpoints
- `/backend/db/schema.sql` - Database schema

**Flutter Files:**
- `lib/main.dart` - App entry point
- `lib/screens/*.dart` - UI screens
- `lib/models/*.dart` - Data models
- `lib/services/api_service.dart` - API calls
- `lib/services/auth_service.dart` - Firebase auth
- `pubspec.yaml` - Dependencies

---

## Next Steps

1. **Test all features** following the testing checklist
2. **Review database schema** for your specific needs
3. **Customize branding** (colors, app name, icons)
4. **Add more features**:
   - Payment integration
   - Product reviews
   - Seller ratings
   - Advanced search filters
   - Notification system

---

**Last Updated**: December 2024
**Version**: 1.0.0
