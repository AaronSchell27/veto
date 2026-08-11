// lib/features/candidate_info/view/candidate_info_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veto/features/candidate_info/bloc/candidate_info_bloc.dart';
import 'package:veto/features/candidate_info/bloc/candidate_info_state.dart';
import 'package:veto/features/candidate_info/widgets/candidate_header_card.dart';
import 'package:veto/features/candidate_info/widgets/stances_card.dart';

class CandidateInfoView extends StatelessWidget {
  const CandidateInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidate Info'),
      ),
      body: BlocBuilder<CandidateInfoBloc, CandidateInfoState>(
        builder: (context, state) {
          switch (state.status) {
            case CandidateInfoStatus.initial:
            case CandidateInfoStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case CandidateInfoStatus.failure:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: theme.colorScheme.error,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load candidate information',
                        style: theme.textTheme.titleMedium,
                      ),
                      if (state.errorMessage != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          state.errorMessage!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              );

            case CandidateInfoStatus.success:
              final candidate = state.candidate;
              if (candidate == null) {
                return const Center(
                  child: Text('Candidate not found'),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CandidateHeaderCard(candidate: candidate),
                    const SizedBox(height: 24),
                    StancesCard(
                      stances: state.stances,
                      positions: state.positions,
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
