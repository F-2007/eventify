import 'package:flutter/material.dart';

import '../models/event_model.dart';

import '../services/event_service.dart';

import '../theme/app_colors.dart';

import 'event_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    List<EventModel> events =
    EventService.getEvents();

    return Scaffold(

      appBar: AppBar(

        title: const Text(

          "Eventify",

          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            /// Welcome Text
            const Text(

              "Welcome Back 👋",

              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),

            const SizedBox(height: 8),

            const Text(

              "Discover amazing events around you",

              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            /// Search Bar
            Container(

              padding:
              const EdgeInsets.symmetric(
                horizontal: 15,
              ),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.circular(15),
              ),

              child: const TextField(

                decoration: InputDecoration(

                  border: InputBorder.none,

                  hintText: "Search events...",

                  icon: Icon(Icons.search),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// Upcoming Events
            const Text(

              "Upcoming Events",

              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),

            const SizedBox(height: 20),

            /// Dynamic Events
            ListView.builder(

              shrinkWrap: true,

              physics:
              const NeverScrollableScrollPhysics(),

              itemCount: events.length,

              itemBuilder: (context, index) {

                final event = events[index];

                return GestureDetector(

                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (_) =>

                            EventDetailsScreen(
                              event: event,
                            ),
                      ),
                    );
                  },

                  child: Container(

                    margin:
                    const EdgeInsets.only(
                      bottom: 20,
                    ),

                    width: double.infinity,

                    padding:
                    const EdgeInsets.all(20),

                    decoration: BoxDecoration(

                      gradient:
                      const LinearGradient(

                        colors: [
                          AppColors.primary,
                          AppColors.secondary,
                        ],
                      ),

                      borderRadius:
                      BorderRadius.circular(
                          25),
                    ),

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        Text(

                          event.title,

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Row(

                          children: [

                            const Icon(
                              Icons.calendar_month,
                              color: Colors.white,
                            ),

                            const SizedBox(width: 8),

                            Text(

                              event.date,

                              style:
                              const TextStyle(
                                color:
                                Colors.white,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(

                          children: [

                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),

                            const SizedBox(width: 8),

                            Text(

                              event.location,

                              style:
                              const TextStyle(
                                color:
                                Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      floatingActionButton:
      FloatingActionButton(

        backgroundColor: AppColors.primary,

        onPressed: () {

        },

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}