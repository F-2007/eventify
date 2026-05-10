import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../models/ticket_model.dart';
import '../../services/firebase_auth_service.dart';
import '../../services/ticket_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/event_date_formatter.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuthService.getCurrentUser()?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Tickets",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<List<TicketModel>>(
        stream: TicketService.streamTicketsByUser(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final tickets = snapshot.data ?? [];

          if (tickets.isEmpty) {
            return const Center(
              child: Text(
                "No Tickets Booked Yet 🎟",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              final event = ticket.event;

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Event Name
                          Text(
                            event.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// Date
                          Row(
                            children: [
                              const Icon(Icons.calendar_month,
                                  color: Colors.white),
                              const SizedBox(width: 10),
                              Text(
                                EventDateFormatter.formatDate(event.dateTime),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          /// Location
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Colors.white),
                              const SizedBox(width: 10),
                              Text(
                                event.location,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          /// Time
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  color: Colors.white),
                              const SizedBox(width: 10),
                              Text(
                                EventDateFormatter.formatTime(event.dateTime),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          /// Price
                          Row(
                            children: [
                              const Icon(Icons.attach_money,
                                  color: Colors.white),
                              const SizedBox(width: 10),
                              Text(
                                "\$${event.price}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// Divider
                    Container(
                      height: 2,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),

                    /// Bottom Ticket — QR Code & Status
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Ticket Status",
                                style: TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                ticket.isCheckedIn
                                    ? "Checked In ✓"
                                    : "Confirmed",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ticket.isCheckedIn ? 16 : 14,
                                ),
                              ),
                            ],
                          ),

                          /// Real QR Code (tap to expand)
                          GestureDetector(
                            onTap: () => _showQRDialog(context, ticket),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: QrImageView(
                                data: ticket.qrCode,
                                version: QrVersions.auto,
                                size: 70,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Show expanded QR code dialog
  void _showQRDialog(BuildContext context, TicketModel ticket) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ticket.event.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Show this QR code at the venue",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: QrImageView(
                  data: ticket.qrCode,
                  version: QrVersions.auto,
                  size: 220,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Ticket ID: ${ticket.id.substring(0, 8)}...",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Close",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
