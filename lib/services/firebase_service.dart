import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/// Initialize Firebase when app starts
class FirebaseService {
  /// Initialize Firebase
  /// Call this in main() before runApp()
  /// Example: await FirebaseService.initialize();
  static Future<void> initialize() async {
    try {
      // Initialize Firebase with config from firebase_options.dart
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print(' Firebase initialized successfully');
    } catch (e) {
      print(' Firebase initialization error: $e');
      // App will still run but without backend features
    }
  }
}
