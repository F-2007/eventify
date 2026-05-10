import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/event_service.dart';
import '../../theme/app_colors.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.currentUser;
    final events = currentUser == null
        ? []
        : EventService.getEventsByCreator(currentUser.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Event Analytics",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Local summary for your organizer events.",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: buildStatCard(
                  icon: Icons.event,
                  title: "Events",
                  value: events.length.toString(),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: buildStatCard(
                  icon: Icons.confirmation_num,
                  title: "Tickets",
                  value: "0",
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: buildStatCard(
                  icon: Icons.qr_code_scanner,
                  title: "Check-ins",
                  value: "0",
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: buildStatCard(
                  icon: Icons.attach_money,
                  title: "Revenue",
                  value: "--",
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Charts and live ticket data will be connected after Firebase, tickets, and QR check-ins are added.",
              style: TextStyle(color: Colors.grey, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 30),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
