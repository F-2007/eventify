import 'package:firebase_core/firebase_core.dart';

/// Firebase configuration
/// These values come from Firebase Console
/// You'll need to replace these with YOUR project's credentials
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      // Get these from Firebase Console > Project Settings
      //add your api key
      apiKey: "",
      // add your appId
      appId: "",
      //add your messagingSenderId
      messagingSenderId: "",
      // add your projectId
      projectId: "",
      // add your storageBucke
      storageBucket: "",
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

