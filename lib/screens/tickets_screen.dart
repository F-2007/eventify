import 'package:flutter/material.dart';

import '../models/ticket_model.dart';

import '../services/ticket_service.dart';

import '../theme/app_colors.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    List<TicketModel> tickets =
    TicketService.getTickets();

    return Scaffold(

      appBar: AppBar(

        title: const Text(

          "My Tickets",

          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: tickets.isEmpty

          ? const Center(

        child: Text(

          "No Tickets Booked Yet 🎟",

          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      )

          : ListView.builder(

        padding: const EdgeInsets.all(20),

        itemCount: tickets.length,

        itemBuilder: (context, index) {

          final ticket = tickets[index];

          final event = ticket.event;

          return Container(

            margin:
            const EdgeInsets.only(
              bottom: 20,
            ),

            decoration: BoxDecoration(

              gradient: const LinearGradient(

                colors: [
                  AppColors.primary,
                  AppColors.secondary,
                ],
              ),

              borderRadius:
              BorderRadius.circular(30),
            ),

            child: Column(

              children: [

                Padding(

                  padding:
                  const EdgeInsets.all(20),

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      /// Event Name
                      Text(

                        event.title,

                        style:
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Date
                      Row(

                        children: [

                          const Icon(
                            Icons.calendar_month,
                            color:
                            Colors.white,
                          ),

                          const SizedBox(width: 10),

                          Text(

                            event.date,

                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      /// Location
                      Row(

                        children: [

                          const Icon(
                            Icons.location_on,
                            color:
                            Colors.white,
                          ),

                          const SizedBox(width: 10),

                          Text(

                            event.location,

                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      /// Time
                      Row(

                        children: [

                          const Icon(
                            Icons.access_time,
                            color:
                            Colors.white,
                          ),

                          const SizedBox(width: 10),

                          Text(

                            event.time,

                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      /// Price
                      Row(

                        children: [

                          const Icon(
                            Icons.attach_money,
                            color:
                            Colors.white,
                          ),

                          const SizedBox(width: 10),

                          Text(

                            "\$${event.price}",

                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// Divider
                Container(

                  height: 2,

                  color:
                  Colors.white.withOpacity(
                    0.3,
                  ),
                ),

                /// Bottom Ticket
                Padding(

                  padding:
                  const EdgeInsets.all(20),

                  child: Row(

                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                    children: [

                      Column(

                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [

                          const Text(

                            "Ticket Status",

                            style: TextStyle(
                              color:
                              Colors.white70,
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text(

                            "Confirmed",

                            style: TextStyle(
                              color:
                              Colors.white,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const Icon(
                        Icons.qr_code,
                        color: Colors.white,
                        size: 60,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}