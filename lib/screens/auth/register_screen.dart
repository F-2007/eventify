import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

import '../../services/auth_service.dart';

import '../../models/user_model.dart';
import '../../widgets/role_card.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPasswordHidden = true;

  bool isConfirmPasswordHidden = true;

  UserRole selectedRole = UserRole.attendee;

  /// Helper function to validate email format
  bool isValidEmail(String email) {
    return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 30),

              /// Back Button
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                icon: const Icon(Icons.arrow_back_ios),
              ),

              const SizedBox(height: 20),

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

              const SizedBox(height: 35),

              /// Header
              const Text(
                "Create Account 🚀",

                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Join Eventify and explore events",

                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 35),

              /// Full Name
              buildTextField(
                controller: nameController,

                hint: "Full Name",

                icon: Icons.person,
              ),

              const SizedBox(height: 20),

              /// Email
              buildTextField(
                controller: emailController,

                hint: "Email Address",

                icon: Icons.email,
              ),

              const SizedBox(height: 20),

              /// Password
              buildPasswordField(
                controller: passwordController,

                hint: "Password",

                isHidden: isPasswordHidden,

                onTap: () {
                  setState(() {
                    isPasswordHidden = !isPasswordHidden;
                  });
                },
              ),

              const SizedBox(height: 20),

              /// Confirm Password
              buildPasswordField(
                controller: confirmPasswordController,

                hint: "Confirm Password",

                isHidden: isConfirmPasswordHidden,

                onTap: () {
                  setState(() {
                    isConfirmPasswordHidden = !isConfirmPasswordHidden;
                  });
                },
              ),

              const SizedBox(height: 25),

              const Text(
                "Account Type",

                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),

              const SizedBox(height: 15),

              RoleCard(
                icon: Icons.event,
                title: "Attendee",
                subtitle: "Browse and buy event tickets",
                isSelected: selectedRole == UserRole.attendee,
                onTap: () {
                  setState(() {
                    selectedRole = UserRole.attendee;
                  });
                },
              ),

              const SizedBox(height: 15),

              RoleCard(
                icon: Icons.add_business,
                title: "Organizer",
                subtitle: "Create and manage events",
                isSelected: selectedRole == UserRole.organizer,
                onTap: () {
                  setState(() {
                    selectedRole = UserRole.organizer;
                  });
                },
              ),

              const SizedBox(height: 35),

              /// Register Button
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
                    final name = nameController.text.trim();
                    final email = emailController.text.trim();
                    final password = passwordController.text;
                    final confirmPassword = confirmPasswordController.text;

                    // Validation checks
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter your name")),
                      );
                      return;
                    }

                    if (email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter your email")),
                      );
                      return;
                    }

                    if (!isValidEmail(email)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter a valid email")),
                      );
                      return;
                    }

                    if (password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter a password")),
                      );
                      return;
                    }

                    if (password.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Password must be at least 6 characters")),
                      );
                      return;
                    }

                    if (password != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Passwords do not match")),
                      );
                      return;
                    }

                    AuthService.register(
                      email: email,

                      password: password,

                      role: selectedRole,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Account Created Successfully"),
                      ),
                    );

                    Navigator.pushReplacementNamed(context, '/login');
                  },

                  child: const Text(
                    "Create Account",

                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  const Text("Already have an account?"),

                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },

                    child: const Text(
                      "Login",

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

  Widget buildPasswordField({
    required TextEditingController controller,

    required String hint,

    required bool isHidden,

    required VoidCallback onTap,
  }) {
    return TextField(
      controller: controller,

      obscureText: isHidden,

      decoration: InputDecoration(
        filled: true,

        fillColor: Colors.white,

        hintText: hint,

        prefixIcon: const Icon(Icons.lock, color: AppColors.primary),

        suffixIcon: IconButton(
          onPressed: onTap,

          icon: Icon(
            isHidden ? Icons.visibility_off : Icons.visibility,

            color: Colors.grey,
          ),
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),

          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
