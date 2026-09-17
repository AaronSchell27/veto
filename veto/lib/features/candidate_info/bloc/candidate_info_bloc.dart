// lib/features/candidate_info/bloc/candidate_info_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_database_client/supabase_database_client.dart';
import 'package:veto/features/candidate_info/bloc/candidate_info_event.dart';
import 'package:veto/features/candidate_info/bloc/candidate_info_state.dart';
import 'package:veto/features/candidates/data/models/candidate_model.dart';
import 'package:veto/features/candidates/data/repositories/candidate_repository.dart';

class CandidateInfoBloc extends Bloc<CandidateInfoEvent, CandidateInfoState> {
  CandidateInfoBloc({
    required CandidateRepository candidateRepository,
    required SupabaseDatabaseClient supabaseDatabaseClient,
    String candidateBucketName = 'candidate-photos',
  })  : _candidateRepository = candidateRepository,
        _supabaseDatabaseClient = supabaseDatabaseClient,
        _candidateBucketName = candidateBucketName,
        super(const CandidateInfoState()) {
    on<CandidateInfoRequested>(_onCandidateInfoRequested);
  }

  final CandidateRepository _candidateRepository;
  final SupabaseDatabaseClient _supabaseDatabaseClient;
  final String _candidateBucketName;

  Future<void> _onCandidateInfoRequested(
    CandidateInfoRequested event,
    Emitter<CandidateInfoState> emit,
  ) async {
    emit(state.copyWith(status: CandidateInfoStatus.loading));
    try {
      final rawCandidate =
          await _candidateRepository.getCandidateById(event.candidateId);

      var candidate = rawCandidate;
      final rawPath = rawCandidate.photoUrl;
      if (rawPath != null && rawPath.trim().isNotEmpty) {
        final cleanPath = rawPath.trim();
        if (!cleanPath.startsWith('http://') && !cleanPath.startsWith('https://')) {
          final fullUrl = _supabaseDatabaseClient.getPublicStorageUrl(
            bucketName: _candidateBucketName,
            path: cleanPath,
          );
          candidate = rawCandidate.copyWithPhotoUrl(fullUrl);
        }
      }

      final stancesFuture =
          _candidateRepository.getStancesForCandidate(event.candidateId);
      final positionsFuture =
          _candidateRepository.getPositionsForCandidate(event.candidateId);
      final donorsFuture =
          _candidateRepository.getDonorsForCandidate(event.candidateId);

      final results = await Future.wait([
        stancesFuture,
        positionsFuture,
        donorsFuture,
      ]);

      emit(
        state.copyWith(
          status: CandidateInfoStatus.success,
          candidate: candidate,
          stances: results[0] as List<CandidateStance>,
          positions: results[1] as List<CandidatePosition>,
          donors: results[2] as List<CandidateDonor>,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: CandidateInfoStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
