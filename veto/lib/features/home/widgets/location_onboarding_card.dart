import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veto/features/home/bloc/home_bloc.dart';
import 'package:veto/features/home/bloc/home_event.dart';
import 'package:veto/features/home/bloc/home_state.dart';
import 'package:veto/features/home/models/location_models.dart';

/// {@template location_onboarding_card}
/// Card widget allowing users to configure their location on the home screen.
/// {@endtemplate}
class LocationOnboardingCard extends StatelessWidget {
  /// {@macro location_onboarding_card}
  const LocationOnboardingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) => previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              action: SnackBarAction(
                label: 'Dismiss',
                onPressed: () {
                  context.read<HomeBloc>().add(const HomeErrorDismissed());
                },
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (!state.showLocationOnboarding) return const SizedBox.shrink();

        final isLoading = state.status == HomeStatus.loading;

        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Set Your Location',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Help us customize your curated updates feed.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Country>(
                  key: ValueKey('country_dropdown_${state.countries.length}'),
                  initialValue: state.selectedCountry,
                  hint: const Text('Select Country'),
                  items: state.countries.map((c) {
                    return DropdownMenuItem(value: c, child: Text(c.name));
                  }).toList(),
                  onChanged: isLoading
                      ? null
                      : (country) {
                          if (country != null) {
                            context.read<HomeBloc>().add(HomeCountryChanged(country));
                          }
                        },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<Region>(
                  key: ValueKey('region_dropdown_${state.availableRegions.length}'),
                  initialValue: state.selectedRegion,
                  hint: const Text('Select State / Region'),
                  items: state.availableRegions.map((r) {
                    return DropdownMenuItem(value: r, child: Text(r.name));
                  }).toList(),
                  onChanged: (state.selectedCountry == null || isLoading)
                      ? null
                      : (region) {
                          if (region != null) {
                            context.read<HomeBloc>().add(HomeRegionChanged(region));
                          }
                        },
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'City',
                    hintText: 'Enter your city name',
                  ),
                  enabled: state.selectedRegion != null && !isLoading,
                  onChanged: (city) {
                    context.read<HomeBloc>().add(HomeCityInputChanged(city));
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (state.isLocationFormValid && !isLoading)
                        ? () => context.read<HomeBloc>().add(const HomeLocationSubmitted())
                        : null,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Confirm Location'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
