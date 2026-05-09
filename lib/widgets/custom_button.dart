import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CustomButton extends StatelessWidget {

  final String text;

  final VoidCallback onPressed;

  const CustomButton({

    super.key,

    required this.text,

    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(

      width: double.infinity,

      height: 60,

      child: ElevatedButton(

        style: ElevatedButton.styleFrom(

          backgroundColor:
          AppColors.primary,

          shape: RoundedRectangleBorder(

            borderRadius:
            BorderRadius.circular(18),
          ),
        ),

        onPressed: onPressed,

        child: Text(

          text,

          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}