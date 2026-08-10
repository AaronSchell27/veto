// lib/features/candidates/data/repositories/candidate_repository.dart

import 'package:supabase_database_client/supabase_database_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:veto/features/candidates/data/models/candidate_model.dart';

class CandidateRepository {
  CandidateRepository({
    SupabaseDatabaseClient? databaseClient,
    SupabaseClient? supabaseClient,
  }) : _supabase = databaseClient?.client ??
            supabaseClient ??
            Supabase.instance.client;

  final SupabaseClient _supabase;

  Future<Candidate> getCandidateById(int candidateId) async {
    final response = await _supabase
        .from('candidates')
        .select()
        .eq('id', candidateId)
        .single();

    return Candidate.fromJson(response);
  }

  Future<List<CandidateStance>> getStancesForCandidate(int candidateId) async {
    final response = await _supabase
        .from('candidate_stances')
        .select('''
          *,
          issues (
            name,
            description
          )
        ''')
        .eq('candidate_id', candidateId);

    return (response as List<dynamic>)
        .map((json) => CandidateStance.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
