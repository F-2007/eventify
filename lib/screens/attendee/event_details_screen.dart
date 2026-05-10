import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../models/event_model.dart';
import '../../models/ticket_model.dart';
import '../../services/firebase_auth_service.dart';
import '../../services/ticket_service.dart';
import '../../services/event_service.dart';
import '../../services/notification_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/event_date_formatter.dart';

class EventDetailsScreen extends StatefulWidget {
  final EventModel event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final uuid = const Uuid();
  bool _isBooking = false;
  late EventModel _event;

  @override
  void initState() {
    super.initState();
    _event = widget.event;
    _refreshEvent();
  }

  /// Refresh event data from Firestore to get latest attendeeCount
  Future<void> _refreshEvent() async {
    final updated = await EventService.getEventById(_event.id);
    if (updated != null && mounted) {
      setState(() => _event = updated);
    }
  }

  Future<void> _bookTicket() async {
    if (_isBooking) return;
    if (_event.isFull) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sorry, this event is sold out!")),
      );
      return;
    }

    setState(() => _isBooking = true);

    try {
      String userId =
          FirebaseAuthService.getCurrentUser()?.uid ?? '';

      TicketModel ticket = TicketModel(
        id: uuid.v4(),
        event: _event,
        userId: userId,
        qrCode: uuid.v4(),
        purchaseDate: DateTime.now(),
      );

      // Save ticket to Firestore
      await TicketService.addTicket(ticket);

      // Increment attendee count
      await EventService.incrementAttendeeCount(_event.id);

      // Schedule notification reminder (1 hour before event)
      await NotificationService.scheduleEventReminder(
        eventTitle: _event.title,
        eventDateTime: _event.dateTime,
        hoursBefore: 1,
      );

      // Show immediate confirmation notification
      await NotificationService.showNotification(
        title: 'Ticket Booked! 🎉',
        body: 'You\'re going to ${_event.title}',
      );

      // Refresh event data to show updated seat count
      await _refreshEvent();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${_event.title} Booked Successfully! 🎉"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Booking failed: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Event Header
            Stack(
              children: [
                Container(
                  height: 320,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child:
                        Icon(Icons.event, size: 120, color: Colors.white),
                  ),
                ),

                Positioned(
                  top: 50,
                  left: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.dark),
                    ),
                  ),
                ),
              ],
            ),

            /// Content
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  Text(
                    _event.title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// Date
                  Row(
                    children: [
                      const Icon(Icons.calendar_month,
                          color: AppColors.primary),
                      const SizedBox(width: 10),
                      Text(
                        EventDateFormatter.formatDate(_event.dateTime),
                        style: const TextStyle(
                            fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// Location
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: AppColors.primary),
                      const SizedBox(width: 10),
                      Text(
                        _event.location,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// Time
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          color: AppColors.primary),
                      const SizedBox(width: 10),
                      Text(
                        EventDateFormatter.formatTime(_event.dateTime),
                        style: const TextStyle(
                            fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// Available Seats
                  Row(
                    children: [
                      Icon(
                        Icons.event_seat,
                        color: _event.isFull
                            ? Colors.red
                            : AppColors.primary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _event.isFull
                            ? "Sold Out"
                            : "${_event.availableSeats} / ${_event.capacity} seats available",
                        style: TextStyle(
                          fontSize: 16,
                          color: _event.isFull
                              ? Colors.red
                              : Colors.grey,
                          fontWeight: _event.isFull
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// About Event
                  const Text(
                    "About Event",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    _event.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 35),

                  /// Price Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Ticket Price",
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "\$${_event.price}",
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 160,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _event.isFull
                                  ? Colors.grey
                                  : AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(18),
                              ),
                            ),
                            onPressed:
                                _event.isFull || _isBooking
                                    ? null
                                    : _bookTicket,
                            child: _isBooking
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    _event.isFull
                                        ? "Sold Out"
                                        : "Book Now",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
