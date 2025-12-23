import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<UserCredential> registerWithEmail(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  static Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> sendPasswordReset(String email) async {
    return await _auth.sendPasswordResetEmail(email: email);
  }

  static Future<void> signOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // After creating Firebase user, register profile in MySQL via API
  static Future<Map<String,dynamic>> registerProfile({required String firebaseUid, String? username, String? email, String? fullName, int roleId = 1}) async {
    final res = await ApiService.registerUserProfile(firebaseUid: firebaseUid, username: username, email: email, fullName: fullName, roleId: roleId);
    return res;
  }
}
