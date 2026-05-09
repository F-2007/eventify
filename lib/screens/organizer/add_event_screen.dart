import 'package:flutter/material.dart';

import '../../models/event_model.dart';

import '../../services/event_service.dart';

import '../../theme/app_colors.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() =>
      _AddEventScreenState();
}

class _AddEventScreenState
    extends State<AddEventScreen> {

  final TextEditingController titleController =
  TextEditingController();

  final TextEditingController locationController =
  TextEditingController();

  final TextEditingController descriptionController =
  TextEditingController();

  final TextEditingController dateController =
  TextEditingController();

  final TextEditingController timeController =
  TextEditingController();

  final TextEditingController priceController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(

          "Add Event",

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

            const SizedBox(height: 10),

            const Text(

              "Create New Event 🎉",

              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),

            const SizedBox(height: 8),

            const Text(

              "Fill all event details below",

              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            /// Event Title
            buildTextField(

              controller: titleController,

              hint: "Event Title",

              icon: Icons.event,
            ),

            const SizedBox(height: 20),

            /// Location
            buildTextField(

              controller: locationController,

              hint: "Location",

              icon: Icons.location_on,
            ),

            const SizedBox(height: 20),

            /// Description
            TextField(

              controller: descriptionController,

              maxLines: 5,

              decoration: InputDecoration(

                filled: true,

                fillColor: Colors.white,

                hintText: "Description",

                prefixIcon: const Padding(

                  padding: EdgeInsets.only(
                    bottom: 80,
                  ),

                  child: Icon(
                    Icons.description,
                    color: AppColors.primary,
                  ),
                ),

                border: OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(18),

                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Date
            buildTextField(

              controller: dateController,

              hint: "Event Date",

              icon: Icons.calendar_month,
            ),

            const SizedBox(height: 20),

            /// Time
            buildTextField(

              controller: timeController,

              hint: "Event Time",

              icon: Icons.access_time,
            ),

            const SizedBox(height: 20),

            /// Price
            buildTextField(

              controller: priceController,

              hint: "Ticket Price",

              icon: Icons.attach_money,
            ),

            const SizedBox(height: 35),

            /// Create Event Button
            SizedBox(

              width: double.infinity,

              height: 60,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(

                  backgroundColor:
                  AppColors.primary,

                  shape: RoundedRectangleBorder(

                    borderRadius:
                    BorderRadius.circular(18),
                  ),
                ),

                onPressed: () {

                  EventModel newEvent =
                  EventModel(

                    title:
                    titleController.text,

                    location:
                    locationController.text,

                    description:
                    descriptionController
                        .text,

                    date:
                    dateController.text,

                    time:
                    timeController.text,

                    price:
                    double.tryParse(
                        priceController
                            .text) ??
                        0,
                  );

                  EventService.addEvent(
                    newEvent,
                  );

                  ScaffoldMessenger.of(
                      context)
                      .showSnackBar(

                    const SnackBar(

                      content: Text(
                        "Event Added Successfully 🎉",
                      ),
                    ),
                  );

                  Navigator.pop(context);
                },

                child: const Text(

                  "Create Event",

                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({

    required TextEditingController controller,

    required String hint,

    required IconData icon,

  }) {

    return TextField(

      controller: controller,

      decoration: InputDecoration(

        filled: true,

        fillColor: Colors.white,

        hintText: hint,

        prefixIcon: Icon(
          icon,
          color: AppColors.primary,
        ),

        border: OutlineInputBorder(

          borderRadius: BorderRadius.circular(18),

          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}