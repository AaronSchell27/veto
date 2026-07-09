// lib/features/home/bloc/home_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:location_repository/location_repository.dart';
import 'package:veto/features/home/bloc/home_event.dart';
import 'package:veto/features/home/bloc/home_state.dart';
import 'package:veto/features/home/models/location_models.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required LocationRepository locationRepository,
  })  : _locationRepository = locationRepository,
        super(const HomeState()) {
    on<HomeCountriesRequested>(_onCountriesRequested);
    on<HomeCountryChanged>(_onCountryChanged);
    on<HomeRegionChanged>(_onRegionChanged);
    on<HomeCityInputChanged>(_onCityInputChanged);
    on<HomeLocationSubmitted>(_onLocationSubmitted);
    
    // Registers our new dismiss handler so the universal panel works!
    on<HomeErrorDismissed>(_onErrorDismissed);
  }

  final LocationRepository _locationRepository;

  Future<void> _onCountriesRequested(
    HomeCountriesRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final repoCountries = await _locationRepository.getCountries();
      final uiCountries = repoCountries.map((c) => Country(id: c.id, name: c.name)).toList();
      
      emit(state.copyWith(
        status: HomeStatus.success,
        countries: uiCountries,
      ));
    } on Exception catch (error) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onCountryChanged(
    HomeCountryChanged event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedCountry: event.country,
        clearSelectedRegion: true,
        availableRegions: const [],
        status: HomeStatus.loading,
      ),
    );

    try {
      final repoRegions = await _locationRepository.getRegionsByCountry(event.country.id);
      final uiRegions = repoRegions.map((r) => Region(id: r.id, name: r.name, countryId: r.countryId)).toList();
      
      emit(state.copyWith(
        status: HomeStatus.success,
        availableRegions: uiRegions,
      ));
    } on Exception catch (error) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  void _onRegionChanged(HomeRegionChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedRegion: event.region));
  }

  void _onCityInputChanged(HomeCityInputChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(cityInput: event.cityInput));
  }

  Future<void> _onLocationSubmitted(
    HomeLocationSubmitted event,
    Emitter<HomeState> emit,
  ) async {
    if (!state.isLocationFormValid) return;
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      await _locationRepository.saveUserLocation(
        countryId: state.selectedCountry!.id,
        regionId: state.selectedRegion!.id,
        cityName: state.cityInput,
      );
      
      emit(state.copyWith(
        status: HomeStatus.success,
        showLocationOnboarding: false,
      ));
    } on Exception catch (error) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  void _onErrorDismissed(HomeErrorDismissed event, Emitter<HomeState> emit) {
    emit(state.copyWith(
      status: HomeStatus.success,
      clearErrorMessage: true,
    ));
  }
}
