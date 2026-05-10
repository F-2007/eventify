import 'package:firebase_core/firebase_core.dart';

/// Firebase configuration
/// These values come from Firebase Console
/// You'll need to replace these with YOUR project's credentials
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      // Get these from Firebase Console > Project Settings
      apiKey: "AIzaSyDHUlksyuJ8BDlJR7EYoBj2pB_O0UmPXwc",
      appId: "1:968279367460:android:25d47d233ed7b2637a9db1",
      messagingSenderId: "968279367460",
      projectId: "eventify-app-67224",
      storageBucket: "eventify-app-67224.firebasestorage.app",
      //iosBundleId: "com.example.eventify",
      //androidClientId: "com.example.eventify",
    );
  }
}

/// HOW TO GET FIREBASE CREDENTIALS:
/// 1. Go to Firebase Console (https://console.firebase.google.com)
/// 2. Create a new project called "eventify-app"
/// 3. Go to Project Settings (gear icon)
/// 4. Copy the values from "Your Apps" section
/// 5. Replace the dummy values above
///
/// IMPORTANT: Never commit real credentials to public repositories
/// In production, use environment files or Firebase CLI
