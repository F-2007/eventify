import 'package:flutter/material.dart';

import '../../models/event_model.dart';
import '../../models/ticket_model.dart';

import '../../services/ticket_service.dart';

import '../../theme/app_colors.dart';

class EventDetailsScreen extends StatelessWidget {

  final EventModel event;

  const EventDetailsScreen({

    super.key,

    required this.event,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.background,

      body: SingleChildScrollView(

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            /// Event Header
            Stack(

              children: [

                Container(

                  height: 320,

                  width: double.infinity,

                  decoration: const BoxDecoration(

                    gradient: LinearGradient(

                      colors: [
                        AppColors.primary,
                        AppColors.secondary,
                      ],

                      begin: Alignment.topLeft,

                      end: Alignment.bottomRight,
                    ),
                  ),

                  child: const Center(

                    child: Icon(

                      Icons.event,

                      size: 120,

                      color: Colors.white,
                    ),
                  ),
                ),

                Positioned(

                  top: 50,
                  left: 20,

                  child: CircleAvatar(

                    backgroundColor:
                    Colors.white,

                    child: IconButton(

                      onPressed: () {

                        Navigator.pop(context);

                      },

                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.dark,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// Content
            Padding(

              padding: const EdgeInsets.all(25),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  /// Title
                  Text(

                    event.title,

                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight:
                      FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// Date
                  Row(

                    children: [

                      const Icon(
                        Icons.calendar_month,
                        color: AppColors.primary,
                      ),

                      const SizedBox(width: 10),

                      Text(

                        event.date,

                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
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
                        color: AppColors.primary,
                      ),

                      const SizedBox(width: 10),

                      Text(

                        event.location,

                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
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
                        color: AppColors.primary,
                      ),

                      const SizedBox(width: 10),

                      Text(

                        event.time,

                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
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
                      fontWeight:
                      FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(

                    event.description,

                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 35),

                  /// Price Card
                  Container(

                    padding:
                    const EdgeInsets.all(20),

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                      BorderRadius.circular(25),
                    ),

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

                              "Ticket Price",

                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(

                              "\$${event.price}",

                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight:
                                FontWeight.bold,
                                color:
                                AppColors.primary,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(

                          width: 160,
                          height: 55,

                          child: ElevatedButton(

                            style:
                            ElevatedButton
                                .styleFrom(

                              backgroundColor:
                              AppColors.primary,

                              shape:
                              RoundedRectangleBorder(

                                borderRadius:
                                BorderRadius
                                    .circular(
                                    18),
                              ),
                            ),

                            onPressed: () {

                              TicketModel ticket =
                              TicketModel(
                                event: event,
                              );

                              TicketService.addTicket(
                                ticket,
                              );

                              ScaffoldMessenger.of(
                                  context)
                                  .showSnackBar(

                                SnackBar(

                                  content: Text(
                                    "${event.title} Booked Successfully 🎉",
                                  ),
                                ),
                              );
                            },

                            child: const Text(

                              "Book Now",

                              style: TextStyle(
                                color:
                                Colors.white,
                                fontSize: 17,
                                fontWeight:
                                FontWeight.bold,
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