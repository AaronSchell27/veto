import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veto/features/home/bloc/home_bloc.dart';
import 'package:veto/features/home/bloc/home_event.dart';
import 'package:veto/features/home/bloc/home_state.dart';
import 'package:veto/features/home/models/location_models.dart';

class LocationOnboardingCard extends StatelessWidget {
  const LocationOnboardingCard({super.key});

  // Mocked localized lists — in a full VGV app, these are fetched via a repository
  static const _countries = [Country(id: 'US', name: 'United States')];
  static const _regions = [
    Region(id: 'AZ', countryId: 'US', name: 'Arizona'),
    Region(id: 'CA', countryId: 'US', name: 'California'),
    Region(id: 'NY', countryId: 'US', name: 'New York'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (!state.showLocationOnboarding) return const SizedBox.shrink();

        // Filter regions matching the selected country
        final availableRegions = _regions
            .where((r) => r.countryId == state.selectedCountry?.id)
            .toList();

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
                  initialValue: state.selectedCountry,
                  hint: const Text('Select Country'),
                  items: _countries.map((c) {
                    return DropdownMenuItem(value: c, child: Text(c.name));
                  }).toList(),
                  onChanged: (country) {
                    if (country != null) {
                      context.read<HomeBloc>().add(LocationCountryChanged(country));
                    }
                  },
                ),
                const SizedBox(height: 12),

                // Region Selector Dropdown (Enabled only when country is selected)
                DropdownButtonFormField<Region>(
                  initialValue: state.selectedRegion,
                  hint: const Text('Select State / Region'),
                  items: availableRegions.map((r) {
                    return DropdownMenuItem(value: r, child: Text(r.name));
                  }).toList(),
                  onChanged: state.selectedCountry == null
                      ? null
                      : (region) {
                          if (region != null) {
                            context.read<HomeBloc>().add(LocationRegionChanged(region));
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
                    context.read<HomeBloc>().add(LocationCityChanged(city));
                  },
                ),
                const SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.isLocationFormValid
                        ? () => context.read<HomeBloc>().add(const LocationFormSubmitted())
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
