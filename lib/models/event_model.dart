import 'user_model.dart';

class EventModel {
  final String id;
  final String title;
  final String location;
  final String description;
  final DateTime dateTime;
  final double price;
  final String creatorId;
  final UserRole? creatorRole;
  final int capacity; // Total seats available
  final int attendeeCount; // How many booked tickets
  final DateTime createdAt;

  EventModel({
    required this.id,
    required this.title,
    required this.location,
    required this.description,
    required this.dateTime,
    required this.price,
    required this.creatorId,
    this.creatorRole,
    this.capacity = 100,
    this.attendeeCount = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Get available seats
  int get availableSeats => capacity - attendeeCount;

  /// Is event full?
  bool get isFull => availableSeats <= 0;

  /// Convert event to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'description': description,
      'dateTime': dateTime,
      'price': price,
      'creatorId': creatorId,
      'capacity': capacity,
      'attendeeCount': attendeeCount,
      'createdAt': createdAt,
    };
  }

  /// Create event from Firestore data
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      dateTime: (map['dateTime'] as dynamic)?.toDate() ?? DateTime.now(),
      price: (map['price'] ?? 0).toDouble(),
      creatorId: map['creatorId'] ?? '',
      capacity: map['capacity'] ?? 100,
      attendeeCount: map['attendeeCount'] ?? 0,
      createdAt: (map['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }
}
