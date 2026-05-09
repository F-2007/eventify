import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

import '../../services/auth_service.dart';

import '../../models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 40),

              /// Logo
              Center(
                child: Container(
                  width: 110,
                  height: 110,

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                    ),

                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: const Icon(Icons.event, color: Colors.white, size: 60),
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                "Welcome Back 👋",

                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Login to continue using Eventify",

                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 40),

              /// Email
              buildTextField(
                controller: emailController,

                hint: "Email Address",

                icon: Icons.email,
              ),

              const SizedBox(height: 20),

              /// Password
              TextField(
                controller: passwordController,

                obscureText: isPasswordHidden,

                decoration: InputDecoration(
                  filled: true,

                  fillColor: Colors.white,

                  hintText: "Password",

                  prefixIcon: const Icon(Icons.lock, color: AppColors.primary),

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordHidden = !isPasswordHidden;
                      });
                    },

                    icon: Icon(
                      isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),

                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// Login Button
              SizedBox(
                width: double.infinity,

                height: 60,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  onPressed: () {
                    /// Admin Login
                    if (emailController.text == "admin@eventify.com" &&
                        passwordController.text == "admin@eventify.com") {
                      Navigator.pushReplacementNamed(context, '/admin');

                      return;
                    }

                    /// Normal User Login
                    bool success = AuthService.login(
                      email: emailController.text,

                      password: passwordController.text,
                    );

                    if (success) {
                      final user = AuthService.currentUser;

                      final route = user?.role == UserRole.organizer
                          ? '/organizer'
                          : '/attendee';

                      Navigator.pushReplacementNamed(context, route);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Wrong Email or Password"),
                        ),
                      );
                    }
                  },

                  child: const Text(
                    "Login",

                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              /// Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  const Text("Don't have an account?"),

                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },

                    child: const Text(
                      "Register",

                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,

    required String hint,

    required IconData icon,
  }) {
    return TextField(
      controller: controller,

      decoration: InputDecoration(
        filled: true,

        fillColor: Colors.white,

        hintText: hint,

        prefixIcon: Icon(icon, color: AppColors.primary),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),

          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
