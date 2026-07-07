// packages/supabase_database_client/lib/src/supabase_database_client.dart

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
      // Fallback to anonKey to match the cache expectation of version 2.12.4
      anonKey: anonKey, 
    );
    return SupabaseDatabaseClient(supabaseClient: supabase.client);
  }

  bool get isAuthenticated => _supabaseClient.auth.currentSession != null;

  User? get currentUser => _supabaseClient.auth.currentUser;
}
