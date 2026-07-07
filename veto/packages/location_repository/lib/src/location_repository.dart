// packages/location_repository/lib/src/location_repository.dart

import 'package:supabase_database_client/supabase_database_client.dart';

/// Clean domain model representing a Country from the database.
class RepoCountry {
  const RepoCountry({required this.id, required this.name});
  final String id;
  final String name;
}

/// Clean domain model representing a Region tied to a Country.
class RepoRegion {
  const RepoRegion({
    required this.id, 
    required this.name, 
    required this.countryId,
  });
  final String id;
  final String name;
  final String countryId;
}

/// Repository responsible for handling location lookups and account initialization.
class LocationRepository {
  const LocationRepository({
    required SupabaseDatabaseClient databaseClient,
  }) : _databaseClient = databaseClient;

  final SupabaseDatabaseClient _databaseClient;

  /// Fetches all available countries ordered alphabetically by name.
  Future<List<RepoCountry>> getCountries() async {
    final List<dynamic> response = await _databaseClient.client
        .from('countries')
        .select('id, name')
        .order('name');

    return response
        .map(
          (dynamic json) => RepoCountry(
            id: (json as Map<String, dynamic>)['id'] as String,
            name: json['name'] as String,
          ),
        )
        .toList();
  }

  /// Fetches all regions belonging to a specific country ID.
  Future<List<RepoRegion>> getRegionsByCountry(String countryId) async {
    final List<dynamic> response = await _databaseClient.client
        .from('regions')
        .select('id, name, country_id')
        .eq('country_id', countryId)
        .order('name');

    return response
        .map(
          (dynamic json) => RepoRegion(
            id: (json as Map<String, dynamic>)['id'] as String,
            name: json['name'] as String,
            countryId: json['country_id'] as String,
          ),
        )
        .toList();
  }

  /// Saves the user's location setup directly into your accounts table.
  /// Generates a placeholder guest user_name to bypass auth layers for now.
  Future<void> saveUserLocation({
    required String countryId,
    required String regionId,
    required String cityName,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final uniqueGuestId = timestamp.substring(timestamp.length - 5);

    await _databaseClient.client.from('accounts').insert({
      'user_name': 'Guest_$uniqueGuestId',
      'country': countryId,
      'region': regionId,
      'city': cityName,
    });
  }
}
