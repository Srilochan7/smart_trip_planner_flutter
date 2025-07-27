part of 'itinerary_bloc.dart';

abstract class ItineraryState extends Equatable {
  const ItineraryState();

  @override
  List<Object> get props => [];
}

class ItineraryInitial extends ItineraryState {}

class ItineraryLoading extends ItineraryState {}


class ItineraryLoaded extends ItineraryState {
  final Itinerary itinerary;

  const ItineraryLoaded(this.itinerary);
  @override
  List<Object> get props => [itinerary];
}

class ItineraryError extends ItineraryState {
  final String message;
  const ItineraryError(this.message);

  @override
  List<Object> get props => [message];
}


class ItinerarySaveOffilne extends ItineraryState{
  
}