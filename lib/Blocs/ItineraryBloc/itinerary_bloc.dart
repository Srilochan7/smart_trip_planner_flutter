import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_trip_planner/ApiServices.dart';

part 'itinerary_event.dart';
part 'itinerary_state.dart';

class ItineraryBloc extends Bloc<ItineraryEvent, ItineraryState> {
  ItineraryBloc() : super(ItineraryInitial()) {
    on<ItineraryEvent>((event, emit) {
    on<FetchItinerary>(_onFetchItinerary);
    });
  }

  Future<void> _onFetchItinerary(
      FetchItinerary event, Emitter<ItineraryState> emit) async {
    emit(ItineraryLoading());
    try {
      
      final itinerary = await GeminiApiService().sendPrompt(event.prompt);
      emit(ItineraryLoaded(itinerary));
    } catch (e) {
      emit(ItineraryError(e.toString()));
    }
  } 
}
