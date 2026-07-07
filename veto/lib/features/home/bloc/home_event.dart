// lib/features/home/bloc/home_event.dart

import 'package:equatable/equatable.dart';
import 'package:veto/features/home/models/location_models.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeCountriesRequested extends HomeEvent {
  const HomeCountriesRequested();
}

class HomeCountryChanged extends HomeEvent {
  const HomeCountryChanged(this.country);
  final Country country;

  @override
  List<Object?> get props => [country];
}

class HomeRegionChanged extends HomeEvent {
  const HomeRegionChanged(this.region);
  final Region region;

  @override
  List<Object?> get props => [region];
}

class HomeCityInputChanged extends HomeEvent {
  const HomeCityInputChanged(this.cityInput);
  final String cityInput;

  @override
  List<Object?> get props => [cityInput];
}

class HomeLocationSubmitted extends HomeEvent {
  const HomeLocationSubmitted();
}
