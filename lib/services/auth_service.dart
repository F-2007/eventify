import '../models/user_model.dart';

class AuthService {
  static String registeredEmail = "";

  static String registeredPassword = "";

  static UserRole registeredRole = UserRole.attendee;
  // to store the current logged in user
  static UserModel? _currentUser;

  static UserModel? get currentUser => _currentUser;

  static bool register({
    required String email,
    required String password,
    required UserRole role,
  }) {
    registeredEmail = email;
    registeredPassword = password;
    registeredRole = role;

    return true;
  }

  static bool login({required String email, required String password}) {
    if (email == registeredEmail && password == registeredPassword) {
      // Create user
      _currentUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: email.split('@')[0],
        email: email,
        role: registeredRole,
        createdAt: DateTime.now(),
      );
      return true;
    }
    return false;
  }

  static void setUserRole(UserRole role) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(role: role);
    }
  }

  static void logout() {
    _currentUser = null;
  }
}
