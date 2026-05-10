/// Model for storing check-in records
/// When an attendee checks in to an event, a record is created
class CheckInModel {
  final String id;
  final String eventId; // Which event
  final String userId; // Who checked in
  final String qrCode; // The QR code that was scanned
  final DateTime checkInTime; // When they checked in
  final String? notes; // Optional notes (e.g., "Came with friend")

  CheckInModel({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.qrCode,
    required this.checkInTime,
    this.notes,
  });

  /// Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventId': eventId,
      'userId': userId,
      'qrCode': qrCode,
      'checkInTime': checkInTime,
      'notes': notes,
    };
  }

  /// Create from Firestore data
  factory CheckInModel.fromMap(Map<String, dynamic> map) {
    return CheckInModel(
      id: map['id'] ?? '',
      eventId: map['eventId'] ?? '',
      userId: map['userId'] ?? '',
      qrCode: map['qrCode'] ?? '',
      checkInTime: (map['checkInTime'] as dynamic)?.toDate() ?? DateTime.now(),
      notes: map['notes'],
    );
  }
}
