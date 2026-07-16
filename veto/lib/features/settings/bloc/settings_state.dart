// lib/features/settings/bloc/settings_state.dart
import 'package:equatable/equatable.dart';

final class SettingsState extends Equatable {
  const SettingsState({
    this.isDarkMode = false,
    this.countryId,
    this.regionId,
    this.cityName,
  });

  /// Restores the state from locally stored JSON.
  factory SettingsState.fromJson(Map<String, dynamic> json) {
    return SettingsState(
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      countryId: json['countryId'] as String?,
      regionId: json['regionId'] as String?,
      cityName: json['cityName'] as String?,
    );
  }

  final bool isDarkMode;
  final String? countryId;
  final String? regionId;
  final String? cityName;

  /// Quick helper to check if a local location has been fully set up.
  bool get hasSavedLocation => 
      countryId != null && regionId != null && cityName != null;

  SettingsState copyWith({
    bool? isDarkMode,
    String? countryId,
    String? regionId,
    String? cityName,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      countryId: countryId ?? this.countryId,
      regionId: regionId ?? this.regionId,
      cityName: cityName ?? this.cityName,
    );
  }

  /// Converts the current state to JSON for HydratedBloc local storage.
  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'countryId': countryId,
      'regionId': regionId,
      'cityName': cityName,
    };
  }

  @override
  List<Object?> get props => [isDarkMode, countryId, regionId, cityName];
}
