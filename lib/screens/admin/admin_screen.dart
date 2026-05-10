import 'package:flutter/material.dart';

import '../../models/event_model.dart';
import '../../services/auth_service.dart';
import '../../services/event_service.dart';
import '../../services/ticket_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/event_date_formatter.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int currentIndex = 0;

  Future<void> openSystemEventScreen() async {
    await Navigator.pushNamed(context, '/add-event');

    setState(() {
      currentIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final titles = ["Admin Dashboard", "All Events", "System Event", "Admin"];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          titles[currentIndex],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: IndexedStack(
        index: currentIndex == 2 ? 1 : currentIndex,
        children: [
          buildDashboardTab(),
          buildEventsTab(),
          const SizedBox.shrink(),
          buildAdminTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 2) {
            openSystemEventScreen();
            return;
          }

          setState(() {
            currentIndex = index;
          });
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: "System Event",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Admin"),
        ],
      ),
    );
  }

  Widget buildDashboardTab() {
    return StreamBuilder<List<EventModel>>(
      stream: EventService.streamEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final events = snapshot.data ?? [];

        return FutureBuilder<int>(
          future: _getTotalTickets(),
          builder: (context, ticketSnapshot) {
            final ticketCount = ticketSnapshot.data ?? 0;
            final totalRevenue = events.fold<double>(
              0,
              (sum, e) => sum + (e.attendeeCount * e.price),
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          "Welcome Admin",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Manage all events and system activity.",
                          style:
                              TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
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
                          value: events.length.toString(),
                          icon: Icons.event,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: buildStatCard(
                          title: "Tickets",
                          value: ticketCount.toString(),
                          icon: Icons.confirmation_num,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: buildStatCard(
                          title: "Attendees",
                          value: events
                              .fold<int>(
                                  0, (sum, e) => sum + e.attendeeCount)
                              .toString(),
                          icon: Icons.people,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: buildStatCard(
                          title: "Revenue",
                          value:
                              "\$${totalRevenue.toStringAsFixed(0)}",
                          icon: Icons.attach_money,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  const Text(
                    "Recent Events",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (events.isEmpty)
                    const Text("No events yet")
                  else
                    ...events.take(3).map(
                          (event) => buildEventCard(
                            event: event,
                            onDelete: () async {
                              await EventService.deleteEventById(
                                  event.id);
                            },
                          ),
                        ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<int> _getTotalTickets() async {
    final tickets = await TicketService.getTickets();
    return tickets.length;
  }

  Widget buildEventsTab() {
    return StreamBuilder<List<EventModel>>(
      stream: EventService.streamEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final events = snapshot.data ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "All Events",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 15),
              if (events.isEmpty)
                const Text("No events yet")
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];

                    return buildEventCard(
                      event: event,
                      onDelete: () async {
                        await EventService.deleteEventById(event.id);
                      },
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget buildAdminTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.admin_panel_settings,
                  color: AppColors.primary,
                  size: 42,
                ),
                SizedBox(height: 15),
                Text(
                  "System Admin",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Full system control with Firestore connected. Manage events, users, and monitor activity.",
                  style: TextStyle(color: Colors.grey, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              AuthService.logout();

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: buildAdminAction(
              icon: Icons.logout,
              title: "Logout",
              isLogout: true,
            ),
          ),
        ],
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
              color: AppColors.primary.withValues(alpha: 0.1),
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
          Text(title,
              style: const TextStyle(color: Colors.grey, fontSize: 15)),
        ],
      ),
    );
  }

  Widget buildEventCard({
    required EventModel event,
    required VoidCallback onDelete,
  }) {
    final creatorLabel = event.creatorRole?.name == "admin"
        ? "System event"
        : "Organizer event";

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
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.event, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "${event.location} - ${EventDateFormatter.formatDate(event.dateTime)}",
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      creatorLabel,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "${event.attendeeCount}/${event.capacity}",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget buildAdminAction({
    required IconData icon,
    required String title,
    bool isLogout = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: isLogout ? Colors.red : AppColors.primary),
          const SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(
              color: isLogout ? Colors.red : AppColors.dark,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
