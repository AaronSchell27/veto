// lib/features/settings/bloc/settings_bloc.dart
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:veto/features/settings/bloc/settings_event.dart';
import 'package:veto/features/settings/bloc/settings_state.dart';

class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<ToggleThemeEvent>((event, emit) {
      emit(state.copyWith(isDarkMode: !state.isDarkMode));
    });

    on<UpdateLocationEvent>((event, emit) {
      emit(state.copyWith(
        countryId: event.countryId,
        regionId: event.regionId,
        cityName: event.cityName,
      ));
    });
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) => 
      SettingsState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(SettingsState state) => 
      state.toJson();
}
