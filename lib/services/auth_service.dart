class AuthService {

  static String registeredEmail = "";

  static String registeredPassword = "";

  static bool register({

    required String email,

    required String password,

  }) {

    registeredEmail = email;

    registeredPassword = password;

    return true;
  }

  static bool login({

    required String email,

    required String password,

  }) {

    return email == registeredEmail &&
        password == registeredPassword;
  }
}