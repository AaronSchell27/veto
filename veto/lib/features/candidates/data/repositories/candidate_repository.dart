// lib/features/candidates/data/repositories/candidate_repository.dart

import 'package:supabase_database_client/supabase_database_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:veto/features/candidates/data/models/candidate_model.dart';

class CandidateRepository {
  CandidateRepository({
    SupabaseDatabaseClient? databaseClient,
    SupabaseClient? supabaseClient,
    String candidateBucketName = 'candidate-photos',
  })  : _databaseClient = databaseClient,
        _supabase = databaseClient?.client ??
            supabaseClient ??
            Supabase.instance.client,
        _candidateBucketName = candidateBucketName;

  final SupabaseDatabaseClient? _databaseClient;
  final SupabaseClient _supabase;
  final String _candidateBucketName;

  Future<Candidate> getCandidateById(int candidateId) async {
    final response = await _supabase
        .from('candidates')
        .select('''
          *,
          candidate_donors(*)
        ''')
        .eq('id', candidateId)
        .single();

    final candidate = Candidate.fromJson(response);

    final rawPath = candidate.photoUrl;
    if (rawPath != null && rawPath.trim().isNotEmpty) {
      final cleanPath = rawPath.trim();
      if (!cleanPath.startsWith('http://') && !cleanPath.startsWith('https://')) {
        if (_databaseClient != null) {
          final fullUrl = _databaseClient.getPublicStorageUrl(
            bucketName: _candidateBucketName,
            path: cleanPath,
          );
          return candidate.copyWithPhotoUrl(fullUrl);
        } else {
          final publicUrl = _supabase.storage
              .from(_candidateBucketName)
              .getPublicUrl(cleanPath);
          return candidate.copyWithPhotoUrl(publicUrl);
        }
      }
    }

    return candidate;
  }

  Future<List<CandidateDonor>> getDonorsForCandidate(int candidateId) async {
    final response = await _supabase
        .from('candidate_donors')
        .select()
        .eq('candidate_id', candidateId)
        .order('amount', ascending: false);

    final dataList = response as List<dynamic>;

    return dataList
        .map((json) => CandidateDonor.fromJson(json as Map<String, dynamic>))
        .toList();
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
