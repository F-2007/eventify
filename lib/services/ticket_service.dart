import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ticket_model.dart';

class TicketService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference _ticketsCollection =
      _db.collection('tickets');

  /// Add Ticket to Firestore
  static Future<void> addTicket(TicketModel ticket) async {
    try {
      await _ticketsCollection.doc(ticket.id).set(ticket.toMap());
      print(' Ticket added to Firestore: ${ticket.id}');
    } catch (e) {
      print(' Error adding ticket: $e');
    }
  }

  /// Get All Tickets from Firestore
  static Future<List<TicketModel>> getTickets() async {
    try {
      final snapshot = await _ticketsCollection.get();
      return snapshot.docs
          .map((doc) =>
              TicketModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(' Error getting tickets: $e');
      return [];
    }
  }

  /// Get Tickets by User ID
  static Future<List<TicketModel>> getTicketsByUser(String userId) async {
    try {
      final snapshot = await _ticketsCollection
          .where('userId', isEqualTo: userId)
          .get();
      return snapshot.docs
          .map((doc) =>
              TicketModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(' Error getting tickets by user: $e');
      return [];
    }
  }

  /// Stream Tickets by User ID (real-time)
  static Stream<List<TicketModel>> streamTicketsByUser(String userId) {
    return _ticketsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                TicketModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  /// Get Tickets by Event ID (for organizer analytics)
  static Future<List<TicketModel>> getTicketsByEvent(String eventId) async {
    try {
      final snapshot = await _ticketsCollection
          .where('eventId', isEqualTo: eventId)
          .get();
      return snapshot.docs
          .map((doc) =>
              TicketModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(' Error getting tickets by event: $e');
      return [];
    }
  }

  /// Get Ticket by QR Code (for scanner validation)
  static Future<TicketModel?> getTicketByQrCode(String qrCode) async {
    try {
      final snapshot = await _ticketsCollection
          .where('qrCode', isEqualTo: qrCode)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return TicketModel.fromMap(
            snapshot.docs.first.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print(' Error getting ticket by QR: $e');
      return null;
    }
  }

  /// Mark ticket as checked in
  static Future<void> markCheckedIn(String ticketId) async {
    try {
      await _ticketsCollection.doc(ticketId).update({
        'isCheckedIn': true,
        'checkInTime': DateTime.now(),
      });
      print(' Ticket marked as checked in: $ticketId');
    } catch (e) {
      print(' Error marking check-in: $e');
    }
  }
}