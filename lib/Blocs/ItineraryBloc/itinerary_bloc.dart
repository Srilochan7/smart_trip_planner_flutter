import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:smart_trip_planner/ApiServices.dart';
import 'package:smart_trip_planner/Models/ItineraryModel.dart';

part 'itinerary_event.dart';
part 'itinerary_state.dart';

class ItineraryBloc extends Bloc<ItineraryEvent, ItineraryState> {
  ItineraryBloc() : super(ItineraryInitial()) {
    on<FetchItinerary>(_onFetchItinerary); // ✅ FIXED!
  }

  Future<void> _onFetchItinerary(
    FetchItinerary event, Emitter<ItineraryState> emit) async {
  emit(ItineraryLoading());
  try {
    final responseString = await GeminiApiService().getItinerary(event.prompt);

    final itinerary = itineraryFromJson(responseString); 

    emit(ItineraryLoaded(itinerary)); // 
  } catch (e) {
    emit(ItineraryError(e.toString()));
  }
}

}
