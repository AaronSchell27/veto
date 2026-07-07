// lib/features/home/bloc/home_event.dart

import 'package:equatable/equatable.dart';
import 'package:veto/features/home/models/location_models.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

// Existing theme event
class ToggleThemeEvent extends HomeEvent {
  const ToggleThemeEvent();
}

// This is the missing event! Trigger this when the home page loads.
class LocationOnboardingInitialized extends HomeEvent {
  const LocationOnboardingInitialized();
}

class LocationCountryChanged extends HomeEvent {
  const LocationCountryChanged(this.country);
  final Country country;

  @override
  List<Object?> get props => [country];
}

class LocationRegionChanged extends HomeEvent {
  const LocationRegionChanged(this.region);
  final Region region;

  @override
  List<Object?> get props => [region];
}

class LocationCityChanged extends HomeEvent {
  const LocationCityChanged(this.city);
  final String city;

  @override
  List<Object?> get props => [city];
}

class LocationFormSubmitted extends HomeEvent {
  const LocationFormSubmitted();
}
