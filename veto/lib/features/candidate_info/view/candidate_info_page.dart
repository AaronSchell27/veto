// lib/features/candidate_info/view/candidate_info_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veto/features/candidate_info/bloc/candidate_info_bloc.dart';
import 'package:veto/features/candidate_info/bloc/candidate_info_event.dart';
import 'package:veto/features/candidate_info/view/candidate_info_view.dart';
import 'package:veto/features/candidates/data/repositories/candidate_repository.dart';

class CandidateInfoPage extends StatelessWidget {
  const CandidateInfoPage({
    required this.candidateId,
    super.key,
  });

  final int candidateId;

  static Route<void> route({
    required int candidateId,
    required CandidateRepository candidateRepository,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => RepositoryProvider.value(
        value: candidateRepository,
        child: CandidateInfoPage(candidateId: candidateId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CandidateInfoBloc(
        candidateRepository: context.read<CandidateRepository>(),
      )..add(CandidateInfoRequested(candidateId)),
      child: const CandidateInfoView(),
    );
  }
}
