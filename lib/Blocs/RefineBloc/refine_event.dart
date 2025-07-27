import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_trip_planner/Models/ItineraryModel.dart';

// Events
abstract class RefineEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitializeRefine extends RefineEvent {
  final String initialPrompt;
  InitializeRefine(this.initialPrompt);
  @override
  List<Object> get props => [initialPrompt];
}

class AddUserMessage extends RefineEvent {
  final String message;
  AddUserMessage(this.message);
  @override
  List<Object> get props => [message];
}

class RefineItinerary extends RefineEvent {
  final String refinementPrompt;
  RefineItinerary(this.refinementPrompt);
  @override
  List<Object> get props => [refinementPrompt];
}

class SaveItinerary extends RefineEvent {}