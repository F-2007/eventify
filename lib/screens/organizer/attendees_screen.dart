import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class AttendeesScreen extends StatelessWidget {
  const AttendeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.qr_code_scanner, color: AppColors.primary, size: 42),
                SizedBox(height: 15),
                Text(
                  "Attendee Check-in",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Ticket holders and QR check-ins will appear here after ticket QR support is added.",
                  style: TextStyle(color: Colors.grey, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          buildPlaceholderItem(
            icon: Icons.people,
            title: "Registered attendees",
            value: "Coming soon",
          ),
          buildPlaceholderItem(
            icon: Icons.verified,
            title: "Checked in",
            value: "Coming soon",
          ),
        ],
      ),
    );
  }

  Widget buildPlaceholderItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.dark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
