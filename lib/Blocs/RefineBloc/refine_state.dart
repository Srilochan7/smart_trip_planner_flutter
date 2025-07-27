import 'package:equatable/equatable.dart';
import 'package:smart_trip_planner/Models/ChatModel.dart';

abstract class RefineState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RefineInitial extends RefineState {}

class RefineLoaded extends RefineState {
  final List<ChatMessage> messages;
  final String currentPrompt;
  final bool isRefining;

  RefineLoaded({
    required this.messages,
    required this.currentPrompt,
    this.isRefining = false,
  });

  @override
  List<Object?> get props => [messages, currentPrompt, isRefining];

  RefineLoaded copyWith({
    List<ChatMessage>? messages,
    String? currentPrompt,
    bool? isRefining,
  }) {
    return RefineLoaded(
      messages: messages ?? this.messages,
      currentPrompt: currentPrompt ?? this.currentPrompt,
      isRefining: isRefining ?? this.isRefining,
    );
  }
}

class RefineError extends RefineState {
  final String message;
  RefineError(this.message);
  @override
  List<Object> get props => [message];
}