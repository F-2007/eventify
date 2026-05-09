import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,

        onPressed: () {
          Navigator.pushNamed(context, '/add-event');
        },

        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// Welcome Card
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),

                borderRadius: BorderRadius.circular(30),
              ),

              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "Welcome Admin 👋",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Manage all events and users easily",

                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            /// Statistics
            const Text(
              "Statistics",

              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: buildStatCard(
                    title: "Events",
                    value: "12",
                    icon: Icons.event,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: buildStatCard(
                    title: "Users",
                    value: "245",
                    icon: Icons.people,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: buildStatCard(
                    title: "Tickets",
                    value: "530",
                    icon: Icons.confirmation_num,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: buildStatCard(
                    title: "Revenue",
                    value: "\$4.2K",
                    icon: Icons.attach_money,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 35),

            /// Recent Events
            const Text(
              "Recent Events",

              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),

            const SizedBox(height: 20),

            buildEventCard(
              title: "Tech Conference",
              location: "Cairo",
              date: "15 May 2026",
            ),

            buildEventCard(
              title: "Music Festival",
              location: "Giza",
              date: "20 May 2026",
            ),

            buildEventCard(
              title: "Business Summit",
              location: "Alexandria",
              date: "30 May 2026",
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatCard({
    required String title,

    required String value,

    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(25),
      ),

      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,

            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),

              borderRadius: BorderRadius.circular(18),
            ),

            child: Icon(icon, color: AppColors.primary, size: 32),
          ),

          const SizedBox(height: 15),

          Text(
            value,

            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),

          const SizedBox(height: 5),

          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 15)),
        ],
      ),
    );
  }

  Widget buildEventCard({
    required String title,

    required String location,

    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(25),
      ),

      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,

            decoration: BoxDecoration(
              color: AppColors.primary,

              borderRadius: BorderRadius.circular(18),
            ),

            child: const Icon(Icons.event, color: Colors.white, size: 32),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "$location • $date",

                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {},

            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
