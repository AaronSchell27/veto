// lib/features/home/bloc/home_state.dart

import 'package:equatable/equatable.dart';
import 'package:veto/features/home/models/location_models.dart';

final class HomeState extends Equatable {
  const HomeState({
    this.isDarkMode = false,
    this.showLocationOnboarding = true,
    this.countries = const [],
    this.availableRegions = const [],
    this.selectedCountry,
    this.selectedRegion,
    this.cityInput = '',
  });

  final bool isDarkMode;
  final bool showLocationOnboarding;
  
  final List<Country> countries;
  final List<Region> availableRegions;
  
  final Country? selectedCountry;
  final Region? selectedRegion;
  final String cityInput;

  bool get isLocationFormValid => 
      selectedCountry != null && selectedRegion != null && cityInput.trim().isNotEmpty;

HomeState copyWith({
  bool? isDarkMode,
  bool? showLocationOnboarding,
  List<Country>? countries,
  List<Region>? availableRegions,
  Country? selectedCountry,
  Region? selectedRegion,
  String? cityInput,
  bool clearSelectedRegion = false,
}) {
  return HomeState(
    isDarkMode: isDarkMode ?? this.isDarkMode,
    showLocationOnboarding: showLocationOnboarding ?? this.showLocationOnboarding,
    countries: countries ?? this.countries,
    availableRegions: availableRegions ?? this.availableRegions,
    selectedCountry: selectedCountry ?? this.selectedCountry,
    selectedRegion: clearSelectedRegion ? null : (selectedRegion ?? this.selectedRegion),
    cityInput: cityInput ?? this.cityInput,
  );
}

  @override
  List<Object?> get props => [
        isDarkMode,
        showLocationOnboarding,
        countries,
        availableRegions,
        selectedCountry,
        selectedRegion,
        cityInput,
      ];
}
