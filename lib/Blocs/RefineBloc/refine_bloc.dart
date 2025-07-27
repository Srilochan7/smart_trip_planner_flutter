import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_trip_planner/Blocs/ItineraryBloc/itinerary_bloc.dart';
import 'package:smart_trip_planner/Blocs/RefineBloc/refine_event.dart';
import 'package:smart_trip_planner/Blocs/RefineBloc/refine_state.dart';
import 'package:smart_trip_planner/Models/ChatModel.dart';
import 'package:smart_trip_planner/Models/ItineraryModel.dart';

class RefineBloc extends Bloc<RefineEvent, RefineState> {
  final ItineraryBloc itineraryBloc;
  
  RefineBloc(this.itineraryBloc) : super(RefineInitial()) {
    on<InitializeRefine>(_onInitialize);
    on<AddUserMessage>(_onAddUserMessage);
    on<RefineItinerary>(_onRefineItinerary);
    
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

  void _onAddUserMessage(AddUserMessage event, Emitter<RefineState> emit) {
    if (state is RefineLoaded) {
      final currentState = state as RefineLoaded;
      final userMessage = ChatMessage(
        isUser: true,
        message: event.message,
        timestamp: DateTime.now(),
      );
      
      emit(currentState.copyWith(
        messages: [...currentState.messages, userMessage],
        isRefining: true,
      ));
    }
  }

  void _onRefineItinerary(RefineItinerary event, Emitter<RefineState> emit) {
    if (state is RefineLoaded) {
      final currentState = state as RefineLoaded;
      final refinedPrompt = "${currentState.currentPrompt}\n\nAdditional requirements: ${event.refinementPrompt}";
      
      emit(currentState.copyWith(
        currentPrompt: refinedPrompt,
        isRefining: true,
      ));
      
      itineraryBloc.add(FetchItinerary(refinedPrompt));
    }
  }

  

  Future<void> _saveToHive(String prompt, Itinerary itinerary) async {
    
  }

  void onItineraryUpdated(Itinerary itinerary) {
    if (state is RefineLoaded) {
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
  }

  void onItineraryError(String error) {
    emit(RefineError(error));
  }
}