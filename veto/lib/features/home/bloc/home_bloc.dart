import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veto/features/home/bloc/home_event.dart';
import 'package:veto/features/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<ToggleThemeEvent>((event, emit) {
      // Using copyWith is better practice as your state grows
      emit(state.copyWith(isDarkMode: !state.isDarkMode));
    });
  }
}
