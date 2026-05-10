import 'event_model.dart';

class TicketModel {
  final String id; // Unique ticket ID
  final EventModel event;
  final String userId; // Who bought the ticket
  final String qrCode; // Unique QR code for check-in
  final DateTime purchaseDate;
  final bool isCheckedIn; // Has user checked in?
  final DateTime? checkInTime; // When did they check in?

  TicketModel({
    required this.id,
    required this.event,
    required this.userId,
    required this.qrCode,
    required this.purchaseDate,
    this.isCheckedIn = false,
    this.checkInTime,
  });

  /// Convert ticket to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventId': event.id,
      'eventTitle': event.title,
      'eventDateTime': event.dateTime,
      'eventLocation': event.location,
      'eventPrice': event.price,
      'userId': userId,
      'qrCode': qrCode,
      'purchaseDate': purchaseDate,
      'isCheckedIn': isCheckedIn,
      'checkInTime': checkInTime,
    };
  }

  /// Create ticket from Firestore data
  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      id: map['id'] ?? '',
      event: EventModel(
        id: map['eventId'] ?? '',
        title: map['eventTitle'] ?? '',
        location: map['eventLocation'] ?? '',
        description: '',
        dateTime: (map['eventDateTime'] as dynamic)?.toDate() ?? DateTime.now(),
        price: (map['eventPrice'] ?? 0).toDouble(),
        creatorId: '',
        creatorRole: null,
      ),
      userId: map['userId'] ?? '',
      qrCode: map['qrCode'] ?? '',
      purchaseDate: (map['purchaseDate'] as dynamic)?.toDate() ?? DateTime.now(),
      isCheckedIn: map['isCheckedIn'] ?? false,
      checkInTime: (map['checkInTime'] as dynamic)?.toDate(),
    );
  }
}