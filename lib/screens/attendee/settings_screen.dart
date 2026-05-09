import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

import '../../services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            /// Profile Card
            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(25),
              ),

              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 35,

                    backgroundColor: AppColors.primary,

                    child: Icon(Icons.person, size: 35, color: Colors.white),
                  ),

                  SizedBox(width: 20),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Mohamed Gamal",

                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.dark,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "eventify@gmail.com",

                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
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

            buildSettingItem(icon: Icons.notifications, title: "Notifications"),

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
              onTap: () {
                AuthService.logout();

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
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
                  ? Colors.red.withOpacity(0.1)
                  : AppColors.primary.withOpacity(0.1),

              borderRadius: BorderRadius.circular(15),
            ),

            child: Icon(icon, color: isLogout ? Colors.red : AppColors.primary),
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

          Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}
