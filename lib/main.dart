import 'package:flutter/material.dart';

import 'theme/app_colors.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(const EventifyApp());
}

class EventifyApp extends StatelessWidget {
  const EventifyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'Eventify',

      theme: ThemeData(

        scaffoldBackgroundColor: AppColors.background,

        primaryColor: AppColors.primary,

        appBarTheme: const AppBarTheme(

          backgroundColor: AppColors.primary,

          elevation: 0,

          centerTitle: true,
        ),

        bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(

          backgroundColor: Colors.white,

          selectedItemColor: AppColors.primary,

          unselectedItemColor: Colors.grey,

          type: BottomNavigationBarType.fixed,
        ),
      ),

      home: const LoginScreen(),
    );
  }
}