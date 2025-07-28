import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:smart_trip_planner/Features/Presentation/Blocs/ItineraryBloc/itinerary_bloc.dart';
import 'package:smart_trip_planner/Features/Presentation/Blocs/RefineBloc/refine_event.dart';
import 'package:smart_trip_planner/Features/Presentation/Blocs/RefineBloc/refine_state.dart';
import 'package:smart_trip_planner/Features/Models/TripsHiveModel/TripsHiveModel.dart';
import 'package:smart_trip_planner/Features/Domain/Entites/ChatModel.dart';
import 'package:smart_trip_planner/Features/Models/itineraryModel/ItineraryModel.dart';

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
        await _onSaveOffline(currentState.currentPrompt, latestItinerary);
        
      } catch (e) {
        emit(RefineError('Failed to save itinerary: $e'));
      }
    }
  }

  Future<void> _onSaveOffline(String prompt, Itinerary itinerary) async {
    try {
      final box = Hive.box<TripsHiveModel>('itineraries');
      final newItem = TripsHiveModel(
        prompt: prompt,
        response: itinerary.toString(),
        createdAt: DateTime.now(),
      );
      await box.add(newItem);
    } catch (e) {
      throw Exception("Failed to save itinerary: ${e.toString()}");
    }
  }

  void onItineraryUpdated(Itinerary itinerary) {
    if (state is! RefineLoaded) return;
    
    final currentState = state as RefineLoaded;
    
    // Add JSON error handling here for Gemini responses
    try {
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
    } catch (e) {
      // Handle any JSON parsing errors here
      print('Error in onItineraryUpdated: $e');
      emit(RefineError('Failed to update itinerary: ${e.toString()}'));
    }
  }

  void onItineraryError(String error) {
    // Add JSON error handling for Gemini format exceptions
    if (error.contains('FormatException') || error.contains('JSON')) {
      // Handle JSON format errors specifically
      if (state is RefineLoaded) {
        final currentState = state as RefineLoaded;
        final errorMessage = ChatMessage(
          isUser: false,
          message: "Sorry, there was an issue processing the response. Please try again.",
          timestamp: DateTime.now(),
        );
        
        emit(currentState.copyWith(
          messages: [...currentState.messages, errorMessage],
          isRefining: false,
        ));
      }
    } else {
      emit(RefineError(error));
    }
  }
}

// Extension for better null safety
extension IterableExtension<T> on Iterable<T> {
  T? get lastOrNull => isEmpty ? null : last;
}