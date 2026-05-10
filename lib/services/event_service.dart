import '../models/event_model.dart';
import '../models/user_model.dart';

class EventService {
  /// Events List
  static List<EventModel> events = [
    EventModel(
      id: "event-1",

      creatorId: "admin",

      creatorRole: UserRole.admin,

      title: "Tech Conference 2026",

      location: "Cairo, Egypt",

      description: "Join one of the biggest technology conferences in Egypt.",

      dateTime: DateTime(2026, 5, 15, 10, 0),

      price: 120,
    ),

    EventModel(
      id: "event-2",

      creatorId: "admin",

      creatorRole: UserRole.admin,

      title: "Music Festival",

      location: "Giza, Egypt",

      description: "Enjoy live music with your friends and favorite artists.",

      dateTime: DateTime(2026, 5, 20, 19, 0),

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

  /// Delete Event By Id
  static void deleteEventById(String id) {
    events.removeWhere((event) => event.id == id);
  }

  /// Get Events By Creator
  static List<EventModel> getEventsByCreator(String creatorId) {
    return events.where((event) => event.creatorId == creatorId).toList();
  }

  /// Get Events
  static List<EventModel> getEvents() {
    return events;
  }
}
