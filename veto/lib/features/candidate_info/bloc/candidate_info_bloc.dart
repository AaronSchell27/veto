// lib/features/candidate_info/bloc/candidate_info_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veto/features/candidate_info/bloc/candidate_info_event.dart';
import 'package:veto/features/candidate_info/bloc/candidate_info_state.dart';
import 'package:veto/features/candidates/data/repositories/candidate_repository.dart';

class CandidateInfoBloc extends Bloc<CandidateInfoEvent, CandidateInfoState> {
  CandidateInfoBloc({required CandidateRepository candidateRepository})
      : _candidateRepository = candidateRepository,
        super(const CandidateInfoState()) {
    on<CandidateInfoRequested>(_onCandidateInfoRequested);
  }

  final CandidateRepository _candidateRepository;

  Future<void> _onCandidateInfoRequested(
    CandidateInfoRequested event,
    Emitter<CandidateInfoState> emit,
  ) async {
    emit(state.copyWith(status: CandidateInfoStatus.loading));
    try {
      final candidate =
          await _candidateRepository.getCandidateById(event.candidateId);
      final stances =
          await _candidateRepository.getStancesForCandidate(event.candidateId);

      emit(
        state.copyWith(
          status: CandidateInfoStatus.success,
          candidate: candidate,
          stances: stances,
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
