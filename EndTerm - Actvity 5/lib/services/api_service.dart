import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // Use local backend during development. Change back to your ngrok URL when needed.
  static const String baseUrl = 'http://localhost/backend/api';

  static Map<String, dynamic> _parseResponse(http.Response response) {
    try {
      if (kDebugMode) {
        debugPrint("[v0] API Response Status: ${response.statusCode}");
        debugPrint("[v0] API Response Body: ${response.body}");
      }

      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Empty response from server'};
      }

      // Check if response is HTML (error page) instead of JSON
      if (response.body.startsWith('<')) {
        return {
          'success': false,
          'message':
              'Server returned HTML error. Check your PHP backend is running correctly.'
        };
      }

      return jsonDecode(response.body);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("[v0] JSON Parse Error: $e");
      }
      return {'success': false, 'message': 'Error parsing server response: $e'};
    }
  }

  static Future<Map<String, dynamic>> getUserByFirebaseUid(
      String firebaseUid) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/get_user.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'firebase_uid': firebaseUid}),
      );
      return _parseResponse(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[v0] getUserByFirebaseUid Error: $e');
      }
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Authentication
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
    int roleId = 1,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'full_name': fullName,
          'role_id': roleId,
        }),
      );

      return _parseResponse(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("[v0] Register Error: $e");
      }
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Register user profile in MySQL (called after Firebase signup)
  static Future<Map<String, dynamic>> registerUserProfile(
      {required String firebaseUid,
      String? username,
      String? email,
      String? fullName,
      int roleId = 1}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firebase_uid': firebaseUid,
          'username': username,
          'email': email,
          'full_name': fullName,
          'role_id': roleId
        }),
      );
      return _parseResponse(response);
    } catch (e) {
      if (kDebugMode) {
        print('[v0] registerUserProfile Error: $e');
      }
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      return _parseResponse(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("[v0] Login Error: $e");
      }
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // CRUD Operations for Notes
  static Future<Map<String, dynamic>> createNote({
    required int userId,
    required String title,
    String? content,
    String? category,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/notes/create.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'title': title,
          'content': content ?? '',
          'category': category ?? 'General',
        }),
      );

      return _parseResponse(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("[v0] Create Note Error: $e");
      }
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getNotes(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notes/read.php?user_id=$userId'),
      );

      return _parseResponse(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("[v0] Get Notes Error: $e");
      }
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateNote({
    required int noteId,
    String? title,
    String? content,
    String? category,
  }) async {
    try {
      final Map<String, dynamic> data = {'id': noteId};

      if (title != null) data['title'] = title;
      if (content != null) data['content'] = content;
      if (category != null) data['category'] = category;

      final response = await http.put(
        Uri.parse('$baseUrl/notes/update.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      return _parseResponse(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("[v0] Update Note Error: $e");
      }
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> deleteNote(int noteId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/notes/delete.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': noteId}),
      );

      return _parseResponse(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("[v0] Delete Note Error: $e");
      }
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // ============ PRODUCT CRUD OPERATIONS ============

  static Future<Map<String, dynamic>> createProduct({
    required int sellerId,
    required String name,
    required String description,
    required double price,
    required int stock,
    String? imageUrl,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products/create.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'seller_id': sellerId,
          'name': name,
          'description': description,
          'price': price,
          'stock': stock,
          'image_url': imageUrl ?? '',
        }),
      );

      return _parseResponse(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("[v0] Create Product Error: $e");
      }
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getProducts(
      {int? sellerId, int? productId}) async {
    try {
      String url = '$baseUrl/products/read.php';
      if (productId != null) {
        url += '?product_id=$productId';
      } else if (sellerId != null) {
        url += '?seller_id=$sellerId';
      }

      final response = await http.get(Uri.parse(url));
      return _parseResponse(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("[v0] Get Products Error: $e");
      }
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateProduct({
    required int productId,
    String? name,
    String? description,
    double? price,
    int? stock,
    String? imageUrl,
  }) async {
    try {
      final Map<String, dynamic> data = {'id': productId};
      if (name != null) data['name'] = name;
      if (description != null) data['description'] = description;
      if (price != null) data['price'] = price;
      if (stock != null) data['stock'] = stock;
      if (imageUrl != null) data['image_url'] = imageUrl;

      final response = await http.put(
        Uri.parse('$baseUrl/products/update.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      return _parseResponse(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("[v0] Update Product Error: $e");
      }
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> deleteProduct(int productId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/products/delete.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': productId}),
      );

      return _parseResponse(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("[v0] Delete Product Error: $e");
      }
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // ============ IMAGE UPLOAD ============

  static Future<Map<String, dynamic>> uploadImage(dynamic imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/products/upload_image.php'),
      );

      // Handle XFile (works for both web and mobile)
      try {
        // Try to read as bytes first (works for web)
        final bytes = await imageFile.readAsBytes();
        final filename = imageFile.name ?? 'image.jpg';
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: filename,
          ),
        );
      } catch (e) {
        // Fallback: try using path (for mobile File objects)
        if (imageFile.path != null) {
          request.files.add(
            await http.MultipartFile.fromPath('file', imageFile.path),
          );
        } else {
          throw Exception('Unable to read image file');
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _parseResponse(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("[v0] Upload Image Error: $e");
      }
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // ============ ORDER OPERATIONS ============

  static Future<Map<String, dynamic>> createOrder({
    required int buyerId,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders/create.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'buyer_id': buyerId,
          'items': items,
        }),
      );

      return _parseResponse(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("[v0] Create Order Error: $e");
      }
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> getOrders(
      {int? sellerId, int? buyerId}) async {
    try {
      String url = '$baseUrl/orders/read.php';
      if (buyerId != null) {
        url += '?buyer_id=$buyerId';
      } else if (sellerId != null) {
        url += '?seller_id=$sellerId';
      }

      final response = await http.get(Uri.parse(url));
      return _parseResponse(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("[v0] Get Orders Error: $e");
      }
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateOrderStatus({
    required int orderId,
    required String status,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/orders/update_status.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'order_id': orderId,
          'status': status,
        }),
      );

      return _parseResponse(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("[v0] Update Order Status Error: $e");
      }
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
