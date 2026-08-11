// lib/features/candidate_info/bloc/candidate_info_state.dart

import 'package:equatable/equatable.dart';
import 'package:veto/features/candidates/data/models/candidate_model.dart';

enum CandidateInfoStatus { initial, loading, success, failure }

class CandidateInfoState extends Equatable {
  const CandidateInfoState({
    this.status = CandidateInfoStatus.initial,
    this.candidate,
    this.stances = const [],
    this.positions = const [],
    this.errorMessage,
  });

  final CandidateInfoStatus status;
  final Candidate? candidate;
  final List<CandidateStance> stances;
  final List<CandidatePosition> positions;
  final String? errorMessage;

  CandidateInfoState copyWith({
    CandidateInfoStatus? status,
    Candidate? candidate,
    List<CandidateStance>? stances,
    List<CandidatePosition>? positions,
    String? errorMessage,
  }) {
    return CandidateInfoState(
      status: status ?? this.status,
      candidate: candidate ?? this.candidate,
      stances: stances ?? this.stances,
      positions: positions ?? this.positions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, candidate, stances, positions, errorMessage];
}
