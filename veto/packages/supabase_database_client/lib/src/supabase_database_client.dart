// packages/supabase_database_client/lib/src/supabase_database_client.dart

// ignore_for_file: document_ignores, deprecated_member_use

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDatabaseClient {
  const SupabaseDatabaseClient({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  SupabaseClient get client => _supabaseClient;

  static Future<SupabaseDatabaseClient> initialize({
    required String url,
    required String anonKey,
  }) async {
    final supabase = await Supabase.initialize(
      url: url,
      anonKey: anonKey, 
    );
    return SupabaseDatabaseClient(supabaseClient: supabase.client);
  }

  bool get isAuthenticated => _supabaseClient.auth.currentSession != null;

  User? get currentUser => _supabaseClient.auth.currentUser;

  /// Fetches all candidates from the `candidates` table.
  Future<List<Map<String, dynamic>>> getUsNationalCandidates() async {
    final response = await _supabaseClient
        .from('candidates')
        .select();

    return List<Map<String, dynamic>>.from(response);
  }

  /// Generates the public image URL for a file in a Supabase Storage bucket.
  String getPublicStorageUrl({
    required String bucketName,
    required String path,
  }) {
    return _supabaseClient.storage.from(bucketName).getPublicUrl(path);
  }
}
