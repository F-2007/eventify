import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class EventService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference _eventsCollection =
      _db.collection('events');

  /// Add Event to Firestore
  static Future<void> addEvent(EventModel event) async {
    try {
      await _eventsCollection.doc(event.id).set(event.toMap());
      print(' Event added to Firestore: ${event.title}');
    } catch (e) {
      print(' Error adding event: $e');
    }
  }

  /// Get All Events from Firestore
  static Future<List<EventModel>> getEvents() async {
    try {
      final snapshot =
          await _eventsCollection.orderBy('dateTime', descending: false).get();
      return snapshot.docs
          .map((doc) =>
              EventModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(' Error getting events: $e');
      return [];
    }
  }

  /// Stream All Events (real-time updates)
  static Stream<List<EventModel>> streamEvents() {
    return _eventsCollection
        .orderBy('dateTime', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                EventModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  /// Get Events By Creator from Firestore
  static Future<List<EventModel>> getEventsByCreator(String creatorId) async {
    try {
      final snapshot = await _eventsCollection
          .where('creatorId', isEqualTo: creatorId)
          .get();
      return snapshot.docs
          .map((doc) =>
              EventModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(' Error getting events by creator: $e');
      return [];
    }
  }

  /// Stream Events By Creator (real-time updates)
  static Stream<List<EventModel>> streamEventsByCreator(String creatorId) {
    return _eventsCollection
        .where('creatorId', isEqualTo: creatorId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                EventModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  /// Get Single Event by ID
  static Future<EventModel?> getEventById(String eventId) async {
    try {
      final doc = await _eventsCollection.doc(eventId).get();
      if (doc.exists) {
        return EventModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print(' Error getting event: $e');
      return null;
    }
  }

  /// Delete Event from Firestore
  static Future<void> deleteEventById(String id) async {
    try {
      await _eventsCollection.doc(id).delete();
      print(' Event deleted: $id');
    } catch (e) {
      print(' Error deleting event: $e');
    }
  }

  /// Increment attendee count when a ticket is booked
  static Future<void> incrementAttendeeCount(String eventId) async {
    try {
      await _eventsCollection.doc(eventId).update({
        'attendeeCount': FieldValue.increment(1),
      });
      print(' Attendee count incremented for event: $eventId');
    } catch (e) {
      print(' Error incrementing attendee count: $e');
    }
  }
}
