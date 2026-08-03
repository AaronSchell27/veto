// lib/features/home/bloc/home_state.dart

import 'package:equatable/equatable.dart';
import 'package:veto/features/candidates/data/models/candidate_model.dart';
import 'package:veto/features/home/models/location_models.dart';

enum HomeStatus { initial, loading, success, failure }

final class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.errorMessage,
    this.isDarkMode = false,
    this.showLocationOnboarding = true,
    this.countries = const [],
    this.availableRegions = const [],
    this.selectedCountry,
    this.selectedRegion,
    this.cityInput = '',
    this.candidates = const [],
  });

  final HomeStatus status;
  final String? errorMessage;
  final bool isDarkMode;
  final bool showLocationOnboarding;
  
  final List<Country> countries;
  final List<Region> availableRegions;
  
  final Country? selectedCountry;
  final Region? selectedRegion;
  final String cityInput;

  final List<Candidate> candidates;

  bool get isLocationFormValid => 
      selectedCountry != null && selectedRegion != null && cityInput.trim().isNotEmpty;

  /// Returns true if the selected country is US/USA or matches 'US'.
  bool get isUSLocation {
    if (selectedCountry == null) return false;
    final countryIdentifier = selectedCountry!.name.trim().toUpperCase();
    final countryId = selectedCountry!.id.trim().toUpperCase();
    return countryIdentifier == 'US' ||
        countryIdentifier == 'UNITED STATES' ||
        countryIdentifier == 'USA' ||
        countryId == 'US' ||
        countryId == 'USA';
  }

  HomeState copyWith({
    HomeStatus? status,
    String? errorMessage,
    bool? isDarkMode,
    bool? showLocationOnboarding,
    List<Country>? countries,
    List<Region>? availableRegions,
    Country? selectedCountry,
    Region? selectedRegion,
    String? cityInput,
    List<Candidate>? candidates,
    bool clearSelectedRegion = false,
    bool clearErrorMessage = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      isDarkMode: isDarkMode ?? this.isDarkMode,
      showLocationOnboarding: showLocationOnboarding ?? this.showLocationOnboarding,
      countries: countries ?? this.countries,
      availableRegions: availableRegions ?? this.availableRegions,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedRegion: clearSelectedRegion ? null : (selectedRegion ?? this.selectedRegion),
      cityInput: cityInput ?? this.cityInput,
      candidates: candidates ?? this.candidates,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        isDarkMode,
        showLocationOnboarding,
        countries,
        availableRegions,
        selectedCountry,
        selectedRegion,
        cityInput,
        candidates,
      ];
}
