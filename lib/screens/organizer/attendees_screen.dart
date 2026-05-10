import 'package:flutter/material.dart';

import '../../models/event_model.dart';
import '../../services/auth_service.dart';
import '../../services/event_service.dart';
import '../../services/qr_service.dart';
import '../../theme/app_colors.dart';
import 'qr_scanner_screen.dart';

class AttendeesScreen extends StatefulWidget {
  const AttendeesScreen({super.key});

  @override
  State<AttendeesScreen> createState() => _AttendeesScreenState();
}

class _AttendeesScreenState extends State<AttendeesScreen> {
  List<EventModel> _events = [];
  EventModel? _selectedEvent;
  List<Map<String, dynamic>> _checkIns = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final currentUser = AuthService.currentUser;
    if (currentUser == null) return;

    final events =
        await EventService.getEventsByCreator(currentUser.id);
    setState(() {
      _events = events;
      _isLoading = false;
      if (events.isNotEmpty && _selectedEvent == null) {
        _selectedEvent = events.first;
        _loadCheckIns();
      }
    });
  }

  Future<void> _loadCheckIns() async {
    if (_selectedEvent == null) return;

    setState(() => _isLoading = true);
    final checkIns =
        await QRService.getCheckIns(_selectedEvent!.id);
    setState(() {
      _checkIns = checkIns;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => QRScannerScreen(
                eventId: _selectedEvent?.id,
              ),
            ),
          );
          // Refresh check-ins after scanning
          _loadCheckIns();
        },
        icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
        label: const Text(
          "Scan QR",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.qr_code_scanner,
                      color: AppColors.primary, size: 42),
                  const SizedBox(height: 15),
                  const Text(
                    "Attendee Check-in",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _events.isEmpty
                        ? "Create events to start tracking attendees."
                        : "Select an event and scan QR codes to check in attendees.",
                    style: const TextStyle(
                        color: Colors.grey, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// Event Selector Dropdown
            if (_events.isNotEmpty) ...[
              const Text(
                "Select Event",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedEvent?.id,
                    items: _events
                        .map((event) => DropdownMenuItem<String>(
                              value: event.id,
                              child: Text(
                                event.title,
                                style: const TextStyle(
                                    color: AppColors.dark),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedEvent = _events.firstWhere(
                            (e) => e.id == value);
                      });
                      _loadCheckIns();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            /// Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.people,
                    title: "Registered",
                    value: _selectedEvent?.attendeeCount.toString() ??
                        "0",
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.verified,
                    title: "Checked In",
                    value: _checkIns.length.toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            /// Checked-In Attendees List
            const Text(
              "Checked-In Attendees",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 15),

            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: CircularProgressIndicator(
                      color: AppColors.primary),
                ),
              )
            else if (_checkIns.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.people_outline,
                        color: Colors.grey, size: 42),
                    SizedBox(height: 10),
                    Text(
                      "No check-ins yet",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Scan attendee QR codes to check them in",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _checkIns.length,
                itemBuilder: (context, index) {
                  final checkIn = _checkIns[index];
                  final checkInTime =
                      (checkIn['checkInTime'] as dynamic)
                              ?.toDate() ??
                          DateTime.now();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                "User: ${(checkIn['userId'] as String?)?.substring(0, 8) ?? 'Unknown'}...",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.dark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Checked in: ${checkInTime.toString().substring(0, 16)}",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.verified,
                            color: Colors.green),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
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
