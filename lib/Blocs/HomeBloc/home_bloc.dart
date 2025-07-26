import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_trip_planner/Models/ItineraryModel.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
