part of 'itinerary_bloc.dart';

@immutable
sealed class ItineraryEvent {}


final class FetchItinerary extends ItineraryEvent {
  final String prompt;

  FetchItinerary(this.prompt);
}



class ItinerarySaveOffline extends ItineraryEvent {
  final String prompt;
  final String result;

  ItinerarySaveOffline(this.prompt, this.result);
}


class ItinerarySaveOfflineState extends ItineraryState {}
