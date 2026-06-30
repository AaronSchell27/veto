// lib/features/settings/bloc/settings_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veto/features/settings/bloc/settings_event.dart';
import 'package:veto/features/settings/bloc/settings_state.dart';

// lib/features/settings/bloc/settings_event.dart
abstract class SettingsEvent {}
class ToggleThemeEvent extends SettingsEvent {}

// lib/features/settings/bloc/settings_state.dart
class SettingsState {
  const SettingsState({this.isDarkMode = false});
  final bool isDarkMode;
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<ToggleThemeEvent>((event, emit) {
      emit(SettingsState(isDarkMode: !state.isDarkMode));
    });
  }
}
