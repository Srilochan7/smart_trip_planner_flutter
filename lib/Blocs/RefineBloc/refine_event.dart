import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_trip_planner/Models/ItineraryModel.dart';

// Events
abstract class RefineEvent extends Equatable {
const RefineEvent();
@override
List<Object> get props => [];
}
class InitializeRefine extends RefineEvent {
final String initialPrompt;
const InitializeRefine(this.initialPrompt);
@override
List<Object> get props => [initialPrompt];
}
// Simplified single event for sending messages
class SendMessage extends RefineEvent {
final String message;
const SendMessage(this.message);
@override
List<Object> get props => [message];
}
class SaveItinerary extends RefineEvent { 
const SaveItinerary();
}