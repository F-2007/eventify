import 'user_model.dart';

class EventModel {
  final String title;
  final String location;
  final String description;
  final DateTime dateTime;
  final double price;
  final String id;
  final String creatorId;
  final UserRole creatorRole;

  EventModel({
    required this.title,
    required this.location,
    required this.description,
    required this.dateTime,
    required this.price,
    required this.id,
    required this.creatorId,
    required this.creatorRole,
  });
}
