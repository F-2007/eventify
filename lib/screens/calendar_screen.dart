import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {

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

      body: SingleChildScrollView(

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

              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
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

                  /// Month Header
                  Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: const [

                      Icon(Icons.arrow_back_ios),

                      Text(

                        "May 2026",

                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),

                  const SizedBox(height: 25),

                  /// Days Row
                  const Row(

                    mainAxisAlignment: MainAxisAlignment.spaceAround,

                    children: [

                      Text("S"),
                      Text("M"),
                      Text("T"),
                      Text("W"),
                      Text("T"),
                      Text("F"),
                      Text("S"),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Calendar Dates
                  GridView.count(

                    shrinkWrap: true,

                    physics: const NeverScrollableScrollPhysics(),

                    crossAxisCount: 7,

                    mainAxisSpacing: 12,

                    crossAxisSpacing: 12,

                    children: List.generate(31, (index) {

                      final day = index + 1;

                      final isSelected = day == 15;

                      return Container(

                        decoration: BoxDecoration(

                          color: isSelected
                              ? AppColors.primary
                              : AppColors.background,

                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: Center(

                          child: Text(

                            "$day",

                            style: TextStyle(

                              color: isSelected
                                  ? Colors.white
                                  : AppColors.dark,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            /// Events Title
            const Text(

              "Events on 15 May",

              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),

            const SizedBox(height: 20),

            /// Event Card 1
            Container(

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

                    child: const Icon(
                      Icons.business_center,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 15),

                  const Expanded(

                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Text(

                          "Tech Conference",

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(

                          "10:00 AM - Cairo",

                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// Event Card 2
            Container(

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

                      color: AppColors.blue,

                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: const Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 15),

                  const Expanded(

                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Text(

                          "Music Festival",

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(

                          "07:00 PM - Giza",

                          style: TextStyle(
                            color: Colors.grey,
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