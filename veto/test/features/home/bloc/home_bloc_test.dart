// test/features/home/bloc/home_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location_repository/location_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:veto/features/home/bloc/home_bloc.dart';
import 'package:veto/features/home/bloc/home_event.dart';
import 'package:veto/features/home/bloc/home_state.dart';
import 'package:veto/features/home/models/location_models.dart';
import 'package:veto/features/settings/bloc/settings_bloc.dart'; // Import SettingsBloc
import 'package:veto/features/settings/bloc/settings_event.dart'; // Import SettingsEvent
import 'package:veto/features/settings/bloc/settings_state.dart'; // Import SettingsState

class MockLocationRepository extends Mock implements LocationRepository {}
class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState> implements SettingsBloc {}

void main() {
  late LocationRepository locationRepository;
  late SettingsBloc settingsBloc; // <-- Declare late settingsBloc variable

  setUpAll(() {
    // Register fallback values if Mocktail demands it for Custom Events
    registerFallbackValue(const UpdateLocationEvent(
      countryId: 'US',
      regionId: 'CA',
      cityName: 'San Francisco',
    ));
  });

  setUp(() {
    locationRepository = MockLocationRepository();
    settingsBloc = MockSettingsBloc(); // <-- Initialize your Mock
    // Stub a default state so HomeBloc can read it on startup
    when(() => settingsBloc.state).thenReturn(const SettingsState());
  });

  group('HomeBloc - Error Universal Panel Tests', () {
    blocTest<HomeBloc, HomeState>(
      'emits failure status and error message when fetching countries fails',
      setUp: () {
        when(() => locationRepository.getCountries())
            .thenThrow(Exception('Supabase connection timeout.'));
      },
      build: () => HomeBloc(
        locationRepository: locationRepository,
        settingsBloc: settingsBloc, // <-- Pass mocked dependency
      ),
      act: (bloc) => bloc.add(const HomeCountriesRequested()),
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        const HomeState(
          status: HomeStatus.failure,
          errorMessage: 'Exception: Supabase connection timeout.',
        ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'clears error message and sets status to success when error is dismissed',
      build: () => HomeBloc(
        locationRepository: locationRepository,
        settingsBloc: settingsBloc, // <-- Pass mocked dependency
      ),
      seed: () => const HomeState(
        status: HomeStatus.failure,
        errorMessage: 'Existing Supabase Error',
      ),
      act: (bloc) => bloc.add(const HomeErrorDismissed()),
      expect: () => [
        const HomeState(
          status: HomeStatus.success,
        ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits success status and calls settingsBloc.add when location is submitted',
      setUp: () {
        // Stub the repository to succeed
        when(() => locationRepository.saveUserLocation(
              countryId: any(named: 'countryId'),
              regionId: any(named: 'regionId'),
              cityName: any(named: 'cityName'),
            )).thenAnswer((_) async => Future.value());
      },
      build: () => HomeBloc(
        locationRepository: locationRepository,
        settingsBloc: settingsBloc,
      ),
      seed: () => const HomeState(
        selectedCountry: Country(id: 'US', name: 'USA'),
        selectedRegion: Region(id: 'CA', name: 'California', countryId: 'US'),
        cityInput: 'San Francisco',
      ),
      act: (bloc) => bloc.add(const HomeLocationSubmitted()),
      expect: () => [
        const HomeState(
          selectedCountry: Country(id: 'US', name: 'USA'),
          selectedRegion: Region(id: 'CA', name: 'California', countryId: 'US'),
          cityInput: 'San Francisco',
          status: HomeStatus.loading,
        ),
        const HomeState(
          selectedCountry: Country(id: 'US', name: 'USA'),
          selectedRegion: Region(id: 'CA', name: 'California', countryId: 'US'),
          cityInput: 'San Francisco',
          status: HomeStatus.success,
          showLocationOnboarding: false,
        ),
      ],
      verify: (_) {
        // This verifies that the SettingsBloc actually received the event!
        verify(() => settingsBloc.add(
              const UpdateLocationEvent(
                countryId: 'US',
                regionId: 'CA',
                cityName: 'San Francisco',
              ),
            )).called(1);
      },
    );
  });
}
