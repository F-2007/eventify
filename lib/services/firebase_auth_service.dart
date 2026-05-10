import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

/// Handles authentication with Firebase
/// This replaces the mock auth and uses real Firebase Auth
class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Register new user with email and password
  /// Returns true if successful
  static Future<bool> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    try {
      // Create user in Firebase
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user profile with name
      await userCredential.user?.updateDisplayName(name);

      print(
          ' User registered: ${userCredential.user?.email} with role: ${role.name}');
      return true;
    } on FirebaseAuthException catch (e) {
      print(' Registration error: ${e.message}');
      return false;
    } catch (e) {
      print('Unexpected error: $e');
      return false;
    }
  }

  /// Login user with email and password
  /// Returns true if successful
  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in with Firebase
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print(' User logged in: ${userCredential.user?.email}');
      return true;
    } on FirebaseAuthException catch (e) {
      print(' Login error: ${e.message}');
      return false;
    } catch (e) {
      print(' Unexpected error: $e');
      return false;
    }
  }

  /// Get currently logged-in user
  /// Returns null if no user is logged in
  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Get current user's email
  static String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  /// Get current user's display name
  static String? getCurrentUserName() {
    return _auth.currentUser?.displayName;
  }

  /// Check if user is logged in
  static bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  /// Logout current user
  static Future<void> logout() async {
    try {
      await _auth.signOut();
      print(' User logged out');
    } catch (e) {
      print(' Logout error: $e');
    }
  }

  /// Change user password
  static Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return false;

      // Re-authenticate before changing password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);

      print(' Password changed successfully');
      return true;
    } on FirebaseAuthException catch (e) {
      print(' Password change error: ${e.message}');
      return false;
    }
  }

  /// Update user display name
  static Future<bool> updateUserName(String newName) async {
    try {
      await _auth.currentUser?.updateDisplayName(newName);
      print(' Username updated to: $newName');
      return true;
    } catch (e) {
      print(' Update name error: $e');
      return false;
    }
  }

  /// Update user photo URL
  static Future<bool> updateUserPhoto(String photoUrl) async {
    try {
      await _auth.currentUser?.updatePhotoURL(photoUrl);
      print(' Profile photo updated');
      return true;
    } catch (e) {
      print(' Update photo error: $e');
      return false;
    }
  }
}
