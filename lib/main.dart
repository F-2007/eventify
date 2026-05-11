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

  // Check for existing session
  final currentUser = FirebaseAuthService.getCurrentUser();
  String initialRoute = '/login';

  if (currentUser != null) {
    try {
      // Fetch user role from Firestore to populate AuthService
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data()!;
        final roleStr = data['role'] ?? 'attendee';
        final role = UserRole.values.byName(roleStr);

        // Populate mock AuthService so existing code still works
        AuthService.register(
          email: currentUser.email ?? '',
          password: '', // Password not needed for existing session
          role: role,
        );
        AuthService.login(
          email: currentUser.email ?? '',
          password: '',
        );

        // Set initial route based on role
        if (role == UserRole.admin) {
          initialRoute = '/admin';
        } else if (role == UserRole.organizer) {
          initialRoute = '/organizer';
        } else {
          initialRoute = '/attendee';
        }
      }
    } catch (e) {
      print(' Session restoration error: $e');
    }
  }

  runApp(EventifyApp(initialRoute: initialRoute));
}

class EventifyApp extends StatelessWidget {
  final String initialRoute;
  const EventifyApp({super.key, required this.initialRoute});

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

      initialRoute: initialRoute,

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
