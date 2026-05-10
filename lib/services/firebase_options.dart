import 'package:firebase_core/firebase_core.dart';

/// Firebase configuration
/// These values come from Firebase Console
/// You'll need to replace these with YOUR project's credentials
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      // Get these from Firebase Console > Project Settings
      apiKey: "AIzaSyDummyKeyReplaceWithYours",
      appId: "1:123456789:android:dummyIdReplaceWithYours",
      messagingSenderId: "123456789",
      projectId: "eventify-app",
      storageBucket: "eventify-app.appspot.com",
      iosBundleId: "com.example.eventify",
      androidClientId: "com.example.eventify",
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
