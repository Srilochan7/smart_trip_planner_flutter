import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:smart_trip_planner/Blocs/ItineraryBloc/itinerary_bloc.dart';
import 'package:smart_trip_planner/Blocs/RefineBloc/refine_event.dart';
import 'package:smart_trip_planner/Blocs/RefineBloc/refine_state.dart';
import 'package:smart_trip_planner/HiveModels/TripsHiveModel/TripsHiveModel.dart';
import 'package:smart_trip_planner/Models/ChatModel.dart';
import 'package:smart_trip_planner/Models/ItineraryModel.dart';

class RefineBloc extends Bloc<RefineEvent, RefineState> {
  final ItineraryBloc itineraryBloc;
  
  RefineBloc(this.itineraryBloc) : super(RefineInitial()) {
    on<InitializeRefine>(_onInitialize);
    on<SendMessage>(_onSendMessage);
    on<SaveItinerary>(_onSaveItinerary);
  }

  void _onInitialize(InitializeRefine event, Emitter<RefineState> emit) {
    final initialMessage = ChatMessage(
      isUser: true,
      message: event.initialPrompt,
      timestamp: DateTime.now(),
    );
    
    emit(RefineLoaded(
      messages: [initialMessage],
      currentPrompt: event.initialPrompt,
    ));
    
 
    itineraryBloc.add(FetchItinerary(event.initialPrompt));
  }

  void _onSendMessage(SendMessage event, Emitter<RefineState> emit) {
    if (state is! RefineLoaded) return;
    
    final currentState = state as RefineLoaded;

    final userMessage = ChatMessage(
      isUser: true,
      message: event.message,
      timestamp: DateTime.now(),
    );
    

    final refinedPrompt = "${currentState.currentPrompt}\n\nAdditional requirements: ${event.message}";
    
    emit(currentState.copyWith(
      messages: [...currentState.messages, userMessage],
      currentPrompt: refinedPrompt,
      isRefining: true,
    ));
    

    itineraryBloc.add(FetchItinerary(refinedPrompt));
  }

  void _onSaveItinerary(SaveItinerary event, Emitter<RefineState> emit) async {
    if (state is! RefineLoaded) return;
    
    final currentState = state as RefineLoaded;
    

    final latestItinerary = currentState.messages
        .where((msg) => !msg.isUser && msg.itinerary != null)
        .lastOrNull
        ?.itinerary;
    
    if (latestItinerary != null) {
      try {
        await _onSaveOffline(currentState.currentPrompt as ItinerarySaveOffline, latestItinerary as Emitter<ItineraryState>);
        
      } catch (e) {
        emit(RefineError('Failed to save itinerary: $e'));
      }
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


  void onItineraryUpdated(Itinerary itinerary) {
    if (state is! RefineLoaded) return;
    
    final currentState = state as RefineLoaded;
    final aiMessage = ChatMessage(
      isUser: false,
      message: "Updated itinerary based on your requirements!",
      timestamp: DateTime.now(),
      itinerary: itinerary,
    );
    
    emit(currentState.copyWith(
      messages: [...currentState.messages, aiMessage],
      isRefining: false,
    ));
  }

  void onItineraryError(String error) {
    emit(RefineError(error));
  }
}

// Extension for better null safety
extension IterableExtension<T> on Iterable<T> {
  T? get lastOrNull => isEmpty ? null : last;
}