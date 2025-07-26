part of 'itinerary_bloc.dart';

@immutable
sealed class ItineraryEvent {}


final class FetchItinerary extends ItineraryEvent {
  final String prompt;

  FetchItinerary(this.prompt);
}

