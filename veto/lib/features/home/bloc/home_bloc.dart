// lib/features/home/bloc/home_bloc.dart

import 'dart:developer' as developer;
import 'package:bloc/bloc.dart';
import 'package:location_repository/location_repository.dart';
import 'package:supabase_database_client/supabase_database_client.dart';
import 'package:veto/features/candidates/data/models/candidate_model.dart';
import 'package:veto/features/home/bloc/home_event.dart';
import 'package:veto/features/home/bloc/home_state.dart';
import 'package:veto/features/home/models/location_models.dart';
import 'package:veto/features/settings/bloc/settings_bloc.dart';
import 'package:veto/features/settings/bloc/settings_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required LocationRepository locationRepository,
    required SettingsBloc settingsBloc,
    required SupabaseDatabaseClient supabaseDatabaseClient,
    String candidateBucketName = 'candidate-pictures',
  })  : _locationRepository = locationRepository,
        _settingsBloc = settingsBloc,
        _supabaseDatabaseClient = supabaseDatabaseClient,
        _candidateBucketName = candidateBucketName,
        super(const HomeState()) {
    on<HomeCountriesRequested>(_onCountriesRequested);
    on<HomeCountryChanged>(_onCountryChanged);
    on<HomeRegionChanged>(_onRegionChanged);
    on<HomeCityInputChanged>(_onCityInputChanged);
    on<HomeLocationSubmitted>(_onLocationSubmitted);
    on<HomeElectionTierChanged>(_onElectionTierChanged);
    on<HomeCandidatesRequested>(_onCandidatesRequested);
    on<HomeErrorDismissed>(_onErrorDismissed);
    on<HomeLocationReset>(_onLocationReset);
  }

  final LocationRepository _locationRepository;
  final SettingsBloc _settingsBloc;
  final SupabaseDatabaseClient _supabaseDatabaseClient;
  final String _candidateBucketName;

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
        candidates: const [],
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

      _settingsBloc.add(
        UpdateLocationEvent(
          countryId: state.selectedCountry!.id,
          regionId: state.selectedRegion!.id,
          cityName: state.cityInput,
        ),
      );

      emit(state.copyWith(
        status: HomeStatus.success,
        showLocationOnboarding: false,
        hasSubmittedLocation: true,
        clearSelectedElectionTier: true,
      ));
    } on Exception catch (error) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onElectionTierChanged(
    HomeElectionTierChanged event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(selectedElectionTier: event.tier));
    if (state.hasSubmittedLocation) {
      add(const HomeCandidatesRequested());
    } else {
      emit(state.copyWith(candidates: const []));
    }
  }

  Future<void> _onCandidatesRequested(
    HomeCandidatesRequested event,
    Emitter<HomeState> emit,
  ) async {
    final selectedTier = state.selectedElectionTier;
    final selectedCountry = state.selectedCountry;

    if (selectedTier == null || selectedCountry == null) {
      return;
    }

    emit(state.copyWith(isFetchingCandidates: true));
    try {
      final rawCandidates =
          await _supabaseDatabaseClient.getUsNationalCandidates();

      final allCandidates = rawCandidates.map((json) {
        final rawPath = json['picture_url'] as String? ??
            json['photo_url'] as String? ??
            json['avatar_url'] as String? ??
            json['image_url'] as String?;

        String? fullPhotoUrl;

        if (rawPath != null && rawPath.trim().isNotEmpty) {
          final cleanPath = rawPath.trim();
          if (cleanPath.startsWith('http://') || cleanPath.startsWith('https://')) {
            fullPhotoUrl = cleanPath;
          } else {
            fullPhotoUrl = _supabaseDatabaseClient.getPublicStorageUrl(
              bucketName: _candidateBucketName,
              path: cleanPath,
            );
          }
        }

        final candidate = Candidate.fromJson(json);
        final resultCandidate = fullPhotoUrl != null ? candidate.copyWithPhotoUrl(fullPhotoUrl) : candidate;

        developer.log(
          'Candidate: ${resultCandidate.fullName} | Raw Path: $rawPath | Resolved URL: ${resultCandidate.photoUrl}',
          name: 'HomeBloc',
        );

        return resultCandidate;
      }).toList();

      final userCountry = selectedCountry.id.trim().toUpperCase();
      final userRegion = state.selectedRegion?.id.trim().toUpperCase();
      final userCity = state.cityInput.trim().toLowerCase();

      final filteredCandidates = allCandidates.where((candidate) {
        final cCountry = candidate.countryId.trim().toUpperCase();
        final cState = candidate.stateId?.trim().toUpperCase();
        final cCity = candidate.city?.trim().toLowerCase();

        if (cCountry != userCountry) return false;
        if (candidate.inferredTier != selectedTier) return false;

        switch (selectedTier) {
          case ElectionTier.local:
            final matchesState = userRegion == null ||
                userRegion.isEmpty ||
                cState == null ||
                cState.isEmpty ||
                cState == userRegion;
            final matchesCity = userCity.isEmpty ||
                cCity == null ||
                cCity.isEmpty ||
                cCity == userCity;
            return matchesState && matchesCity;

          case ElectionTier.state:
            return userRegion == null ||
                userRegion.isEmpty ||
                cState == null ||
                cState.isEmpty ||
                cState == userRegion;

          case ElectionTier.federal:
            if (cState != null && cState.isNotEmpty && userRegion != null && userRegion.isNotEmpty) {
              return cState == userRegion;
            }
            return true;
        }
      }).toList();

      emit(state.copyWith(
        candidates: filteredCandidates,
        isFetchingCandidates: false,
      ));
    } on Exception catch (error) {
      emit(state.copyWith(
        status: HomeStatus.failure,
        errorMessage: error.toString(),
        isFetchingCandidates: false,
      ));
    }
  }

  void _onErrorDismissed(HomeErrorDismissed event, Emitter<HomeState> emit) {
    emit(state.copyWith(
      status: HomeStatus.success,
      clearErrorMessage: true,
    ));
  }

  void _onLocationReset(HomeLocationReset event, Emitter<HomeState> emit) {
    emit(state.copyWith(
      showLocationOnboarding: true,
      hasSubmittedLocation: false,
      status: HomeStatus.initial,
      candidates: const [],
      isFetchingCandidates: false,
      clearSelectedElectionTier: true,
    ));
  }
}
