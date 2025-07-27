import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:smart_trip_planner/Blocs/RefineBloc/refine_event.dart';
import 'package:smart_trip_planner/HiveModels/TripsHiveModel/TripsHiveModel.dart';
import 'package:smart_trip_planner/Services/ApiServices.dart';
import 'package:smart_trip_planner/Models/ItineraryModel.dart';

part 'itinerary_event.dart';
part 'itinerary_state.dart';

class ItineraryBloc extends Bloc<ItineraryEvent, ItineraryState> {
  ItineraryBloc() : super(ItineraryInitial()) {
    on<FetchItinerary>(_onFetchItinerary); 
    on<ItinerarySaveOffline>(_onSaveOffline);
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

Future<void> _onSaveOffline(
  ItinerarySaveOffline event,
  Emitter<ItineraryState> emit,
) async {
  emit(ItinerarySaveOfflineState());

  try {
    final box = Hive.box<TripsHiveModel>('itineraries');
    final newItem = TripsHiveModel(
      prompt: event.prompt,
      response: event.result,
      createdAt: DateTime.now(),
    );
    await box.add(newItem);
    emit(ItinerarySaveOfflineState());
  } catch (e) {
    // emit(ItinerarySaveError("Failed to save itinerary: ${e.toString()}"));
  }
}


}
