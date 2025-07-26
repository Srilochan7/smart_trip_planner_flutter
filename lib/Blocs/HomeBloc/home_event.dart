part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}


class HomeInitialEvent extends HomeEvent {}

class HomeFetchItineraryEvent extends HomeEvent {
  final String vision;

  HomeFetchItineraryEvent(this.vision);
}


class CreateItineraryEvent extends HomeEvent {
  final String vision;

  CreateItineraryEvent(this.vision);
}


class ViewItineraryEvent extends HomeEvent {
  final String itineraryId;

  ViewItineraryEvent(this.itineraryId);
}



