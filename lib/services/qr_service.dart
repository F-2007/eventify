import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Handles QR code generation and check-in verification
class QRService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const uuid = Uuid();

  /// Generate unique QR code
  /// Each ticket gets a unique code that attendees show for check-in
  /// Format: "550e8400-e29b-41d4-a716-446655440000"
  static String generateQRCode() {
    String qrCode = uuid.v4(); // Generates UUID like above
    print(' QR Code generated: $qrCode');
    return qrCode;
  }

  /// Store check-in record in Firestore
  /// Called when organizer scans or enters QR code
  static Future<bool> checkIn({
    required String eventId,
    required String userId,
    required String qrCode,
  }) async {
    try {
      // Add check-in record to Firestore
      await _db.collection('check_ins').add({
        'eventId': eventId,
        'userId': userId,
        'qrCode': qrCode,
        'checkInTime': DateTime.now(),
      });

      print(' Check-in recorded for user: $userId');
      return true;
    } catch (e) {
      print(' Check-in error: $e');
      return false;
    }
  }

  /// Verify QR code exists in database
  /// Used by organizer to validate before checking in
  static Future<bool> verifyQRCode(String qrCode) async {
    try {
      final result = await _db
          .collection('check_ins')
          .where('qrCode', isEqualTo: qrCode)
          .get();

      bool exists = result.docs.isNotEmpty;
      if (exists) {
        print(' QR Code verified: $qrCode');
      } else {
        print(' QR Code not found: $qrCode');
      }
      return exists;
    } catch (e) {
      print(' QR verification error: $e');
      return false;
    }
  }

  /// Get all check-ins for an event
  /// Used by organizer to see attendance
  static Future<List<Map<String, dynamic>>> getCheckIns(String eventId) async {
    try {
      final result = await _db
          .collection('check_ins')
          .where('eventId', isEqualTo: eventId)
          .get();

      return result.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print(' Get check-ins error: $e');
      return [];
    }
  }

  /// Check if user has already checked in
  static Future<bool> hasUserCheckedIn({
    required String eventId,
    required String userId,
  }) async {
    try {
      final result = await _db
          .collection('check_ins')
          .where('eventId', isEqualTo: eventId)
          .where('userId', isEqualTo: userId)
          .get();

      return result.docs.isNotEmpty;
    } catch (e) {
      print(' Check attendance error: $e');
      return false;
    }
  }
}
