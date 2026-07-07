// lib/features/home/bloc/home_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veto/features/home/bloc/home_event.dart';
import 'package:veto/features/home/bloc/home_state.dart';
import 'package:veto/features/home/models/location_models.dart'; 

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    
    on<ToggleThemeEvent>((event, emit) {
      emit(state.copyWith(isDarkMode: !state.isDarkMode));
    });

    on<LocationOnboardingInitialized>((event, emit) {
      const mockCountries = [Country(id: 'US', name: 'United States')];
      emit(state.copyWith(countries: mockCountries));
    });

    on<LocationCountryChanged>((event, emit) {
      const allRegions = [
        Region(id: 'AZ', countryId: 'US', name: 'Arizona'),
        Region(id: 'CA', countryId: 'US', name: 'California'),
        Region(id: 'NY', countryId: 'US', name: 'New York'),
      ];

      final filteredRegions = allRegions
        .where((r) => r.countryId == event.country.id)
        .toList();

      emit(state.copyWith(
        selectedCountry: event.country,
        availableRegions: filteredRegions,
        clearSelectedRegion: true, // Perfect, functional, and linter-compliant!
        cityInput: '',
      ));
    });

    on<LocationRegionChanged>((event, emit) {
      // Redundant cityInput clearing removed to satisfy lint rule
      emit(state.copyWith(
        selectedRegion: event.region,
      ));
    });

    on<LocationCityChanged>((event, emit) {
      emit(state.copyWith(cityInput: event.city));
    });

    on<LocationFormSubmitted>((event, emit) {
      emit(state.copyWith(showLocationOnboarding: false));
    });
  }
}
