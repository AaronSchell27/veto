// lib/features/candidate_info/bloc/candidate_info_state.dart

import 'package:equatable/equatable.dart';
// Replace 'package:your_app/models/candidate.dart' with:
import 'package:veto/features/candidates/data/models/candidate_model.dart';

enum CandidateInfoStatus { initial, loading, success, failure }

class CandidateInfoState extends Equatable {
  const CandidateInfoState({
    this.status = CandidateInfoStatus.initial,
    this.candidate,
    this.stances = const [],
    this.errorMessage,
  });

  final CandidateInfoStatus status;
  final Candidate? candidate;
  final List<CandidateStance> stances;
  final String? errorMessage;

  CandidateInfoState copyWith({
    CandidateInfoStatus? status,
    Candidate? candidate,
    List<CandidateStance>? stances,
    String? errorMessage,
  }) {
    return CandidateInfoState(
      status: status ?? this.status,
      candidate: candidate ?? this.candidate,
      stances: stances ?? this.stances,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, candidate, stances, errorMessage];
}
