import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CustomTextField extends StatelessWidget {

  final TextEditingController controller;

  final String hint;

  final IconData icon;

  final bool isPassword;

  const CustomTextField({

    super.key,

    required this.controller,

    required this.hint,

    required this.icon,

    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {

    return TextField(

      controller: controller,

      obscureText: isPassword,

      decoration: InputDecoration(

        filled: true,

        fillColor: Colors.white,

        hintText: hint,

        prefixIcon: Icon(
          icon,
          color: AppColors.primary,
        ),

        border: OutlineInputBorder(

          borderRadius:
          BorderRadius.circular(18),

          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}