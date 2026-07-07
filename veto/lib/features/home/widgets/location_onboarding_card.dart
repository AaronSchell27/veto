import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veto/features/home/bloc/home_bloc.dart';
import 'package:veto/features/home/bloc/home_event.dart';
import 'package:veto/features/home/bloc/home_state.dart';
import 'package:veto/features/home/models/location_models.dart';

class LocationOnboardingCard extends StatelessWidget {
  const LocationOnboardingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (!state.showLocationOnboarding) return const SizedBox.shrink();

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

                // Country Selector Dropdown
                DropdownButtonFormField<Country>(
                  // FIX: Migrated from 'value' to 'initialValue'
                  initialValue: state.selectedCountry,
                  hint: const Text('Select Country'),
                  items: state.countries.map((c) {
                    return DropdownMenuItem(value: c, child: Text(c.name));
                  }).toList(),
                  onChanged: (country) {
                    if (country != null) {
                      context.read<HomeBloc>().add(HomeCountryChanged(country));
                    }
                  },
                ),
                const SizedBox(height: 12),

                // Region Selector Dropdown
                DropdownButtonFormField<Region>(
                  // FIX: Migrated from 'value' to 'initialValue'
                  initialValue: state.selectedRegion,
                  hint: const Text('Select State / Region'),
                  items: state.availableRegions.map((r) {
                    return DropdownMenuItem(value: r, child: Text(r.name));
                  }).toList(),
                  onChanged: state.selectedCountry == null
                      ? null
                      : (region) {
                          if (region != null) {
                            context.read<HomeBloc>().add(HomeRegionChanged(region));
                          }
                        },
                ),
                const SizedBox(height: 12),

                // City Name Input Field
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'City',
                    hintText: 'Enter your city name',
                  ),
                  enabled: state.selectedRegion != null,
                  onChanged: (city) {
                    context.read<HomeBloc>().add(HomeCityInputChanged(city));
                  },
                ),
                const SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.isLocationFormValid
                        ? () => context.read<HomeBloc>().add(const HomeLocationSubmitted())
                        : null,
                    child: const Text('Confirm Location'),
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
