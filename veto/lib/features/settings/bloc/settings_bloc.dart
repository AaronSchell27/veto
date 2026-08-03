// lib/features/settings/bloc/settings_bloc.dart

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:location_repository/location_repository.dart';
import 'package:veto/features/settings/bloc/settings_event.dart';
import 'package:veto/features/settings/bloc/settings_state.dart';

/// {@template settings_bloc}
/// Manages theme and local location settings with persistent hydrated state.
/// {@endtemplate}
class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  /// {@macro settings_bloc}
  SettingsBloc({
    required LocationRepository locationRepository,
  })  : _locationRepository = locationRepository,
        super(const SettingsState()) {
    on<ToggleThemeEvent>((event, emit) {
      emit(state.copyWith(isDarkMode: !state.isDarkMode));
    });

    on<UpdateLocationEvent>(_onUpdateLocation);
  }

  final LocationRepository _locationRepository;

  Future<void> _onUpdateLocation(
    UpdateLocationEvent event,
    Emitter<SettingsState> emit,
  ) async {
    // 1. Emit updated settings state immediately
    emit(
      state.copyWith(
        countryId: event.countryId,
        regionId: event.regionId,
        cityName: event.cityName,
      ),
    );

    // 2. Persist locally via LocationRepository
    await _locationRepository.saveUserLocation(
      countryId: event.countryId,
      regionId: event.regionId,
      cityName: event.cityName,
    );
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) =>
      SettingsState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(SettingsState state) => state.toJson();
}
