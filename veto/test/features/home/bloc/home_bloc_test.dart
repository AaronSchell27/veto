// test/features/home/bloc/home_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location_repository/location_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:veto/features/home/bloc/home_bloc.dart';
import 'package:veto/features/home/bloc/home_event.dart';
import 'package:veto/features/home/bloc/home_state.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  late LocationRepository locationRepository;

  setUp(() {
    locationRepository = MockLocationRepository();
  });

  group('HomeBloc - Error Universal Panel Tests', () {
    blocTest<HomeBloc, HomeState>(
      'emits failure status and error message when fetching countries fails',
      setUp: () {
        when(() => locationRepository.getCountries())
            .thenThrow(Exception('Supabase connection timeout.'));
      },
      build: () => HomeBloc(locationRepository: locationRepository),
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
      build: () => HomeBloc(locationRepository: locationRepository),
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
  });
}
