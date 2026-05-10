import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../services/auth_service.dart';
import '../../services/firebase_auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get real user data from Firebase Auth
    final firebaseUser = FirebaseAuthService.getCurrentUser();
    final localUser = AuthService.currentUser;
    final userName = firebaseUser?.displayName ??
        localUser?.name ??
        'User';
    final userEmail = firebaseUser?.email ??
        localUser?.email ??
        'No email';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Profile Card — Dynamic user data
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: AppColors.primary,
                    child:
                        Icon(Icons.person, size: 35, color: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          userEmail,
                          style: const TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          localUser?.role.name.toUpperCase() ?? 'ATTENDEE',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            /// Settings Title
            const Text(
              "General",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),

            const SizedBox(height: 20),

            buildSettingItem(icon: Icons.dark_mode, title: "Dark Mode"),
            buildSettingItem(
                icon: Icons.notifications, title: "Notifications"),
            buildSettingItem(icon: Icons.language, title: "Language"),
            buildSettingItem(icon: Icons.lock, title: "Privacy"),

            const SizedBox(height: 35),

            /// About
            const Text(
              "About",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),

            const SizedBox(height: 20),

            buildSettingItem(icon: Icons.info, title: "About Eventify"),
            buildSettingItem(icon: Icons.help, title: "Help & Support"),

            /// Logout
            GestureDetector(
              onTap: () async {
                // Logout from both Firebase and local auth
                await FirebaseAuthService.logout();
                AuthService.logout();

                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              },
              child: buildSettingItem(
                icon: Icons.logout,
                title: "Logout",
                isLogout: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingItem({
    required IconData icon,
    required String title,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isLogout
                  ? Colors.red.withValues(alpha: 0.1)
                  : AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child:
                Icon(icon, color: isLogout ? Colors.red : AppColors.primary),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isLogout ? Colors.red : AppColors.dark,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios,
              size: 18, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}
