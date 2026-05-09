import 'package:flutter/material.dart';

import '../models/event_model.dart';

import '../theme/app_colors.dart';

class EventCard extends StatelessWidget {

  final EventModel event;

  final VoidCallback onTap;

  const EventCard({

    super.key,

    required this.event,

    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        margin: const EdgeInsets.only(
          bottom: 20,
        ),

        width: double.infinity,

        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(

          gradient: const LinearGradient(

            colors: [
              AppColors.primary,
              AppColors.secondary,
            ],
          ),

          borderRadius:
          BorderRadius.circular(25),
        ),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            /// Title
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

            /// Date
            Row(

              children: [

                const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                ),

                const SizedBox(width: 8),

                Text(

                  event.date,

                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// Location
            Row(

              children: [

                const Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),

                const SizedBox(width: 8),

                Text(

                  event.location,

                  style: const TextStyle(
                    color: Colors.white,
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
                  color: Colors.white,
                ),

                const SizedBox(width: 8),

                Text(

                  "\$${event.price}",

                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}