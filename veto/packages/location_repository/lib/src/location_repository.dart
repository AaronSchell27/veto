import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_database_client/supabase_database_client.dart';

/// Clean domain model representing a Country from the database.
class RepoCountry {
  /// {@macro repo_country}
  const RepoCountry({required this.id, required this.name});

  /// Unique identifier for the country.
  final String id;

  /// Display name of the country.
  final String name;
}

/// Clean domain model representing a Region tied to a Country.
class RepoRegion {
  /// {@macro repo_region}
  const RepoRegion({
    required this.id,
    required this.name,
    required this.countryId,
  });

  /// Unique identifier for the region.
  final String id;

  /// Display name of the region.
  final String name;

  /// Country identifier this region belongs to.
  final String countryId;
}

/// {@template location_repository}
/// Repository responsible for handling location lookups and local/remote persistence.
/// {@endtemplate}
class LocationRepository {
  /// {@macro location_repository}
  const LocationRepository({
    required SupabaseDatabaseClient databaseClient,
    SharedPreferences? plugin,
  })  : _databaseClient = databaseClient,
        _plugin = plugin;

  final SupabaseDatabaseClient _databaseClient;
  final SharedPreferences? _plugin;

  static const _countryKey = 'local_user_country_id';
  static const _regionKey = 'local_user_region_id';
  static const _cityKey = 'local_user_city_name';

  /// Helper to lazily acquire SharedPreferences instance if not injected.
  Future<SharedPreferences> get _prefs async =>
      _plugin ?? await SharedPreferences.getInstance();

  /// Fetches all available countries ordered alphabetically by name.
  Future<List<RepoCountry>> getCountries() async {
    try {
      developer.log('=== [DEBUG] LocationRepository.getCountries() CALLED ===');

      final List<dynamic> response = await _databaseClient.client
          .from('countries')
          .select('id, name')
          .order('name', ascending: true);

      developer.log('=== [DEBUG] Supabase Raw Response: $response ===');

      return response
          .map(
            (dynamic json) => RepoCountry(
              id: (json as Map<String, dynamic>)['id'] as String,
              name: json['name'] as String,
            ),
          )
          .toList();
    } catch (e, stack) {
      developer.log('=== [DEBUG] Supabase getCountries FAILED ===');
      developer.log('Error: $e');
      developer.log('Stacktrace: $stack');
      rethrow;
    }
  }

  /// Fetches all regions belonging to a specific country ID.
  Future<List<RepoRegion>> getRegionsByCountry(String countryId) async {
    final List<dynamic> response = await _databaseClient.client
        .from('regions')
        .select('id, name, country_id')
        .eq('country_id', countryId)
        .order('name', ascending: true);

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

  /// Saves the user's location setup locally.
  /// 
  /// Optionally passes [isLoggedIn] to trigger Supabase persistence when
  /// authentication is fully integrated.
  Future<void> saveUserLocation({
    required String countryId,
    required String regionId,
    required String cityName,
    bool isLoggedIn = false,
  }) async {
    final prefs = await _prefs;

    // Always store location preferences locally
    await prefs.setString(_countryKey, countryId);
    await prefs.setString(_regionKey, regionId);
    await prefs.setString(_cityKey, cityName);

    developer.log('=== [DEBUG] Location saved locally: $cityName ($regionId, $countryId) ===');

    // Sync remotely only when a valid authenticated user exists
    if (isLoggedIn) {
      // TODO(auth): Re-enable Supabase sync once login flow is completed.
      // final user = _databaseClient.client.auth.currentUser;
      // if (user != null) {
      //   await _databaseClient.client.from('accounts').upsert({
      //     'id': user.id,
      //     'country': countryId,
      //     'region': regionId,
      //     'city': cityName,
      //   });
      // }
    }
  }

  /// Reads the saved local location details if present.
  Future<Map<String, String>?> getSavedLocation() async {
    final prefs = await _prefs;
    final country = prefs.getString(_countryKey);
    final region = prefs.getString(_regionKey);
    final city = prefs.getString(_cityKey);

    if (country == null || region == null || city == null) {
      return null;
    }

    return {
      'countryId': country,
      'regionId': region,
      'cityName': city,
    };
  }
}
