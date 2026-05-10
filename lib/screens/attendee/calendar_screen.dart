import 'package:flutter/material.dart';

import '../../models/event_model.dart';
import '../../models/ticket_model.dart';
import '../../services/firebase_auth_service.dart';
import '../../services/ticket_service.dart';
import '../../services/event_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/event_date_formatter.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentMonth = DateTime.now();
  int? _selectedDay;
  List<EventModel> _allEvents = [];
  List<TicketModel> _userTickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now().day;
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final userId = FirebaseAuthService.getCurrentUser()?.uid ?? '';
      final events = await EventService.getEvents();
      final tickets = await TicketService.getTicketsByUser(userId);

      if (mounted) {
        setState(() {
          _allEvents = events;
          _userTickets = tickets;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Get all events on a specific day
  List<EventModel> _getAllEventsForDay(int day) {
    final targetDate = DateTime(_currentMonth.year, _currentMonth.month, day);

    return _allEvents.where((event) {
      final eventDate = event.dateTime;
      return eventDate.year == targetDate.year &&
          eventDate.month == targetDate.month &&
          eventDate.day == targetDate.day;
    }).toList();
  }

  /// Check if a day has any events
  bool _dayHasEvents(int day) {
    return _getAllEventsForDay(day).isNotEmpty;
  }

  /// Get days in current month
  int _daysInMonth() {
    return DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
  }

  /// Get the weekday of the first day of the month (0 = Sunday)
  int _firstDayOfWeek() {
    final first =
        DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;
    return first % 7; // Convert to 0=Sun format
  }

  /// Month name
  String _monthName() {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[_currentMonth.month - 1]} ${_currentMonth.year}';
  }

  @override
  Widget build(BuildContext context) {
    final selectedDayEvents = _selectedDay != null
        ? _getAllEventsForDay(_selectedDay!)
        : <EventModel>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Calendar",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  const Text(
                    "Your Schedule 📅",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Manage your upcoming events easily",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),

                  /// Calendar Container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        /// Month Header with navigation
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _currentMonth = DateTime(
                                    _currentMonth.year,
                                    _currentMonth.month - 1,
                                  );
                                  _selectedDay = null;
                                });
                              },
                              icon: const Icon(Icons.arrow_back_ios,
                                  size: 18),
                            ),
                            Text(
                              _monthName(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _currentMonth = DateTime(
                                    _currentMonth.year,
                                    _currentMonth.month + 1,
                                  );
                                  _selectedDay = null;
                                });
                              },
                              icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),

                        /// Days of week row
                        const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                          children: [
                            Text("S", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                            Text("M", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                            Text("T", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                            Text("W", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                            Text("T", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                            Text("F", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                            Text("S", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 20),

                        /// Calendar Grid
                        GridView.count(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(),
                          crossAxisCount: 7,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          children: [
                            // Empty cells for offset
                            ...List.generate(
                              _firstDayOfWeek(),
                              (_) => const SizedBox.shrink(),
                            ),
                            // Day cells
                            ...List.generate(
                              _daysInMonth(),
                              (index) {
                                final day = index + 1;
                                final isSelected =
                                    day == _selectedDay;
                                final hasEvents =
                                    _dayHasEvents(day);

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedDay = day;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.background,
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "$day",
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : AppColors.dark,
                                            fontWeight:
                                                FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        if (hasEvents)
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 2),
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? Colors.white
                                                  : AppColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  /// Events for selected day
                  if (_selectedDay != null) ...[
                    Text(
                      "Events on ${_selectedDay} ${_monthName().split(' ')[0]}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (selectedDayEvents.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.event_busy,
                                color: Colors.grey, size: 40),
                            SizedBox(height: 10),
                            Text(
                              "No events on this day",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...selectedDayEvents.map((event) =>
                          _buildEventCard(event)),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildEventCard(EventModel event) {
    // Check if user has a ticket for this event
    final hasTicket = _userTickets.any((t) => t.event.id == event.id);

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
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(15),
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
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "${EventDateFormatter.formatTime(event.dateTime)} - ${event.location}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          if (hasTicket)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Booked",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}