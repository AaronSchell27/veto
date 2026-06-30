// lib/features/home/bloc/home_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veto/features/home/bloc/home_event.dart';
import 'package:veto/features/home/bloc/home_state.dart';

// lib/features/home/bloc/home_event.dart
abstract class HomeEvent {}
class ToggleThemeEvent extends HomeEvent {}

// lib/features/home/bloc/home_state.dart
class HomeState {
  const HomeState({this.isDarkMode = false});
  final bool isDarkMode;
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<ToggleThemeEvent>((event, emit) {
      emit(HomeState(isDarkMode: !state.isDarkMode));
    });
  }
}
