import '../models/event_model.dart';

class EventService {

  /// Events List
  static List<EventModel> events = [

    EventModel(

      title: "Tech Conference 2026",

      location: "Cairo, Egypt",

      description:
      "Join one of the biggest technology conferences in Egypt.",

      date: "15 May 2026",

      time: "10:00 AM",

      price: 120,
    ),

    EventModel(

      title: "Music Festival",

      location: "Giza, Egypt",

      description:
      "Enjoy live music with your friends and favorite artists.",

      date: "20 May 2026",

      time: "07:00 PM",

      price: 80,
    ),
  ];

  /// Add Event
  static void addEvent(EventModel event) {

    events.add(event);
  }

  /// Delete Event
  static void deleteEvent(int index) {

    events.removeAt(index);
  }

  /// Get Events
  static List<EventModel> getEvents() {

    return events;
  }
}