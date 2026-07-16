// lib/features/settings/bloc/settings_event.dart
import 'package:equatable/equatable.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class ToggleThemeEvent extends SettingsEvent {
  const ToggleThemeEvent();
}

class UpdateLocationEvent extends SettingsEvent {
  const UpdateLocationEvent({
    required this.countryId,
    required this.regionId,
    required this.cityName,
  });

  final String countryId;
  final String regionId;
  final String cityName;

  @override
  List<Object?> get props => [countryId, regionId, cityName];
}
