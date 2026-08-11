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
          candidate_id,
          issue_id,
          agree,
          statement,
          source_url,
          issues!candidate_stances_issue_id_fkey (
            id,
            name,
            description,
            category
          )
        ''')
        .eq('candidate_id', candidateId);

    final dataList = response as List<dynamic>;

    return dataList
        .map((json) => CandidateStance.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<CandidatePosition>> getPositionsForCandidate(int candidateId) async {
    final response = await _supabase
        .from('candidate_positions')
        .select()
        .eq('candidate_id', candidateId)
        .order('start_date', ascending: false);

    final dataList = response as List<dynamic>;

    return dataList
        .map((json) => CandidatePosition.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
