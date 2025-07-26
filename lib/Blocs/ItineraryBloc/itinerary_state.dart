part of 'itinerary_bloc.dart';

@immutable
sealed class ItineraryState {}

final class ItineraryInitial extends ItineraryState {}


final class ItineraryLoading extends ItineraryState {}

final class ItineraryLoaded extends ItineraryState {
  final String itinerary;

  ItineraryLoaded(this.itinerary);
}

final class ItineraryError extends ItineraryState {
  final String message;

  ItineraryError(this.message);
}
