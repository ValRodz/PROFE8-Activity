import 'package:firebase_core/firebase_core.dart';

/// Default Firebase options for the Flutter application.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBYo6YASBLs1o2-awkfdkKjEpcNB8x2k78',
    appId: '1:610845866290:web:f9bd36d8b0fa8ed1b0ff2b',
    messagingSenderId: '610845866290',
    projectId: 'activity5-7910b',
    authDomain: 'activity5-7910b.firebaseapp.com',
    storageBucket: 'activity5-7910b.firebasestorage.app',
    measurementId: 'G-F4KTB1K89E',
  );
}
