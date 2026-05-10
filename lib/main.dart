import 'package:flutter/material.dart';

import 'theme/app_colors.dart';

import 'screens/admin/admin_screen.dart';
import 'screens/attendee/attendee_main_screen.dart';
import 'screens/organizer/add_event_screen.dart';
import 'screens/organizer/my_events_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'services/firebase_service.dart';
import 'services/notification_service.dart';

void main() async {
  // Required for Firebase initialization
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseService.initialize();

  // Initialize Notifications
  await NotificationService.initialize();

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

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,

          selectedItemColor: AppColors.primary,

          unselectedItemColor: Colors.grey,

          type: BottomNavigationBarType.fixed,
        ),
      ),

      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/attendee': (context) => const AttendeeMainScreen(),
        '/organizer': (context) => const MyEventsScreen(),
        '/admin': (context) => const AdminScreen(),
        '/add-event': (context) => const AddEventScreen(),
      },
    );
  }
}
