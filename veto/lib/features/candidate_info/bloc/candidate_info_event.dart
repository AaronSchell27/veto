// lib/features/candidate_info/bloc/candidate_info_event.dart

import 'package:equatable/equatable.dart';

abstract class CandidateInfoEvent extends Equatable {
  const CandidateInfoEvent();

  @override
  List<Object?> get props => [];
}

class CandidateInfoRequested extends CandidateInfoEvent {
  const CandidateInfoRequested(this.candidateId);

  final int candidateId; // Ensure this is int, not String

  @override
  List<Object?> get props => [candidateId];
}
