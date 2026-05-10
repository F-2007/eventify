import 'package:flutter/material.dart';

import '../../models/event_model.dart';
import '../../services/auth_service.dart';
import '../../services/event_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/event_date_formatter.dart';
import 'analytics_screen.dart';
import 'attendees_screen.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  int currentIndex = 0;

  Future<void> openAddEventScreen() async {
    await Navigator.pushNamed(context, '/add-event');

    setState(() {
      currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.currentUser;
    final events = currentUser == null
        ? <EventModel>[]
        : EventService.getEventsByCreator(currentUser.id);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          currentIndex == 0
              ? "My Events"
              : currentIndex == 2
              ? "Attendees"
              : "Analytics",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              AuthService.logout();

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: openAddEventScreen,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: IndexedStack(
        index: currentIndex == 1 ? 0 : currentIndex,
        children: [
          buildMyEventsTab(events),
          const SizedBox.shrink(),
          const AttendeesScreen(),
          const AnalyticsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 1) {
            openAddEventScreen();
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
            icon: Icon(Icons.list_alt),
            label: "My Events",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: "Add Event",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Attendees"),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Analytics",
          ),
        ],
      ),
    );
  }

  Widget buildMyEventsTab(List<EventModel> events) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Manage Your Events",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Create events, review activity, and track your audience.",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
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
          const SizedBox(height: 30),
          const Text(
            "My Events",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(height: 15),
          if (events.isEmpty)
            buildEmptyState()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];

                return buildEventCard(
                  event: event,
                  onDelete: () {
                    setState(() {
                      EventService.deleteEventById(event.id);
                    });
                  },
                );
              },
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
          Icon(icon, color: AppColors.primary, size: 32),
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

  Widget buildEventCard({
    required EventModel event,
    required VoidCallback onDelete,
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
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.event, color: AppColors.primary),
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

  Widget buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          Icon(Icons.event_busy, color: Colors.grey, size: 42),
          SizedBox(height: 10),
          Text(
            "No events yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.dark,
            ),
          ),
        ],
      ),
    );
  }
}
