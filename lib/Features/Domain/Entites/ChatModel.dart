import 'package:smart_trip_planner/Features/Models/itineraryModel/ItineraryModel.dart';

class ChatMessage  {
  final bool isUser;
  final String message;
  final DateTime timestamp;
  final Itinerary? itinerary;

  const ChatMessage({
    required this.isUser,
    required this.message,
    required this.timestamp,
    this.itinerary,
  });

  @override
  List<Object?> get props => [isUser, message, timestamp, itinerary];
}